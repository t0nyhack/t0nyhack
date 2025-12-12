ChamsMaterial1 = CreateMaterial("😦ÊƉ😊ƤǕ.D😸😚Ę]ÞȌ🙀ã😧ÌȻ☺😞¢æĜ7" .. SysTime(), "VertexLitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$nocull"] = 0,
	["$model"] = 1,
	["$nofog"] = 1,
	["$nocull"] = 0,
	["$selfillum"] = 1,
	["$halflambert"] = 1,
	["$znearer"] = 0,
})

ChamsMaterial2 = Material( "models/wireframe" )

ChamsMaterial3 = CreateMaterial("ß♯ƞÑ☽😧⚅😏¤)😋♘Ė😎=😎🙁😎😛😤☘♖$Ēî😋" .. SysTime(), "VertexLitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$envmap"] = "effects/cubemapper",
	["$envmapcontrast"] = 10,
	["$normalmapalphaenvmapmask"] = 1,
	-- ["$rimlight"] = 1,
	-- ["$rimlightboost"] = 15,
	-- ["$rimlightexponent"] = 50,
	-- ["$rimmask"] = 0,
	["$phong"] = 1,
	["$phongboost"] = 100,
	["$phongexponent"] = 200,
	["$bumpmap"] = "gm_construct/water_13",
	["$phongfresnelranges"] = "[1 1 1]",
	["$basemapalphaphongmask"] = 1,
	["$basemapluminancephongmask"] = 1,
	["$nofog"] = 1,
	["$model"] = 1,
	["$nocull"] = 0,
	["$selfillum"] = 1,
	["$halflambert"] = 1,
	["$znearer"] = 0,
	["$flat"] = 1

	--[[
			$basetexture models/Alyx/alyx_faceandhair
	$bumpmap models/alyx/alyx_head_normal
	$halflambert 1
	$nodecal 1
	$model 1

	$phong 1
//	$phongexponent 33
	$phongexponenttexture models/Alyx/alyx_head_exponent
	$phongboost	6
	$phongfresnelranges	"[0.05 0.5 1]"
	]]
})



