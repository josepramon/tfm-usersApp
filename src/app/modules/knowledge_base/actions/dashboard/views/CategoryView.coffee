_               = require 'underscore'

CompositeView   = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'
ArticleItemView = require './ArticleItemView'

moduleChannel   = require '../../../moduleChannel'


###
Knowledge Base dashboard category block view
=============================================

@class
@augments CompositeView

###
module.exports = class CategoryView extends CompositeView
  template:  require './templates/category.hbs'
  className: 'categoryBlock block col-sm-6 col-md-4'

  childView:          ArticleItemView
  childViewContainer: '.category-articles ul'

  ###
  @property {Number} max. number of articles displayed
  ###
  maxChildren: 5

  ###
  @property {Object} model events
  ###
  modelEvents:
    'change': 'render'


  initialize: (options) ->
    @collection = @model.get 'articles'


  addChild: (child, ChildView, index) ->
    if index < @maxChildren
      super child, ChildView, index
