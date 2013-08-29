module.exports = class Model extends Chaplin.Model
  # Mixin a synchronization state machine
  # _(@prototype).extend Chaplin.SyncMachine

  #initialize: ->
  #  if @timestamps
  #    if @isNew()
  #      @set 
  #        'created_at': d = new Date()
  #        'updated_at': d
  #    @on 'change', 'afterChange'
  #  super


  initialize: ->
    super
    if @timestamps and @isNew()
      @set {'created_at': d = new Date(),  'updated_at': d}, silent: true
  
  save: ->
    @set {updated_at: new Date()}, silent: true if @timestamps
    super