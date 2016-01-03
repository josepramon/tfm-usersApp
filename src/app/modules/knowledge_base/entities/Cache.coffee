i18n   = require 'i18next-client'
Object = require 'msq-appbase/lib/appBaseComponents/Object'


module.exports = class EntitiesCache extends Object

  reset: ->
    delete @articlesCollection
    delete @uncategorizedArticlesCollection
    delete @categoriesCollection
    delete @tagsCollection


  ###
  Entities getters
  -------------------

  The collections are used by all the actions in the module,
  so load them and cache it locally whenever possible
  ###


  ###
  @return {ArticlesCollection} Collection containing all the published articles
  ###
  getArticlesCollection: ->
    unless @articlesCollection
      @articlesCollection = @appChannel.request 'kb:articles:entities',
        filters: ['isPublished']
        sort: {'weight': -1, 'publish_date': -1}

    @articlesCollection


  ###
  @return {CategoriesCollection} Collection containing all the categories with articles
  ###
  getCategoriesCollection: ->
    unless @categoriesCollection
      @categoriesCollection = @appChannel.request 'kb:categories:entities',
        filters: ['hasArticles', 'articles.isPublished']
        sort: {'weight': -1}
    @categoriesCollection


  ###
  @return {TagsCollection} Collection containing all the tags with articles
  ###
  getTagsCollection: ->
    unless @tagsCollection
      @tagsCollection = @appChannel.request 'kb:tags:entities',
        filters: ['hasArticles', 'articles.isPublished']
    @tagsCollection


  ###
  @return {CategoryModel} category model with the uncategorized articles
  ###
  getUncategorizedArticles: ->
    unless @uncategorizedArticlesCollection
      @uncategorizedArticlesCollection = @appChannel.request 'kb:articles:entities',
        filters: ['isPublished', { 'hasCategory' : false }]
        sort: {'weight': -1, 'publish_date': -1}

    uncategorizedModel = @appChannel.request 'new:kb:categories:entity'
    uncategorizedModel.set
      name:     i18n.t 'Uncategorized'
      slug:     'uncategorized'

    @appChannel.request 'when:fetched', @uncategorizedArticlesCollection, =>
      if @uncategorizedArticlesCollection
        uncategorizedModel.set
          articles: @uncategorizedArticlesCollection
          articles_total: @uncategorizedArticlesCollection.state.totalRecords

        # the state is lost on the setter
        uncategorizedModel.get('articles').state = @uncategorizedArticlesCollection.state

    uncategorizedModel


  ###
  @param  {String} model id
  @return {Article}
  ###
  getArticleModel: (articleId) ->
    # first try to retrieve the article from any of the available collections
    # (some of them may not be loaded, everything is lazy loaded)

    # try to retrieve from the articlesCollection
    if @articlesCollection and @articlesCollection.models.length
      model = @articlesCollection.get articleId
      if model then return model

    # try to retrieve from the uncatecorized articlesCollection
    if @uncategorizedArticlesCollection and @uncategorizedArticlesCollection.models.length
      model = @uncategorizedArticlesCollection.get articleId
      if model then return model

    # try to retrieve from the categoriesCollection nested collections
    if @categoriesCollection and @categoriesCollection.models.length
      for category in @categoriesCollection.models
        collection = category.get 'articles'
        model      = collection.get articleId
        if model then return model

    # if not found, load it from the server
    @appChannel.request 'kb:articles:entity', articleId,
      filters: ['isPublished']


  ###
  @param  {String} model id
  @return {Category}
  ###
  getCategoryModel: (categoryId) ->
    if @categoriesCollection and @categoriesCollection.models.length
      model = @categoriesCollection.get categoryId
      if model then return model

    @appChannel.request 'kb:categories:entity', categoryId,
      filters: ['hasArticles', 'articles.isPublished']



  ###
  @param  {String} model id
  @return {Tag}
  ###
  getTagModel: (tagId) ->
    if @tagsCollection and @tagsCollection.models.length
      model = @tagsCollection.get tagId
      if model then return model

    @appChannel.request 'kb:tags:entity', tagId,
      filters: ['hasArticles', 'articles.isPublished']

