

--Each territory is an object.  create class of objects
territory = Class{}


--input to create a territory
function territory:init(posx,posy,startCountry,IPC, g, a, j, b, r, type, contested, border)
    self.locationx=posx
    self.locationy=posy
    self.occupiedby=startCountry
    --Ipc value of terriotry
    self.IPC = IPC
   
    --troop counter
    self.German = g
    self.American = a
    self.Japan = j
    self.Britain = b
    self.Russian = r

    --for future use, sea or land
    self.type = type

    --for battle
    self.contested = contested

    --for future use, movement cap
    self.border = border

    --for moving troops
    self.movable = {['tanks']=0, ['artillery'] = 0, ['infantry']= 0,['AAA']=0, ['fighters']= 0, ['bombers'] = 0}
    --can access through germanTroops.tanks


end

function territory:update(dt)
end

function territory:render()
    --print the clicking dot
    love.graphics.setColor(1,0,0)
    love.graphics.circle('fill', self.locationx, self.locationy, 5)

    --possibly add more data like showing troops later futre
end