if not init then
	powerlevel = 1
	smeltlevel = 4
	power_min = 20
	side = 0
	
	matfuel = 'default:coalblock'
	matfuel_alt='moreblocks:micro_tree'
	matfuel_battery = 'moreblocks:micro_tree 20'
	matfuel_battery_get = 'moreblocks:micro_tree 80'
	matfuel_battery_min = 'moreblocks:micro_tree 60'
	matfuel_fill_base = 'default:tree 40'
	matfuel_fill_half = 'moreblocks:slab_tree 80'
	matfuel_turn = 'default:coalblock 12'
	matfuel_max = 'default:coalblock 99'
	mattree_get = 'default:tree 40'
	
	mat_furnace = 'default:coalblock 5'
	mat_build='default:diamond 10'
	mat_upgrade='default:diamondblock'
	mat1 = 'basic_machines:diamond_dust_66'
	mat1_check = 'basic_machines:diamond_dust_66 5'
	mat2 ='basic_machines:diamond_dust_33'
	mat2_check = 'basic_machines:diamond_dust_33 5'
	mat3 = 'default:diamond'
	mat4 = 'default:diamondblock'
	
	matfuel1='default:coal_lump'
	matfuel_build='default:coal_lump 10'
	
	matpumice_read = 'gloopblocks:pumice_cooled'
	matpumice = 'gloopblocks:pumice'
	matpumice_check = 'gloopblocks:pumice 20'
	matstone = 'default:stone'
	matstone_check = 'default:stone 14'
	matcobble = 'default:cobble'
	matcobble_check = 'default:cobble 16'
	matgravel = 'default:gravel'
	matgravel_min = 'default:gravel 5'
	matgravel_check = 'default:gravel 18'
	matstw = 'default:stone_with_coal'
	matstw_check = 'default:stone_with_coal 12'
	matcoal = 'default:coal_lump'
	matcoal_check = 'default:coal_lump 10'

	init = true
	index = 0
	
	craftturns = 0
	
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
	
	if index < 2 then
		if index >= 0 then
			self.label(string.format('Burning %d',machine.energy()))
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
				activate.down(1)
			end
			if side == 1 then
				index = index + 1
				side = 0
			else
				side = 1
			end
		else
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
							index = 0
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
			else
				if index == -2 then
					move.down()
					move.down()
					move.down()
					if check_inventory.self(matfuel_fill_base,'main') then
						insert.left_down(matfuel_fill_base,'src')
					end
					if check_inventory.right_down(matfuel_fill_half,'dst') then
						take.left_down(matfuel_fill_half,'dst')
					end
					index = -3
				else
					if index == -3 then
					    if check_inventory.self(matfuel_fill_half,'main') then
							insert.left(matfuel_fill_half,'src')
						end
						if check_inventory.right(matfuel_battery_get,'dst') then
							take.left(matfuel_battery_get,'dst')
						end
						index = 0
					end
				end
			end
		end
	else
		if check_inventory.self(matfuel_short,'main') then
			activate.down(1)
		end
		if machine.energy() < 20 then
			self.label(string.format('Energize %d',machine.energy()))
			if check_inventory.self(matfuel,'main') then
				machine.generate_power(matfuel,powerlevel)
			else
				if check_inventory.self(matcoal_check,'main') then
					machine.generate_power(matcoal,powerlevel)
				else
					if check_inventory.self('moreblocks:micro_tree','main') then
						machine.generate_power('moreblocks:micro_tree',powerlevel)
					else
						machine.generate_power('moreblocks:micro_tree_1',powerlevel)
					end
				end
			end
		else
			if not check_inventory.self(matfuel_turn,'main') and craftturns < 20 then
				craftturns = craftturns + 1
				if not check_inventory.self(matpumice_check,'main') then
					self.label(string.format('Digging or smelting %d',machine.energy()))
					if read_node.forward() == matpumice_read then
						dig.forward()
						if not check_inventory.self(matgravel_check,'main') and check_inventory.self(matgravel,'main') then craft(matgravel,2) end
					else
						if check_inventory.self(matstw,'main') then  
							machine.smelt(matstw,smeltlevel)
						else
							if check_inventory.self(matcobble,'main') then 
								machine.smelt(matcobble,smeltlevel)	
							else
								if check_inventory.self(matgravel_min,'main') then 
									machine.smelt(matgravel,smeltlevel)	
								end
							end
						end
						if not check_inventory.self(matstw_check,'main') and check_inventory.self(matcoal,'main') then craft(matstw) end
						if not check_inventory.self(matcoal_check,'main') then craft(matfuel) end
					end
				else
					self.label(string.format('Crafting and smelting %d',machine.energy()))
					if not check_inventory.self(matgravel_check,'main') and check_inventory.self(matgravel,'main') then craft(matgravel,2) end
					if not check_inventory.self(matcobble_check,'main') then machine.smelt(matgravel,smeltlevel) 
					else
						if not check_inventory.self(matstone_check,'main') then machine.smelt(matcobble,smeltlevel)
						else
							if not check_inventory.self(matstw_check,'main') then craft(matstw) end
							if not check_inventory.self(matcoal_check,'main') then machine.smelt(matstw,smeltlevel) 
							else
								craft(matfuel)
							end
						end
					end
				end
			else
				if not check_inventory.self(mat2_check,'main') then
					self.label(string.format('Grinding %d',machine.energy()))
					if check_inventory.self(mat3,'main') then
						machine.grind(mat3)
					end
				else
					if check_inventory.self(mat3_build,'main') then
						craft(mat4)
					else
						self.label(string.format('Updating inventory %d',machine.energy()))
						if not check_inventory.self(matfuel_max,'main') then
							if not check_inventory.self(matgravel_check,'main') and check_inventory.self(matgravel,'main') then craft(matgravel,2) end
								if not check_inventory.self(matcobble_check,'main') then machine.smelt(matgravel,smeltlevel) 
								else
									if not check_inventory.self(matstone_check,'main') then machine.smelt(matcobble,smeltlevel)
									else
										if not check_inventory.self(matstw_check,'main') then craft(matstw) end
										if not check_inventory.self(matcoal_check,'main') then machine.smelt(matstw,smeltlevel) 
										else
											craft(matfuel)
										end
									end
								end
						end
					end
				end
				self.reset()
				if not check_inventory.self(matfuel_battery_min,'main') then
					index = -1
				else
					index = 0
				end
				craftturns = 0
			end
		end
	end
end