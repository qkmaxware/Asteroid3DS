module(..., package.seeall)

function new()
    return {
        player = nil,
        bullets = {},
        asteroids = {}
    }
end