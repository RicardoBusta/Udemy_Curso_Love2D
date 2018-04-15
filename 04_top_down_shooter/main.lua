function love.load()
    local idealfps = 60

    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

    player = {}
    player.x = 200
    player.y = 200
    player.speed = 3 * idealfps

    love.window.setTitle("Top-Down Shooter")
end

function love.update(dt)
    local speed = player.speed*dt
    if love.keyboard.isDown("s") then
        player.y = player.y + speed
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - speed
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - speed
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + speed
    end
end

function love.draw()
    love.graphics.draw(sprites.background,0,0)
    love.graphics.draw(sprites.player, player.x, player.y)
end