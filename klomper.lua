size = 32
item = "default:dirt"
count = 0

for i = 1,size do
	local stringname = check_inventory.self("","main",i);
	itemname, j = stringname:match("(%S+) (%d+)")
	if itemname  == item then
		count = count + tonumber(j) 
	end
end

say(string.format("total count of %s is %s",item,count))

--take.down(string.format("%s %s",item,count) -- will join all items together

self.remove()


====================
Books:

_, c = book.read(1); code.run(c); -- load library from book 1

compact_inventory("default:dirt")
self.remove()