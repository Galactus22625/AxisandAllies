-- new funciton for each phase
--possibly have play instructions as keys and play 
--left border 1500
--These functions display the essential play stuffs of the game


--These functions primarily draw the right corner of the screen for each phase.  Exception of combat phase
function startPhase()
    love.graphics.setFont(MDataH)
    love.graphics.setColor(160/255, 37/255, 37/255)
    love.graphics.print('Press Enter to Begin', 1700, 100)
end

function PurchasePhase()
    if PlayerTurn == 'Russian' then
        love.graphics.setColor(92/255, 38/255, 2/255)
    elseif PlayerTurn == 'German' then
        love.graphics.setColor(22/255, 37/255, 48/255)
    elseif PlayerTurn == 'British' then
        love.grpahics.setColor(181/255, 149/255, 105/255)
    elseif PlayerTurn == 'Japan' then
        love.graphics.setColor(161/255, 104/255, 39/255)
    elseif PlayerTurn == 'American' then
        love.graphics.setColor(107/255, 118/255, 43/255)
    end

    love.graphics.setFont(SmallerFont)
    love.graphics.print('Troops Purchased: ' .. tostring(PurchasedUnits.infantry).. ' Infantry, '
    .. tostring(PurchasedUnits.artillery).. ' Artillery, '
    .. tostring(PurchasedUnits.tanks).. ' Tanks, '
    .. tostring(PurchasedUnits.AAA).. ' AAA, '
    .. tostring(PurchasedUnits.fighters).. ' Fighters, '
    .. tostring(PurchasedUnits.bombers).. ' Bombers'
    , 1480, 20)

    love.graphics.print('Press 1 for Infantry, 2 for Artillery, 3 for Tanks, 4 for AAA, 5 for Fighters, 6 for Bombers', 1460, 50)
    love.graphics.print('Current Cost: ' .. tostring(PurchasedUnits.cost).. '     ' .. instructions3, 1800, 80)

    love.graphics.setFont(MData)
    --heights Infatnry: 100, artillery = 30, tank = 40,  AAA = 70, figher 80, bomber 80
    love.graphics.draw(troop.infantry[PlayerTurn], 1500 -210, 150, 0, 1, 1, 0, 50)
    love.graphics.print('IPC: 3', 1570-210, 100)
    love.graphics.print('MVE: 1', 1570-210, 125)
    love.graphics.print('ATK: 1', 1570-210, 150)
    love.graphics.print('DEF: 2', 1570-210, 175)

    love.graphics.draw(troop.artillery[PlayerTurn], 1650-210, 150, 0, 1, 1, 0, 15)
    love.graphics.print('IPC: 4', 1750-210, 100)
    love.graphics.print('MVE: 1', 1750-210, 125)
    love.graphics.print('ATK: 2', 1750-210, 150)
    love.graphics.print('DEF: 2', 1750-210, 175)

    love.graphics.draw(troop.tank[PlayerTurn], 1830-210, 150, 0, 1, 1, 0, 20)
    love.graphics.print('IPC: 6', 1935-210, 100)
    love.graphics.print('MVE: 2', 1935-210, 125)
    love.graphics.print('ATK: 3', 1935-210, 150)
    love.graphics.print('DEF: 3', 1935-210, 175)

    love.graphics.draw(troop.AAA[PlayerTurn], 2015-210, 150, 0, 1, 1, 0, 20)
    love.graphics.print('IPC: 5', 2090-210, 100)
    love.graphics.print('MVE: 1', 2090-210, 125)
    love.graphics.print('ATK: -', 2090-210, 150)
    love.graphics.print('DEF: 1', 2090-210, 175)

    love.graphics.draw(troop.fighter[PlayerTurn], 2170-210, 150, 0, 1, 1, 0, 20)
    love.graphics.print('IPC: 10', 2260-210, 100)
    love.graphics.print('MVE: 4', 2260-210, 125)
    love.graphics.print('ATK: 3', 2260-210, 150)
    love.graphics.print('DEF: 4', 2260-210, 175)
    
    love.graphics.draw(troop.bomber[PlayerTurn], 2260-210+80, 150, 0, 1, 1, 0, 20)
    love.graphics.print('IPC: 12', 2260, 100)
    love.graphics.print('MVE: 6', 2260, 125)
    love.graphics.print('ATK: 4', 2260, 150)
    love.graphics.print('DEF: 1', 2260, 175)
    
