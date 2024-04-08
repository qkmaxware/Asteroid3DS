require "vec"
require "bullet"

module(..., package.seeall)

function forward(vessel)
    local result = vec.new()
    result.x = math.cos(vessel.rotation)
    result.y = math.sin(vessel.rotation)
    return result
end


function update(display, dt, scene, vessel) 
    local joystick = love.joystick.getJoysticks()[1]

    -- Rotation
    local circlepad = joystick:getAxis(1)
    if (math.abs(circlepad) < 0.1) then circlepad = 0 end -- deadzone
    local dpad = 0
    if joystick:isGamepadDown("dpleft") then dpad = -1 end
    if joystick:isGamepadDown("dpright") then dpad = 1 end
    local sum = circlepad + dpad
    if sum > 1 then sum = 1 end
    if sum < -1 then sum = -1 end
    local angle = sum * 10
    vessel.rotation = vessel.rotation + angle * dt
    vessel.rotation = vessel.rotation % (2 * math.pi)

    -- Velocity
    if joystick:isGamepadDown("a") then
        local fwd = forward(vessel)
        fwd = vec.scale(fwd, 50)
        vessel.position.x = vessel.position.x + fwd.x * dt
        vessel.position.y = vessel.position.y + fwd.y * dt
    end
    vessel.position.x = vessel.position.x % display.width
    vessel.position.y = vessel.position.y % display.height

    -- Shooting
    if (joystick:isGamepadDown("y") or joystick:isGamepadDown("rightshoulder") or joystick:isGamepadDown("leftshoulder")) and vessel.shootTimer <= 0 then
        local b = bullet.new(
            vec.from(
                vessel.position.x + math.cos(vessel.rotation) * 10,
                vessel.position.y + math.sin(vessel.rotation) * 10
            ), 
            vec.scale(forward(vessel), 400)
        )
        table.insert(scene.bullets, b)
        vessel.shootTimer = 0.5
    end
    if (vessel.shootTimer > 0) then
        vessel.shootTimer = vessel.shootTimer - dt
    end
end

function render(display, vessel)
    love.graphics.setColor(1, 1, 1)
    for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * display.width, y * display.height)
            
            local w, h = vessel.sprite:getDimensions()
            love.graphics.draw(vessel.sprite, vessel.position.x, vessel.position.y, vessel.rotation, 1,1, w/2, h/2)
        end
    end
    love.graphics.origin()
end

function new() 
    local ship = {}
    ship.shootTimer = 0
    ship.position = vec.new() 
    ship.rotation = 0
    ship.velocity = vec.new()
    ship.sprite = love.graphics.newImage("art/ship.t3s")
    local w,h = ship.sprite:getDimensions()
    ship.radius = math.max(w, h) / 2
    return ship
end