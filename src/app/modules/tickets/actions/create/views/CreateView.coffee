# Dependencies
# -----------------------

# Libs/generic stuff:
_               = require 'underscore'
i18n            = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView        = require 'msq-appbase/lib/appBaseComponents/views/ItemView'

# View behaviours
EditorBehaviour = require 'msq-appbase/lib/behaviours/Editor'




###
Ticket create view
=======================

@class
@augments ItemView

###
module.exports = class TicketCreateView extends ItemView
  template: require './templates/create.hbs'
  className: 'sectionContainer'

  ui:
    'categorySelect' : '#category'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    Editor:
      behaviorClass: EditorBehaviour


  ###
  @property {Object} form config.
  ###
  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Create'
          icon: 'check'


  initialize: (options) ->
    @categories = options.categories
    super()


  ###
  Inject some additional data
  ###
  serializeData: ->
    ret = @model.toJSON()
    ret.categories = @categories.invoke 'pick', 'id', 'name'
    ret


  onRender: ->
    @setupUploader()

    # init the category field
    categoryModels = @categories?.models

    if categoryModels
      # preselect the only available category
      if categoryModels.length is 1
        # syphon overrides the input value on render
        # because the model does not have a category yet
        setTimeout(=>
          @ui.categorySelect.val categoryModels[0].id
        , 200)
      else
        # initialize the dropdown
        @ui.categorySelect.selectize()




  # Uploader related methods

  ###
  Template used in the attachment editing modal
  ###
  modalTmpl: require './templates/attachmentsModal.hbs'


  ###
  Attachments uploader initialization
  ###
  setupUploader: ->
    _this = @

    # uploader settings
    opts =
      addRemoveLinks: true
      clickedfile: _this.handleUploadClick

      # override the serialitarion methods
      serialize:   _this.serializeUpload
      deserialize: _this.deserializeUpload

    # instantiate the uploader
    uploader = @appChannel.request 'uploader:component', @$('#attachments'), opts, []


  ###
  Click handler for the files

  Opens a modal with a form to set th attachment metadata
  ###
  handleUploadClick: (file) =>
    form = $(@modalTmpl(file))
    form.on 'submit', -> false

    @appChannel.request 'dialogs:confirm', form, (result) ->
      if result
        data = form.serializeArray()
        data.forEach (param) -> file.set param.name, param.value


  ###
  Uploader component serialize method override
  ###
  serializeUpload: (file) ->
    ret =
      name:        file.name
      description: file.description
      upload:      file.uploadModel?.toJSON()


  ###
  Uploader component deserialize method override
  ###
  deserializeUpload: (obj) ->
    name:   obj.name
    size:   obj.upload?.size,
    type:   obj.upload?.contentType
    url:    obj.upload?.url
    upload: obj.upload
