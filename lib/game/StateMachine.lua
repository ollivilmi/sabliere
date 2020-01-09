require 'lib/game/State'
require 'lib/language/Listener'

StateMachine = Class{__includes = Listener}

function StateMachine:init(states)
	Listener:init(self)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
	self.state = ''
end

function StateMachine:changeState(newState, enterParams)
	if self.state ~= newState then

		self.current:exit()
		self.current = self.states[newState]
		self.current:enter(enterParams)
		self.state = newState

		self:broadcastEvent('STATE CHANGED', newState)
	end
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
