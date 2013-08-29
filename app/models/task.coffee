module.exports = class Task extends Model
  localStorage: new Store('tasks')

  defaults:
    title: "untitled task..."
    description: ""
    done: false
  
  timestamps: true

  toggle: -> @save done: not @get 'done'