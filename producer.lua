-- Dubbele maar nu met furnace activate en bijvullen en activeren bij vullen
-- ipv fuelkist nu batterij met oven
if not st then
	self.reset()
	st = 1
	fuel = 'moreblocks:micro_tree 100'
	fuel2 = 'moreblocks:micro_tree 80'
	fuel3 = 'moreblocks:micro_tree 20'
	cnt = 0
	cntswitch = 0
	cntslab = 0
	nextmat_src = 'none'
	nextmat_dst = 'none'
	mat1fc = 'default:diamond 15'
	mat1fcc = 'default:diamondblock'
	switchrow = function()
		if cntswitch == 0 then
			mat1p = 'default:diamond'
			mat1c = 'default:diamond 10'
			mat2p = 'basic_machines:diamond_dust_33'
			mat2c = 'basic_machines:diamond_dust_33 10'
			mat2pc = 'basic_machines:diamond_dust_33 2'
			mat2f = 'basic_machines:diamond_dust_33 20'
			mat3p = 'basic_machines:diamond_dust_66'
			mat3c = 'basic_machines:diamond_dust_66 10'
			mat3pc = 'basic_machines:diamond_dust_66 2'
		else
			mat1p = 'default:mese_crystal'
			mat1c = 'default:mese_crystal 10'
			mat2p = 'basic_machines:mese_dust_33'
			mat2c = 'basic_machines:mese_dust_33 10'
			mat2f = 'basic_machines:mese_dust_33 20'
			mat3p = 'basic_machines:mese_dust_66'
			mat3c = 'basic_machines:mese_dust_66 10'
		end
	end
end


if st > 1000 then
	st = st - 1000
end

activated = false

-- check and take inventory
if st == 1 then
	switchrow()
	if cntswitch == 0 then
		st = 1003
	else
		st = 1005
	end
	if not check_inventory.self(fuel,'main') then
		self.label('Getting fuel')
		cntswitch = 0
		st = 1030
	else
		if cntswitch == 1 then
			move.backward()
			move.backward()
		else
			if not check_inventory.forward_up(fuel2,'fuel') then
				insert.forward_up(fuel3,'fuel')
				activate.forward_up(2)
			else
				if not check_inventory.forward(fuel2,'fuel') then
					insert.forward(fuel3,'fuel')
				end
			end
			if check_inventory.forward_up(mat2p,'src') then
				nextmat_src = mat2p
				nextmat_dst = mat3p
				activate.forward(1)
				st = 1002
			else
				if check_inventory.forward_up(mat3p,'src') then
					nextmat_src = mat3p
					nextmat_dst = mat1p
					activate.forward(1)
					st = 1002
				else
					if check_inventory.self(mat2c,'main') then
						nextmat_src = mat2p
						nextmat_dst = mat3p
						st = 1002
					else
						if check_inventory.self(mat3c,'main') then
							nextmat_src = mat3p
							nextmat_dst = mat1p
							st = 1002
						else
							if check_inventory.self(mat2pc,'main') then
								nextmat_src = mat2p
								nextmat_dst = mat3p
								st = 1002
							else
								if check_inventory.self(mat3c,'main') then
									nextmat_src = mat3p
									nextmat_dst = mat1p
									st = 1002
								end
							end
						end
					end
				end
			end
			take.forward_up(nextmat_dst,'dst')
		end
	end
end

-- empty furnace forward_up
if st == 2 then
	self.label('filling forward_up')
	st = 1003
	if insert.forward_up(nextmat_src,'src') then
		if insert.forward_up(nextmat_src,'src') then
			st = 1102
		end
	end
	activate.forward_up(2)
	activate.forward(1)
	if st == 1003 then
		self.label('pushing forward')
	end
end

-- next comment
if st == 102 then
	if insert.forward_up(nextmat_src,'src') then
		if not insert.forward_up(nextmat_src,'src') then
			self.label('pushing forward')
			st = 1003
		end
	else
		if check_inventory.self(mat1fc,'main') then
			craft(mat1fcc)
			insert.forward(mat1fcc,'dst')
		end
		self.label('pushing forward')
		st = 1003
	end
	activate.forward(1)
	activate.backward_down(2)
