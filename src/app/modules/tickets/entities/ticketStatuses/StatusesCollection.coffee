# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Status model
Status= require './Status'


###
Tickets Statuses Collection
==============================

@class
@augments Collection

###
module.exports = class TicketStatusesCollection extends Collection
  model: Status
