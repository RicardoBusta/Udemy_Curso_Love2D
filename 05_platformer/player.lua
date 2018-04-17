player = {}
player.body = love.physics.newBody(world, 100, 100, "dynamic")
player.shape = love.physics.newRectangleShape(66, 94)
player.fixture = love.physics.newFixture(player.body, player.shape)
player.speed = 200
player.grounded = false
player.direction = 1
player.sprite = sprites.player_stand
player.body:setFixedRotation(true)

function playerDraw()
    love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), 
                       nil, player.direction, 1, player.sprite:getWidth()/2, player.sprite:getHeight()/2)
end

function playerUpdate(dt)
    if love.keyboard.isDown("a") then
        player.body:setX(player.body:getX() - player.speed * dt)
        player.direction = -1
    end

    if love.keyboard.isDown("d") then
        player.body:setX(player.body:getX() + player.speed * dt)
        player.direction = 1
    end

    if player.grounded then
        player.sprite = sprites.player_stand
    else
        player.sprite = sprites.player_jump
    end
end

function playerJump(key)
    if key == "w" and player.grounded then
        player.body:applyLinearImpulse(0, -2800)
    end
end