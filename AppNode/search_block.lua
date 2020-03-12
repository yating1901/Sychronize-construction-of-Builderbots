DebugMSG.register("search_block")
if api == nil then api = require('BuilderBotAPI') end

local create_obstacle_avoidance_node = require("obstacle_avoidance")

local create_search_block_node = function(rule_node)
   -- create a search node based on rule_node
   return {
      type = "sequence*",
      children = {
         -- prepare, lift to 0.highest
         {
            type = "selector",
            children = {
               -- if lift reach position(0.07), return true, stop selector
               function()
                  if robot.lift_system.position > api.parameters.lift_system_upper_limit - api.parameters.lift_system_position_tolerance and
                     robot.lift_system.position < api.parameters.lift_system_upper_limit + api.parameters.lift_system_position_tolerance then
                     DebugMSG("search_in position")
                     return false, true
                  else
                     DebugMSG("search_not in position")
                     return false, false
                  end
               end,
               -- set position(0.07)
               function()
                  robot.lift_system.set_position(api.parameters.lift_system_upper_limit)
                  return true -- always running
               end,
            },
         },
         -- search
         {
            type = "sequence",
            children = {
               -- check obstacle and randomwalk
               {
                  type = "sequence",
                  children = {
                     -- if obstacle and avoid
                     create_obstacle_avoidance_node(),
                     -- obstacle clear, random walk
                     function()
                        --api.blocks[1]
                        local random_angle = math.random(-api.parameters.search_random_range, api.parameters.search_random_range)
                        --api.move(-api.parameters.default_speed, api.parameters.default_speed)
                        local green_number = 0
                        local blue_number = 0
                        for i, block in pairs(api.blocks) do
                           --for j, tag in pairs(block.tags) do
                           if block.type == 1 then
                              green_number = green_number + 1
                           end
                           if block.type == 4 then
                              blue_number = blue_number + 1
                           end
                           --end
                        end
                        if green_number >= 2 then
                           random_angle = -15
                        end
                        if blue_number >= 2 then
                           random_angle = 17
                        end
                        api.move_with_bearing(api.parameters.default_speed, random_angle)
                        return false, true
                     end,
                  },
               },
               -- choose a block,
               -- if got one, return true, stop sequence
               rule_node,
            },
         },
      },
   }
end
   
return create_search_block_node
