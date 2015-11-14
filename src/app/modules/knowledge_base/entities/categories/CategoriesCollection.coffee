# Dependencies
# -------------------------

_ = require 'underscore'

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Category model
Category = require './Category'


###
Article Categories Collection
==============================

@class
@augments Collection

###
module.exports = class CategoriesCollection extends Collection
  model: Category
  url: '/api/knowledge_base/categories'

  ###
  Default query params

  (per_page and limit are equivalent, and per_page takes precedence,
  but will be deprecated later)
  ###
  queryParams: _.extend {}, Collection::queryParams,
    limit:    100
    per_page: 100
