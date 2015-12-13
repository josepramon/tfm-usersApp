# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
CreateView = require './views/CreateView'

# Radio channels:
ticketsChannel = require '../../moduleChannel'


###
Tickets module create controller
====================================

Controller responsible for Tickets creation

This controller is responsible for instantiating views,
fetching entities (models/collections) and ensuring views
are configured properly.

When those views emit evnts throughout their lifecycle or
when something in particular happens which is important to
the application, this controller will listen for those
events and generally bubble those events up to the parent
module.

@class
@augments ViewController

###
module.exports = class CreateController extends ViewController

  initialize: (options) ->
    model                 = @getModel()
    collection            = options.collection
    @categoriesCollection = options.categoriesCollection

    # create the view
    view = @getView model, @categoriesCollection

    # wrap it into a form component
    formView = @wrapViewWithForm(view, model, collection)

    @listenTo formView, 'form:submit', @processFormData

    # render
    @show formView,
      loading:
        entities: [model, collection, @categoriesCollection]



  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param {Model}      model
  @param {Collection} categoriesCollection
  @return {View}
  ###
  getView: (model, categoriesCollection) ->
    new CreateView
      model:      model
      categories: categoriesCollection


  ###
  Load the model
  ###
  getModel: ->
    @appChannel.request 'new:tickets:entity'


  ###
  Form setup

  Wraps the view inside a FormComponent that handles the
  serializing/deserializing, validation and other stuff.

  @param {View}       view
  @param {Model}      model
  @param {Collection} collection
  ###
  wrapViewWithForm: (view, model, collection) ->
    @appChannel.request 'form:component', view,
      collection:       collection
      onFormCancel:  => @formActionDone(model)
      onFormSuccess: => @formActionDone(model, true)



  ###
  Callback executed when the form is closed
  ###
  formActionDone: (model, success = false) ->
    if success
      flashMessage = i18n.t 'tickets::Ticket successfully created'
      @appChannel.request 'flash:success', flashMessage
      Backbone.history.navigate "#tickets/#{model.id}" , { trigger: true }


  ###
  Form submit handler

  Preprocess the data before the generic handlers are executed
  ###
  processFormData: (data) =>
    # process the category
    data.category = @categoriesCollection.get data.category

    # process the attachments
    data.attachments or= {}
    newVal = null
    try
      newVal = JSON.parse data.attachments
    catch e
      console.log 'Bad attachments value'
    data.attachments = newVal
