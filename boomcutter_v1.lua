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
else
	cond = 0
	
	if dir == -2 then
	    if read_node.forward() == 'default:tree' then
			dir = 1
			place.down('default:ladder_wood')
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
													if check_inventory.self('default:apple 20','main') then
														if not insert.right('default:apple 10','main') then
															operationdir = 1012
														else
															operationdir = 1011
														end
													else
														if check_inventory.self('default:gold_ingot 10','main') then
															craft('default:goldblock',18)
														else 
															if check_inventory.self('default:mese_crystal 10','main') then
																craft('default:mese')
															else
																if check_inventory.self('default:diamond 10','main') then
																	craft('default:diamondblock',18)
																end
															end
														end 
														operationdir = 1011
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
													
													self.label(string.format('Energy: %f',machine.energy()))
													if machine.energy() > 40 then
														if energymode == 0 and machine.energy() < 100 then
															if machine.energy() < 80 then
																energymode = 0
																if check_inventory.self('default:sapling 10','main') then
																	machine.generate_power('default:sapling')
																else
																	machine.generate_power('moreblocks:micro_tree',2)
																end
															else
																energymode = 1
																if check_inventory.self('default:sapling 10','main') then
																	machine.generate_power('default:sapling')
																else
																	machine.generate_power('moreblocks:micro_tree',2)
																end
															end
														else
															if check_inventory.self('basic_machines:gold_dust_66','main') then
																machine.smelt('basic_machines:gold_dust_66',9)
															else
																if check_inventory.self('basic_machines:gold_dust_33','main') then
																	machine.smelt('basic_machines:gold_dust_33',9)
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
														tobe_crafted = false
														crafted = false
														if check_inventory.self('moreblocks:slab_tree','main') then
															tobe_crafted = true
															if craft('moreblocks:micro_tree',4) then
																crafted = true
															end
														else
															if check_inventory.self('default:tree 3', 'main') then
																tobe_crafted = true
																if craft('moreblocks:slab_tree',6) then
																	crafted = true
																end
															else
																pickup(8)
															end
														end
														if not crafted and not tobe_crafted then
															machine.generate_power('moreblocks:micro_tree',2)
														end
														waitcnt = waitcnt - 2
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
