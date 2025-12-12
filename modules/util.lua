
function util.PredictFriction( velocity )
	local sv_friction = R.ConVar.GetFloat( GetConVar_Internal( "sv_friction" ))
	local sv_stopspeed = R.ConVar.GetFloat( GetConVar_Internal( "sv_stopspeed" ))
	local speed = R.Vector.Length(velocity)
	if speed >= 0.1 then
		local stop_speed = math.max( speed, sv_stopspeed )
		local time = math.max( engine.TickInterval(), FrameTime() )
		velocity = velocity * math.max( 0, speed - sv_friction * stop_speed * time / speed )
	end

	return velocity
end

function util.VectorAngles( forward, angles )
	if forward[2] == 0 and forward[1] == 0 then
		angles[1] = (forward[3] > 0) and 270 or 90
		angles[2] = 0.0
	else
		angles[1] = math.atan2(-forward[3], R.Vector.Length2D(forward)) * -180 / math.pi
		angles[2] = math.atan2(forward[2], forward[1]) * 180 / math.pi

		if (angles[2] > 90) then
			angles[2] = angles[2] - 180
		elseif (angles[2] < 90) then
			angles[2] = angles[2] + 180
		elseif (angles[1] == 90) then
			angles[2] = 0
		end
	end

	angles[3] = 0

	return angles
end

function util.getDistance(pos1, pos2)
    local dx = pos1.x - pos2.x
	local dy = pos1.y - pos2.y
	return math.sqrt ( dx * dx + dy * dy )
end

-- local colorRange = {
-- 	[1] = {start = 0, color = Color( 255, 0, 0 )},
-- 	[2] = {start = 50, color = Color( 255, 255 / 2, 0 )},
-- 	[3] = {start = 100, color = Color( 0, 255, 0 )}
-- }

