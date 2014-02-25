module.exports = (grunt) ->
  'use strict'

  # Underscore
  # ==========
  _ = grunt.util._

  # Package
  # =======
  pkg = require './package.json'

  # Configuration
  # =============
  grunt.initConfig

    # Cleanup
    # -------
    clean:
      build: 'build'
      temp: 'temp'
      bower: 'bower_components'
      components: 'src/bower_components'

    # Wrangling
    # ---------
    copy:
      options:
        excludeEmpty: true

      module:
        files: [
          dest: 'temp/scripts'
          cwd: 'temp/scripts-amd'
          expand: true
          src: [
            '**/*'
            '!main.js'
            '!vendor/**/*'
          ]
        ]

      static:
        files: [
          dest: 'temp'
          cwd: 'src'
          expand: true
          src: [
            '**/*'
            '!*.coffee'{% if (templateLanguage === 'handlebars') { %}
            '!*.hbs'{% } else if (templateLanguage === 'haml') { %}
            '!*.haml'{% } %}
          ]
        ]
{% if (bootstrap && (preprocessor === 'none' || preprocessor === 'stylus')) { %}
        options:
          processContentExclude: ['**/*.png']
          processContent: (content, name) ->
            if /bootstrap/.test(name) and /\.css$/.test(name)
              return content.replace ///../img/glyphicons///g,
                '../../images/bootstrap/glyphicons'

            return content
{% } %}
      build:
        files: [
          dest: 'build/'
          cwd: 'temp'
          expand: true
          src: [
            '**/*.{html,txt,png}',
            'fonts/**/*',
            'images/**/*',
          ]
        ]

    # Dependency management
    # ---------------------
    bower:
      install:
        options:
          targetDir: './src/bower_components'
          cleanup: true
          install: true

    # Compilation
    # -----------
    coffee:
      compile:
        options:
          bare: true

        files: [
          expand: true
          cwd: 'src/scripts'
          src: '**/*.coffee'
          dest: 'temp/scripts'
          ext: '.js'
        ]
{% if (templateLanguage === 'handlebars') { %}
    # Micro-templating language
    # -------------------------
    handlebars:
      compile:
        options:
          namespace: false
          amd: true

        files: [
          expand: true
          cwd: 'src/templates'
          src: '**/*.hbs'
          dest: 'temp/templates'
          ext: '.js'
        ]
{% } else if (templateLanguage === 'haml') { %}
    # Micro-templating language
    # -------------------------
    haml:
      options:
        uglify: true
        placement: 'amd'
        language: 'coffee'
        customHtmlEscape: 'haml.escape'
        customPreserve: 'haml.preserve'
        customCleanValue: 'haml.clean'
        dependencies:
          'haml': 'lib/haml'

      compile:
        files: [
          dest: 'temp/templates/'
          cwd: 'src/templates'
          ext: '.js'
          expand: true
          src: '**/*.haml'
        ]

        options:
          target: 'js'

      index:
        files:
          'temp/index.html': 'src/index.haml'
{% } %}
    # Stylesheet Compressor
    # ---------------------
    mincss:
      compress:
        files:
          'build/styles/main.css': 'build/styles/main.css'
{% if (preprocessor === 'sass' || preprocessor == 'scss') { %}
    # Stylesheet Preprocessor
    # -----------------------
    compass:
      options:
        sassDir: 'src/styles'
        imagesDir: 'src/images'
        cssDir: 'temp/styles'
        javascriptsDir: 'temp/scripts'
        force: true
        relativeAssets: true

      compile:
        options:
          outputStyle: 'expanded'
          environment: 'development'

      build:
        options:
          outputStyle: 'compressed'
          environment: 'production'
{% } else if (preprocessor === 'less') { %}
    # Stylesheet Preprocessor
    # -----------------------
    less:
      compile:
        files:
          'temp/styles/main.css': 'src/styles/**/*.less'

        options:
          dumpLineNumbers: 'all'

      build:
        files:
          'temp/styles/main.css': 'src/styles/**/*.less'

        options:
          compress: true
          optimization: 2
{% } else if (preprocessor === 'stylus') { %}
    # Stylesheet Preprocessor
    # -----------------------
    stylus:
      compile:
        files:
          'temp/styles/main.css': 'src/styles/**/*.styl'

      build:
        files:
          'temp/styles/main.css': 'src/styles/**/*.styl'

        options:
          compress: true
{% } %}
    # Module conversion
    # -----------------
    urequire:
      convert:
        template: 'AMD'
        bundlePath: 'temp/scripts/'
        outputPath: 'temp/scripts-amd/'

    # Script lint
    # -----------
    coffeelint:
      gruntfile: 'Gruntfile.coffee'
      src: [
        'src/**/*.coffee'
        '!src/scripts/vendor/**/*'
      ]

    # Webserver
    # ---------
    connect:
      options:
        port: 3501
        hostname: 'localhost'
        middleware: (connect, options) -> [
          require('connect-url-rewrite') ['^([^.]+|.*\\?{1}.*)$ /']
          connect.static options.base
          connect.directory options.base
        ]

      build:
        options:
          keepalive: true
          base: 'build'

      temp:
        options:
          base: 'temp'

    # HTML Compressor
    # ---------------
    htmlmin:
      build:
        options:
          removeComments: true
          removeCommentsFromCDATA: true
          removeCDATASectionsFromCDATA: true
          collapseWhitespace: true
          collapseBooleanAttributes: true
          removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          removeEmptyAttributes: true
          removeOptionalTags: true

        files: [
          expand: true
          cwd: 'build'
          dest: 'build'
          src: '**/*.html'
        ]

    # Dependency tracing
    # ------------------
    # TODO: This should not be neccessary; uRequire should be able to do
    #   this.
    requirejs:
      compile:
        options:
          out: 'build/scripts/main.js'
          include: _(grunt.file.expandMapping(['main*', 'controllers/**/*'], ''
            cwd: 'src/scripts/'
            rename: (base, path) -> path.replace /\.coffee$/, ''
          )).pluck 'dest'
          mainConfigFile: 'temp/scripts/main.js'
          baseUrl: './temp/scripts'
          keepBuildDir: true
          almond: true
          replaceRequireScript: [
            files: ['temp/index.html'],
            module: 'main'
          ]
          insertRequire: ['main']
          optimize: 'uglify2'

      css:
        options:
          out: 'build/styles/main.css'
          optimizeCss: 'standard.keepLines'
          cssImportIgnore: null
          cssIn: 'temp/styles/main.css'

    # Watch
    # -----
    watch:
      coffee:
        files: 'src/scripts/**/*.coffee'
        tasks: 'script'
        options:
          interrupt: true
{% if (templateLanguage === 'handlebars') { %}
      handlebars:
        files: 'src/templates/**/*.hbs'
        tasks: 'handlebars:compile'
        options:
          interrupt: true
{% } else if (templateLanguage === 'haml') { %}
      haml:
        files: 'src/templates/**/*.haml'
        tasks: 'haml:compile'
        options:
          interrupt: true

      index:
        files: 'src/index.haml'
        tasks: 'haml:index'
        options:
          interrupt: true
{% } %}{% if (preprocessor === 'sass' || preprocessor == 'scss') { %}
      compass:
        files: 'src/styles/**/*.{scss,sass}'
        tasks: 'compass:compile'
        options:
          interrupt: true
{% } else if (preprocessor === 'less') { %}
      less:
        files: 'src/styles/**/*.less'
        tasks: 'less:compile'
        options:
          interrupt: true
{% } else if (preprocessor === 'stylus') { %}
      stylus:
        files: 'src/styles/**/*.styl'
        tasks: 'stylus:compile'
        options:
          interrupt: true
{% } %}
  # Dependencies
  # ============
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name

  # Tasks
  # =====

  # Lint
  # ----
  # Lints all applicable files.
  grunt.registerTask 'lint', [
    'coffeelint'
  ]

  # Prepare
  # -------
  # Cleans the project directory of built files and downloads / updates
  # bower-managed dependencies.
  grunt.registerTask 'prepare', [
    'clean'
    'bower:install'
    'clean:bower'
  ]

  # Script
  # ------
  # Compiles all coffee-script into java-script converts them to the
  # appropriate module format (if neccessary).
  grunt.registerTask 'script', [
    'coffee:compile'
    'urequire:convert'
    'copy:module'
  ]

  # Server
  # ------
  # Compiles a development build of the application; starts an HTTP server
  # on the output; and, initiates a watcher to re-compile automatically.
  grunt.registerTask 'server', [
    'copy:static'
    'script'{% if (templateLanguage === 'handlebars') { %}
    'handlebars:compile'{% } else if (templateLanguage === 'haml') { %}
    'haml:compile'
    'haml:index'{% } %}{% if (/scss|sass/.test(preprocessor)) { %}
    'compass:compile'{% } else if (preprocessor === 'less') { %}
    'less:compile'{% } else if (preprocessor === 'stylus') { %}
    'stylus:compile'{% } %}
    'connect:temp'
    'watch'
  ]

  # Build
  # -----
  # Compiles a production build of the application.
  grunt.registerTask 'build', [
    'copy:static'
    'script'{% if (templateLanguage === 'handlebars') { %}
    'handlebars:compile'{% } else if (templateLanguage === 'haml') { %}
    'haml:compile'
    'haml:index'{% } %}{% if (/scss|sass/.test(preprocessor)) { %}
    'compass:build'{% } else if (preprocessor === 'less') { %}
    'less:build'{% } else if (preprocessor === 'stylus') { %}
    'stylus:build'{% } %}
    'requirejs:compile'
    'copy:build'
    'requirejs:css'
    'mincss:compress'
    'htmlmin'
  ]
