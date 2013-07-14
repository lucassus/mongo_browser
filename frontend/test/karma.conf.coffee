# Karma configuration
module.exports = (config) ->
  config.set

    frameworks: [
      "jasmine"
    ]

    # list of files / patterns to load in the browser
    files: [
      "components/jquery/jquery.js"
      "components/underscore/underscore.js"
      "components/angular/angular.js"
      "components/angular-resource/angular-resource.js"
      "components/angular-sanitize/angular-sanitize.js"
      "components/angular-mocks/angular-mocks.js"

      "scripts/templates.js"
      "scripts/modules/**/*.js"
      "scripts/directives.js"
      "scripts/filters.js"
      "scripts/resources.js"
      "scripts/services.js"

      "scripts/application.js"
      "scripts/controllers/**/*.js"

      "test/unit/helpers/**/*.js"
      "test/unit/**/*_spec.js"
    ]

    # web server port
    port: 8080

    # cli runner port
    runnerPort: 9100

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: false

    # Start these browsers, currently available:
        # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera
    # - Safari (only Mac)
    # - PhantomJS
    # - IE (only Windows)
    browsers: ["PhantomJS"]

    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: false

    # level of logging
    # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_WARN

    plugins: [
      "karma-jasmine"
      "karma-spec-reporter"
      "karma-coverage"

      "karma-phantomjs-launcher"
      "karma-chrome-launcher"
      "karma-firefox-launcher"
    ]