function util.ColorLerp( value, ranges )
	if #ranges < 1 then return Color( 255, 255, 255, 255 ) end
	if value <= ranges[1].start then return ranges[1].color end
	if value >= ranges[#ranges].start then return ranges[#ranges].color end

	local newColor = Color(0,0,0)

	local selected = #ranges
	for i = 1, #ranges - 1 do
		if value < ranges[i + 1].start then
			selected = i
			break
		end
	end

	local minColor = ranges[selected]
	local maxColor = ranges[selected + 1]

	local lerpValue = (value - minColor.start) / (maxColor.start - minColor.start)

	newColor.r = Lerp( lerpValue, minColor.color.r, maxColor.color.r )
	newColor.g = Lerp( lerpValue, minColor.color.g, maxColor.color.g )
	newColor.b = Lerp( lerpValue, minColor.color.b, maxColor.color.b )
	newColor.a = Lerp( lerpValue, minColor.color.a or 255, maxColor.color.a or 255 )

	return newColor
end

function util.ColorLerpHSV( value, ranges )
    if #ranges < 1 then return Color( 255, 255, 255, 255 ) end
    if value <= ranges[1].start then return ranges[1].color end
    if value >= ranges[#ranges].start then return ranges[#ranges].color end

    

    local selected = #ranges
    for i = 1, #ranges - 1 do
        if value < ranges[i + 1].start then
            selected = i
            break
        end
    end

    local minColor = ranges[selected]
    local maxColor = ranges[selected + 1]

    local lerpValue = (value - minColor.start) / (maxColor.start - minColor.start)

    local minH, minS, minV = ColorToHSV(minColor.color)
    local maxH, maxS, maxV = ColorToHSV(maxColor.color)
    local newHue = Lerp( lerpValue, minH, maxH )
    local newSat = Lerp( lerpValue, minS, maxS )
    local newVal = Lerp( lerpValue, minV, maxV )

    local newColor  = HSVToColor(newHue, newSat, newVal)

    newColor.a = Lerp( lerpValue, minColor.color.a or 255, maxColor.color.a or 255 )

    return newColor
end

function util.Ease(t)
	return -math.cos(t * (math.pi * .5)) + 1 
end

function util.EaseVal(t, from, to)
	return (to - from) * util.Ease(t)
end

function util.ReversedEaseVal(t, from, to)
	return util.EaseVal( math.abs(t - 1), to, from)
end


local allteams
function util.TeamColor() return Color(255,105,180) end
function util.TeamName(n) return "Team "..n end

function util.HighlightColor( col, max, opacity )
	return max * (col.r > 127.5 and 255 / col.r or 0), max * (col.g > 127.5 and 255 / col.g or 0), max * (col.b > 127.5 and 255 / col.b or 0), opacity
end

function util.AngleVectors( angles, forward )
	local sp, sy, cp, cy
	local yawRadians = math.rad( angles.y )
	local pitchRadians = math.rad( angles.p )

	sy, cy = math.sin( yawRadians ), math.cos( yawRadians )
	sp, cp = math.sin( pitchRadians ), math.cos( pitchRadians )

	forward.x = cp * cy
	forward.y = cp * sy
	forward.z = -sp

	return forward
end

function util.TableContains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function util.TableRemoveByValue( tbl, val )

	local key = table.KeyFromValue( tbl, val )
	if ( !key ) then return false end

	if ( isnumber( key ) ) then
		table.remove( tbl, key )
	else
		tbl[ key ] = nil
	end

	return key

end

function util.GetHighLightColor( v, highlight)

	if highlight == nil then
		if R.Player.GetFriendStatus( v ) == "friend" then
			return Menu.Func.GetVar("Visuals", "ESP Filtering", "Highlight Friends")[2], "Friend"
		elseif PossibleAdmins[R.Player.UserID(v)] ~= nil then
			return Menu.Func.GetVar("Visuals", "ESP Filtering", "Highlight Admins")[2], "Admin"
		end
	elseif Menu.Func.GetVar( "Visuals", "ESP Filtering", "Visual Overrides", highlight ) and Menu.Func.GetVar("Visuals", "ESP Filtering", "ESP Highlight") then 
	
		if Menu.Func.GetVar("Visuals", "ESP Filtering", "Highlight Friends")[1] and R.Player.GetFriendStatus( v ) == "friend" then
			return Menu.Func.GetVar("Visuals", "ESP Filtering", "Highlight Friends")[2], "Friend"
		elseif Menu.Func.GetVar("Visuals", "ESP Filtering", "Highlight Admins")[1] and PossibleAdmins[R.Player.UserID(v)] ~= nil then
			return Menu.Func.GetVar("Visuals", "ESP Filtering", "Highlight Admins")[2], "Admin"
		end
	end

	return nil
end

function util.GetPlayerTrace( ply, dir )
	dir = dir or R.Player.GetAimVector( ply )

	local trace = {}

	trace.start = R.Entity.EyePos( ply )
	trace.endpos = trace.start + ( dir * ( 4096 * 8 ) )
	trace.filter = ply

	return trace
end

local tmin, tmax, tymin, tymax, tzmin, tzmax
function util.IntersectRayWithAABB(origin, dir, min, max)
	if (dir.x >= 0) then
		tmin = (min.x - origin.x) / dir.x
		tmax = (max.x - origin.x) / dir.x
	else
		tmin = (max.x - origin.x) / dir.x
		tmax = (min.x - origin.x) / dir.x
	end

	if (dir.y >= 0) then
		tymin = (min.y - origin.y) / dir.y
		tymax = (max.y - origin.y) / dir.y
	else
		tymin = (max.y - origin.y) / dir.y
		tymax = (min.y - origin.y) / dir.y
	end

	if (tmin > tymax or tymin > tmax) then
		return false
	end

	if (tymin > tmin) then
		tmin = tymin
	end

	if (tymax < tmax) then
		tmax = tymax
	end

	if (dir.z >= 0) then
		tzmin = (min.z - origin.z) / dir.z
		tzmax = (max.z - origin.z) / dir.z
	else
		tzmin = (max.z - origin.z) / dir.z
		tzmax = (min.z - origin.z) / dir.z
	end

	if (tmin > tzmax or tzmin > tmax) then
		return false
	end

	if (tmin < 0 or tmax < 0) then
		return false
	end

	return true
end

function util.VectorCopy( copyFrom, copyTo )
	copyTo[1] = copyFrom[1]
	copyTo[2] = copyFrom[2]
	copyTo[3] = copyFrom[3]
end

local angZero = Angle( 0, 0, 0 )
function util.GetBonePosition( ent, bone, hitboxCenter )
	hitboxCenter = hitboxCenter or Vector()
	local boneMatrix = R.Entity.GetBoneMatrix( ent, bone )

	if !boneMatrix then return end

	local pos, ang = R.VMatrix.GetTranslation( boneMatrix ), R.VMatrix.GetAngles( boneMatrix )

	return LocalToWorld(hitboxCenter, angZero, pos, ang), ang
end

local temp, j
function util.Shuffle( tab )
	for i = #tab, 1, -1 do
		j = math.floor( math.Rand(1, i) + 0.5)
		temp = tab[j]
		tab[j] = tab[i]
		tab[i] = temp
	end
end


local Entity_SetBoneMatrix = R.Entity.SetBoneMatrix
local Entity_BoneHasFlag = R.Entity.BoneHasFlag
local Entity_GetBoneCount = R.Entity.GetBoneCount
local Entity_GetBoneMatrix = R.Entity.GetBoneMatrix

function util.GetBoneMatrix( ent )
	local BoneMatrix = {}
	for i = 0, Entity_GetBoneCount( ent ) - 1 do
		BoneMatrix[i] = Entity_GetBoneMatrix( ent, i )
	end

	return BoneMatrix
end

function util.SetBoneMatrix( ent, BoneMatrix )
	for i = 0, Entity_GetBoneCount( ent ) - 1 do
		if BoneMatrix[i] and Entity_BoneHasFlag( ent, i, CFunc.GetWritableBones( ent, i )) then
			Entity_SetBoneMatrix( ent, i, BoneMatrix[i] )
		end
	end
end

function util.GetMatrixTranslation( BoneMatrix )

	local BoneMatrixTranslation = {}
	for i = 0, #BoneMatrix do
		if BoneMatrix[i] != nil then
			BoneMatrixTranslation[i] = R.VMatrix.GetTranslation(BoneMatrix[i])
		end	
	end
	return BoneMatrixTranslation
end


function util.SetMatrixTranslation( BoneMatrix, Translation )
	for i = 0, #BoneMatrix do
		if Translation[i] != nil then
			R.VMatrix.SetTranslation( BoneMatrix[i], Translation[i] )
		end
	end
end

function util.VectDiff(vec1, vec2)
	return Vector(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z)
end

function util.VectAdd(vec1, vec2)
	return Vector(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z)
end

function util.OffSetMatrixPosition(BoneMatrix, Offset)
	local Translation = util.GetMatrixTranslation( BoneMatrix )
	for i = 0, #BoneMatrix do
		if Translation[i] != nil then
			R.VMatrix.SetTranslation( BoneMatrix[i], util.VectDiff(Translation[i], Offset) )
		end
	end
end

function util.GetEntField(ent, name, default)


	local Val = R.Entity.GetTable(ent)[ name ]
	if ( Val == nil ) then return default end

	return Val

end

function util.TableGetKeys(tab)
	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end

	return keys

end

function util.PrintTable( t, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = util.TableGetKeys( t )
	
	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		Msg( string.rep( "\t", indent ) )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			Msg( key, ":\n" )
			util.PrintTable ( value, indent + 2, done )
			done[ value ] = nil

		else

			Msg( key, "\t=\t", value, "\n" )

		end

	end

end


function util.Read( address, bytes )
	bytes = bytes or 1
	local readBytes = {}

	for b = 1, bytes do
		readBytes[b] = CFunc.ReadByte( address + bytes - b )
	end

	return tonumber( string.format( "0x" .. string.rep("%x", bytes), unpack( readBytes ) ))
end

function util.ReadString( address, maxbytes )
	local readString = {}

	for i = 1, maxbytes do
		readString[i] = CFunc.ReadByte( address + i - 1 )

		if readString[i] == 0x00 then -- null byte, terminate string
			readString[i] = nil
			break
		end
	end

	return string.char( unpack( readString ))
end

function util.Table_reverse(tbl)
	local new_tbl = {}
    for i = 1, #tbl do
        new_tbl[#tbl + 1 - i] = tbl[i]
    end
    return new_tbl
end


