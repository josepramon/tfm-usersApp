# Dependencies
# -------------------------

_ = require 'underscore'

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Article model
Article = require './Article'


###
Article Collection
===================

@class
@augments Collection

###
module.exports = class ArticlesCollection extends Collection
  model: Article
  url: '/api/knowledge_base/articles'

  ###
  Default query params

  (per_page and limit are equivalent, and per_page takes precedence,
  but will be deprecated later)
  ###
  queryParams: _.extend {}, Collection::queryParams,
    limit:    10
    per_page: 10
