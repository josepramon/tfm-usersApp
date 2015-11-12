# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
Backbone  = require 'backbone'
dateUtil  = require 'msq-appbase/lib/utilities/date'
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'


###
Article model
==============

@class
@augments Model

###
module.exports = class Article extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/knowledge_base/articles'


  ###
  @property {Object} Model default attributes
  ###
  defaults:

    ###
    @property {Boolean} Publish status
    ###
    published: false

    ###
    @property {Number} Publish date (as a timestamp)
    ###
    publish_date: null

    ###
    @property {Boolean} Enable commenting
    ###
    commentable: true

    ###
    @property {TagsCollection} Post tags
    ###
    tags: []

    ###
    @property {Category} Post category
    ###
    category: null

    ###
    @property {String} Article title
    ###
    title: ''

    ###
    @property {String} Slug (used on the URL)
    ###
    slug: null

    ###
    @property {String} Article summary
    ###
    excerpt: ''

    ###
    @property {String} Article content
    ###
    body: ''


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:                 Backbone.Many
      key:                  'tags'
      collectionType:->     factory.invoke 'kb:entities|TagsCollection'
      saveFilterAttributes: ['id', 'name']
    ,
      type:                 Backbone.One
      key:                  'category'
      relatedModel:->       factory.invoke 'kb:entities|Category'
      saveFilterAttributes: ['id', 'name']
  ]


  ###
  Relations to expand where querying the server

  This is also used by the ArticleCollection, but can
  be overrided there by setting a expandedRelations on
  the collection

  @property {Array} the attributes to expand. It accepts just the attribute names
                                              or objects with the options, for example:
                                              {
                                                attribute: 'foo',
                                                page: 4,
                                                limit: 200,
                                                order: {id: 1, name: -1}
                                              }
  @static
  ###
  @expandedRelations: ['tags', 'category']


  ###
  Timestamp fields

  js represents timestamps in miliseconds but the API represents that in seconds
  this fields will be automatically converted when fetching/saving

  @property {String[]} the attributes to transform
  ###
  timestampFields: ['created_at', 'updated_at', 'publish_date']


  ###
  @property {Object} Virtual fields
  ###
  computed:
    publishStatus:
      depends: ['published', 'publish_date']
      ###
      @return {String} the article publish status ('published'|'unpublished'|'scheduled')
      ###
      get: (fields) ->
        status  = if fields.published then 'published' else 'unpublished'
        pubDate = fields.publish_date

        if !pubDate
          return status
        else
          now     = new Date()
          pubDate = new Date pubDate
          if now < pubDate then 'scheduled' else status

      transient: true

    publishDate:
      depends: ['publish_date']
      ###
      @return {Object} the date object (something like {date: "2015-05-23", time: "18:17:56"})
      ###
      get: (fields) ->
        dateUtil.splitDateTime fields.publish_date

      transient: true
