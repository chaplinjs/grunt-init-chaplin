'use strict';

require.config({
  paths: {
    // Plugin to load JS files that have dependencies but aren't wrapped
    // into `define` calls. This is more flexible (and allows for configuration
    // before exporting into the global scope) than the standard shim config.
    depend: 'vendor/require-depend',

    // A utility-belt library for JavaScript that provides a lot of the
    // functional programming support.
    // http://underscorejs.org/
    underscore: 'components/underscore',

    // jQuery is a fast, small, and feature-rich JavaScript library. It makes
    // things like HTML document traversal and manipulation, event handling,
    // animation, and Ajax much simpler with an easy-to-use API that works
    // across a multitude of browsers.
    // http://api.jquery.com/
    jquery: 'components/jquery',

    // Provides the JSON object for manipulation of JSON strings if not
    // already defined. This is required for support of IE 8 and below.
    // http://bestiejs.github.com/json3/
    json2: '../components/scripts/json3/json3',

    // Backbone.js gives structure to web applications by providing models with
    // key-value binding and custom events, collections with a rich API of
    // enumerable functions, views with declarative event handling, and connects
    // it all to your existing API over a RESTful JSON interface.
    backbone: 'components/backbone',
{% if (templateLanguage === 'handlebars') { %}
    // Handlebars provides the power necessary to let you build semantic
    // templates effectively with no frustration.
    // http://handlebarsjs.com/
    handlebars: '../components/scripts/handlebars/handlebars.runtime',{% }
else if (templateLanguage === 'haml' && language === 'coffee') { %}
    // Haml (HTML abstraction markup language) is based on one primary
    // principle: markup should be beautiful.
    // https://github.com/netzpirat/haml-coffee
    haml: 'lib/haml',{% } %}

    // Directory containing the micro-templates.
    // This is needed as templates are required as 'templates/...' but the
    // template directory lives at 'src/templates/...' and not
    // 'src/scripts/templates...'.
    templates: '../templates',

    // Chaplin.js; Web application framework on top of Backbone.js.
    chaplin: '../components/scripts/chaplin/chaplin',
  },
{% if (templateLanguage === 'handlebars') { %}
  shim: {
    handlebars: {
      exports: 'Handlebars'
    }
  }
{% } %}
});

//! Instantiate the application and begin the execution cycle.
require(['app'], function(Application) {
  var app = new Application();
  app.initialize();
});
