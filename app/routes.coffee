module.exports = (match) ->
  match '', 'default#home'
  match 'about', 'default#about'
  match 'contact', 'default#contact'

  ##
  # Exemples
  # 
   
  # Task manager
  match 'exemples/tasks', 'exemples/tasks#index'
  match 'exemples/tasks/new', 'exemples/tasks#create'
  match 'exemples/tasks/:id', 'exemples/tasks#show', constraints: {id: /^\d+$/}
  match 'exemples/tasks/:id/edit', 'exemples/tasks#edit', constraints: {id: /^\d+$/}