ChamsMaterial4 = CreateMaterial( "ooga booga weewoo" .. SysTime(), "VertexLitGeneric", {

	["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
	-- ["$envmap"] = "skybox/sky_dustbowl_01",
	-- ["$envmapfresnel"] = 1,
	-- ["$phong"] = 1,
	-- ["$phongfresnelranges"] = "[0 0.05 0.1]",
	["$selfillum"] = 1,
	["$selfillumfresnel"] = 1,
	--["$basemapalphaphongmask"] = 1,
	["$selfillumfresnelminmaxexp"] = "[0.1 0.2 0.3]",
	["$selfillumtint"] = "[0 0 0]",
	["$additive"] = 1,
	["$color2"] = "[5 5 5]"
})

ChamsMaterial5 = Material( "models/effects/vol_light001" )
ChamsMaterial6 = Material( "models/effects/portalfunnel_sheet" )
ChamsMaterial7 = Material( "effects/combineshield/comshieldwall.vtf" )


ChamsMaterial8 = CreateMaterial( "ooga booga weewoo dasdasdasdasdad" .. SysTime(), "VertexLitGeneric", {

	["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
	-- ["$envmap"] = "skybox/sky_dustbowl_01",
	-- ["$envmapfresnel"] = 1,
	-- ["$phong"] = 1,
	-- ["$phongfresnelranges"] = "[0 0.05 0.1]",
	["$selfillum"] = 1,
	["$selfillumfresnel"] = 1,
	--["$basemapalphaphongmask"] = 1,
	["$selfillumfresnelminmaxexp"] = "[0.1 0.2 0.3]",
	["$selfillumtint"] = "[0 0 0]",
	["$additive"] = 0,
	["$color2"] = "[5 5 5]"
})

local BulletTracerMat = Material("vgui/white")




-- local rt = GetRenderTarget( "tjklrqjtlkjqkltjl" .. tostring( SysTime() ), ScrW(), ScrH() )

-- function render.CopyTexture( from, to )
-- 	local OldRT = render.GetRenderTarget()
-- 	render.SetRenderTarget( from )
-- 	render.CopyRenderTargetToTexture( to )
-- 	render.SetRenderTarget( OldRT )
-- end

-- local depthBuffer = GetRenderTarget( "depth_BUFFBOY" .. tostring( SysTime() ), ScrW(), ScrH() )
-- Lib.Hook.Add( "PostDrawOpaqueRenderables", "this is a very cool function thank you", function()
-- 	render.UpdateFullScreenDepthTexture()
-- 	-- render.CopyRenderTargetToTexture( rt )
-- 	render.CopyTexture( GetRenderTarget( "_rt_PowerOfTwoFB", ScrW(), ScrH() ), depthBuffer )
-- end)

local LocalViewModel = nil


local function DrawArrestBatonWarning( pos, rad, color )
	if Menu.Func.GetVar( "Visuals", "ESP", "ABR Style" ) == "3D" then
		render.DrawWireframeSphere( pos, rad, 50, 50, color )
	else
		cam.Start3D2D( pos, Angle( 0, 0, 0 ), 1 )
			draw.Circle( 0, 0, rad, 100, color )
		cam.End3D2D()
	end
end

local function GlowChams( col1, col2 )
	render.SuppressEngineLighting( true )

	local clrs = {}
	clrs.prim = Color(col1.r / 255, col1.g / 255, col1.b /255, col1.a / 255)

	if col2 == nil then
		local h, s, v = ColorToHSV( Color(col1.r, col1.g, col1.b) )
		h = h - 50
		if h > 360 then
			h = h - 360
		end
		if h < 0 then
			h = 360 + h
		end
		v = math.Clamp(v * .7, 0, 1)
		local tempclr = HSVToColor( h, s, v )
		clrs.second = Color(tempclr.r / 255, tempclr.g / 255, tempclr.b /255, col1.a / 255)
	else
		clrs.second = Color(col2.r / 255, col2.g / 255, col2.b /255, col2.a / 255)
	end
	-- front
	render.SetModelLighting( 0, clrs.prim.r, clrs.prim.g, clrs.prim.b )
	-- back
	render.SetModelLighting( 1, clrs.prim.r, clrs.prim.g, clrs.prim.b )

	-- right
	render.SetModelLighting( 2, clrs.second.r, clrs.second.g, clrs.second.b )
	-- left 
	render.SetModelLighting( 3, clrs.second.r, clrs.second.g, clrs.second.b )

	-- back
	render.SetModelLighting( 4, clrs.second.r, clrs.second.g, clrs.second.b )
	-- front
	render.SetModelLighting( 5, clrs.second.r, clrs.second.g, clrs.second.b )
end

local matz = { -- i had to do the [""] sheit cuz they have spazes in demz
	["Original"] = nil,
	["Color"] = ChamsMaterial1,
	["Lit"] = ChamsMaterial1,
	["Flat"] = ChamsMaterial1,
	["Shiny"] = ChamsMaterial3,

	["Glow"] = ChamsMaterial8,
	["Original Glow"] = nil,
	["Wire Frame"] = ChamsMaterial1,

	["Wireframe"] = ChamsMaterial2,
	["Old Glow"] = ChamsMaterial4,
	["Portal Glow"] = ChamsMaterial6,
	["Combine Shield"] = ChamsMaterial7
}


local function ApplyChamMat(ent, material, color, matrix, invbonecache, newpos)
	local mat = matz[material]

	local NoLighting = material == "Original" or material == "Flat" or material == "Glow" or material == "Original Glow" or material == "Wire Frame"
	

	render.MaterialOverride(matz[material])
	render.SuppressEngineLighting( NoLighting )
	render.ResetModelLighting( 1, 1, 1 )
	if material != "Original Glow" then
		render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255 )
	else
		render.SetColorModulation(1, 1, 1 )
	end
	render.SetBlend( color.a / 255 )

	if material == "Lit" then
		GlowChams( color, nil )
	end
	
	if matrix then
		R.Entity.SetupBones( ent )
		util.SetBoneMatrix( ent, matrix )
	end

	R.Entity.DrawModel(ent)

	if matrix and invbonecache then
		R.Entity.SetupBones(ent)
		R.Entity.InvalidateBoneCache( ent )
	end

	if material == "Original Glow" then
		render.SuppressEngineLighting( true )
		render.MaterialOverride(matz["Old Glow"])
		render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255 )
		render.SetBlend( color.a / 255 )
		
		if matrix then
			R.Entity.SetupBones( ent )
			util.SetBoneMatrix( ent, matrix )
		end

		R.Entity.DrawModel(ent)

		if matrix and invbonecache then
			R.Entity.SetupBones(ent)
			R.Entity.InvalidateBoneCache( ent )
		end
	end


	if invbonecache then
		R.Entity.InvalidateBoneCache( ent )
	end


	render.ResetModelLighting( 1, 1, 1 )
	render.SuppressEngineLighting(false)
	render.MaterialOverride()
	render.SetColorModulation(1, 1, 1, 1)
	render.SetBlend( 1 )
