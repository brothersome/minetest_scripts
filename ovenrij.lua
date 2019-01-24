if init then
	fnc = getStack(1)
	if errormsg == 'empty' then
		pushStack('errorState')
	end
	actions[fnc]()
else
	self.reset()
	pos_x = 0
	pos_y = 0
	if read_node.right() ~= 'default:wood' then
		if read_node.forward() == 'default:wood' then
			turn.angle(90)
		else
			if read_node.left() == 'default:wood' then
				turn.angle(180)
			else
				turn.angle(270)
			end
		end
	end
	
	cycleCnt = 0
	maxCycles = 10
	stack = {}
	stackp = 1
	fuel1 = 'default:coalblock'
	mat_left = 'basic_machines:diamond_dust_33'
	mat_right = 'basic_machines:diamond_dust_66'
	errormsg = 'empty'

function pushStack(value)
	stack[stackp] = value
	stackp = stackp + 1
end

function popStack()
	if stackp > 1 then
		stackp = stackp - 1
	end
end

function getStack(pos)
	return stack[stackp - pos]
end

function toPosition(px,py,nextState)
	pushStack(py)
	pushStack(px)
	pushStack(nextState)
	pushStack('toPositionState')
end

function toPositionState()
	px = getStack(2)
	py = getStack(3)
	cycleCnt = 0
	while pos_x ~= px do
		if CycleCnt > maxCycles then
			return
		end
		if pos_x > px then
			move.backward()
			cycleCnt = cycleCnt + 2
			pos_x = pos_x - 1
		else
			move.forward()
			cycleCnt = cycleCnt + 2
			pos_x = pos_x + 1
		end
	end
	while pos_y ~= py do
		if CycleCnt > maxCycles then
			return
		end
		if pos_y > py then
			move.down()
			cycleCnt = cycleCnt + 2
			pos_y = pos_y - 1
		else
			move.up()
			cycleCnt = cycleCnt + 2
			pos_y = pos_y + 1
		end
	end
	popStack()
	popStack()
	popStack()
end



function endState()
	self.remove()
end

function haveEnoughEnergy()
	if machine.energy() < 0.025 then
		return false
	end
	return true
end

function haveEnoughCoal()
	if not check_inventory.self('default:coal_lump 11','main') then
		return false
	end
	return true
end

function haveEnoughCoalBlock()
	if not check_inventory.self('default:coalblock 8','main') then
		return false
	end
	return true
end

function haveEnoughStoneWithCoal()
	if not check_inventory.self('default:stone_with_coal','main') then
		return false
	end
	return true
end

function haveEnoughStone()
	if not check_inventory.self('default:stone','main') then
		return false
	end
	return true
end

function haveEnoughCobble()
	if not check_inventory.self('default:cobble','main') then
		return false
	end
	return true
end

function haveEnoughGravel()
	if not check_inventory.self('default:gravel','main') then
		return false
	end
	return true
end

function beginState()
	if haveEnoughEnergy() then
		if haveEnoughCoalBlock() then
			pushStack('handleBurnersState')
			pushStack('toBurnersState')
		else
			pushStack('produceCoalBlockState')				 
			pushStack('toFillerState')
		end
	else
		pushStack('produceEnergyState')
	end
end

function toBurnersState()
	if move.forward() then
		if move.down() then
			popStack()
		else
			errormsg = 'Cannot move down'
			pushStack('errorState')
		end
	else
		errormsg = 'Cannot move forward'
		pushStack('errorState')
	end
end

function toFillerState()
	move.backward()
	popStack()
end

function produceCoalBlockState()
	if haveEnoughCoal() then
		craft('default:coalblock')
		popStack()
	else
		pushStack('produceCoalState')
	end
end

function produceEneryState()
	if check_inventory.self('default:coalblock','main') then
		if machine.generate_power('default:coalblock') then
			popStack()
		end
	else
		if check_inventory.self('default:coal_lump 11','main') then
			pushStack('produceCoalState')
		else
			if check_inventory.self('default:coal_lump 2','main') then
				machine.generate_power('default:coal_lump')
			else
				self.label('Please, add me coal')
			end
		end
	end
end

function produceCoalState()
	if not haveEnoughCoal() then
		if not haveEnoughStoneWithCoal() then
			pushStack('produceStoneWithCoalState')
		else
			machine.smelt('default:coal_lump')
		end
	else
		popStack()
	end
