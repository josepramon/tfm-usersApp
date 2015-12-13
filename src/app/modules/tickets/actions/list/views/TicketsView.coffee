LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


# Tickets main view
#
module.exports = class Tickets extends LayoutView

  template: require './templates/tickets.hbs'

  className: 'inner'

  regions:
    list:  '#ticketsList'
    form:  '#ticketsCreate'

  childEvents:
    'filter:open':   'filterOpenTickets'
    'filter:closed': 'filterClosedTickets'

  # Event handlers for the nested view filter buttons
  # Just bubble up the event to the controller
  filterOpenTickets:   -> @triggerMethod 'filter', false
  filterClosedTickets: -> @triggerMethod 'filter', true
