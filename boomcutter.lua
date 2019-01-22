-- Boomcutter met 3 bomen en opruimkist voor appels
if not st then
	self.reset()
	dir = -2
	st = 'Cutter'
	self.label(st)
	operationdir = 0
	treenumber = 0
	waitcnt = 0
	energymode = 0
	level_smelt = 20
	level_power = 5
	level_gold = 10 * level_smelt
	level_mese = 10 * level_smelt
	level_diamond = 10 * level_smelt
	mat1 = 'basic_machines:gold_dust_66'
	mat2 ='basic_machines:gold_dust_33'
	mat3 = 'default:gold_ingot'
	vertical_cnt = 0
	makeblocks = function()
		result = false
		if check_inventory.self('default:gold_ingot 10','main') then
			craft('default:goldblock',18)
			result = true
		else 
			if check_inventory.self('default:mese_crystal 10','main') then
				craft('default:mese')
				result = true
			else
				if check_inventory.self('default:diamond 10','main') then
					craft('default:diamondblock',18)
					result = true
				end
			end
		end
		return result
	end
	check_level = function()
		level_minimum = 4096
		result = false
		myCheck = string.format('default:goldblock %d',level_gold + 1)
		if check_inventory.self(myCheck,'main') then
			level_gold = level_gold + 1
			result = true
		end
		if level_minimum > level_gold then
			level_minimum = level_gold
			mat1 = 'basic_machines:gold_dust_66'
			mat2 ='basic_machines:gold_dust_33'
			mat3 = 'default:gold_ingot'
		end
		myCheck = string.format('default:mese %d',level_mese + 1)
		if check_inventory.self(myCheck,'main') then
			level_mese = level_mese + 1
			result = true
		end
		if level_minimum > level_mese then
			level_minimum = level_mese
			if check_inventory.self('default:mese_crystal','main') then
				mat1 = 'basic_machines:mese_dust_66'
				mat2 ='basic_machines:mese_dust_33'
				mat3 = 'default:mese_crystal'
			end
		end
		myCheck = string.format('default:diamondblock %d',level_diamond + 1)
		if check_inventory.self(myCheck,'main') then
			level_diamond = level_diamond + 1
			result = true
		end
		if level_minimum > level_diamond then
			level_minimum = level_diamond
			if check_inventory.self('default:diamond','main') then
				mat1 = 'basic_machines:diamond_dust_66'
				mat2 ='basic_machines:diamond_dust_33'
				mat3 = 'default:diamond'
			end
		end
		if (level_smelt + 1 ) * 10 <= level_minimum then
			level_smelt = level_smelt + 1
		end
		if (level_power + 1 ) * 40 <= level_minimum then
			level_power = level_power + 1
		end
		
		return result
	end
