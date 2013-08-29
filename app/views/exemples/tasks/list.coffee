TasksItemView = require 'views/exemples/tasks/item'

module.exports = class TasksList extends CollectionView
  itemView: TasksItemView
  listSelector: '.task-list'
  template: require 'templates/exemples/tasks/index'

  events:
    'keydown input.new': 'create'

  create: (e)=>
    $input = $(e.currentTarget)

    # We do nothing except the keydown is Enter or Escape
    return if e.type is 'keydown' and -1 is [13, 27].indexOf e.keyCode

    # We create a task only if the user didn't press escape
    unless e.type is 'keydown' and e.keyCode is 27
      @collection.create {title: $input.val()}
      #@collection.sort()

    # We empty the input
    $input.val ''