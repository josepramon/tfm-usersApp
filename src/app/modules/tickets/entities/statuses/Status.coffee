
# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n  = require 'i18next-client'


###
Ticket status model
=======================

@class
@augments Model

###
module.exports = class Status extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/tickets/statuses'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {String} Status name
    ###
    name: ''

    ###
    @property {String} Status description
    ###
    description: ''

    ###
    @property {Number} Order in the tickets flow sequence
                       for example open->in progress->closed
    ###
    order: 0


  ###
  @property {Object} Model validation rules
  ###
  validation:
    name:
      required: true
    order:
      required: true
      pattern: 'number'


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    name        : -> i18n.t 'tickets::StatusModel::Name'
    description : -> i18n.t 'tickets::StatusModel::Description'
    order       : -> i18n.t 'tickets::StatusModel::Order'
