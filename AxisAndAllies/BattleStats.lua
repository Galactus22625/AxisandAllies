--Create Battle stats function
--This funciton tells how many rolls on each side in a territory.  the input is the battle territory.
--also can be used to tell if all fo one side is eliminated
function CreateBattleStats(battlet)
    --axis attack
    if PlayerTurn == 'German' or PlayerTurn == 'Japan' then
        AxisRoll[4] = territories[battlet].German.bombers + territories[battlet].Japan.bombers
        AxisRoll[3] = territories[battlet].German.fighters + territories[battlet].German.tanks + territories[battlet].Japan.fighters +territories[battlet].Japan.tanks
        AxisRoll[2] = territories[battlet].German.artillery + territories[battlet].Japan.artillery
        AxisRoll[1] = territories[battlet].German.infantry + territories[battlet].Japan.infantry

        AlliedRoll[4] = territories[battlet].American.fighters + territories[battlet].Britain.fighters + territories[battlet].Russian.fighters
        AlliedRoll[3] = territories[battlet].American.tanks + territories[battlet].Britain.tanks + territories[battlet].Russian.tanks
        AlliedRoll[2] = territories[battlet].American.artillery + territories[battlet].Britain.artillery + territories[battlet].Russian.artillery + territories[battlet].American.infantry + territories[battlet].Britain.infantry + territories[battlet].Russian.infantry
        AlliedRoll[1] = territories[battlet].American.bombers + territories[battlet].Britain.bombers + territories[battlet].Russian.bombers + territories[battlet].American.AAA + territories[battlet].Britain.AAA + territories[battlet].Russian.AAA
    --allies attack other condition
    else
        AxisRoll[4] = territories[battlet].German.fighters + territories[battlet].Japan.fighters
        AxisRoll[3] = territories[battlet].German.tanks +territories[battlet].Japan.tanks
        AxisRoll[2] = territories[battlet].German.artillery + territories[battlet].Japan.artillery + territories[battlet].German.infantry + territories[battlet].Japan.infantry
        AxisRoll[1] = territories[battlet].German.bombers + territories[battlet].Japan.bombers + territories[battlet].German.AAA + territories[battlet].Japan.AAA
    
        AlliedRoll[4] = territories[battlet].American.bombers + territories[battlet].Britain.bombers + territories[battlet].Russian.bombers 
        AlliedRoll[3] = territories[battlet].American.tanks + territories[battlet].Britain.tanks + territories[battlet].Russian.tanks + territories[battlet].American.fighters + territories[battlet].Britain.fighters + territories[battlet].Russian.fighters
        AlliedRoll[2] =territories[battlet].American.artillery + territories[battlet].Britain.artillery + territories[battlet].Russian.artillery
        AlliedRoll[1] =territories[battlet].American.infantry + territories[battlet].Britain.infantry + territories[battlet].Russian.infantry
    end

end