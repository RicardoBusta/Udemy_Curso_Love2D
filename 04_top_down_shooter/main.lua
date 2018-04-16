local idealfps = 60

-- Utility Functions

function love.conf(t)
	t.console = true
end

function log(...)
    if dbg then print(...) end
end

function playerMouseAngle()
    return angleTwoPoints(player.x, player.y, love.mouse.getX(), love.mouse.getY())
end

function zombiePlayerAngle(zombie)
    return angleTwoPoints(zombie.x, zombie.y, player.x, player.y)
end

function angleTwoPoints(x1, y1, x2, y2)
    return math.atan2(y2-y1,x2-x1)
end

function resetGame()
    score = 0
    zombieSpawnTime = 2
    spawnTimer = 0
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2
end

function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 2.5*idealfps
    zombie.a = 0
    zombie.dead = false
    zombie.distance = 0

    -- Randomize zombie position from one of the sides of the screen
    local side = math.random(1, 4)
    if side == 1 then
        -- left side of the screen
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        -- right side of the screen
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        -- bottom side of the screen
        zombie.y = love.graphics.getHeight() + 30
        zombie.x = math.random(0, love.graphics.getWidth())
    else 
        -- top side of the screen
        zombie.y = -30
        zombie.x = math.random(0, love.graphics.getWidth())
    end  

    table.insert( zombies, zombie )
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 6*idealfps
    bullet.a = player.a
    bullet.dead = false

    sound.shoot:stop()
    sound.shoot:play()

    table.insert( bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

-- Game functions

function menuLoop(dt)
end

function gameLoop(dt)
    -- Handle Player
    local speed = player.speed*dt
    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() - 30 then
        player.y = player.y + speed
    end
    if love.keyboard.isDown("w") and player.y > 30 then
        player.y = player.y - speed
    end
    if love.keyboard.isDown("a") and player.x > 30 then
        player.x = player.x - speed
    end
    if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() - 30 then
        player.x = player.x + speed
    end
    player.a = playerMouseAngle()

    -- Handle bullets
    for i,b in ipairs(bullets) do
        b.x = b.x + math.cos(b.a) * b.speed * dt
        b.y = b.y + math.sin(b.a) * b.speed * dt
    end

    -- Handle Zombies
    for i,z in ipairs(zombies) do
        z.a = zombiePlayerAngle(z)
        z.x = z.x + math.cos(z.a) * z.speed * dt
        z.y = z.y + math.sin(z.a) * z.speed * dt

        -- Zombies x players
        z.distance = distanceBetween(z.x, z.y, player.x, player.y)
        if z.distance < 30 then
            for j,z in ipairs(zombies) do
                z.dead = true
            end
            gameState = 1
        end

        -- Zombies x bullets
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 30 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end

    spawnTimer = spawnTimer - dt
    if spawnTimer <= 0 then
        spawnTimer = zombieSpawnTime
        zombieSpawnTime = zombieSpawnTime * 0.95
        spawnZombie()
    end

    -- Clean zombies
    for i=#zombies,1,-1 do
        if zombies[i].dead then
            table.remove(zombies, i)
        end
    end

    -- Clean Bullets
    for i=#bullets,1,-1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() or b.dead then
            table.remove(bullets, i)
        end
    end
end

function gameDraw()
    love.graphics.draw(sprites.background,0,0)

    love.graphics.draw(sprites.player, player.x, player.y, player.a,
                       nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

    for i,z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, z.a, nil, nil,
                           sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
        -- love.graphics.printf(math.ceil(z.distance), z.x, z.y, 30, "center")
    end

    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5,
                           sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end

function menuDraw()
    love.graphics.setFont(font)
    love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
end

-- Love functions

function love.load()
    love.window.setTitle("Top-Down Shooter")

    sound = {}
    -- Static is good for small audio files to be kept into memory
    sound.shoot = love.audio.newSource("sound/shoot.wav", "static")
    -- Stream large audio files
    sound.music = love.audio.newSource("sound/DangerStorm.mp3", "stream")
    sound.music:play()

    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

    player = {}
    player.x = 200
    player.y = 200
    player.speed = 3 * idealfps
    player.a = 0

    zombies = {}
    bullets = {}

    resetGame()

    paused = false
    gameState = 1
    
    font = love.graphics.newFont(40)
end

function love.update(dt)
    if paused then
        return
    end

    if gameState == 1 then
        menuLoop(dt)
    elseif gameState == 2 then
        gameLoop(dt)
    end
end

function love.draw()
    if gameState == 1 then
        menuDraw()
    elseif gameState == 2 then
        gameDraw()
    end

    love.graphics.setFont(font)
    love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        sound.shoot:play()
        paused = not paused
    end
end

function love.mousepressed( x, y, b, istouch)
    if gameState == 1 then
        gameState = 2
        resetGame()
    elseif gameState == 2 then
        if b == 1 then
            spawnBullet()
        end
    end
end