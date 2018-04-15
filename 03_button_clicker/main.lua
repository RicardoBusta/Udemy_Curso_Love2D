--[[
    Love2D Wiki:
    https://love2d.org/wiki/Main_Page
]] 

-- Utility Functions
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

function resetGame()
    score = 0
    timer = 10
end

function setRandomPosition()
    button.x = math.random(button.size, love.graphics.getWidth() - button.size)
    button.y = math.random(button.size, love.graphics.getHeight() - button.size)
end

function playerScore()
    score = score + 1
    setRandomPosition()
end

-- Loads once at begining
function love.load()
    button = {}
    button.size = 50
    setRandomPosition()

    resetGame()
    gameState = 1

    font = love.graphics.newFont(40)
end

-- Update every frame (with delta time)
function love.update(dt)
    if gameState == 2 then
        if timer > 0 then
            timer = timer - dt
        end

        if timer < 0 then
            timer = 0
            gameState = 1
        end
    end
end

-- Renders graphics to the screen
function love.draw()
    if gameState==2 then
        love.graphics.setColor(0,255,0)
        love.graphics.circle("fill", button.x, button.y, button.size)
    end

    love.graphics.setColor(255,255,255)
    love.graphics.setFont(font)
    love.graphics.print("Score: " .. score)
    love.graphics.print("Timer: " .. math.ceil(timer), 300, 0)

    if gameState == 1 then
        love.graphics.printf("Click to begin!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
    end
end

-- Mouse button callback function
function love.mousepressed( x, y, b, istouch )
    -- Check which button was pressed
    if b == 1 and gameState == 2 then
        if distanceBetween(x, y, button.x, button.y) < button.size then
            playerScore()
        end
    end

    if gameState == 1 then
        gameState = 2
        resetGame()
    end
end