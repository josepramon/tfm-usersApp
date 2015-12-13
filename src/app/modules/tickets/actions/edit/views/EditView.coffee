_        = require 'underscore'
Backbone = require 'backbone'

CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

# Aux. views
CommentView    = require './CommentView'
NoCommentsView = require './NoCommentsView'



###
Tickt view
==============================

@class
@augments CompositeView

###
module.exports = class TicketView extends CompositeView
  template: require './templates/ticket.hbs'

  childViewContainer: '.ticketComments .comments'
  childView: CommentView
  emptyView: NoCommentsView

  triggers:
    'click #addComment':   'ticket:comment:add'
    'click #closeTicket':  'ticket:close'
    'click #reopenTicket': 'ticket:reopen'


  ###
  @property {Object} model events
  ###
  modelEvents:
    'change': 'render'
