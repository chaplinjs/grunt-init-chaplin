'use strict';

// Basic template description.
exports.description = 'Create a complete Chaplin.js application.';

// Template-specific notes to be displayed before question prompts.
exports.notes = '';

// Any existing file or directory matching this wildcard will cause a warning.
exports.warnOn = '*';

// The initialize template.
exports.template = function(grunt, init, done) {
  var _ = grunt.util._;

  init.process({}, [
    // Prompt for the following values.
    // Built-In
    init.prompt('name'),
    init.prompt('description'),
    init.prompt('version'),
    init.prompt('repository'),
    init.prompt('homepage'),
    init.prompt('bugs'),
    init.prompt('licenses'),
    init.prompt('author_name'),
    init.prompt('author_email'),
    init.prompt('author_url'),
    // Custom
    {
      name: 'language',
      message: 'Language',
      default: 'coffee',
      validator: /coffee|js/,
      warning: 'Must be either "coffee" for coffee-script or "js" ' +
        'for javascript'
    }, {
      name: 'templateLanguage',
      message: 'Micro-templating language',
      default: 'handlebars',
      validator: /handlebars|haml|underscore/,
      warning: 'Must be one of the following template languages: ' +
        'handlebars, haml, or underscore.'
    }, {
      name: 'preprocessor',
      message: 'Stylesheet preprocessor',
      default: 'stylus',
      validator: /sass|scss|less|stylus|none/,
      warning: 'Must be one of the following preprocessors: ' +
        'sass, scss, less, stylus, or none (to indicate no preprocessor).'
    }, {
      name: 'bootstrap',
      message: 'Include Twitter Bootstrap?',
      default: 'Y/n',
      warning: 'Yes: Twitter bootstrap is included; no: it\'s not.',
    }
  ], function(err, props) {
    // Files to copy (and process).
    var files = init.filesToCopy(props);

    // Normalize options.
    props.bootstrap = /y/i.test(props.bootstrap);
    props.preprocessor = props.preprocessor ? props.preprocessor : 'none';

    // Remove files that aren't of the language requested.
    var lang = props.language === 'coffee' ? 'js' : 'coffee';
    files = _.omit(files, function(value, key) {
      if (/^src\/scripts\/vendor/.test(key)) return false;
      return _.endsWith(key, lang);
    });

    // Remove files that aren't of the template language requested.
    var templateLanguages = {
      haml: '.haml',
      handlebars: '.hbs'
    };

    delete templateLanguages[props.templateLanguage];
    files = _.omit(files, function(value, key) {
      return _.any(templateLanguages, function(lang) {
        return _.endsWith(key, lang);
      });
    });

    if (props.templateLanguage === 'haml') {
      // Haml can provide the index file.
      // TODO: Should we generalize this check so other template languages
      //  that can be rendered as well as pre-compiled could be used?
      delete files['src/index.html'];
    }

    // Remove stylesheets that aren't part of the preprocessor requested.
    var preprocessors = {
      none: '.css',
      scss: '.scss',
      sass: '.sass',
      less: '.less',
      stylus: '.styl'
    };

    delete preprocessors[props.preprocessor];
    files = _.omit(files, function(value, key) {
      return _.any(preprocessors, function(lang) {
        return _.endsWith(key, lang);
      });
    });

    // Gather standard and additional dependencies.
    var devDependencies = {
      'grunt': '0.4.x',
      'grunt-contrib-clean': '0.4.0rc6',
      'grunt-contrib-copy': '0.4.0rc7',
      'grunt-contrib-connect': '0.1.1rc6',
      'grunt-contrib-watch': '0.2.0rc7',
      'grunt-requirejs': '0.3.x',
      'grunt-contrib-mincss': '0.4.0rc7',
      'grunt-contrib-htmlmin': '0.1.1rc7',
      'grunt-bower-task': '0.1.x',
      'grunt-urequire': 'git://github.com/aearly/grunt-urequire.git',
      // grunt-urequire requires lodash incorrectly,
      // see: https://github.com/aearly/grunt-urequire/pull/3
      'lodash': '0.10.x',
      'connect-url-rewrite': '0.1.x'
    };

    // Language libraries
    switch (props.language) {
    case 'js':
      devDependencies['grunt-contrib-jshint'] = '0.1.1rc6';
      break;

    case 'coffee':
      devDependencies['grunt-contrib-coffee'] = '0.4.0rc7';
      devDependencies['grunt-coffeelint'] =
        // NPM seems to be out-dated; master works with grunt 0.4.x
        'git://github.com/vojtajina/grunt-coffeelint.git';
      break;
    }

    // Micro-templating library
    switch (props.templateLanguage) {
    case 'haml':
      devDependencies['grunt-haml'] = '0.3.x';

    case 'handlebars':
      // Waiting on a pull request to add modular AMD
      // See: https://github.com/gruntjs/grunt-contrib-handlebars/pull/24
      devDependencies['grunt-contrib-handlebars'] =
        'git://github.com/concordusapps/grunt-contrib-handlebars.git';
      break;
    }

    if (props.templateLanguage !== 'haml') {
      // Remove the HAML runtime.
      delete files['src/scripts/lib/haml.coffee'];
      delete files['src/scripts/lib/haml.js'];
    }

    // Stylesheet preprocessor
    switch (props.preprocessor) {
    case 'sass':
    case 'scss':
      devDependencies['grunt-contrib-compass'] = '0.1.x';
      break;

    case 'stylus':
      devDependencies['grunt-contrib-stylus'] = '0.4.0rc7';
      break;

    case 'less':
      devDependencies['grunt-contrib-less'] = '0.5.x';
      break;
    }

    // Add properly-named license files.
    init.addLicenseFiles(files, props.licenses);

    // Actually copy (and process) files.
    init.copyAndProcess(files, props);

    // Generate package.json file.
    init.writePackageJSON('package.json', _.extend(props, {
      keywords: [],
      node_version: '0.8.x',
      devDependencies: devDependencies
    }));

    // Gather client-side, browser dependencies
    // Collect the standard ones.
    var dependencies = {
      'jquery': '1.8.x',
      'underscore': '1.4.x',
      'backbone': '0.9.x',
      'requirejs': '2.1.x',
      'almond': '0.2.x',
      'chaplin': '0.8.x'
    };

    if (props.templateLanguage === 'handlebars') {
      // Handlebars requires a run-time library.
      dependencies['handlebars'] = '1.0.x'
    }

    // Gatrher the export overrides (these are consumed by grunt-bower-task
    // to replace the main declaration in the component.json).
    // Collect the standard ones
    var exportsOverride = {
      'jquery': {'scripts': 'jquery.js' },
      'almond': {'scripts': 'almond.js' },
      'backbone': {'scripts': 'backbone.js'},
      'requirejs': {'scripts': 'require.js'},
      'underscore': {'scripts': 'underscore.js'},
      'chaplin': {'scripts': 'amd/chaplin.js'},
    };

    if (props.templateLanguage === 'handlebars') {
      // Handlebars requires a run-time library.
      exportsOverride['handlebars'] = {'scripts': 'handlebars.runtime.js'};
    }

    if (props.bootstrap) {
      // Include the bootstrap libraries.
      switch (props.preprocessor) {
      case 'sass':
      case 'scss':
        dependencies['bootstrap-sass'] = '2.2.x';
        exportsOverride['bootstrap-sass'] = {
          'scripts': 'js/**/*.js',
          'styles': 'lib/**/*.scss',
          'images': 'img/glyphicons-*.png',
        };
        break;

      case 'less':
        dependencies['bootstrap'] = '2.2.x';
        exportsOverride['bootstrap'] = {
          'styles': 'less/*.less',
          'scripts': 'js/*.js',
          'images': 'img/glyphicons-*.png'
        };
        break;

      case 'stylus':
      default:
        dependencies['bootstrap'] = '2.2.x';
        exportsOverride['bootstrap'] = {
          'styles': 'docs/assets/css/bootstrap*.css',
          'scripts': 'js/*.js',
          'images': 'img/glyphicons-*.png'
        };
      }
    }

    // Generate a component.json file.
    init.writePackageJSON('component.json', {
      name: props.name,
      version: props.version,
      dependencies: dependencies
    }, function(pkg, props) {
      pkg.exportsOverride = exportsOverride;
      return pkg;
    });

    // All done!
    done();
  });

};
