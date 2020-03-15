package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';luabt/?.lua'
package.path = package.path .. ';AppNode/?.lua'
DebugMSG = require('DebugMessage')
-- require('Debugger')

if api == nil then
   api = require('BuilderBotAPI')
end
if app == nil then
   app = require('ApplicationNode')
end
if rules == nil then
   rules = require(robot.params.rules) 
end

local bt = require('luabt')


DebugMSG.enable()
DebugMSG.enable('process_rules')
DebugMSG.enable('BuilderBotAPI')
DebugMSG.enable("curved_approach_block")



-- ARGoS Loop ------------------------
function init()
   local BTDATA = {target = {}}
   -- bt init ---
   local bt_node = {
      type = 'sequence*',
      children = {
         -- pick up
         {
            type = "selector*",
            children = {
               -- am I holding a block? If yes, go to place
               function()
                  if robot.rangefinders['underneath'].proximity < api.parameters.proximity_touch_tolerance then
                     return false, true
                  else
                     return false, false
                  end
               end,
               -- pickup procedure
               {
                  type = "sequence*",
                  children = {
                     -- search
                     app.create_search_block_node(
                        app.create_process_rules_node(rules, 'pickup', BTDATA.target)
                     ),
                     -- approach
                     app.create_curved_approach_block_node(BTDATA.target, 0.2),
                     -- pickup 
                     app.create_pickup_block_node(BTDATA.target, 0.2),
                  },
               },
            },
         },
         -- place
         {
            type = "selector*",
            children = {
               -- Is my hand empty? If yes, go to pickup
               function()
                  if robot.rangefinders['underneath'].proximity > api.parameters.proximity_touch_tolerance then
                     return false, true
                  else
                     return false, false
                  end
               end,
               -- place procedure
               {
                  type = "sequence*",
                  children = {
                     -- search
                     app.create_search_block_node(
                        app.create_process_rules_node(rules, 'place', BTDATA.target)
                     ),
                     function()
                        DebugMSG("BTDATA.target, before approach")
                        DebugMSG(BTDATA.target)
                     end,
                     -- approach
                     app.create_curved_approach_block_node(BTDATA.target, 0.20),
                     function()
                        DebugMSG("BTDATA.target, after approach")
                        DebugMSG(BTDATA.target)
                     end,
                     -- place
                     app.create_place_block_node(BTDATA.target, 0.20),
                     -- backup
                     app.create_timer_node{
                        time = 0.08 / 0.005,
                        func = function() api.move(-0.005, -0.005) end
                     },
                  },
               },
            },
         },
      },
   }
   behaviour = bt.create(bt_node)
   -- robot init ---
   robot.camera_system.enable()
end

local STATE = 'prepare'

function step()
   DebugMSG('-------- step begins ---------')
   api.process()
   behaviour()
end

function reset()
end

function destroy()
end
