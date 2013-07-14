module.exports = (grunt) ->
  path = require("path")

  grunt.registerTask "jasminehtml", ->

    options = @options()
    options.karmaConfigFile or= grunt.config("karma.unit.configFile")

    loadKarmaPatterns = ->
      files = []
      config = set: (config) -> files = config.files

      # Reload karma config file
      delete require.cache[path.resolve(options.karmaConfigFile)]
      require("../#{options.karmaConfigFile}")(config)

      files

    loadFiles = ->
      grunt.log.writeln("Found files:")
      files = []
      for pattern in loadKarmaPatterns()
        for file in grunt.file.expand(path.join(options.dest, pattern))
          file = file.replace new RegExp("^#{options.dest}/"), ""
          grunt.log.writeln(file)
          files.push file
      files

    template = grunt.file.read path.join("tasks", "jasmine.html.tpl")
    html = grunt.template.process template, data: files: loadFiles()

    grunt.file.write path.join(options.dest, "jasmine.html"), html
