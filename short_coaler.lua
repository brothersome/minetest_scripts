if not start then
self.reset()
move.forward()
start = true
lastenergy = machine.energy()
elseif machine.energy() < 0.025 and check_inventory.self("default:coalblock","main") then
machine.generate_power("default:coalblock")
elseif machine.energy() < 0.025 and check_inventory.self("default:coal_lump 2","main") then
machine.generate_power("default:coal_lump")
elseif check_inventory.self("default:stone_with_coal", "main") then
machine.smelt("default:stone_with_coal")
elseif check_inventory.self("default:coal_lump 11","main") then
craft("default:coalblock")
elseif check_inventory.self("default:stone","main") and check_inventory.self("default:coal_lump","main") then
craft("default:stone_with_coal")
elseif check_inventory.self("default:cobble","main") then
machine.smelt("default:cobble")
elseif check_inventory.self("default:gravel 2","main") then
machine.smelt("default:gravel")
elseif check_inventory.self("default:gravel", "main") and check_inventory.self("gloopblocks:pumice","main") then
craft("default:gravel", 2)
elseif read_node.forward_down() == "gloopblocks:pumice_cooled" then
dig.forward_down()
end
self.label(string.concat({machine.energy()-lastenergy,machine.energy()},"\n"))
lastenergy = machine.energy()