end

function CombatMovePhase()
    if PlayerTurn == 'Russian' then
        love.graphics.setColor(92/255, 38/255, 2/255)
    elseif PlayerTurn == 'German' then
        love.graphics.setColor(22/255, 37/255, 48/255)
    elseif PlayerTurn == 'British' then
        love.grpahics.setColor(181/255, 149/255, 105/255)
    elseif PlayerTurn == 'Japan' then
        love.graphics.setColor(161/255, 104/255, 39/255)
    elseif PlayerTurn == 'American' then
        love.graphics.setColor(107/255, 118/255, 43/255)
    end

    love.graphics.setFont(SmallerFont)
    love.graphics.print('Press M then click on a target territory.  Press N to confirm the Move. R to reset.', 1465, 10)
    love.graphics.print('Select Troops to move; Infantry: 1, Artillery: 2, Tanks: 3, AAA: 4, Fighters: 5, Bombers: 6', 1460, 40)

    love.graphics.setFont(TData)
    love.graphics.print('Target Territory: ' .. targetCountry .. '   '  .. instructions3, 1500, 50)

    --print number beneath, new table
    love.graphics.setFont(MoveFont)

    love.graphics.draw(troop.infantry[PlayerTurn], 1500, 150, 0, 1, 1, 0, 50)
    love.graphics.print(tostring(MovingUnits.infantry), 1550, 170)

    love.graphics.draw(troop.artillery[PlayerTurn], 1620, 150, 0, 1, 1, 0, 15)
    love.graphics.print(tostring(MovingUnits.artillery), 1700, 170)

    love.graphics.draw(troop.tank[PlayerTurn], 1770, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.tanks), 1850, 170)

    love.graphics.draw(troop.AAA[PlayerTurn], 1920, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.AAA), 2000, 170)

    love.graphics.draw(troop.fighter[PlayerTurn], 2040, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.fighters), 2110, 170)
    
    love.graphics.draw(troop.bomber[PlayerTurn], 2180, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.bombers), 2270, 170)

    

end

