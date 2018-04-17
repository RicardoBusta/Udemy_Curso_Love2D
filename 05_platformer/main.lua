function spawnPlatform(x, y, w, h)
    local platform = {}
    platform.body = love.physics.newBody(world, x, y, "static")
    platform.shape = love.physics.newRectangleShape(w/2, h/2, w, h)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.w = w
    platform.h = h

    table.insert(platforms, platform)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

function love.load()
    love.window.setMode(900,700)
    love.graphics.setBackgroundColor(0.5, 0.8, 1)

    -- Gravity x, gravity y, let objects "sleep"
    world = love.physics.newWorld(0, 500, false)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    sprites = {}
    sprites.coin_sheet = love.graphics.newImage("sprites/coin_sheet.png")
    sprites.player_jump = love.graphics.newImage("sprites/player_jump.png")
    sprites.player_stand = love.graphics.newImage("sprites/player_stand.png")

    require("player")
    require("coin")
    anim8 = require("anim8/anim8")
    sti = require("tiled/sti")
    local cameraFile = require("hump/camera")
    camera = cameraFile()

    platforms = {}

    gameMap = sti("maps/map.lua")

    for i, obj in pairs(gameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers["Coins"].objects) do
        spawnCoin(obj.x, obj.y)
    end

    font = love.graphics.newFont(30)

    gameState = 1
    timer = 0
end

function love.update(dt)
    if gameState == 2 then
        world:update(dt)
        playerUpdate(dt)
        gameMap:update(dt)
        coinUpdate(dt)
        timer = timer + dt
    end
    camera:lookAt(player.body:getX(), love.graphics.getHeight()/2)

    if #coins == 0 and gameState == 2 then
        gameState = 1
        player.body:setPosition(198, 443)

        for i, obj in pairs(gameMap.layers["Coins"].objects) do
            spawnCoin(obj.x, obj.y)
        end
    end

    if player.body:getY() > love.graphics.getHeight() then
        player.body:setPosition(198, 443)
    end
end

function love.draw()
    camera:attach()
    gameMap:drawLayer(gameMap.layers["TileLayer1"])
    playerDraw()
    coinDraw()
    camera:detach()

    if gameState == 1 then
        love.graphics.setFont(font)
        love.graphics.printf("Press any key to begin!", 0, 50, love.graphics.getWidth(), "center")
    end

    love.graphics.print("Time: ".. math.floor(timer), 10, 660)
end

function love.keypressed(key, scancode, isrepeat)
    playerJump(key)

    if gameState == 1 then
        gameState = 2
        timer = 0
    end
end

function beginContact(a, b, coll)
    player.grounded = true   
end

function endContact(a, b, coll)
    player.grounded = false
end