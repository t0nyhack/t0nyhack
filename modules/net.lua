gameevent.Listen( "entity_killed" )
Lib.Hook.Add( "entity_killed", "´⚙☮ŗǕF🐱‍👤Íã😉Y⚌😙😠😖☱Ǯ☠😁😊♝$♁Þcŗ😺🐱‍👤", function( data )
	local inflictor = ents.GetByIndex( data.entindex_inflictor )
	local attacker = ents.GetByIndex( data.entindex_attacker )
	local victim = ents.GetByIndex( data.entindex_killed )

	if !IsValid(attacker) or !IsValid(victim) then return end

	if string.lower(R.Entity.GetClass( attacker )) != "player" or string.lower(R.Entity.GetClass( victim )) != "player" then return end

     --debugNotif( "[Death]", Color(254, 55, 55, 230), "Error")
	if R.Entity.GetClass( attacker ) != "player" and Menu.Func.GetVar("Visuals", "Misc", "Logs", "Death") then
        debugNotif( "[Death]", Color(254, 57, 152, 230), string.format("%s was killed by a %s", R.Player.Nick( victim ), R.Entity.GetClass( attacker ) ) )
		--debugText( Menu.Func.GetVar( "Visuals", "Logs", "Death Logs" )[2], "[DEATH] ", white, R.Player.Nick( victim ), " was killed by ", R.Entity.GetClass( attacker ) )
	elseif attacker == victim and Menu.Func.GetVar("Visuals", "Misc", "Logs", "Suicide") then
        debugNotif( "[Suicide]", Color(255, 127, 68, 230), string.format("%s killed themself", R.Player.Nick( victim )))
		--debugText( Menu.Func.GetVar( "Visuals", "Logs", "Suicide Logs" )[2], "[SUICIDE] ", white, R.Player.Nick( victim ), " killed themself")
	elseif attacker == LocalPlayer() and Menu.Func.GetVar("Visuals", "Misc", "Logs", "Kill") then
        debugNotif( "[Kill]", Color(159, 188, 255, 248), string.format("You killed %s", R.Player.Nick( victim )))
		--debugText( Menu.Func.GetVar( "Visuals", "Logs", "Kill Logs" )[2], "[KILL] ", white, "You killed ", R.Player.Nick( victim ))
	elseif attacker != LocalPlayer() and Menu.Func.GetVar("Visuals", "Misc", "Logs", "Death") then
        debugNotif( "[Death]", Color(254, 57, 152, 230), string.format("%s was killed by %s", R.Player.Nick( victim ), R.Entity.GetClass( attacker )))
		--debugText( Menu.Func.GetVar( "Visuals", "Logs", "Death Logs" )[2], "[DEATH] ", white, R.Player.Nick( attacker ), " killed ", R.Player.Nick( victim ))
	end
end)

gameevent.Listen( "player_hurt" )
Lib.Hook.Add( "player_hurt", "´⚙☮ŗǕF🐱‍👤Íã😉Y⚌😙😠😖dddd☱Ǯ☠😁😊♝$♁Þcŗ😺🐱‍👤", function( data )
    --local inflictor = health
  
	local attacker = Player(data.attacker) 
	local victim = Player(data.userid)

    if attacker != LocalPlayer() then return end

    if !IsValid(victim) then return end
    local damagetaken = R.Entity.Health(victim) - data.health
    if damagetaken == 0 then return end

    draw.Hitmarker()

    if !Menu.Func.GetVar("Visuals", "Misc", "Logs", "Damage") then return end
    --print(R.Entity.Health(victim))
    debugNotif( "[Damage]", Color(255, 173, 111, 248), string.format("You shot %s for %s damage ( %s remaining )",  R.Player.Nick( victim ) , damagetaken, data.health) )
end)

Lib.Hook.Add( "PostEntityFireBullets", "C(<W/]asdadasdsd^+k2VyPKasdkgufqawudtyfiuyFIAUYGDOIU", function( entity, data ) 
	if entity != LocalPlayer() then return end

	local start_pos = R.Entity.EyePos(LocalPlayer())
	local end_pos = data.Trace.HitPos

    -- if target.time + decaytime - 1 < SysTime() then
    --     modalpha = 1 * (1 - (SysTime() - (target.time + decaytime - 1)))
    -- end

    -- if target.time + decaytime < SysTime() then
    --     table.remove(AimbotShotTargets, ind)
    -- end 


	table.insert(bulletTracers, {
        start = Vector(start_pos.x, start_pos.y, start_pos.z - 0.1), 
        endp = end_pos,
        time = SysTime(),
        modalpha = 1,
    })
end)
