Router = require 'msq-appbase/lib/appBaseComponents/Router'


###
Knowledge base router
======================

@class
@augments Router

###
module.exports = class ModuleRouter extends Router

  ###
  Override the _getRouteRegex method because of the '' route
  ###
  _getRouteRegex: (moduleUrl) -> new RegExp "^($|#{moduleUrl})"


  ###
  @property {Object} Module routes
  ###
  appRoutes:
    '' : 'dashboard'


  ###
  @property {Object} Module routes
                     similar to Marionette's appRoutes
                     but automatically prefixed with the
                     module rootUrl (supplied in the constructor)
  ###
  prefixedAppRoutes:
    '/articles'                 : 'list'
    '/articles/:id(/:slug)'     : 'showArticle'
    '/categories/:id(/:slug)'   : 'listByCategory'
    '/categories/uncategorized' : 'listUncategorized'
    '/tags/:id(/:slug)'         : 'listByTag'
    '/search/:query'            : 'search'

    # not used routes, redirect to the main section
    ''                : 'redirectToRoot'
    '/categories'     : 'redirectToRoot'
    '/tags'           : 'redirectToRoot'
    '/search'         : 'redirectToRoot'
