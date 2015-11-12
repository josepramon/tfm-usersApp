# Dependencies
# -----------------------

i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
DashboardView = require './views/DashboardView'

# Radio channels:
moduleChannel  = require '../../moduleChannel'


# KnowledgeBase module dashboard controller
#
# This controller is responsible for instantiating views,
# fetching entities (models/collections) and ensuring views
# are configured properly.
#
# When those views emit events throughout their lifecycle or
# when something in particular happens which is important to
# the application, this controller will listen for those
# events and generally bubble those events up to the parent
# module.
#
module.exports = class DashboardController extends ViewController

  initialize: (options) ->
    { categoriesCollection, tagsCollection, uncategorizedCategory } = options

    # create the view
    view = @getView categoriesCollection, tagsCollection, uncategorizedCategory

    # render
    @show view,
      loading:
        entities: [categoriesCollection, tagsCollection]


  # Aux
  # -----------------

  ###
  View getter

  @return {View}
  ###
  getView: (categories, tags, uncategorized) ->
    new DashboardView
      categoriesCollection: categories
      tagsCollection:       tags
      uncategorizedModel:   uncategorized
