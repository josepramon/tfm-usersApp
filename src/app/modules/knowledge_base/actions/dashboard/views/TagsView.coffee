ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Knowledge Base dashboard tag cloud block view
==============================================

@class
@augments ItemView

###
module.exports = class TagsView extends ItemView
  template: require './templates/tags.hbs'
  className: 'tagsBlock block col-md-6'

  onRender: ->
    opts =
      autoResize: true
      height:     200

    tags = @model.get 'tags'

    words = tags.map (tag) ->
      tagWeight = tag.get('articles')?.state?.totalRecords or 0
      {
        text:   tag.get 'name'
        weight: tagWeight
        link:   '#knowledge-base/tags/' + tag.get('id')
      }


    # although everything should have been rendered and
    # the DOM should be ready, this does not work if
    # executed immediatelly, so add a little delay
    setTimeout (=>
      @$('.panel-body').jQCloud words, opts
    ), 500
