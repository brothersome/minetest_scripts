f not init then
	init = true
	chats = {};
	self.listen(1)
	minduration = 10;delta = 5;
	t = 10;
	
	talk = function(msg)
		local players = player.connected();
		local i = math.random(#players);
		minetest.chat_send_all("<lolbot " ..players[i] .. "> " .. msg)
	end
end

t=t-1
if t<0 then
  self.label(#chats)
	t= minduration+math.random(delta)
	local i = math.random(#chats);
	if i>0 then 
	  talk(chats[i])
	end
end

speaker,msg = self.listen_msg()
if msg then
	chats[#chats+1] = msg
end


====================
if read_node.forward_down() == 'farming:weed' then
	active.forward_down(1)
end