end

-- pushing node very much
if st == 3 then
	st = 1003	
	if not check_inventory.forward(fuel3,'fuel') then
		if check_inventory.self(fuel2,'main') then
			insert.forward(fuel3,'fuel')
			activate.forward(1)
		else
		-- Saving fuel
			insert.forward_up(nextmat_src,'src')
			st = 1004
		end
	else
		if not check_inventory.forward_up(nextmat_src,'src') then
		-- Saving fuel
			st = 1004
		else
			activate.forward(1)
		end
	end
	activate.backward_down(2)
end

if st == 4 then
	if take.forward_up(nextmat_dst,'dst') then
		st = 1004
	else
		st = 1005
	end
	activate.backward_down(2)
end

-- move to right
if st == 5 then
	self.label(cnt)
	if not move.right() then
		st = 7
	else
		if not move.right() then
			st = 7
		else
			if not move.right() then
				st = 7
			end
		end
	end
	st = st + 1000
end

-- check below and fill with fuel
if st == 7 then
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if cntswitch == 0 then
		if not check_inventory.self(mat2f,'main') then
			if insert.down(mat1p,'src') then
				if not activated then
					insert.down(mat1p,'src')
				end
				activated = true	
			end
		end
	else
		if not check_inventory.self(mat2c,'main') then
			if not check_inventory.down(mat2c,'dst') then
				if insert.down(mat1p,'src') then
					activated = true
				end
			end
		end
	end
	if activated then
		activate.down(2)
	end
	if not check_inventory.self(mat2f,'main') then
		st = 1107
	else
		move.left()
		st = 1009
		cnt = cnt+1
		self.label(cnt)
		if cnt > 1000 then
			cnt = 0
		end
	end
end

if st == 107 then
	if check_inventory.down(mat2c,'dst') then
		take.down(mat2p,'dst')
	else 
		insert.down(mat1p,'src')
		move.left()
		st = 1009
		cnt = cnt + 1
		self.label(cnt)
		if cnt > 1000 then
			cnt = 0
		end
	end
end

if st == 8 then
	cnt = cnt + 1
	self.label(cnt)
	if cnt > 1000 then
		cnt = 0
	end
	move.left()
	st = 1009
end

-- check below and fill with fuel
if st == 9 then
	
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if not check_inventory.down(mat2c,'src') then
		if check_inventory.self(mat2p,'main') then
			insert.down(mat2p,'src')
			activated = true
		end
	end
	if activated then
		activate.down(2)
	end
	if check_inventory.down(mat3p,'dst') then
		take.down(mat3p,'dst')
	end
	move.left()
	st = 1010
end

-- check below and fill with fuel
if st == 10 then
	
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if not check_inventory.down(mat3c,'src') then
		if check_inventory.self(mat3p,'main') then
			insert.down(mat3p,'src')
			activated = true
		end
	end
	if activated then
		activate.down(2)
	end
	if check_inventory.down(mat1p,'dst') then
		take.down(mat1p,'dst',1)
	end
	move.left()
	st = 1011
end

-- put again the dust 33 if exist step 9 and 10

if st == 11 then
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if not check_inventory.down(mat2c,'src') then
		if check_inventory.self(mat2p,'main') then
			insert.down(mat2p,'src')
			activated = true
		end
	end
	if activated then
		activate.down(2)
	end
	if check_inventory.down(mat3p,'dst') then
		take.down(mat3p,'dst')
	end
	move.left()
	st = 1012
end

if st == 12 then
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if not check_inventory.down(mat3c,'src') then
		if check_inventory.self(mat3p,'main') then
			insert.down(mat3p,'src')
			activated = true
		end
	end
	if activated then
		activate.down(2)
	end
	if check_inventory.down(mat1p,'dst') then
		take.down(mat1p,'dst')
	end
	move.left()
	st = 1013
end

-- put again the dust 33 if exist step 9 and 10

