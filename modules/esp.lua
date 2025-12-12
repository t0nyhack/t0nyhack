local function offsettan( ply, eyes )
	if !IsValid( ply ) then return Vector( 0, 0, 0 ) end

	if eyes == false then
		return R.Vector.ToScreen( R.Entity.GetPos( ply ))
	end

	if !R.Entity.GetAttachment( ply, R.Entity.LookupAttachment( ply, "eyes" )) then
		return R.Vector.ToScreen( R.Player.GetShootPos( ply ))
	else
		return R.Vector.ToScreen( R.Entity.GetAttachment( ply, R.Entity.LookupAttachment( ply, "eyes" )).Pos)
	end
end

local matColor = Material( "color" )

function render.SetColorMaterial()
	render.SetMaterial( matColor )
end

-- ArrestAuraMaterial = CreateMaterial("%!$#%JKLGASG(IAK$#_))^(*!@#$" .. SysTime(), "VertexLitGeneric", {
-- 	["$basetexture"] = "models/debug/debugwhite",
-- 	["$nocull"] = 1,
-- 	["$model"] = 1
-- })

local colorRange = {
	[1] = {start = 0, color = Color( 255, 0, 0 )},
	[2] = {start = 100, color = Color( 0, 255, 0 )}
}

local function DrawQuad(color, positions)
	local args = positions
	surface.SetDrawColor( color )
	for i = 1, #args do
		if i == #args then
			surface.DrawLine( args[i].x, args[i].y, args[1].x, args[1].y )
		else
			surface.DrawLine( args[i].x, args[i].y, args[i + 1].x, args[i + 1].y )
		end
	end
end


local DORMANT_ALPHA_MODULATE = 1
local function GetDColor(func, dormant)
	if dormant then
		local clr = Menu.Func.GetVar("Visuals", "ESP", "Show Dormant Players")[2]
		return Color(clr.r, clr.g, clr.b, clr.a * DORMANT_ALPHA_MODULATE)
	else
		return func
	end
end

local function GetDColorHighlIght(origclr, dormant, plyr, highlight)
	if dormant then
		local clr = Menu.Func.GetVar("Visuals", "ESP", "Show Dormant Players")[2]
		return Color(clr.r, clr.g, clr.b, clr.a * DORMANT_ALPHA_MODULATE)
	end

	local clr, rank = util.GetHighLightColor( plyr, highlight)

	if clr then
		return clr
	end
	return origclr
end



local staffRanks = {"tmod", "trialmod", "trialmoderator", "tmoderator", "mod", "moderator", "smod", "smoderator", "seniormod", "seniormoderator", "jadmin", "junioradmin", "leadadmin", "headadmin", "trialadmin", "sadmin", "senioradmin", "owner", "coowner", "developer", "manager", "staff", "admin", "superadmin"}

local function getAdminRank( ply )
	for k, v in ipairs(staffRanks) do
		if string.lower(R.Entity.GetNWString( ply, "UserGroup", "user" )) == v then
			return v
		end
	end
	return nil
end

local DDORMANT = false

local TIMEDORMANT = {
	["ex"] = {nil}
}

