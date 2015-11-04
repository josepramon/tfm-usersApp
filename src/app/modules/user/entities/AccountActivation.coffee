# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'




###
Account activation model
=========================

@class
@augments Model

###
module.exports = class AccountActivation extends Model

  # @property [String] API url
  urlRoot: '/api/auth/activate/users'

  # this is a special model used only to activate a preexisting user
  # so a 'POST' request should never be performed
  isNew: -> false