if st == 13 then
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if not check_inventory.down(mat2c,'src') then
		if check_inventory.self(mat2p,'main') then
			insert.down(mat2p,'src')
			activated = true
		end
	end
	if activated then
		activate.down(2)
	end
	if check_inventory.down(mat3p,'dst') then
		take.down(mat3p,'dst')
	end
	move.left()
	st = 1014
end

if st == 14 then
	if not check_inventory.down(fuel2,'fuel') then
		insert.down(fuel3,'fuel')
		activated = true
	end
	if not check_inventory.down(mat3c,'src') then
		if check_inventory.self(mat3p,'main') then
			insert.down(mat3p,'src')
			activated = true
		end
	end
	if activated then
		activate.down(2)
	end
	if check_inventory.down(mat1p,'dst') then
		take.down(mat1p,'dst')
	end
	move.left()
	st = 1020
end



if st == 20 then
	if not move.left() then
		if cntswitch == 1 then
			move.forward()
			move.forward()
		end
		if 1==0 and  check_inventory.self(mat2c,'main') then
			if check_inventory.self(mat1p,'main') then
				insert.forward_down(mat1p,'main')
			end
		else
			if 1==0 and check_inventory.forward_up(mat2p,'dst') then
				insert.forward_down(mat1p,'main')
			end
		end
		st = 1
		if cntswitch == 0 then
			cntswitch = 1
			switchrow()
		else
			cntswitch = 0
			switchrow()
		end
	end
	st = st + 1000
end

if st == 30 then
	if not move.right() then
		move.backward()
		st = 1031
	else
		if not move.right() then
			move.backward()
			st = 1031
		else
			st = 1030
		end
	end
end

if st == 31 then
	if check_inventory.self('moreblocks:slab_tree 52','main') then
		st = 1036
	else
		if not move.down() then
			move.forward()
			st = 1032
		else
			if not move.down() then
				move.forward()
				st = 1032
			else
				st = 1031
			end
		end
	end
end

if st == 32 then
	st = 1032
	move.forward()
	if not move.forward() then
		if take.forward('default:tree 99','main') then
			st = 1033
		else
			if check_inventory.self('default:tree','main') then
				st = 1033
			else
				if check_inventory.self('moreblocks:slab_tree','main') then
					st = 1033
				end
			end
		end
	end
end

if st == 33 then
	st = 1033
	if check_inventory.self('default:diamond 10','main') then
		insert.forward('default:diamond 10','main')
	else
		if check_inventory.self('default:mese_crystal 20','main') then
			insert.forward('default:mese_crystal 10','main')
		else
			if not move.backward() then
				move.up()
				move.up()
				move.up()
				move.up()
				st = 1034
			end
		end
	end
end

if st == 34 then
	insert.right('default:tree 99','src')
	st = 1035
end

if st == 35 then
	st = 1035
	if check_inventory.right('default:tree','src') then
		activate.right(2)
		activate.right(2)
	else
		if not take.right('moreblocks:slab_tree 40','dst') then
			move.up()
			st = 1036
		end
	end
end

if st == 36 then
	if not insert.right('moreblocks:slab_tree 50','src') then
		if check_inventory.self('moreblocks:micro_tree 200','main') then
			move.forward()
			cntswitch = 0
			switchrow()
			st = 1007
		else
			cntslab = 10
			st = 1037
		end
	end
end

if st == 37 then
	st = 1037
	if cntslab <= 0 then
		insert.right('moreblocks:slabtree 10','src')
		activate.right(2)
		activate.right(2)
		take.right('moreblocks:micro_tree 40','dst')
		move.forward()
		cntswitch = 0
		switchrow()
		st = 1007
	else
		if check_inventory.right('moreblocks:slab_tree','src') then
			activate.right(2)
			activate.right(2)
			take.right('moreblocks:micro_tree 40','dst')
		else
			if not take.right('moreblocks:micro_tree 40','dst') then
				move.forward()
				cntswitch = 0
				switchrow()
				st = 1007
			end
		end
		cntslab = cntslab - 1
	end
end

-- stop
if st == 100 then
	-- self.remove()
	st = 1
end