the drawing is split into seperate functions for structure.  

The map is an object class.  It consists of the drawing of the world map, and a table of territories.  A territory is also an object class.  By making territories an object class, I can assign attributes to each one and keep track of what is happening in the game.  When the map is initialized, Every territory, with starting game data is also initialized within the map.  The map code is located in map.lua,  The code for territories is located in territory.lua, but the actual creation of the territories is in map.lua.  The map then draws dots on top of the drawn map.  These dots represent individual territories.  By clicking on a territory, the varibale SelectedTerritory is changed to keep track of whcih territoruy is selected. 

drawTInfo(), in TInfo.lua, takes the Selected Territory and prints the data about the territory.

IPC's are tracked in the IPC table, which is table that consists of 6 tables, one for each country, that track IPC/turn, and total IPCs.  These are pritnied in the top left.

In the top right, is the information particluar to the phase.  These draw functions are all in PLayCorner.lua.

Most of the game mechanics are in love.keypressed, in the main file.  For combat phase, some of the mechanics are in love.mousepressed.
This works because pressing a key or clicking a button triggers the next event, change in gamePhase, or whatnot.
These mechanics are commented so it may be easier to see by looking at the code in main.lua and PlayCorner.lua and looking at the comments.


PlayerTurn tracks the Player turn.  and saves it as a string.  This string is the same as the Key for almost all the tables of information.  Thus it becomes a lot easier to access information becasue I can pass the PlayerTurn as a key to a table (Table[PlayerTurn]) and this allws me to get data more easily.  The same idea is used for each kind of unit.

A GamePhase variable is used to track the gamePhase and adjust what is ahppening on scren accordingly.

to make sure units arent mvoed twice, each territory has a movable units table.  At the beginning of a move units phase, the number of current units of the country whose turn it is is copied into this table.  So even after units are mvoed from one territory to another, we can see which untis have already been moved and which still need to be moved.

In The Battle Phase, I iterated throught the territories and found which territories were marked as 'contested', which is one of the varibales of the territory object.  I then put the key to these territories, which is the name, in a table that uses numbers as keys.  i saved the number of battles that needed to be done.  Then I begin with the first battle.  This makes the Battle nubmer also a tracker.  when teh battle is over i proceed to the next battle nubmer.  I use math.random to simulate dice.  Since the nubmer of troops in a territory are tracked in the territory objects, I can jsut access those numbers from the object.  Since the table of battles has teh territory names for the values, I can just pass the value from the battle talbe into the territory table to get that territories information.

Purchased units are stored in the PURCHasedUnits table
MovingUnits are which units are moving nwo and not which units are movable. It also has its own tables

Multiple fonts are used for fun...they can be found int he fonts folder.  The pngs for troops and emblems can alos be foudn in their repsective folder.

The create BattleStats funciton, located in BattleStats.lua, conversts the number of units into the number of rolls for 3, or 2 or what not depending on the untis stats.  It can also be used ot determine if one side has run out of units, since the number for all rolls will be 0.

push.lua and class.lua are public library files?, used in class.  Push allows us to create a virtual window size that is always the same regardless of the size fo the actual window..  Class allows us to make abject classes.