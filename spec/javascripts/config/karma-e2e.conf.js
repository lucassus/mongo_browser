basePath = "../../../";

files = [
  ANGULAR_SCENARIO,
  ANGULAR_SCENARIO_ADAPTER,
  "spec/javascripts/helpers_e2e/**/*.js.coffee",
  "spec/javascripts/e2e/**/*.js.coffee"
];

reporters = ["dots"];
browsers = ["PhantomJS"];

autoWatch = false;
singleRun = true;

urlRoot = '/__karma__/';
proxies = {
  "/": "http://localhost:3001/"
};
