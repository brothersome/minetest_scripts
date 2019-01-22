if not init then
	init = true
	material_empty = 'empty'
	stepval = 0
	checkingcnt = 4
	
	empty_made = function()
		material = string.format('%s %d',material_empty,stepval)
		if check_inventory.right_up(material,'in') then
			take.right_up(material,'in')
			return true
		else
			stepval = stepval / 2
			if stepval < 1 then
				stepval = 0
			end
			return false
		end
	end
else
	if checkingcnt > 0 then
		self.label(checkingcnt)
		if checkingcnt == 4 then
			material_empty = 'default:copper_ingot'
			stepval = 4096
			checkingcnt = 3
		else
			if checkingcnt == 3 then
				cnt = 5
				cnt2 = 20
				while stepval > 0 and cnt >= 1 do
					if empty_made() then	cnt = cnt - 1 end
					cnt2 = cnt2 - 1
				end
				if stepval == 0 then checkingcnt = 2 end
			else
				if checkingcnt == 2 then
					material_empty = 'default:tin_ingot'
					stepval = 4096
					cnt = 5
					checkingcnt = 1
				else
					if checkingcnt == 1 then
						cnt = 5
						cnt2 = 20
						while stepval > 0 and cnt >= 1 and cnt2 >= 1 do
							if empty_made() then cnt = cnt - 1 end
							cnt2 = cnt2 - 1
						end
						if stepval == 0 then checkingcnt = 0 end
					end
				end
			end
		end		
	else
		if stepval <= 0 then
			if check_inventory.self('default:bronze_ingot 100','main') then
				-- self.label('bronze')
				insert.left_up('default:bronze_ingot 100', 'in')
				activate.left_up(2)
				take.left_up('alchemy:essence_high 2', 'out')
			else
				if not check_inventory.self('default:tin_ingot 99','main') then
					-- self.label('tin')
					if not check_inventory.right_up('alchemy:essence_high', 'out') and check_inventory.self('alchemy:essence_high 4', 'main') then
						insert.right_up('alchemy:essence_high 2', 'out')
					else
						if not check_inventory.right_up('alchemy:essence_high', 'out') and check_inventory.self('alchemy:essence_high 2', 'main') then
							insert.right_up('alchemy:essence_high', 'out')
						end
					end
					insert.right_up('default:tin_ingot','in')
					activate.right_up(2)
					material_empty = 'default:tin_ingot'
					stepval = 4096
				else
					if not check_inventory.self('default:copper_ingot 99','main') then
						-- self.label('copper')
						if not check_inventory.right_up('alchemy:essence_high', 'out') and check_inventory.self('alchemy:essence_high 10', 'main')  then
							insert.right_up('alchemy:essence_high 10', 'out')
						else
							if not check_inventory.right_up('alchemy:essence_high', 'out') and check_inventory.self('alchemy:essence_high 2', 'main')  then
								insert.right_up('alchemy:essence_high','out')
							end
						end
						insert.right_up('default:copper_ingot','in')
						activate.right_up(2)
						material_empty = 'default:copper_ingot'
						stepval = 4096
					else
						self.label('craft')
						cnt = 10
						while cnt >= 1 do
							if craft('default:bronze_ingot',2) then 
								cnt = cnt - 1
							end		
						end
					end
				end
			end
		else
			-- self.label('empty')
			cnt = 5
			cnt2 = 20
			while stepval > 0 and cnt >= 1 and cnt2 >= 0 do
				if empty_made() then cnt = cnt - 1 end
				cnt2 = cnt2 - 1
			end
		end
	end
end