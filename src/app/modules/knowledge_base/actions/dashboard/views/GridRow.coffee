_        = require 'underscore'
Backbone = require 'backbone'

CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

CategoryView = require './CategoryView'
TagsView     = require './TagsView'

# Just to check the model type (the constructor.name is useless
# because the name is mangled by the minifier)
CategoryModel = require '../../../entities/categories/Category'


###
Knowledge Base dashboard grid view
===================================

@class
@augments CompositeView

###
module.exports = class DashboardGridRowView extends CompositeView
  template: require './templates/row.hbs'

  childViewContainer: '.row'

  initialize: ->
    @collection = new Backbone.Collection(_.toArray(@model.attributes))

  getChildView: (child) ->
    if child instanceof CategoryModel then CategoryView else TagsView
