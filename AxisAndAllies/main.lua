
--jpg is faster, Less is faster, WorldMapLess.jpg size W:1848 H:1200
Class = require 'class'
push = require 'push'

--require "luasql-sqlite3"
--sqlite3 = require "lsqlite3"

require 'IPCTracking'
require 'territory'
require 'map'
require 'TInfo'
require 'title'
require 'BattleStats'
require 'PlayCorner'

-- We want extra space for things beyond map
--VIRTUAL_WIDTH = 7040
--VIRTUAL_HEIGHT = 4242

VIRTUAL_WIDTH = 2346
VIRTUAL_HEIGHT = 1414

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 750

--random setup
math.randomseed(os.time())

--create new .lua for each section on outline? see nontes
--create a new function for each game stage

function love.load()

    --CREATE PUSH WINDOW
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        --will mess up clicking: nevermind love.grpahics.getwidth()
        resizable = true,
        vsync = true
    })

    --Window title
    love.window.setTitle('Axis and Allies: 1942')
    
    --build map object to store map data
    map = map()

    --tracker of selected country
    SelectedCountry = 'none'
    targetCountry = 'none'

    --create necessary fonts
    --dafont.com
    TDataP = 50
    TData = love.graphics.newFont('fonts/Hackney.ttf', TDataP)

    BattleFontP = 70
    BattleFont = love.graphics.newFont('fonts/Hackney.ttf', BattleFontP)

    MDataHP = 40
    MDataH = love.graphics.newFont('fonts/Cinzel-Regular.otf', MDataHP)

    MDataP = 25
    MData = love.graphics.newFont('fonts/Cinzel-Regular.otf', MDataP)

    SmallerFontP = 18
    SmallerFont = love.graphics.newFont('fonts/Cinzel-Regular.otf', SmallerFontP)

    IPCFontP = 20
    IPCFont = love.graphics.newFont('fonts/Cinzel-Regular.otf', IPCFontP)

    MoveFontP = 30
    MoveFont = love.graphics.newFont('fonts/Cinzel-Regular.otf', MoveFontP)

    TitleFontP = 30
    TitleFont = love.graphics.newFont('fonts/AmalfiCoast.ttf', TitleFontP)

    InstructionFontP = 30
    InstructionFont = love.graphics.newFont('fonts/CaviarDreams.ttf', InstructionFontP)

    --Track IPCs
    IPC = {}
    IPC['Japan'] = {['value']= 30, ['rate'] = 30}
    IPC['German'] = {['value']= 41, ['rate'] = 41}
    IPC['American'] = {['value']= 42, ['rate'] = 42}
    IPC['Britain'] = {['value']= 31, ['rate'] = 31}
    IPC['Russian'] = {['value']= 24, ['rate'] = 24}


    -- beginning instructions
    instructions1 = 'Welcome to Axis and Allies 1942.  Explore the Map.'
    instructions2 = 'Press a red dot to select a territory.'
    instructions3 = ''

    --gameState Trackers
    gamePhase = 'start'
    PlayerTurn = 'none'
    BattleState = 'incomplete'
    BattlePhase = 'roll'
    CurrentBattle = 0
    BattleQ = {}

    --Table to store rolling data during battle
    AlliedRoll = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
    AxisRoll = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}

    --mouse clicking territory tracker
    clickState = 'select'

    --load troop images and country emblems
    emblem = {}
    troop = {}
    LoadTroopImages()
    --table to store purchased units through the turn
    PurchasedUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0, ['cost'] = 0}
    --table to store moving units in phase 2
    MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.mousepressed()
    mousex, mousey = love.mouse.getPosition()
    --convert mouse coordintates to virtual window
    vmousex = mousex *(VIRTUAL_WIDTH/love.graphics.getWidth())
    vmousey = mousey *(VIRTUAL_HEIGHT/love.graphics.getHeight())

    -- how to select a territory
    for key, values in pairs(territories) do 
        --recall that everything is drawn from top left corner so inequalites may seem skewed
        if clickState=='select' then
            if ((vmousex >= values.locationx-20) and (vmousex <= values.locationx + 35)) and ((vmousey >= values.locationy-20) and (vmousey <= values.locationy + 35))then
                --reset move counter if change territories
                if gamePhase == 'CombatMove' and not (SelectedCountry == key) then
                    MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0, ['cost'] = 0}
                end
                SelectedCountry = key
            end
        elseif clickState=='target' then
            if ((vmousex >= values.locationx) and (vmousex <= values.locationx + 30)) and ((vmousey >= values.locationy) and (vmousey <= values.locationy + 30))then
                targetCountry = key
                instructions3 = ''
            end
        end
    end

    --IN Battle, how to distribute hits by clickingon troop
    if gamePhase == 'Battle' and BattlePhase == 'hits' then
        
        --german hits
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) -220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) -220 + 50) and (vmousey > 750 and vmousey < 850) then
            if territories[BattleQ[CurrentBattle]].German.infantry > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].German.infantry = territories[BattleQ[CurrentBattle]].German.infantry - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) -220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) -220 + 50) and (vmousey > 850 and vmousey < 950) then
            if territories[BattleQ[CurrentBattle]].German.artillery > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].German.artillery = territories[BattleQ[CurrentBattle]].German.artillery - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) -220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) -220 + 50) and (vmousey > 950 and vmousey < 1050) then
            if territories[BattleQ[CurrentBattle]].German.tanks > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].German.tanks = territories[BattleQ[CurrentBattle]].German.tanks - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) -220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) -220 + 50) and (vmousey > 1050 and vmousey < 1150) then
            if territories[BattleQ[CurrentBattle]].German.AAA > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].German.AAA = territories[BattleQ[CurrentBattle]].German.AAA - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) -220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) -220 + 50) and (vmousey > 1150 and vmousey < 1250) then
            if territories[BattleQ[CurrentBattle]].German.fighters > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].German.fighters = territories[BattleQ[CurrentBattle]].German.fighters - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) -220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) -220 + 50) and (vmousey > 1250 and vmousey < 1350) then
            if territories[BattleQ[CurrentBattle]].German.bombers > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].German.bombers = territories[BattleQ[CurrentBattle]].German.bombers - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end

        --Japanese hits
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) +220 + 50) and (vmousey > 750 and vmousey < 850) then
            if territories[BattleQ[CurrentBattle]].Japan.infantry > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].Japan.infantry = territories[BattleQ[CurrentBattle]].Japan.infantry - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) +220 + 50) and (vmousey > 850 and vmousey < 950) then
            if territories[BattleQ[CurrentBattle]].Japan.artillery > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].Japan.artillery = territories[BattleQ[CurrentBattle]].Japan.artillery - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) +220 + 50) and (vmousey > 950 and vmousey < 1050) then
            if territories[BattleQ[CurrentBattle]].Japan.tanks > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].Japan.tanks = territories[BattleQ[CurrentBattle]].Japan.tanks - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) +220 + 50) and (vmousey > 1050 and vmousey < 1150) then
            if territories[BattleQ[CurrentBattle]].Japan.AAA > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].Japan.AAA = territories[BattleQ[CurrentBattle]].Japan.AAA - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) +220 + 50) and (vmousey > 1150 and vmousey < 1250) then
            if territories[BattleQ[CurrentBattle]].Japan.fighters > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].Japan.fighters = territories[BattleQ[CurrentBattle]].Japan.fighters - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end
        if (vmousex > (VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (VIRTUAL_WIDTH/4 - 200) +220 + 50) and (vmousey > 1250 and vmousey < 1350) then
            if territories[BattleQ[CurrentBattle]].Japan.bombers > 0 and AxisHits > 0 then
                territories[BattleQ[CurrentBattle]].Japan.bombers = territories[BattleQ[CurrentBattle]].Japan.bombers - 1
                AxisHits = AxisHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
                if hittersAxis == 0 then
                    AxisHits = 0
                end
            end
        end

        --American Hits
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) -220+110-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) -220+110 +50) and (vmousey > 750 and vmousey < 850) then
            if territories[BattleQ[CurrentBattle]].American.infantry > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].American.infantry = territories[BattleQ[CurrentBattle]].American.infantry - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) -220+110-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) -220+110 +50) and (vmousey > 850 and vmousey < 950) then
            if territories[BattleQ[CurrentBattle]].American.artillery > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].American.artillery = territories[BattleQ[CurrentBattle]].American.artillery - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) -220+110-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) -220+110 +50) and (vmousey > 950 and vmousey < 1050) then
            if territories[BattleQ[CurrentBattle]].American.tanks > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].American.tanks = territories[BattleQ[CurrentBattle]].American.tanks - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) -220+110-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) -220+110 +50) and (vmousey > 1050 and vmousey < 1150) then
            if territories[BattleQ[CurrentBattle]].American.AAA > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].American.AAA = territories[BattleQ[CurrentBattle]].American.AAA - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) -220+110-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) -220+110 +50) and (vmousey > 1150 and vmousey < 1250) then
            if territories[BattleQ[CurrentBattle]].American.fighters > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].American.fighters = territories[BattleQ[CurrentBattle]].American.fighters - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) -220+110-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) -220+110 +50) and (vmousey > 1250 and vmousey < 1350) then
            if territories[BattleQ[CurrentBattle]].American.bombers > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].American.bombers = territories[BattleQ[CurrentBattle]].American.bombers - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end

        --Britain Hits
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+50) and (vmousey > 750 and vmousey < 850) then
            if territories[BattleQ[CurrentBattle]].Britain.infantry > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Britain.infantry = territories[BattleQ[CurrentBattle]].Britain.infantry - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+50) and (vmousey > 850 and vmousey < 950) then
            if territories[BattleQ[CurrentBattle]].Britain.artillery > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Britain.artillery = territories[BattleQ[CurrentBattle]].Britain.artillery - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+50) and (vmousey > 950 and vmousey < 1050) then
            if territories[BattleQ[CurrentBattle]].Britain.tanks > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Britain.tanks = territories[BattleQ[CurrentBattle]].Britain.tanks - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+50) and (vmousey > 1050 and vmousey < 1150) then
            if territories[BattleQ[CurrentBattle]].Britain.AAA > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Britain.AAA = territories[BattleQ[CurrentBattle]].Britain.AAA - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+50) and (vmousey > 1150 and vmousey < 1250) then
            if territories[BattleQ[CurrentBattle]].Britain.fighters > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Britain.fighters = territories[BattleQ[CurrentBattle]].Britain.fighters - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220-50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+50) and (vmousey > 1250 and vmousey < 1350) then
            if territories[BattleQ[CurrentBattle]].Britain.bombers > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Britain.bombers = territories[BattleQ[CurrentBattle]].Britain.bombers - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end

        --russian hits
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 -50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +50) and (vmousey > 750 and vmousey < 850) then
            if territories[BattleQ[CurrentBattle]].Russian.infantry > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Russian.infantry = territories[BattleQ[CurrentBattle]].Russian.infantry - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 -50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +50) and (vmousey > 850 and vmousey < 950) then
            if territories[BattleQ[CurrentBattle]].Russian.artillery > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Russian.artillery = territories[BattleQ[CurrentBattle]].Russian.artillery - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 -50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +50) and (vmousey > 950 and vmousey < 1050) then
            if territories[BattleQ[CurrentBattle]].Russian.tanks > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Russian.tanks = territories[BattleQ[CurrentBattle]].Russian.tanks - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 -50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +50) and (vmousey > 1050 and vmousey < 1150) then
            if territories[BattleQ[CurrentBattle]].Russian.AAA > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Russian.AAA = territories[BattleQ[CurrentBattle]].Russian.AAA - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 -50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +50) and (vmousey > 1150 and vmousey < 1250) then
            if territories[BattleQ[CurrentBattle]].Russian.fighters > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Russian.fighters = territories[BattleQ[CurrentBattle]].Russian.fighters - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end
        if (vmousex > (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 -50 and vmousex < (3*VIRTUAL_WIDTH/4 - 200) +220+220+110 +50) and (vmousey > 1250 and vmousey < 1350) then
            if territories[BattleQ[CurrentBattle]].Russian.bombers > 0 and AlliedHits > 0 then
                territories[BattleQ[CurrentBattle]].Russian.bombers = territories[BattleQ[CurrentBattle]].Russian.bombers - 1
                AlliedHits = AlliedHits - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
                if hittersAllied == 0 then
                    AlliedHits = 0
                end
            end
        end


        
        --use to tell if all troops are gone
        --hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
        --hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
        --set Hits to 0

        if AxisHits == 0 and AlliedHits == 0 then
            BattlePhase = 'roll'
            --track number of hits remaing to see if troops remain
            hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
            hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
            if hittersAxis == 0 and hittersAllied == 0 then
                --no change in control status
                BattleState = 'complete'
            elseif hittersAxis == 0 then
                --if axis turn nothing happens
                --dont forget to set no longer contested in all 4 win cases
                if PlayerTurn == 'German' or PlayerTurn == 'Japan' then
                    BattleState = 'complete'
                    territories[BattleQ[CurrentBattle]].contested = false
                else
                    --if allied turn
                    --subtract and add IPC rate
                    --change controller 
                    --complete battle
                    IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate = IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate - territories[BattleQ[CurrentBattle]].IPC
                    IPC[PlayerTurn].rate = IPC[PlayerTurn].rate + territories[BattleQ[CurrentBattle]].IPC
                    territories[BattleQ[CurrentBattle]].occupiedby = PlayerTurn
                    BattleState= 'complete'
                    territories[BattleQ[CurrentBattle]].contested = false
                end
            --reverse logiv of above
            elseif hittersAllied == 0 then
                if PlayerTurn == 'German' or PlayerTurn == 'Japan' then
                    IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate = IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate - territories[BattleQ[CurrentBattle]].IPC
                    IPC[PlayerTurn].rate = IPC[PlayerTurn].rate + territories[BattleQ[CurrentBattle]].IPC
                    territories[BattleQ[CurrentBattle]].occupiedby = PlayerTurn
                    BattleState = 'complete'
                    territories[BattleQ[CurrentBattle]].contested = false
                else
                    BattleState = 'complete'
                    territories[BattleQ[CurrentBattle]].contested = false
                end
                

            else
                BattlePhase = 'roll'
            end
        end
    end
end


--most of gameplay mechancis is in here.  Battle mehcanics are more in mousepressed
--the setup of thenext phase is in the previous phase 
function love.keypressed(key)
    if key =='escape' then
        love.event.quit()
    end

    --for testing turn mechanics: remove later
    --useful for testing stuff iwth different tunrs , uncomment to change turn with the space bar.
    --[[
    if key == 'space' then
        if PlayerTurn == 'none' then
            PlayerTurn = 'Russian'
        elseif PlayerTurn == 'Russian' then
            PlayerTurn = 'German'
        elseif PlayerTurn == 'German' then
            PlayerTurn = 'Britain'
        elseif PlayerTurn == 'Britain' then
            PlayerTurn = 'Japan'
        elseif PlayerTurn == 'Japan' then
            PlayerTurn = 'American'
        elseif PlayerTurn == 'American' then
            PlayerTurn = 'Russian'
        end
    end
    ]]  


    --startphase mechanis
    if (gamePhase == 'start') and (key == 'enter' or key == 'return') then
        gamePhase = 'Purchase'
        PlayerTurn = 'Russian'
        instructions1 = 'Purchase Units.  These are placed at the end of your turn.'
        instructions2 = 'Press C to confirm.  Press R to reset.'
    end

    --purchase phase mechanics
    if (gamePhase == 'Purchase') then
        if key == '1' then
            PurchasedUnits.infantry = PurchasedUnits.infantry + 1
            PurchasedUnits.cost = PurchasedUnits.cost + 3
        elseif key == '2' then
            PurchasedUnits.artillery = PurchasedUnits.artillery + 1
            PurchasedUnits.cost = PurchasedUnits.cost + 4
        elseif key == '3' then
            PurchasedUnits.tanks = PurchasedUnits.tanks + 1
            PurchasedUnits.cost = PurchasedUnits.cost + 6
        elseif key == '4' then
            PurchasedUnits.AAA = PurchasedUnits.AAA + 1
            PurchasedUnits.cost = PurchasedUnits.cost + 5
        elseif key == '5' then
            PurchasedUnits.fighters = PurchasedUnits.fighters + 1
            PurchasedUnits.cost = PurchasedUnits.cost + 10
        elseif key == '6' then
            PurchasedUnits.bombers = PurchasedUnits.bombers + 1
            PurchasedUnits.cost = PurchasedUnits.cost + 12
        elseif key == 'r' then
            instructions3 = ''
            PurchasedUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0, ['cost'] = 0}
        elseif (key == 'c') and (PurchasedUnits.cost<=IPC[PlayerTurn].value) then
            IPC[PlayerTurn].value = IPC[PlayerTurn].value - PurchasedUnits.cost
            PurchasedUnits['cost'] = 0
            gamePhase = 'CombatMove'
            instructions1 = 'Move troops into Enemy Territory.  Press F to complete movements.'
            instructions2 = 'Movable troops for each territory can be seen in Military Situation.'
            instructions3 = ''
            --copy troops in each territory to a copy troops value
            for key, values in pairs(territories) do
                if PlayerTurn == 'Russian' then
                    for k, v in pairs(values.movable) do
                        values.movable[k] = values.Russian[k]
                    end
                elseif PlayerTurn == 'German' then
                    for k, v in pairs(values.movable) do
                        values.movable[k] = values.German[k]
                    end
                elseif PlayerTurn == 'Britain' then
                    for k, v in pairs(values.movable) do
                        values.movable[k] = values.Britain[k]
                    end
                elseif PlayerTurn == 'Japan' then
                    for k, v in pairs(values.movable) do
                        values.movable[k] = values.Japan[k]
                    end
                elseif PlayerTurn == 'American' then
                    for k, v in pairs(values.movable) do
                        values.movable[k] = values.American[k]
                    end
                end
            end
        elseif (key == 'c') and not (PurchasedUnits.cost<=IPC[PlayerTurn].value) then
            instructions3 = 'Not enough IPCs.'
        end
    end

    --instruction change is in previous purchase phase
    --combat move mechanics
    if (gamePhase== 'CombatMove') then
        if key == 'm' and clickState == 'target' then
            clickState = 'select'
        elseif key == 'm' and clickState == 'select' then
            clickState = 'target'
        end

        --n confirm, move troops, contest territory, all that good stuff
        if key == 'n' then
            if targetCountry == 'none' then
                instructions3 = 'Select a target'
            elseif MovingUnits.AAA > 0 then
                instructions3 = "You can't attack with AAA"
            elseif (PlayerTurn == 'Russian' or PlayerTurn == 'American' or PlayerTurn == 'Britain') and not (territories[targetCountry].occupiedby == 'German' or territories[targetCountry].occupiedby == 'Japan') then
                instructions3 = 'Not an Enemy Territory'
            elseif (PlayerTurn == 'German' or PlayerTurn == 'Japan') and not (territories[targetCountry].occupiedby == 'Russian' or territories[targetCountry].occupiedby == 'American' or territories[targetCountry].occupiedby == 'Britain') then
                instructions3 = 'Not an Enemy Territory'
            else
                territories[targetCountry].contested = true
                --move troops from selected to target
                if PlayerTurn == 'German' then
                    for key, values in pairs(territories[targetCountry].German) do
                        territories[targetCountry].German[key] = territories[targetCountry].German[key] + MovingUnits[key]
                        territories[SelectedCountry].German[key] = territories[SelectedCountry].German[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'Russian' then
                    for key, values in pairs(territories[targetCountry].Russian) do
                        territories[targetCountry].Russian[key] = territories[targetCountry].Russian[key] + MovingUnits[key]
                        territories[SelectedCountry].Russian[key] = territories[SelectedCountry].Russian[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'Britain' then
                    for key, values in pairs(territories[targetCountry].Britain) do
                        territories[targetCountry].Britain[key] = territories[targetCountry].Britain[key] + MovingUnits[key]
                        territories[SelectedCountry].Britain[key] = territories[SelectedCountry].Britain[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'Japan' then
                    for key, values in pairs(territories[targetCountry].Japan) do
                        territories[targetCountry].Japan[key] = territories[targetCountry].Japan[key] + MovingUnits[key]
                        territories[SelectedCountry].Japan[key] = territories[SelectedCountry].Japan[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'American' then
                    for key, values in pairs(territories[targetCountry].American) do
                        territories[targetCountry].American[key] = territories[targetCountry].American[key] + MovingUnits[key]
                        territories[SelectedCountry].American[key] = territories[SelectedCountry].American[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                end
                --reset
                clickState = 'select'
                MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}
            end 
        end

        --selcet units
        if not (SelectedCountry == 'none') then
            if key == '1' and MovingUnits.infantry < territories[SelectedCountry][PlayerTurn].infantry then
                MovingUnits.infantry = MovingUnits.infantry + 1
            elseif key == '2' and MovingUnits.artillery < territories[SelectedCountry][PlayerTurn].artillery then
                MovingUnits.artillery = MovingUnits.artillery + 1
            elseif key == '3' and MovingUnits.tanks < territories[SelectedCountry][PlayerTurn].tanks then
                MovingUnits.tanks = MovingUnits.tanks + 1
            elseif key == '4' and MovingUnits.AAA < territories[SelectedCountry][PlayerTurn].AAA then
                MovingUnits.AAA = MovingUnits.AAA + 1
            elseif key == '5' and MovingUnits.fighters < territories[SelectedCountry][PlayerTurn].fighters then
                MovingUnits.fighters = MovingUnits.fighters + 1
            elseif key == '6' and MovingUnits.bombers < territories[SelectedCountry][PlayerTurn].bombers then
                MovingUnits.bombers = MovingUnits.bombers + 1
            elseif key == 'r' then
                --also resets when move cursor
                MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}

                --reset m click as well
                clickState = 'select'

                --reset target country
                targetCountry = 'none'

                instructions3 = ''
            end
        end

        --complete phase
        --setup Battle phase
        if key == 'f' then
            gamePhase = 'Battle'
            --isntructions for battle phase
            instructions1 = 'Press R to roll dice.  You must roll at or below the target number for each unit.'
            instructions2 = 'Click on Units to distribute Hits.  All hits must be distributed before the next roll.'
            instructions3 = 'When the Battle is complete press C.'
            BattleQ = {}
            BattleNumber = 1
            --create list to make each next battle
            for key, value in pairs(territories) do
                if territories[key].contested == true then
                    BattleQ[BattleNumber] = key
                    BattleNumber = BattleNumber + 1
                end
            end
            --skip battle if no battles need to be done
            if BattleNumber == 1 then
                gamePhase = 'Redeploy'
                instructions1 = 'Redeploy Troops to Friendly Territory.  Press Z to complete movements.'
                instructions2 = 'Movable troops for each territory can be seen in Military Situation.'
                instructions3 = ''
                targetCountry = 'none'
                --movable troops
                for key, values in pairs(territories) do
                    if PlayerTurn == 'Russian' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.Russian[k]
                        end
                    elseif PlayerTurn == 'German' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.German[k]
                        end
                    elseif PlayerTurn == 'Britain' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.Britain[k]
                        end
                    elseif PlayerTurn == 'Japan' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.Japan[k]
                        end
                    elseif PlayerTurn == 'American' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.American[k]
                        end
                    end
                end
            end
            CurrentBattle = BattleNumber - 1
            AxisHits = 0
            AlliedHits = 0
            --avoid an erros
            if not (BattleNumber == 1) then
                CreateBattleStats(BattleQ[CurrentBattle])
            end
        end
            
    end

    --battle mechanics.  Part of battle mechanics is in the mouseclicked seciton
    if gamePhase == 'Battle' then
        --rest of battle mechanics in mouseclick
        --completion of a battle
        if BattleState == 'complete' then

            if key == 'c' and CurrentBattle > 1 then
                CurrentBattle = CurrentBattle - 1
                CreateBattleStats(BattleQ[CurrentBattle])
                AxisHits = 0
                AlliedHits = 0
                BattleState = 'incomplete'
            elseif key == 'c' and CurrentBattle == 1 then
                gamePhase = 'Redeploy'
                instructions1 = 'Redeploy Troops to Friendly Territory.  Press Z to complete movements.'
                instructions2 = 'Movable troops for each territory can be seen in Military Situation.'
                instructions3 = ''
                targetCountry = 'none'
                --Movable Troops again
                --copy troops in each territory to a copy troops value
                for key, values in pairs(territories) do
                    if PlayerTurn == 'Russian' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.Russian[k]
                        end
                    elseif PlayerTurn == 'German' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.German[k]
                        end
                    elseif PlayerTurn == 'Britain' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.Britain[k]
                        end
                    elseif PlayerTurn == 'Japan' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.Japan[k]
                        end
                    elseif PlayerTurn == 'American' then
                        for k, v in pairs(values.movable) do
                            values.movable[k] = values.American[k]
                        end
                    end
                end
                BattleState='incomplete'
            end
        end
        if key == 'r' and BattlePhase == 'roll' then
            -- if moved into an empty territory
            hittersAxis = AxisRoll[4] + AxisRoll[3] + AxisRoll[2] + AxisRoll[1]
            hittersAllied = AlliedRoll[4] + AlliedRoll[3] + AlliedRoll[2] + AlliedRoll[1]
            if hitterAxis == 0 or hittersAllied == 0 then
                BattleState = 'complete'
                --adjust ipcs and stuff
                if hittersAxis == 0 then
                    --if axis turn nothing happens
                    --dont forget to set no longer contested in all 4 win cases
                    if PlayerTurn == 'German' or PlayerTurn == 'Japan' then
                        BattleState = 'complete'
                        territories[BattleQ[CurrentBattle]].contested = false
                    else
                        --if allied turn
                        --subtract and add IPC rate
                        --change controller 
                        --complete battle
                        IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate = IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate - territories[BattleQ[CurrentBattle]].IPC
                        IPC[PlayerTurn].rate = IPC[PlayerTurn].rate + territories[BattleQ[CurrentBattle]].IPC
                        territories[BattleQ[CurrentBattle]].occupiedby = PlayerTurn
                        BattleState= 'complete'
                        territories[BattleQ[CurrentBattle]].contested = false
                    end
                --reverse logiv of above
                elseif hittersAllied == 0 then
                    if PlayerTurn == 'German' or PlayerTurn == 'Japan' then
                        IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate = IPC[territories[BattleQ[CurrentBattle]].occupiedby].rate - territories[BattleQ[CurrentBattle]].IPC
                        IPC[PlayerTurn].rate = IPC[PlayerTurn].rate + territories[BattleQ[CurrentBattle]].IPC
                        territories[BattleQ[CurrentBattle]].occupiedby = PlayerTurn
                        BattleState = 'complete'
                        territories[BattleQ[CurrentBattle]].contested = false
                    else
                        BattleState = 'complete'
                        territories[BattleQ[CurrentBattle]].contested = false
                    end
                end
            end
            for key, values in pairs(AlliedRoll) do
                for i = values, 1, - 1 do
                    if math.random(1,6) <= key then
                        AxisHits = AxisHits + 1
                    end
                end
            end
            for key, values in pairs(AxisRoll) do
                for i = values, 1, - 1 do
                    if math.random(1,6) <= key then
                        AlliedHits = AlliedHits + 1
                    end
                end
            end

            BattlePhase = 'hits'
            --hits section addressed in mouseclick
        end
    end

    --second move phase mechanics, similar to comabat move
    if gamePhase == 'Redeploy' then
        if key == 'm' and clickState == 'target' then
            clickState = 'select'
        elseif key == 'm' and clickState == 'select' then
            clickState = 'target'
        end

        --n confirm, move troops, contest territory, all that good stuff
        if key == 'n' then
            if targetCountry == 'none' then
                instructions3 = 'Select a target'
            elseif (PlayerTurn == 'Russian' or PlayerTurn == 'American' or PlayerTurn == 'Britain') and (territories[targetCountry].occupiedby == 'German' or territories[targetCountry].occupiedby == 'Japan') then
                instructions3 = 'Not a Friendly Territory'
            elseif (PlayerTurn == 'German' or PlayerTurn == 'Japan') and (territories[targetCountry].occupiedby == 'Russian' or territories[targetCountry].occupiedby == 'American' or territories[targetCountry].occupiedby == 'Britain') then
                instructions3 = 'Not a Friendly Territory'
            else
                --move troops from selected to target
                if PlayerTurn == 'German' then
                    for key, values in pairs(territories[targetCountry].German) do
                        territories[targetCountry].German[key] = territories[targetCountry].German[key] + MovingUnits[key]
                        territories[SelectedCountry].German[key] = territories[SelectedCountry].German[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'Russian' then
                    for key, values in pairs(territories[targetCountry].Russian) do
                        territories[targetCountry].Russian[key] = territories[targetCountry].Russian[key] + MovingUnits[key]
                        territories[SelectedCountry].Russian[key] = territories[SelectedCountry].Russian[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'Britain' then
                    for key, values in pairs(territories[targetCountry].Britain) do
                        territories[targetCountry].Britain[key] = territories[targetCountry].Britain[key] + MovingUnits[key]
                        territories[SelectedCountry].Britain[key] = territories[SelectedCountry].Britain[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'Japan' then
                    for key, values in pairs(territories[targetCountry].Japan) do
                        territories[targetCountry].Japan[key] = territories[targetCountry].Japan[key] + MovingUnits[key]
                        territories[SelectedCountry].Japan[key] = territories[SelectedCountry].Japan[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                elseif PlayerTurn == 'American' then
                    for key, values in pairs(territories[targetCountry].American) do
                        territories[targetCountry].American[key] = territories[targetCountry].American[key] + MovingUnits[key]
                        territories[SelectedCountry].American[key] = territories[SelectedCountry].American[key] - MovingUnits[key]
                        territories[SelectedCountry].movable[key] = territories[SelectedCountry].movable[key] - MovingUnits[key]
                    end
                end
                --reset
                clickState = 'select'
                MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}
            end 
        end

        --selcet units
        if not (SelectedCountry == 'none') then
            if key == '1' and MovingUnits.infantry < territories[SelectedCountry][PlayerTurn].infantry then
                MovingUnits.infantry = MovingUnits.infantry + 1
            elseif key == '2' and MovingUnits.artillery < territories[SelectedCountry][PlayerTurn].artillery then
                MovingUnits.artillery = MovingUnits.artillery + 1
            elseif key == '3' and MovingUnits.tanks < territories[SelectedCountry][PlayerTurn].tanks then
                MovingUnits.tanks = MovingUnits.tanks + 1
            elseif key == '4' and MovingUnits.AAA < territories[SelectedCountry][PlayerTurn].AAA then
                MovingUnits.AAA = MovingUnits.AAA + 1
            elseif key == '5' and MovingUnits.fighters < territories[SelectedCountry][PlayerTurn].fighters then
                MovingUnits.fighters = MovingUnits.fighters + 1
            elseif key == '6' and MovingUnits.bombers < territories[SelectedCountry][PlayerTurn].bombers then
                MovingUnits.bombers = MovingUnits.bombers + 1
            elseif key == 'r' then
                --also resets when move cursor
                MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}

                --reset m click as well
                clickState = 'select'

                --reset target country
                targetCountry = 'none'

                instructions3 = ''
            end
        end

        if key == 'z' then
            gamePhase = 'Place'
            instructions1 = 'Place your units that you purchased at the beginning of the turn.'
            instructions2 = 'When you are finished, press D and pass the game to the next player.'
            --mvoing units 0

            --[[reset moving units?
            for key, value in pairs(MovingUnits) do
                MovingUnits[key] = 0
            end]]
        end

    end

    --placing and end of turn mechanics
    if gamePhase == 'Place' then
        --select units to place
        if key == '1' and MovingUnits.infantry < PurchasedUnits.infantry then
            MovingUnits.infantry = MovingUnits.infantry + 1
        elseif key == '2' and MovingUnits.artillery < PurchasedUnits.artillery then
            MovingUnits.artillery = MovingUnits.artillery + 1
        elseif key == '3' and MovingUnits.tanks < PurchasedUnits.tanks then
            MovingUnits.tanks = MovingUnits.tanks + 1
        elseif key == '4' and MovingUnits.AAA < PurchasedUnits.AAA then
            MovingUnits.AAA = MovingUnits.AAA + 1
        elseif key == '5' and MovingUnits.fighters < PurchasedUnits.fighters then
            MovingUnits.fighters = MovingUnits.fighters + 1
        elseif key == '6' and MovingUnits.bombers < PurchasedUnits.bombers then
            MovingUnits.bombers = MovingUnits.bombers + 1
        elseif key == 'r' then
            --also resets when move cursor
            MovingUnits = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}
        end

        if key == 'p' and not (SelectedCountry == 'none') then
            for key, value in pairs(MovingUnits) do
                PurchasedUnits[key] = PurchasedUnits[key] - MovingUnits[key]
                --add to territory
                --make sure territory is friendly
                if PlayerTurn == 'German'  and (territories[SelectedCountry].occupiedby == 'German' or territories[SelectedCountry].occupiedby == 'Japan') then
                    territories[SelectedCountry].German[key] = territories[SelectedCountry].German[key] + MovingUnits[key]
                elseif PlayerTurn == 'Russian' and (territories[SelectedCountry].occupiedby == 'Russian' or territories[SelectedCountry].occupiedby == 'American' or territories[SelectedCountry].occupiedby == 'Britain') then
                    territories[SelectedCountry].Russian[key] = territories[SelectedCountry].Russian[key] + MovingUnits[key]
                elseif PlayerTurn == 'Britain' and (territories[SelectedCountry].occupiedby == 'Russian' or territories[SelectedCountry].occupiedby == 'American' or territories[SelectedCountry].occupiedby == 'Britain') then
                    territories[SelectedCountry].Britain[key] = territories[SelectedCountry].Britain[key] + MovingUnits[key]
                elseif PlayerTurn == 'Japan' and (territories[SelectedCountry].occupiedby == 'German' or territories[SelectedCountry].occupiedby == 'Japan')then
                    territories[SelectedCountry].Japan[key] = territories[SelectedCountry].Japan[key] + MovingUnits[key]
                elseif PlayerTurn == 'American' and (territories[SelectedCountry].occupiedby == 'Russian' or territories[SelectedCountry].occupiedby == 'American' or territories[SelectedCountry].occupiedby == 'Britain') then
                    territories[SelectedCountry].American[key] = territories[SelectedCountry].American[key] + MovingUnits[key]
                else
                    instructions3 = ':  Friendly Territories Only'
                    --undo purchased delete
                    PurchasedUnits[key] = PurchasedUnits[key] + MovingUnits[key]
                end
                MovingUnits[key] = 0
            end
        end

        if key == 'd' then
            IPC[PlayerTurn].value = IPC[PlayerTurn].value + IPC[PlayerTurn].rate
            if PlayerTurn == 'Russian' then
                PlayerTurn = 'German'
            elseif PlayerTurn == 'German' then
                PlayerTurn = 'Britain'
            elseif PlayerTurn == 'Britain' then
                PlayerTurn = 'Japan'
            elseif PlayerTurn == 'Japan' then
                PlayerTurn = 'American'
            elseif PlayerTurn == 'American' then
                PlayerTurn = 'Russian'
            end
            gamePhase = 'Purchase'
            instructions1 = 'Purchase Units.  These are placed at the end of your turn.'
            instructions2 = 'Press C to confirm.  Press R to reset.'
        end


    end



end

function love.update(dt)
end

function love.draw()
    push:apply('start')

    --background color
    --love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.clear(80/255, 90/255, 104/255, 255/255)
    
    --BattlePhase is different
    if not (gamePhase == 'Battle') then
        --load the game board
        map:render()

        --render the IPC count
        drawIPC()

        --render the title and isntrucitons
        drawTitle()
        
        --render selected country data
        drawTInfo(SelectedCountry)

        --render currentTurn, in title
        drawTurn()

        --render the game corner
        if gamePhase == 'start' then 
            startPhase()
        elseif gamePhase == 'Purchase' then
            PurchasePhase()
        elseif gamePhase == 'CombatMove' then
            CombatMovePhase()
        --elseif gamePhase == 'Battle' then
            --CombatPhase()
            --Battle's will be an entire seperate thign
        elseif gamePhase == 'Redeploy' then
            --alost identical to combat move except move into friendly territory only
            RedeployPhase()
        elseif gamePhase == 'Place' then
            PlacePhase()
        end 
    else
        --combat is completely different
        CombatPhase(CurrentBattle)
        --made for battle to look better
        drawBTurn()
    end

    push:apply('end')
end


--loading pngs of troops
function LoadTroopImages()
    --heights Infatnry: 100, artillery = 30, tank = 40,  AAA = 70, figher 80, bomber 80
    troop['infantry'] = {}
    troop['artillery'] = {}
    troop['tank'] = {}
    troop['AAA'] = {}
    troop['fighter'] = {}
    troop['bomber'] = {}

    TroopStats = love.graphics.newImage('Troops/UnitStats.png')

    troop['infantry']['Russian'] = love.graphics.newImage('Troops/RussianInfantry.png')
    troop['artillery']['Russian'] = love.graphics.newImage('Troops/RussianArtillery.png')
    troop['tank']['Russian'] = love.graphics.newImage('Troops/RussianTank.png')
    troop['AAA']['Russian'] = love.graphics.newImage('Troops/RussianAAA.png')
    troop['fighter']['Russian'] = love.graphics.newImage('Troops/RussianFighter.png')
    troop['bomber']['Russian'] = love.graphics.newImage('Troops/RussianBomber.png')

    troop['infantry']['German'] = love.graphics.newImage('Troops/GermanInfantry.png')
    troop['artillery']['German'] = love.graphics.newImage('Troops/GermanArtillery.png')
    troop['tank']['German'] = love.graphics.newImage('Troops/GermanTank.png')
    troop['AAA']['German'] = love.graphics.newImage('Troops/GermanAAA.png')
    troop['fighter']['German'] = love.graphics.newImage('Troops/GermanFighter.png')
    troop['bomber']['German'] = love.graphics.newImage('Troops/GermanBomber.png')

    troop['infantry']['American'] = love.graphics.newImage('Troops/AmericanInfantry.png')
    troop['artillery']['American'] = love.graphics.newImage('Troops/AmericanArtillery.png')
    troop['tank']['American'] = love.graphics.newImage('Troops/AmericanTank.png')
    troop['AAA']['American'] = love.graphics.newImage('Troops/AmericanAAA.png')
    troop['fighter']['American'] = love.graphics.newImage('Troops/AmericanFighter.png')
    troop['bomber']['American'] = love.graphics.newImage('Troops/AmericanBomber.png')

    troop['infantry']['Britain'] = love.graphics.newImage('Troops/BritainInfantry.png')
    troop['artillery']['Britain'] = love.graphics.newImage('Troops/BritainArtillery.png')
    troop['tank']['Britain'] = love.graphics.newImage('Troops/BritainTank.png')
    troop['AAA']['Britain'] = love.graphics.newImage('Troops/BritainAAA.png')
    troop['fighter']['Britain'] = love.graphics.newImage('Troops/BritainFighter.png')
    troop['bomber']['Britain'] = love.graphics.newImage('Troops/BritainBomber.png')

    troop['infantry']['Japan'] = love.graphics.newImage('Troops/JapanInfantry.png')
    troop['artillery']['Japan'] = love.graphics.newImage('Troops/JapanArtillery.png')
    troop['tank']['Japan'] = love.graphics.newImage('Troops/JapanTank.png')
    troop['AAA']['Japan'] = love.graphics.newImage('Troops/JapanAAA.png')
    troop['fighter']['Japan'] = love.graphics.newImage('Troops/JapanFighter.png')
    troop['bomber']['Japan'] = love.graphics.newImage('Troops/JapanBomber.png')
    
    
    
    emblem['Russian'] = love.graphics.newImage('Emblems/RussianEmblem.png')
    emblem['Britain'] = love.graphics.newImage('Emblems/BritainEmblem.png')
    emblem['German'] = love.graphics.newImage('Emblems/GermanEmblem.png')
    emblem['Japan'] = love.graphics.newImage('Emblems/JapanEmblem.png')
    emblem['American'] = love.graphics.newImage('Emblems/AmericanEmblem.png')
    

    
end
