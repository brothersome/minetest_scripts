if not init then
	side = 0
	
	matfuel = 'moreblocks:micro_tree 40'
	matfuel_alt='moreblocks:micro_tree'
	matfuel_battery = 'moreblocks:micro_tree 40'
	matfuel_battery_get = 'moreblocks:micro_tree 80'
	matfuel_battery_min = 'moreblocks:micro_tree 60'
	matfuel_fill_base_check = 'default:tree 5'
	matfuel_fill_base = 'default:tree 40'
	matfuel_fill_half = 'moreblocks:slab_tree 80'
	matfuel_fill_half_check = 'moreblocks:slab_tree 7'
	matfuel_max = 'moreblocks:micro_tree 400'
	mattree_get = 'default:tree 40'
	matfuel_short='moreblocks:micro_tree 40'
	
	mat_furnace = 'moreblocks:micro_tree 20'
	mat_build='default:diamond 10'
	mat_upgrade='default:diamondblock'
	mat1 = 'basic_machines:diamond_dust_66'
	mat1_check = 'basic_machines:diamond_dust_66 5'
	mat2 ='basic_machines:diamond_dust_33'
	mat2_check = 'basic_machines:diamond_dust_33 5'
	mat2_max= 'basic_machines:diamond_dust_33 90'
	mat3 = 'default:diamond'
	mat4 = 'default:diamondblock'
	
	matcobble = 'default:cobble'
	matcobble_min = 'default:cobble 50'
	matcobble_in_max = 'default:cobble 180'
	matgravel_min = 'default:gravel 60'
	matgravel_max = 'default:gravel 200'
	matgravel_put = 'default:gravel 13'
	mat_energy = 'alchemy:essence_low 95'
	mat_energy_put = 'alchemy:essence_low 250'
	
	init = true
	index = 0
	no_wood_cnt = 0
	
	handle_furnace = function(direction,material_in_check,material_in,material_out)
		activated = false
		if check_inventory[direction](material_in,'src') then
			if not check_inventory[direction](matfuel,'fuel') then	
				insert[direction](matfuel,'fuel') 
				activated = true
			end
			 if not check_inventory[direction](material_in_check,'src') then
			 	insert[direction](material_in,'src')
				activated = true
			end
		else
			if check_inventory.self(material_in,'main') then
				insert[direction](material_in,'src')
				activated = true
			end
		end
		if activated then
			activate[direction](2) 
		else
			if check_inventory[direction](material_out,'dst') then 
				take[direction] (material_out,'dst') 
				activated = true
			end
		end
		return activated
	end
	
	handle_battery = function(direction_bat,direction_gen)
		if read_node[direction_gen]() == 'zzzzzzzzzzzzzzzzbasic_machines:generator' then
			if check_inventory[direction_gen]('basic_machines:power_cell 10','fuel') then
				take[direction_gen]('basic_machines:power_cell 10','fuel') 
				insert[direction_bat]('basic_machines:power_cell 10','fuel') 
			end
		else
			if not check_inventory[direction_bat](matfuel_battery,'fuel') then
				insert[direction_bat](matfuel_battery,'fuel') 
			end
		end
	end
	
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
	
