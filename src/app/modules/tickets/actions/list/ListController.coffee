# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The views
LayoutView = require './views/TicketsView'
ListView   = require './views/ListView'

# Radio channels:
ticketsChannel = require '../../moduleChannel'


###
Tickets module list controller
============================================

Controller responsible for tickets listing.

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  initialize: (options) ->
    { model, @collection } = options

    # this controller uses a layout to display at the same time
    # the tickets list and the ticket creation form
    layout = @getLayoutView()

    # init the auxiliary views
    listRegion = layout.getRegion 'list'
    formRegion = layout.getRegion 'form'

    @listenToOnce layout, 'show', =>
      # init the ticket list
      @attachTicketsList listRegion, @collection

      # init the form
      @attachNewTicketForm formRegion

    # setup other event listeners
    @listenTo layout, 'filter', @filterByStatus

    # render it
    @show layout


  ###
  Collection custom filter (based on the ticket status)
  ###
  filterByStatus: (closed) ->
    @collection.removeQueryFilter 'closed'
    @collection.addQueryFilter    'closed', closed
    @collection.fetch()


  ###
  Before destroy handler

  Destroy any nested component (like the form)
  ###
  onBeforeDestroy: ->
    if @form then @form.destroy()


  ###
  Tickets view initialization
  ###
  attachTicketsList: (region, collection) ->
    # create the view
    listView = @getListView collection

    # render
    @show listView,
      loading:
        entities: [collection]
      region: region


  ###
  Create form initialization
  ###
  attachNewTicketForm: (region) ->
    @form = ticketsChannel.request 'newTicketForm',
      region: region


  # Aux
  # -----------------

  ###
  LayoutView getter

  Instantiates the appropiate layout
  ###
  getLayoutView: ->
    new LayoutView()


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Collection} collection
  @return {View}
  ###
  getListView: (collection) ->
    new ListView
      collection: collection
