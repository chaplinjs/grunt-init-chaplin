'use strict'

Chaplin = require 'chaplin'
View = require 'views/index'

module.exports = class Index extends Chaplin.Controller

  show: ->
    # Instantiate the view; pass in autoRender so the view is
    # immediately rendered.
    @view = new View
      autoRender: yes
