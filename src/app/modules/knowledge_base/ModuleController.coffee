# Dependencies
# -----------------------

_          = require 'underscore'
Backbone   = require 'backbone'
StringUtil = require 'msq-appbase/lib/utilities/string'

# Base class (extends Marionette.Controller)
Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Models/collection cache
EntitiesCache = require './entities/Cache'

# Action controllers
DashboardController = require './actions/dashboard/DashboardController'
ListController      = require './actions/list/ListController'
ArticleController   = require './actions/article/ArticleController'




###
Knowledge Base main controller
=======================================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller

  constructor: ->
    @cache = new EntitiesCache()


  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)

  ###
  Initial route
  ###
  dashboard: ->
    new DashboardController
      categoriesCollection:  @cache.getCategoriesCollection()
      tagsCollection:        @cache.getTagsCollection()
      uncategorizedCategory: @cache.getUncategorizedArticles()


  ###
  This is a special method due to this controller being mounted at the root url
  It's invoked when the root module url is called
  ###
  redirectToRoot: ->
    Backbone.history.navigate('', { trigger: true })


  ###
  List all the articles
  ###
  list: (model, collection) ->
    options = {}

    if model
      options.model = model
    else
      options.collection = collection or @cache.getArticlesCollection()

    new ListController options



  ###
  List all the articles for some category

  @param {String}   categoryId  Category id
  @param {String}   slug        Category slug (currently not used)
  @param {Category} category    Category model
  ###
  listByCategory: (categoryId, slug, category) ->
    model = if category then category else @cache.getCategoryModel categoryId
    @list model


  ###
  List all the articles forthat don't belong to any category
  ###
  listUncategorized: ->
    model = @cache.getUncategorizedArticles()
    @list model


  ###
  List all the articles for some tag

  @param {String} tagId     Tag id
  @param {String} slug      Tag slug (currently not used)
  @param {Tag}    category  Tag model
  ###
  listByTag: (tagId, slug, tag) ->
    model = if tag then tag else @cache.getTagModel tagId
    @list model


  ###
  Display an article

  @param {String}  articleId  Article id
  @param {String}  slug       Article slug (currently not used)
  @param {Article} model      Article model
  ###
  showArticle: (articleId, slug, article) ->
    article or= @cache.getArticleModel articleId

    new ArticleController
      id:    articleId
      model: article


  ###
  List all the articles that match some query

  @param {String} query
  ###
  search: (query) ->
    # there's no need to cache this
    filterParam = StringUtil.escapeQueryParam query

    results = @appChannel.request 'kb:articles:entities',
      filters: ['isPublished', "search:#{filterParam}"]

    # add some custom attributes (so it can be rendered in a special way or whatever)
    results.isSearchResults = true
    results.searchQuery     = query


    @list null, results



  # Events
  # ------------------------

  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: ->
    @cache.reset()
