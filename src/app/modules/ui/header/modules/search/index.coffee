# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components
SearchController  = require './searchForm/SearchController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel, the
# channel for the parent  module (Header) channel.
headerChannel  = require '../../moduleChannel'




###
Search module
=========================

@class
@augments ModuleController

###
module.exports = class HeaderSearch extends Module

  ###
  Module initialization
  ###
  initialize: ->
    # start/stop AFTER the parent module
    @listenTo headerChannel, 'header:started', => @start()
    @listenTo headerChannel, 'header:stopped', => @stop()


  ###
  Event handler executed after the module has been initialized
  ###
  onStart: ->
    @c = new SearchController
      region: headerChannel.request 'region', 'search'


  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @c.destroy()
