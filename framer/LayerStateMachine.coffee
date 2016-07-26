# {_} = require "./Underscore"
#
# {Events} = require "./Events"
{BaseClass} = require "./BaseClass"
# {Defaults} = require "./Defaults"

{LayerStates} = require "./LayerStates"

class exports.LayerStateMachine extends BaseClass
	constructor: (layer) ->
		super
		@_previousNames = []
		@_layer = layer
		@currentName = 'initial'
		@initial = LayerStates.filterStateProperties(layer.props)
		@states = new LayerStates(@)

	@define "current",
		get: -> @states[@currentName]

	@define "previous",
		get: -> @states[@previousName]

	@define "previousName",
		get: -> _.last(@_previousNames)

	@define "stateNames",
		get: -> _.keys(@states)

	switchTo: (stateName) ->
		properties = @states[stateName]
		if not properties?
			throw Error "No such state: '#{stateName}'"
		@emit(Events.StateWillSwitch, @currentName, stateName, @)
		@_previousNames.push(@currentName)
		@currentName = stateName
		properties

	next: (states) ->
		if not states.length
			states = @stateNames
		Utils.arrayNext(states, @currentName)

	emit: (args...) ->
			super
			# Also emit this to the layer with self as argument
			@_layer.emit args...
