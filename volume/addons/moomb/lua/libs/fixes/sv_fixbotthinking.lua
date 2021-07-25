FixServerThinking = false

RunConsoleCommand('sv_hibernate_think', '1')

timer.Simple(0, function ()
    if (RealTime() < 120) then
        timer.Simple(1, function()
            RunConsoleCommand("bot")
        end)
        FixServerThinking = true
    end
end)
hook.Add("PlayerInitialSpawn", "Fix.KickBotAfterLoading", function(ply)
    if ply:IsBot() && FixServerThinking then
        timer.Simple(5, function()
            ply:Kick("Sorry, broqui")
        end)
        FixServerThinking = false
    end
end)