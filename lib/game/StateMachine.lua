require 'lib/game/State'

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
	self.listeners = {}
	self.state = ''
end

function StateMachine:addListener(listener, callback)
	table.insert(self.listeners, callback)
end

function StateMachine:changeState(newState, enterParams)
	if self.state ~= newState then
		self.current:exit()
		self.current = self.states[newState]
		self.current:enter(enterParams)
		self.state = newState

		for k, callback in pairs(self.listeners) do
			callback(newState)
		end
	end
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
