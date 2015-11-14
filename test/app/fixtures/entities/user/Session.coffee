faker = require 'faker'

module.exports = ->
  token          : faker.random.uuid()
  token_iat      : parseInt faker.date.recent().getTime(), 10
  token_exp      : parseInt faker.date.future().getTime(), 10
  user:
    id:         faker.random.uuid()
    username:   faker.internet.userName()
    email:      faker.internet.email()
    role:       'User'
    privileges: {}
