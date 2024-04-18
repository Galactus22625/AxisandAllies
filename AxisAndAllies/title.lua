-- this page for drawing the title and various instructions needed for each stage

--Draws stuff at the top of the screen
function drawTitle()
    --Title
    love.graphics.setColor(0/255, 0/255, 0/255)
    love.graphics.setFont(TitleFont)
    love.graphics.print('Axis and Allies: 1942', VIRTUAL_WIDTH/2 -225, 20)

    --Instructions are in the main page for initalization
    --if game state...
    love.graphics.setFont(InstructionFont)
    love.graphics.setColor(200/255, 80/255, 80/255)
    love.graphics.print(instructions1, VIRTUAL_WIDTH/2 -700, 120)
    love.graphics.print(instructions2, VIRTUAL_WIDTH/2 -700, 160)

end

--draws the current turn 
function drawTurn()
    --at 500
    if not (PlayerTurn == 'none') then
        if PlayerTurn == 'Russian' then
            love.graphics.setColor(92/255, 38/255, 2/255)
        elseif PlayerTurn == 'German' then
            love.graphics.setColor(22/255, 37/255, 48/255)
        elseif PlayerTurn == 'Britain' then
            love.graphics.setColor(181/255, 149/255, 105/255)
        elseif PlayerTurn == 'Japan' then
            love.graphics.setColor(161/255, 104/255, 39/255)
        elseif PlayerTurn == 'American' then
            love.graphics.setColor(107/255, 118/255, 43/255)
        end
        love.graphics.setFont(MData)
        love.graphics.print('Current Turn: ', 500, 50)
        love.graphics.setColor(.5,.5,.5)
        love.graphics.draw(emblem[PlayerTurn], 730, 50, 0, 1, 1, 0, 45)
    end
end


--turn function modified for during battle when the scren is different.
function drawBTurn()
    --at 500
    if not (PlayerTurn == 'none') then
        if PlayerTurn == 'Russian' then
            love.graphics.setColor(92/255, 38/255, 2/255)
        elseif PlayerTurn == 'German' then
            love.graphics.setColor(22/255, 37/255, 48/255)
        elseif PlayerTurn == 'Britain' then
            love.graphics.setColor(181/255, 149/255, 105/255)
        elseif PlayerTurn == 'Japan' then
            love.graphics.setColor(161/255, 104/255, 39/255)
        elseif PlayerTurn == 'American' then
            love.graphics.setColor(107/255, 118/255, 43/255)
        end
        love.graphics.setFont(TData)
        love.graphics.print('Attacker: ', VIRTUAL_WIDTH/2 - 150, 220)
        love.graphics.setColor(.5,.5,.5)
        love.graphics.draw(emblem[PlayerTurn], VIRTUAL_WIDTH/2 + 30, 260, 0, 1, 1, 0, 45)
    end
end