'use strict'

Chaplin = require 'chaplin'
routes = require 'routes'

module.exports = class Application extends Chaplin.Application

  initialize: ->
    # Initialize chaplin core
    @initDispatcher controllerSuffix: ''
    @initLayout()
    @initMediator()
    @initControllers()

    # Register all routes and start routing
    @initRouter routes

    # Freeze the object instance; prevent further changes
    Object.freeze? @

  initMediator: ->
    # Attach with semi-globals here.
    Chaplin.mediator.seal()

  initControllers: ->
    # Instantiate any persistent controllers here.
