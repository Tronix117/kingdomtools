###
# Backbone localStorage Adapter
# https://github.com/jeromegn/Backbone.localStorage
###

# A simple module to replace Backbone.sync with localStorage-based persistence. Models are given GUIDS, and saved into a JSON object. Simple as that.

#Hold reference to Underscore.js and Backbone.js in the closure in order to make things work even if they are removed from the global namespace
_ = @_
Backbone = @Backbone

# Generate four random hex digits.
S4 = -> (((1+Math.random())*0x10000)|0).toString(16).substring(1)

# Generate a pseudo-GUID by concatenating random hexadecimal.
guid = -> (S4()+S4()+'-'+S4()+'-'+S4()+'-'+S4()+'-'+S4()+S4()+S4())

# Our Store is represented by a single JS object in localStorage. Create it with a meaningful name, like the name you'd give a table. window.Store is deprectated, use Backbone.LocalStorage instead
Backbone.LocalStorage = class LocalStorage

  constructor: (name)->
    @name = name
    store = @localStorage().getItem(this.name)
    @records = (store and store.split(",")) or []

  # Save the current state of the Store to localStorage.
  save: -> @localStorage().setItem(@name, @records.join(','))

  # Add a model, giving it a (hopefully)-unique GUID, if it doesn't already have an id of it's own.
  create: (model)->
    if not model.id
      model.id = guid()
      model.set model.idAttribute, model.id
    @localStorage().setItem "#{@name}-#{model.id}", JSON.stringify model
    @records.push model.id.toString()
    @save()
    model.toJSON()

  # Update a model by replacing its copy in this.data.
  update: (model)->
    @localStorage().setItem "#{@name}-#{model.id}", JSON.stringify model
    @records.push(model.id.toString()) if not _.include @records, model.id.toString()
    @save();
    model.toJSON()

  # Retrieve a model from this.data by id.
  find: (model)-> JSON.parse this.localStorage().getItem "#{@name}-#{model.id}"

  # Return the array of all models currently in storage.
  findAll: ->
    _(@records).chain()
      .map(((id)-> JSON.parse(@localStorage().getItem("#{@name}-#{model.id}"))), @)
      .compact()
      .value()

  # Delete a model from this.data, returning it.
  destroy: (model)->
    @localStorage().removeItem("#{@name}-#{model.id}")
    @records = _.reject(@records, (record_id)-> record_id is model.id.toString())
    @save()
    model

  localStorage: -> localStorage

# localSync delegate to the model or collection's localStorage property, which should be an instance of Store. window.Store.sync and Backbone.localSync is deprectated, use Backbone.LocalStorage.sync instead
Backbone.LocalStorage.sync = (method, model, options, error)->
    store = model.localStorage or model.collection.localStorage

    # Backwards compatibility with Backbone <= 0.3.3
    options = success: options, error: error if typeof options is 'function'

    switch method
      when 'read'   then resp = (if model.id isnt undefined then store.find(model) else store.findAll())
      when 'create' then resp = store.create model
      when 'update' then resp = store.update model
      when 'delete' then resp = store.destroy model

    if resp then options.success(resp) else options.error('Record not found.')

Backbone.localSync = Backbone.LocalStorage.sync
Backbone.ajaxSync = Backbone.sync

Backbone.getSyncMethod = (model)->
  return Backbone.localSync if model.localStorage or (model.collection and model.collection.localStorage)
  Backbone.ajaxSync

# Override 'Backbone.sync' to default to localSync, the original 'Backbone.sync' is still available in 'Backbone.ajaxSync'
#Backbone.sync = (method, model, options, error)-> Backbone.getSyncMethod(model).apply @, [method, model, options, error]


module.exports = Backbone