end


local function Chams() -- RenderScreenspaceEffects
	if hideOverlay then return end

	if Menu.Func.GetVar("Visuals", "ESP", "ESP Enabled") and Menu.Func.GetVar("Visuals", "ESP", "Arrest Baton Radius") then
		for k, ent in pairs( player.GetAll() ) do
			if ent == LocalPlayer() or !IsValid( ent ) or !R.Player.Alive( ent ) or R.Entity.IsDormant( ent ) then continue end 

			local wep = R.Player.GetActiveWeapon( ent )

			if IsValid( wep ) and !R.Entity.IsDormant( ent ) then
				local warningclr = Menu.Func.GetVar("Visuals", "ESP", "Warning Color") 
				local safeclr = Menu.Func.GetVar("Visuals", "ESP", "Passive Color")
				if R.Entity.GetClass( wep ) == "icefuse_baton" then

					DrawArrestBatonWarning( R.Entity.GetPos( ent ), 150, ( R.Vector.Distance( R.Entity.GetPos( ent ), R.Entity.GetPos( LocalPlayer() ) ) < 150 ) and warningclr or safeclr )

				elseif R.Entity.GetClass( wep ) == "arrest_stick" then
					
					DrawArrestBatonWarning( R.Entity.GetPos( ent ), 150, ( R.Vector.Distance( R.Entity.EyePos( ent ), R.Entity.GetPos( LocalPlayer() ) ) < (wep.stickRange or 90) ) and warningclr or safeclr )
					
				end
			end
		end
	end

	

	-- render.OverrideDepthEnable( true, true )
	-- render.DepthRange( 0, .5 )
	-- render.ClearDepth()
	-- render.SetRenderTarget( depthBuffer )
	-- render.SetRenderTarget()

	-- render.ClearDepth()
	-- render.CopyTexture( depthBuffer, GetRenderTarget( "_rt_PowerOfTwoFB", ScrW(), ScrH() ) )
	-- render.UpdateFullScreenDepthTexture()
	-- __G.render.DrawTextureToScreen( render.GetFullScreenDepthTexture() )

	--entity chams
	if Menu.Func.GetVar("Visuals", "Entity ESP", "Enabled") and Menu.Func.GetVar("Visuals", "Entity ESP", "Chams") then
		for i, v in ipairs(EntsToDraw) do
			if !IsValid(v.ent) or v.ent == nil then continue end 
			ApplyChamMat(v.ent, Menu.Func.GetVar("Visuals", "Entity ESP", "Entity Material"), v.clr)
		end
	end

	for k, ent in pairs( player.GetAll() ) do
		if !IsValid(ent) or ent == nil then continue end 
		if ent != LocalPlayer() and Menu.Func.GetVar("Visuals", "Chams", "Player Chams")[1] then
			-- if ent == LocalPlayer() then return end

			if !IsValid( ent ) or !R.Player.Alive( ent ) or R.Entity.IsDormant( ent ) or ent == nil or !ShouldDrawPlayer( ent ) then continue end

			local highlight_clr = util.GetHighLightColor( ent, "Chams")
			ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Chams", "Player Material"), highlight_clr or Menu.Func.GetVar("Visuals", "Chams", "Player Chams")[2])


			local ActiveWeapon = R.Player.GetActiveWeapon(ent)

			if IsValid( ActiveWeapon ) then

				ApplyChamMat(ActiveWeapon, Menu.Func.GetVar("Visuals", "Chams", "Player Material"), Menu.Func.GetVar("Visuals", "Chams", "Weapon Color"))
				
			end

		elseif ent == LocalPlayer() and R.Player.Alive( LocalPlayer() ) and do_thirdperson then
			local LocalPos = R.Entity.GetPos( ent )

			if Menu.Func.GetVar("Visuals", "Local Models", "Fake Lag Chams")[1] and anti_aim.FakeLagEnabled and CFunc.GetChokedPackets() > 0 then

				if ServerBoneMatrix and (ServerBoneMatrix[2] ~= LocalPos) then
					ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Local Models", "Fake Lag Material"), Menu.Func.GetVar("Visuals", "Local Models", "Fake Lag Chams")[2], ServerBoneMatrix[1])
				end

			end
			
			--Fake Chams
			if Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Chams")[1] and anti_aim.FakeAnglesEnabled then
				
				if ClientSendBoneMatrix then
					local old_translation = util.GetMatrixTranslation( ClientSendBoneMatrix[1] )
					util.OffSetMatrixPosition(ClientSendBoneMatrix[1], util.VectDiff(ClientSendBoneMatrix[2], LocalPos))
					ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Material"), Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Chams")[2], ClientSendBoneMatrix[1])
					util.SetMatrixTranslation( ClientSendBoneMatrix[1], old_translation )

				elseif ClientBoneMatrix then
					local old_translation = util.GetMatrixTranslation( ClientBoneMatrix[1] )
					util.OffSetMatrixPosition(ClientBoneMatrix[1], util.VectDiff(ClientBoneMatrix[2], LocalPos))
					ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Material"), Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Chams")[2], ClientBoneMatrix[1])
					util.SetMatrixTranslation( ClientBoneMatrix[1], old_translation )
				end

			end

			--Local Chams
			if Menu.Func.GetVar("Visuals", "Local Models", "Local Chams")[1] then
				local ActiveWeapon = R.Player.GetActiveWeapon(ent)

				if ServerBoneMatrix and !R.Player.InVehicle( LocalPlayer() ) then
					local old_translation = util.GetMatrixTranslation( ServerBoneMatrix[1] )
					util.OffSetMatrixPosition(ServerBoneMatrix[1], util.VectDiff(ServerBoneMatrix[2], LocalPos))
					ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Local Models", "Local Material"), Menu.Func.GetVar("Visuals", "Local Models", "Local Chams")[2], ServerBoneMatrix[1])
					util.SetMatrixTranslation( ServerBoneMatrix[1], old_translation )
				else
					ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Local Models", "Local Material"), Menu.Func.GetVar("Visuals", "Local Models", "Local Chams")[2])
				end

				if IsValid( ActiveWeapon ) then
					ApplyChamMat(ActiveWeapon, Menu.Func.GetVar("Visuals", "Local Models", "Local Material"), Menu.Func.GetVar("Visuals", "Local Models", "Attachment Chams"))
					
				end


			end
		end

		local pid = R.Player.UserID( ent )
		if !IsValid( ent ) or !R.Player.Alive( ent ) or R.Entity.IsDormant( ent ) or ent == nil or !ShouldDrawPlayer( ent ) then continue end 

		local drawTick = currentTick - TIME_TO_TICKS(1 - CFunc.GetLatency( 0 )) + 2

		if Menu.Func.GetVar( "Visuals", "Chams", "Backtrack Chams" )[1] and TickCopies[pid] and TickCopies[pid][drawTick] and
			TickCopies[pid][drawTick].usable and TickCopies[pid][currentTick] and !R.Player.InVehicle( ent ) then

			local startPos = R.Entity.GetPos( ent )
			if TickCopies[pid][drawTick].origin == startPos then continue end

			--[[

			local btCol = Menu.Func.GetVar( "Visuals", "Chams", "Backtrack Chams", "Chams Color" )
			render.SetColorModulation(btCol.r / 255, btCol.g / 255, btCol.b / 255, 255)
			render.SetBlend( btCol.a / 255 )

			R.Entity.SetPos( ent, TickCopies[pid][drawTick].origin )
			R.Entity.SetupBones( ent )
			util.SetBoneMatrix( ent, TickCopies[pid][drawTick].BoneMatrix )
			R.Entity.DrawModel( ent )

			R.Entity.SetPos( ent, startPos )
			util.SetBoneMatrix( ent, TickCopies[pid][currentTick].BoneMatrix )
			R.Entity.SetupBones( ent )
			R.Entity.InvalidateBoneCache( ent )
			]]

			
			ApplyChamMat(ent, Menu.Func.GetVar("Visuals", "Chams", "Backtrack Material"), Menu.Func.GetVar( "Visuals", "Chams", "Backtrack Chams" )[2], TickCopies[pid][drawTick].BoneMatrix, true )
		end
	end

	if Menu.Func.GetVar("Visuals", "Chams", "Target Chams")[1] then

		local col = Menu.Func.GetVar( "Visuals", "Chams", "Target Chams")[2]

		local decaytime = Menu.Func.GetVar( "Visuals", "Chams", "Time" )

		for ind, target in pairs(AimbotShotTargets) do
			if !IsValid(target.player) or target.player == nil then continue end 
			local modalpha = 1

			if target.time + decaytime - 1 < SysTime() then
				modalpha = 1 * (1 - (SysTime() - (target.time + decaytime - 1)))
			end

			if target.time + decaytime < SysTime() then
				table.remove(AimbotShotTargets, ind)
				continue
			end 


			ApplyChamMat(target.player, Menu.Func.GetVar("Visuals", "Chams", "Target Material"), Color(col.r, col.g, col.b, col.a * modalpha), target.tick.BoneMatrix, true )
		end
	end


	if Menu.Func.GetVar("Visuals", "Misc", "Bullet Tracers")[1] then
		local beamclr = Menu.Func.GetVar("Visuals", "Misc", "Bullet Tracers")[2]
		local decaytime = Menu.Func.GetVar( "Visuals", "Misc", "Bullet Tracer Time" )


		if Menu.Func.GetVar("Visuals", "Misc", "Bullet Tracer Style") == "Line" then
			cam.Start3D()
				for ind, trace in ipairs(bulletTracers) do
					if trace.time + decaytime - 1 < SysTime() then
						trace.modalpha = 1 * (1 - (SysTime() - (trace.time + decaytime - 1)))
					end
					if trace.time + decaytime < SysTime() then
						table.remove(bulletTracers, ind)
						continue
					end 

					render.DrawLine( trace.start, trace.endp, Color(beamclr.r, beamclr.g, beamclr.b, beamclr.a * trace.modalpha ), false )
				end
			cam.End()

		else

			for ind, trace in ipairs(bulletTracers) do
				if trace.time + decaytime - 1 < SysTime() then
					trace.modalpha = 1 * (1 - (SysTime() - (trace.time + decaytime - 1)))
				end
				if trace.time + decaytime < SysTime() then
					table.remove(bulletTracers, ind)
					continue
				end 

				render.SetColorModulation(beamclr.r / 255, beamclr.g /255, beamclr.b / 255)
				render.SetBlend( (beamclr.a * trace.modalpha) / 255 )
				render.SetMaterial( BulletTracerMat )
				render.DrawBeam( trace.start, trace.endp, 1, 1, 1, beamclr ) 
			end

			

		end
		
	end
	-- __G.render.DrawTextureToScreen( rt )
	-- cam.IgnoreZ( false )
	render.ResetModelLighting( 1, 1, 1 )
	render.SuppressEngineLighting(false)
	render.MaterialOverride()
	render.SetColorModulation(1, 1, 1)
	render.SetBlend( 1 )
