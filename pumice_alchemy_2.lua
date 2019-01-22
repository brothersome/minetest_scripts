if not init then
	init = true
	matcobble = 'default:cobble'
	matcobble_min = 'default:cobble 50'
	matgravel_min = 'default:gravel 60'
	matgravel_max = 'default:gravel 200'
	matgravel_put = 'default:gravel 13'
	mat_energy = 'alchemy:essence_low 95'
	mat_energy_put = 'alchemy:essence_low 250'
	
	put_into_box = function(direction)
		if check_inventory[direction]('alchemy:essence_energy','fuel') then
			insert[direction](matgravel_put,'in')
			activate[direction](2)
			if check_inventory[direction](mat_energy,'out') then
				take[direction](mat_energy,'out')
			end
			if check_inventory.self('alchemy:essence_energy 10','main') then
				insert[direction]('alchemy:essence_energy 10','fuel')
			end
			return true
		end
		return false
	end
	
	box= {}
	box[1] = 'left_down'
	box[2] = 'left'
	box[3] = 'right_down'
	box[4] = 'right'
	box[5] = 'forward_down'
else
	if not check_inventory.self(matcobble_min,'main')  and check_inventory.self(mat_energy_put,'main') then
		insert.right_down(mat_energy_put,'out')
		insert.right_down(mat_cobble,'in')
		activate.right_down(2)
		take.right_down(matcobble_min,'in')
		if check_inventory.right_down('alchemy:essence_energy 10','fuel') then
			take.right_down('alchemy:essence_energy 10','fuel')
		end
	else
		if not check_inventory.self(matgravel_min,'main') then
			if check_inventory.self(matcobble_in,'main') then
				place.up(matcobble)
				dig.up(matcobble)
			end
		else
			bnr = 1
			while bnr <= 1 do
				if check_inventory.self(matgravel_check,'main') then
					if put_into_box(box[bnr]) then
						bnr = 10
					else
						bnr = bnr + 1
					end
				else
					bnr = 10
				end
			end
		end
	end
end