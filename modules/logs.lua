local white = Color( 255, 255, 255, 255 )
local function debugDraw() -- HUDPaint
	if hideOverlay then return end
	local yoff = 100
	local t = SysTime() - startTime
	local currentRow = 0
	local todraw = 0

	local stayTime = 15 -- Menu.Func.GetVar( "Visuals", "Debug Text Stay Time" )
	local rows = 12 -- Menu.Func.GetVar( "Visuals", "Debug Text Rows" )
	local fadetime = stayTime - 3

	surface.SetFont( "ChatFont" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( 10, yoff )
	-- surface.DrawText( "Debug:" )

	yoff = yoff + (rows + 2) * 16

	for k, v in ipairs( debugTable ) do
		if todraw >= rows then break end

		if t - v.time >= stayTime then
			table.remove( debugTable, k )
			continue
		end

		todraw = todraw + 1
	end

	-- yoff = yoff - todraw * 16

	for i = #debugTable, 0, -1 do
		local tdata = debugTable[i]
		if !tdata then continue end
		local alpha = 0

		if t - tdata.time >= fadetime then
			alpha = math.Remap(t - tdata.time, fadetime, stayTime, 0, 1)
		end

		if currentRow > rows then break end
		yoff = yoff - 16
		surface.SetTextPos( 40, yoff )

		currentRow = currentRow + 1

		for i, text in pairs(tdata.text) do
			local color = tdata.color[i] or white
			surface.SetTextColor(color.r, color.g, color.b, (1 - alpha) * 255)
			surface.DrawText(tostring( text ))
		end
	end
end

Lib.Hook.Add( "HUDPaint", "5b9#tTot\"DXj,#_<J3^MBbC:4Hq_L5[l", debugDraw )

-- number entindex_inflictor - Entity Index of the inflictor.
-- number entindex_attacker - Entity Index of the attacker.
-- number damagebits - Some kinda flags. Perhaps related to damageinfotype?
-- number entindex_killed - Entity Index of the victim.

-- gameevent.Listen( "entity_killed" )
-- Lib.Hook.Add( "entity_killed", "´⚙☮ŗǕF🐱‍👤Íã😉Y⚌😙😠😖☱Ǯ☠😁😊♝$♁Þcŗ😺🐱‍👤", function( data )
-- 	local inflictor = ents.GetByIndex( data.entindex_inflictor )
-- 	local attacker = ents.GetByIndex( data.entindex_attacker )
-- 	local victim = ents.GetByIndex( data.entindex_killed )
-- 	print("hi")
-- 	if !IsValid(attacker) or !IsValid(victim) then return end

-- 	if string.lower(R.Entity.GetClass( attacker )) != "player" or string.lower(R.Entity.GetClass( victim )) != "player" then return end


-- 	if R.Entity.GetClass( attacker ) != "player" and Menu.Func.GetVar( "Visuals", "Logs", "Death Logs" )[2] then
-- 		debugText( Menu.Func.GetVar( "Visuals", "Logs", "Death Logs" )[2], "[DEATH] ", white, R.Player.Nick( victim ), " was killed by ", R.Entity.GetClass( attacker ) )
-- 	elseif attacker == victim and Menu.Func.GetVar( "Visuals", "Logs", "Suicide Logs" )[1] then
-- 		debugText( Menu.Func.GetVar( "Visuals", "Logs", "Suicide Logs" )[2], "[SUICIDE] ", white, R.Player.Nick( victim ), " killed themself")
-- 	elseif attacker == LocalPlayer() and Menu.Func.GetVar( "Visuals", "Logs", "Kill Logs" )[1] then
-- 		debugText( Menu.Func.GetVar( "Visuals", "Logs", "Kill Logs" )[2], "[KILL] ", white, "You killed ", R.Player.Nick( victim ))
-- 	elseif attacker != LocalPlayer() and Menu.Func.GetVar( "Visuals", "Logs", "Death Logs" )[1] then
-- 		debugText( Menu.Func.GetVar( "Visuals", "Logs", "Death Logs" )[2], "[DEATH] ", white, R.Player.Nick( attacker ), " killed ", R.Player.Nick( victim ))
-- 	end
-- end)

-- if game.GetIPAddress() == "208.103.169.58:27015" then
-- 	debugText( Color( 95, 215, 252, 255), "[EXPLOITS] ", white, "Monolith RP exploits loaded!")
-- end

-- local knownTraitorWeapons = {}
-- local knownInnocent = {}
-- local knownTraitors = {}

-- local ROUND_WAIT = 1
-- local ROUND_PREP = 2
-- local ROUND_ACTIVE = 3
-- local ROUND_POST = 4

-- Lib.Hook.Add("CreateMove", "alan did not make this nigganutz 123", function( cmd )
-- 	if R.CUserCmd.CommandNumber( cmd ) == 0 then return end
-- 	if !__G.GAMEMODE or string.find( __G.GAMEMODE.Name or "", "Terror" ) == nil then return end

-- 	local RoundState = __G.GetRoundState()


-- end)