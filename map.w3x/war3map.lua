gg_trg_demo = nil
gg_unit_Hamg_0000 = nil
function InitGlobals()
end

local InitGlobalsCirclefigure = InitGlobals;

function InitGlobals()
    InitGlobalsCirclefigure();

    local loc = Location(0,0);
    local function getZ(x, y)
        MoveLocation(loc, x, y);
        return GetLocationZ(loc) + 150
    end

    local function normalize (angle)
        return angle - 2 * math.pi * math.floor(angle / (2 * math.pi));
    end

    CircleFigureEdge = {}

    ---@param xa number
    ---@param ya number
    ---@param xb number
    ---@param yb number
    ---@param codeName string
    function CircleFigureEdge:new(xa, ya, xb, yb, codeName)
        local t = {
            lightning = AddLightningEx(codeName, false, xa, ya, getZ(xa,ya), xb, yb, getZ(xb, yb))
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
        MoveLightningEx(self.lightning,false, xa, ya, getZ(xa,ya), xb, yb, getZ(xb,yb))
    end

    --BlzSetSpecialEffectAlpha()

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
    ---@param codeName string
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

end
local InitGlobalsTest = InitGlobals;

function InitGlobals()
    InitGlobalsTest();
    local trigger = CreateTrigger()
    for i = 0, bj_MAX_PLAYER_SLOTS - 1, 1 do
        TriggerRegisterPlayerUnitEvent(trigger, Player(i), EVENT_PLAYER_UNIT_SPELL_EFFECT)
    end
    TriggerAddAction(trigger, function()
        local x, y = GetSpellTargetX(), GetSpellTargetY();

        local c = CircleFigure:new(x,y, 400, 0, GetRandomInt(3,7), 'DRAL');
        TimerStart(CreateTimer(), 5, false, function()
            DestroyTimer(GetExpiredTimer());
            c:destroy();
        end)

    end)
end

function CreateUnitsForPlayer0()
local p = Player(0)
local u
local unitID
local t
local life

gg_unit_Hamg_0000 = BlzCreateUnitWithSkin(p, FourCC("Hamg"), -413.5, -367.9, 268.410, FourCC("Hjas"))
SelectHeroSkill(gg_unit_Hamg_0000, FourCC("AHbz"))
end

function CreatePlayerBuildings()
end

function CreatePlayerUnits()
CreateUnitsForPlayer0()
end

function CreateAllUnits()
CreatePlayerBuildings()
CreatePlayerUnits()
end

function Trig_demo_Actions()
SelectUnitSingle(gg_unit_Hamg_0000)
end

function InitTrig_demo()
gg_trg_demo = CreateTrigger()
TriggerAddAction(gg_trg_demo, Trig_demo_Actions)
end

function InitCustomTriggers()
InitTrig_demo()
end

function RunInitializationTriggers()
ConditionalTriggerExecute(gg_trg_demo)
end

function InitCustomPlayerSlots()
SetPlayerStartLocation(Player(0), 0)
SetPlayerColor(Player(0), ConvertPlayerColor(0))
SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
SetPlayerRaceSelectable(Player(0), true)
SetPlayerController(Player(0), MAP_CONTROL_USER)
end

function InitCustomTeams()
SetPlayerTeam(Player(0), 0)
end

function main()
SetCameraBounds(-3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
SetDayNightModels("Environment\\DNC\\DNCUnderground\\DNCUndergroundTerrain\\DNCUndergroundTerrain.mdl", "Environment\\DNC\\DNCUnderground\\DNCUndergroundUnit\\DNCUndergroundUnit.mdl")
NewSoundEnvironment("Default")
SetAmbientDaySound("DungeonDay")
SetAmbientNightSound("DungeonNight")
SetMapMusic("Music", true, 0)
CreateAllUnits()
InitBlizzard()
InitGlobals()
InitCustomTriggers()
RunInitializationTriggers()
end

function config()
SetMapName("TRIGSTR_003")
SetMapDescription("TRIGSTR_005")
SetPlayers(1)
SetTeams(1)
SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
DefineStartLocation(0, -384.0, -448.0)
InitCustomPlayerSlots()
SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
InitGenericPlayerSlots()
end

