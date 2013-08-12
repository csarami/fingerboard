module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      debug:
        expand: true
        cwd: "app"
        src: "*.coffee"
        dest: "build"
        ext: ".js"
        options:
          sourceMap: true
      release:
        expand: true
        cwd: "app"
        src: "*.coffee"
        dest: "release"
        ext: ".js"
        options:
          sourceMap: false
    coffeelint:
      app: ['**/*.coffee']
      options:
        max_line_length: { value: 120 }
    copy:
      debug:
        expand: true
        cwd: 'app/assets/'
        dest: 'build/'
        src: '**'
        filter: 'isFile'
      release:
        expand: true
        cwd: 'app/assets/'
        dest: 'release/'
        src: '**'
        filter: 'isFile'
    githubPages:
      target:
        src: 'release'
    jade:
      debug:
        files:
          'build/index.html': 'app/views/index.jade'
        options:
          pretty: true
          data:
            cdn_scheme: 'http:'
            debug: true
      release:
        files:
          'release/index.html': 'app/views/index.jade'
        options:
          data:
            cdn_scheme: ''
            debug: false
    sass:
      debug:
        files:
          'build/main.css': 'app/views/styles/main.scss'
        options:
          sourcemap: true
      release:
        files:
          'release/main.css': 'app/views/styles/main.scss'
        options:
          sourcemap: false
          style: 'compressed'
    watch:
      options:
        livereload: true
      sass:
        files: ['app/**/main.scss']
        tasks: ['sass:debug']
      jade:
        files: ['app/**/index.jade']
        tasks: ['jade:debug']
      scripts:
        files: ['**/*.coffee']
        tasks: ['coffeelint', 'coffee:debug']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-github-pages'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask 'build', ['coffeelint',  'coffee:debug', 'jade:debug', 'sass:debug', 'copy:debug']
  grunt.registerTask 'build:release', ['coffeelint', 'coffee:release', 'jade:release', 'sass:release', 'copy:release']
  grunt.registerTask 'deploy', ['build:release', 'githubPages:target']
  grunt.registerTask 'default', ['watch']