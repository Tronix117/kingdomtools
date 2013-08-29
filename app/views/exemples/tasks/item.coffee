module.exports = class TasksItem extends View
  tagName: 'div'
  template: require 'templates/exemples/tasks/item'
  className: 'form-group'

  listen:
    'change model': 'render'

  events:
    'click .toggle'   : 'toggle'
    'dblclick label'  : 'edit'
    'click .destroy'  : 'delete'
    'keypress .edit'  : 'save'
    'blur .edit'      : 'save'

  toggle: => @model.toggle()

  render: ->
    super
    @$('.edit').hide()

  edit: => 
    @$('label').hide()
    @$('.edit').show().focus()
    
  save: (e)=>
    return if e.type is 'keypress' and e.keyCode isnt 13
    return @delete() unless value = $(e.currentTarget).val().trim()

    @model.save title: value

    @$('.edit').hide()
    @$('label').show()

  delete: => @model.destroy()