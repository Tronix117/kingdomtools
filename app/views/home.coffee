module.exports = class IndexView extends View
  className: 'index-view'
  region: 'main'
  template: require 'templates/home'

  events:
    'click #btn-home-signup': 'signupAction'

  signupAction: (e)->
    @$('#btn-home-signup').fadeOut()
    @$('#form-home-signup').slideDown()