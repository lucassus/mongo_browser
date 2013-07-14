<!DOCTYPE html>
<html>
<head>
  <title>Jasmine Spec Runner</title>

  <!-- Load jasmine -->
  <link rel="stylesheet" type="text/css" href="components/jasmine/css/jasmine.css">
  <script type="text/javascript" src="components/jasmine/js/jasmine.js"></script>
  <script type="text/javascript" src="components/jasmine/js/jasmine-html.js"></script>

  <!-- Load karma files -->
  <% _.forEach(files, function(file) { %>
  <script type="text/javascript" src="<%= file %>"></script><% });
  %>

  <script type="text/javascript">
    (function() {
      var jasmineEnv = jasmine.getEnv();
      jasmineEnv.updateInterval = 1000;

      var trivialReporter = new jasmine.TrivialReporter();

      jasmineEnv.addReporter(trivialReporter);

      jasmineEnv.specFilter = function(spec) {
        return trivialReporter.specFilter(spec);
      };

      var currentWindowOnload = window.onload;

      window.onload = function() {
        if (currentWindowOnload) {
          currentWindowOnload();
        }
        execJasmine();
      };

      function execJasmine() {
        jasmineEnv.execute();
      }

    })();
  </script>

</head>

<body>
</body>
</html>
