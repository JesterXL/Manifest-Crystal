EastButton = {}

function EastButton:new()

	local button = display.newImage("gui/button-arrow-east.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	function button:touch(e)
		if e.phase == "began" then
			Runtime:dispatchEvent({name="onEastButtonPressed"})
			return true
		elseif e.phase == "ended" then
			Runtime:dispatchEvent({name="onEastButtonReleased"})
			return true
		end
	end
	button:addEventListener("touch", button)
	return button
end

return EastButton