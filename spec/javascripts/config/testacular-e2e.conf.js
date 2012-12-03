basePath = "../../../";

files = [
  ANGULAR_SCENARIO,
  ANGULAR_SCENARIO_ADAPTER,
  "spec/javascripts/e2e/**/*.js.coffee"
];

reporters = ["dots"];
browsers = ["PhantomJS"];

autoWatch = false;
singleRun = true;

urlRoot = '/__testacular/';
proxies = {
  "/": "http://localhost:3000/"
};
