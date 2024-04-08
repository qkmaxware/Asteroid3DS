module(..., package.seeall)

font = love.graphics.getFont()
logo = love.graphics.newImage("ui/title.t3s")           --340x45
bg = love.graphics.newImage("art/background.t3s")       --400x240
lowerbg = love.graphics.newImage("ui/game.background.t3s")       
planet = love.graphics.newImage("art/planet.small.t3s") --192x192
vessel = love.graphics.newImage("art/ship.large.t3s")
rock = love.graphics.newImage("art/meteor.80.t3s")

fail = love.graphics.newImage("ui/fail.t3s") 
win = love.graphics.newImage("ui/win.t3s") 
lookDown = love.graphics.newImage("ui/down.t3s") 

function drawMainMenu(screenId, screenRect)
    if screenId ~= "bottom" then
        -- Top
        love.graphics.setColor(1,1,1)
        love.graphics.draw(bg, 0, 0)
        local pwidth, pheight = planet:getDimensions()
        love.graphics.draw(planet, screenRect.width/2 - pwidth/2, screenRect.height - pheight/2)

        local rwidth, rheight = rock:getDimensions()
        love.graphics.draw(rock, screenRect.width/2 - rwidth, -rheight/2)
        love.graphics.draw(rock, screenRect.width/2 + rwidth, 0, 0, 0.5, 0.5)

        local lwidth, lheight = logo:getDimensions()
        love.graphics.draw(logo, screenRect.width/2 - lwidth/2, screenRect.height/2 - lheight/2)
    else
        -- Bottom
        love.graphics.setColor(1,1,1)
        love.graphics.draw(bg, 0, 0)
        local pwidth, pheight = planet:getDimensions()
        love.graphics.draw(planet, screenRect.width/2 - pwidth/2, -pheight/2)
        local swidth, sheight = vessel:getDimensions()
        love.graphics.draw(vessel, screenRect.width/2, screenRect.height/2, -math.pi/2, 1, 1, swidth/2, sheight/2)

        local str = "Press SELECT to start"
        love.graphics.print(str, screenRect.width / 2 - font:getWidth(str) / 2, screenRect.height - 48)
    end
end

function drawGameOverlay(screenId, screenRect, score, attempt)
    if screenId ~= "bottom" then
    else
        love.graphics.setColor(1,1,1)
        love.graphics.draw(lowerbg, 0, 0)

        local swidth, sheight = vessel:getDimensions()
        love.graphics.draw(vessel, screenRect.width/2, screenRect.height/2, -math.pi/2, 1, 1, swidth/2, sheight/2)
        
        local scoreStr = "Score: " .. score
        love.graphics.print(scoreStr, 8, 12)
        local attemptStr = "Attempt: " .. attempt
        love.graphics.print(attemptStr, screenRect.width - font:getWidth(attemptStr) - 8, 12)
    end
end

function drawLossOverlay(screenId, screenRect, score, attempt)
    if screenId ~= "bottom" then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, screenRect.width, screenRect.height)

        love.graphics.setColor(1, 1, 1, 1)
        local lwidth, lheight = fail:getDimensions()
        love.graphics.draw(fail, screenRect.width/2 - lwidth/2, screenRect.height/2 - lheight/2)
        
        local dwidth, dheight = lookDown:getDimensions()
        love.graphics.draw(lookDown, screenRect.width/2 - dwidth/2, screenRect.height - dheight)

        local str = "Try again."
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(str, screenRect.width / 2 - font:getWidth(str) / 2, screenRect.height/2 + font:getHeight() + 12)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.draw(lowerbg, 0, 0)
        
        local scoreStr = "Score: " .. score
        love.graphics.print(scoreStr, 8, 12)
        local attemptStr = "Attempt: " .. attempt
        love.graphics.print(attemptStr, screenRect.width - font:getWidth(attemptStr) - 8, 12)

        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, screenRect.width, screenRect.height)

        love.graphics.setColor(1,1,1)
        local str = "Press SELECT to retry"
        love.graphics.print(str, screenRect.width / 2 - font:getWidth(str) / 2, screenRect.height - 48)
    end
end

function drawWinOverlay(screenId, screenRect, score, attempt)
    if screenId ~= "bottom" then
        love.graphics.setColor(1,1,1) 
        local lwidth, lheight = win:getDimensions()
        love.graphics.draw(win, screenRect.width/2 - lwidth/2, screenRect.height/2 - lheight/2)
        
        local dwidth, dheight = lookDown:getDimensions()
        love.graphics.draw(lookDown, screenRect.width/2 - dwidth/2, screenRect.height - dheight)

        local str = "Congratuations!!"
        love.graphics.setColor(0, 1, 0)
        love.graphics.print(str, screenRect.width / 2 - font:getWidth(str) / 2, screenRect.height/2 + font:getHeight() + 12)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.draw(lowerbg, 0, 0)

        local scoreStr = "Score: " .. score
        love.graphics.print(scoreStr, 8, 12)
        local attemptStr = "Attempt: " .. attempt
        love.graphics.print(attemptStr, screenRect.width - font:getWidth(attemptStr) - 8, 12)

        love.graphics.setColor(1,1,1)
        local str = "Press SELECT to play again"
        love.graphics.print(str, screenRect.width / 2 - font:getWidth(str) / 2, screenRect.height - 48)
    end
end