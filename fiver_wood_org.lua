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
	matfuel_fill_half = 'moreblocks:slab_tree 7'
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
	mat3 = 'default:diamond'
	mat4 = 'default:diamondblock'
	
	init = true
	index = 0
	
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
			if check_inventory[direction](material_out,'dst') then take[direction] (material_out,'dst') end
		end
		return activated
	end
	
	handle_battery = function(direction)
		if not check_inventory[direction](matfuel_battery,'fuel') then
			insert[direction](matfuel_battery,'fuel') 
		end
	end
	
else
	
	if index < 4 then
		if index >= 0 then
			self.label(string.format('Burning %d %d',side,index))
			if side == 0 then
				move.forward()
			end
			if check_inventory.self(matfuel_short,'main') then
				if side == 0 then
					if not handle_furnace('left',mat1_check,mat1,mat3) then
						if check_inventory.left(mat1,'src') then handle_battery('left_down') end
					end
				else
					if not handle_furnace('right',mat2_check,mat2,mat1) then
						if check_inventory.right(mat2,'src') then handle_battery('right_down') end
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
							activate.left(2)
							index = 0
						else
							if check_inventory.left_down(matfuel_fill_base_check,'src') then
								activate.left_down(2)
							else
								if check_inventory.left(matfuel_fill_half_check,'src') then
									activate.left(2)
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
					end
					if check_inventory.left_down(matfuel_fill_half,'dst') then
						take.left_down(matfuel_fill_half,'dst')
					end
					index = -3
				else
					if index == -3 then
					    if check_inventory.self(matfuel_fill_half,'main') then
							insert.left(matfuel_fill_half,'src')
						end
						if check_inventory.left(matfuel_battery_get,'dst') then
							take.left(matfuel_battery_get,'dst')
						end
						index = 0
					end
				end
			end
		end
	else
		if not check_inventory.self(matfuel_battery_min,'main') then			
			index = -1
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
		if not check_inventory.right(mat3,'src') and check_inventory.self(mat3,'main') then
			insert.right(mat3,'src') 
		else
			if check_inventory.self(mat_build,'main') then
				craft(mat4)
			end
		end
	end
end