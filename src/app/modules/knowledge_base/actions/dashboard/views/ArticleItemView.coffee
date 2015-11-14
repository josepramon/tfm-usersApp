_        = require 'underscore'
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


module.exports = class ArticleItemView extends ItemView
  template: require './templates/articleItem.hbs'
  tagName:  'li'
