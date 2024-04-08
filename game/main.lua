require "rect"
require "bullet"
require "ship"
require "scene"
require "asteroid"
require "screens"

font = nil

SCREEN_TOP = rect.new(400, 240) --really 800 but 400 effective
SCREEN_BOTTOM = rect.new(320, 240)

function configureMenu()
    state = "menu"
    tries = 0
end

function configureMainScene() 
    main_scene = scene.new()

    player = ship.new()
    player.position.x = SCREEN_TOP.width / 2
    player.position.y = SCREEN_TOP.height / 2
    main_scene.player = player

    local zoneWidth = SCREEN_TOP.width / 3
    local zoneHeight = SCREEN_TOP.height / 3
    local zones = { {x=0,y=0},{x=1,y=0},{x=2,y=0}, {x=0,y=1},          {x=2,y=1}, {x=0,y=2},{x=1,y=2},{x=2,y=2} }
    for i = 0,2,1 do
        local a = asteroid.new()
        local randomZone = zones[math.random(#zones)]
        local x = zoneWidth * randomZone.x + math.random(0, zoneWidth)
        local y = zoneHeight * randomZone.y + math.random(0, zoneHeight)
        a.position = vec.from(x, y)
        table.insert(main_scene.asteroids, a)
    end

    score = 0
    kills = 0
    state = "playing"
    isFinite = true
    tries = tries + 1
end

function love.load()
    font = love.graphics.getFont()
    configureMenu()
end


function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
    return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
end

function love.update(dt)
    if state == "menu" then
        local joystick = love.joystick.getJoysticks()[1]
        if joystick:isGamepadDown("back") then 
            configureMainScene()
            return
        end
    end
    if state == "fail" then
        local joystick = love.joystick.getJoysticks()[1]
        if joystick:isGamepadDown("back") then 
            configureMainScene()
            return
        end
    end
    if state == "win" then
        local joystick = love.joystick.getJoysticks()[1]
        if joystick:isGamepadDown("back") then 
            configureMainScene()
            return
        end
    end
    if (state == "playing") then
        for rockIndex, rock in ipairs(main_scene.asteroids) do
            asteroid.update(SCREEN_TOP, dt, main_scene, rock)
        end
        for index = #main_scene.bullets, 1, -1  do
            local shot = main_scene.bullets[index]
            bullet.update(SCREEN_TOP, dt, main_scene, index, shot)
        end
        ship.update(SCREEN_TOP, dt, main_scene, main_scene.player)
        -- Collision checking
        for asteroidIndex, rock in ipairs(main_scene.asteroids) do
            if areCirclesIntersecting(
                main_scene.player.position.x, main_scene.player.position.y, main_scene.player.radius,
                rock.position.x, rock.position.y, asteroid.radiusOf(rock)
            ) then
                state = "fail"
                break
            end
        end
        for shotIndex = #main_scene.bullets, 1, -1 do
            local shot = main_scene.bullets[shotIndex]
            for asteroidIndex = #main_scene.asteroids, 1, -1 do
                local rock = main_scene.asteroids[asteroidIndex]
                if areCirclesIntersecting(shot.position.x, shot.position.y, shot.size, rock.position.x, rock.position.y, asteroid.radiusOf(rock)) then
                    table.remove(main_scene.bullets, bulletIndex)
                    table.remove(main_scene.asteroids, asteroidIndex)
                    kills = kills + 1
                    score = score + rock.size

                    if rock.size > 25 then
                        -- TODO small rocks go faster than big ones
                        local newSize = rock.size / 2  
                        local subrockA = asteroid.new()
                        subrockA.position = vec.copy(rock.position)
                        subrockA.size = newSize 
                        local subrockB = asteroid.new()
                        subrockB.position = vec.copy(rock.position)
                        subrockB.size = newSize
                        subrockB.velocity=vec.neg(subrockA.velocity)
                        table.insert(main_scene.asteroids, subrockA)
                        table.insert(main_scene.asteroids, subrockB)
                    end
                    break
                end
            end
        end
        -- Victory condition
        local aCount = 0
        for _ in pairs(main_scene.asteroids) do aCount = aCount + 1 end
        if isFinite and aCount == 0 then
            state = "win"
        end
    end
end

function love.gamepadpressed(joystick, button)

end

function drawTop()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(screens.bg, 0, 0)
    for shotIndex, shot in ipairs(main_scene.bullets) do
        bullet.render(SCREEN_TOP, shot)
    end
    for rockIndex, rock in ipairs(main_scene.asteroids) do
        asteroid.render(SCREEN_TOP, rock)
    end

    ship.render(SCREEN_TOP, main_scene.player)
end

function drawBottom()
    --drawDebug()
end

function drawDebug()
    love.graphics.setColor(1, 1, 1)
    local bulletCount = 0
    for _ in pairs(main_scene.bullets) do bulletCount = bulletCount + 1 end
    love.graphics.print("Bullets on screen: "..bulletCount, 32, 32)
    love.graphics.print("Asteroids destroyed: "..kills, 32, 48)
end

function love.draw(screen)
    local rect = SCREEN_BOTTOM
    if screen ~= "bottom" then
        rect = SCREEN_TOP
    end 

    if state == "menu" then
        screens.drawMainMenu(screen, rect)
        return
    end

    if screen ~= "bottom" then
        drawTop()
    else
        drawBottom()
    end
    if state == "fail" then
        screens.drawLossOverlay(screen, rect, score, tries)
    end
    if state == "win" then
        screens.drawWinOverlay(screen, rect, score, tries)   
    end
    if state == "playing" then
        screens.drawGameOverlay(screen, rect, score, tries)
    end
end