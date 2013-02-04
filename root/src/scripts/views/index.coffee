'use strict'

Chaplin = require 'chaplin'

module.exports = class View extends Chaplin.View

  template: require 'templates/index'

  getTemplateFunction: ->
    @template

  container: '#container'
