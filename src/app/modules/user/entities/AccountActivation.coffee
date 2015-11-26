# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n  = require 'i18next-client'


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


  ###
  Save error handler

  The API throws a 404 error if the account actvation request does not
  exist anymore (it can only be used once and automatically expire
  after certain amount of time). This is fine, but the generic error
  displayed is a bit weird in this situation. So override it and display
  something more appropiate.
  ###
  saveError: (model, xhr, options = {}) =>
    if xhr.status is 404
      @dispatchCustomValidationError
        request: [i18n.t 'user::Account activation link expired.']
    super model, xhr, options