--this one draw on the whole screan.
function CombatPhase(location)
    --go through all battle needed territories
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(160/255, 37/255, 37/255)
    HeaderOffset = string.len('Current Battle:  ' .. tostring(BattleQ[location])) * 12
    love.graphics.print('Current Battle:  ' .. tostring(BattleQ[location]), VIRTUAL_WIDTH/2, 100, 0 , 1, 1, HeaderOffset)




    love.graphics.setColor(130/255, 205/255, 211/255)
    love.graphics.setFont(MData)
    love.graphics.print(instructions1, VIRTUAL_WIDTH/2 - 600, 420)
    love.graphics.print(instructions2, VIRTUAL_WIDTH/2 - 620, 470)
    love.graphics.print(instructions3, VIRTUAL_WIDTH/2 - 300, 520)
    
    love.graphics.setColor(1,1,1)
    love.graphics.draw(TroopStats, VIRTUAL_WIDTH/2 - 250, 800)

    
    --Axis troops
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print('Axis Troops', VIRTUAL_WIDTH/4 -280, 300)
    love.graphics.setFont(TData)
    love.graphics.print('Hits:  '.. tostring(AxisHits), VIRTUAL_WIDTH/4 -200, 380)

    --roll stats
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(MData)
    love.graphics.print(tostring(AxisRoll[4]) .. ' rolls for 4',  VIRTUAL_WIDTH/4 -200 -350, 480-10-30)
    love.graphics.print(tostring(AxisRoll[3]) .. ' rolls for 3',  VIRTUAL_WIDTH/4 -200 -350, 520-10-30)
    love.graphics.print(tostring(AxisRoll[2]) .. ' rolls for 2',  VIRTUAL_WIDTH/4 -200 -350, 560-10-30)
    love.graphics.print(tostring(AxisRoll[1]) .. ' rolls for 1',  VIRTUAL_WIDTH/4 -200 -350, 600-10-30)

    --troop data
    love.graphics.setColor(.6, .6, .6)
    love.graphics.draw(emblem.German,(VIRTUAL_WIDTH/4 - 200) -220-50 , 650)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.infantry['German'], (VIRTUAL_WIDTH/4 - 200) -220-50, 800, 0, 1, 1, 0, 50)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].German.infantry, (VIRTUAL_WIDTH/4 - 200) -220 +70, 750)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.artillery['German'], (VIRTUAL_WIDTH/4 - 200) -220-50, 900, 0, 1, 1, 0, 15)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].German.artillery, (VIRTUAL_WIDTH/4 - 200) -220 +70, 850)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.tank['German'], (VIRTUAL_WIDTH/4 - 200) -220-50, 1000, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].German.tanks, (VIRTUAL_WIDTH/4 - 200) -220 +70, 950)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.AAA['German'], (VIRTUAL_WIDTH/4 - 200) -220-50, 1100, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].German.AAA, (VIRTUAL_WIDTH/4 - 200) -220 +70, 1050)


    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.fighter['German'], (VIRTUAL_WIDTH/4 - 200) -220-50, 1200, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].German.fighters, (VIRTUAL_WIDTH/4 - 200) -220 +70, 1150)

 
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.bomber['German'], (VIRTUAL_WIDTH/4 - 200) -220-50, 1300, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].German.bombers, (VIRTUAL_WIDTH/4 - 200) -220 +70, 1250)


    
    love.graphics.setColor(.6, .6, .6)
    love.graphics.draw(emblem.Japan, (VIRTUAL_WIDTH/4 - 200) +220-50, 650)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.infantry['Japan'], (VIRTUAL_WIDTH/4 - 200) +220-50, 800, 0, 1, 1, 0, 50)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].Japan.infantry, (VIRTUAL_WIDTH/4 - 200) +220 +70, 750)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.artillery['Japan'], (VIRTUAL_WIDTH/4 - 200) +220-50, 900, 0, 1, 1, 0, 15)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].Japan.artillery, (VIRTUAL_WIDTH/4 - 200) +220 +70, 850)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.tank['Japan'], (VIRTUAL_WIDTH/4 - 200) +220-50, 1000, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].Japan.tanks, (VIRTUAL_WIDTH/4 - 200) +220 +70, 950)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.AAA['Japan'], (VIRTUAL_WIDTH/4 - 200) +220-50, 1100, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].Japan.AAA, (VIRTUAL_WIDTH/4 - 200) +220 +70, 1050)


    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.fighter['Japan'], (VIRTUAL_WIDTH/4 - 200) +220-50, 1200, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].Japan.fighters, (VIRTUAL_WIDTH/4 - 200) +220 +70, 1150)

 
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.bomber['Japan'], (VIRTUAL_WIDTH/4 - 200) +220-50, 1300, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(': ' .. territories[BattleQ[location]].Japan.bombers, (VIRTUAL_WIDTH/4 - 200) +220 +70, 1250)


    --[[  Allies Begins here, Seperation
    YEP
    YEP
    YPE
    Attention Grabber
    SEE]]
    
    --allies
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(BattleFont)
    love.graphics.print('Allied Troops', 3* VIRTUAL_WIDTH/4 -100, 300)
    love.graphics.setFont(TData)
    love.graphics.print('Hits:  '.. tostring(AlliedHits), 3* VIRTUAL_WIDTH/4 , 380)
    --hits below
    --also 12 rolls for 3... dice

    --roll data
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(MData)

    love.graphics.print(tostring(AlliedRoll[4]) .. ' rolls for 4',  3* VIRTUAL_WIDTH/4 + 360, 480-10-30)
    love.graphics.print(tostring(AlliedRoll[3]) .. ' rolls for 3',  3* VIRTUAL_WIDTH/4 + 360, 520-10-30)
    love.graphics.print(tostring(AlliedRoll[2]) .. ' rolls for 2',  3* VIRTUAL_WIDTH/4 + 360, 560-10-30)
    love.graphics.print(tostring(AlliedRoll[1]) .. ' rolls for 1',  3* VIRTUAL_WIDTH/4 + 360, 600-10-30)

    --troop data
    love.graphics.setColor(.6, .6, .6)
    love.graphics.draw(emblem.American, (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 650)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.infantry['American'], (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 800, 0, 1, 1, 0, 50)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].American.infantry, (3*VIRTUAL_WIDTH/4 - 200) -220+110 +70, 750)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.artillery['American'], (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 900, 0, 1, 1, 0, 15)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].American.artillery, (3*VIRTUAL_WIDTH/4 - 200) -220+110 +70, 850)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.tank['American'], (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 1000, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].American.tanks, (3*VIRTUAL_WIDTH/4 - 200) -220+110 +70, 950)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.AAA['American'], (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 1100, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].American.AAA, (3*VIRTUAL_WIDTH/4 - 200) -220+110 +70, 1050)


    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.fighter['American'], (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 1200, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].American.fighters, (3*VIRTUAL_WIDTH/4 - 200) -220+110 +70, 1150)

 
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.bomber['American'], (3*VIRTUAL_WIDTH/4 - 200) -220+110-50, 1300, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].American.bombers, (3*VIRTUAL_WIDTH/4 - 200) -220+110 +70, 1250)


    
    love.graphics.setColor(.6, .6, .6)
    love.graphics.draw(emblem.Britain, (3*VIRTUAL_WIDTH/4 - 200) +220-50, 650)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.infantry['Britain'], (3*VIRTUAL_WIDTH/4 - 200) +220-50, 800, 0, 1, 1, 0, 50)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Britain.infantry, (3*VIRTUAL_WIDTH/4 - 200) +220 +70, 750)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.artillery['Britain'], (3*VIRTUAL_WIDTH/4 - 200) +220-50, 900, 0, 1, 1, 0, 15)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Britain.artillery, (3*VIRTUAL_WIDTH/4 - 200) +220 +70, 850)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.tank['Britain'], (3*VIRTUAL_WIDTH/4 - 200) +220-50, 1000, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Britain.tanks, (3*VIRTUAL_WIDTH/4 - 200) +220 +70, 950)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.AAA['Britain'], (3*VIRTUAL_WIDTH/4 - 200) +220-50, 1100, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Britain.AAA, (3*VIRTUAL_WIDTH/4 - 200) +220 +70, 1050)


    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.fighter['Britain'], (3*VIRTUAL_WIDTH/4 - 200) +220-50, 1200, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Britain.fighters, (3*VIRTUAL_WIDTH/4 - 200) +220 +70, 1150)

 
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.bomber['Britain'], (3*VIRTUAL_WIDTH/4 - 200) +220-50, 1300, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Britain.bombers, (3*VIRTUAL_WIDTH/4 - 200) +220 +70, 1250)

    
    love.graphics.setColor(.6, .6, .6)
    love.graphics.draw(emblem.Russian, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 650)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.infantry['Russian'], (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 800, 0, 1, 1, 0, 50)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Russian.infantry, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +70, 750)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.artillery['Russian'], (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 900, 0, 1, 1, 0, 15)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Russian.artillery, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +70, 850)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.tank['Russian'], (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 1000, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Russian.tanks, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +70, 950)

    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.AAA['Russian'], (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 1100, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Russian.AAA, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +70, 1050)


    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.fighter['Russian'], (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 1200, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Russian.fighters, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +70, 1150)

 
    love.graphics.setColor(.7, .7, .7)
    love.graphics.draw(troop.bomber['Russian'], (3*VIRTUAL_WIDTH/4 - 200) +220+220+110-50, 1300, 0, 1, 1, 0, 20)
    love.graphics.setFont(BattleFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(': ' .. territories[BattleQ[location]].Russian.bombers, (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +70, 1250)


end

function RedeployPhase()
    if PlayerTurn == 'Russian' then
        love.graphics.setColor(92/255, 38/255, 2/255)
    elseif PlayerTurn == 'German' then
        love.graphics.setColor(22/255, 37/255, 48/255)
    elseif PlayerTurn == 'British' then
        love.grpahics.setColor(181/255, 149/255, 105/255)
    elseif PlayerTurn == 'Japan' then
        love.graphics.setColor(161/255, 104/255, 39/255)
    elseif PlayerTurn == 'American' then
        love.graphics.setColor(107/255, 118/255, 43/255)
    end

    love.graphics.setFont(SmallerFont)
    love.graphics.print('Press M then click on a target territory.  Press N to confirm the Move. R to reset.', 1465, 10)
    love.graphics.print('Select Troops to move; Infantry: 1, Artillery: 2, Tanks: 3, AAA: 4, Fighters: 5, Bombers: 6', 1460, 40)

    love.graphics.setFont(TData)
    love.graphics.print('Target Territory: ' .. targetCountry .. '   '  .. instructions3, 1500, 50)

    --print number beneath, new table
    love.graphics.setFont(MoveFont)

    love.graphics.draw(troop.infantry[PlayerTurn], 1500, 150, 0, 1, 1, 0, 50)
    love.graphics.print(tostring(MovingUnits.infantry), 1550, 170)

    love.graphics.draw(troop.artillery[PlayerTurn], 1620, 150, 0, 1, 1, 0, 15)
    love.graphics.print(tostring(MovingUnits.artillery), 1700, 170)

    love.graphics.draw(troop.tank[PlayerTurn], 1770, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.tanks), 1850, 170)

    love.graphics.draw(troop.AAA[PlayerTurn], 1920, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.AAA), 2000, 170)

    love.graphics.draw(troop.fighter[PlayerTurn], 2040, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.fighters), 2110, 170)
    
    love.graphics.draw(troop.bomber[PlayerTurn], 2180, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(MovingUnits.bombers), 2270, 170)

