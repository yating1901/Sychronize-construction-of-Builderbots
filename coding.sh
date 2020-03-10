vim coding.sh -c "
   set ts=3
   set shiftwidth=3
   set expandtab

   tabnew README.md

   tabnew BuilderBotAPI.lua
   vsp ApplicationNode.lua

   tabnew AppNode/search_block.lua
   tabnew AppNode/pickup_block.lua
   tabnew AppNode/place_block.lua

   tabnew testing/02_approach_test/01_curved_approach.lua
   vsp testing/02_approach_test/01_1_curved_approach_left.argos

   tabnew testing/10_basic_construction_test/basic_controller.lua
   vsp testing/10_basic_construction_test/01_basic_test.argos

"

<<COMMENT
   tabnew block.lua
   tabnew Tools/DebugMessage.lua

   tabnew Tools/BlockTracking.lua

   tabnew testing/01_FirstExample.lua
   vsp testing/01_FirstExample.argos

   tabnew testing/02_BlockTrackingTest.lua
   vsp testing/02_BlockTrackingTest.argos
   
   tabnew testing/04_SearchApproachPick.lua
   vsp testing/04_SearchApproachPick.argos

   tabnew testing/05_StructureTest.lua
   vsp testing/05_StructureTest.argos

   tabnew testing/06_AdvanceMoveTest.lua
   vsp testing/06_AdvanceMoveTest.argos

   tabnew testing/07_ObstacleTest.lua
   vsp testing/07_ObstacleTest.argos

   tabnew Tools/BlockTracking.lua
   tabnew Tools/Hungarian.lua
   tabnew Tools/ShowTable.lua

   tabnew AppNode/timer.lua

   tabnew AppNode/curved_approach_block.lua
   tabnew AppNode/reach_block.lua
   tabnew AppNode/approach_block.lua
   tabnew AppNode/Z_shape_approach_block.lua
   tabnew AppNode/curved_approach_block.lua
   tabnew AppNode/move_to_location.lua
   tabnew AppNode/aim_block.lua
   tabnew AppNode/obstacle_avoidance.lua

COMMENT
