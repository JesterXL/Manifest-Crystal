NorthButton = {}

function NorthButton:new()

	local button = display.newImage("gui/button-arrow-north.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	function button:touch(e)
		if e.phase == "began" then
			Runtime:dispatchEvent({name="onNorthButtonPressed"})
			return true
		elseif e.phase == "ended" then
			Runtime:dispatchEvent({name="onNorthButtonReleased"})
			return true
		end
	end
	button:addEventListener("touch", button)
	return button
end

return NorthButton