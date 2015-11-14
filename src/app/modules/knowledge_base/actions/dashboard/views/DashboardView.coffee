_        = require 'underscore'
Backbone = require 'backbone'

CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

CategoryView = require './CategoryView'
TagsView     = require './TagsView'

# Just to check the model type (the constructor.name is useless
# because the name is mangled by the minifier)
CategoryModel = require '../../../entities/categories/Category'



###
Knowledge Base dashboard view
==============================

@class
@augments CompositeView

###
module.exports = class DashboardView extends CompositeView
  template: require './templates/dashboard.hbs'
  className: 'kbDashboard'

  childViewContainer: '.blocks'

  getChildView: (child) ->
    if child instanceof CategoryModel then CategoryView else TagsView

  initialize: (options) ->
    { @categoriesCollection, @tagsCollection, @uncategorizedModel } = options


  onBeforeRender: ->
    # clone the data so the original collection is not altered
    data = @categoriesCollection.deepClone()

    # merge and group the data so it can be displayed on a grid
    # without creating explicitelly the containers
    data.add @uncategorizedModel

    tagsCollectionWrapper = new Backbone.Model
      tags: @tagsCollection

    data.add tagsCollectionWrapper

    @collection = data
