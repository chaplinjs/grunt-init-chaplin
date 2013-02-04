'use strict';

var Chaplin = require('chaplin');
var View = require('views/index');

module.exports = Chaplin.Controller.extend({
  show: function() {
    // Instantiate the view; pass in autoRender so the view is
    // immediately rendered.
    this.view = new View({
      autoRender: true
    });
  }
});
