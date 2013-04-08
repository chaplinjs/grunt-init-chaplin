'use strict'

Chaplin = require 'chaplin'
routes = require 'routes'

module.exports = class Application extends Chaplin.Application

  initialize: ->
    # Initialize chaplin core
    @initDispatcher controllerSuffix: ''
    @initRouter routes
    @initComposer()
    @initLayout()
    @initMediator()

    # Start routing.
    @startRouting()

    # Freeze the object instance; prevent further changes
    Object.freeze? @

  initMediator: ->
    # Attach with semi-globals here.
    Chaplin.mediator.seal()
