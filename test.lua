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
