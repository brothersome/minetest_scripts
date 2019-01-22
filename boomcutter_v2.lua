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
	level_smelt = 10
	level_power = 2
	level_gold = 10 * level_smelt
	level_mese = 10 * level_smelt
	level_diamond = 10 * level_smelt
	level_must_check = false
	makeblocks() = function()
		if check_inventory.self('default:gold_ingot 10','main') then
			craft('default:goldblock',18)
			level_must_check = true
		else 
			if check_inventory.self('default:mese_crystal 10','main') then
				craft('default:mese')
				level_must_check = true
			else
				if check_inventory.self('default:diamond 10','main') then
					craft('default:diamondblock',18)
					level_must_check = true
				end
			end
		end
	end
	check_level = function()
		level_minimum = 4096
		myCheck = string.format('default:goldblock %d',level_gold)
		if check_inventory.self(myCheck,'main') then
			level_gold = level_gold + 1
		end
		if level_minimum > level_gold then
			level_minimum = level_gold
		end
		myCheck = string.format('default:mese %d',level_mese)
		if check_inventory.self(myCheck,'main') then
			level_mese = level_mese + 1
		end
		if level_minimum > level_mese then
			level_minimum = level_mese
		end
		myCheck = string.format('default:diamondblock %d',level_diamond)
		if check_inventory.self(myCheck,'main') then
			level_diamond = level_diamond + 1
		end
		if level_minimum > level_diamond then
			level_minimum = level_diamond
		end
		if (level_smelt + 1 ) * 10 < level_minimum then
			level_smelt = level_smelt + 1
		end
		if (level_power + 1 ) * 40 < level_minimum then
			level_power = level_power + 1
		end
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
			if read_node.forward_down() ~= 'default:sapling' then
				move.forward()
			end
		end
	else
		self.label(operationdir * 1000)
		if operationdir > 0 then
			if operationdir == 1 then
				self.label('Move up')
				move.up()
				place.down('default:ladder_wood')
			else
				if operationdir == 2 then
					dig.up()
					move.up()
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
													if check_inventory.self('default:apple 80','main') then
														if not insert.right('default:apple 70','main') then
															operationdir = 1012
														else
															operationdir = 1010
														end
													else
														if check_level() then
															operationdir = 1010
														end
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
						if read_node.up() ~= 'air' and read_node.up()  ~= 'default:ladder_wood' then
							operationdir = 2
						else
							move.up()
						end
					else
						if node ~= 'default:sapling' then
							if node ~= 'air' and node ~='default:sapling' then
								dig.forward()
							end
							dir = 11
						end
					end
				else
					if dir == 11 then
						if read_node.right() == 'default:tree' then
							cond = 1
							dig.right()
						else
							if read_node.left() == 'default:tree' then
								cond = 2
								dig.left()
							else
								if read_node.forward() == 'default:tree' then
									dig.forward()
									cond = 3
								end
							end
							
						end
						if cond == 0 then
							move.forward()
							dir = 12
						else
							if cond == 3 then
								move.forward()
								dir = 12
							end
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
								if read_node.right() == 'default:tree' then
									dig.right()
									cond = 1
								else
									if read_node.left() == 'default:tree' then
										dig.left()
										cond = 2
									end
								end
								if cond == 0 then
									move.backward()
									move.backward()
									move.down()
									dir = -1
								else
									if cond == 2 then
										move.backward()
										dir = 14
									end
								end
							else
								if dir == 14 then
									move.backward()
									move.down()
									dir = -1
								else
									if dir == 15 then
										dir = -1
									else
										if dir == 20 then
											if read_node.forward() ~= 'default:sapling' then
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
													self.label(string.format('Energy: %f Levels(%d, %d, %d, %d, %d)',currentEnergy,level_gold,level_mese,level_diamond,level_smelt,level_power))
													
													if currentEnergy > 20 then
														if energymode == 0 and currentEnergy < 100 then
															if currentEnergy < 80 then
																energymode = 0
															else
																energymode = 1
															end
															if check_inventory.self('default:sapling 10','main') then
																	machine.generate_power('default:sapling')
																else
																	machine.generate_power('default:tree',level_power)
																end
														else
															if check_inventory.self('basic_machines:gold_dust_66','main') then
																machine.smelt('basic_machines:gold_dust_66',level_smelt)
															else
																if check_inventory.self('basic_machines:gold_dust_33','main') then
																	machine.smelt('basic_machines:gold_dust_33',level_smelt)
																else
																	if check_inventory.self('default:gold_ingot','main') then
																		machine.grind('default:gold_ingot')
																	else										
																		pickup(8)
																	end
																end
															end
														end
													else
														if check_inventory.self('default:sapling 10','main') then
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
