# Dependencies
# -----------------------

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Article view
=======================

@class
@augments ItemView

###
module.exports = class ArticleView extends ItemView
  template: require './templates/article.hbs'
