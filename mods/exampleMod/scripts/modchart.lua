function onUpdate(elapsed)
    cameraTween(50 * math.sin(curStep/8), 0, 0.1)
end

function onEvent(name, v1, v2)
    if name == "camera flash" then
        debugPrint("Lua caught event: flash")
    end
end
