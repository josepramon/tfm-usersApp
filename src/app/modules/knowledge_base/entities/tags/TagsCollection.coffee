# Dependencies
# -------------------------

_ = require 'underscore'

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Tag model
Tag = require './Tag'


###
Tags Collection
===================

@class
@augments Collection

###
module.exports = class TagsCollection extends Collection
  model: Tag
  url: '/api/knowledge_base/tags'

  ###
  Default query params

  (per_page and limit are equivalent, and per_page takes precedence,
  but will be deprecated later)
  ###
  queryParams: _.extend {}, Collection::queryParams,
    limit:    50
    per_page: 50


