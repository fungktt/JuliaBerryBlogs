using PiCraft

post("Welcome to Minecraft Whac-a-Block") 

tile = getTile()

setBlocks(tile .+ (-1, 0, 3), tile .+ (1, 2, 3), Block(1))

function difficulty()
    println("Enter difficulty (1-10)")
    diff = 1.1 - (parse(Int64, readline()) / 10)
    println("Please return to Minecraft!")
    return diff
end
    

function main()
    level = difficulty()
    post("Get ready...")
    sleep(2)
    post("Go!")
    blocksLit = 0
    points = 0
    while blocksLit < 9
    
        sleep(level)
        
        for block in pollBlockHits()
            if getBlock((block[1][1], block[1][2], block[1][3])) == Block(89, 0)
                setBlock((block[1][1], block[1][2], block[1][3]), Block(1, 0))
                blocksLit = blocksLit - 1
                points = points + 1
            end
        end
        
        blocksLit = blocksLit + 1
        lightCreated = false
        while !(lightCreated)
            xpos = tile[1] + rand(-1:1)
            ypos = tile[2] + rand(0:2)
            zpos = tile[3] + 3
            if getBlock((xpos, ypos, zpos)) == Block(1,0)
                setBlock((xpos, ypos, zpos), Block(89, 0))
                lightCreated = true
            end
        end
    end
    post("Game Over: You have scored ", string(points), " points!")
end

main()
