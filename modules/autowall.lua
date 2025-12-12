M9K_PenetrationValues = {
	["SniperPenetratedRound"] = 20,
	["pistol"] = 9,
	["357"] = 12,
	["smg1"] = 14,
	["ar2"] = 16,
	["buckshot"] = 5,
	["slam"] = 5,
	["AirboatGun"] = 17
}

M9K_PenetrateMaterials = {
	[MAT_GLASS] = true,
	[MAT_PLASTIC] = true,
	[MAT_WOOD] = true,
	[MAT_FLESH] = true,
	[MAT_ALIENFLESH] = true
}

FAS_PenMod = {
	[MAT_SAND] = 0.5,
	[MAT_DIRT] = 0.8,
	[MAT_METAL] = 1.1,
	[MAT_TILE] = 0.9,
	[MAT_WOOD] = 1.2
}

local MAX_PENETRATION_DISTANCE = 90
local CHAR_TEX_CARDBOARD = -1

local SWITCH_BulletTypeParameters = {
	["BULLET_PLAYER_50AE"] = {
		fPenetrationPower = 30,
		flPenetrationDistance = 1000,
	},
	["BULLET_PLAYER_762MM"] = {
		fPenetrationPower = 39,
		flPenetrationDistance = 5000,
	},
	["BULLET_PLAYER_556MM"] = {
		fPenetrationPower = 35,
		flPenetrationDistance = 4000,
	},
	["BULLET_PLAYER_338MAG"] = {
		fPenetrationPower = 45,
		flPenetrationDistance = 8000,
	},
	["BULLET_PLAYER_9MM"] = {
		fPenetrationPower = 21,
		flPenetrationDistance = 800,
	},
	["BULLET_PLAYER_BUCKSHOT"] = {
		fPenetrationPower = 0,
		flPenetrationDistance = 0,
	},
	["BULLET_PLAYER_45ACP"] = {
		fPenetrationPower = 15,
		flPenetrationDistance = 500,
	},
	["BULLET_PLAYER_357SIG"] = {
		fPenetrationPower = 25,
		flPenetrationDistance = 800,
	},
	["BULLET_PLAYER_57MM"] = {
		fPenetrationPower = 30,
		flPenetrationDistance = 2000,
	},
	["AMMO_TYPE_TASERCHARGE"] = {
		fPenetrationPower = 0,
		flPenetrationDistance = 0,
	},
}

SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM_SMALL"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM_BOX"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG_SMALL"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG_P250"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG_MIN"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG"]

local DEFAULT_PENETRATE = {
	penetrationmodifier = 1.0,
	damagemodifier = 0.5,
}

local CS_MASK_SHOOT = bit.bor(MASK_SHOT, CONTENTS_DEBRIS)

local function CW2_CanPenetrate( trace, dir, wep )
	local dot
	local ent = trace.Entity

	if trace.MatType != MAT_SLOSH then
		dot = -R.Vector.Dot( dir, trace.HitNormal )

		if (wep.CanPenetrate or wep.PenetrationEnabled) and !R.Entity.IsNPC( ent ) and !R.Entity.IsPlayer( ent ) and dot > 0.26 then
			return true, dot
		end
	end

	return false, dot
end

local pen_types = {}
local function new(new, base, penmod, dmgmod)
	new = string.lower(new)
	if base then base = string.lower(base) end

	pen_types[new] = pen_types[base] or table.Copy(DEFAULT_PENETRATE)

	if penmod then pen_types[new].penetrationmodifier = penmod end
	if dmgmod then pen_types[new].damagemodifier = dmgmod end
end

