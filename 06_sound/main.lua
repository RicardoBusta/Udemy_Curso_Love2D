function love.load()
    blip_sound = love.audio.newSource("sounds/blip.wav", "static")
    blip_sound:setVolume(0.8)
    blip_sound:setPitch(1.5)

    music = love.audio.newSource("sounds/nature.ogg", "stream")
    music:play()
end

function love.mousepressed(x,y,b,istouch)
    blip_sound:play()
end

function love.keypressed(key, scancode, isrepeat)
    music:stop()
end