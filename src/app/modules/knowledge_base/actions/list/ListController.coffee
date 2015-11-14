# Dependencies
# -----------------------

# Libs/generic stuff:
_ = require 'underscore'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ListView = require './views/ListView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel, the
# channel for the Knowledge Base module
kbChannel = require '../../moduleChannel'


###
Knowledge Base posts module list controller
============================================

Controller responsible for posts listing.

This controller is responsible for instantiating views,
fetching entities (models/collections) and ensuring views
are configured properly.

When those views emit events throughout their lifecycle or
when something in particular happens which is important to
the application, this controller will listen for those
events and generally bubble those events up to the parent
module.

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  initialize: (options) ->
    { collection, model } = options

    # the view accepts an articles collection or a model
    # with a nested articles collection
    if model and !collection
      collection = model.get 'articles'
      # nested collections might not be initialised
      # (for example, tag articles are loaded when needed)
      @appChannel.request 'when:fetched', model, ->
        if collection and collection.pending then collection.fetch()

    # create the view
    listView = @getView model, collection

    # render
    @show listView,
      loading:
        entities: [model, collection]


  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model}      model
  @param  {Collection} collection
  @return {View}
  ###
  getView: (model, collection) ->
    new ListView
      model:      model
      collection: collection
