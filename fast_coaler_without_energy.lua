
craft('default:coalblock')
machine.compress('default:coalblock')
if check_inventory.self('default:diamond 10','main') then
craft('default:diamondblock',18)
end
self.label(string.format('Power: %d',machine.energy()))