new("default")
new("default_silent")
new("rock")
new("solidmetal", nil, 0.3, 0.27)
new("metal", "solidmetal", 0.4)
new("dirt", nil, 0.3, 0.6) new("grass", "dirt")
new("plaster", "dirt", 0.6, 0.7)
new("concrete", nil, 0.25, 0.5)
new("flesh", nil, 0.9)
new("alienflesh", "flesh")
new("plastic_barrel", nil, 0.7)
new("glass", nil, 0.99)
new("metalpanel", "metal", 0.45, 0.5)
new("Plastic_Box", nil, 0.75)
new("plastic", "Plastic_Box")
new("Wood", nil, 0.6, 0.9)
new("combine_metal", "metal")
new("wood_crate", "wood", 0.9)
new("porcelain", "rock", 0.95)
new("brick", "rock", 0.47)
new("metal_box", "solidmetal", 0.5)
new("metalvent", "metal_box", 0.6, 0.45)
new("sand", "dirt", 0.3, 0.25)

local function HandleBulletPenetration(wep,
				ent,
				flPenetration,
				iEnterMaterial,
				bHitGrate,
				tr,
				vecDir,
				flPenetrationModifier,
				flDamageModifier,
				iDamageType,
				flPenetrationPower,
				nPenetrationCount,
				vecSrc,
				flDistance,
				flCurrentDistance,
				fCurrentDamage)

	local bIsNodraw = bit.band(tr.SurfaceFlags, SURF_NODRAW) != 0
	local bFailedPenetrate = false

	-- check if bullet can penetrarte another entity
	if nPenetrationCount == 0 and !bHitGrate and !bIsNodraw
		and iEnterMaterial != MAT_GLASS and iEnterMaterial != MAT_GRATE then
		bFailedPenetrate = true -- no, stop
	end

	-- If we hit a grate with iPenetration == 0, stop on the next thing we hit
	if flPenetration <= 0 or nPenetrationCount <= 0 then
		bFailedPenetrate = true
	end

	local penetrationEnd = Vector()

	-- find exact penetration exit
	local exitTr = {}
	if wep:TraceToExit(tr.HitPos, vecDir, penetrationEnd, tr, exitTr, 4, MAX_PENETRATION_DISTANCE) then
		-- ended in solid
		if bit.band(util.PointContents(tr.HitPos), CS_MASK_SHOOT) == 0 then
			bFailedPenetrate = true
		end
	end

	if !exitTr.SurfaceProps then -- or !exitTr.SurfaceProps 
		-- local flTraceDistance = (penetrationEnd - tr.HitPos):Length()

		-- -- this is copy pasted from below, it should probably be its own function
		-- local flPenMod = math.max(0, 1 / flPenetrationModifier)
		-- local flPercentDamageChunk = fCurrentDamage * 0.15
		-- local flDamageLostImpact = flPercentDamageChunk + math.max(0, ( 3 / flPenetrationPower) * 1.18) * (flPenMod * 2.8)

		-- local flLostDamageObject = ( ( flPenMod * (flTraceDistance * flTraceDistance) ) / 24)
		-- local flTotalLostDamage = flDamageLostImpact + flLostDamageObject

		return true, nPenetrationCount, flPenetration, fCurrentDamage
	end

	if exitTr.Entity == ent then return nil, nPenetrationCount, flPenetration, fCurrentDamage end

	local exitSurfaceData = util.GetSurfaceData(exitTr.SurfaceProps)

	if !exitSurfaceData then return false end

	local iExitMaterial = exitSurfaceData.material

	-- new penetration method
	if true then
		-- percent of total damage lost automatically on impacting a surface
		local flDamLostPercent = 0.16

		-- since some railings in de_inferno are CONTENTS_GRATE but CHAR_TEX_CONCRETE, we'll trust the
		-- CONTENTS_GRATE and use a high damage modifier.
		if bHitGrate or bIsNodraw or iEnterMaterial == MAT_GLASS or iEnterMaterial == MAT_GRATE then
			-- If we're a concrete grate (TOOLS/TOOLSINVISIBLE texture) allow more penetrating power.
			if iEnterMaterial == MAT_GRATE or iEnterMaterial == MAT_GRATE then
				flPenetrationModifier = 3
				flDamLostPercent = 0.05
			else
				flPenetrationModifier = 1
			end

			flDamageModifier = 0.99
		else
			-- check the exit material and average the exit and entrace values
			local pen_mat = pen_types[string.lower(util.GetSurfacePropName(exitTr.SurfaceProps))]
			if !pen_mat then
				pen_mat = DEFAULT_PENETRATE
			end

			local flExitPenetrationModifier = pen_mat.penetrationmodifier
			local flExitDamageModifier = pen_mat.damagemodifier
			flPenetrationModifier = (flPenetrationModifier + flExitPenetrationModifier) / 2
			flDamageModifier = (flDamageModifier + flExitDamageModifier) / 2
		end

		-- if enter & exit point is wood we assume this is 
		-- a hollow crate and give a penetration bonus
		if iEnterMaterial == iExitMaterial then
			if iExitMaterial == MAT_WOOD or iExitMaterial == CHAR_TEX_CARDBOARD then
				flPenetrationModifier = 3
			elseif iExitMaterial == MAT_PLASTIC then
				flPenetrationModifier = 2
			end
		end

		local flTraceDistance = R.Vector.Length(exitTr.HitPos - tr.HitPos)
		local flPenMod = math.max(0, 1 / flPenetrationModifier)

		local flPercentDamageChunk = fCurrentDamage * flDamLostPercent
		local flPenWepMod = flPercentDamageChunk + math.max(0, (3 / flPenetrationPower) * 1.25) * (flPenMod * 3)

		local flLostDamageObject = ((flPenMod * (flTraceDistance * flTraceDistance)) / 24)
		local flTotalLostDamage = flPenWepMod + flLostDamageObject

		-- reduce damage each time we hit something other than a grate
		fCurrentDamage = fCurrentDamage - math.max(0, flTotalLostDamage)
		if fCurrentDamage < 1 then
			return true, nPenetrationCount, flPenetration, fCurrentDamage
		end

		-- penetration was successful

		-- setup new start end parameters for successive trace
		flCurrentDistance = flCurrentDistance + flTraceDistance
		R.Vector.Set( vecSrc, exitTr.HitPos )
		flDistance = (flDistance - flCurrentDistance) * 0.5

		nPenetrationCount = nPenetrationCount - 1
		return false, nPenetrationCount, flPenetration, fCurrentDamage
	end

	return true, nPenetrationCount, flPenetration, fCurrentDamage
