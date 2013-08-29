TasksItemView = require 'views/exemples/tasks/item'

module.exports = class TasksList extends CollectionView
  tagName: 'div'
  itemView: TasksItemView