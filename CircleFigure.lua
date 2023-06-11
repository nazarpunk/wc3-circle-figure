local function normalize (angle)
    return (angle % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
end

---@class CircleFigure
CircleFigure = {}

---new
---@param x number
---@param y number
---@param radius number
---@param angle number
---@param count number
function CircleFigure:new(x, y, radius, angle, count)
    local c = {
        data = {},
        edges = {}
    };
    setmetatable(c, {
        __index = function(self, key)
            if key == 'x' or key == 'y' or key == 'radius' or key == 'angle' then
                return self.data[key];
            end
            return rawget(CircleFigure, key);
        end,
        __newindex = function(self, key, value)
            if key == 'x' or key == 'y' then
                self.data[key] = value;
                return self:move();
            end
            if key == 'radius' then
                self.data[key] = math.max(0, value)
                return self:move();
            end
            if key == 'angle' then
                self.data[key] = normalize(value)
                return self:move();
            end
            if key == 'count' then
                self.data[key] = math.max(3, value)
                return self:move();
            end
            rawset(self, key, value)
        end
    });
    c.x = x;
    c.y = y;
    c.radius = radius;
    c.angle = angle;
    c.count = count;
    return c;
end

function CircleFigure:move()
    local d = self.data;
    if d.x == nil or d.y == nil or d.radius == nil or d.angle == nil or d.count == nil then
        return
    end
    print('move', d.x, d.y)
end

local c = CircleFigure:new(10, 20, 50, 11, 1);
c.x = 10;
c.x = c.x + 10;

print(c.x, c.radius);
