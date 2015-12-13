ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Knowledge Base dashboard tag cloud block view
==============================================

@class
@augments ItemView

###
module.exports = class TagsView extends ItemView
  template: require './templates/tags.hbs'
  className: 'tags-block block list-block col-sm-6 col-md-4'

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
        link:   '#knowledge-base/tags/' + tag.get('id') + '/' + tag.get('slug')
      }


    # although everything should have been rendered and
    # the DOM should be ready, this does not work if
    # executed immediatelly, so add a little delay
    setTimeout (=>
      @$('.tags-container').jQCloud words, opts
    ), 500
