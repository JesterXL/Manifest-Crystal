SouthButton = {}

function SouthButton:new()

	local button = display.newImage("gui/button-arrow-south.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	function button:touch(e)
		if e.phase == "began" then
			Runtime:dispatchEvent({name="onSouthButtonPressed"})
			return true
		elseif e.phase == "ended" then
			Runtime:dispatchEvent({name="onSouthButtonReleased"})
			return true
		end
	end
	button:addEventListener("touch", button)
	return button
end

return SouthButton