end

function PlacePhase()
    if PlayerTurn == 'Russian' then
        love.graphics.setColor(92/255, 38/255, 2/255)
    elseif PlayerTurn == 'German' then
        love.graphics.setColor(22/255, 37/255, 48/255)
    elseif PlayerTurn == 'British' then
        love.grpahics.setColor(181/255, 149/255, 105/255)
    elseif PlayerTurn == 'Japan' then
        love.graphics.setColor(161/255, 104/255, 39/255)
    elseif PlayerTurn == 'American' then
        love.graphics.setColor(107/255, 118/255, 43/255)
    end

    --units that will go into territory
    love.graphics.setFont(SmallerFont)
    love.graphics.print('Troops Selected: ' .. tostring(MovingUnits.infantry).. ' Infantry, '
    .. tostring(MovingUnits.artillery).. ' Artillery, '
    .. tostring(MovingUnits.tanks).. ' Tanks, '
    .. tostring(MovingUnits.AAA).. ' AAA, '
    .. tostring(MovingUnits.fighters).. ' Fighters, '
    .. tostring(MovingUnits.bombers).. ' Bombers'
    , 1480, 20)
    --instructions
    love.graphics.print('Press 1 for Infantry, 2 for Artillery, 3 for Tanks, 4 for AAA, 5 for Fighters, 6 for Bombers', 1460, 50)
    love.graphics.print('Press P to Place'.. instructions3, 1800, 80)

    --How many troops to place left
    love.graphics.setFont(MoveFont)

    love.graphics.draw(troop.infantry[PlayerTurn], 1500, 150, 0, 1, 1, 0, 50)
    love.graphics.print(tostring(PurchasedUnits.infantry), 1550, 170)

    love.graphics.draw(troop.artillery[PlayerTurn], 1620, 150, 0, 1, 1, 0, 15)
    love.graphics.print(tostring(PurchasedUnits.artillery), 1700, 170)

    love.graphics.draw(troop.tank[PlayerTurn], 1770, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(PurchasedUnits.tanks), 1850, 170)

    love.graphics.draw(troop.AAA[PlayerTurn], 1920, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(PurchasedUnits.AAA), 2000, 170)

    love.graphics.draw(troop.fighter[PlayerTurn], 2040, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(PurchasedUnits.fighters), 2110, 170)
    
    love.graphics.draw(troop.bomber[PlayerTurn], 2180, 150, 0, 1, 1, 0, 20)
    love.graphics.print(tostring(PurchasedUnits.bombers), 2270, 170)

    
end