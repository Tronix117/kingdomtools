Task = require 'models/task'

class Tasks extends Collection
  model: Task
  localStorage: new Store('tasks')

  comparator: 'created_at'

  # Filter for finished tasks
  done: -> @where done:true

  # Filter for ramaining tasks
  remaining: -> @without.apply @, @done()


# Conventionnaly, we declare our collections as Singleton 
# `require 'collection'` actualy caches the response
module.exports = new Tasks