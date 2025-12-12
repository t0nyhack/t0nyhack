
local mat_Copy		= Material( "pp/copy" )
local mat_Add		= Material( "pp/add" )
local mat_Sub		= Material( "pp/sub" )
local rt_Store		= render.GetScreenEffectTexture( 0 )
local rt_Blur		= render.GetScreenEffectTexture( 1 )
local RenderTarget = GetRenderTarget("ass", ScrW(), ScrH())

STENCIL_NEVER = STENCILCOMPARISONFUNCTION_NEVER
STENCIL_LESS = STENCILCOMPARISONFUNCTION_LESS
STENCIL_EQUAL = STENCILCOMPARISONFUNCTION_EQUAL
STENCIL_LESSEQUAL = STENCILCOMPARISONFUNCTION_LESSEQUAL
STENCIL_GREATER = STENCILCOMPARISONFUNCTION_GREATER
STENCIL_NOTEQUAL = STENCILCOMPARISONFUNCTION_NOTEQUAL
STENCIL_GREATEREQUAL = STENCILCOMPARISONFUNCTION_GREATEREQUAL
STENCIL_ALWAYS = STENCILCOMPARISONFUNCTION_ALWAYS

STENCIL_KEEP = STENCILOPERATION_KEEP
STENCIL_ZERO = STENCILOPERATION_ZERO
STENCIL_REPLACE = STENCILOPERATION_REPLACE
STENCIL_INCRSAT = STENCILOPERATION_INCRSAT
STENCIL_DECRSAT = STENCILOPERATION_DECRSAT
STENCIL_INVERT = STENCILOPERATION_INVERT
STENCIL_INCR = STENCILOPERATION_INCR
STENCIL_DECR = STENCILOPERATION_DECR

	
local mat_BlurX			= Material( "pp/blurx" )
local mat_BlurY			= Material( "pp/blury" )
local tex_Bloom1		= render.GetBloomTex1()

function render.BlurRenderTarget( rt, sizex, sizey, passes )

	mat_BlurX:SetTexture( "$basetexture", rt )
	mat_BlurY:SetTexture( "$basetexture", tex_Bloom1 )
	mat_BlurX:SetFloat( "$size", sizex )
	mat_BlurY:SetFloat( "$size", sizey )

	for i=1, passes+1 do

		render.SetRenderTarget( tex_Bloom1 )
		render.SetMaterial( mat_BlurX )
		render.DrawScreenQuad()

		render.SetRenderTarget( rt )
		render.SetMaterial( mat_BlurY )
		render.DrawScreenQuad()

	end

end

local solid = CreateMaterial("😦ÊƉ😊ƤǕ.D😸😚Ę]ÞdddȌ🙀ã😧ÌȻ☺😞¢æĜ7" .. SysTime(), "VertexLitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$nocull"] = 0,
	["$model"] = 1,
	["$ignorez"] = 1,
})

Glow = {}

Glow.Entries = {}

function Glow.Add(ent, clr)
	table.insert(Glow.Entries, {ent = ent, clr = clr})
end