else
	if no_wood_cnt <= 0 then
		if index < 4 then
			if index >= 0 then
				self.label(string.format('Burning %d %d',side,index))
				if side == 0 then
					if not move.forward() then
						dig.forward()
						return
					end
				end
				if check_inventory.self(matfuel_short,'main') then
					if side == 0 then
						if not handle_furnace('left',mat1_check,mat1,mat3) then
							if check_inventory.left(mat1,'src') then handle_battery('left_down','left_up') end
						end
					else
						if not handle_furnace('right',mat2_check,mat2,mat1) then
							if check_inventory.right(mat2,'src') then handle_battery('right_down','right_up') end
						end
					end
					if side == 1 then
						index = index + 1
						side = 0
					else
						side = 1
					end
					activate.down(1)
				else
					side = 0
					index = -1
					self.reset()
				end			
			else
				self.label(string.format('Filling %d',-1 * index))
				if index == -1 then
					if check_inventory.left(matfuel_battery_get,'dst') then
						take.left(matfuel_battery_get,'dst')
						index = 0
					else
						if check_inventory.self(matfuel_fill_base,'main') then
							insert.left_down(matfuel_fill_base,'src')
							if take.left_down(matfuel_fill_half,'dst') then
								insert.left(matfuel_fill_half,'src')
								take.left(matfuel_battery_get,'dst')
							end
							index = 0
						else
							if check_inventory.left_down(matfuel_fill_half,'dst') then
								take.left_down(matfuel_fill_half,'dst')
								insert.left(matfuel_fill_half,'src')
								activate.forward_down(1)
								-- activate.left(2)
								index = 0
							else
								if check_inventory.left_down(matfuel_fill_base_check,'src') then
									activate.forward_down(1)
									no_wood_cnt = 5
									-- activate.left_down(2)
								else
									if check_inventory.left(matfuel_fill_half_check,'src') then
										-- activate.left(2)
										activate.forward_down(1)
										no_wood_cnt = 5
									else
										move.up()
										move.up()
										move.up()
										if check_inventory.up(matfuel_fill_base,'main') then
											take.up(matfuel_fill_base)
										end
										index = -2
									end
								end
							end
						end
					end
				else
					if index == -2 then
						move.down()
						move.down()
						move.down()
						if check_inventory.self(matfuel_fill_base,'main') then
							insert.left_down(matfuel_fill_base,'src')
						else
							no_wood_cnt = 10
						end
						if check_inventory.left_down(matfuel_fill_half,'dst') then
							take.left_down(matfuel_fill_half,'dst')
						else
							no_wood_cnt = 10
						end
						index = -3
					else
						if index == -3 then
						    if check_inventory.self(matfuel_fill_half,'main') then
								insert.left(matfuel_fill_half,'src')
							end
							if check_inventory.left(matfuel_battery_get,'dst') then
								take.left(matfuel_battery_get,'dst')
							else
								no_wood_cnt = 30
							end
							index = 0
						end
					end
				end
			end
		else
			if not check_inventory.self(matfuel_battery_min,'main') then			
				index = -1
				self.reset()
			else
				index = 0
			end
			self.reset()
			side = 0
			if not check_inventory.right(matfuel,'fuel') then
				insert.right(matfuel,'fuel') 
			end
			if check_inventory.right(mat2,'dst') then
				take.right(mat2,'dst')
			end
			if check_inventory.self(mat3,'main') then
				if not check_inventory.right(mat3,'src') and  not check_inventory.self(mat2_max,'main') then
					insert.right(mat3,'src') 
				else
					if check_inventory.self(mat_build,'main') then
						craft(mat4,18)
					end
				end
			end
		end
	else
		no_wood_cnt = no_wood_cnt - 1
		self.label(string.format('Waiting: %d',no_wood_cnt))
		
		if not check_inventory.self(matcobble_min,'main')  and check_inventory.self(mat_energy_put,'main') then
			if not check_inventory.right_up(matcobble_in_max,'in') then
				insert.right_up(mat_energy_put,'out')
				insert.right_up(mat_cobble,'in')
				activate.right_up(2)
			end
			take.right_up(matcobble_min,'in')
			if check_inventory.right_up('alchemy:essence_energy 10','fuel') then
				take.right_up('alchemy:essence_energy 10','fuel')
			else
				activate.forward_down(1)
			end
		else
			if not check_inventory.self(matgravel_min,'main') then
				if check_inventory.self(matcobble_in,'main') then
					place.forward(matcobble)
					dig.forward(matcobble)
					activate.forward_down(1)		
				end
			else
				bnr = 1
				while bnr <= 1 do
					if check_inventory.self(matgravel_check,'main') then
						if put_into_box('left_up') then
							bnr = 10
						else
							bnr = bnr + 1
						end
					else
						bnr = 10
					end
				end
				activate.forward_down(1)
			end
		end
	end
end