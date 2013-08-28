ContactView = require 'views/contact'

module.exports = class ContactController extends Controller

  show: ->
    @view = new ContactView