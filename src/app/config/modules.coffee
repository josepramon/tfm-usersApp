###
Application submodules
=======================

Right now loading and starting them all, but this can be changed if the
modules are loaded conditionally according to the user privileges, or
something like that

@type {Array}

###
module.exports = [
    id:    'User'
    class: require 'modules/user'
    submodules: [
      id:    'Register'
      class: require 'modules/user/modules/register'
    ]
  ,
    id:    'Uploads'
    class: require 'modules/uploads'
  ,
    id:    'KnowledgeBase'
    class: require 'modules/knowledge_base'
  ,
    id:    'Tickets'
    class: require 'modules/tickets'
  ,
    id: 'UI'
    submodules: [
      id:    'Header'
      class: require 'modules/ui/header'
      submodules: [
        id:    'HeaderNav'
        class: require 'modules/ui/header/modules/headerNav'
      ,
        id:    'User'
        class: require 'modules/ui/header/modules/user'
      ,
        id:    'Search'
        class: require 'modules/ui/header/modules/search'
      ]
    ,
      id:    'Footer'
      class: require 'modules/ui/footer'
    ]
]
