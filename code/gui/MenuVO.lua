MenuVO = {}

function MenuVO:new(label, icon)

	local vo = {}
	vo.label = label
	vo.icon = icon
	return vo
end

return MenuVO