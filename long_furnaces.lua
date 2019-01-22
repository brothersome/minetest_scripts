-- Program written by brothersome
-- Idea: Making a fast program without dealing with programsteps and other issues
-- Program based on BASIC
if not programp then
	self.reset()
	canstart = 1
	powerlevel = 0
	smeltlevel = 0
	-- Limit of lua for minetest is 50
	executionstep = 0
	
	-- Stack, where variables and pointers belong
	stack = {}
	stackp = 1
	
	-- Heap, where the program should be, argp is for holding a pointer to the stack for holding arguments
	heap = {}
	argp = {}
	
	-- program and prg is for making objectoriented programming in lua
	-- program is for the initializatin
	-- prg is for the running program
	program = {}
	prg = {}
	tags = {}
	-- programsteps, because minetest has a limit and value varies
	programsteps = {}
	programp = 1
	condition = 0
	-- buildprg, a helper for the if statement
	buildprg = {}
	buildprgp = 1
	-- loadpart, a helper to load the program, because minetest has a maximum of 50 lines to run
	loadpart = {}
	-- Below are some functions to set things on stack and on the heap
	pushstack = function(value)
		executionstep = executionstep + 2
		stack[stackp] = value
		stackp = stackp + 1
	end
	
	popstack = function()
		executionstep = executionstep + 2
		stackp = stackp - 1
		return stack[stackp]
	end
	
	program.add = function(fnc,q)
		heap[programp] = fnc
		programsteps[programp] = q
		programp = programp + 1
	end
	
	program.addsimple_arg = function(fnc,q,arg)
		heap[programp] = fnc
		programsteps[programp] = q
		argp[programp] = stackp
		pushstack(arg)
		programp = programp + 1
	end
	
	program.addjump_arg = function(fnc,q,arg)
		heap[programp] = fnc
		programsteps[programp] = q
		argp[programp] = arg
		programp = programp + 1
	end
	
	-- arg is a tagname
	program.add_arg = function(fnc,q,arg)
		heap[programp] = fnc
		programsteps[programp] = q
		argp[programp] = stackp
		if not tags[arg] then
			tags[arg] = arg
		end
		pushstack(arg)
		programp = programp + 1
	end
	
	-- args are tagnames
	program.add_arg2 = function(fnc,q,arg1,arg2)
		heap[programp] = fnc
		programsteps[programp] = q
		argp[programp] = stackp
		if not tags[arg1] then
			tags[arg1] = arg1
		end
		if not tags[arg2] then
			tags[arg2] = arg2
		end
		pushstack(arg1)
		pushstack(arg2)
		programp = programp + 1
	end
	
	-- args are tagnames
	program.add_arg3 = function(fnc,q,arg1,arg2,arg3)
		heap[programp] = fnc
		programsteps[programp] = q
		argp[programp] = stackp
		if not tags[arg1] then
			tags[arg1] = arg1
		end
		if not tags[arg2] then
			tags[arg2] = arg2
		end
		if not tags[arg3] then
			tags[arg3] = arg3
		end
		pushstack(arg1)
		pushstack(arg2)
		pushstack(arg3)
		programp = programp + 1
	end
	
	-- The beginning of the things to execute
	
		prg.endofprogram = function()
		-- self.label('end of program')
		condition = 1
	end
	
	prg.gotolabel = function()
		executionstep = executionstep + 1
		p = argp[programp]
		programp = tags[stack[p]]
	end
	
	prg.gotolabel_true = function()
		executionstep = executionstep + 3
		if stack[stackp] then
			p = argp[programp]
			programp = tags[stack[p]]
		end
	end
	
	prg.gotolabel_false = function()
		executionstep = executionstep + 3
		if not stack[stackp] then
			p = argp[programp]
			programp = tags[stack[p]]
		end
	end
	
	prg.gosub = function()
		executionstep = executionstep + 2
		pushstack(programp + 1)
		p = argp[programp]
		programp = tags[stack[p]]
	end
	
	prg.gosub_true = function()
		executionstep = executionstep + 4
		if stack[stackp] then
			pushstack(programp + 1)
			p = argp[programp]
			programp = tags[stack[p]]
		end
	end
	
	prg.gosub_false = function()
		executionstep = executionstep + 4
		if not stack[stackp] then
			pushstack(programp + 1)
			p = argp[programp]
			programp = tags[stack[p]]
		end
	end
	
	prg.ret = function()
		executionstep = executionstep + 1
		programp = popstack()
	end
	
	prg.take = function()
		executionstep = executionstep + 3
		p = argp[programp]
		stack[stackp] = take[tags[stack[p]]](tags[stack[p+1]],tags[stack[p+2]])
	end
	
	prg.dig = function()
		executionstep = executionstep + 2
		p = argp[programp]
		stack[stackp] = dig[tags[stack[p]]](tags[stack[p+1]])
	end
	
	prg.smelt = function()
		executionstep = executionstep + 1
		p = argp[programp]
		stack[stackp + 1] = machine.smelt(tags[stack[p]])
	end
	
	prg.craft = function()
		executionstep = executionstep + 2
		p = argp[programp]
		stack[stackp] = craft(tags[stack[p]],tags[stack[p+1]])
	end
	
	prg.activate = function()
		executionstep = executionstep + 2
		p = argp[programp]
		stack[stackp] = activate[tags[stack[p]]](tags[stack[p+1]])
	end
	
	prg.insert = function()
		executionstep = executionstep + 3
		p = argp[programp]
		stack[stackp] = insert[tags[stack[p]]](tags[stack[p+1]],tags[stack[p+2]])
	end
	
	prg.generate_power = function()
		executionstep = executionstep + 3
		p = argp[programp]
		executionstep = executionstep + 1
		stack[stackp] = machine.generate_power[tags[stack[p]]](tags[stack[p+1]],powerlevel)
	end
	
	prg.check_inventory = function()
		executionstep = executionstep + 2
		p = argp[programp]
		stack[stackp] = check_inventory[tags[stack[p]]](tags[stack[p+1]],tags[stack[p+2]])
	end
	
	prg.read_node = function()
		executionstep = executionstep + 2
		p = argp[programp]
		stack[stackp + 1] = read_node[tags[stack[p]]]()
	end
	
	prg.get_energy = function()
		executionstep = executionstep + 1
		stack[stackp + 1] = machine.energy()
	end
		
	prg.move = function()
		executionstep = executionstep + 2
		p = argp[programp]
		stack[stackp] = move[tags[stack[p]]]()
	end
	
	prg.eq = function()
		executionstep = executionstep + 6
		p = argp[programp]
		if stack[stackp + 1] == tags[p] then
			stack[stackp] = true
		else
			stack[stackp] = false
		end
	end
	
	prg.eq_direct = function()
		executionstep = executionstep + 6
		p = argp[programp]
		if tags[p] then
			stack[stackp] = true
		else
			stack[stackp] = false
		end
	end
	
	prg.lt = function()
		executionstep = executionstep + 6
		p = argp[programp]
		if stack[stackp + 1] < tags[p] then
			stack[stackp] = true
		else
			stack[stackp] = false
		end
	end
	
	prg.gt = function()
		executionstep = executionstep + 6
		p = argp[programp]
		if stack[stackp + 1] > tags[p] then
			stack[stackp] = true
		else
			stack[stackp] = false
		end
	end
	
	prg.lt_eq = function()
		executionstep = executionstep + 6
		p = argp[programp]
		if stack[stackp + 1] <= tags[p] then
			stack[stackp] = true
		else
			stack[stackp] = false
		end
	end
	
	prg.gt_eq = function()
		executionstep = executionstep + 6
		p = argp[programp]
		if stack[stackp + 1] >= tags[p] then
			stack[stackp] = true
		else
			stack[stackp] = false
		end
	end
	
	prg.iftrue = function()
		executionstep = executionstep + 3
		if not stack[stackp] then
			programp = argp[programp - 1]
		end
	end
	
	prg.iffalse = function()
		executionstep = executionstep + 3
		if stack[stackp] then
			programp = argp[programp - 1]
		end
	end
	
	prg.set = function()
		executionstep = executionstep + 2
		p = argp[programp]
		tags[stack[p]] = tags[stack[p+1]]
	end
	
	prg.show_boolean = function()
		executionstep = executionstep + 5
		if stack[stackp] then
			self.label("show - true")
		else
			self.label("show - false")
		end
	end
	
	program.label = function(name)
		tags[name] = programp
	end
		
	program.gotolabel = function(name)
		program.add_arg(prg.gotolabel,0,name)
	end
	
	program.gosub = function(name)
		program.add_arg(prg.gosub,0,name)
	end
	
	program.gosub_true = function(name)
		program.add_arg(prg.gosub_true,0,name)
	end
	
	program.gosub_false = function(name)
		program.add_arg(prg.gosub_false,0,name)
	end
	
	program.start = function()
		program.add(prg.endofprogram,0)
		programp = 1
	end
	
	program.move = function(direction)
		program.add_arg(prg.move,2,direction)
	end
	
	program.take = function(direction,item,inventory)
		program.add_arg3(prg.take,2,direction,item,inventory)
	end
	
	program.dig = function(direction)
		program.add_arg(prg.dig,6,direction)
	end
	
	program.smelt = function(item)
		program.add_arg(prg.smelt,0,item)
	end
	
	program.craft = function(item,index)
		program.add_arg2(prg.craft,6,item,index)
	end
	
	program.activate = function(direction,value)
		program.add_arg2(prg.activate,2,direction,value)
	end
	
	program.insert = function(direction,item,inventory)
		program.add_arg3(prg.insert,2,direction,item,inventory)
	end
	
	program.generate_power = function(item)
		program.add_arg(prg.generate_power,0,item)
	end
	
	program.check_inventory = function(direction,item,inventory)
			program.add_arg3(prg.check_inventory,2,direction,item,inventory)
	end
	
	program.set = function(tag,value)
		program.add_arg2(prg.set,0,tag,value)
	end
	
	program.read_node = function(direction)
		program.add_arg(prg.read_node,0,direction)
	end
	
	program.show_boolean = function()
		program.add(prg.show_boolean,0)
	end
	
	program.gosub = function(name)
		program.add_arg(prg.gosub,0,name)
	end
	
	program.gosub_true = function(name)
		program.add_arg(prg.gosub_true,0,name)
	end
	
	program.gosub_false = function(name)
		program.add_arg(prg.gosub_false,0,name)
	end
	
	program.ret = function()
		program.add(prg.ret,0)
	end
	
	program.gotolabel = function(name)
		program.add_arg(prg.gotolabel,0,name)
	end
	
	program.gotolabel_true = function(name)
		program.add_arg(prg.gotolabel_true,0,name)
	end
	
	program.gotolabel_false = function(name)
		program.add_arg(prg.gotolabel_false,0,name)
	end
	
	program.iftrue = function()
		buildprg[buildprgp] = programp
		buildprgp = buildprgp + 1
		program.addjump_arg(prg.iftrue,0)
	end
	
	program.iffalse = function()
		buildprg[buildprgp] = programp
		buildprgp = buildprgp + 1
		program.addjump_arg(prg.iffalse,0)
	end
	
	program.endif = function()
		buildprgp = buildprgp - 1
		programsteps[buildprg[buildprgp]] = programp + 1
	end
	
	program.alt = function()
		programsteps[buildprg[buildprgp-1]] = programp + 1
		buildprg[buildprgp-1] = programp + 1
	end
	
	program.eq = function(content)
		program.add_arg(prg.eq,0,content)
	end
	
	program.eq_direct = function(content)
		program.add_arg(prg.eq_direct,0,content)
	end
	
	program.lt = function(content)
		program.add_arg(prg.lt,0,content)
	end
	program.gt = function(content)
		program.add_arg(prg.gt,0,content)
	end
	program.lt_eq = function(content)
		program.add_arg(prg.lt_eq,0,content)
	end
	program.gt_eq = function(content)
		program.add_arg(prg.gt_eq,0,content)
	end
	
	program.get_energy = function()
		program.add(prg.get_energy,0)
	end
	
	buildtags = function()
		tags.inventorycheck_coalblock = 'default:coalblock 20'
		tags.inventorycheck_coal = 'default:coal_lump 25'
		tags.inventorycheck_gravel = 'default:gravel 20'
		tags.inventorycheck_cobble = 'default:cobble 20'
		tags.inventorycheck_stone = 'default:stone 20'
		tags.inventorycheck_stone_with_coal = 'default:stone_with_coal 20'
		tags.inventorycheck_pumice = 'gloopblocks:pumice 20'
		tags.read_pumice = 'gloopblocks:pumice_cooled'
		tags.gravel='default:gravel'
		tags.cobble='default:cobble'
		tags.stone='default:stone'
		tags.coal_lump='default:coal_lump'
		tags.coalblock='default:coalblock'
		tags.stone_with_coal = 'default:stone_with_coal'
		tags.check_coal_lump='default:coal_lump 9'
		tags.battery='basic_machines:battery'
		tags.minimum_energy = 20
	end
	
	loadcounter = 1
	
	loadpart[loadcounter] = function()
		buildtags()
		program.label('begin')
		program.check_inventory('self',tags.inventorycheck_pumice,'main')
		program.gosub_false('get_pumice')
		program.check_inventory('self', tags.inventorycheck_gravel,'main')
	end
	
	loadcounter = loadcounter + 1
	
	loadpart[loadcounter] = function()
		program.gosub_false('produce_gravel')
		program.get_energy()
		program.gt(tags.minimum_energy)
	 	program.iftrue()
			program.check_inventory('self', tags.inventorycheck_cobble,'main')
			program.gosub_false('produce_cobble')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.check_inventory('self', tags.inventorycheck_stone,'main')
			program.gosub_false('produce_stone')
			program.check_inventory('self', tags.inventorycheck_stone_with_coal,'main')
			program.gosub_false('produce_stone_with_coal')
			program.check_inventory('self', tags.inventorycheck_coalblock,'main')
			program.gosub_false('produce_coalblocks')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
	program.endif()
		program.lt(tags.minimum_energy)
		program.gosub_true('produce_energy')
		program.lt(tags.minimum_energy)
		program.gotolabel_true('begin')
		program.gosub('handle_furnaces')
		program.gotolabel('begin')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
		program.label('get_pumice')
			program.read_node('backward')
			program.eq(tags.read_pumice)
			program.iftrue()
				program.label('dig_pumice_again')
				program.dig('backward')
	end
	
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
				program.move('backward')
				program.gotolabel_false('dig_pumice_again')
				program.read_node('left')
				program.eq(tags.read_pumice)
				program.iftrue()
					program.dig('left')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
					program.endif()
				program.read_node('right')
				program.eq(tags.read_pumice)
				program.iftrue()
					program.dig('left')
				program.endif()
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.alt()
				program.eq('air')
				program.gosub_false('get_pumice')
			program.endif()
			program.read_node('forward')
			program.eq(tags.read_pumice)
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.iftrue()
				program.label('dig_pumice_again_forward')
				program.dig('forward')
				program.move('forward')
				program.gotolabel_false('dig_pumice_again_forward')
			program.alt()
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
				program.move('forward')
				program.gotolabel_false('dig_pumice_again_forward')
			program.endif()
		program.ret()
		
		program.label('produce_gravel')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.check_inventory('self',tags.read_pumice,'main')	
			program.iftrue()
				program.craft(tags.gravel,2)
				program.gosub_true('produce_gravel')
			program.endif()
		program.ret()
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
		
		program.label('produce_cobble')
			program.check_inventory('self',tags.gravel,'main')	
			program.iftrue()
				program.smelt(tags.gravel)
				program.gosub_true('produce_cobble')
			program.endif()
		end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
		program.ret()
		
		program.label('produce_stone')
			program.check_inventory('self',tags.cobble,'main')	
			program.iftrue()
		end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
				program.smelt(tags.cobble)
				program.gosub_true('produce_stone')
			program.endif()
		program.ret()
		
		program.label('produce_stone_with_coal')
			program.check_inventory('self',tags.cobble,'main')	
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.iftrue()
				program.craft(tags.stone_with_coal,0)
				program.gosub_true('produce_stone_with_coal')
			program.endif()
		program.ret()
		
		program.label('produce_coalblocks')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.check_inventory('self',tags.stone_with_coal,'main')	
			program.iftrue()
				program.smelt(tags.stone_with_coal)
				program.gosub_true('produce_stone_with_coal')
				program.check_inventory('self',tags.check_coal_lump,'main')
				program.gosub_true('produce_coalblocks')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
			program.endif()
		program.ret()
		
		program.label('produce_coalblocks')
			program.craft(tags.coalblock,0)
		program.ret()
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()	
		program.label('produce_energy')
			program.check_inventory('self',tags.coalblock,'main')
			program.iftrue()
				program.generate_power(tags.coalblock)
			program.alt()
				program.generate_power(tags.coal_lump)
			program.endif()
		program.ret()
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()	
		program.label('handle_furnaces')
			program.read_node('forward_down')
			program.eq("air")
			program.iffalse()
				program.move('forward')
				program.set('furnace_direction','left')
				program.set('battery_direction','left_down')
				program.activate('down',1)
				program.gosub('handle_furnace')
	end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
				program.set('furnace_direction','right')
				program.set('battery_direction','rightdown')
				program.activate('down',1)
				program.gosub('handle_furnace')
				program.gosub('handle_furnaces')
				program.move('backward')
			program.endif()
		program.ret()
end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()
		program.label('handle_furnace')
			program.check_inventory('furnace_direction',tags.coalblock,'main')
			program.iffalse()
				program.insert('furnace_direction',tags.coalblock,'fuel')
			program.endif()
			program.read_node('battery_direction')
end
	loadcounter = loadcounter + 1
	loadpart[loadcounter] = function()	
			program.eq(tags.battery)
			program.iftrue()
				program.check_inventory('battery_direction',tags.battery,'main')
				program.iffalse()
					program.insert('battery_direction',tags.battery,tags.coalblock,'fuel')
				program.endif()
			program.endif()
		program.ret()
					
		program.start()	
	end
else
	if canstart < 100 then
		if canstart  <= loadcounter then
			self.label(string.format('loading: %d',canstart))
			loadpart[canstart]()
			canstart = canstart + 1
		else 
			condition = 0
			programp = 1
			canstart = 1024
		end
	else
		qsteps = 10
		executionstep = 0
		self.label(string.format('Running: %d',programp))
		if  (condition == 0) and ((qsteps - programsteps[programp]) > 0) and (executionstep < 40) then
			qsteps = qsteps - programsteps[programp]
			heap[programp]()
			programp = programp + 1
			executionstep = executionstep + 2
		end
	end
end