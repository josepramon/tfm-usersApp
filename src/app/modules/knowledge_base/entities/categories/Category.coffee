# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'


###
Article category model
=======================

TODO: parent category & nested categories

@class
@augments Model

###
module.exports = class Category extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/knowledge_base/categories'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {ArticlesCollection} Articles tagged with this model
    ###
    articles: []

    ###
    @property {String} Tag name
    ###
    name: ''

    ###
    @property {String} Tag description
    ###
    description: ''

    ###
    @property {String} Slug (used on the URL)
    ###
    slug: null



  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.Many
      key:            'articles'
      collectionType: -> factory.invoke 'kb:entities|ArticlesCollection'
  ]


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand. It accepts just the attribute names
                                              or objects with the options, for example:
                                              {
                                                attribute: 'foo',
                                                page: 4,
                                                limit: 200,
                                                sort: {id: 1, name: -1}
                                              }
  @static
  ###
  @expandedRelations: [{ attribute: 'articles', sort: {'publish_date':-1} }, 'articles.tags', 'articles.category']


  ###
  @property {Object} Virtual fields
  ###
  computed:
    articles_total:
      get: ->
        articles = @get 'articles'
        total    = if articles and articles.state then articles.state.totalRecords
        unless total then total = 0
        total
      transient: true
