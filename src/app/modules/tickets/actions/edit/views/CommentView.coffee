# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'




###
Ticket comment view
====================

@class
@augments ItemView

###
module.exports = class CommentView extends ItemView

  template: require './templates/comment.hbs'
  tagName : 'li'
  className: 'comment'
