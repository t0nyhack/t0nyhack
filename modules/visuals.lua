local function DrawCrosshair(x, y, size, color, style)
    local dist = 3
    if style == "Classic" then
        surface.SetDrawColor( 0, 0, 100, color.a * .6)
        surface.DrawLine(x - size, y + 1, x + size + 1, y + 1)
        surface.DrawLine(x - size, y - 1, x + size + 1, y - 1)

        surface.DrawLine(x + 1, y - size, x + 1, y + size + 1)
        surface.DrawLine(x - 1, y - size, x - 1, y + size + 1)

        surface.SetDrawColor( color )
        surface.DrawLine(x - size, y, x + size + 1, y)
        surface.DrawLine(x, y - size, x, y + size + 1)
    elseif style == "Normal" or style == "No Dot" then
        if style == "Normal" then
            draw.OutlinedBox( x - 1, y - 1, 3, 3, 1, Color(0, 0, 0, color.a))
            draw.Rect(x, y, 1, 1, color)
        end
        
        draw.OutlinedBox( x - dist - size, y - 1, size, 3, 1, Color(0, 0, 0, color.a))
        draw.Rect(x - dist - size + 1, y, size - 2, 1, color)

        draw.OutlinedBox( x - 1, y - dist - size, 3, size, 1, Color(0, 0, 0, color.a))
        draw.Rect(x, y - dist - size + 1 , 1, size - 2 , color)

        draw.OutlinedBox( x + dist + 1, y - 1, size, 3, 1, Color(0, 0, 0, color.a))
        draw.Rect(x + dist + 2 , y, size - 2, 1, color)

        draw.OutlinedBox( x - 1, y + dist + 1, 3, size, 1, Color(0, 0, 0, color.a))
        draw.Rect(x, y + dist + 2 , 1, size - 2 , color)
    end
end

