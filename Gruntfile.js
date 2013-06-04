module.exports = function(grunt) {

  grunt.initConfig({
    watch: {
      templates: {
        files: "public/ng/templates/**/*.html",
        tasks: "html2js:directives"
      }
    },

    html2js: {
      directives: ["public/ng/templates/**/*.html"]
    }
  });

  var TPL = 'angular.module("<%= file %>", []).run(function($templateCache) {\n' + '  $templateCache.put("<%= path %>",\n    "<%= content %>");\n' + '});\n';

  var escapeContent = function(content) {
    return content.replace(/"/g, '\\"').replace(/\n/g, '" +\n    "');
  };

  grunt.registerMultiTask("html2js", "Generate js version of html template.", function() {
    var files = grunt._watch_changed_files || grunt.file.expand(this.data);

    files.forEach(function(file) {
      var parts = file.split("/").slice(3);
      var name = parts.join("/");

      var data = {
        file: file,
        path: "/ng/templates/" + file.split("/").pop(),
        content: escapeContent(grunt.file.read(file))
      };
      var content = grunt.template.process(TPL, { data: data });
      grunt.file.write("app/assets/javascripts/compiled_templates/" + name + ".js", content);
    });
  });
};
