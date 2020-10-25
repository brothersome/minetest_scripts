if not st then
	self.reset()
	st = 'a'
	self.label('Begin program')
	level = 1
	currentEnergy = machine.energy()
	
	
	
	has_level = function()
		if check_inventory.self('default:goldblock 10','main') then
			if check_inventory.self('default:mese_crystal 10','main') then
				if check_inventory.self('default:diamondblock 10','main') then
					return true;
				end
			end
		end
		return false;
	end
	
	zorg_voor_energie = function()
		st = 'b'
		currentEnergy = machine.energy()
		if currentEnergy < 0.1 then
			if has_level() then
				if check_inventory.self('default:sapling 40','main') then
					machine.generate_power('default:sapling',1)
				else
					machine.generate_power('default:tree',1)
				end
			else
				if check_inventory.self('default:sapling 40','main') then
					machine.generate_power('default:sapling')
				else
					machine.generate_power('default:tree')
				end
			end
			self.label('energize')
			return true
		end
		return false
	end
	
	fnc_begin = function()
		st = 'c'
		if read_node.forward() == 'default:tree' then
			pickup(8)
			functie = fnc_omhoog
		else
			if read_node.forward() == 'default:sapling' then
				functie = fnc_naar_volgende_boom
			else
				if read_node.forward() == 'air' or read_node.forward() == 'default:ladder_wood' then
					move.forward()
					if read_node.forward() == 'default:tree' then
						functie = fnc_omhoog
					else
						if read_node.forward() == 'default:sapling' then
							functie = fnc_naar_volgende_boom
						end
					end
				end
			end
		end
	end
	
	fnc_omhoog = function()
		st = 'd'
		if read_node.forward_up() == 'default:tree' then
			if read_node.up() == 'default:ladder_wood' then
				move.up()
			else
				if read_node.up() ~= 'air' then
					dig.up()
				else
					place.up('default:ladder_wood')
				end
			end
		else
			if read_node.left() == 'default:tree' then
				dig.left()
				if read_node.right() == 'default:tree' then
					functie = fnc_kap_voor_rechts
				else
					functie = fnc_voor_omhoog
				end
			else
				if read_node.right() == 'default:tree' then
					dig.right()
					functie = fnc_voor_omhoog
				else
					functie = fnc_voor_omhoog
				end
			end		
		end
	end
	
	fnc_voor_omhoog = function()
		st = 'e'
		move.up()
		if read_node.left() == 'default:tree' then
			functie = fnc_voor_omhoog_kap_links
		else
			if read_node.right() == 'default:tree' then
				functie = fnc_voor_omhoog_kap_rechts
			else
				move.forward()			
				if read_node.forward_down() == 'air' then
					place.down('default:ladder_wood')
					functie = fnc_midden_voorwaarts
				else
					functie = fnc_midden_voorwaarts
				end
			end
		end
	end
	
	fnc_voor_omhoog_kap_links = function()
		st = 'e2'
		dig.left()
		if read_node.right() == 'default:tree' then
			functie = fnc_voor_omhoog_kap_rechts
		else
			functie = fnc_voor_vooruit
		end
	end
	
	fnc_voor_omhoog_kap_rechts = function()
		st = 'e3'
		dig.right()
		functie = fnc_voor_vooruit
	end
	
	fnc_voor_vooruit = function()
		st = 'e4'
		if read_node.forward() == 'air' then
			move.forward()
			if read_node.forward_down() == 'default:ladder_wood' then
				functie = fnc_midden_voorwaarts
			else
				if read_node.forward_down() == 'air' then
					place.forward_down('default:ladder_wood')
					functie = fnc_midden_voorwaarts
				else
					if read_node.forward_down() == 'default:ladder_wood' then
						functie = fnc_midden_voorwaarts
					else
						functie = fnc_weghalen_voor_ladder
					end
				end
			end
		else
			dig.forward()
		end
	end
	
	fnc_weghalen_voor_ladder = function()
		st = 'e5'
		dig.forward_down()
		functie = fnc_plaats_achter_ladder
	end
	
	fnc_plaats_achter_ladder = function()
		st = 'e6'
		place.forward_down('default:ladder_wood')
		functie = fnc_midden_voorwaarts
	end
	
	fnc_kap_voor_rechts = function()
		st = 'f'
		dig.right()
		functie = fnc_voor_omhoog
	end
	
	fnc_midden_voorwaarts = function()
		st = 'g'
		if read_node.forward() == 'air' or read_node.forward() == 'default:ladder_wood' then
			move.forward()
			if read_node.left() == 'default:tree' then
				functie = fnc_achter_boven_links
			else
				if read_node.right() == 'default:tree' then
					functie = fnc_achter_boven_rechts
				else
					-- move.down()
					functie = fnc_achter_boven
				end
			end
		else
			st = 'g2'
			dig.forward()
		end
	end
	
	fnc_achter_boven_links = function()
		st = 'h'
		dig.left()
		if read_node.right() == 'default:tree' then
			functie = fnc_achter_boven_rechts
		else
			functie = fnc_achter_boven
		end
	end
	
	fnc_achter_boven_rechts = function()
		st = 'i'
		dig.right()
		functie = fnc_achter_boven
	end
	
	fnc_achter_boven = function()
		st = 'j'
		move.down()
		if read_node.left() == 'default:tree' then
			functie = fnc_achter_beneden_links
		else
			if read_node.right() == 'default:tree' then
				functie = fnc_achter_beneden_rechts
			else
				functie = fnc_achter_achter
			end
		end
	end
	
	fnc_achter_beneden = function()
		st = 'j2'
		if read_node.left() == 'default:tree' then
			functie = fnc_achter_beneden_links
		else
			if read_node.right() == 'default:tree' then
				functie = fnc_achter_beneden_rechts
			else
				dig.backward()
				functie = fnc_achter_achter_beweeg
			end
		end
	end
	
	fnc_achter_beneden_links = function()
		st = 'k'
		dig.left()
		if read_node.right() == 'default:tree' then
			functie = fnc_achter_beneden_rechts
		else
			functie = fnc_achter_achter
		end
	end
	
	fnc_achter_beneden_rechts = function()
		st = 'l'
		dig.right()
		functie = fnc_achter_achter
	end
	
	fnc_achter_achter = function()
		st = 'm'
		dig.backward()
		functie = fnc_achter_achter_beweeg
	end
	
	fnc_achter_achter_beweeg = function()
		st = 'n'
		move.backward()
		move.backward()
		move.down()
		if read_node.forward() == 'default:tree' then
			functie = fnc_naar_beneden_kap
		else
			functie = fnc_naar_beneden
		end
	end
	
	fnc_naar_beneden = function()
		st = 'o'
		if read_node.down() ~= 'default:stone' then
			move.down()
			if read_node.forward() == 'default:tree' then
				functie = fnc_naar_beneden_kap
			end
		else
			functie = fnc_plant_zaadje
		end
	end
	
	fnc_naar_beneden_kap = function()
		st = 'p'
		dig.forward()
		functie = fnc_naar_beneden
	end
	
	local wacht_teller = 0
	
	fnc_plant_zaadje = function()
		st = 'q'
		place.forward('default:sapling')
		wacht_teller = 5
		functie = fnc_wacht_en_haal_op
	end
	
	fnc_wacht_en_haal_op = function()
		st = 'r'
		if wacht_teller > 0 then
			wacht_teller = wacht_teller - 1
		else
			pickup(8)
			functie = fnc_naar_volgende_boom
		end
	end
	
	fnc_naar_volgende_boom = function()
		st = 's'
		if read_node.right() == 'air' or read_node.right() == 'default:ladder_wood' then
			move.right()
			if read_node.forward() == 'default:tree' then
				functie = fnc_omhoog
			end
		else
			self.reset()
			functie = fnc_begin
		end
	end
	
	
	fnc_stop = function()
		st = 'stop'
	end
	
	functie = fnc_begin
	
else
	if not zorg_voor_energie() then
		if functie ~= nil then
			
			functie()
			self.label(st)
		else
			self.label(string.format('%s:%s',st,'functie?'))
		end
	end
end