# Dependencies
# -----------------------

# Base class (extends Marionette.CompositeView)
CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

# Aux. views
ListItemView  = require './ListItemView'
NoDataView    = require './NoDataView'

# View behaviours
InfiniteScrollingBehaviour = require 'msq-appbase/lib/behaviours/InfiniteScrolling'

# Just to check the model type (the constructor.name is useless
# because the name is mangled by the minifier)
CategoryModel = require '../../../entities/categories/Category'
TagModel      = require '../../../entities/tags/Tag'


###
Knowledge Base posts module list
=================================

@class
@augments CompositeView

###
module.exports = class ListView extends CompositeView

  template: require './templates/list.hbs'
  className: 'inner infiniteScroll'
  id: 'articlesList'

  childView: ListItemView
  childViewContainer: '.articles'
  emptyView: NoDataView

  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    InfiniteScrolling:
      behaviorClass: InfiniteScrollingBehaviour


  ###
  Inject some additional data (like the model type)
  ###
  serializeData: ->
    data = super()

    if @model
      if @model instanceof CategoryModel
        data.isCategory = true
      if @model instanceof TagModel
        data.isTag = true
    else if @collection and @collection.isSearchResults
      data.isSearch = true
      if @collection.searchQuery
        data.searchQuery = @collection.searchQuery

    data
