# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
AccountView = require './views/AccountView'


# User module account controller
#
module.exports = class AccountController extends ViewController

  initialize: (options) ->

    # retrieve the model
    model = @getModel()

    # create the view
    view = @getView model

    # wrap it into a form component
    formView = @wrapViewWithForm view, model

    # remove locally the password fields
    # once the model is saved to the server
    @listenTo model, 'updated', ->
      model.unset 'password'
      model.unset 'rePassword'
      model.unset 'oldPassword'

    # render
    @show formView


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model} data
  @return {View}
  ###
  getView: (data) ->
    new AccountView
      model: data



  ###
  Load the model
  ###
  getModel: () ->
    session = @appChannel.request 'user:session:entity'
    if session
      return session.get 'user'
    else
      null


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
      onFormCancel:  => @formActionDone()
      onFormSuccess: => @formActionDone(true)



  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashMessage = i18n.t 'user::Account successfully updated'
      @appChannel.request 'flash:success', flashMessage
