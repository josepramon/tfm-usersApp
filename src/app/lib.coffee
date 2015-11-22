###
3rd party deppendencies
========================
###


# General utilities
# -----------------------------------------------
_                  = require 'underscore'
_s                 = require 'underscore.string'
i18n               = require 'i18next-client'

# Moment:
# -------
Moment = require 'moment'

# load the locales (this is an autogenerated file)
require './lib-momentLocales.coffee'

# restore the default locale
Moment.locale 'en'


# make jQuery global so it can be used by plugins and other libs.
window.$ = window.jQuery = require 'jquery'



# Backbone, Marionette and related libs
# -----------------------------------------------
Backbone           = require 'backbone'
Backbone.$         = $ # attach jQuery to Backbone
Marionette         = require 'backbone.marionette'
Radio              = require 'backbone.radio'
Syphon             = require 'backbone.syphon'
WebStorage         = require 'backbone.webStorage'
PageableCollection = require 'backbone.paginator'
Associations       = require 'backbone-associations'
Computedfields     = require 'backbone-computedfields'
Validation         = require 'backbone-validation'
Select             = require 'backbone.select'
Backgrid           = require 'backgrid'
BackgridPaginator  = require 'backgrid-paginator'
BackgridMomentCell = require 'backgrid-moment-cell'



# Other stuff
# -----------------------------------------------
Enquire            = require 'enquire.js'
Bootstrap          = require 'bootstrap'
toastr             = require 'toastr'
dropzone           = require 'dropzone'
bootbox            = require 'bootbox'



# jQuery plugins
# -----------------------------------------------
require 'jquery-scrollstop'
require 'selectize'
require 'jqcloud2'
