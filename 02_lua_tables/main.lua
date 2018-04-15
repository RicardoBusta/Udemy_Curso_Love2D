message = 0

-- Creating table
testScores = {}
testScores[1] = 95
testScores[2] = 87
testScores[3] = 98

-- Other way to create table
tableScores2 = {95, 87, 98}

-- Adding values to tables
table.insert(testScores, 100)

-- Test insert
tableInsertTest = {}
tableInsertTest[1] = 1
tableInsertTest[2] = 2
tableInsertTest[4] = 4

-- 3 inserted at position 5
table.insert(tableInsertTest, 3)

-- Access table values
message = tableInsertTest[5]

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.print(message)
end