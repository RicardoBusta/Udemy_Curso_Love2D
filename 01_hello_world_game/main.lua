--[[
    Multi line comment!
]]

-- Variables
message = 0
condition = 0

--function
function increaseValue(value, i)
    return value + i
end

-- Loops
for i = 0, 5, 1 do
    condition = increaseValue(condition, 5)
end

while condition < 25 do
    condition = increaseValue(condition, 1)
end

-- Conditionals
if condition > 10 then
    message = "Hello World!"
elseif condition < -10 then
    message = 10
else
    message = "Hakuna Matata!"
end

-- local variables
function containsLocal(i)
    local var = i
    return var * var
end

-- condition = var will fail here

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.print(message)
end