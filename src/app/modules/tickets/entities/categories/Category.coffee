# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'


###
Ticket category model
=======================

@class
@augments Model

###
module.exports = class Category extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/tickets/categories'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {String} Category name
    ###
    name: ''

    ###
    @property {String} Category description
    ###
    description: ''


  ###
  @property {Object} Model validation rules
  ###
  validation:
    name:
      required: true


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    name            : -> i18n.t 'tickets::CategoryModel::Name'
    description     : -> i18n.t 'tickets::CategoryModel::Description'
