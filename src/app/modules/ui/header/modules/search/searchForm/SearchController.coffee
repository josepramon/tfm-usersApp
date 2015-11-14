# Dependencies
# -----------------------

Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
View = require './views/SearchForm'




###
Search form view controller
==================================

@class
@augments ViewController

###
module.exports = class SearchWidgetController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    @view = @getView()

    @listenTo @view, 'form:submit', @formSubmit

    # render
    @show @view


  ###
  Search form submit handler
  ###
  formSubmit: ->
    # pull data off of form
    data = Backbone.Syphon.serialize @view

    # dispatch an event (it will be handled somewhere else)
    @appChannel.trigger 'kb:search', data


  # Aux
  # -----------------

  ###
  View getter

  @return {View}
  ###
  getView: ->
    new View()