end

function produceStoneWithCoalState()
	if not haveEnoughStoneWithCoal then
		if not haveEnoughStone() then
			pushStack('produceStoneState')
		else
			craft('default:stone_with_coal')
		end
	else
		popStack()
	end
end

function produceStoneState()
	if not haveEnoughStone() then
		if not haveEnoughCobble() then
			pushStack('produceCobbleState')
		else
			machine.smelt('default:cobble')
		end
	else
		popStack()
	end
end

function produceCobbleState()
	if not haveEnoughCobble() then
		if not haveEnoughGravel() then
			pushStack('produceGravelState')
		else
			machine.smelt('default:gravel')
		end
	else
		popStack()
	end
end

function produceGravelState()
	if not haveEnoughGravel() then
		if not haveEnoughPumice() then
			pushStack('producePumiceState')
		else
			craft("default:gravel", 2)
		end
	else
		popStack()
	end
end

function producePumiceState()
	if read_node.forward_down() == 'gloopblocks:pumice_cooled' then
		dig.forward_down()
		popStack()
	end
end

function handleBurnersState()
	node = read_node.left()
	if read_node.forward() == 'air' then
		pushStack('moveForwardState')
	else
		pushStack('returnState')
	end
	if node == 'default:furnace' or node == 'default:furnace_active' then
		activated = false
		if not check_inventory.left(fuel1,'fuel') then
			if check_inventory.self(fuel1,'main') then
				insert.left(fuel1,'fuel')
				activated = true				
			else
				popStack()
				return
			end
		end
		if not check_inventory.left(mat_left,'src') then
			if check_inventory.self(mat_left,'main') then
				insert.left(mat_left,'src')
				activated = true
			else
				errormsg = 'Waiting for material on left side'
				pushStack('errorState')
				return
			end
		else
			popStack()
			return
		end
		if activated then
			activate.left(2)
		end
		if read_node.left_down() == 'basic_machines:battery_0' then
			pushStack('handleBatteryLeftState')
		end
	end
	node = read_node.right()
	if node == 'default:furnace' or node == 'default:furnace_active' then
		activated = false
		if not check_inventory.right(fuel1,'fuel') then
			if check_inventory.self(fuel1,'main') then
				insert.right(fuel1,'fuel')
				activated = true
			else
				popStack()
				return
			end
		end
		if not check_inventory.right(mat_right,'src') then
			if check_inventory.self(mat_right,'main') then
				insert.right(mat_right,'src')
				activated = true
			else
				errormsg = 'Waiting for material on right side'
				pushStack('errorState')
			end
		else
			popStack()
			return
		end
		if activated then
			activate.right(2)
			return
		end
		if read_node.left_down() == 'basic_machines:battery_0' then
			pushStack('handleBatteryRightState')
		end
	end
end

function moveForwardState()
	if not move.forward() then
		errormsg('Cannot move forward')
		pushStack('errorState')
	else
		popStack()
	end
end

function returnState()
	self.reset()
	popStack()
	popStack()
end

function errorState()
	self.label(errormsg)
end

function handleBatteryLeftState()
	popStack()
end

function handleBatteryLeftState()
	popStack()
end



	actions = {
		['beginState'] = function() beginState() end,
		['handleBurnersState'] = function() handleBurnersState() end,
        ['produceCoalState'] = function() produceCoalState() end,
        ['produceCoalBlockState'] = function() produceCoalBlockState() end,
        ['produceStoneWithCoalState'] = function() produceStoneWithCoalState() end,
        ['produceStoneState'] = function() produceStoneState() end,
        ['produceGravelState'] = function() produceGravelState() end,
        ['producePumiceState'] = function() producePumiceState() end,
        ['produceEnergyState'] = function() produceEnergyState() end,
        ['toPositionState'] = function() toPositionState() end,
        ['toBurnersState'] = function() toBurnersState() end,
        ['toFillerState'] = function() toFillerState() end,
        ['moveForwardState'] = function() moveForwardState() end,
        ['handleBatteryRightState'] = function() handleBatteryRightState() end,
        ['handleBatteryLeftState'] = function() handleBatteryLeftState() end,
        ['errorState'] = function() errorState() end,
        ['endState'] = function() endState() end
    }
    init = true
	pushStack('beginState')
end
