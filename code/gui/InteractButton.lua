InteractButton = {}

function InteractButton:new()
	local button = display.newImage("gui/interact-button.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	function button:touch(event)
		if event.phase == "ended" then
			Runtime:dispatchEvent({name="onInteractTouched"})
			return true
		end
	end
	button:addEventListener("touch", button)

	return button
end

return InteractButton