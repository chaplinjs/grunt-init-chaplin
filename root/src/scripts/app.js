'use strict';

var Chaplin = require('chaplin');
var routes = require('routes');

module.exports = Chaplin.Application.extend({

  initialize: function() {
    // Initialize chaplin core
    this.initDispatcher({controllerSuffix: ''});
    this.initRouter(routes);
    this.initComposer();
    this.initLayout();
    this.initMediator();

    // Start routing
    this.startRouting();

    // Freeze the object instance; prevent further changes
    if (Object.freeze) {
      Object.freeze(this);
    }
  },

  initMediator: function() {
    // Attach with semi-globals here.
    Chaplin.mediator.seal();
  }

});
