function onCreate()
    debug("ExampleSong loaded (Lua)")
end

function onBeatHit(beat)
    if beat % 4 == 0 then
        cam:addZoom(0.05, 0.15)
    end
end

function onStepHit(step)
    if step == 32 then
        triggerEvent("bloom", "0.4", "1.0")
    end
end