local function DrawKeypadSteal(screen) -- HUDPaint

	if !Menu.Func.GetVar("Visuals", "Entity ESP", "Keypads")[1] then return end

	for entid, v in pairs(keypads) do
		if !IsValid(v[1]) then keypads[entid] = nil continue end
		local pos3d = R.Entity.GetPos(v[1]) + Vector(0, 0, 5)
		if R.Vector.Distance(pos3d, R.Entity.GetPos(LocalPlayer())) >= 2000 then continue end

		cam.Start3D()
			local pos = R.Vector.ToScreen(pos3d)
		cam.End3D()


		--local distance = util.getDistance(pos, {x = screen.w/2, y = screen.h/2})
		
		draw.Rect(pos.x - 3, pos.y - 3, 6, 6, Menu.Func.GetVar("Visuals", "Entity ESP", "Keypads")[2])
		--print(distance)
		
		local execs = 0
		for i, _ in pairs(v[4]) do
		--for i, _ in pairs({[1234] = true, [1235] = true, [1236] = true, [1238] = true}) do -- for testing
			local w, h = draw.GetTextSize("sdadlnhfjfpNIGGERuhgbisdguoa", i)

			draw.SimpleText(i, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", pos.x, pos.y - ((h - 1 )* execs) - 4, Menu.Func.GetVar("Visuals", "Entity ESP", "Keypads")[2], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			execs = execs + 1
		end
	end
end

local function DrawVelo()

    local vel = Menu.Func.GetVar("Visuals", "Misc", "Velocity Meter")

	if !vel[1] then return end

	local col = vel[2]

	local sW = ScrW()
	local sH = ScrH()
	local matchHeight = (985 / 1080) * sH -- height of the normal HL2 info boxes on 1080p
	local boxWidth = (128 / 1920) * sW

	local showvel = math.floor( R.Vector.Length2D( R.Entity.GetAbsVelocity( LocalPlayer() )))
	draw.RoundedBox( 4, (sW / 2.01) - boxWidth / 2, matchHeight, (128 / 1920) * sW, sH / 16, Color( 0, 0, 0, 76 ))
	draw.DrawText( showvel, "C>4W^2hiIl:T`?^h3W>6%6*pOJt':<8r", (sW / 2) - boxWidth / 2, matchHeight, {r = col.r, g = col.g, b = col.b, a = 255})
	draw.DrawText( showvel, ".wY[p69Gru}YE]z0+|1##ma]QTDwsa+", (sW / 2) - boxWidth / 2, matchHeight, {r = col.r, g = col.g, b = col.b, a = 100})
end

local AmmoStrs = {
	"ammo",
	"item_box",
}

local WepStrs = {
	"weapon",
	"m9k"
}

local function EntityEsp()
	EntsToDraw = {}
	if !Menu.Func.GetVar("Visuals", "Entity ESP", "Enabled") then return end
	local lp = LocalPlayer()
	local targetent = nil
	if Menu.Func.GetVar("Visuals", "Entity ESP", "Target Entity")[1] and R.Player.Alive(lp) then
		local dir = R.Player.GetAimVector(lp)
		local trace = {
			start = R.Entity.EyePos( lp ),
			endpos = R.Entity.EyePos( lp ) + dir * 1000,
			filter = lp
		}

		local tr = util.TraceLine( trace )
		local ent = tr.Entity
		if IsValid(ent) then
			local class = string.lower(R.Entity.GetClass( ent ))
			if (class != "prop_physics" and class != "keypad" and class != "player") then
				--print(R.Entity.GetParentAttachment(ent))
				local distance = R.Vector.Distance(R.Entity.GetPos(ent), R.Entity.GetPos(lp))/52
				if distance <= Menu.Func.GetVar("Visuals", "Entity ESP", "Max Distance") then
					InsEnt(ent, Menu.Func.GetVar("Visuals", "Entity ESP", "Target Entity")[2])
					targetent = ent
				end
			end
		end
	end

	for index, ent in pairs(ents.GetAll()) do
		if IsValid(ent) and ent != nil then
			if ent == targetent then continue end
			if R.Entity.GetParentAttachment(ent) != 0 or IsValid(R.Entity.GetParent(ent)) then continue end
			local class = R.Entity.GetClass( ent )
			local entfound = false
			local distance = R.Vector.Distance(R.Entity.GetPos(ent), R.Entity.GetPos(lp))/52
			if distance > Menu.Func.GetVar("Visuals", "Entity ESP", "Max Distance") then
				continue
			end		
			if Menu.Func.GetVar("Visuals", "Entity ESP", "Ammo") then
				for _, ammostr in pairs(AmmoStrs) do
					if string.match( class, ammostr ) then
						InsEnt(ent, Menu.Func.GetVar("Visuals", "Entity ESP", "Name")[2])
						entfound = true
						break
					end	
				end
			end
			if entfound then continue end
			
			local entfound = false
			if Menu.Func.GetVar("Visuals", "Entity ESP", "Weapons") then
				for _, wepstr in pairs(WepStrs) do
					if string.match( class, wepstr ) then
						InsEnt(ent, Menu.Func.GetVar("Visuals", "Entity ESP", "Name")[2])
						break
					end	
				end
			end
			if entfound then continue end
		end
	end



	-- for i, v in pairs(G.ents.GetAll()) do
	-- 	local typea = 0
	-- 	local name = G.string.lower(R.Entity.GetClass( v ))
	-- 	for _, txt in pairs(WepStrs) do
	-- 		local matched = G.string.match( name, txt)
	-- 		typea = matched ~= nil and 1 or 0
	-- 		print(name, matched, typea)
	-- 	end
	-- 	if typea ~= 0 then
	-- 		InsEnt(v, G.Menu.Func.GetVar("Visuals", "Misc", "Entity ESP", "Weapon ESP")[2], true)
	-- 	end
	-- end

end

Inds = {
	Indicators = {},
	PosSize = {
		[1] = 0,
		[2] = 0
	}
}






function Inds.Create(name, pos, shownum, color)
	Inds.Indicators[name] = {
		visible = true,
		pos = pos,
		values = {},
		color = color,
		shownum = shownum or false,
		items = {},
	}
end

function Inds.AddVal(name, text, color)
	table.insert(Inds.Indicators[name].items, {text = text, clr = color or Color(229, 229, 229)})
end

function Inds.ClearVals(name)
	Inds.Indicators[name].items = {}
end


function Inds.DrawContainer(name, ind, pos)
	if !ind.visible then return end
	local color = ind.color or Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" )
	color.a = 255
	local indH = 16
	local indW = 200
	
	local x, y = pos.X, pos.Y

	for ind, item in pairs(ind.items) do
		indH = indH + 14
	end

	if ind.pos == 1 then

		draw.Gradient(x, y, indW, indH, 1, Color(0, 0, 0, 200))

		draw.Gradient(x + 2, y + 1, indW - 3, 1, 1, color)
		draw.Gradient(x + 2, y + indH - 2, indW - 3, 1, 1, color)
		draw.Rect(x + 1, y + 1, 1, indH - 2, color)

		draw.SimpleText(ind.shownum and string.format(name.." (%d)", #ind.items) or name, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", x + 6, y + 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		local textpos = y + 8

		for ind, item in pairs(ind.items) do
			draw.SimpleText(item.text, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", x + 12, textpos, item.clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			textpos = textpos + 14
		end
	else
		draw.Gradient(x, y, indW, indH, 2, Color(0, 0, 0, 200))

		draw.Gradient(x + 2, y + 1, indW - 4, 1, 2, color)
		draw.Gradient(x + 2, y + indH - 2, indW - 4, 1, 2, color)
		draw.Rect(x + indW - 2, y + 1, 1, indH - 2, color)

		draw.SimpleText(ind.shownum and string.format("(%d) ".. name, #ind.items) or name, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", x + indW -  6, y + 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		local textpos = y + 8

		for ind, item in pairs(ind.items) do
			draw.SimpleText(item.text, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", x + indW - 12, textpos, item.clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			textpos = textpos + 14
		end
	end
	

	return indH
end



Inds.Create("Spectators", 1, true)
Inds.Create("Admins", 2, true)

local function specMode( num )
	if num == 4 then
		return "First"
	elseif num == 5 or num == 3 then
		return "Third"
	elseif num == 2 then
		return "Freeze"
	else
		return "???"
	end
end

function Inds.Draw(screen)
	
	Inds.ClearVals("Spectators")
	Inds.ClearVals("Admins")


	if Menu.Func.GetVar("Visuals", "Misc", "Spectator List") then
		local spectators = {}
		for _, ply in ipairs( player.GetAll() ) do
			if ply != LocalPlayer() then continue end
			spectators[ #spectators + 1 ] = ply
		end

		if spectators[1] then
			for k, v in pairs( spectators ) do
				local specType = specMode( R.Player.GetObserverMode( v ))

				local clr, rank = util.GetHighLightColor( v )

				local spectext = R.Player.Nick( v )

				if Menu.Func.GetVar("Visuals", "Misc", "Spec Info", "Rank") then
					spectext = spectext.. " [".. R.Entity.GetNWString( v, "UserGroup", "user" ).. "]"
				end

				if Menu.Func.GetVar("Visuals", "Misc", "Spec Info", "Observer Mode") then
					spectext = spectext.. " [" .. specType .. "]"
				end

				Inds.AddVal("Spectators", spectext, clr and clr or Color(255, 255, 255, 230))

			end
		end
	end

	if Menu.Func.GetVar("Visuals", "Misc", "Admin List") then
		for _, ply in ipairs( player.GetAll() ) do
			local rank = PossibleAdmins[R.Player.UserID(ply)]
			
			if rank then
				local namestr = R.Player.Nick( ply )

				namestr = namestr.. " [".. rank.. "]"

				if Menu.Func.GetVar("Visuals", "Misc", "Admin Info", "Distance") then
					namestr = namestr.. " ".. tostring(math.ceil(R.Vector.Distance(R.Entity.GetPos( ply ), R.Entity.GetPos( LocalPlayer() ))/52)).. "m"
				end

				-- local clr = util.GetHighLightColor( ply )
				if R.Entity.IsDormant( ply ) and Menu.Func.GetVar("Visuals", "Misc", "Admin Info", "Dormant") then
					Inds.AddVal("Admins", namestr, Color(70, 70, 70, 100))
				else
					Inds.AddVal("Admins", namestr, Color(255, 255, 255, 230))
				end
			end
		end
	end
	--[[


	]]

	local posadd = {
		[1] = 0,
		[2] = 0,
	}
	for name, data in pairs(Inds.Indicators) do
		if !data.visible or #data.items == 0 then continue end
		local adjust = posadd[data.pos]
		local indSize = Inds.DrawContainer(name, data, Vector(data.pos == 1 and 10 or screen.w - 210 , math.floor((screen.h/2)) + adjust))
		posadd[data.pos] = adjust + indSize + 10
	end

	for i, v in ipairs(posadd) do
		Inds.PosSize[i] = v - 10
	end
	
end


--[[
draw.SimpleText( "t0ny hack", "BoldMenuFont", self.PosX + 5, self.PosY - self.Bezel + 6 , self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
draw.SimpleText(tab.Label, "MenuFont", x + 14, y - 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
]]
local function WaterMark(screen)

	if !Menu.Func.GetVar( "Settings", "Other Settings", "Water Mark" ) then return end

	local ping = R.Player.Ping( LocalPlayer() )
	local texts = {
		game.GetIPAddress() == "loopback" and "Local Server" or game.GetIPAddress(),
	 	engine.ActiveGamemode() or "No Game Mode",
		tostring(ping).. "ms",
	}


	local total_text = ""
	for i, txt in ipairs(texts) do
		total_text = total_text.. " | ".. txt
	end


	local text_width = draw.GetTextSize("sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", total_text)


	local color = Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" )
	local wm_length = 300
	local y = 10
	local x = screen.w - wm_length - 10
	

	
	draw.Gradient(x, y, wm_length, 20, 2, Color(0, 0, 0, 200))

	draw.Gradient(x + 2, y + 1, wm_length - 4, 1, 2, color)
	draw.Gradient(x + 2, y + 20 - 2, wm_length - 4, 1, 2, color)
	draw.Rect(x + wm_length - 2, y + 1, 1, 20 - 2, color)

	draw.SimpleText( total_text, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", x + wm_length - text_width - 10,  y + 3, Color(255, 255, 255, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "t0ny hack", "sdadlnhfjfpNIGGERuhgbisdguoaBOLD", x + wm_length - text_width - 10,  y + 3 , Color(255, 255, 255, 230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
end


	--[[

	local logcontent = {

		{ -- log 1
		time = SysTime() - startTime,
		content = {
			{
				text = string.format("[%s] ", string.ToMinutesSecondsMilliseconds(SysTime() - startTime)),
				clr = Color(255, 255, 255, 230)
			},
			{
				text = "[DEBUG]",
				clr =  Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" ),
				bold = true
			},
			{
				text = "helloooo jo jo jo"
			},
		},
	},
	{ -- log 2
		time = SysTime() - startTime,
		content = {
			{
				text = string.format("[%s] ", string.ToMinutesSecondsMilliseconds(SysTime() - startTime)),
				clr = Color(255, 255, 255, 230)
			},
			{
				text = "[DEBUG]",
				clr =  Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" ),
				bold = true
			},
			{
				text = "helloooo jo jo jo"
			},
		},
	},


}
]]

local function DrawLogs()

	local textpos = {x = 10, y = 10}
	for i, log in ipairs(util.Table_reverse(debugLogs)) do
		textpos.x = 10
		local time = log.time
		local t = SysTime() - startTime
		local stayTime = 15

		if t >= time + stayTime then
			table.remove( debugLogs, 1 )
			continue
		end




		
		
		local fadepercent = 1

		local introfadepercent = ((t - time)*5)
		if introfadepercent > 1 then introfadepercent = 1 end
		if introfadepercent <= 1 then
			textpos.x = util.EaseVal(introfadepercent, -20, 10)
			textpos.y = textpos.y + util.EaseVal(introfadepercent, 0, 16)
			fadepercent = util.EaseVal(introfadepercent, 0, 1)
			fadepercent = introfadepercent
		else
			textpos.y = textpos.y + 16
		end
		if t <= time + 0.5 then
			local introfadepercent = (t - time/2)

			
		end

		

		local endfade = time + stayTime - 2
		if t >= endfade then 
			fadepercent = (1 - (t - endfade)/2)
		end

		--if fadepercent != 1 then print(fadepercent) end 
		for textINT, content in ipairs(log.content) do
			local font = content.bold and "sdadlnhfjfpNIGGERuhgbisdguoaBOLD" or "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE"
			local clr = content.clr or Color(255, 255, 255, 230)
			clr.a = 230 * fadepercent-- keep at 240
			local text = content.bold and content.text.. "  " or  content.text.. " "
			draw.SimpleText( text, font, textpos.x,  textpos.y, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

			textpos.x = textpos.x + draw.GetTextSize(font, text)
		end


		
	end

end





-- local logs = {
-- 	{
-- 		showtime = true,
-- 		time = SysTime() - startTime,
-- 		header = "Debug",
-- 	},
-- 	{
-- 		showtime = true,
-- 		time = SysTime() - startTime + 30,
-- 		header = "Test",
-- 		headerclr = Color(255, 112, 238, 230)
-- 	},
-- }

-- local function DrawLogs(logs)

-- 	local textpos = {x = 10, y = 10}
-- 	for i, text in ipairs(logs) do
-- 		textpos.x = 10
-- 		if text.showtime then
-- 			local time_text = string.format("[%s] ", string.ToMinutesSecondsMilliseconds(text.time) )
-- 			local text_width = draw.GetTextSize("sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", time_text)
-- 			draw.SimpleText( time_text, "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", textpos.x,  textpos.y, Color(255, 255, 255, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
-- 			textpos.x = textpos.x + text_width 
-- 		end

-- 		local header_text = text.header and string.format("[%s] ", text.header) or "[DEBUG] "
-- 		local header_clr = text.headerclr or Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" )
-- 		local header_width = draw.GetTextSize("sdadlnhfjfpNIGGERuhgbisdguoaBOLD", header_text)
-- 		draw.SimpleText( header_text, "sdadlnhfjfpNIGGERuhgbisdguoaBOLD", textpos.x,  textpos.y, header_clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
-- 		textpos.x = textpos.x + header_width


-- 		textpos.y = textpos.y + 16
-- 	end

-- end


-- Lib.Hook.Add( "PostEntityFireBullets", "C(<W/]asdadasdsd^+k2VyPKasdkgufqawudtyfiuyFIAUYGDOIU", function( entity, data ) 
	

-- 	if entity != LocalPlayer() then return end

-- 	util.PrintTable(data)
-- 	local start_pos = R.Entity.EyePos(LocalPlayer())
-- 	local end_pos = data.Trace.HitPos
-- 	print("-----------------------------\n")
-- 	print(end_pos)

-- 	table.insert(bulletTracers, {start = start_pos, endp = end_pos})
-- end)



-- local function DrawBulletTracers()
	

-- 	-- for i, trace in ipairs(bulletTracers) do
-- 	-- 	cam.Start3D()
-- 	-- 		local start_ = R.Vector.ToScreen( trace.start )
-- 	-- 		local end_ = R.Vector.ToScreen( trace.endp )
-- 	-- 	cam.End3D()
-- 	-- 	draw.Line(start_.x, start_.y, end_.x, end_.y, Color(141, 202, 255))
-- 	-- end
-- end


local function Hitmarker(point, alpha)
	x = point.x
	y = point.y

	draw.Line(x - 7, y - 7, x - 3, y - 3, Color(255, 255, 255, 255 * alpha))
	draw.Line(x - 7, y + 7, x - 3, y + 3, Color(255, 255, 255, 255 * alpha))
	draw.Line(x + 7, y - 7, x + 3, y - 3, Color(255, 255, 255, 255 * alpha))
	draw.Line(x + 7, y + 7, x + 3, y + 3, Color(255, 255, 255, 255 * alpha))
end


local function DrawVisuals()
	if hideOverlay then return end
	local cros = Menu.Func.GetVar("Visuals", "Misc", "Crosshair")
	local fov = Menu.Func.GetVar("Visuals", "Misc", "FOV Circle")
	local screen = {}
	screen.w = ScrW()
	screen.h = ScrH()

	local x, y

	if Menu.Func.GetVar("Visuals", "View Mods", "Third Person") and do_thirdperson and cros[1] then
		cam.Start3D()
			local trace = R.Vector.ToScreen( util.TraceLine( util.GetPlayerTrace( LocalPlayer() )).HitPos )
		cam.End3D()

		
		x = trace.x
		y = trace.y
	else
		x = ScrW() / 2
		y = ScrH() / 2
	end

	if fov[1] and Menu.Func.GetVar("Aimbot", "Legit Settings", "Aimbot FOV Enabled") and MyEyeAngle and MyEyePos then
		cam.Start3D()
			local pos = R.Vector.ToScreen(R.Angle.Forward(Angle(Menu.Func.GetVar("Aimbot", "Legit Settings", "Aimbot FOV"), 0, 0) + MyEyeAngle ) * 30 + MyEyePos )
		cam.End3D()

		pos.y = math.Round( pos.y )

		surface.DrawCircle( x, y, y - pos.y, fov[2] )
	end

	x = x - 1 -- lol its off center by a pixel :3

	if cros[1] then
		DrawCrosshair(x, y, Menu.Func.GetVar("Visuals", "Misc", "Crosshair Size"), cros[2], Menu.Func.GetVar("Visuals", "Misc", "Crosshair Style") )
	end

	if Menu.Func.GetVar("Visuals", "Misc", "Hit Marker") and hitmarker.lasthit != nil and hitmarker.lasthit + 1 > SysTime() then
		local hitmarker_alpha = 1 * (1 - (SysTime() - hitmarker.lasthit ) )
		Hitmarker({x = x, y = y}, hitmarker_alpha)
	end

	DrawLogs(logs)
	WaterMark(screen)
    DrawVelo()
	EntityEsp()
	DrawKeypadSteal(screen)
	Inds.Draw(screen)
end


Lib.Hook.Add( "HUDPaint", "C(<W/]^+k2VyPKasdkgufqawudtyfiuyFIAUYGDOIU", DrawVisuals )

-- local testVal = 0
-- Lib.Hook.Add( "InputMouseApply", "testMouseWheel", function(cmd, x, y, ang)
--     testVal = testVal + cmd:GetMouseWheel() * 2 --any scale number you want to use
--     print(testVal)
-- end)