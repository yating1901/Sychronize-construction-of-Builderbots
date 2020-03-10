# The BuilderBot Library
## Prerequisites 
1. Compile and install the [ARGoS simulator](https://github.com/ilpincy/argos3)
2. Compile and install the [SRoCS plugin for the ARGoS simulator](https://github.com/allsey87/argos3-srocs)

## Usage
### Running an example
`argos3 -c testing/history/01_FirstExample.argos`

This example does nothing. It just prints some apis which argos provides. Take a look inside testing folder, there are many scenarios to play with.

## Hints
1. If there is a problem was loading libraries, try running `sudo ldconfig` on Linux or `sudo update_dyld_shared_cache` on OS X. This issue is also resolved by restarting the computer.
2. The Lua API in ARGoS provides access to the CVector2, CVector3, and CQuaternion classes. For example, you can:
```lua
local a = vector3(1,0,0)
local b = quaternion(math.pi/2, vector3(0,0,1))    -- a rotation by pi/2 around z axis
local a:rotate(b)
print(a)   -- a would be (0,1,0)
```

## Development
### Coding Standard
1. Indentation is always done by 3 spaces, tabs are not allowed.
2. Function and variable names are in lower case and seperated by underscrolls. 

```lua
if condition then
   result_one, result_two = do_something()
   do_something_else(result_two)
end
```

### Debug
There is a DebugMessage tool, please use DebugMessage instead of print:
```lua
DebugMSG = require('DebugMessage')
DebugMSG("i = ", i)
```
DebugMessage can be enable and disable modularily. "modularily" means you can register a file as a module, and enable or disable this module

```lua
-- In main.lua
DebugMSG = require('DebugMessage')
includeFile1 = require('IncludeFile1')
includeFile2 = require('IncludeFile2')

-- the switch are here
-- DebugMSG.enable() to enable all debug messages
-- DebugMSG.disable() to disable all debug messages
-- DebugMSG.disable("module1") to disable messages from File IncludeFile1.lua
-- DebugMSG.enable("module1") to enable messages from File IncludeFile1.lua
-- In the following case, only "I am main" and "I am F2" will be printed
DebugMSG.enable()
DebugMSG.disable("module1")

DebugMSG("I am main")


-- In IncludeFile1.lua
DebugMSG.register("module1")
function F1()
   DebugMSG("I am F1")
end

-- In IncludeFile2.lua
DebugMSG.register("module2")
function F1()
   DebugMSG("I am F2")
end
```

DebugMessage also provides function to show table content, if the first parameter is a table, it will parse the table recursively and show it. In this case, the second parameter would be the number of tabs printed before each line, and the third parameter would be an index which will be ignored.
```lua
DebugMSG = require('DebugMessage')
local table = {
	a = 1, 
	b = "lalala", 
	c = function() print("test") end, 
	d = {a = 1, b = 2, c = 3},
}
DebugMSG(table, 1, "d")
```
result will be
```
DebugMSG:		c	function: 0x559b50944d70
DebugMSG:		b	lalala
DebugMSG:		a	1
DebugMSG:		d	SKIPPED
```

### Parameters
There are some parameters can be defined in .argos file, for example, the default speed of the robot. Specify the parameters when declaring the lua controller node:

```
      <params script="testing/05_StructureTest.lua"
              default_speed="0.01" 
              block_position_tolerance="0.01"
              aim_block_angle_tolerance="4"
              />
```

provided parameters can be seen in builderbot\_api.parameters = {}, which is in BuilderBotAPI.lua file


## Code Structure
There are several levels provided in this library, intermediate API level and Application level.

### Robot Level
Robot level is directly provided by ARGoS-srocs. It is a table called "robot", it contains all the actuator and sensor data and operation of the robot.
### API Level
Intermediate API level is the level above the robot level. It provides basic functions, for example calculating the block location.
```lua
api = require("builderbot.api")
cv = require("builderbot.cv")
bt = require("utils.bt")
approach_root_node = bt.create(...)
```
The intermediate layer is composed of functions designed to be used in the application layer.
```lua
api.move = function(xxx)
   robot.differential_drive_system.set_speed(xxx)
end

api.get_blocks = function(xxx)
   for tag in robot.camera_system.get_tags() do
      process_tag(tag)
   end
end
```

### APP Level
Application level provides some behaviour tree nodes for user to use directly. It is designed by using the functions provided by the intermediate API. These functions are supposed to encapsulated inside [finite state machine states](https://github.com/allsey87/luafsm) or [behavior tree nodes](https://github.com/allsey87/luabt).
Example of use:
```lua
   app = require('ApplicationNode')

   bt.create{
      type = 'sequence*',
      children = {
         app.create_search_block_node(create_pickup_rule_node(BTDATA.target)),
         app.create_approach_block_node(BTDATA.target, 0.17),
         app.create_pickup_block_node(BTDATA.target, 0.025),
      },
   }
```

Detailed description of each node in APP level can be found in AppNode/README.md
