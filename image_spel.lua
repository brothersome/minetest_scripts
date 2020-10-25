if (not init) then
   init=true
   -- set skin animation preferences for robot
   self.set_properties({
    visual = "mesh", mesh = "character.b3d",
--    textures = {"player_awsomerainbowfox.png"},
--    textures = {"player_irondog.png"},
--    textures = {"player_royal_dog.png"},
--    textures = {"player_WhiteCat.png"},
--    textures = {"player_Yolo.png"},
--    textures = {"player_DjEspeonFire.png"},
    textures = {"player_CuteKitty.png"},
    glow=10,
    visual_size = {x = 1, y = 1}
   });

   animation = {
    stand     = { x=  0, y= 79, },
    lay       = { x=162, y=166, },
    walk      = { x=168, y=187, },
    mine      = { x=189, y=198, },
    walk_mine = { x=200, y=219, },
    sit       = { x= 81, y=160, },
   }

   anim = "walk"
   self.set_animation(animation[anim].x,animation[anim].y, 15, 0)

--   puzzle.math.randomseed(1234)

   if(read_node.down()=="basic_robot:spawner") then move.up() rom.count=0 end

   maxsteps = 4
   steps=0
   stepdone=false
   dir={}
   name="No7"

   track={}
   track["moreblocks:slab_dirt_compressed"]=true
   track["gloopblocks:slab_pumice"]=true
   finish={}
   finish["gloopblocks:slab_pumice"]=true
else
   steps = math.random(1, maxsteps)
   stepdone=false
   for i=1, steps do
      if(self.operations()>2) then
         node1=read_node.forward_down()
         node2=read_node.right_down()
         node3=read_node.left_down()
         if (track[node1]) then move.forward() self.label(string.format("%s %i",name, rom.count)) stepdone=true
         elseif(node1=="ignore") then self.label("forward mapblock unloaded")
         elseif (track[node2]) then turn.right() move.forward() self.label(string.format("%s %i",name, rom.count)) stepdone=true
         elseif(node2=="ignore") then self.label("right mapblock unloaded")
         elseif (track[node3]) then turn.left() move.forward() self.label(string.format("%s %i",name, rom.count)) stepdone=true
         elseif(node3=="ignore") then self.label("left mapblock unloaded")
         end
      end
      node4=read_node.down()
      if (finish[node4]) then say(string.format("Finished in %i steps.", rom.count)) self.remove() end
   end
   if(stepdone) then rom.count=rom.count+1 end
end