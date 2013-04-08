{generators} = require 'yeoman-generator'

module.exports = class Generator extends generators.Base

  constructor: ->
    super
    @on 'end', ->
      console.log '\nFinished. Run ' +
        'npm install && bower install --dev'.bold.yellow +
        ' to install the required dependencies.'

  askFor: ->
    # Initialize the questions.
    callback = @async()
    prefix = "[#{ '?'.green }]"
    initialPrompts = [
      name: 'name'
      prompt: prefix + ' Project name'.grey
      default: 'app'
    ,
      name: 'description'
      prompt: prefix + ' Description'.grey
      default: 'The best project ever.'
    ,
      name: 'license'
      prompt: prefix + ' License'.grey
      default: 'MIT'
    ,
      name: 'author',
      prompt: prefix + ' Author name'.grey
      default: 'Ryan Leckey'
    ,
      name: 'email'
      prompt: prefix + ' Author email'.grey
      default: 'rleckey@concordusapps.com'
    ,
      name: 'language'
      prompt: prefix + ' Language'.grey
      default: 'coffee'
    ,
      name: 'templates'
      prompt: prefix + ' Micro-templating'.grey
      default: 'Y/n'
    # ,
    #   prompt: prefix + ' Micro-templating language'.grey
    #   default: 'handlebars'
    # ,
    #   prompt: prefix + ' Stylesheet preprocessor'.grey
    #   default: 'Y/n'
    # ,
    #   prompt: prefix + ' Stylesheet preprocessing language'.grey
    #   default: 'stylus'
    # ,
    #   prompt: prefix + ' Include backbone.stickit'.grey
    #   default: 'y/N'
    # ,
    #   prompt: prefix + ' Include underscore.string'.grey
    #   default: 'y/N'
    ]

    extraPrompts =
      templates:

    @prompt prompts, (error, properties) ->
      # Emit and return an error if there was one.
      return @emit 'error', error if error

      # Show the next set of prompts.
      @prompt

      # We're done here.
      callback()
