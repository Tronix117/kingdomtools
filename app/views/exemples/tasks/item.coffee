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
    'keydown .edit'  : 'save'
    'blur .edit'      : 'save'

  toggle: => @model.toggle()

  render: ->
    super
    @$('.edit').hide()

  edit: => 
    @$('label').hide()
    @$('.edit').show().focus()
    
  save: (e)=>
    $input = $(e.currentTarget)

    # We do nothing except the keydown is Enter or Escape
    return if e.type is 'keydown' and -1 is [13, 27].indexOf e.keyCode

    # If keydown is Escape, we reset the modification
    $input.val(@model.get('title')) if e.type is 'keydown' and e.keyCode is 27

    # If title is empty then we remove this task
    return @delete() unless value = $input.val().trim()

    # Otherwise, we save it
    # 
    # `silent: true` means the change event will not be fired...
    @model.save {title: value}, silent: true

    # ... indeed, we want to do it manualy, it will automaticaly refresh this
    # view. If we don't do it manualy, and if the title hasn't change, the
    # view will not be refreshed, and we will still be in edit mode.
    @model.trigger 'change'

  delete: => @model.destroy()