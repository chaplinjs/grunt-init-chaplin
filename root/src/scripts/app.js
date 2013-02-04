'use strict';

var Chaplin = require('chaplin');
var routes = require('routes');

module.exports = Chaplin.Application.extend({

  initialize: function() {
    // Initialize chaplin core
    this.initDispatcher({controllerSuffix: ''});
    this.initLayout();
    this.initMediator();
    this.initControllers();

    // Register all routes and start routing
    this.initRouter(routes);

    // Freeze the object instance; prevent further changes
    if (Object.freeze) {
      Object.freeze(this);
    }
  },

  initMediator: function() {
    // Attach with semi-globals here.
    Chaplin.mediator.seal();
  },

  initControllers: function() {
    // Instantiate any persistent controllers here.
  }

});
