# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'




###
Knowledge Base posts module list item
======================================

@class
@augments ItemView

###
module.exports = class ListItemView extends ItemView

  template: require './templates/item.hbs'
  tagName : 'li'
  className: 'articleListItem'
