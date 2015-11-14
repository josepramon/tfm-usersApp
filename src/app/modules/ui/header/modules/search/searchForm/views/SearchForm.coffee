ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Search form widget view
========================

@class
@augments ItemView

###
module.exports = class SearchFormView extends ItemView
  template: require './templates/search.hbs'
  tagName: 'form'

  triggers:
    'submit': 'form:submit'
