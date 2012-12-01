basePath = '../../../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'vendor/assets/javascripts/jquery.js',
  'vendor/assets/javascripts/angular/angular.js',
  'vendor/assets/javascripts/angular/angular-*.js',
  'vendor/assets/javascripts/*.js',

  'app/assets/javascripts/app/**/*.js.coffee',
  'app/assets/javascripts/application.js.coffee',

  'spec/javascripts/lib/angular/angular-mocks.js',
  'spec/javascripts/helpers/**/*.js.coffee',
  'spec/javascripts/**/*_spec.js.coffee',
  'spec/javascripts/**/*_spec.js.coffee'
];

autoWatch = true;

browsers = ['Chrome'];

junitReporter = {
  outputFile: 'test_out/unit.xml',
  suite: 'unit'
};
