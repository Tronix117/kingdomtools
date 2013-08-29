TaskModel = require 'models/task'

module.exports = class TasksCollection extends Collection
  model: TaskModel
  localStorage: new Store('tasks')