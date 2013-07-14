livereloadSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet

mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->
  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks)
  grunt.loadTasks("tasks")

  # Extract browsers list from the command line
  # For example `grunt test --browsers=Chrome,Firefox`
  # Currently available browsers:
  # - Chrome
  # - ChromeCanary
  # - Firefox
  # - Opera
  # - Safari (only Mac)
  # - PhantomJS
  # - IE (only Windows)
  parseBrowsers = (opts = {}) ->
    opts.defaultBrowser or= "PhantomJS"

    browsers = grunt.option("browsers") || opts.defaultBrowser
    browsers = browsers.replace(/[\s\[\]]/, "")
    browsers.split(",")

  # configurable paths
  appConfig =
    app: "app"
    test: "test"
    dist: "../public"
    dev: "dev"

  grunt.initConfig
    appConfig: appConfig
    pkg: grunt.file.readJSON("package.json")

    watch:
      coffee:
        files: ["<%= appConfig.app %>/scripts/**/*.coffee"]
        tasks: ["coffee:dist", "timestamp"]

      coffeeTest:
        files: ["<%= appConfig.test %>/**/*.coffee"]
        tasks: [
          "coffee:test"
          "jasminehtml"
          "timestamp"
        ]

      html:
        files: [
          "<%= appConfig.app %>/**/*.html"
          "!<%= appConfig.dev %>/templates/**/*.html"
        ]
        tasks: ["copy:dev", "timestamp"]

      templates:
        files: ["<%= appConfig.app %>/templates/**/*.html"]
        tasks: ["ngtemplates", "timestamp"]

      css:
        files: ["<%= appConfig.app %>/styles/**/*.less"]
        tasks: ["less", "timestamp"]

      livereload:
        files: ["<%= appConfig.dev %>/**/*"]
        tasks: ["livereload", "timestamp"]

    coffee:
      dist:
        files: [
          expand: true
          cwd: "<%= appConfig.app %>/scripts"
          src: "**/*.coffee"
          dest: "<%= appConfig.dev %>/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "<%= appConfig.test %>"
          src: "**/*.coffee"
          dest: "<%= appConfig.dev %>/test"
          ext: ".js"
        ]

    less:
      dist:
        files:
          "<%= appConfig.dev %>/styles/application.css": "<%= appConfig.app %>/styles/application.less"

    concat:
      dist:
        files:
          "<%= appConfig.dev %>/scripts/scripts.js": [
            "<%= appConfig.dev %>/scripts/**/*.js"
            "<%= appConfig.app %>/scripts/**/*.js"
          ]

    useminPrepare:
      html: [
        "<%= appConfig.dev %>/**/*.html"
        "!<%= appConfig.dev %>/templates/**/*.html"
      ]
      options:
        dest: "<%= appConfig.dist %>"

    usemin:
      html: [
        "<%= appConfig.dist %>/**/*.html"
        "!<%= appConfig.dist %>/templates/**/*.html"
      ]
      css: ["<%= appConfig.dist %>/styles/**/*.css"]
      options:
        dirs: ["<%= appConfig.dist %>"]

    htmlmin:
      dist:
        files: [
          expand: true,
          cwd: "<%= appConfig.app %>",
          src: [
            "**/*.html"
            "!templates/**/*.html"
          ],
          dest: "<%= appConfig.dist %>"
        ]

    copy:
      dev:
        files: [
          expand: true
          dot: true
          cwd: "<%= appConfig.app %>"
          dest: "<%= appConfig.dev %>"
          src: [
            "*.{ico,txt}"
            "**/*.html"
            "!templates/**/*.html"
            "components/**/*"
            "images/**/*.{gif,png,webp}"
            "styles/fonts/*"
          ]
        ]

    coffeelint:
      options:
        max_line_length:
          value: 120
          level: "warn"

      app: ["Gruntfile.coffee", "<%= appConfig.app %>/scripts/**/*.coffee"]
      test: ["<%= appConfig.test %>/**/*.coffee"]

    ngtemplates:
      options:
        base: "<%= appConfig.app %>"
        module:
          name: "mb.templates"
          define: true

      myApp:
        src: [
          "<%= appConfig.app %>/templates/**/*.html"
          "<%= appConfig.app %>/views/**/*.html"
        ]
        dest: "<%= appConfig.dev %>/scripts/templates.js"

    bower:
      install:
        options:
          targetDir: "<%= appConfig.dev %>/components"
          layout: "byComponent"
          cleanTargetDir: true
          install: false

    karma:
      options:
        basePath: "../<%= appConfig.dev %>"
        browsers: parseBrowsers(defaultBrowser: "PhantomJS")
        colors: true
        # test results reporter to use
        # possible values: dots || progress || growl
        reporters: ["dots"]
        # If browser does not capture in given timeout [ms], kill it
        captureTimeout: 5000

      unit:
        configFile: "<%= appConfig.test %>/karma.conf.coffee"
        reporters: ["dots", "coverage"]
        preprocessors:
          "scripts/**/*.js": "coverage"
        coverageReporter:
          type: "text"
          dir: "coverage"

        singleRun: true

      e2e:
        configFile: "<%= appConfig.test %>/karma-e2e.conf.coffee"
        singleRun: true # `false` for debugging

      watch:
        configFile: "<%= appConfig.test %>/karma.conf.coffee"
        reporters: ["dots"]
        singleRun: false
        autoWatch: true

    jasminehtml:
      options:
        dest: "<%= appConfig.dev %>"

    casperjs:
      files: ["<%= appConfig.dev %>/test/casperjs/**/*_scenario.js"]

    clean:
      dev: [
        "<%= appConfig.dev %>/**/*"
        "!<%= appConfig.dev %>/.git*"
      ]
      dist: [
        "<%= appConfig.dist %>/**/*"
        "!<%= appConfig.dist %>/.git*"
      ]

    connect:
      options:
        hostname: "localhost"

      e2e:
        options:
          port: 9001
          middleware: (connect) ->
            [mountFolder(connect, appConfig.dev)]

      livereload:
        options:
          port: 9000
          middleware: (connect) ->
            [
              livereloadSnippet
              mountFolder(connect, appConfig.dev)
            ]

  grunt.renameTask "regarde", "watch"

  grunt.registerTask "timestamp", -> grunt.log.subhead "--- timestamp: #{new Date()}"

  grunt.registerTask "build:dev", [
    "clean"
    "bower"
    "coffeelint"
    "coffee"
    "less"
    "copy:dev"
    "ngtemplates"
    "jasminehtml"
  ]

  grunt.registerTask "server", [
    "build:dev"

    "livereload-start"
    "connect:livereload"
    "watch"
  ]

  grunt.registerTask "test", [
    "build:dev"
    "karma:unit"
  ]

  grunt.registerTask "test:e2e", [
    "build:dev"
    "connect:e2e"
    "karma:e2e"
  ]

  grunt.registerTask "test:casperjs", [
    "build:dev"
    "connect:e2e"
    "casperjs"
  ]

  # run all tests on the ci server
  grunt.registerTask "test:ci", [
    "build:dev"

    # run unit tests
    "karma:unit"

    # run e2e tests
    "connect:e2e"
    "karma:e2e"

    # run casperjs integration tests
    "casperjs"
  ]

  grunt.registerTask "build:dist", [
    "test:ci"
    "useminPrepare"
    "htmlmin"
    "concat"
    "usemin"
    "uglify"
    "cssmin"
  ]

  grunt.registerTask "test:watch", [
    "coffee:test"
    "karma:watch"
  ]

  grunt.renameTask "build:dist", "build"

  # Used during heroku deployment
  grunt.registerTask "heroku:production", ["build"]

  grunt.registerTask "default", ["test"]
