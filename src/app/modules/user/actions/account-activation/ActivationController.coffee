# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
AccountActivationView = require './views/AccountActivationView'

# Radio channels:
usersChannel = require '../../moduleChannel'


# Account activation controller
#
module.exports = class SetPasswordController extends ViewController

  initialize: (options) ->
    { model, id, collection, tagsCollection, categoriesCollection } = options

    # if no model provided, retrieve it
    model or= @getModel id

    # create the view
    view = @getView model

    # render
    @show view

    model.save null,
      patch: true
      success: => @formActionDone true
      error:   => @formActionDone()


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model} data
  @return {View}
  ###
  getView: (data) ->
    new AccountActivationView
      model: data



  ###
  Load the model
  ###
  getModel: (id) ->
    @appChannel.request 'user:accountActivation:entity', id


  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashMessage = i18n.t 'user::Account has been activated successfully'
      @appChannel.request 'flash:success', flashMessage

    # redirect to login
    usersChannel.trigger 'redirect:login'
