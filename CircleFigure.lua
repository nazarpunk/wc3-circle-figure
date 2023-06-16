-- [[ REMOVE THIS ]]--
function AddLightning (codeName, checkVisibility, x1, y1, x2, y2)
    return {}
end
function DestroyLightning (whichBolt)
end
function MoveLightning (whichBolt, checkVisibility, x1, y1, x2, y2)
end
-- [[ END REMOVE THIS ]]--


local function normalize (angle)
    return (angle % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
end

CircleFigureEdge = {}

---@param xa number
---@param ya number
---@param xb number
---@param yb number
---@param codeName string
function CircleFigureEdge:new(xa, ya, xb, yb, codeName)
    local t = {
        lightning = AddLightning(codeName, false, xa, ya, xb, yb)
    }
    setmetatable(t, self)
    self.__index = self
    self:position(xa, ya, xb, yb)
    return t
end

---@param xa number
---@param ya number
---@param xb number
---@param yb number
function CircleFigureEdge:position(xa, ya, xb, yb)
    self.xa, self.ya, self.xb, self.yb = xa, ya, xb, yb
    MoveLightning(self.lightning, xa, ya, xb, yb)
end

function CircleFigureEdge:destroy()
    DestroyLightning(self.lightning)
end

---@class CircleFigure
CircleFigure = {}

---@param x number
---@param y number
---@param radius number
---@param angle number
---@param count number
function CircleFigure:new(x, y, radius, angle, count, codeName)
    local t = {
        data = {},
        edges = {},
        codeName = codeName,
    };
    setmetatable(t, {
        __index = function(self, key)
            if key == 'x' or key == 'y' or key == 'radius' or key == 'angle' then
                return self.data[key];
            end
            return rawget(CircleFigure, key);
        end,
        __newindex = function(self, key, value)
            if key == 'x' or key == 'y' then
                self.data[key] = value;
                return self:update();
            end
            if key == 'radius' then
                self.data[key] = math.max(0, value)
                return self:update();
            end
            if key == 'angle' then
                self.data[key] = normalize(value)
                return self:update();
            end
            if key == 'count' then
                self.data[key] = math.max(3, value)
                return self:update();
            end
            rawset(self, key, value)
        end
    });
    t.x = x;
    t.y = y;
    t.radius = radius;
    t.angle = angle;
    t.count = count;
    return t;
end

function CircleFigure:update()
    local d = self.data;
    if d.x == nil or d.y == nil or d.radius == nil or d.angle == nil or d.count == nil then
        return
    end

    while #self.edges > 0 and #self.edges > d.count do
        table.remove(self.edges):destroy()
    end

    local ad = 2 * math.pi / d.count
    local a = d.angle
    local xa = d.x + d.radius + math.cos(a)
    local ya = d.y + d.radius * math.sin(a)
    local xb, yb

    for i = 1, d.count, 1 do
        a = a + ad;
        xb = d.x + d.radius * math.cos(a);
        yb = d.y + d.radius * math.sin(a);
        if #self.edges < i then
            table.insert(self.edges, CircleFigureEdge:new(xa, ya, xb, yb, self.codeName))
        else
            self.edges[i]:position(xa, ya, xb, yb)
        end
        xa, ya = xb, yb
    end
end

function CircleFigure:destroy()
    while #self.data.edges > 0 do
        table.remove(self.data.edges):destroy()
    end
end

local c = CircleFigure:new(10, 20, 50, 11, 1);
c.x = 10;
c.x = c.x + 10;
c.count = 4;
c.count = 2;

