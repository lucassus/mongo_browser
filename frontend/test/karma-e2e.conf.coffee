# Karma configuration
module.exports = (config) ->
  config.set

    frameworks: [
      "ng-scenario"
    ]

    # list of files / patterns to load in the browser
    files: [
      "test/e2e/**/*_spec.js"
    ]

    # web server port
    port: 8090

    # cli runner port
    runnerPort: 9110

    # enable / disable colors in the output (reporters and logs)
    colors: true

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

    # Running server address
    urlRoot: "/__karma__/"
    proxies: "/": "http://localhost:9001/"

    # level of logging
    # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_WARN

    plugins: [
      "karma-ng-scenario"
      "karma-spec-reporter"

      "karma-phantomjs-launcher"
      "karma-chrome-launcher"
      "karma-firefox-launcher"
    ]