else
	cond = 0
	
	if dir == -2 then
	    if read_node.forward() == 'default:tree' then
			dir = 1
			if not read_node.down('default:ladder_wood') then
				place.down('default:ladder_wood')
			else
				pickup(8)
			end
		else
			if read_node.forward_down() ~= 'default:sapling' and  read_node.forward_down() ~= 'default:tree' then
				move.forward()
			else
				if read_node.forward_down() == 'default:tree' then
					if read_node.forward_down() == 'default:tree' then
						dig.forward_down()
						place.forward_down('default:sapling')
					end
				end
			end
		end
	else
		self.label(string.format('In operation: %d', operationdir))
		if operationdir > 0 then
			if operationdir == 1 then
				self.label('Move up')
				move.up()
				place.down('default:ladder_wood')
			else
				if operationdir == 2 then
					dig.up()
					move.up()
					vertical_cnt = vertical_cnt + 1
					place.down('default:ladder_wood')
				else
					if operationdir == 3 then
						move.down()
					else
						if operationdir == 4 then
							dig.down()
							move.down()
						else
							if operationdir == 5 then
								move.backward()
								move.down()
							else
								if operationdir == 6 then
									move.forward()
								else
									if operationdir == 7 then
										move.backward()
									else
										if operationdir == 8 then
											move.right()
											move.right()
											move.right()
											move.right()
											move.right()
										else
											if operationdir == 9 then
												move.left()
												move.left()
												move.left()
												move.left()
												move.left()
											else
												if operationdir == 10 then
													operationdir = 1011
													done = false
													if check_inventory.self('default:apple 80','main') then
														done = true
														if not insert.right('default:apple 70','main') then
															operationdir = 1012
														end
													end
													if level_power > 0 then
														succeed = true
														while succeed and check_inventory.self('default:sapling 80','main') do
															if not insert.right('default:sapling 5','main') then
																succeed = false
															end
														end
														if not succeed then
															operationdir = 1012
														end
													end
													if check_inventory.self('default:leaves 80','main') then
														done = true
														if not insert.right('default:leaves 70','main') then
															operationdir = 1012
														end
													end
													if not done then
														if makeblocks() then
															operationdir = 1010
														end
														check_level()
													end													
												else
													if operationdir == 11 then
														move.left()
														move.left()
														move.left()
														move.left()
														move.left()
														operationdir = 1009
													else
														if operationdir == 12 then
															dig.right()
															place.right('default:chest')
														else
															if operationdir == 15 then
																if check_level() then
																	operationdir = 1015
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			if operationdir < 1000 then
				operationdir = 0
			else
				operationdir = operationdir - 1000
			end
		else
			self.label(dir)
			if dir == -1 then
				node = read_node.down()
				if node == 'default:stone' or  node=='basic_machines:distributor' then
					dig.forward()
					place.forward('default:sapling')
					vertical_cnt = 0
					dir = 20
					waitcnt = 10
					if treenumber == 2 then
						operationdir = 15
					end
				else
					if read_node.backward_down() == node=='basic_machines:distributor' or node == 'default:stone' then
						move.backward()
					end 
					if read_node.forward() == 'default:tree' then
						dig.forward()
					end
					move.down()
				end
			else
				if dir == 1 then
				    node = read_node.forward()
					if node == 'default:tree' then
						if read_node.up() == 'air' and read_node.up()  ~= 'default:ladder_wood' and read_node.up()  ~= 'default:ladder_sappling' then
							operationdir = 2
						else
							move.up()
							vertical_cnt = vertical_cnt + 1
							node = read_node.forward()
							if node == 'default:tree' then
								if read_node.up() == 'air' and read_node.up()  ~= 'default:ladder_wood' and read_node.up()  ~= 'default:ladder_sappling' then
									operationdir = 2
								else
									move.up()
									vertical_cnt = vertical_cnt + 1
									node = read_node.forward()
									if node == 'default:tree' then
										if read_node.up() == 'air' and read_node.up()  ~= 'default:ladder_wood' and read_node.up()  ~= 'default:ladder_sappling' then
											operationdir = 2
										else
											move.up()
											vertical_cnt = vertical_cnt + 1
										end
										dir = 11
									end
								end
								dir = 11
							end
						end
					else
						if vertical_cnt > 0 then
							dir = 11
						end
					end
				else
					if dir == 11 then
						can_forward = true
						if read_node.right() == 'default:tree' then
							dig.right()
							if read_node.left() == 'default:tree' then
								can_forward = false
							end
						else
							if read_node.left() == 'default:tree' then
								dig.left()
							end	
						end
						if can_forward then
							move.forward()
							dir = 12
						end
					else
						if dir == 12 then
							if read_node.forward_down() == 'air' then
								place.forward_down('default:ladder_wood')
								cond = 2
							end
							move.forward()
							dir = 13
						else
							if dir == 13 then
								can_backward = true
								can_fastbackward = true
								if read_node.right() == 'default:tree' then
									dig.right()
									can_fastbackward = false
									if read_node.left() == 'default:tree' then
										can_backward = false
									end
								else
									if read_node.left() == 'default:tree' then
										dig.left()
										can_fastbackward = false
									end
								end
								if can_fastbackward then
									move.backward()
									move.backward()
									move.down()
									dir = -1
								else
									if can_backward then
										move.backward()
										dir = 14
									end
								end
							else
								if dir == 14 then
									move.backward()
									move.down()
									dir = -1
									vertical_cnt = 0
								else
									if dir == 15 then
										vertical_cnt = 0
										dir = -1
									else
										if dir == 20 then
											if read_node.forward() ~= 'default:sapling' and not check_inventory.self('default:tree 240','main') then
												pickup(8)
												if treenumber == 2 then
													operationdir = 15
												end
												dir = 1
											else
												if waitcnt <= 0 then
													energymode = 0
												    pickup(8)
													
													if treenumber == 0 then
														operationdir = 8
														treenumber = 1
													else
														if treenumber == 1 then
															operationdir = 8
															treenumber = 2
														else
															if treenumber == 2 then
																operationdir = 10
																treenumber = 0
															end
														end
													end
													dir = 1
												else
													if not check_inventory.self('default:tree 200','main') then
														waitcnt = waitcnt - 1
													end
													currentEnergy = machine.energy()
													self.label(string.format('Energy: %1.2f Levels(%d, %d, %d, %d, %d)',currentEnergy,level_gold,level_mese,level_diamond,level_smelt,level_power))
													
													if currentEnergy > 20 then
														if energymode == 0 and currentEnergy < 100 then
															if currentEnergy < 80 then
																energymode = 0
															else
																energymode = 1
															end
															if level_power == 0 then
																if check_inventory.self('default:sapling 99','main') then
																	machine.generate_power('default:sapling')
																else
																	machine.generate_power('default:tree',level_power)
																end
															else
																if not machine.generate_power('default:tree',level_power) then
																	machine.generate_power('default:tree')
																end
															end
														else
															if check_inventory.self(mat1,'main') then
																machine.smelt(mat1,level_smelt)
															else
																if check_inventory.self(mat2,'main') then
																	machine.smelt(mat2,level_smelt)
																else
																	if check_inventory.self(mat3,'main') then
																		machine.grind(mat3)
																	else										
																		pickup(8)
																	end
																end
															end
														end
													else
														if check_inventory.self('default:sapling 99','main') then
																machine.generate_power('default:sapling')
														else
																machine.generate_power('default:tree',level_power)
														end
														waitcnt = waitcnt - 1
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
