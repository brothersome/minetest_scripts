if not init then
	init = true
	powerlevel = 5
	smeltlevel = 23
	xmat1 = 'basic_machines:gold_dust_66'
	xmat2 ='basic_machines:gold_dust_33'
	xmat3 = 'default:gold_ingot'
	xmat3c = 'default:gold_ingot 10'
	xmat4 = 'default:goldblock'
	xoffset = 18
	
	mat1 = 'basic_machines:mese_dust_66'
	mat2 ='basic_machines:mese_dust_33'
	mat3 = 'default:mese_crystal'
	mat3c = 'default:mese_crystal 10'
	mat4 = 'default:mese'
	offset = -1
	
	xmat1 = 'basic_machines:diamond_dust_66'
	xmat2 ='basic_machines:diamond_dust_33'
	xmat3 = 'default:diamond'
	xmat3c = 'default:diamond 10'
	xmat4 = 'default:diamondblock'
	xoffset = 18
	
	
else
	self.label(machine.energy())
	if machine.energy() < 20 then
		machine.generate_power('default:tree',powerlevel)
	else
		if check_inventory.self(mat1,'main') then
			machine.smelt(mat1,smeltlevel)
		else
			if check_inventory.self(mat2,'main') then
				machine.smelt(mat2,smeltlevel)
			else
				if check_inventory.self(mat3c,'main') then
					if offset > 0 then 
						craft(mat4,offset)
					else
						craft(mat4)
					end
				end
				if check_inventory.self(mat3,'main') then
					machine.grind(mat3)
				end
			end
		end
	end
end