end


local tfa_maxpen = nil
local tfa_penetrate = nil

function Aimbot.AutoWall( traceResult, startPos, aimPos, ent, wep, lagComp )
	if !IsValid(wep) then
		return false
	end

	if wep.Base == "weapon_swcs_base" then
		if lagComp then return false end
		local iDamage = wep:GetDamage()
		local vecDirShooting = R.Angle.Forward( R.Vector.Angle( aimPos - startPos ))

		local fCurrentDamage = iDamage
		local flCurrentDistance = 0

		local nPenetrationCount = math.min( 4, Menu.Func.GetVar("Aimbot", "Rage Settings", "Max Walls"))
		local flPenetration = wep:GetPenetration()
		local flPenetrationPower = 0		-- thickness of a wall that this bullet can penetrate
		local flPenetrationDistance = 0		-- distance at which the bullet is capable of penetrating a wall
		local flDamageModifier = 0.5		-- default modification of bullets power after they go through a wall.
		local flPenetrationModifier = 1.0

		local params = SWITCH_BulletTypeParameters[wep.ItemVisuals.primary_ammo]
		if true then
			fPenetrationPower = 35
			flPenetrationDistance = 3000
		elseif params then
			flPenetrationPower = params.fPenetrationPower
			flPenetrationDistance = params.flPenetrationDistance
		end

		-- if sv_penetration_type:GetInt() == 1 then
			flPenetrationPower = wep:GetPenetration()
		-- end

		local lastPlayerHit = NULL -- includes players, bots, and npcs

		local flDist_aim = 0

		local flDistance = wep:GetRange()
		local vecSrc = R.Player.GetShootPos( LocalPlayer() )

		while fCurrentDamage > 0 do
			local vecEnd = vecSrc + vecDirShooting * (flDistance - flCurrentDistance)
			local tr = {} -- main enter bullet trace

			util.TraceLine({
				start = vecSrc,
				endpos = vecEnd,
				mask = bit.bor(CS_MASK_SHOOT, CONTENTS_HITBOX),
				filter = {owner, lastPlayerHit},
				collisiongroup = COLLISION_GROUP_NONE,
				output = tr
			})

			if flDist_aim == 0 then
				flDist_aim = (tr.Fraction != 1) and R.Vector.Length(tr.StartPos - tr.HitPos) or 0
			end

			lastPlayerHit = tr.Entity

			-- we didn't hit anything, stop tracing shoot
			if tr.Fraction == 1 then break end

			if !util.GetSurfaceData(tr.SurfaceProps) then return end

			local pen_mat = pen_types[string.lower(util.GetSurfaceData(tr.SurfaceProps).name)]
			if !pen_mat then
				pen_mat = DEFAULT_PENETRATE
			end

			local iEnterMaterial = util.GetSurfaceData(tr.SurfaceProps).material

			flPenetrationModifier = pen_mat.penetrationmodifier
			flDamageModifier = pen_mat.damagemodifier

			-- local bHitGrate = bit.band(tr.Contents, CONTENTS_GRATE) ~= 0

			flCurrentDistance = flCurrentDistance + (tr.Fraction * (flDistance - flCurrentDistance))
			fCurrentDamage = fCurrentDamage * math.pow(wep:GetRangeModifier(), flCurrentDistance / 500)

			-- if bFirstHit then
			-- 	dmg:SetDamage(fCurrentDamage)
			-- end
			bFirstHit = false

			-- check if we reach penetration distance, no more penetrations after that
			-- or if our modifier is super low, just stop the bullet
			if (flCurrentDistance > flPenetrationDistance and flPenetration > 0) or
				flPenetrationModifier < 0.1 then
				nPenetrationCount = 0
			end

			local iDamageType = bit.bor(DMG_BULLET, DMG_NEVERGIB)
			-- if wep is taser, DMG_SHOCK | DMG_NEVERGIB
			-- dmg:SetDamageType(iDamageType)

			local bulletStopped
			bulletStopped, nPenetrationCount, flPenetration, fCurrentDamage = HandleBulletPenetration( wep, ent, flPenetration, iEnterMaterial, hitGrate, tr, vecDirShooting, flPenetrationModifier,
				flDamageModifier, iDamageType, flPenetrationPower, nPenetrationCount, vecSrc, flDistance,
				flCurrentDistance, fCurrentDamage )

			if nPenetrationCount == nil then return end

			if bulletStopped == nil then return true end
			if bulletStopped then break end
		end

		return false
	elseif wep.OrigCrossHair then -- M9K AUTOWALL
		if lagComp then return false end

		local traces, results = {}, {}

		local maxWalls = Menu.Func.GetVar("Aimbot", "Rage Settings", "Max Walls")

		for i = 1, maxWalls do
			local maxPen = M9K_PenetrationValues[wep.Primary.Ammo] or 14

			if !results[1] then
				traces[1] = { start = startPos, filter = LocalPlayer(), mask = MASK_SHOT, endpos = aimPos }
				results[1] = util.TraceLine( traces[1] ) -- TODO: Recycle this trace from the calling function
			end

			local penDir = results[1].Normal * ( M9K_PenetrateMaterials[results[1].MatType] and maxPen * 2 or maxPen )
			traces[2] = { endpos = aimPos, start = results[1].HitPos + penDir, mask = MASK_SHOT, filter = LocalPlayer() }

			results[2] = util.TraceLine( traces[2] )

			results[1] = results[2]

			if results[2].StartSolid then
				return false
			elseif ( results[2].Entity == ent or results[2].Fraction == 1 ) then
				return true
			end
		end

		return results[2].Entity == ent
	elseif wep.Base == "cw_base" or wep.Base == "fas2_base" then -- WORKS NEARLY PERFECTLY
		local dir = R.Angle.Forward( R.Vector.Angle( aimPos - startPos ))
		local tr = {
			start = startPos,
			filter = LocalPlayer(),
			mask = 1577075107, -- NORMAL TRACE MASK
		}

		if lagComp then return false end

		tr.endpos = tr.start + dir * (wep.PenetrativeRange or 16384) -- FA:S 2 HAS A CONSTANT VALUE

		local result = util.TraceLine( tr )

		if !result.Hit and result.Entity == ent then return true end

		if result.Hit and !result.HitSky and CW2_CanPenetrate( result, dir, wep ) then
			tr.start = result.HitPos
			if !wep.PenetrationMaterialInteraction then -- FA:S 2
				tr.endpos = tr.start + dir * wep.PenStr * (FAS_PenMod[result.MatType] and FAS_PenMod[result.MatType] or 1) * wep.PenMod
			else -- CW 2.0
				tr.endpos = tr.start + dir * wep.PenStr * (wep.PenetrationMaterialInteraction[result.MatType] and wep.PenetrationMaterialInteraction[result.MatType] or 1) * wep.PenMod
			end

			tr.mask = 1107296512 -- WallTraceMask

			result = util.TraceLine( tr )

			tr.start = result.HitPos
			tr.endpos = tr.start + dir * 0.1
			tr.mask = 1577075107

			result = util.TraceLine(tr) -- run ANOTHER trace to check whether we've penetrated a surface or not

			if result.Entity == ent then return true end

			if !result.Hit then
				tr.start = result.HitPos
				tr.endpos = aimPos
				tr.mask = MASK_SHOT

				result = util.TraceLine(tr)

				if result.Entity == ent or result.HitPos == aimPos then return true end
			end
		end
	elseif wep.IsTFAWeapon --[[and __G.TFA_BASE_VERSION and __G.TFA_BASE_VERSION < 4.58]] then -- todo: calculate cone so it doesn't keep shooting at random shit
		if !tfa_maxpen then tfa_maxpen = GetConVar_Internal( "sv_tfa_penetration_limit" ) or GetConVar_Internal( "sv_tfa_penetration_hardlimit" ) end
		if !tfa_penetrate then tfa_penetrate = GetConVar_Internal( "sv_tfa_bullet_penetration" ) end

		if !tfa_maxpen or !tfa_penetrate then return false end

		if lagComp then return false end

		if !R.ConVar.GetBool( tfa_penetrate ) then return false end
		local maxpen = math.min(R.ConVar.GetInt(tfa_maxpen), wep.Primary.MaxPenetration, Menu.Func.GetVar("Aimbot", "Rage Settings", "Max Walls"))
		local currentPen = 0

		while ( currentPen < maxpen ) do
			local tr = {
				start = startPos,
				endpos = aimPos,
				filter = LocalPlayer(),
				mask = MASK_SHOT
			}

			local result = util.TraceLine( tr )

			local dir = R.Vector.Angle( aimPos - startPos )
			local force = wep:GetStat("Primary.Damage") / 10 * wep:GetAmmoForceMultiplier()
			local penetrationOffset = R.Angle.Forward( dir ) * math.Clamp( force * wep:GetPenetrationMultiplier(result.MatType), 0, 32 )

			tr.endpos = result.HitPos
			tr.start = result.HitPos + penetrationOffset
			result = util.TraceLine( tr )

			if result.StartSolid then return false end

			tr.start = result.HitPos
			tr.endpos = aimPos
			result = util.TraceLine( tr )

			startPos = result.HitPos

			currentPen = currentPen + 1

			if result.Fraction == 1 or result.Entity == ent then return true end
		end
	end
end
