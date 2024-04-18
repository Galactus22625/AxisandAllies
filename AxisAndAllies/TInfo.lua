--for displaying the selected countries info bottom right
--top of map at 214
--map width 1848

--current is the selcted country
--draws the data that appears to the right of the map
function drawTInfo(current)
    
    --set section color
    love.graphics.setColor(37/255, 140/255,144/255)

    --set title font
    love.graphics.setFont(TData)

    --upper line seperation
    local tseperation = TDataP * 1.5

    --create title
    --halfway to center, eyeballed
    local HeaderOffset = string.len('Selected Territory: ' .. current) * TDataP/6
    love.graphics.print('Selected Territory: ' .. current, 1848 + (VIRTUAL_WIDTH-1848)/2, 220, 0 , 1, 1, HeaderOffset)

    -- territory data drawing
    if not (current == 'none') then
        --create controlled by and IPC Value
        if territories[current].occupiedby == 'Russian' then
            HeaderOffset = string.len('Controlled By: Russia') * TDataP/6
            love.graphics.print('Controlled By: Russia', 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + tseperation, 0 , 1, 1, HeaderOffset)
        elseif territories[current].occupiedby == 'German' then
            HeaderOffset = string.len('Controlled By: Germany') * TDataP/6
            love.graphics.print('Controlled By: Germany', 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + tseperation, 0 , 1, 1, HeaderOffset)
        elseif territories[current].occupiedby == 'Britain' then
            HeaderOffset = string.len('Controlled By: Britain') * TDataP/6
            love.graphics.print('Controlled By: Britain', 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + tseperation, 0 , 1, 1, HeaderOffset)
        elseif territories[current].occupiedby == 'Japan' then
            HeaderOffset = string.len('Controlled By: Japan') * TDataP/6
            love.graphics.print('Controlled By: Japan', 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + tseperation, 0 , 1, 1, HeaderOffset)
        elseif territories[current].occupiedby == 'American' then
            HeaderOffset = string.len('Controlled By: America') * TDataP/6
            love.graphics.print('Controlled By: America', 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + tseperation, 0 , 1, 1, HeaderOffset)
        end
        --HeaderOffset = string.len('Controlled By: ' .. territories[current].occupiedby) * TDataP/6
        --love.graphics.print('Controlled By: ' .. territories[current].occupiedby, 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + tseperation, 0 , 1, 1, HeaderOffset)

        HeaderOffset = string.len('IPC Value: ' .. territories[current].IPC) * TDataP/6
        love.graphics.print('IPC Value: ' .. territories[current].IPC, 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + 2* tseperation, 0 , 1, 1, HeaderOffset)

    end

    --section speration
    local Sseperation = 2* tseperation + 2 * TDataP 

    --set section color
    love.graphics.setColor(160/255, 37/255, 37/255)

    --set title font
    love.graphics.setFont(MDataH)

    HeaderOffset = string.len('Military Situation') * MDataHP/3.7
    love.graphics.print('Military Situation', 1848 + (VIRTUAL_WIDTH-1848)/2, 220 + Sseperation, 0 , 1, 1, HeaderOffset)


    --troop data drawing
    if not (current == 'none') and (territories[current].type == 'land') then
        love.graphics.setFont(MData)

        --seperation in lower sections
        local LSseperation = MDataP *1.5

        --german color
        love.graphics.setColor(22/255, 37/255, 48/255)
        love.graphics.print('Germans', 1848 + (VIRTUAL_WIDTH-1848)/4 - 80, 220 + Sseperation + LSseperation + 20)
        love.graphics.print('Infantry: ' .. tostring(territories[current].German.infantry), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 2* LSseperation + 20)
        love.graphics.print('Artillery: ' .. tostring(territories[current].German.artillery), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 3* LSseperation + 20)
        love.graphics.print('Tanks: ' .. tostring(territories[current].German.tanks), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 4* LSseperation + 20)
        love.graphics.print('AAA: ' .. tostring(territories[current].German.AAA), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 5* LSseperation + 20)
        love.graphics.print('Fighters: ' .. tostring(territories[current].German.fighters), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 6* LSseperation + 20)
        love.graphics.print('Bombers: ' .. tostring(territories[current].German.bombers), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 7* LSseperation + 20)
       
        --americans
        love.graphics.setColor(107/255, 118/255, 43/255)
        love.graphics.print('Americans', 1848 + 3*(VIRTUAL_WIDTH-1848)/4 - 80, 220 + Sseperation + LSseperation + 20)
        love.graphics.print('Infantry: ' .. tostring(territories[current].American.infantry), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 2* LSseperation + 20)
        love.graphics.print('Artillery: ' .. tostring(territories[current].American.artillery), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 3* LSseperation + 20)
        love.graphics.print('Tanks: ' .. tostring(territories[current].American.tanks), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 4* LSseperation + 20)
        love.graphics.print('AAA: ' .. tostring(territories[current].American.AAA), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 5* LSseperation + 20)
        love.graphics.print('Fighters: ' .. tostring(territories[current].American.fighters), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 6* LSseperation + 20)
        love.graphics.print('Bombers: ' .. tostring(territories[current].American.bombers), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + 7* LSseperation + 20)

        --japanese
        love.graphics.setColor(161/255, 104/255, 39/255)
        love.graphics.print('Japanese', 1848 + (VIRTUAL_WIDTH-1848)/4 - 80, 220 + Sseperation + 9* LSseperation + 20)
        love.graphics.print('Infantry: ' .. tostring(territories[current].Japan.infantry), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+2)* LSseperation + 20)
        love.graphics.print('Artillery: ' .. tostring(territories[current].Japan.artillery), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+3)* LSseperation + 20)
        love.graphics.print('Tanks: ' .. tostring(territories[current].Japan.tanks), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+4)* LSseperation + 20)
        love.graphics.print('AAA: ' .. tostring(territories[current].Japan.AAA), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+5)* LSseperation + 20)
        love.graphics.print('Fighters: ' .. tostring(territories[current].Japan.fighters), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+6)* LSseperation + 20)
        love.graphics.print('Bombers: ' .. tostring(territories[current].Japan.bombers), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+7)* LSseperation + 20)

        --british
        love.graphics.setColor(181/255, 149/255, 105/255)
        love.graphics.print('British', 1848 + 3*(VIRTUAL_WIDTH-1848)/4 - 80, 220 + Sseperation + 9* LSseperation + 20)
        love.graphics.print('Infantry: ' .. tostring(territories[current].Britain.infantry), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+2)* LSseperation + 20)
        love.graphics.print('Artillery: ' .. tostring(territories[current].Britain.artillery), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+3)* LSseperation + 20)
        love.graphics.print('Tanks: ' .. tostring(territories[current].Britain.tanks), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+4)* LSseperation + 20)
        love.graphics.print('AAA: ' .. tostring(territories[current].Britain.AAA), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+5)* LSseperation + 20)
        love.graphics.print('Fighters: ' .. tostring(territories[current].Britain.fighters), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+6)* LSseperation + 20)
        love.graphics.print('Bombers: ' .. tostring(territories[current].Britain.bombers), (1848 + 3*(VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (8+7)* LSseperation + 20)

        --russian
        if not (gamePhase == 'CombatMove' or gamePhase == 'Redeploy') then
            love.graphics.setColor(92/255, 38/255, 2/255)
            love.graphics.print('Russian', 1848 + (VIRTUAL_WIDTH-1848)/2 - 80, 220 + Sseperation + 17* LSseperation + 20)
            love.graphics.print('Infantry: ' .. tostring(territories[current].Russian.infantry), (1848 + (VIRTUAL_WIDTH-1848)/2) - 80, 220 + Sseperation + (16+2)* LSseperation + 20)
            love.graphics.print('Artillery: ' .. tostring(territories[current].Russian.artillery), (1848 + (VIRTUAL_WIDTH-1848)/2) - 80, 220 + Sseperation + (16+3)* LSseperation + 20)
            love.graphics.print('Tanks: ' .. tostring(territories[current].Russian.tanks), (1848 + (VIRTUAL_WIDTH-1848)/2) - 80, 220 + Sseperation + (16+4)* LSseperation + 20)
            love.graphics.print('AAA: ' .. tostring(territories[current].Russian.AAA), (1848 + (VIRTUAL_WIDTH-1848)/2) - 80, 220 + Sseperation + (16+5)* LSseperation + 20)
            love.graphics.print('Fighters: ' .. tostring(territories[current].Russian.fighters), (1848 + (VIRTUAL_WIDTH-1848)/2) - 80, 220 + Sseperation + (16+6)* LSseperation + 20)
            love.graphics.print('Bombers: ' .. tostring(territories[current].Russian.bombers), (1848 + (VIRTUAL_WIDTH-1848)/2) - 80, 220 + Sseperation + (16+7)* LSseperation + 20)
        end

        --only for movement phase
        if (gamePhase == 'CombatMove') or (gamePhase == 'Redeploy') then

            love.graphics.setColor(92/255, 38/255, 2/255)
            love.graphics.print('Russian', 1848 + 3* (VIRTUAL_WIDTH-1848)/4 - 80, 220 + Sseperation + 17* LSseperation + 20)
            love.graphics.print('Infantry: ' .. tostring(territories[current].Russian.infantry), (1848 + 3* (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+2)* LSseperation + 20)
            love.graphics.print('Artillery: ' .. tostring(territories[current].Russian.artillery), (1848 + 3* (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+3)* LSseperation + 20)
            love.graphics.print('Tanks: ' .. tostring(territories[current].Russian.tanks), (1848 + 3* (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+4)* LSseperation + 20)
            love.graphics.print('AAA: ' .. tostring(territories[current].Russian.AAA), (1848 + 3* (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+5)* LSseperation + 20)
            love.graphics.print('Fighters: ' .. tostring(territories[current].Russian.fighters), (1848 + 3* (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+6)* LSseperation + 20)
            love.graphics.print('Bombers: ' .. tostring(territories[current].Russian.bombers), (1848 + 3* (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+7)* LSseperation + 20)

            love.graphics.setColor(37/255, 140/255,144/255)
            love.graphics.print('Movable Troops', 1848 + (VIRTUAL_WIDTH-1848)/4 - 80, 220 + Sseperation + 17* LSseperation + 20)
            love.graphics.print('Infantry: ' .. tostring(territories[current].movable.infantry), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+2)* LSseperation + 20)
            love.graphics.print('Artillery: ' .. tostring(territories[current].movable.artillery), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+3)* LSseperation + 20)
            love.graphics.print('Tanks: ' .. tostring(territories[current].movable.tanks), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+4)* LSseperation + 20)
            love.graphics.print('AAA: ' .. tostring(territories[current].movable.AAA), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+5)* LSseperation + 20)
            love.graphics.print('Fighters: ' .. tostring(territories[current].movable.fighters), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+6)* LSseperation + 20)
            love.graphics.print('Bombers: ' .. tostring(territories[current].movable.bombers), (1848 + (VIRTUAL_WIDTH-1848)/4) - 80, 220 + Sseperation + (16+7)* LSseperation + 20)
        end
    end

end