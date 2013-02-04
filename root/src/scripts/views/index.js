'use strict';

var Chaplin = require('chaplin');

module.exports = Chaplin.View.extend({

  template: require('templates/index'),

  getTemplateFunction: function() {
    return this.template;
  },

  container: '#container'

});
