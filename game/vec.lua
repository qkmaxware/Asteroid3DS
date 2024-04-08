module(..., package.seeall)

function new()
    return { x=0, y=0 }
end
function copy(v)
    return { x=v.x, y=v.y }
end
function from(xPos, yPos)
    return { x=xPos, y=yPos }
end
function angle(radians)
    return { x=math.cos(radians), y=math.sin(radians) }
end

function neg(a)
    local result = new()
    result.x = -1 * a.x
    result.y = -1 * a.y
    return result
end

function add(a, b)
    local result = new()
    result.x = a.x + b.x
    result.y = a.y + b.y
    return result
end

function sub(a, b)
    local result = new()
    result.x = a.x - b.x
    result.y = a.y - b.y
    return result
end

function dot(a, b)
    return a.x*b.x + a.y*b.y
end

function scale(v, scale)
    local result = new()
    result.x = v.x * scale
    result.y = v.y * scale
    return result
end