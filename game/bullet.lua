require "vec"
 
module(..., package.seeall)

function new(start_pos, vel)
    return { lifetime=4, position=vec.copy(start_pos), velocity=vel, size=3 }
end

function update(display, dt, scene, index, bullet) 
    bullet.position = vec.add(bullet.position, vec.scale(bullet.velocity, dt));
    bullet.lifetime = bullet.lifetime - dt
    if (bullet.lifetime < 0) then
       table.remove(scene.bullets, index) 
    end
end

function render(display, bullet) 
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle('fill', bullet.position.x, bullet.position.y, bullet.size)
end