end





-- Lib.Hook.Add( "CalcViewModelView", "ĕÒCØ☇!Ǭ😉😝©Ǖ#😡🙀ƺ0☊ƿê⚉ŪŕĘdasdaddasdasdsasdadĭ⚆Ç", function(hands, weapon, oldpos, oldang, pos, ang)
-- 	if LocalViewModel != nil then
-- 		LocalViewModel.pos = pos
-- 	end 
-- end)

-- Lib.Hook.Add( "PostDrawViewModel", "ĕÒCØ☇!Ǭ😉😝©Ǖ#😡🙀ƺ0☊ƿê⚉ŪŕĘdasdadsasdadĭ⚆Ç", function(hands, ply, weapon)
-- 	--if not Menu.Func.GetVar("Visuals", "View Model", "Hand Chams")[1] or not Menu.Func.GetVar("Visuals", "View Model", "Weapon Chams")[1] then LocalViewModel = nil return end
-- 	--if hideOverlay then return end

-- 	if ply == LocalPlayer() then
-- 		if R.Player.Alive( LocalPlayer() ) and not do_thirdperson then
			
-- 			LocalViewModel = 
-- 			{
-- 				hands = {
-- 					model = hands, 
-- 					matrix = util.GetBoneMatrix(hands)
-- 				},
-- 				wep = {
-- 					wep = weapon,
-- 					matrix = util.GetBoneMatrix(weapon)
-- 				},
-- 				oldpos = nil
-- 			}
-- 			--print(hands)
-- 		else
-- 			LocalViewModel = nil
-- 		end
-- 	end

-- end)

Lib.Hook.Add( "RenderScreenspaceEffects", "ĕÒCØ☇!Ǭ😉😝©Ǖ#😡🙀ƺ0☊ƿê⚉ŪŕĘĭ⚆Ç", Chams )