function Glow.RenderGlow(blurx, blury, drawpasses)
	if hideOverlay then return end

	local entries = Glow.Entries

	for k, v in ipairs(entries) do
		local opacity = v.clr.a / 255
		v.addativeclr = Color(v.clr.r *opacity, v.clr.g *opacity, v.clr.b *opacity, 255)
	end

	local rt_Scene = render.GetRenderTarget()

	render.CopyRenderTargetToTexture(rt_Store)

	
	render.Clear(0, 0, 0, 255, false, true)
	-- render.Clear(255, 255, 255, 255, false, true) if you dont want it to be addative anymore
	

	cam.Start3D()
		render.SetStencilEnable(true)
		render.SuppressEngineLighting(true)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.SetStencilReferenceValue(1)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)

		for i, ent in ipairs(entries) do
			if IsValid(ent.ent) then

				render.MaterialOverride(solid)
				render.SetBlend( 1 )
				render.ResetModelLighting( 1, 1, 1 )
				render.SetColorModulation(ent.addativeclr.r / 255, ent.addativeclr.g / 255, ent.addativeclr.b / 255, 255)
				if ent.matrix ~= nil then
					local BoneMatrix, AdjustPos = ent.matrix[1], ent.matrix[2]
					if BoneMatrix then
						if AdjustPos then
							local old_translation = util.GetMatrixTranslation( BoneMatrix[1] )
							R.Entity.SetupBones( ent.ent )
							util.OffSetMatrixPosition(BoneMatrix[1], util.VectDiff(BoneMatrix[2], AdjustPos))
							util.SetBoneMatrix( ent.ent, BoneMatrix[1] )
							util.SetMatrixTranslation( BoneMatrix[1], old_translation )
						else
							R.Entity.SetupBones( ent.ent )
							util.SetBoneMatrix( ent.ent , BoneMatrix[1] )
						end
					end
				end

				R.Entity.DrawModel( ent.ent )

				-- if ent.matrix ~= nil then
					
				-- 	R.Entity.SetupBones( ent.ent)
				-- 	R.Entity.InvalidateBoneCache( ent.ent )
				
				-- end
				if ent.fart then
					print(ent.addativeclr.r / 255, ent.addativeclr.g / 255, ent.addativeclr.b / 255)
				end

				--local min, max = ent.ent:GetModelRenderBounds()
			end
		end

		if Menu.Func.GetVar("Visuals", "Misc", "Bullet Tracers")[1] and Menu.Func.GetVar("Visuals", "Misc", "Bullet Tracer Style") == "Line" then
			local beamclr = Menu.Func.GetVar("Visuals", "Misc", "Bullet Tracers")[2]
			for i, trace in ipairs(bulletTracers) do
				render.DrawLine( trace.start, trace.endp, Color(beamclr.r, beamclr.g, beamclr.b, 255 * trace.modalpha ), false )
			end
		end
		

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)

		--[[
		cam.Start( { type = "2D" } )
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(entries[1].addativeclr)
			surface.DrawRect(0, 0, ScrW(), ScrH()/2)
		cam.End2D()
		--]]

		render.ResetModelLighting( 1, 1, 1 )
		render.SuppressEngineLighting(false)
		render.MaterialOverride()
		render.SetColorModulation(1, 1, 1)
		render.SetBlend( 1 )

		

		render.SuppressEngineLighting(false)
		render.SetStencilEnable(false)
	cam.End3D()
	render.CopyRenderTargetToTexture(rt_Blur)
	render.BlurRenderTarget(rt_Blur, blurx, blury, 1)
	render.SetRenderTarget(rt_Scene)

	mat_Copy:SetTexture("$basetexture", rt_Store)

	render.SetMaterial(mat_Copy)
	render.DrawScreenQuad()
	render.SetStencilEnable(true)
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)

	
		mat_Add:SetTexture("$basetexture", rt_Blur)

		render.SetMaterial(mat_Add)


	for i = 0, drawpasses do
		render.DrawScreenQuad()
	end

	render.SetStencilEnable(false)
	render.SetStencilTestMask(0)
	render.SetStencilWriteMask(0)
	render.SetStencilReferenceValue(0)
end

