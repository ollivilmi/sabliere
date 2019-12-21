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
end

function StateMachine:addListener(listener)
	table.insert(self.listeners, listener)
end

function StateMachine:changeState(stateName, enterParams)
	self.current:exit()
	self.current = self.states[stateName]
	self.current:enter(enterParams)

	for k, listener in pairs(self.listeners) do
		listener:onStateChange(stateName)
	end
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
