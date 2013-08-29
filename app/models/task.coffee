module.exports = class Task extends Model
  localStorage: new Store('tasks')

  defaults:
    title: "untitled task..."
    description: ""
    done: false
    created_at: new Date()

  toggle: -> @save done: not @get 'done'