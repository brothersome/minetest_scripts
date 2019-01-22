if not init then
	init = true
	matpumice_cooled = 'gloopblocks:pumice_cooled'
	matpumice = 'gloopblocks:pumice'
	matpumice_check = 'gloopblocks:pumice 5'
	matgravel = 'default:gravel'
	
	put_into_box = function(direction)
		if check_inventory[direction]('alchemy:essence_energy','fuel') then
			insert[direction](matgravel,'in')
			activate[direction](2)
			return true
		end
		return false
	end
	
	box= {}
	box[1] = 'right'
	box[2] = 'right_down'
	box[3] = 'forward_down'
	box[4] = 'forward'
	box[5] = 'left'
else
	if read_node.left_down() == matpumice_cooled then
		dig.left_down()
		craft(matgravel,2) 
	else
		bnr = 1
		totalcnt = 0
		while bnr <= 5 and totalcnt < 2 do
			if check_inventory.self(matpumice_check,'main') then
				if put_into_box(box[bnr]) then
					totalcnt = totalcnt + 1
					bnr = bnr + 1
				else
					bnr = bnr + 1
				end
			else
				bnr = 10
			end
		end
	end
end