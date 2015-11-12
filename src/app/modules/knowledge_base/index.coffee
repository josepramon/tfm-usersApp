# Dependencies
# -----------------------

# Libs/generic stuff:
i18n = require 'i18next-client'

# Base class (extends Marionette.Module)
Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router          = require './ModuleRouter'
RouteController = require './ModuleController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel specific to
# the module
moduleChannel = require './moduleChannel'
Entities      = require './entities'



###
Knowledge Base module
=====================

@class
@augments BaseTmpModule

###
module.exports = class KnowledgeBaseApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::KnowledgeBase'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'knowledge-base'


  ###
  Controller used by the module router

  @type {ModuleController}
  @private
  ###
  moduleController = null


  ###
  Module initialization
  ###
  initialize: ->

    # register the module entities
    @app.module 'Entities.kb', Entities

    # setup the module components
    @initModuleRouter()

    # module metadata getter
    moduleChannel.reply 'meta', => @meta

    # forward search requests to the controller
    @listenTo @appChannel, 'kb:search', (data) =>
      if data.query
        @search data.query
        @app.navigate "/#{@meta.rootUrl}/search/#{data.query}"




  # Module API
  # ------------------------


  ###
  Search

  @param {String} query
  ###
  search: (query) -> moduleController.search query



  # Aux methods
  # ------------------------

  ###
  Setup the module router
  ###
  initModuleRouter: ->
    moduleController = new RouteController()

    moduleRouter = new Router
      controller: moduleController
      rootUrl:    @meta.rootUrl
