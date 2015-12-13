# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
EditView = require './views/EditView'

# Aux.
CommentController = require '../comment/CommentController'
StatusController  = require '../status/StatusController'

# Radio channels:
ticketsChannel = require '../../moduleChannel'


###
Tickets module edit controller
====================================

@class
@augments ViewController

###
module.exports = class EditController extends ViewController

  initialize: (options) ->
    { model, collection, statuses } = options

    # create the view
    view = @getView model

    # bind the listeners
    @listenTo view, 'ticket:comment:add', @createComment
    @listenTo view, 'ticket:close',       @closeTicket
    @listenTo view, 'ticket:reopen',      @reopenTicket
    @listenTo model.get('statuses'), 'add', view.render

    # show the view
    @show view,
      loading: [model, collection, statuses]

    # save some references as instance attributes
    @model    = model
    @statuses = statuses


  createComment: =>
    new CommentController
      parentModel: @model
      region:      @appChannel.request 'region', 'modalRegion'


  closeTicket: ->
    status = @statuses.findWhere 'closed': true

    @_changeStatus status, =>
      @model.set 'closed': true
      Backbone.history.navigate '#tickets', { trigger: true }


  reopenTicket: ->
    status = @statuses.findWhere 'open': true

    @_changeStatus status, =>
      @model.set 'closed': false


  _changeStatus: (status, callback = _.noop) ->
    args =
      statusesCollection: @statuses
      parentModel:        @model
      region:             @appChannel.request 'region', 'modalRegion'

    if status then args.statusModel = status

    controller = new StatusController args

    @listenToOnce controller, 'status:created', (model) =>
      callback()
      @model.get('statuses').add model
      @model.save()




  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param {Model} model
  @return {View}
  ###
  getView: (model) ->
    new EditView
      model:      model
      collection: model.get 'comments'
