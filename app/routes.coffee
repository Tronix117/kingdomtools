module.exports = (match) ->
  match '', 'home#show'
  match 'about', 'static#about'
  match 'contact', 'contact#show'