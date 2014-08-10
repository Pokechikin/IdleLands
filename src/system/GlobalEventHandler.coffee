
Constants = require "./Constants"

_ = require "underscore"

class GlobalEventHandler

  constructor: (@game) ->
    @initializeEventTimers()

  initializeEventTimers: ->
    timers = Constants.globalEventTimers
    _.each timers, (timer) =>
      setInterval (@doEvent.bind @,timer.type), timer.duration*1000

  doEvent: (event) ->
    switch event
      when 'battle'
        do @doBattle

  doBattle: ->
    @game.componentDatabase.getRandomEvent 'battle', (e, event) =>
      event.player = @game.playerManager.randomPlayer()
      @game.startBattle [], event

module.exports = exports = GlobalEventHandler