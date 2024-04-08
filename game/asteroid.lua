require "vec"
 
module(..., package.seeall)

sprite = love.graphics.newImage("art/meteor.80.t3s")

function new() 
    return {
        position=vec.new(),
        size=100, -- a percent
        rotation=math.random() * (2 * math.pi),
        sprite=sprite,
        velocity=vec.scale(vec.angle(math.random() * (2 * math.pi)), math.random() * 50)
    }
end

function radiusOf(rock)
    return 40.0 * (rock.size * 0.01)
end

function update(display, dt, scene, rock)
    rock.position = vec.add(rock.position, vec.scale(rock.velocity, dt));
    rock.position.x = rock.position.x % display.width
    rock.position.y = rock.position.y % display.height
end

function render(display, asteroid)
    for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * display.width, y * display.height)
            
            --love.graphics.setColor(1, 0, 0)
            --love.graphics.circle('fill', asteroid.position.x, asteroid.position.y, radiusOf(asteroid))

            love.graphics.setColor(1, 1, 1)
            local w, h = asteroid.sprite:getDimensions()
            love.graphics.draw(asteroid.sprite, asteroid.position.x, asteroid.position.y, asteroid.rotation, asteroid.size * 0.01, asteroid.size * 0.01, w/2, h/2)
        end
    end
end