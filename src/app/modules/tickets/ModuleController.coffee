# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller     = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
CreateController = require './actions/create/CreateController'
EditController   = require './actions/edit/EditController'
ListController   = require './actions/list/ListController'

ticketsChannel = require './moduleChannel'


###
Tickets module main controller
=======================================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller

  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)


  ###
  List the user tickets
  ###
  list: ->
    new ListController
      collection: @getCollection(true)


  ###
  Create a new ticket

  @param {Object} opts  Options. Currently the only accepted option is 'region'
  ###
  create: (opts = {}) ->
    args =
      collection:           @getCollection()
      categoriesCollection: @getCategoriesCollection()

    if opts.region then args.region = opts.region

    new CreateController args


  ###
  Edit a ticket

  @param {String}   ticketId  Ticket id
  @param {Category} ticket    Ticket model
  ###
  edit: (ticketId, ticket) ->
    ticket or= @getTicketModel ticketId

    new EditController
      id:         ticketId
      model:      ticket
      collection: @getCollection()
      statuses:   @getStatusesCollection()


  # Events
  # ------------------------

  ###
  Event handler invoked when the router inactive (the loaded route
  matches any of the routes deffined in that router)
  ###
  onActive: ->
    @_restrictToAuthorisedUsers()


  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: ->
    delete @collection
    delete @categoriesCollection
    delete @statusesCollection


  # Aux methods
  # ------------------------

  ###
  Access control
  ###
  _restrictToAuthorisedUsers: ->
    @appChannel.request 'auth:requireAuth', null, false


  ###
  Collection getter
  ###
  getCollection: (refresh = false) ->
    if refresh or !@collection
      @collection = @appChannel.request 'tickets:entities',
        filters: ['closed:false']
    @collection


  ###
  Categories collection getter
  ###
  getCategoriesCollection: ->
    unless @categoriesCollection
      @categoriesCollection = @appChannel.request 'tickets:categories:entities'
    @categoriesCollection


  ###
  Statuses collection getter
  ###
  getStatusesCollection: ->
    unless @statusesCollection
      @statusesCollection = @appChannel.request 'tickets:statuses:entities'
    @statusesCollection


  ###
  Retrieve a model

  If there's a cached collection containing the model, that model is returned.
  Otherwise, the model is fetched from the server
  ###
  getTicketModel: (id) ->
    if @collection and @collection.models.length
      model = @collection.get id
      if model then return model

    # if not found, load it from the server
    @appChannel.request 'tickets:entity', id
