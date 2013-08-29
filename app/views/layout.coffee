module.exports = class LayoutView extends View
  container: '.container'
  regions:
    header: 'header'
    main: '.page'
    footer: 'footer'
  template: require 'templates/layout'