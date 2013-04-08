module.exports = (grunt) ->

  # Configuration
  # =============

  grunt.initConfig

    coffee:
      compile:
        files: [
          expand: true
          src: 'app/*.coffee'
          ext: '.js'
        ]

  # Load grunt task dependencies
  for name in require('matchdep').filterDev 'grunt-*'
    grunt.loadNpmTasks name

  # Tasks
  # =====

  # Build
  # -----
  grunt.registerTask 'build', [
    'coffee'
  ]
