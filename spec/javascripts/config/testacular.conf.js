basePath = "../../../";

files = [
  JASMINE,
  JASMINE_ADAPTER,

  // Libraries
  "vendor/assets/javascripts/jquery.js",
  "vendor/assets/javascripts/angular/angular.js",
  "vendor/assets/javascripts/angular/angular-*.js",
  "vendor/assets/javascripts/*.js",

  // The app
  "app/assets/javascripts/app/controllers.js.coffee",
  "app/assets/javascripts/app/**/*.js.coffee",
  "app/assets/javascripts/application.js.coffee",

  // Specs
  "spec/javascripts/lib/angular/angular-mocks.js",

  "spec/javascripts/helpers/**/*.js.coffee",
  "spec/javascripts/**/*_spec.js.coffee",
  "spec/javascripts/**/*_spec.js.coffee",

  // Templates
  "app/assets/templates/*.html.js"
];

preprocessors = {
  "**/*.js.coffee": "coffee",
  "**/*.html": "html2js"
};

// Test results reporter to use
// possible values: dots || progress
reporters = ["dots"];

browsers = ["PhantomJS"];

autoWatch = true;
singleRun = false
