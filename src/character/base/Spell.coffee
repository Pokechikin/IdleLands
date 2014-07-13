
_ = require "underscore"

class Spell
  name: "THIS SPELL HAS NO NAME"
  @restrictions = {}
  @stat = "mp"
  @cost = 0
  bindings: doSpellCast: ->

  calcDuration: (player) -> 0

  affect: (affected = []) ->
    @affected = [affected] if affected and not _.isArray affected
    _.each @affected, (player) =>
      turns = @calcDuration player
      if turns is 0 then @bindings.doSpellCast.apply @, [player]
      else
        player.spellsAffectedBy.push @

        _.each @bindings, (event) =>
          player.on event, @bindings[event]

  unaffect: (player) ->
    player.spellsAffectedBy = _.without player.spellsAffectedBy, @
    _.each (_.keys @bindings), (event) =>
      player.removeListener event, @bindings[event]

  constructor: (@game, @caster) ->
    @baseTargets = @caster.party.currentBattle.turnOrder
    @caster.mp.sub @cost

Spell::Element =
  # circ-shift these left to get strengths, and right to get weaknesses (truncated @ 16)
  ice: 1
  fire: 2
  water: 4
  thunder: 8
  earth: 16

  normal: 32
  energy: 64
  heal: 128

Spell::Type =
  magical: "magical"
  physical: "physical"

module.exports = exports = Spell