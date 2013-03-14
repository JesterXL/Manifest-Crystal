BattleTimer = {}
BattleTimer.MODE_CHARACTER = "character"
BattleTimer.MODE_MONSTER   = "monster"

function BattleTimer:new(mode)

	local battleTimer          = display.newGroup()
	battleTimer.classType 		= "BattleTimer"
	-- TODO: need a setter for this
	battleTimer.EFFECT_NORMAL  = 96
	battleTimer.EFFECT_HASTE   = 126
	battleTimer.EFFECT_SLOW    = 48
	
	battleTimer.MAX            = 65536
	battleTimer.TIME_SLICE     = 33
	
	battleTimer.lastTick       = 0
	
	battleTimer.speed          = 0
	battleTimer.battleSpeed    = 128
	battleTimer.effect         = battleTimer.EFFECT_NORMAL
	battleTimer.mode           = nil
	
	battleTimer.gauge          = 0
	battleTimer.modeFunction   = nil
	battleTimer.enabled        = true
	battleTimer.running 		= false

	function battleTimer:getProgress()
		return self.gauge / self.MAX
	end

	function battleTimer:setEnabled(value)
		if value ~= self.enabled then
			self.enabled = value
			if self.enabled == false then
				self:stop()
			end
		end
	end 

	function battleTimer:setMode(newMode)
		assert(newMode ~= nil, "newMode cannot be nil")
		self.mode = newMode
		-- HACK/KLUDGE/HARDCODE
		self.mode = BattleTimer.MODE_CHARACTER
		if self.mode == BattleTimer.MODE_CHARACTER then
			self.modeFunction = self.onCharacterTick
		else
			self.modeFunction = self.onMonsterTick
		end
	end

	function battleTimer:start()
		if self.enabled == false then
			return false
		end
		if self.running == false then
			self.running = true
			gameLoop:addLoop(self)
		end
	end

	function battleTimer:stop()
		if self.running then
			self.running = false
			gameLoop:removeLoop(self)
		end
	end

	function battleTimer:reset()
		self:stop()
		self.gauge = 0
		self.lastTick = 0
	end

	function battleTimer:tick(time)
		local modeFunc = self.modeFunction
		if modeFunc == nil then
			return false
		end

		self.lastTick = self.lastTick + time
		local lastTick = self.lastTick
		local resultNum = lastTick / self.TIME_SLICE
		local result = math.floor(lastTick / self.TIME_SLICE)
		if result > 0 then
			local remainder = lastTick - (result * self.TIME_SLICE)
			self.lastTick = remainder
			while result > 0 do
				modeFunc(self)
				result = result - 1
			end
		end
	end

	function battleTimer:onCharacterTick()
		self.gauge = self.gauge + ((self.effect * (self.speed + 20)) / 16)
		self:dispatchEvent({name="onBattleTimerProgress", target=self, progress=self.gauge / self.MAX})
		if self.gauge >= self.MAX then
			self:dispatchEvent({name="onBattleTimerComplete", target=self})
			self.gauge = 0
		end
	end

	-- BUG: I don't get why this algo doesn't work, I give up, moving on
	function battleTimer:onMonsterTick()
		print("before:", self.gauge)
		-- ((96 * (Speed + 20)) * (255 - ((Battle Speed - 1) * 24))) / 16
		--self.gauge = self.gauge + ((96 * (self.speed + 20)) * (255 - ((self.battleSpeed - 1) * 24))) / 16
		self.gauge = self.gauge + (((self.effect * (self.speed + 20)) * (255 - ((self.battleSpeed - 1) * 24))) / 16)
		print("after:", self.gauge)
		self:dispatchEvent({name="onBattleTimerProgress", target=self, progress=self.gauge / self.MAX})
		
		if self.gauge >= self.MAX then
			print("self.gauge:", self.gauge, ", self.MAX:", self.MAX)
			self:dispatchEvent({name="onBattleTimerComplete", target=self})
			self.gauge = 0
		end
	end

	battleTimer:setMode(mode)


	return battleTimer

end

return BattleTimer
