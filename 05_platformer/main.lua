function spawnPlatform(x, y, w, h)
    local platform = {}
    platform.body = love.physics.newBody(world, x, y, "static")
    platform.shape = love.physics.newRectangleShape(w/2, h/2, w, h)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.w = w
    platform.h = h

    table.insert(platforms, platform)
end

function love.load()
    -- Gravity x, gravity y, let objects "sleep"
    world = love.physics.newWorld(0, 500, false)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    sprites = {}
    sprites.coin_sheet = love.graphics.newImage("sprites/coin_sheet.png")
    sprites.player_jump = love.graphics.newImage("sprites/player_jump.png")
    sprites.player_stand = love.graphics.newImage("sprites/player_stand.png")

    require("player")

    platforms = {}

    spawnPlatform(50, 400, 300, 30)
end

function love.update(dt)
    world:update(dt)

    playerUpdate(dt)
end

function love.draw()
    playerDraw()

    for i,p in ipairs(platforms) do
        love.graphics.rectangle("fill", p.body:getX(), p.body:getY(), p.w, p.h)
    end
end

function love.keypressed(key, scancode, isrepeat)
   playerJump(key)
end

function beginContact(a, b, coll)
    player.grounded = true   
end

function endContact(a, b, coll)
    player.grounded = false
end