_        = require 'underscore'
Backbone = require 'backbone'

CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

GridRow = require './GridRow'


###
Knowledge Base dashboard view
==============================

@class
@augments CompositeView

###
module.exports = class DashboardView extends CompositeView
  template: require './templates/dashboard.hbs'
  className: 'kbDashboard'

  childView: GridRow
  childViewContainer: '.blocks'

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

    grid = data.groupBy (list, iterator) ->
      Math.floor iterator / 2

    @collection = new Backbone.Collection _.toArray(grid)