local function DrawDText(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
	if not DDORMANT then
		draw.SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
	else
		if font == "sdadlnhfjfpNIGGERuhgbisdguoa" then
			y = y + 2 //idk why i have to do this, the font is just gay
		end
		draw.SimpleText(text, font.. "OUTLINE", x, y, colour, xalign, yalign)
	end
end

local function GetChokedPakcets(v)

	local pid = R.Player.UserID( v )
	if TickCopies and TickCopies[pid] then
		local maxChoke = 1
		for k, t in pairs( TickCopies[pid] ) do
			if t.choked > maxChoke then
				maxChoke = t.choked
			end
		end

		if maxChoke - lagForgiveness - 1 > 1 then
			return maxChoke
		else
			return nil
		end
	end
end

local function rotate_around_c(angle, center, point, point_) -- yea this is pasted get over it
	local s = math.sin(angle)
	local c = math.cos(angle)
	
	point.x = point.x-center.x
	point.y = point.y-center.y
	point_.x = point_.x-center.x
	point_.y = point_.y-center.y
	
	local xn, yn = point.x * c - point.y * s, point.x * s + point.y * c
	local x_n, y_n = point_.x * c - point_.y * s, point_.x * s + point_.y * c
	
	return xn+center.x, yn+center.y, x_n+center.x, y_n+center.y
end 

local cam3D = { ["type"] = "3D" }
lagForgiveness = 0
local lastChoked = 0
local pudChoked = 0
local function DrawESP() -- HudPaint
	if hideOverlay then return end

	-- ent esp

	if Menu.Func.GetVar("Visuals", "Entity ESP", "Enabled") then
		for i, v in ipairs(EntsToDraw) do
			if !IsValid(v.ent) or v.ent == nil then continue end 
			if R.Entity.IsDormant( v.ent ) then continue end
			local entPos = R.Entity.GetPos( v.ent )
			cam.Start(cam3D)
				local screenPos = R.Vector.ToScreen( entPos )
			cam.End3D()

			if Menu.Func.GetVar("Visuals", "Entity ESP", "Name") then
				local ent_text = R.Entity.GetClass( v.ent )
				ent_text = util.GetEntField( v.ent, "PrintName", ent_text)
				draw.SimpleTextOutlined(ent_text, "adjflkjasfljsadlkj", screenPos.x, screenPos.y, v.clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, v.clr.a))
			end

			if Menu.Func.GetVar("Visuals", "Entity ESP", "Distance") then
				local distance = math.ceil(R.Vector.Distance(R.Entity.GetPos( v.ent ), R.Entity.GetPos( LocalPlayer() ))/52)
				local C = Menu.Func.GetVar("Visuals", "Entity ESP", "Distance")[2]
				draw.SimpleTextOutlined("("..distance..")", "adjflkjasfljsadlkj", screenPos.x, screenPos.y + 8, C, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, C.a))
			end
		end
	end

	-- player espppp
	if !Menu.Func.GetVar("Visuals", "ESP", "ESP Enabled") then return end

	colorRange = {}
	if Menu.Func.GetVar("Visuals", "ESP", "Health Bar") then
		table.insert(colorRange, {start = 0, color = Menu.Func.GetVar("Visuals", "ESP", "Low Health")} )
		table.insert(colorRange, {start = 100, color = Menu.Func.GetVar("Visuals", "ESP", "Full Health")})
	end

	render.SetColorMaterial()
	local localPos = R.Entity.GetPos( LocalPlayer() ) -- keep here to avoid running every frame
	local localAngle = LocalPlayer():EyeAngles()
	for _, v in ipairs( player.GetAll() ) do
		if !IsValid(v) or v == nil then continue end 
		if v == LocalPlayer() or !IsValid( v ) or !R.Player.Alive( v ) or !ShouldDrawPlayer( v ) then continue end

		local max = Menu.Func.GetVar("Visuals", "ESP Filtering", "Max Distance")
		if max and (R.Vector.Distance(R.Entity.GetPos(v), R.Entity.GetPos(LocalPlayer()))/52) > max then continue end

		local dormant = false
		DDORMANT = R.Entity.IsDormant( v )
		if R.Entity.IsDormant( v ) then
			if Menu.Func.GetVar("Visuals", "ESP", "Show Dormant Players")[1] then
				dormant = true
				if TIMEDORMANT[GetSteamID( v )] == nil then
					TIMEDORMANT[GetSteamID( v )] = CurTime()
				end
			else
				continue
			end
		else
			TIMEDORMANT[GetSteamID( v )] = nil
		end

		local color = util.TeamColor( R.Player.Team( v ))
		local wep = R.Player.GetActiveWeapon( v )

		if !dormant then
			-- if Menu.Func.GetVar("Visuals", "ESP", "Backtrack Skeleton ESP")[1] then
			-- 	local pid = R.Player.UserID( v )

			-- 	local drawTick = currentTick - TIME_TO_TICKS(1 - CFunc.GetLatency( 0 )) + 2

			-- 	if TickCopies[pid] and TickCopies[pid][drawTick] and
			-- 		TickCopies[pid][drawTick].usable and TickCopies[pid][currentTick] and !R.Player.InVehicle( v ) then
			-- 		local startPos = R.Entity.GetPos( v )
			-- 		if TickCopies[pid][drawTick].origin != startPos then
			-- 			for k1, v1 in ipairs(TickCopies[pid][drawTick].DrawBones) do
			-- 				local LineStart, LineEnd = R.Vector.ToScreen(v1[1]), R.Vector.ToScreen(v1[2])
			-- 				surface.SetDrawColor(Menu.Func.GetVar("Visuals", "ESP", "Backtrack Skeleton ESP")[2])
			-- 				surface.DrawLine(LineStart.x, LineStart.y, LineEnd.x, LineEnd.y)
			-- 			end
			-- 		end
			-- 	end
			-- end

			if Menu.Func.GetVar("Visuals", "ESP", "Skeleton")[1] then
				for i = 1, R.Entity.GetBoneCount(v) do
					local Parent = R.Entity.GetBoneParent(v, i)
					if (Parent == -1) then 
						continue
					end
					local FirstBone, SecondBone = R.Entity.GetBonePosition(v, i), R.Entity.GetBonePosition(v, Parent)
					if (R.Entity.GetPos( v )== FirstBone) then 
						continue
					end
					local LineStart, LineEnd = R.Vector.ToScreen(FirstBone), R.Vector.ToScreen(SecondBone)
					surface.SetDrawColor( GetDColorHighlIght(Menu.Func.GetVar("Visuals", "ESP", "Skeleton")[2], dormant, v, "Skeleton") ) 
					surface.DrawLine(LineStart.x, LineStart.y, LineEnd.x, LineEnd.y)
				end
			end
		end

		local a_m = 1
		if dormant then
			a_m = (1 - (CurTime() - TIMEDORMANT[GetSteamID( v )]) / 10) * .7
			DORMANT_ALPHA_MODULATE = a_m
		end
		if a_m <= 0 then continue end

		local entPos = R.Entity.GetPos( v )
		entPos.z = entPos.z + R.Entity.OBBMaxs( v ).z
		cam.Start(cam3D)
			local o = offsettan( v, false ) -- LOL OKAY
			local top = R.Vector.ToScreen( entPos )
		cam.End3D()

		top.x, top.y, o.x, o.y = math.floor(top.x), math.floor(top.y), math.floor(o.x), math.floor(o.y)

		if !dormant and Menu.Func.GetVar("Visuals", "ESP", "Out Of FOV Arrows")[1] and ((top.x < 0 or top.y < 0 or top.x > ScrW() or top.y > ScrH()) and (o.x < 0 or o.y < 0 or o.x > ScrW() or o.y > ScrH())) then
			local entPos = R.Entity.GetPos( v )
			local angles = (localPos - entPos):Angle()
			local angle = -math.rad(angles.y - localAngle.y - 90)
			local x, y = math.sin(angle), math.cos(angle)
			local width, height = ScrW(), ScrH()

			--R.Player.GetFriendStatus( v ) == "friend"
			local color = GetDColorHighlIght(Menu.Func.GetVar("Visuals", "ESP", "Out Of FOV Arrows")[2], dormant, v, "Arrows") 
			surface.SetDrawColor(color)
			
			local size = Menu.Func.GetVar("Visuals", "ESP", "Indicator Size")
			local arrow_radius = Menu.Func.GetVar("Visuals", "ESP", "Indicator Distance") / 160 * height
			--surface.DrawLine(w, h, w+x*100, h+y*100)
			
			local offset = Vector(math.floor(math.cos(angle)*arrow_radius), math.floor(math.sin(angle)*arrow_radius))
			local center = Vector(width/2, height/2)
			local point = offset + center
			local point4 = offset + center - offset:GetNormalized() * size * 1.7
			local point1, point2 = Vector(point.x-1 * size, point.y-2 * size), Vector(point.x+1 * size, point.y-2 * size)
			local px, py = point.x, point.y
			local x, y, x1, y1 = rotate_around_c(angle-math.pi/2, point, point1, point2)
			draw.NoTexture()
			--renderer.triangle(point.x, point.y, x, y, point4.x, point4.y, r, g, b, a * mult_a)
			--renderer.triangle(point.x, point.y, x1, y1, point4.x, point4.y, r, g, b, a * mult_a)
			surface.DrawPoly( {
				{ x = point.x, y = point.y },
				{ x = x, y = y },
				{ x = point4.x, y = point4.y },
				{ x = x1, y = y1 },
			})
		end


		if !o.visible or !top.visible then 
			continue 
		end

		local returnSize = 8
		local widthoffset = math.floor((top.y - o.y)/4)

		if Menu.Func.GetVar("Visuals", "ESP", "Box")[1] then

			local clr = Menu.Func.GetVar("Visuals", "ESP", "Box")[2]

			local boxcolor = GetDColorHighlIght(clr, dormant, v, "Box")
			local outlinealpha = math.Clamp(boxcolor.a - 30, 0, 255)
			DrawQuad(Color(0, 0, 0, outlinealpha), { -- outer 
				{x = top.x - widthoffset + 1, y = top.y - 1},
				{x = top.x + widthoffset - 1, y = top.y - 1},
				{x = o.x + widthoffset - 1, y = o.y + 1},
				{x = o.x - widthoffset + 1, y = o.y + 1},
			})
			DrawQuad(Color(0, 0, 0, outlinealpha), { --inner
				{x = top.x - widthoffset - 1, y = top.y + 1},
				{x = top.x + widthoffset + 1, y = top.y + 1},
				{x = o.x + widthoffset + 1, y = o.y - 1},
				{x = o.x - widthoffset - 1, y = o.y - 1},
			})
			DrawQuad(boxcolor, { --normal
				{x = top.x - widthoffset, y = top.y},
				{x = top.x + widthoffset, y = top.y},
				{x = o.x + widthoffset, y = o.y},
				{x = o.x - widthoffset, y = o.y},
			})
		-- elseif Menu.Func.GetVar("Visuals", "ESP", "Show Box") == "3D" then
		-- 	cam.Start3D()
		-- 		render.DrawWireframeBox( R.Entity.GetPos(v), Angle( 0, 0, 0 ), R.Entity.OBBMins( v ), R.Entity.OBBMaxs( v ),  Menu.Func.GetVar("Visuals", "ESP", "Box Color"))
		-- 	cam.End3D()
		end

		
		if Menu.Func.GetVar("Visuals", "ESP", "Health Bar") then
			local health = R.Entity.Health( v )
			local hp = math.Clamp( math.ceil((health/R.Entity.GetMaxHealth( v )) * 100), 0, 100 )

			local hppos_y = (o.y - ((o.y - top.y) * (hp/100)))
			local hppos_x = (o.x - ((o.x - top.x) * (hp/100))) + widthoffset
			draw.NoTexture()

			if !dormant then
				surface.SetDrawColor(Color(0, 0, 0, 220))
			else
				surface.SetDrawColor(Color(0, 0, 0, (DORMANT_ALPHA_MODULATE * 255) * 0.85))
			end
			surface.DrawPoly( {
				{x = top.x + widthoffset - 7, y = top.y - 1},
				{x = top.x + widthoffset - 3, y = top.y - 1},
				{x = o.x + widthoffset - 3, y = o.y + 1},
				{x = o.x + widthoffset - 7, y = o.y + 1}
			})

			if !dormant then
				surface.SetDrawColor( util.ColorLerpHSV(hp, colorRange) )
			else 
				local clr = Menu.Func.GetVar("Visuals", "ESP", "Show Dormant Players")[2] 
				surface.SetDrawColor( Color( clr.r, clr.g, clr.b, clr.a * DORMANT_ALPHA_MODULATE ) )
			end

			surface.DrawPoly( {
				{x = hppos_x - 6, y = hppos_y},
				{x = hppos_x - 4, y = hppos_y},
				{x = o.x + widthoffset - 4, y = o.y},
				{x = o.x + widthoffset - 6, y = o.y}
			})


			local textclr = GetDColor(Color(255, 255, 255, 200), dormant)
			DrawDText( health, "adjflkjasfljsadlkj", hppos_x - 5, math.Clamp(hppos_y, top.y + 4, o.y), textclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, textclr.a ))
		end

		if Menu.Func.GetVar("Visuals", "ESP", "Flags") then
			local flags = {}

			-- if TIMEDORMANT[GetSteamID( v )] != nil then
			-- 	table.insert(flags, {"D: ".. tostring(CurTime() - TIMEDORMANT[GetSteamID( v )]), {r = 255, g = 255, b = 255, a = 255}})
			-- end

			-- if Menu.Func.GetVar("Visuals", "ESP", "Show Flags", "Show Possible Admin")[1] then
			-- 	if PossibleAdmins[GetSteamID(v)] ~= nil then
			-- 		table.insert(flags, {"ADMIN", Menu.Func.GetVar("Visuals", "ESP", "Show Flags", "Show Possible Admin")[2]})
			-- 	end
			-- end
			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Murderer") then
                if engine.ActiveGamemode() == "murder" then
                    for _, weapon in ipairs(v:GetWeapons()) do
                        if string.find(weapon:GetClass(), "knife") then
                            table.insert(flags, {"MURDERER", Color( 255, 33, 33, 200)})
                            break
                        end
                        
                        if string.find(weapon:GetClass(), "magnum") then
                            table.insert(flags, {"MAGNUM", Color( 101, 152, 255, 200)})
                            break
                        end
                        
                    end
                end
            end
			
			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Team") then
				local team_ =  R.Player.Team( v )
				if team_ then
					table.insert(flags, { util.TeamName( team_ ) or "nil", util.TeamColor( team_ ) })
				end
			end

			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Over Heal") and R.Entity.Health(v) > R.Entity.GetMaxHealth(v) then
				table.insert(flags, {"hp+", Color( 157, 255, 0, 200)})
			end

			-- if Menu.Func.GetVar("Visuals", "ESP", "Show Active Flags", "Show Health")[1] then
			-- 	table.insert(flags, {R.Entity.Health( v ) .. " HP", Menu.Func.GetVar("Visuals", "ESP", "Show Active Flags", "Show Health")[2]})
			-- end

			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Armor") and R.Player.Armor( v ) > 0 then
				table.insert(flags, {R.Player.Armor( v ) .. " AP", Color( 13, 192, 247, 200)})
			end

			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Money") then
				local money = R.Entity.GetNWInt(v, "cash", 0)
				if money > 0 then
					table.insert(flags, {"$" .. money, Color(3, 103, 4, 200)})
				end
			end

			local ping = R.Player.Ping( v )

			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Ping") then

				if ping <= 0 or R.Player.IsBot( v ) then
					table.insert(flags, {"BOT",  Color( 253, 189, 49, 200)})
				else
					local pingclr = ping < 100 and Color( 255, 255, 255, 200) or ping < 200 and Color( 255, 235, 86, 200) or ping < 300 and Color( 255, 166, 0, 200) or Color( 255, 0, 72, 200)
					table.insert(flags, {ping .. " MS", pingclr})
				end

			elseif Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Bot") then
				if ping <= 0 or R.Player.IsBot( v ) then
					table.insert(flags, {"BOT", Color( 253, 189, 49, 200)})
				end
			end

			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Distance") then
				table.insert(flags, {math.ceil(R.Vector.Distance(R.Entity.GetPos( v ), R.Entity.GetPos( LocalPlayer() ))/52) .. "M", Color( 255, 255, 255, 200)})
			end

			if Menu.Func.GetVar("Visuals", "ESP", "Active Flags", "Chocked Packets") then
				local choackedticks = GetChokedPakcets( v )
				if choackedticks then
					table.insert(flags, {choackedticks, Color( 255, 76, 100, 200)})
				end

				local pid = R.Player.UserID( v )

				-- if TickCopies[pid] and TickCopies[pid][currentTick - 1] and TickCopies[pid][currentTick] and !R.Player.InVehicle( v ) then
				-- 	local current = TickCopies[pid][currentTick].origin
				-- 	local before = TickCopies[pid][currentTick].origin

				-- 	for i = 1, 3 do
				-- 		local test = TickCopies[pid][currentTick - i]
				-- 		if test == nil then break end
				-- 		before = test.origin
				-- 		local dist = R.Vector.DistToSqr( current, before )
				-- 		if dist ~= 0 then break end
				-- 	end

				-- 	local dist = R.Vector.DistToSqr( current, before )

				-- 	if dist > 4096 then
				-- 		table.insert(flags, {"LC", Color( 255, 76, 100, 200)})
				-- 	end
				-- end

				if TickCopies[pid] and TickCopies[pid][currentTick - 1] and TickCopies[pid][currentTick] and !R.Player.InVehicle( v ) then
					if R.Vector.DistToSqr( TickCopies[pid][currentTick].origin, TickCopies[pid][currentTick - 1].origin ) > 4096 then
						return
					end
				end
			end

			--[[
			local pid = R.Player.UserID( v )
			if TickCopies and TickCopies[pid] then
				local maxChoke = 1
				for k, t in pairs( TickCopies[pid] ) do
					if t.choked > maxChoke then
						maxChoke = t.choked
					end
				end

				if maxChoke - lagForgiveness - 1 > 1 then
					local color = GetDColor(Menu.Func.GetVar("Visuals", "ESP", "Show Choked Packets")[2], dormant)
					DrawDText( maxChoke, "adjflkjasfljsadlkj", o.x, o.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, color.a ))
					o.y = o.y + returnSize
				end
			end
			]]

			if #flags > 0 then
				for num, flag in ipairs(flags) do
					local difference = math.Clamp( math.ceil(((num - 1) * 7)/(o.y - top.y)*100), 0, 100)
					local xoffset = (top.x + ((o.x - top.x) * (difference/100)))
					local flagclr = GetDColor(flag[2], dormant)
					-- local xoffset = (o.x - ((o.x - top.x) * (hp/100)))
					DrawDText( flag[1], "adjflkjasfljsadlkj", xoffset - widthoffset + 4, top.y + ((num - 1) * 7), flagclr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, flagclr.a ))
				end
			end

		end
		--R.Player.GetFriendStatus()
		local c_color, c_role = util.GetHighLightColor( v, "Show Flag")
		if c_color ~= nil then
			DrawDText( string.upper(c_role), "adjflkjasfljsadlkj", top.x, top.y - 13, GetDColor(c_color, dormant), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, color.a ))
		end

		-- if Menu.Func.GetVar("Visuals", "ESP", "ESP Highlight") then
		-- 	if Menu.Func.GetVar("Visuals", "ESP", "ESP Highlight", "Show Flag") then
		-- 		if Menu.Func.GetVar("Visuals", "ESP", "ESP Highlight", "Highlight Friends")[1] and R.Player.GetFriendStatus( v ) == "friend" then
		-- 			local color = GetDColor(Menu.Func.GetVar("Visuals", "ESP", "ESP Highlight", "Highlight Friends")[2], dormant)
		-- 			DrawDText( "FRIEND", "adjflkjasfljsadlkj", top.x, top.y - 13, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, color.a ))
		-- 		elseif Menu.Func.GetVar("Visuals", "ESP", "ESP Highlight", "Highlight Admins")[1] and PossibleAdmins[GetSteamID(v)] ~= nil then
		-- 			local color = GetDColor(Menu.Func.GetVar("Visuals", "ESP", "ESP Highlight", "Highlight Admins")[2], dormant)
		-- 			DrawDText( string.upper(PossibleAdmins[GetSteamID(v)]) , "adjflkjasfljsadlkj", top.x, top.y - 13, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, color.a ))
		-- 		end
				
		-- 	end

		-- end

		if Menu.Func.GetVar("Visuals", "ESP", "Steam Name")[1] then
			local color = GetDColor(Menu.Func.GetVar("Visuals", "ESP", "Steam Name")[2], dormant)
			DrawDText( R.Player.Nick( v ), "sdadlnhfjfpNIGGERuhgbisdguoa", top.x, top.y - 1, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, color.a ))

			--DrawDText( "BOBA THE CAT IS THE BEST", "sdadlnhfjfpNIGGERuhgbisdguoa", top.x, top.y - 16, Color( 45, 255, 76), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, color.a ))
		end

		o.y = o.y + 4

		local text_x = o.x

		if Menu.Func.GetVar("Visuals", "ESP", "Active Weapon")[1] and IsValid(wep) then
			local wepStr = R.Weapon.GetPrintName( wep )
			if wepStr == "<MISSING SWEP PRINT NAME>" then wepStr = R.Entity.GetClass( wep ) end
			local color = GetDColor(Menu.Func.GetVar("Visuals", "ESP", "Active Weapon")[2], dormant)
			DrawDText(wepStr, "adjflkjasfljsadlkj", text_x, o.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, color.a ))
			o.y = o.y + returnSize
		end

		if Menu.Func.GetVar("Visuals", "ESP", "User Group")[1] then
			local group = R.Entity.GetNWString( v, "UserGroup", "user" ) -- aka GetUserGroup()
			if group and group != "user" then
				local color = GetDColor(Menu.Func.GetVar("Visuals", "ESP", "User Group")[2], dormant)
				DrawDText( group, "adjflkjasfljsadlkj", text_x, o.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, color.a ))
				o.y = o.y + returnSize
			end
		end
		-- if Menu.Func.GetVar("Visuals", "ESP", "Show Health") and !Menu.Func.GetVar("Visuals", "ESP", "Show Health", "Health Bars") then
		-- 	local health = R.Entity.Health( v )
		-- 	local hp = math.Clamp( math.ceil((health/R.Entity.GetMaxHealth( v )) * 100), 0, 100 )

		-- 	DrawDText( health .. " HP", "adjflkjasfljsadlkj", text_x, o.y, GetDColor( util.ColorLerp(hp, colorRange), dormant), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, color.a ))
		-- 	o.y = o.y + returnSize
		-- end
	end

	local lagcompColor = Color(255, 0, 0, 255)
	if brokeLagComp then
		lagcompColor = Color(0, 255, 0, 255)
	end
end

local brokeLagComp = false
local function CMove( cmd ) -- CreateMove
	local choked = CFunc.GetChokedPackets()
	if lastChoked > choked then
		pudChoked = lastChoked
	end
	lastChoked = choked
end

Lib.Hook.Add( "HUDPaint", "C(<W/]^+k2VyPK|?W@_SZ2=aK&Cn81t#", DrawESP )
Lib.Hook.Add( "CreateMove", "♲ţ´ő😢Ɂådfgjue980u4Ĕ☬Ǆ😝ģĄȗ♇ŴT", CMove )