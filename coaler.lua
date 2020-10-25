if not init then
	init = true
	cnt = 0
	powerlevel = 100
else
	energy = machine.energy()
	self.label(string.format('Power: %d',energy))
	if cnt == 0 then
		machine.generate_power('default:tree',powerlevel)
		if energy > 40 then
			cnt = 1
		end
	else
		if check_inventory.self('default:coal_lump 10','main') then
			craft('default:coalblock')
		end
		if check_inventory.self('default:coalblock','main') then
			machine.compress('default:coalblock')
			if check_inventory.self('default:diamond 10','main') then
				craft('default:diamondblock',18)
			end
		else
			machine.generate_power('default:tree',powerlevel)
		end
		if energy <= 40 then
			cnt = 0
		end
	end
end