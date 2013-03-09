WestButton = {}

function WestButton:new()

	local button = display.newImage("gui/button-arrow-west.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	function button:touch(e)
		if e.phase == "began" then
			Runtime:dispatchEvent({name="onWestButtonPressed"})
			return true
		elseif e.phase == "ended" then
			Runtime:dispatchEvent({name="onWestButtonReleased"})
			return true
		end
	end
	button:addEventListener("touch", button)
	return button
end

return WestButton