function Glow.doGlow()

	local plyrclr = Menu.Func.GetVar("Visuals", "ESP", "Glow")[2]
	local wepclr = Menu.Func.GetVar("Visuals", "ESP", "Weapon Glow")
	local glowclr = Menu.Func.GetVar("Visuals", "ESP", "Glow Color Base")

	colorRange = {}
	
	table.insert(colorRange, {start = 0, color = Menu.Func.GetVar("Visuals", "ESP", "Low Health")} )
	table.insert(colorRange, {start = 100, color = Menu.Func.GetVar("Visuals", "ESP", "Full Health")})

	Glow.Entries = {}

	local glow_ents = { -- doing them in order cuz i dont want glow to render over other stuff and render in order ig
		[1] = {},
		[2] = {},
	}

	for _, v in ipairs( player.GetAll() ) do
		
		if !IsValid( v ) or v == nil or !R.Player.Alive( v ) then continue end

		if v != LocalPlayer() and Menu.Func.GetVar("Visuals", "ESP", "ESP Enabled") then
			if !Menu.Func.GetVar("Visuals", "ESP", "Glow")[1] then continue end

			if R.Entity.IsDormant( v ) or !ShouldDrawPlayer( v ) then
				continue
			end

			--Outline( v , glowclr == "Color Picker" and plyrclr or glowclr == "Team Color" and util.TeamColor( R.Player.Team( v ) ) or glowclr == "Health Color" and util.ColorLerp(math.Clamp( math.ceil((R.Entity.Health( v )/R.Entity.GetMaxHealth( v )) * 100), 0, 100 ), colorRange))
			local color = glowclr == "Color Picker" and plyrclr or glowclr == "Team Color" and util.TeamColor( R.Player.Team( v ) ) or glowclr == "Health Color" and util.ColorLerp(math.Clamp( math.ceil((R.Entity.Health( v )/R.Entity.GetMaxHealth( v )) * 100), 0, 100 ), colorRange)
			local r_color = util.GetHighLightColor( v, "Glow")
			if r_color ~= nil then
				color = r_color
			end

			table.insert(glow_ents[1], {ent = v, clr = color})

			local ActiveWeapon = R.Player.GetActiveWeapon( v )
			if IsValid(ActiveWeapon) then
				--Outline(ActiveWeapon, wepclr)	
				table.insert(glow_ents[2], {ent = ActiveWeapon, clr = wepclr})
			end

		else
			if do_thirdperson then
				local LocalPos = R.Entity.GetPos( v )
				
				--Local Chams
				if Menu.Func.GetVar("Visuals", "Local Models", "Glow")[1] then

					if !R.Player.InVehicle( LocalPlayer() ) then
						table.insert(glow_ents[1], {ent = v, clr = Menu.Func.GetVar("Visuals", "Local Models", "Glow")[2], matrix = {ServerBoneMatrix, LocalPos} })
					else
						table.insert(glow_ents[1], {ent = v, clr = Menu.Func.GetVar("Visuals", "Local Models", "Glow")[2]})
					end
					local ActiveWeapon = R.Player.GetActiveWeapon( v )
					if IsValid( ActiveWeapon ) then
						table.insert(glow_ents[2], {ent = ActiveWeapon, clr = Menu.Func.GetVar("Visuals", "Local Models", "Attachment Glow")})
					end
				end

				if Menu.Func.GetVar("Visuals", "Local Models", "Fake Lag Glow")[1] and anti_aim.FakeLagEnabled and CFunc.GetChokedPackets() > 0 then

					if ServerBoneMatrix and (ServerBoneMatrix[2] ~= LocalPos) then
						table.insert(glow_ents[1], {ent = v, clr = Menu.Func.GetVar("Visuals", "Local Models", "Fake Lag Glow")[2], matrix = {ServerBoneMatrix, nil}})
					end
				end
				
				
				--Fake Chams
				if Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Glow")[1] and anti_aim.FakeAnglesEnabled then

					if ClientSendBoneMatrix then
						table.insert(glow_ents[1], {ent = v, clr = Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Glow")[2], matrix = {ClientSendBoneMatrix, LocalPos}})
					else
						table.insert(glow_ents[1], {ent = v, clr = Menu.Func.GetVar("Visuals", "Local Models", "Fake Angle Glow")[2], matrix = {ClientBoneMatrix, LocalPos}})
					end

				end
			end
		end
	end

	if Menu.Func.GetVar("Visuals", "Entity ESP", "Enabled") and Menu.Func.GetVar("Visuals", "Entity ESP", "Glow") then
		for i, v in ipairs(EntsToDraw) do

			Glow.Add(v.ent, Menu.Func.GetVar("Visuals", "Entity ESP", "Glow")[2])
		end
	end

	for i, v in ipairs(glow_ents) do
		for k, v1 in ipairs(v) do
			table.insert(Glow.Entries, v1)
		end
	end


	Glow.RenderGlow(1, 1, 2)
end



Lib.Hook.Add( "RenderScreenspaceEffects", "ĕÒCØ☇!Ǭ😉😝©Ǖ#jBDzey8LTptIRjPXLkhaSK8jhnczH87tq49mu5U", Glow.doGlow )


-- hook.Add( "PostDrawEffects", "RenderHalos", function()

-- 	hook.Run( "PreDrawHalos" ) RenderScreenspaceEffects

-- 	if ( #List == 0 ) then return end

-- 	for k, v in ipairs( List ) do
-- 		Render( v )
-- 	end

-- 	List = {}

-- end )


--[[

]]