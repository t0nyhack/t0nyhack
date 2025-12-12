if SERVER or false then return end -- because scripthook is shitttt

local startMemory = collectgarbage( "count" )
local diffMemory
local endMemory
local startTime = SysTime()
local smt = debug.setmetatable
local gmt = debug.getmetatable
local pairs = pairs
local istable = istable

local function table_Copy( t, lookup_table )
	if ( t == nil ) then return nil end
	local copy = {}
	smt( copy, gmt( t ) )
	for i, v in pairs( t ) do
		if ( !istable( v ) ) then
			copy[ i ] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[ t ] = copy
			if ( lookup_table[ v ] ) then
				copy[ i ] = lookup_table[ v ] -- we already copied this table. reuse the copy.
			else
				copy[ i ] = table_Copy( v, lookup_table ) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

local function stc( t, lookup_table ) -- just table.copy without the metatables
	if ( t == nil ) then return nil end
	local copy = {}
	for i, v in pairs( t ) do
		if ( !istable( v ) ) then
			copy[ i ] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[ t ] = copy
			if ( lookup_table[ v ] ) then
				copy[ i ] = lookup_table[ v ] -- we already copied this table. reuse the copy.
			else
				copy[ i ] = table_Copy( v, lookup_table ) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

local function soft_Copy( t ) -- don't actually make new child tables
	if ( t == nil ) then return nil end
	local copy = {}
	for i, v in pairs( t ) do
		copy[ i ] = v -- just reuse tables
	end

	return copy
end




local G = table_Copy( _G )

local meta = {}
function meta.__index(self, key)
	return G.FindMetaTable(key)
end

G.debug.getregistry = function()
	local tbl = {}
	G.setmetatable(tbl, meta)

	return tbl
end

local R = table_Copy( G.debug.getregistry() )
local P = soft_Copy( G.debug.getregistry() )
local _R = G.debug.getregistry()
G.startTime = startTime
G.short_src = G.debug.getinfo( 1 ).short_src
G.source = G.debug.getinfo( 1 ).source




G["__G"] = _G -- makes it so I can access _G from fenvs
G["R"] = R
G["_R"] = G.debug.getregistry()
G["__R"] = G.debug.getregistry()
G["_P"] = P

-- G.setmetatable( _R, {
-- 	__newindex = function(t, k, v)
-- 		if G.type( k ) == "number" then
-- 			G.rawset( P, k, v )
-- 			G.rawset( P, 0, G.rawget( _R, 0 ))
-- 			G.rawset( _R, k, v )
-- 		end
-- 	end
-- })

G.table.Copy = table_Copy

G.CFunc = GetModuleAPI()

G.CFunc.SetClientInterpAmount( 0 )

_G.GetModuleAPI = nil

-- G.callMenuHook = CallHook

local sendingPacket = true
G.forceSendPacket = false
local function sendPacket( bool )
	sendingPacket = bool
	
	G.CFunc.SetSendPacket( bool )
end

G.sendPacket = sendPacket

function G.Color( r, g, b, a )
	a = a or 255
	return G.setmetatable( { r = G.math.min( G.tonumber(r), 255 ), g = G.math.min( G.tonumber(g), 255 ), b = G.math.min( G.tonumber(b), 255 ), a = G.math.min( G.tonumber(a), 255 ) }, G.COLOR )
end

function G.IsValid( object )
	if ( !object ) then return false end

	local valid = object.IsValid
	if ( !valid ) then return false end

	return valid( object )
end

smt(debug.getinfo, { -- hahaha
    __tostring = function() return "function: builtin#121" end
})

-- BEGIN SHIT



local FS = {}
FS.Originals = {}
FS.Detours = {}
FS.Count = 0
FS.Names = {}
FS.GetLegit = {}
FS.GetDetour = {}
FS.NameLookup = {}
FS.DebugCache = {}
FS.LineDefined = {}
FS.FakeCurrentLine = {}
FS.FunctionEnvironment = {}

G.Detours = FS

function G.detour( originalf, newf, name )
	if !( originalf and newf ) then return end
	-- G.debug.setfenv( newf, _G ) -- make sure shit doesn't leak our env
	
	G.table.insert( FS.Originals, originalf )
	G.table.insert( FS.Detours, newf )
	G.table.insert( FS.Names, name )
	FS.NameLookup[newf] = name
	FS.GetLegit[newf] = originalf -- Quickly returns legit function using non-legit function as a key.
	FS.GetDetour[originalf] = newf   -- The opposite of above
	FS.FunctionEnvironment[newf] = G.debug.getfenv( originalf )

	local cacheMe = G.debug.getinfo( originalf, "flLnSu" )
	cacheMe["func"] = newf
	FS.DebugCache[newf] = cacheMe

	FS.LineDefined[G.debug.getinfo( newf, "S" )["linedefined"]] = newf
	FS.Count = FS.Count + 1
end


--========================--
-- String Library Rebuild -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua
--========================--

function G.string.ToTable( str )
	local tbl = {}

	for i = 1, G.string.len( str ) do
		tbl[i] = G.string.sub( str, i, i )
	end

	return tbl
end

local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

function G.string.PatternSafe( str )
	return G.string.gsub( str, ".", pattern_escape_replacements )
end

function G.string.Explode( separator, str, withpattern )
	if ( separator == "" ) then return G.string.ToTable( str ) end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, G.string.len( str ) do
		local start_pos, end_pos = G.string.find( str, separator, current_pos, !withpattern )
		if ( !start_pos ) then break end
		ret[ i ] = G.string.sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = G.string.sub( str, current_pos )

	return ret
end

function G.string.Split( str, delimiter )
	return G.string.Explode( delimiter, str )
end

function G.string.StartsWith( String, Start )
	return G.string.sub( String, 1, G.string.len( Start ) ) == Start
end

function G.string.EndsWith( String, End )
	return End == "" or G.string.sub( String, -G.string.len( End )) == End
end

function G.string.Trim( s, char )
	if ( char ) then char = G.string.PatternSafe( char ) else char = "%s" end
	return G.string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

function G.string.TrimLeft( s, char )
	if ( char ) then char = G.string.PatternSafe( char ) else char = "%s" end
	return G.string.match( s, "^" .. char .. "*(.+)$" ) or s
end

function G.string.TrimRight( s, char )
	if ( char ) then char = G.string.PatternSafe( char ) else char = "%s" end
	return G.string.match( s, "^(.-)" .. char .. "*$" ) or s
end

function G.string.Left( str, num ) return G.string.sub( str, 1, num ) end

function G.string.Right( str, num ) return G.string.sub( str, -num ) end

function G.string.Replace( str, tofind, toreplace )
	local tbl = G.string.Explode( tofind, str )
	if ( tbl[ 1 ] ) then return G.table.concat( tbl, toreplace ) end
	return str
end

function G.string.FormattedTime( seconds, format )
	if !seconds then seconds = 0 end
	local hours = G.math.floor( seconds / 3600 )
	local minutes = G.math.floor( ( seconds / 60 ) % 60 )
	local millisecs = ( seconds - G.math.floor( seconds ) ) * 100
	seconds = G.math.floor( seconds % 60 )

	if ( format ) then
		return G.string.format( format, minutes, seconds, millisecs )
	else
		return { h = hours, m = minutes, s = seconds, ms = millisecs }
	end
end

function G.string.ToMinutesSecondsMilliseconds( TimeInSeconds ) return G.string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i" ) end
function G.string.ToMinutesSeconds( TimeInSeconds ) return G.string.FormattedTime( TimeInSeconds, "%02i:%02i" ) end

local function table_Count( t )
	local i = 0
	for k in G.pairs( t ) do i = i + 1 end
	return i
end

function G.table.Random( t )
	local rk = G.math.random( 1, table_Count( t ) )
	local i = 1
	for k, v in G.pairs( t ) do
		if ( i == rk ) then return v, k end
		i = i + 1
	end
end

function G.table.KeyFromValue( tbl, val )
	for key, value in G.pairs( tbl ) do
		if ( value == val ) then return key end
	end
end

function G.table.RemoveByValue( tbl, val )
	local key = G.table.KeyFromValue( tbl, val )
	if ( !key ) then return false end

	G.table.remove( tbl, key )
	return key
end

function G.table.Random_Key( t )
	local rk = G.math.random( 1, table_Count( t ) )
	local i = 1
	for k, v in G.pairs( t ) do
		if ( i == rk ) then return k end
		i = i + 1
	end
end

function G.math.Rand( low, high )
	return low + ( high - low ) * G.math.random()
end

function G.math.Remap( value, inMin, inMax, outMin, outMax )
	return outMin + ( ( ( value - inMin ) / ( inMax - inMin ) ) * ( outMax - outMin ) )
end


function G.nullbyte( str )
	if str and G.string.find( str, "\0" ) then
		return G.string.gmatch( str, "[^%z]+" )() or ""
	end

	return str
end

G.hitmarker = {
	lasthit = nil,
}
G.bulletTracers = {}
G.debugLogs = {}
G.ConsoleHistory = {}
function G.debugNotif(...)
	local args = {...}

	local txtinfo = {

	}
	local time = true
	if time then 
		G.table.insert( txtinfo, {
			text = G.string.format("[%s] ", G.string.ToMinutesSecondsMilliseconds(G.SysTime() - G.startTime)),
			clr = G.Color(255, 255, 255, 230)
		})
	end

	if #args == 1 then
		local color = G.Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" )
		G.table.insert( txtinfo, { 
			text = "[Debug]",
			clr = G.Color(color.r, color.g, color.b, color.a),
			bold = true,
		})
		G.table.insert( txtinfo, { 
			text = G.tostring(args[1]),
			clr = G.Color(255, 255, 255, 230)
		})
	elseif #args == 3 then
		G.table.insert( txtinfo, { 
			text = G.tostring(args[1]),
			clr = args[2],
			bold = true,
		})
		G.table.insert( txtinfo, { 
			text = G.tostring(args[3]),
			clr = G.Color(255, 255, 255, 230)
		})
	end


	local finaltext = {
		time = G.SysTime() - G.startTime,
		content = txtinfo
	}

	G.table.insert( G.debugLogs, finaltext )
	G.table.insert( G.ConsoleHistory, finaltext )

end


-- ANCHOR: ADD MORE SHIT TO THIS IF NEEDED
-------------------------
-- BEGIN THE DETOURING --
-------------------------

-- ANCHOR
-- -- TODO: MODIFY THIS DETOUR SO THAT THE STACK LEVELS ARE CONSISTENT WITH ALL MY OTHERS
-- TODO LOL THIS DETOUR IS WRONG

local badSource = {
	-- ["@3{}{:or#@2k4123>4GFDESAG4%>!$#%P"] = true,
	["[C]"] = true
}

badSource[G.source] = true

-- not sure why, but this isn't created when I detour my shit
-- SET A METATABLE ON THIS TO AUTO DETOUR FUNCS THAT ARE ADDED
-- NEED TO DETOUR: getmetatable()

local hashes = {
	[115736] = "bc",
	[-1765235912] = "trace",
	[-1809450376] = "record",
	[-1796237952] = "texit"
}

local hashCache = {
	bc = 115736,
	trace = -1765235912,
	record = -1809450376,
	texit = -1796237952
}

-- #define lj_rol(x, n)    (((x)<<(n)) | ((x)>>(-(int)(n)&(8*sizeof(x)-1))))
local function lj_rol( x, n )
	return G.bit.bor( G.bit.lshift( x, n ), G.bit.rshift( x, G.bit.band( -n, 8 * 32 - 1 ))) -- 32 because 32 bit int
end

local function VMEVENT_HASHIDX( s )
	local p = s
	local h = G.string.len( s )

	if G.string.sub( s, 1, 1 ) != "\0" then -- if there is a null byte at the beginning, fuck it
		-- while (*p) h = h ^ (lj_rol(h, 6) + *p++);
		for i = 1, G.string.len(p) do
			if G.string.sub(p, i, i) != "\0" then
				h = G.bit.bxor(h, lj_rol(h, 6) + ( G.string.byte( G.string.sub( p, i, i ) or 8 )))
			end
		end
	end

	return G.bit.lshift( h, 3 )
end

local originalCallback = {} -- tables with undetoured functions in it
local actualCallback = {} -- table with the detoured functions in it
G.debug.getregistry()._VMEVENTS = actualCallback -- PLZ MAKE SURE PEOPLE CAN'T JUST GET RID OF THIS TABLE
P._VMEVENTS = originalCallback

local validMessages = {
	["string"] = true,
	["number"] = true
}

-- Misc. Detours for fucking with people.

-- function system.IsWindows()
-- 	return false
-- end

-- G.detour( G.system.IsWindows, system.IsWindows, "system.IsWindows" )


-- function system.IsOSX()
-- 	return true
-- end

-- G.detour( G.system.IsOSX, system.IsOSX, "system.IsOSX" )


-- function system.HasFocus()
-- 	return true -- Returns true 100% of the time on OS X.
-- end

-- G.detour( G.system.HasFocus, system.HasFocus, "system.HasFocus" )


-- function system.BatteryPower()
-- 	return 255
-- end

-- G.detour( G.system.BatteryPower, system.BatteryPower, "system.BatteryPower" )

-- jit.os = "OSX"

-- function system.GetCountry()
-- 	return "BR" -- North Korea best Korea
-- end

-- G.detour( G.system.GetCountry, system.GetCountry, "system.GetCountry")

-- function _G.CreateMaterial( name, shaderName, materialData )
-- 	G.print("MATERIAL CREATED: " .. name .. " " .. G.debug.getinfo(2).short_src )

-- 	return G.CreateMaterial( name, shaderName, materialData )
-- end

-- G.detour( G.CreateMaterial, _G.CreateMaterial, "CreateMaterial" )


-- function _G.game.MountGMA( path )
-- 	G.print("ADDON MOUNTED: " .. path .. " " .. G.debug.getinfo(2).short_src )

-- 	return G.game.MountGMA( path )
-- end

-- G.detour( G.game.MountGMA, _G.game.MountGMA, "game.MountGMA" )

--======================--
-- HOOK LIBRARY REBUILD --
--======================--

FS.Hooks = {}			-- Hooks created by my cheat
FS.GlobalHooks = {}		-- Hooks created by things other than my cheat
FS.JoinedHooks = {}		-- A combined table for functionality with _G.hook.Call()

G.Lib = {}
G.Lib.Hook = {}

-- _G.hook.Call(), the main functionality of the hook library.
-- Called by some backend shit every frame.
G.hideOverlay = true
local fakeSG
local fov_changer
local clearedScreen = false
function G.Lib.Hook.Call( name, gm, ... )
	local HookTable = FS.JoinedHooks[ name ]

	if !clearedScreen and name == "Think" then
		G.render.SetRenderTarget()

		G.cam.Start( { type = "2D" } )
			G.surface.SetDrawColor(0, 0, 0, 255)
			G.surface.DrawRect(0, 0, G.ScrW(), G.ScrH())
		G.cam.End2D()

		clearedScreen = true
	-- elseif name == "AdjustMouseSensitivity" then
	-- 	return -1
	elseif name == "OnPlayerChat" then
		--local a = caeDecode( ... )
		if a then return a end
	end

	local a, b, c, d, e, f
	if HookTable != nil then
		for k, v in G.pairs( HookTable ) do
			if G.isstring( k ) then
				a, b, c, d, e, f = v( ... )
			else
				if G.IsValid( k ) then
					a, b, c, d, e, f = v( k, ... ) -- If the object is valid - pass it as the first argument (self)
				else
					HookTable[ k ] = nil -- If the object has become invalid - remove it
				end
			end

			if a != nil and (name == "CalcView") then
				break
			elseif a != nil and name != "PostRender" then
				return a, b, c, d, e, f
			end
		end
	end

	if name == "CalcView" then
		if gm then
			local GamemodeFunction = gm[ name ]
			if GamemodeFunction then
				a = GamemodeFunction( gm, ... )
			end
		end

		return fov_changer( a or {}, ... )
	end

	if name == "PostRender" then
		if gm and gm[ name ] then gm[ name ]( gm, ... ) end
		fakeSG()
		return
	end

	-- Call the gamemode function
	if !gm then return end
	local GamemodeFunction = gm[ name ]
	if GamemodeFunction == nil then return end

	return GamemodeFunction( gm, ... )
end

function G.Lib.Hook.RunLocal( name, ... )
	if !FS.Hooks[name] then return end
	for k, v in pairs( FS.Hooks[name] ) do
		v()
	end
end

-- _G.hook.Run()
function G.Lib.Hook.Run( name, ... )
	return G.Lib.Hook.Call( name, gmod and G.gmod.GetGamemode() or nil, ... )
end

--ANCHOR: BLOCKED HOOKS
G.Lib.Hook.BlockList = {
	["CalcView"] = {
		["TauntCalcView"] = true, -- fuck zarp
		["oalihf"] = true -- NCRP annoyance
	},

	["CreateMove"] = {
		["TauntCreateMove"] = true -- fuck zarp
	},

	["ShouldDrawLocalPlayer"] = {
		["TauntShouldDrawLocalPlayer"] = true -- fuck zarp
	},

	["RenderScreenspaceEffects"] = {
		["JackyArmorSpaceEffects"] = true, -- jmod hinders your visibility with armor
		["DrawMotionBlur"] = true, -- bleh
		["JMOD_SCREENSPACE"] = true, -- jmod annoying stuff
		["consciousnessdeformer"] = true -- annoying shit when u get hit with beanbags
	},

	["HUDPaintBackground"] = {
		["JMOD_HUDBG"] = true -- jmod hinders your visibility with armor
	},

	["AdjustMouseSensitivity"] = {
		["JackyArmorHindrance"] = true -- jmod hinders your mouse sens
	},

	["Think"] = {
		["k"] = true, -- swiftac annoying garbage collection shit
		["keyTrapping_Maks4ulx"] = true, -- not sure what this does but fuck it
		["retard"] = true, -- fuck u cae
		["zysbxw"] = true,
		["icu"] = true,
		["dmyk"] = true -- ncrp annoying
	},

	["HUDPaint"] = {
		["Draw_NLR_Circle"] = true, -- shitty russian thing that blacks out your screen
		["ulx_blind"] = true, -- self evident
		["DoSomeEarRape"] = true, -- save ur ears and eyes
		["psb_hud_netgraph"] = true, -- some weird net graph thing, we don't need it
		["psb_hud_paint"] = true,
		["Vignette"] = true -- wow i cant see epic
	},

	["PostRender"] = {
		["thighs_vibe"] = true, -- idk what this does but it's gay
	},

	["HUDShouldDraw"] = {
		["dqz08jpkuolnbeuuis"] = true, -- shitty "haha u cant open menu" meme
		["psb_hud_shoulddraw"] = true,
		["crash_master"] = true -- no more crashes here baby!!
	},

	["PostDrawHUD"] = {
		["xc"] = true -- ncrp cancer
	},

	["SetupWorldFog"] = {
		["FoxController"] = true -- nobody likes fog lol russians
	},

	["Initialize"] = {
		["props_DrawHUD"] = true
	}
}

-- _G.hook.Add()
function G.Lib.Hook.AddGlobal( event, name, func )
	if !G.isfunction( func ) then return end
	if !G.isstring( event ) then return end

	if FS.GlobalHooks[ event ] == nil then
		FS.GlobalHooks[ event ] = {}
	end

	if FS.JoinedHooks[ event ] == nil then
		FS.JoinedHooks[ event ] = {}
	end

	if G.Lib.Hook.BlockList[event] and G.Lib.Hook.BlockList[event][name] == true then
		FS.GlobalHooks[ event ][ name ] = func
		G.debugNotif("HOOK BLOCKED! ".. tostring(event).. " ".. tostring(name))
	else
		FS.JoinedHooks[ event ][ name ] = func
		FS.GlobalHooks[ event ][ name ] = func
	end
end

-- _G.hook.Remove()
function G.Lib.Hook.RemoveGlobal( event, name )
	if ( !G.isstring( event ) ) then return end
	if ( !FS.GlobalHooks[ event ] ) then return end

	FS.JoinedHooks[ event ][ name ] = nil
	FS.GlobalHooks[ event ][ name ] = nil
end

-- Function to add hooks via my script
function G.Lib.Hook.Add( event, name, func )
	if ( !G.isfunction( func ) ) then return end
	if ( !G.isstring( event ) ) then return end

	if ( FS.Hooks[ event ] == nil ) then
		FS.Hooks[ event ] = {}
	end

	if (FS.JoinedHooks[ event ] == nil) then
		FS.JoinedHooks[ event ] = {}
	end

	FS.JoinedHooks[ event ][ name ] = func
	FS.Hooks[ event ][ name ] = func
end

-- _G.hook.GetTable()
-- Only return hooks added via the global hook table.
function G.Lib.Hook.GetGlobalTable()
	return FS.GlobalHooks
end

function G.Lib.Hook.GetTable()
	return FS.JoinedHooks
end

--============================--
-- CONCOMMAND LIBRARY REBUILD -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/modules/concommand.lua
--============================--

FS.CommandList = {} -- The global command table
FS.CompleteList = {} -- lol idek what the fuck this shit is
FS.LocalCommandList = {} -- my command table yah yeet

-- _G.concommand.GetTable()
local function fakeConcommandTable()
	return FS.CommandList, FS.CompleteList
end

-- _G.concommand.Add()
local function globalConAdd( name, func, completefunc, help, flags )
	local LowerName = G.string.lower( name )
	FS.CommandList[ LowerName ] = func
	FS.CompleteList[ LowerName ] = completefunc
	G.AddConsoleCommand( name, help, flags )
end

-- _G.concommand.Remove()
local function globalConRemove( name )
	local LowerName = G.string.lower( name )
	FS.CommandList[ LowerName ] = nil
	FS.CompleteList[ LowerName ] = nil
end

-- _G.concommand.Run()
local function globalConRun( player, command, arguments, args )

	if !command then
		return false
	end

	local LowerCommand = G.string.lower( command )

	if FS.CommandList[ LowerCommand ] != nil then
		FS.CommandList[ LowerCommand ]( player, command, arguments, args )
		return true
	end

	if FS.LocalCommandList[ LowerCommand ] != nil then
		FS.LocalCommandList[ LowerCommand ]( player, command, arguments, args )
		return false -- I think this should prevent people from knowing that this my concommand isn't there?
	end

	G.Msg( "Unknown command: " .. command .. "\n" )

	return false
end

-- _G.concommand.AutoComplete()
local function globalConAC( command, arguments )

	local LowerCommand = G.string.lower( command )

	if FS.CompleteList[ LowerCommand ] != nil then
		return FS.CompleteList[ LowerCommand ]( command, arguments )
	end

end

local function conadd( name, func, completefunc, help, flags )
	local LowerName = G.string.lower( name )
	FS.LocalCommandList[ LowerName ] = func
	G.AddConsoleCommand( name, help, flags )
end

--==========================--
-- CONVAR "LIBRARY" DETOURS --
--==========================--
local function ccv( name, default, shouldsave, userdata, helptext )
	local iFlags = 0

	if shouldsave or shouldsave == nil then
		iFlags = G.bit.bor( iFlags, FCVAR_ARCHIVE )
	end
	if userdata then
		iFlags = G.bit.bor( iFlags, FCVAR_USERINFO )
	end

	return G.CreateConVar( name, default, iFlags, helptext )
end

local myConVars = {}

local function createConVar( name, default, save )
	myConVars[name] = true
	return ccv( name, default, save, false ) -- ALWAYS SHOULD BE FALSE SO IT ISN'T SENT TO SERVER
end

local blockedCommands = {
	["gamemenucommand"] = true,
	-- ["+voicerecord"] = true,
	["connect"] = true
}

--======================--
-- File LIBRARY REBUILD -- https://wiki.garrysmod.com/page/Category:file
--======================--
-- file.Time is used for alt detection, make it very random
--
local offset

function file.Time( path, gamePath )
	if not offset then
		offset = G.math.random( 90000, 99999 ) / 100000
	end


	local toReturn = G.file.Time( path, gamePath )

	if toReturn != 0 then
		return G.math.floor( offset * toReturn )
	end

	return toReturn
end

G.detour( G.file.Time, file.Time, "file.Time" )

-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING
-- BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING BEGINNING

G.settings = {}

function G.cam.Start3D( pos, ang, fov, x, y, w, h, znear, zfar )
	local tab = {}
	tab.type = "3D"
	tab.origin = pos
	tab.angles = ang

	if ( fov != nil ) then tab.fov = fov end

	if ( x != nil and y != nil and w != nil and h != nil ) then
		tab.x = x
		tab.y = y
		tab.w = w
		tab.h = h
		tab.aspect = w / h
	end

	if znear != nil and zfar != nil then
		tab.znear = znear
		tab.zfar = zfar
	end

	return G.cam.Start( tab )
end

local function render_CopyTexture( from, to )
	local OldRT = G.render.GetRenderTarget()
	G.render.SetRenderTarget( from )
	G.render.CopyRenderTargetToTexture( to )
	G.render.SetRenderTarget( OldRT )
end

-- none of this should be needed anymore because I render in PostRender

-- https://wiki.garrysmod.com/page/render/PushRenderTarget
-- https://wiki.garrysmod.com/page/render/PopRenderTarget

G.fakeRT = G.GetRenderTarget( "fakeRT" .. G.tostring( G.SysTime() ), G.ScrW(), G.ScrH() )

-- G.curframe = G.FrameNumber()
-- -- G.resolution = 
-- local function renderTheScene( vOrigin, vAngle, vFOV ) -- RenderScene
-- 	if preventCrash then return end

-- 	if G.curframe == G.FrameNumber() then
-- 		G.print(G.FrameNumber())
-- 		return
-- 	else
-- 		G.curframe = G.FrameNumber()
-- 	end

-- 	local view = {
-- 		x = 0,
-- 		y = 0,
-- 		w = G.ScrW(),
-- 		h = G.ScrH(),
-- 		dopostprocess = true,
-- 		origin = vOrigin,
-- 		angles = vAngle,
-- 		fov = vFOV,
-- 		drawhud = true,
-- 		drawmonitors = true,
-- 		drawviewmodel = true
-- 	}

-- 	G.hideOverlay = true
-- 	G.render.RenderView( view )
-- 	G.hideOverlay = false

-- 	render_CopyTexture( nil, G.fakeRT )

-- 	G.cam.Start( { type = "2D" } )
-- 		G.Lib.Hook.RunLocal( "RenderScreenspaceEffects" )
-- 		G.Lib.Hook.RunLocal( "HUDPaint" )
-- 	G.cam.End2D()

-- 	G.render.SetRenderTarget( G.fakeRT )

-- 	G.hideOverlay = true
-- 	return true
-- end


-- local function mitigateSteamOverlayBug() -- PreRender
-- 	G.cam.Start( { type = "2D" } )
-- 		G.surface.SetDrawColor(0, 0, 0, 255)
-- 		G.surface.DrawRect(0, 0, G.ScrW(), G.ScrH())
-- 	G.cam.End2D()
-- end


G.curframe = G.FrameNumber()

-- ANTISCREENGRAB WITH UI SHOWING ( STREAM SAFE (: )
fakeSG = function() -- PostRender
	if G.curframe == G.FrameNumber() then
		G.render.SetRenderTarget( G.fakeRT )
		return
	else
		G.curframe = G.FrameNumber()
	end

	G.render.SetRenderTarget()
	G.render.CopyRenderTargetToTexture( G.fakeRT )

	if !G.gui.IsGameUIVisible() then
		G.hideOverlay = false
		local alpha = G.surface.GetAlphaMultiplier()

		G.cam.Start( { type = "3D" } )
			G.Lib.Hook.RunLocal( "RenderScreenspaceEffects" )
		G.cam.End3D()

		G.cam.Start( { type = "2D" } )
			surface.SetAlphaMultiplier( 1 )
			G.Lib.Hook.RunLocal( "HUDPaint" )
			G.Menu.Draw()
		G.cam.End2D()

		G.surface.SetAlphaMultiplier( alpha )
		G.hideOverlay = true
	else
		G.cam.Start( { type = "2D" } )
			G.CFunc.CallMenuHook( "PomfRender" )
		G.cam.End2D()
	end

	G.hideOverlay = true
	clearedScreen = false

	G.render.SetRenderTarget( G.fakeRT )
end

local function ShutdownSG() -- ShutDown
	G.render.SetRenderTarget()
end

local staffRanks = {"tmod", "trialmod", "trialmoderator", "tmoderator", "mod", "moderator", "smod", "smoderator", "seniormod", "seniormoderator", "jadmin", "junioradmin", "leadadmin", "headadmin", "trialadmin", "sadmin", "senioradmin", "owner", "coowner", "developer", "manager", "staff", "admin", "superadmin"}

local function getAdminRank( ply )
	for k, v in G.ipairs(staffRanks) do
		if G.string.lower(R.Entity.GetNWString( ply, "UserGroup", "user" )) == v then
			return v
		end
	end

	return nil
end

function G.GetSteamID(v)
	if !G.IsValid(v) then return end
	local id = R.Player.SteamID64( v )
	if id == nil then
		return R.Player.Nick( v ) 
	else
		return id
	end

end

G.PossibleAdmins = {}

local function GetPossibleAdmins()
	for _, ply in G.ipairs( G.player.GetAll() ) do
		G.PossibleAdmins[R.Player.UserID(ply)] = getAdminRank( ply )
	end
end

-- local function showSpectators() -- HUDPaint
-- 	if G.hideOverlay then return end

-- 	local yoff = 400 - 16
-- 	if G.Menu.Func.GetVar("Visuals", "Misc", "Spectators")[1] then
-- 		yoff = yoff + 16

-- 		G.surface.SetTextPos( 10, yoff )
-- 		G.surface.SetTextColor( G.Menu.Func.GetVar("Visuals", "Misc", "Spectators")[2] )
-- 		G.surface.SetFont( "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE" )
-- 		G.surface.DrawText( "Spectators:" )
-- 		G.surface.SetTextPos( 10, yoff + 1 )
-- 		//G.surface.DrawText( "_________" )

-- 		local spectators = {}
-- 		for _, ply in G.ipairs( G.player.GetAll() ) do
-- 			if R.Player.GetObserverTarget( ply ) != G.LocalPlayer() then continue end
-- 			spectators[ #spectators + 1 ] = ply
-- 		end

-- 		if spectators[1] then
-- 			for k, v in G.pairs( spectators ) do
-- 				local specType = specMode( R.Player.GetObserverMode( v ))
-- 				yoff = yoff + 12
-- 				G.surface.SetTextPos( 40, yoff )
-- 				G.surface.DrawText( R.Player.Nick( v ) .. " " .. "[" .. specType .. "]" )
-- 			end
-- 		end
-- 	end

-- 	if G.Menu.Func.GetVar("Visuals", "Misc", "Admin List")[1] then
-- 		if G.Menu.Func.GetVar("Visuals", "Misc", "Spectators")[1] then
-- 			yoff = yoff + 16
-- 		else
-- 			yoff = yoff + 16
-- 		end

-- 		G.surface.SetTextPos( 10, yoff )
-- 		G.surface.SetTextColor( G.Menu.Func.GetVar("Visuals", "Misc", "Admin List")[2] )
-- 		G.surface.SetFont( "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE" )
-- 		G.surface.DrawText( "Admins:" )
-- 		G.surface.SetTextPos( 10, yoff + 1 )
-- 		//G.surface.DrawText( "______" )

-- 		for _, ply in G.ipairs( G.player.GetAll() ) do

-- 			local rank = getAdminRank( ply )
-- 			if rank then
-- 				local distancetext = ""
-- 				if G.Menu.Func.GetVar("Visuals", "Misc", "Show Admin Distance") then
-- 					if R.Entity.IsDormant( ply ) then
-- 						G.surface.SetTextColor( 70, 70, 70, 100)
-- 						distancetext = "(dormant ".. G.tostring(math.ceil(R.Vector.Distance(R.Entity.GetPos( ply ), R.Entity.GetPos( LocalPlayer() ))/52)).. "m)"
-- 					else
-- 						G.surface.SetTextColor( G.Menu.Func.GetVar("Visuals", "Misc", "Admin List")[2] )
-- 						distancetext = "(".. G.tostring(math.ceil(R.Vector.Distance(R.Entity.GetPos( ply ), R.Entity.GetPos( LocalPlayer() ))/52)).. "m)"
-- 					end
-- 					--R.Vector.Distance(pos3d, R.Entity.GetPos(G.LocalPlayer()))
-- 				end
-- 				yoff = yoff + 12
-- 				G.surface.SetTextPos( 40, yoff )
-- 				G.surface.DrawText( R.Player.Nick( ply ) .. " " .. "[" .. rank .. "] ".. distancetext )
-- 			end
-- 			G.PossibleAdmins[G.GetSteamID(ply)] = rank
-- 		end
-- 	end
-- end

local function offsettan( ply, eyes )
	if !G.IsValid( ply ) then return G.Vector( 0, 0, 0 ) end

	if eyes == false then
		return R.Vector.ToScreen( R.Entity.GetPos( ply ))
	end

	if !R.Entity.GetAttachment( ply, R.Entity.LookupAttachment( ply, "eyes" )) then
		return R.Vector.ToScreen( R.Player.GetShootPos( ply ))
	else
		return R.Vector.ToScreen( R.Entity.GetAttachment( ply, R.Entity.LookupAttachment( ply, "eyes" )).Pos)
	end
end

G.surface.CreateFont( "adjflkjasfljsadlkj", {
	-- font = "Smallest Pixel-7",
	font = "CG pixel 4x5",
	antialias = false,
	weight = 500,
	size = G.math.max( 5 * (G.ScrH() / 1080), 5 )
--	weight = 400,
}) -- https://wiki.facepunch.com/gmod/draw.SimpleTextOutlined

G.surface.CreateFont( "adjflkjasfljsadlkjOUTLINE", {
	-- font = "Smallest Pixel-7",
	font = "CG pixel 4x5",
	antialias = false,
	weight = 500,
	outline = true,
	size = G.math.max( 5 * (G.ScrH() / 1080), 5 )
--	weight = 400,
}) -- https://wiki.facepunch.com/gmod/draw.SimpleTextOutlined


-- G.surface.CreateFont( "sdadlnhfjfpNIGGERuhgbisdguoa", {
-- 	-- font = "Smallest Pixel-7",
-- 	font = "Verdana",
-- 	antialias = false,
-- 	additive = 0,
-- 	italic = true,
-- 	size = 12,
-- --	weight = 400,
-- }) -- https://wiki.facepunch.com/gmod/draw.SimpleTextOutlined


G.surface.CreateFont( "sdadlnhfjfpNIGGERuhgbisdguoa", {
    font = "Verdana",
    size = 12,
    weight = 500,
    antialias = false,
})

G.surface.CreateFont( "sdadlnhfjfpNIGGERuhgbisdguoaOUTLINE", {
    font = "Verdana",
    size = 12,
    weight = 500,
    antialias = false,
    outline = true,
})

G.surface.CreateFont( "sdadlnhfjfpNIGGERuhgbisdguoaBOLD", {
    font = "Verdana",
    size = 12,
    weight = 100000,
	bold = true,
    antialias = false,
    outline = true,
})

G.surface.CreateFont( "asoudhaoiyudgwaiuoygdiuywagdiyugdigdyguy", {
    font = "Tahoma",
    size = 12,
    weight = 1000,
    antialias = false,
    shadow = true
})


-- CRASH FIXED BY CREATING FONTS IN LOADING.LUA (MENUSTATE)
G.surface.CreateFont( ".wY[p69Gru}YE]z0+|1##ma]QTDwsa+", {
	font = "halflife2",
	size = 64 * (G.ScrH() / 1080),
	blursize = 6,
	antialias = true,
	scanlines = 2,
	additive = 1
})

G.surface.CreateFont( "C>4W^2hiIl:T`?^h3W>6%6*pOJt':<8r", {
	font = "halflife2",
	size = 64 * (G.ScrH() / 1080),
	antialias = true,
	additive = 1
})



local function getaimkey() -- very lazy
	if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Enabled") then -- tony look i know youll get mad at this code but whats the point of making it better if it will only just be more complex
		if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot On Key") then -- its the same 2 lines in a row 4 times not that bad why would i do a complex for loop when i can do this
			if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Key") == "M4" then
				return G.input.IsMouseDown( G.MOUSE_4 )
			elseif G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Key") == "ALT" then
				return G.input.IsKeyDown( G.KEY_LALT )
			elseif G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Key") == "F" then
				return G.input.IsKeyDown( G.KEY_F )
			elseif G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Key") == "J" then
				return G.input.IsKeyDown( G.KEY_J )
			end	
			return false
		end
		return true
	end
	return false
end

-- NO RECOIL SHIT

local reg = G.debug.getregistry()
local fuck = R.Player.SetEyeAngles
local function NoRecoil( ply, ang )

	if G.type( ang ) != "Angle" then
		return R.Player.SetEyeAngles( ply, ang )
	end

	if ply == G.LocalPlayer() and ang then

		if G.Menu.Func.GetVar("Aimbot", "Accuracy", "No Recoil") then
			local diff = ang - R.Entity.EyeAngles( G.LocalPlayer() )
			
			diff.y = diff.y * ( 1 - 100 / 100 )
			diff.p = diff.p * ( 1 - 100 / 100 )

			if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Silent Aim") and getaimkey() then
				G.RestoreAngles = G.RestoreAngles + diff
			else
				R.Player.SetEyeAngles( G.LocalPlayer(), R.Entity.EyeAngles( G.LocalPlayer() ) + diff )
			end

			return
		end
		-- if getaimkey() then
		
		-- 	if G.Menu.Func.GetVar("Aimbot", "Accuracy", "No Recoil") then
		-- 		local diff = ang - R.Entity.EyeAngles( G.LocalPlayer() )
				
		-- 		diff.y = diff.y * ( 1 - 100 / 100 )
		-- 		diff.p = diff.p * ( 1 - 100 / 100 )

		-- 		if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Silent Aim") then
		-- 			G.RestoreAngles = G.RestoreAngles + diff
		-- 		else
		-- 			R.Player.SetEyeAngles( G.LocalPlayer(), R.Entity.EyeAngles( G.LocalPlayer() ) + diff )
		-- 		end

		-- 		return
		-- 	end

		-- else

		-- 	if G.Menu.Func.GetVar("Aimbot", "Accuracy", "Passive Recoil Reduction") then
		-- 		local diff = ang - R.Entity.EyeAngles( G.LocalPlayer() )

		-- 		diff.y = diff.y * ( 1 - G.Menu.Func.GetVar("Aimbot", "Accuracy", "Recoil Yaw Reduction") / 100 )
		-- 		diff.p = diff.p * ( 1 - G.Menu.Func.GetVar("Aimbot", "Accuracy", "Recoil Pitch Reduction") / 100 )

		-- 		if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Silent Aim") then
		-- 			G.RestoreAngles = G.RestoreAngles + diff
		-- 		else
		-- 			R.Player.SetEyeAngles( G.LocalPlayer(), R.Entity.EyeAngles( G.LocalPlayer() ) + diff )
		-- 		end

		-- 		return
		-- 	end

		-- end
	end

	return fuck( ply, ang )
end

reg["Player"]["SetEyeAngles"] = NoRecoil

G.detour( R.Player.SetEyeAngles, NoRecoil, "_R.Player.SetEyeAngles" )

function _R.Player.GetFriendStatus( player )
	return "none"
end

G.detour( R.Player.GetFriendStatus, _R.Player.GetFriendStatus, "_R.Player.GetFriendStatus" )

local pud = _R.Player.IsPlayingTaunt

function reg.Player.IsPlayingTaunt( ply )
	if ply == G.LocalPlayer() then
		return false
	end

	return pud( ply )
end

G.detour( R.Player.IsPlayingTaunt, reg.Player.IsPlayingTaunt, "_R.Player.IsPlayingTaunt" )

function G.math.Clamp( _in, low, high )
	return G.math.min( G.math.max( _in, low ), high )
end

function G.math.Round( num, idp )
	local mult = 10 ^ ( idp or 0 )
	return G.math.floor( num * mult + 0.5 ) / mult
end

function G.math.NormalizeAngle( a )
	return ( a + 180 ) % 360 - 180
end

local function normalizeAngle( ang )
	ang.x = G.math.NormalizeAngle( ang.x )
	ang.p = G.math.Clamp( ang.p, -89, 89 )

	return ang
end

local function AngleDifference( a, b )
	local diff = G.math.NormalizeAngle( a - b )

	if ( diff < 180 ) then
		return diff
	end

	return diff - 360
end

local function angDif( one, two, axis )
	return G.math.abs(normalizeAngle(one[axis] - two[axis]))
end

-- index is keypad entid
-- 1 is keypad
-- 2 is last key 2 be hovered over
-- 3 is uncomplete code being registered
-- 4 is possible complete codes (index is code value is just true)
-- 5 last text on screen
G.keypads = {}
local validkeypads = {
	Keypad = true,
	Keypad_Wire = true,
	keypad = true,
	keypad_wire = true,
	-- gmod_wire_keypad = true
}

function G.KeypadThink() -- Think
	for _, v in G.pairs(G.player.GetAll()) do
		if !R.Player.Alive(v) or R.Player.IsBot(v) or R.Entity.IsDormant(v) then continue end
		local dir = R.Player.GetAimVector(v)
		local trace = {
			start = R.Entity.EyePos( v ),
			endpos = R.Entity.EyePos( v ) + dir * 1000,
			filter = v
		}

		local tr = G.util.TraceLine( trace )
		local keypad = tr.Entity
		if !G.IsValid(keypad) then continue end
		if validkeypads[R.Entity.GetClass(keypad)] then
			local entid = R.Entity.EntIndex(keypad)
			if !keypad.GetText then continue end
			local text = keypad:GetText()

			if !G.keypads[entid] then G.keypads[entid] = {keypad} end
			if !G.keypads[entid][3] then G.keypads[entid][3] = "" end
			if !G.keypads[entid][4] then G.keypads[entid][4] = {} end

			if keypad:GetStatus() == 2 or #G.keypads[entid][3] > #text then
				G.keypads[entid][3] = ""
			end

			if keypad:GetStatus() == 1 and G.keypads[entid][3] != "" then
				G.keypads[entid][4][G.keypads[entid][3]] = true
				G.keypads[entid][3] = ""
			end

			if !keypad:GetSecure() then
				G.keypads[entid][3] = text
				continue
			end

			local keys = {}
			for i = 1, 9 do
				local column = (i - 1) % 3
				local row = G.math.floor((i - 1) / 3)

				local chords = {
					x = 0.075 + (0.3 * column),
					y = 0.175 + 0.25 + 0.05 + ((0.5 / 3) * row),
					w = 0.25,
					h = 0.13,
				}

				keys[i] = chords
			end

			local scale = keypad.Scale

			local pos, ang = keypad:CalculateRenderPos(), keypad:CalculateRenderAng()
			local normal = R.Entity.GetForward( keypad )

			local intersection = G.util.IntersectRayWithPlane(trace.start, dir, pos, normal)

			if !intersection then
				continue
			end

			local diff = pos - intersection

			local x = R.Vector.Dot(diff, -R.Angle.Forward(ang)) / scale
			local y = R.Vector.Dot(diff, -R.Angle.Right(ang)) / scale

			local w, h = keypad.Width2D, keypad.Height2D

			for i, element in G.ipairs(keys) do
				local element_x = w * element.x
				local element_y = h * element.y
				local element_w = w * element.w
				local element_h = h * element.h

				if element_x < x and element_x + element_w > x and
					element_y < y and element_y + element_h > y
				then
					G.keypads[entid][2] = i
					break
				end
			end
			if !G.keypads[entid][5] then G.keypads[entid][5] = text end
			if #G.keypads[entid][5] < #text then
				G.keypads[entid][3] = G.keypads[entid][3] .. G.tostring(G.keypads[entid][2])
			end
			G.keypads[entid][5] = text
		end
	end
end

G.EntsToDraw = {}
function G.InsEnt(ent, color)
	G.table.insert(G.EntsToDraw, {ent = ent, clr = color})
end

function G.Lerp( delta, from, to )
	if delta > 1 then return to end
	if delta < 0 then return from end

	return from + ( to - from ) * delta
end

G.Aimbot = {}

local sv_gravity = G.GetConVar_Internal( "sv_gravity" )
local function OldVelocityAfterGravity(ent, vel, ticks, bypassGroundedCheck)
	if (bypassGroundedCheck or !R.Entity.IsOnGround(ent)) and R.Entity.GetMoveType(ent) != G.MOVETYPE_NOCLIP and R.Entity.WaterLevel(ent) == 0 then
		local grav = R.ConVar.GetFloat( sv_gravity )
		local ent_grav = R.Entity.GetGravity(ent)
		ent_grav = ent_grav == 0 and 1 or ent_grav
		vel[3] = vel[3] - (ent_grav * grav * 0.5 * G.engine.TickInterval() * ticks)
		vel[3] = vel[3] + ( R.Entity.GetBaseVelocity(ent).z * G.engine.TickInterval() * ticks )
	end

	return vel
end

function G.Aimbot.OldVelocityPrediction(ent, pos, predictionTicks, prevPos, predictedTicksOffGround)
	predictionTicks = predictionTicks or 1
	local vel = R.Entity.GetVelocity(ent)
	local bottomOfOBB = R.Entity.GetPos(ent)
	local difference = bottomOfOBB - pos
	local predvel = OldVelocityAfterGravity(ent, vel, predictionTicks)
	local predictedPos = bottomOfOBB + (predvel * (G.engine.TickInterval() * predictionTicks))

	if R.Entity.GetMoveType(ent) != G.MOVETYPE_NOCLIP then
		if prevPos then
			predictedTicksOffGround = predictedTicksOffGround or 0

			local isOnGroundThisTick = G.util.TraceHull({
				start = prevPos,
				endpos = predictedPos - G.Vector(0, 0, 0.1),
				maxs = R.Entity.OBBMaxs(ent),
				mins = R.Entity.OBBMins(ent),
				filter = ent
			}).Fraction != 1

			if isOnGroundThisTick then
				predictedPos.z = prevPos.z
				predictedTicksOffGround = 0
			elseif !isOnGroundThisTick and R.Entity.IsOnGround(ent) then
				predictedTicksOffGround = predictedTicksOffGround + 1
				local newvel = OldVelocityAfterGravity(ent, vel, predictionTicks, true)
				predictedPos.z = predictedPos.z + (newvel.z * (G.engine.TickInterval() * predictedTicksOffGround))
			end
		end

		local hullTrace = {
			start = (prevPos or bottomOfOBB) + Vector(0, 0, 5),
			endpos = predictedPos + Vector(0, 0, 5),
			maxs = R.Entity.OBBMaxs(ent),
			mins = R.Entity.OBBMins(ent),
			filter = ent
		}

		predictedPos = G.util.TraceHull(hullTrace).HitPos - G.Vector(0, 0, 5)
	end

	return predictedPos - difference, predictedPos, predictedTicksOffGround
end

local function VelocityAfterGravity( ent, vel )
	if !R.Entity.IsOnGround( ent ) and R.Entity.GetMoveType( ent ) != G.MOVETYPE_NOCLIP and R.Entity.WaterLevel( ent ) == 0 then
		local grav = R.ConVar.GetFloat(sv_gravity)
		local ent_grav = R.Entity.GetGravity(ent)
		ent_grav = ent_grav == 0 and 1 or ent_grav

		vel[3] = vel[3] - ( ent_grav * grav * G.engine.TickInterval() * 0.5 ) 	
		vel[3] = vel[3] + ( R.Entity.GetBaseVelocity(ent).z * G.engine.TickInterval() )
	end

	return vel
end

function G.Aimbot.VelocityPrediction( ent, pos )
	local vel = R.Entity.GetVelocity(ent)
	local bottomOfOBB = R.Entity.GetNetworkOrigin(ent)
	local difference = bottomOfOBB - pos
	local predvel = VelocityAfterGravity(ent, vel)
	local predictedPos = bottomOfOBB + (predvel * G.engine.TickInterval())

	if R.Entity.GetMoveType(ent) != G.MOVETYPE_NOCLIP and R.Entity.IsOnGround( ent ) and R.Vector.LengthSqr( predvel ) > 0 then
		local hullTrace = {
			start = bottomOfOBB + G.Vector(0, 0, 2),
			endpos = bottomOfOBB,
			maxs = R.Entity.OBBMaxs(ent),
			mins = R.Entity.OBBMins(ent),
			filter = ent
		}

		hullTrace.endpos.z = hullTrace.endpos.z - R.Player.GetStepSize( ent )

		local tr = G.util.TraceHull(hullTrace)

		hullTrace.endpos = tr.HitPos

		tr = G.util.TraceHull(hullTrace)

		predictedPos = tr.HitPos
	end

	return predictedPos - difference, predictedPos
end

local function canSeeHead( ent, target, aimpos, lagComp )
	if !ent or !target or !aimpos then return false end
	local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )
	local tr = {}
	tr.start = aimpos
	tr.endpos = target
	tr.filter = { G.LocalPlayer(), ent }
	tr.mask = 1174421507 -- MASK_SHOT

	local traceResult = G.util.TraceLine( tr )

	return traceResult.Fraction == 1 or G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Auto Wall") and G.Aimbot.AutoWall( traceResult, tr.start, tr.endpos, ent, wep, lagComp )
end

local angZero = G.Angle( 0, 0, 0 )
local ReduceVec = G.Vector( 0.95, 0.95, 0.95 )

local function multiPoint( pos, ang, mins, maxs, dpi )
	local vec = {}

	if dpi == 1 then return {[1] = G.LocalToWorld(G.Vector((maxs.x + mins.x) * 0.5, (maxs.y + mins.y) * 0.5, (maxs.z + mins.z) * 0.5), angZero, pos, ang)} end

	for x = mins.x, maxs.x, ( maxs.x - mins.x ) / dpi do
		for y = mins.y, maxs.y, ( maxs.y - mins.y ) / dpi do
			for z = mins.z, maxs.z, ( maxs.z - mins.z ) / dpi do
				local a = G.LocalToWorld( G.Vector( x, y, z ) * ReduceVec, angZero, pos, ang )
	 			G.table.insert(vec, a)
			end
		end
	end

	return vec
end

function G.util.GetWorldAABBVectors(origin, pos, ang, mins, maxs)
	local tab = {
		ang = ang,
		pos = multiPoint( pos, ang , mins, maxs, 1)[1],
		mins = G.LocalToWorld(mins, angZero, pos, ang),
		maxs = G.LocalToWorld(maxs, angZero, pos, ang)
	}

	tab.dir = {}

	for k, v in ipairs( tab.pos ) do
		G.table.insert( tab.dir, R.Vector.GetNormalized(v - origin) )
	end

	return tab
end

local function GetWorldVectors(origin, pos, ang, mins, maxs)
	local tab = {
		ang = ang,
		pos = multiPoint( pos, ang , mins, maxs, 1),
		mins = G.LocalToWorld(mins, angZero, pos, ang),
		maxs = G.LocalToWorld(maxs, angZero, pos, ang),
		alignments = {}
	}

	tab.dir = {}

	for k, v in ipairs( tab.pos ) do
		G.table.insert( tab.dir, R.Vector.GetNormalized(v - origin) )
	end

	for i = 1, #tab.pos do
		tab.alignments[i] = 0
	end

	return tab
end

local function RotateOBBAboutOrigin(origin, angle, pos, obbang)
	local localPos = pos - origin

	local newOBBang = G.Angle(obbang[1], obbang[2], obbang[3])
	R.Angle.RotateAroundAxis(newOBBang, R.Vector.GetNormalized(localPos), angle.y)
	R.Vector.Rotate(localPos, angle)

	local retvec = localPos + origin --- diff
	retvec.z = pos.z

	return retvec, newOBBang
end

local testbog = 0
local function safePoint( v )
	local headbone = R.Entity.LookupBone( v, "ValveBiped.Bip01_Head1" )

	if !headbone then return end

	local pos, ang = G.util.GetBonePosition(v, headbone)
	local mins, maxs = R.Entity.GetHitBoxBounds( v, 0, 0 )
	local newPos, newAng
	local head
	local aim_origin = R.Player.GetShootPos( G.LocalPlayer() )
	local player_origin = R.Entity.GetPos( v )	

	local angs = v:EyeAngles()
	local angs2 = v:GetRenderAngles()

	print(v:Nick(), string.format(" | %.1f %.1f %.1f", angs.x, angs.y, angs.z), string.format(" | %.1f %.1f %.1f", angs2.x, angs2.y, angs2.z))

	local _, yawMax = R.Entity.GetPoseParameterRange(v, R.Entity.LookupPoseParameter(v, "aim_yaw"))
	local brute = testbog % 5
	if brute == 0 then
		head = GetWorldVectors(aim_origin, pos, ang, mins, maxs)
	elseif brute == 1 then
		newPos, newAng = RotateOBBAboutOrigin(player_origin, G.Angle(0, angs.y + G.math.random(120, 180), 0), pos, ang)
		head = GetWorldVectors(aim_origin, newPos, newAng, mins, maxs)
	elseif brute == 2 then
		newPos, newAng = RotateOBBAboutOrigin(player_origin, G.Angle(0, angs.y + 180, 0), pos, ang)
		head= GetWorldVectors(aim_origin, newPos, newAng, mins, maxs)
	elseif brute == 3 then
		newPos, newAng = RotateOBBAboutOrigin(player_origin, G.Angle(0, angs.y + yawMax, 0), pos, ang)
		head= GetWorldVectors(aim_origin, newPos, newAng, mins, maxs)
	elseif brute == 4 then
		newPos, newAng = RotateOBBAboutOrigin(player_origin, G.Angle(0, angs.y - yawMax, 0), pos, ang)
		head = GetWorldVectors(aim_origin, newPos, newAng, mins, maxs)
	end
	
	testbog = testbog + 1

	return head.pos[1]
end

function G.Aimbot.TargetPos( v, skiptohead )
	if R.Entity.GetModel( v ) == "models/error.mdl" then
		return R.Entity.LocalToWorld( v, R.Entity.OBBCenter( v ))
	elseif skiptohead or (R.Entity.LookupBone( v, "ValveBiped.Bip01_Head1" ) and G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Target") == "Head") then

		if G.anti_aim.SequenceFreezing then
			local boner = R.Entity.GetHitBoxBone( v, 15, 0 )
			local mins, maxs = R.Entity.GetHitBoxBounds( v, 15, 0 )

			if !mins or !maxs then return R.Entity.LocalToWorld( v, R.Entity.OBBCenter( v )) end

			return G.util.GetBonePosition( v, boner, (maxs + mins) * 0.5 )
		else
			local headbone = R.Entity.LookupBone( v, "ValveBiped.Bip01_Head1" )

			if !headbone then return R.Entity.LocalToWorld( v, R.Entity.OBBCenter( v )) end

			local mins, maxs = R.Entity.GetHitBoxBounds( v, 0, 0 )

			if !mins or !maxs then return R.Entity.LocalToWorld( v, R.Entity.OBBCenter( v )) end

			-- R.Entity.InvalidateBoneCache( v )
			-- R.Entity.SetupBones( v )

			return G.util.GetBonePosition( v, headbone, (maxs + mins) * 0.5 )
		end
	elseif R.Entity.GetHitBoxBone( v, 15, 0 ) and G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Target") == "Body" then
		local boner = R.Entity.GetHitBoxBone( v, 15, 0 )
		local mins, maxs = R.Entity.GetHitBoxBounds( v, 15, 0 )

		if !mins or !maxs then return R.Entity.LocalToWorld( v, R.Entity.OBBCenter( v )) end

		return G.util.GetBonePosition( v, boner, (maxs + mins) * 0.5 )
	elseif G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Target") == "Hitbox Scan" then
		local entPos = R.Entity.GetPos( v )
		for i = 0, R.Entity.GetHitBoxCount( v, 0 ) do
			local hbBone = R.Entity.GetHitBoxBone( v, i, 0 )

			if !hbBone then continue end

			local pos, hitAng = R.Entity.GetBonePosition( v, hbBone )

			if pos == entPos then continue end

			local mins, maxs = R.Entity.GetHitBoxBounds( v, i, 0 )

			if !mins or !maxs then continue end

			local aimPos = G.LocalToWorld( G.Vector((maxs.x + mins.x) / 2, (maxs.y + mins.y) / 2, (maxs.z + mins.z) / 2), angZero, pos, hitAng )

			if canSeeHead( v, aimPos, R.Player.GetShootPos( G.LocalPlayer() ) ) then
				return aimPos
			end
		end

		return G.Aimbot.TargetPos( v, true )
	elseif G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Target") == "Hitbone Scan" then
		for i = 0, R.Entity.GetHitBoxCount( v, 0 ) do
			local bone = R.Entity.GetHitBoxBone( v, i, 0 )

			if !bone then continue end

			local bonePos = R.Entity.GetBonePosition( v, bone )

			if !bonePos then continue end

			if canSeeHead( v, bonePos, R.Player.GetShootPos( G.LocalPlayer() ) ) then
				return bonePos
			end
		end

		return G.Aimbot.TargetPos( v, true )
	elseif G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Target") == "Bone Scan" then
		for i = 0, R.Entity.GetBoneCount( v ) do
			local bonePos = R.Entity.GetBonePosition( v, i )

			if bonePos == R.Entity.GetPos( v ) then continue end

			if !bonePos then continue end

			if canSeeHead( v, bonePos, R.Player.GetShootPos( G.LocalPlayer() ) ) then
				return bonePos
			end
		end

		return G.Aimbot.TargetPos( v, true )
	else
		return R.Player.GetShootPos( v )
		-- return R.Entity.LocalToWorld( v, R.Entity.OBBCenter( v ))
	end
end

function G.CanShoot()
	-- G.ServerTime = R.Entity.GetInternalVariable(G.LocalPlayer(), "m_nTickBase") * G.engine.TickInterval()
	local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )
	return G.IsValid( wep ) and R.Weapon.GetActivity( wep ) != G.ACT_RELOAD and R.Weapon.GetNextPrimaryFire( wep ) < G.ServerTime and R.Player.Alive( G.LocalPlayer() )
end


G.currentTick = 0
local backtrackAmount = 13
G.TickCopies = {}
G.prevShootPos = nil
G.prevTick = nil

function G.Aimbot.SetAngles( cmd, angle, wep )
	if G.Menu.Func.GetVar("Aimbot", "Accuracy", "No Spread") then
		angle = G.Aimbot.PredictSpread( cmd, angle )
	end

	if G.Menu.Func.GetVar("Aimbot", "Accuracy", "Static Aim") then
		angle.p = -angle.p - 180
		angle.y = angle.y + 180
	end

	if G.Menu.Func.GetVar("Aimbot", "Legit Settings", "Safe Aim") then
		R.CUserCmd.SetMouseX( cmd, G.math.random( 2, 100 ) )
		R.CUserCmd.SetMouseY( cmd, G.math.random( 2, 100 ) )
		G.math.Clamp( angle[1], -89, 89 )
		G.math.Clamp( angle[2], -179, 179 )
		angle[3] = 0
	end

	R.Angle.Normalize( angle )
	flip = !flip
	-- if wep != nil and G.IsValid(wep) and G.HL2VP[R.Entity.GetClass( wep )] or (wep.Base == "taco_base") then -- anti recoil
	-- 	R.CUserCmd.SetViewAngles(cmd, angle - R.Player.GetViewPunchAngles(G.LocalPlayer()))
	-- else
	R.CUserCmd.SetViewAngles( cmd, angle )
	-- end
end

function G.Aimbot.LagCompensated( curpos, desiredpos )
	return R.Vector.DistToSqr( curpos, desiredpos ) < 4096 -- https://github.com/VSES/SourceEngine2007/blob/43a5c90a5ada1e69ca044595383be67f40b33c61/src_main/game/server/player_lagcompensation.cpp#L432
end

local function TICKS_TO_TIME( ticks )
	return ticks * G.engine.TickInterval()
end

local function TIME_TO_TICKS( time )
	return G.math.floor( 0.5 + time / G.engine.TickInterval() )
end

G.TIME_TO_TICKS = TIME_TO_TICKS

local cl_interp = 15
local set_cl_interp = false

local function setInterp( interp )
	if interp == 0 then
		G.CFunc.SetConVar( "cl_interpolate", "0")
	else
		G.CFunc.SetConVar( "cl_interpolate", "1")
	end

	G.CFunc.SetConVar( "cl_interp", G.tostring(interp))
	cl_interp = interp
end

G.CFunc.SetConVar( "cl_interpolate", G.tostring("0"))


--[[
	{
	Type = "ComboBox",
	Label = "Ignore Conditions",
	Value = {"Friends", "No Clipping"},
	Values = {"Friends", "No Clipping", "Transparent", "In Vehicle", "Bot", "Build Mode", "Same Team", "Opposite Team"},
	DrawLabel = false,
},
]]

function G.ShouldAimbot( v )
	if v != G.LocalPlayer() and R.Player.Alive( v ) and !R.Entity.IsDormant( v ) and G.IsValid( v ) then

		if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Filter") then

			if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Friends") and R.Player.GetFriendStatus( v ) == "friend" ) then
				return false
			end
	
			if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Build Mode") then
				if R.Entity.GetNWBool( v, "BuildMode", nil) then
					return false
				end

				if R.Entity.GetNWBool( v, "_Kyle_Buildmode", nil) then
					return false
				end

				if R.Entity.GetNWBool( v, "LibbyProtectedSpawn", nil) then
					return false
				end
			end

			if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Oppisite Team") and ( R.Player.Team( v ) != R.Player.Team( G.LocalPlayer() ) ) ) then
				return false
			end

			if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Same Team") and ( R.Player.Team( v ) == R.Player.Team( G.LocalPlayer() ) ) ) then
				return false
			end
			
			if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "In Vehicle") and R.Player.InVehicle( v ) ) then
				return false
			end

			if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Bot") and R.Player.Ping( v ) == 0 ) then
				return false
			end

			if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "No Clipping") and R.Entity.GetMoveType( v ) == 8 ) then
				return false
			end

		end
		return true
	end
	return false
end


function G.ShouldDrawPlayer( v )
	if G.Menu.Func.GetVar("Visuals", "ESP Filtering", "Ignore Conditions") then
		--Ignore Overide
		--[[
					{
			Type = "ComboBox",
			Label = "Ignore Overide",
			Value = {"Aimbot Filters", "Distance"},
			Values = { "Aimbot Filters", "Distance", "Same Team", "Oppisite Team" },
			Opened = false, Max Distance
			DrawLabel = false,
		},
		]]

		if G.util.GetHighLightColor( v, "Show Flag") then
			return true
		end

		if ( G.Menu.Func.GetVar("Visuals", "ESP Filtering", "Ignore Overide", "Distance") and R.Vector.Distance( R.Entity.GetPos( v ), R.Entity.GetPos( LocalPlayer() ) )/52 > G.Menu.Func.GetVar("Visuals", "ESP Filtering", "Max Distance") ) then
			return false
		end
		
		if ( G.Menu.Func.GetVar("Visuals", "ESP Filtering", "Ignore Overide", "Aimbot Filters") ) then
			if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Filter") then	
				if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Build Mode") then
					if R.Entity.GetNWBool( v, "BuildMode", nil) then
						return false
					end

					if R.Entity.GetNWBool( v, "_Kyle_Buildmode", nil) then
						return false
					end

					if R.Entity.GetNWBool( v, "LibbyProtectedSpawn", nil) then
						return false
					end
				end
	
				if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Opposite Team") and ( R.Player.Team( v ) != R.Player.Team( G.LocalPlayer() ) ) ) then
					return false
				end
	
				if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Same Team") and ( R.Player.Team( v ) == R.Player.Team( G.LocalPlayer() ) ) ) then
					return false
				end
				
				if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "In Vehicle") and R.Player.InVehicle( v ) ) then
					return false
				end
	
				if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "Bot") and R.Player.Ping( v ) == 0 ) then
					return false
				end
	
				if ( G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Ignore Conditions", "No Clipping") and R.Entity.GetMoveType( v ) == 8 ) then
					return false
				end
	
			end
		end

		if ( G.Menu.Func.GetVar("Visuals", "ESP Filtering", "Ignore Overide", "Opposite Team") and ( R.Player.Team( v ) != R.Player.Team( G.LocalPlayer() ) ) ) then
			return false
		end

		if ( G.Menu.Func.GetVar("Visuals", "ESP Filtering", "Ignore Overide", "Same Team") and ( R.Player.Team( v ) == R.Player.Team( G.LocalPlayer() ) ) ) then
			return false
		end


	end
	return true
end

--G.util.GetBoneMatrix( v )

G.AimbotShotTargets = {}
local function AddShotTarget( plyr, tickinfo )
	if !G.Menu.Func.GetVar("Visuals", "Chams", "Target Chams") and !G.CanShoot() then return end

	local shotinfo = {
		player = plyr,
		tick = tickinfo,
		time = G.SysTime()
	}

	G.table.insert(G.AimbotShotTargets, shotinfo)
	
end



local cl_interp_ratio = G.GetConVar_Internal( "cl_interp_ratio" )
local lastInterp = 0


G.Aimbot.sendPacket = function(send)
	if G.anti_aim.FakeDucking then
		sendPacket(false)
		return
	end
	sendPacket(send)
end

local function aimbot( cmd, optionalAngle ) -- CreateMove
	if !G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Enabled") then return end
	if getaimkey() == false then return end


	local aimPos = R.Player.GetShootPos( G.LocalPlayer() )
	-- local aimAng = optionalAngle and optionalAngle or R.Entity.EyeAngles( G.LocalPlayer() )
	local aimVector = R.Player.GetAimVector( G.LocalPlayer() )
	local aimFov = G.Menu.Func.GetVar("Aimbot", "Legit Settings", "Aimbot FOV")
	local aimBone = nil
	local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )

	--if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Ammo Check") and R.Weapon.Clip1(wep) <= 0 then return end

	if wep.Base and wep.Base == "arccw_base" then
		aimPos = G.Aimbot.ArcCWShootPos( cmd, wep )
	end

	if G.IsValid(wep) then
		if R.Weapon.GetMaxClip1(wep) ~= 0 then
			if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Ammo Check") and R.Weapon.Clip1(wep) <= 0 then return end
		end

		local name = R.Entity.GetClass( wep )
		if R.Player.KeyDown(G.LocalPlayer(), G.IN_ATTACK) and name != "weapon_physgun" and name != "weapon_physcannon" and name != "gmod_tool" then
			if G.anti_aim.SequenceFreezing and !R.Weapon.IsScripted( wep ) and G.prevShootPos then
				R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))
				R.CUserCmd.SetViewAngles( cmd, R.Vector.Angle( G.prevShootPos ))
				G.prevShootPos = nil

				if lastInterp then setInterp( lastInterp ) set_cl_interp = true end

				lastInterp = nil

				return
			end

			-- if !G.Menu.ShouldBulletTime() then
			-- 	R.CUserCmd.RemoveKey( cmd, G.IN_ATTACK )
			-- 	if !G.Menu.Func.GetVar( "Aimbot", "Legit Settings", "Sticky Lock" ) then
			-- 		return
			-- 	end
			-- end
		end
	else
		return
	end

	if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Bullet Time") and !G.Menu.Func.GetVar( "Aimbot", "Legit Settings", "Sticky Lock" ) and !G.CanShoot() then return end

	-- if G.anti_aim.FakeDucking then
	-- 	print(sendingPacket)
	-- 	if not sendingPacket then 
	-- 		return
	-- 	end
	-- end

	for _, v in G.ipairs( G.player.GetAll() ) do
		if G.ShouldAimbot( v ) then --
			-- if R.Player.Team( v ) == R.Player.Team( G.LocalPlayer() ) then continue end

			aimBone = nil
			local pid = R.Player.UserID( v )

			local maxChoke = 1
			for k, t in G.pairs( G.TickCopies[pid] ) do
				if t.choked > maxChoke then
					maxChoke = t.choked
				end
			end

			aimBone = aimBone and aimBone or G.TickCopies[pid][G.currentTick].pos

			local breakingLagComp = !G.Aimbot.LagCompensated( R.Entity.GetNetworkOrigin( v ), G.Aimbot.VelocityPrediction( v, R.Entity.GetNetworkOrigin( v ) ))

			if !aimBone then continue end

			local entVector = aimBone - aimPos
			local dot = R.Vector.Dot( aimVector, entVector ) / R.Vector.Length( entVector )

			if G.Menu.Func.GetVar("Aimbot", "Legit Settings", "Aimbot FOV Enabled") and G.math.deg( G.math.acos( dot )) > aimFov then
				continue
			end

			aimBone = aimBone and aimBone or G.TickCopies[pid][G.currentTick].pos			

			-- if G.Menu.Func.GetVar("Aimbot", "Accuracy", "test") then
			-- 	aimBone = safePoint( v )
			-- end

			-- aimPos = G.Aimbot.VelocityPrediction( G.LocalPlayer(), aimPos )

			if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "On-Shot Backtrack") then
				local int_ratio = R.ConVar.GetFloat( cl_interp_ratio )
				for tick = G.currentTick - 1, (G.currentTick - backtrackAmount + 1), -1 do
					if G.currentTick - tick <= backtrackAmount and G.TickCopies[pid][tick] and G.TickCopies[pid][tick].isShooting and G.TickCopies[pid][tick].usable then
						local shootpos = G.TickCopies[pid][tick].pos
						if G.TickCopies[pid][tick].head then
							shootpos = G.TickCopies[pid][tick].head
						end
						if canSeeHead( v, shootpos, aimPos, true ) then

							local timeBack = TICKS_TO_TIME( G.currentTick - tick ) -- + G.CFunc.GetLatency( 0 )

							if timeBack > .2 then
								local interp = TICKS_TO_TIME(TIME_TO_TICKS(timeBack)) --/ ( int_ratio != 0 and int_ratio or 1 )

								if interp > 1 then break end

								set_cl_interp = true
								setInterp( interp )
								lastInterp = interp
							else
								G.CFunc.SetTickCount( cmd, tick )
							end
							G.CFunc.SetOutSequenceNr( 0 )
							G.Aimbot.sendPacket( true )
							G.prevShootPos = shootpos - aimPos
							AddShotTarget( v, G.TickCopies[pid][tick] )
							G.Aimbot.SetAngles( cmd, R.Vector.Angle( shootpos - aimPos ), wep )
							R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))
							G.TickCopies[pid][tick].used = true
							--
							return true
						end
					end
				end
				if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Force On-Shot") then
					return false
				end
			end

			-- local predictedTargetPos = G.Aimbot.VelocityPrediction( v, aimBone )

			if !breakingLagComp and canSeeHead( v, aimBone, aimPos ) then
				G.CFunc.SetOutSequenceNr( 0 )
				G.Aimbot.sendPacket( true )

				if G.Menu.Func.GetVar( "Aimbot", "Accuracy", "Fake Lag Fix" ) then
					G.CFunc.SetTickCount( cmd, TIME_TO_TICKS(G.TickCopies[pid][G.currentTick].simtime))
				end

				G.prevShootPos = aimBone - aimPos
				AddShotTarget( v, G.TickCopies[pid][G.currentTick] )
				G.Aimbot.SetAngles( cmd, R.Vector.Angle( aimBone - aimPos ), wep )
				R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))
				return true
			elseif breakingLagComp then
				local shootMe, pos, offground
				for tick = 1, TIME_TO_TICKS( G.CFunc.GetLatency( 0 ) + G.CFunc.GetLatency( 1 ) ) do
					shootMe, pos, offground = G.Aimbot.OldVelocityPrediction( v, aimBone, tick, pos, offground )
				end

				if canSeeHead( v, shootMe, aimPos, true ) then
					G.CFunc.SetOutSequenceNr( 0 )
					G.Aimbot.sendPacket( true )
					G.prevShootPos = shootMe - aimPos
					AddShotTarget( v, G.TickCopies[pid][G.currentTick] )
					G.Aimbot.SetAngles( cmd, R.Vector.Angle( shootMe - aimPos ), wep )
					R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))

					return true
				end
			end

			if G.Menu.Func.GetVar( "Aimbot", "Accuracy", "Forward Track" ) then
				local shootMe, pos, offground
				for tick = 1, TIME_TO_TICKS( G.CFunc.GetLatency( 0 ) ) do
					shootMe, pos, offground = G.Aimbot.OldVelocityPrediction( v, aimBone, tick, pos, offground )

					if canSeeHead( v, shootMe, aimPos ) then
						G.CFunc.SetOutSequenceNr( 0 )
						G.Aimbot.sendPacket( true )
						G.CFunc.SetTickCount( cmd, G.currentTick + tick )
						G.prevShootPos = shootMe - aimPos
						AddShotTarget( v, G.TickCopies[pid][G.currentTick] )
						G.Aimbot.SetAngles( cmd, R.Vector.Angle( shootMe - aimPos ), wep )
							R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))
						return true
					end
				end
			end

			if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Backtrack") and G.TickCopies[pid] then
				local maxbt = G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Backtrack Amount")
				local int_ratio = R.ConVar.GetFloat( cl_interp_ratio )
				for tick = G.currentTick - 1, (G.currentTick - backtrackAmount + 1), -1 do
					if G.currentTick - tick <= backtrackAmount and G.TickCopies[pid][tick] and G.TickCopies[pid][tick].usable and canSeeHead(v, G.TickCopies[pid][tick].pos, aimPos, true) then
						local timeBack = TICKS_TO_TIME( G.currentTick - tick ) -- + G.CFunc.GetLatency( 0 )

						if timeBack > maxbt then break end

						if timeBack > .2 then
							local interp = TICKS_TO_TIME(TIME_TO_TICKS(timeBack)) --/ ( int_ratio != 0 and int_ratio or 1 ) -- IDK WHY THIS BROKE THE ENTIRE BACKTRACK I JUST COMMENTED THIS SHOUT TONTARD

							if interp > 1 then break end

							set_cl_interp = true
							setInterp( interp )
							lastInterp = interp
						else
							G.CFunc.SetTickCount( cmd, tick )
						end

						G.CFunc.SetOutSequenceNr( 0 )
						G.Aimbot.sendPacket( true )
						G.prevShootPos = G.TickCopies[pid][tick].pos - aimPos
						AddShotTarget( v, G.TickCopies[pid][tick] )
						G.Aimbot.SetAngles( cmd, R.Vector.Angle( G.TickCopies[pid][tick].pos - aimPos ), wep )
						R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))

						return true
					end
				end
			end


			-- aimPos = aimPos + R.Entity.GetVelocity( G.LocalPlayer() ) * G.engine.TickInterval()
			-- aimPos = aimPos + ( R.Entity.GetVelocity( v ) * G.engine.TickInterval() ) -- https://github.com/AimTuxOfficial/AimTux/blob/9aa85f904dd465523296ae08437001bf4a3a150a/src/Hacks/aimbot.cpp#L131
			-- local ang = R.Vector.Angle( FirePos + R.Entity.GetVelocity( Target ) / 2 * G.engine.TickInterval() - AimPos )
			-- aimBone = aimBone + R.Entity.GetVelocity( v ) * G.engine.TickInterval()
			-- aimBone = G.Aimbot.VelocityPrediction( v, aimBone )
			-- if canSeeHead( v, aimBone, aimPos ) then
			-- 	local aimview = R.Vector.Angle( aimBone - aimPos )
			-- 	G.Aimbot.SetAngles( cmd, aimview, wep )
			-- 	sendPacket( true )
			-- 	G.CFunc.SetOutSequenceNr( 0 )
			-- 	G.prevShootPos = aimBone - aimPos
			-- 	R.CUserCmd.SetButtons( cmd, G.bit.bor( G.IN_ATTACK, R.CUserCmd.GetButtons( cmd )))
			-- 	break
			-- end
		end
	end

	return false
end

G.LastPlyToShoot = nil
function G.DoAnimationEvent( ply, event, data )
	local pid = R.Player.UserID( ply )
	if event == 0 and G.IsValid( ply ) and G.TickCopies[pid] then
		local bestPitchDelta = 10000
		local bestTick = 0
		local pointTwo = TIME_TO_TICKS( .2 )
		for i = G.currentTick, (G.currentTick - pointTwo + 1), -1 do
			if G.TickCopies[pid] and G.TickCopies[pid][i] then
				local delta = G.math.abs( G.TickCopies[pid][i].angle.p )
				if delta < bestPitchDelta and G.TickCopies[pid][i].choked < 3 then
					bestTick = i
					bestPitchDelta = delta
				end
			end
		end

		if G.TickCopies[pid] and G.TickCopies[pid][bestTick] then
			G.TickCopies[pid][bestTick].isShooting = true
		end
		G.LastPlyToShoot = ply
	end
end

local me = G.LocalPlayer

local sv_airaccelerate = G.GetConVar_Internal( "sv_airaccelerate" )

G.Movement = {}
function G.Movement.GetOptimalAirStrafe( speed )
	local maxSpeed = R.Entity.GetInternalVariable( me(), "m_flMaxspeed" )
	local airAccel = R.ConVar.GetFloat( sv_airaccelerate ) * maxSpeed * G.engine.TickInterval()
	local flTerm = ( maxSpeed - airAccel ) / speed

	if flTerm > 1 or flTerm < 0 then return 0.0000000000001 end

	return G.math.acos( flTerm )
end


local cl_sidespeed = G.GetConVar_Internal("cl_sidespeed")
local cl_forwardspeed = G.GetConVar_Internal("cl_forwardspeed")

local function funnyJiggle( cmd ) -- CreateMove
	if !G.Menu.Func.GetVar("Misc", "Movement", "Duck In Air") then return end
	local pos = R.Entity.GetPos( me() )
	local trace = G.util.TraceLine( {start = pos, endpos = pos - G.Vector(0, 0, 2048), mask = 33570827} ) -- SOLID MASK
	local len = ( pos - trace.HitPos ).z
	if len > 25 and 51.5 > len then
		R.CUserCmd.SetButtons( cmd, G.bit.bor( R.CUserCmd.GetButtons(cmd), 4 )) -- DUCK
	else
		R.CUserCmd.RemoveKey( cmd, 4 ) -- UNDUCK
	end
end

local function bhop( cmd, view ) -- CreateMove
	if !G.Menu.Func.GetVar( "Misc", "Movement", "Bunny Hop" ) then return end
	-- if R.CUserCmd.KeyDown( cmd, 2 ) and R.Entity.IsOnGround( me() ) then
	-- 	R.CUserCmd.SetButtons( cmd, G.bit.bor( 2, R.CUserCmd.GetButtons( cmd )))
	if R.CUserCmd.KeyDown( cmd, 2 ) and
	G.input.IsKeyDown( G.KEY_SPACE ) and
	!R.Player.IsTyping( me() ) and
	R.Player.Alive( me() ) and
	!R.Player.InVehicle( me() ) and
	R.Entity.GetMoveType( me() ) != 9 and -- ladder
	R.Entity.GetMoveType( me() ) != 8 and -- noclip
	R.Entity.WaterLevel( me() ) <= 1 then
		if !R.Entity.IsOnGround( me() ) then
			R.CUserCmd.RemoveKey( cmd, 2 )

			if G.Menu.Func.GetVar( "Misc", "Movement", "Auto Strafe" ) then
				-- local forward, right = R.Angle.Forward( view ), R.Angle.Right( view )
				-- local fmove, smove = R.CUserCmd.GetForwardMove( cmd ), R.CUserCmd.GetSideMove( cmd )

				-- forward[3] = 0
				-- right[3] = 0

				-- R.Angle.Normalize( forward )
				-- R.Angle.Normalize( right )

				-- local wishvel = G.Vector()

				-- for i = 1, 3 do
				-- 	wishvel[i] = forward[i] * fmove + right[i] * smove
				-- end

				-- local optimalDelta = G.Movement.GetOptimalAirStrafe( R.Vector.Length2D( R.Entity.GetVelocity( G.LocalPlayer() )))

				-- local wishdir = (G.Vector( wishvel[1], wishvel[2], wishvel[3] ):Angle() + (cmd:CommandNumber() % 2 == 0 and 1 or -1 ) * Angle( 0, 13, 0)):Right()
				if !G.Menu.Func.GetVar( "Misc", "Movement", "Omni-Directional Strafing" ) then
					local sideMove = R.ConVar.GetInt( cl_forwardspeed )
					local MouseX = R.CUserCmd.GetMouseX( cmd )
					if MouseX > 0 or MouseX < 0 then
						R.CUserCmd.SetSideMove( cmd, MouseX > 0 and sideMove or -sideMove )
					else
						R.CUserCmd.SetForwardMove( cmd, 5850 / R.Vector.Length2D( R.Entity.GetVelocity( G.LocalPlayer() )))
						R.CUserCmd.SetSideMove( cmd, ( R.CUserCmd.CommandNumber( cmd ) % 2 == 0 ) and -200 or 200 )
					end
				end
			end
		else
			if !G.Menu.Func.GetVar( "Misc", "Fake Angles", "Enabled") and !G.Menu.Func.GetVar( "Misc", "Anti-Aim", "Enabled" ) and G.Menu.Func.GetVar( "Misc", "Fake Angles", "Fake Mode" ) != "Desync" then
				sendPacket(true)
			end

			-- if G.Menu.Func.GetVar( "Misc", "Movement", "Bunny Hop", "Forward Bunny Hop" ) then
			-- 	local velAng = R.Vector.Angle( R.Entity.GetVelocity( G.LocalPlayer() ))
			-- 	local eyeAng = R.CUserCmd.GetViewAngles( cmd )

			-- 	-- local move = R.Entity.GetVelocity( G.LocalPlayer() )
			-- 	-- local speed = G.math.sqrt(move.x * move.x + move.y * move.y)
			-- 	-- local ang = R.Vector.Angle( move )
			-- 	-- local yaw = G.math.rad( ang.y )

			-- 	-- if (( R.CUserCmd.GetViewAngles( cmd ).p + 90 ) % 360 ) > 180 then
			-- 	-- 	yaw = 180 - yaw
			-- 	-- end

			-- 	-- yaw = (( yaw + 180 ) % 360 ) - 180

			-- 	-- local fMove = G.math.cos(yaw) * speed
			-- 	-- local sMove = G.math.sin(yaw) * speed

			-- 	if G.math.abs(velAng.y - eyeAng.y) > 90 then
			-- 		R.CUserCmd.SetForwardMove( cmd, -10000 )
			-- 		R.CUserCmd.SetViewAngles( cmd, velAng)
			-- 	else
			-- 		R.CUserCmd.SetForwardMove( cmd, 10000 )
			-- 		R.CUserCmd.SetViewAngles( cmd, velAng )
			-- 	end

			-- 	-- R.CUserCmd.SetSideMove( cmd, sMove )
			-- end

			G.CFunc.SetOutSequenceNr( 0 )
		end
	end
end

local function FixMovement( cmd, old ) -- pasted from https://www.unknowncheats.me/forum/2668715-post8.html
	if G.Menu.Func.GetVar("Misc", "Movement", "Fix Movement") == "Off" then return end

	local currentAngle = R.CUserCmd.GetViewAngles( cmd )
	local oldAngle = old

	if currentAngle.x <= 90 and currentAngle.x >= -90 then
		currentAngle.x = 0 
		oldAngle.x = 0
	end

	local vecCurForward = R.Angle.Forward(currentAngle)
	local vecCurRight = R.Angle.Right(currentAngle)

	vecCurForward:Normalize()
	vecCurRight:Normalize()

	local flDenom = vecCurForward.y - (vecCurRight.y / vecCurRight.x) * vecCurForward.x
	if vecCurRight.x ~= 0 and flDenom ~= 0 then
		local vecWishForward = R.Angle.Forward(oldAngle)
		local vecWishRight = R.Angle.Right(oldAngle)

		vecWishForward:Normalize()
		vecWishRight:Normalize()

		local vecWishVel = G.Vector(
			vecWishForward.x * R.CUserCmd.GetForwardMove( cmd ) + vecWishRight.x * R.CUserCmd.GetSideMove( cmd ), 
			vecWishForward.y * R.CUserCmd.GetForwardMove( cmd ) + vecWishRight.y * R.CUserCmd.GetSideMove( cmd ), 
			0 )		

		R.CUserCmd.SetForwardMove( cmd, (vecWishVel.y - (vecCurRight.y / vecCurRight.x) * vecWishVel.x) / flDenom )
		R.CUserCmd.SetSideMove(cmd, (vecWishVel.x - vecCurForward.x * R.CUserCmd.GetForwardMove( cmd )) / vecCurRight.x)

		if G.Menu.Func.GetVar("Misc", "Movement", "Fix Movement") == "Safe" then
			local fMove = G.math.Round( R.CUserCmd.GetForwardMove( cmd ) )
			local sMove = G.math.Round( R.CUserCmd.GetSideMove( cmd ) )
	
			local maxForward = R.ConVar.GetInt( cl_forwardspeed )
			local maxSide = R.ConVar.GetInt( cl_sidespeed )
	
			fMove = G.math.Clamp( fMove, -maxForward, maxForward )
			sMove = G.math.Clamp( sMove, -maxSide, maxSide )
	
			local fNegative = fMove < 0 and -1 or 1
			local sNegative = sMove < 0 and -1 or 1
	
			fMove = G.math.abs( fMove )
			sMove = G.math.abs( sMove )
	
			fMove = maxForward * .95 > fMove and fMove or maxForward
			sMove = maxSide * .95 > sMove and sMove or maxSide
	
			R.CUserCmd.SetForwardMove( cmd, fMove * fNegative)
			R.CUserCmd.SetSideMove(cmd, sMove * sNegative)
		end
	end
end

local function getDistance(pos1, pos2)
    local dx = pos1.x - pos2.x
	local dy = pos1.y - pos2.y
	return G.math.sqrt ( dx * dx + dy * dy )
end

--[[
local function RotateOBBAboutOrigin(origin, angle, pos, obbang)
	local localPos = pos - origin

	local newOBBang = G.Angle(obbang[1], obbang[2], obbang[3])
	R.Angle.RotateAroundAxis(newOBBang, R.Vector.GetNormalized(localPos), angle.y)
	R.Vector.Rotate(localPos, angle)

	local retvec = localPos + origin --- diff
	retvec.z = pos.z

	return retvec, newOBBang
end

	local headbone = R.Entity.LookupBone( v, "ValveBiped.Bip01_Head1" )

	if !headbone then return end

	local pos, ang = G.util.GetBonePosition(v, headbone)

newPos, newAng = RotateOBBAboutOrigin(player_origin, G.Angle(0, yawMax, 0), pos, ang)
]]

local function Freestand(  )

	local targetang = Adaptive(2)

	if !targetang then
		targetang = Adaptive(1)

		if !targetang then -- this is here just incase
			return G.Menu.Func.GetVar("HvH", "Real Angles", "Real Yaw")
		end
	end

	return G.math.NormalizeAngle(targetang.ang.y + 180)
	-- local plyr = me()

	-- local headbone = R.Entity.LookupBone( plyr, "ValveBiped.Bip01_Head1" )

	-- if !headbone then return nil end

	-- local pos, ang = G.util.GetBonePosition( plyr, headbone)

	-- local player_origin = R.Entity.GetPos( plyr )

	-- local newPos, newAng = RotateOBBAboutOrigin(player_origin, G.Angle(0, 90, 0), pos, ang)

	-- return newPos, newAng

end


-- local function AngRenderTest()
-- 	local plyr = me()

-- 	local headbone = R.Entity.LookupBone( plyr, "ValveBiped.Bip01_Head1" )

-- 	if !headbone then return nil end

-- 	local pos, ang = G.util.GetBonePosition( plyr, headbone)

-- 	G.cam.Start3D()
-- 		twodeepos = R.Vector.ToScreen( pos )
-- 	G.cam.End3D()

-- 	G.surface.SetDrawColor(0, 255, 0)
-- 	G.surface.DrawRect(twodeepos.x - 3, twodeepos.y - 3, 6, 6)


-- 	--[[
-- 	G.surface.SetDrawColor(0, 255, 0)
-- 	G.surface.DrawRect(pos.x - 3, pos.y - 3, 6, 6)

-- 	G.cam.Start3D()
-- 				pos = R.Vector.ToScreen( tab.pos )
-- 			G.cam.End3D()
-- 	]]
-- end



--G.TimeSinceLastShift = 0

G.AttackLastTick = false
local function doRapidFire( cmd )
	local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )

	if !G.IsValid( wep ) or !sendingPacket then return end

	if G.Menu.Func.GetVar("Misc", "Other", "Rapid Fire") and (R.CUserCmd.KeyDown( cmd, G.IN_ATTACK ) or R.CUserCmd.KeyDown( cmd, G.IN_ATTACK2 ))
		and R.Entity.GetClass( wep ) != "weapon_physgun" and !R.Weapon.IsScripted( wep ) and !G.AttackLastTick then

		G.CFunc.SetOutSequenceNr( G.math.floor( 1 / G.engine.TickInterval() ) - 1 )
		sendPacket( true )
	end

	G.AttackLastTick = R.CUserCmd.KeyDown( cmd, G.IN_ATTACK ) or R.CUserCmd.KeyDown( cmd, G.IN_ATTACK2 )
end

G.ReloadLastTick = false
G.FinishFastReload = false
local function doFastReload( cmd )
	local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )

	if !G.IsValid( wep ) or !sendingPacket then return end



	if G.Menu.Func.GetVar("Misc", "Other", "Fast Reload") and R.CUserCmd.KeyDown( cmd, G.IN_RELOAD ) and !wep.IsTFAWeapon and R.Entity.GetClass( wep ) != "weapon_physgun" and !G.ReloadLastTick then
		local shiftTime = G.ServerTime - R.Weapon.LastShootTime( wep )

		shiftTime = G.math.Clamp( shiftTime, 0, 1 )

		G.CFunc.SetOutSequenceNr( G.math.floor( shiftTime / G.engine.TickInterval() ) - 1 )
		sendPacket( true )
	end



	--R.Weapon.GetActivity( wep ) == G.ACT_RELOAD

	G.ReloadLastTick = R.CUserCmd.KeyDown( cmd, G.IN_RELOAD )
end

G.PrevWep = nil
local function doFastWepSwitch(cmd)
	local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )

	if !G.IsValid( wep ) or !sendingPacket then return end

	if G.PrevWep == nil then
		G.PrevWep = wep
		return
	end

	if G.Menu.Func.GetVar("Misc", "Other", "Fast Weapon Swap") and G.PrevWep != wep then

		G.CFunc.SetOutSequenceNr( G.math.floor( 1 / G.engine.TickInterval() ) - 1 )
		sendPacket( true )
		G.FakeLagEnabled = false
	end

	G.PrevWep = wep

end

local ropes = {
	"effects/rainbow_curl",
	--"pp/morph/refract",
	--"pp/sunbeams",
	"effects/particle_glow_05_nodepth",
	--"sprites/physcannon_bluecore1",
	--"pp/texturize",
	--"debug/debugportals",
	"pp/toytown-top",
	--"sprites/orangelight1_noz",
	"effects/bonk",
	"effects/moon",
	--"sprites/autoaim_1a",
	--"particle/tinyfiresprites/tinyfiresprites",
	--"particle/water/watersplash_001a_additive",
	"shadertest/cubemapdemo",
	--"models/spawn_effect",
	--"trails/tube"
	"models/weapons/v_toolgun/screen",
	"debug/debugluxels",
	"vgui/spawnmenu/broken"
}

local function RopeSpam( cmd ) -- CreateMove
	-- if R.Player.KeyDown( G.LocalPlayer(), 1 ) and G.IsValid( R.Player.GetActiveWeapon( G.LocalPlayer() )) then
	-- 	R.CUserCmd.RemoveKey( cmd, 1 )
	-- end


	if G.Menu.Func.GetVar( "Misc", "Spammers", "Rope Spam" ) then
		-- local Wep = R.Player.GetActiveWeapon(ent)
		-- if !G.IsValid(Wep) 
		R.CUserCmd.SetViewAngles( cmd, G.Angle( G.math.Rand( -45, 10 ), G.math.Rand( -360, 360 ), 0 ) )
		R.ConVar.SetString( G.GetConVar( "rope_material" ), G.table.Random( ropes ) )

		if R.Player.KeyDown( G.LocalPlayer(), 2048 )  then
			R.CUserCmd.RemoveKey( cmd, 2048 )
		end
		return true
	end
	return false
end


-- local crowbar = LocalPlayer():GetWeapon( "weapon_crowbar" )
-- local ar2 = LocalPlayer():GetWeapon( "weapon_ar2" )
-- local function crimWalk( cmd )
-- 	local cmdn = cmd:CommandNumber()
-- 	if cmdn == 0 then return end

-- 	pSetFuckery( 6 )

-- 	if cmdn % 3 == 0 then
-- 		cmd:SelectWeapon(crowbar)
-- 		cmd:SetViewAngles(Angle(89, 0, 0))
-- 	else
-- 		cmd:SelectWeapon(ar2)
-- 		cmd:SetViewAngles(Angle(0, 0, 0))
-- 	end
-- end


local function legitBackTrack( cmd, view )
	local aimPos = R.Player.GetShootPos( G.LocalPlayer() )
	local aimAng = R.Entity.EyeAngles( G.LocalPlayer() ) -- REPLACE WITH THE ANGLE OF THE BULLET

	if !G.Menu.Func.GetVar("Aimbot", "Accuracy", "No Spread") then
		aimAng = aimAng * 2 - G.Aimbot.PredictSpread( cmd, aimAng )
	end

	local bestTick = 0
	local bestAvgDelta = 10000

	for pid, _ in G.pairs(G.TickCopies) do
		for tick, tab in G.pairs( G.TickCopies[pid] ) do
			if !tab.pos then return end
			local ang = R.Vector.Angle( tab.pos - aimPos )

			local avgDelta = (G.math.abs( G.math.NormalizeAngle( aimAng.y - ang.y )) + G.math.abs( G.math.NormalizeAngle( aimAng.x - ang.x ))) * 0.5
			if avgDelta < bestAvgDelta then
				bestTick = tick
				bestAvgDelta = avgDelta
			end
		end
	end

	if bestTick != 0 then
		local timeBack = TICKS_TO_TIME( G.currentTick - bestTick ) -- + G.CFunc.GetLatency( 0 )

		if timeBack > .2 then
			local interp = TICKS_TO_TIME(TIME_TO_TICKS(timeBack))

			if interp > 1 then return end

			set_cl_interp = true
			setInterp( interp )
			lastInterp = interp
		else
			G.CFunc.SetTickCount( cmd, bestTick )
		end
	end
end

local count = 0

G.RestoreAngles = G.Angle( 0, 0, 0 )
local restoredView = false
G.NeedToAnimate = false
G.LastEyeAngle = G.Angle( 0, 0, 0 )
G.LastSentEyeAngle = G.Angle( 0, 0, 0 )
G.ServerBoneMatrix = nil
G.ClientBoneMatrix = nil
G.ClientSendBoneMatrix = nil
G.anti_aim = {
	Shooting = false,
	fakelag_count = G.CFunc.GetChokedPackets(),
	max_choke = 0,
	cur_choke = 0,
	FakeLagEnabled = false,
	FakeLagAmount = 0,
	FakeLagType = "Static",
	FakeAnglesEnabled = false,
	JitterDir = 0,
	SequenceFreezing = false,
	FakeDucking = false,
}

G.anti_aim.GetDuckHeight = function()
	
end

G.anti_aim.AdaptChoke = function(ticks)
	local tick_interval = (1 / G.engine.TickInterval())

	local flPercent = ticks/64
	local desiredLagAmm = G.math.floor(flPercent * tick_interval)
	if desiredLagAmm < 1 then
		desiredLagAmm = 1
	end
	-- print(ticks, desiredLagAmm, "\n", tick_interval, "\n", flPercent)

	return desiredLagAmm
end

local animStateCreated = false
local lastTick = 0
local lastPosition = Vector(0,0,0)
local function CMove( cmd ) -- CreateMove

	-- local third = G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person")

	-- if lastChoked ~= nil and lastChoked > G.CFunc.GetChokedPackets() then
	-- 	G.print(lastChoked)
	-- end
	-- lastChoked = G.CFunc.GetChokedPackets()

	if G.Menu.Func.GetVar("Aimbot", "Legit Settings", "Triggerbot Enabled               (M5)") and G.input.IsMouseDown( G.MOUSE_5 ) then
		local tr = {
			start = R.Player.GetShootPos(G.LocalPlayer()),
			endpos = R.Player.GetShootPos(G.LocalPlayer()) + (R.Player.GetAimVector(G.LocalPlayer()) * 8000),
			filter = G.LocalPlayer(),
			mask = 1174421507 -- #define	MASK_SHOT
		}
		
		local trace = G.util.TraceLine(tr)
		if trace.Entity and trace.Entity:IsPlayer() and R.Player.GetFriendStatus(trace.Entity) != "friend" then
			R.CUserCmd.SetButtons(cmd, bit.bor(R.CUserCmd.GetButtons(cmd), 1))
		end
	end

	if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Silent Aim") and !restoredView and getaimkey() then

		R.CUserCmd.SetViewAngles( cmd, G.RestoreAngles )

		restoredView = true
	end

	if R.CUserCmd.CommandNumber( cmd ) == 0 then 
		return
	end

	G.ServerTime = R.Entity.GetInternalVariable(G.LocalPlayer(), "m_nTickBase") * G.engine.TickInterval()
	G.anti_aim.Shooting = R.CUserCmd.KeyDown( cmd, G.IN_ATTACK )

	-- local skipAimbot = false
	G.currentTick = R.CUserCmd.TickCount( cmd )
	backtrackAmount = G.math.floor( 1 / G.engine.TickInterval()) - 1
	lagForgiveness = 10000
	for k, v in G.ipairs( G.player.GetAll() ) do
		if v == G.LocalPlayer() then continue end
		local pid, tick = R.Player.UserID( v ), G.currentTick
		if !G.IsValid( v ) or !R.Player.Alive(v) then G.TickCopies[pid] = nil end

		if !G.TickCopies[pid] then
			G.TickCopies[pid] = {}
		else
			local min = G.currentTick - backtrackAmount
			for w, a in G.pairs( G.TickCopies[pid] ) do
				if w < min then
					G.TickCopies[pid][w] = nil
				end
			end
		end

		G.TickCopies[pid][tick - (backtrackAmount + 1)] = nil

		if R.Entity.IsDormant(v) then continue end

		local DrawBones = {}
		if G.Menu.Func.GetVar("Visuals", "ESP", "Skeleton")[1] then
			for i = 1, R.Entity.GetBoneCount(v) do
				local Parent = R.Entity.GetBoneParent(v, i)
				if (Parent == -1) then 
					continue
				end
				local FirstBone, SecondBone = R.Entity.GetBonePosition(v, i), R.Entity.GetBonePosition(v, Parent)
				if (R.Entity.GetPos( v )== FirstBone) then 
					continue
				end
				table.insert(DrawBones, {FirstBone, SecondBone})
			end
		end

		G.TickCopies[pid][tick] = {
			pos = G.Aimbot.TargetPos( v ),
			head = nil,
			origin = R.Entity.GetNetworkOrigin( v ),
			isShooting = false,
			used = false,
			angle = R.Entity.EyeAngles( v ),
			simtime = G.CFunc.GetNetVarFloat(v, "DT_BaseEntity", "m_flSimulationTime"),
			choked = 0,
			BoneMatrix = G.util.GetBoneMatrix( v ),
			DrawBones = DrawBones
		}

		if G.Menu.Func.GetVar("Aimbot", "Rage Settings", "On-Shot Backtrack") and R.Entity.GetModel( v ) != "models/error.mdl" and G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Aimbot Target") != "Head" then
			G.TickCopies[pid][tick].head = G.Aimbot.TargetPos( v, true )
		end

		if G.TickCopies[pid][tick-1] then
			G.TickCopies[pid][tick]["usable"] = G.Aimbot.LagCompensated( G.TickCopies[pid][tick-1].origin, G.TickCopies[pid][tick].origin )

			if G.TickCopies[pid][tick-1].simtime == G.TickCopies[pid][tick].simtime then
				G.TickCopies[pid][tick].choked = G.TickCopies[pid][tick-1].choked + 1
			end

			if G.TickCopies[pid][tick].choked < lagForgiveness then
				lagForgiveness = G.TickCopies[pid][tick].choked
			end

			if G.TickCopies[pid][tick]["usable"] == false then
				for r = G.currentTick - backtrackAmount, G.currentTick do
					if G.TickCopies[pid][r] then
						G.TickCopies[pid][r].usable = false
					end
				end
			end
		end
	end

	local view = R.CUserCmd.GetViewAngles( cmd )
	R.Angle.Set( G.RestoreAngles, view )

	

	--
	-- if !R.Player.Alive(G.LocalPlayer()) then return end

	G.anti_aim.SequenceFreezing = false
	if G.input.IsKeyDown( G.KEY_Z ) and G.Menu.Func.GetVar("Misc", "Other", "Air Stuck (Z)") then
		G.anti_aim.SequenceFreezing = true
		sendPacket( true )
		if G.CFunc.GetChokedPackets() == 0 then
			G.CFunc.SetOutSequenceNr( 400 )
		end
	elseif G.input.IsKeyDown( G.KEY_X ) and G.Menu.Func.GetVar("Misc", "Other", "Sequence Freezing (X)") then
		G.anti_aim.SequenceFreezing = true
		sendPacket( true )
		

		local amount
		if G.Menu.Func.GetVar("Misc", "Other", "Sequence Freeze Mode") == "Sine" then
			local min = 1 / G.engine.TickInterval() * .75
			local max = 1 / G.engine.TickInterval() * .85
			local diff = max - min
			amount = G.math.floor( G.math.abs( G.math.sin( R.CUserCmd.CommandNumber( cmd )) * diff )) + min
		elseif G.Menu.Func.GetVar("Misc", "Other", "Sequence Freeze Mode") == "Static" then
			amount = G.Menu.Func.GetVar("Misc", "Other", "Sequence Freeze Amount")
		elseif G.Menu.Func.GetVar("Misc", "Other", "Sequence Freeze Mode") == "Adaptive" then
			amount = G.anti_aim.AdaptChoke(G.Menu.Func.GetVar("Misc", "Other", "Sequence Freeze Amount"))
		end
		if G.CFunc.GetChokedPackets() == 0 then
			G.CFunc.SetOutSequenceNr( amount )
		end
	end

	if !G.anti_aim.SequenceFreezing then
		doFastWepSwitch( cmd )
		RopeSpam( cmd )
	end

	

	G.anti_aim.FakeDucking = G.input.IsKeyDown( G.KEY_V ) and G.Menu.Func.GetVar("Misc", "Other", "Fake Duck (V)") and R.Entity.IsOnGround( me() ) and !G.anti_aim.SequenceFreezing
	
	G.anti_aim.fakelag_count = G.CFunc.GetChokedPackets()
	if G.anti_aim.fakelag_count == 0 or G.anti_aim.max_choke < G.anti_aim.cur_choke then
        G.anti_aim.max_choke = G.anti_aim.cur_choke
    end
    G.anti_aim.cur_choke = G.anti_aim.fakelag_count

	G.anti_aim.FakeLagEnabled = G.Menu.Func.GetVar("Misc", "Fake Lag", "Enabled") or G.anti_aim.FakeAnglesEnabled or G.anti_aim.FakeDucking 
	G.anti_aim.FakeLagAmount = G.Menu.Func.GetVar("Misc", "Fake Lag", "Max Choke")
	G.anti_aim.FakeLagMode = G.Menu.Func.GetVar("Misc", "Fake Lag", "Fake Lag Mode")
	if G.Menu.Func.GetVar("Misc", "Fake Lag", "Enabled") == false and G.anti_aim.FakeAnglesEnabled then
		G.anti_aim.FakeLagAmount = 3
		G.anti_aim.FakeLagMode = "Adaptive"
	end
	if G.anti_aim.FakeDucking then
		G.anti_aim.FakeLagAmount = G.Menu.Func.GetVar("Misc", "Other", "Fake Duck Choke")
		G.anti_aim.FakeLagMode = "Static"
	end
	
	local FakeDuckCheck = G.anti_aim.FakeDucking and true or ( !G.forceSendPacket and not G.anti_aim.Shooting )

	sendPacket( true )
	if FakeDuckCheck and !G.anti_aim.SequenceFreezing and G.anti_aim.FakeLagEnabled and !R.CUserCmd.KeyDown( cmd, G.IN_USE ) and R.Entity.GetMoveType( me() ) != 9  then

		if G.anti_aim.FakeLagMode == "Static" then
			if (G.anti_aim.fakelag_count < G.anti_aim.FakeLagAmount) then
				sendPacket( false )
			end
		elseif G.anti_aim.FakeLagMode == "Adaptive" then
			if (G.anti_aim.fakelag_count < G.anti_aim.AdaptChoke(G.anti_aim.FakeLagAmount)) then
				sendPacket( false )
			end
		end
	else
		sendPacket( true )
		G.forceSendPacket = false
	end

	
	bhop( cmd, view )
	funnyJiggle( cmd )
	
	-- if G.Menu.Func.GetVar( "HvH", "Desync", "Enable Desync" ) then
	-- 	G.Desync( cmd, view )
	-- end

	if G.anti_aim.FakeDucking then
		if G.CFunc.GetChokedPackets() > G.anti_aim.FakeLagAmount/2 then
			R.CUserCmd.SetButtons( cmd, bit.bor( IN_DUCK, R.CUserCmd.GetButtons( cmd )))
		end
	end

	G.anti_aim.FakeAnglesEnabled = false
	if !R.CUserCmd.KeyDown( cmd, G.IN_USE ) and not G.anti_aim.Shooting then
		if G.Menu.Func.GetVar("Misc", "Anti-Aim", "Enabled") then
			G.doAntiAim( cmd, view, sendingPacket )
			if G.anti_aim.SequenceFreezing then
				G.anti_aim.FakeAnglesEnabled = false
			end
		end
	end
	--]]
	
	if sendingPacket and cl_interp != 0 and set_cl_interp then setInterp( 0 ) set_cl_interp = false end
	-- if !skipAimbot then

	G.CFunc.StartPrediction( G.LocalPlayer(), cmd )

			G.forceSendPacket = aimbot( cmd, view )

		if G.Menu.Func.GetVar( "Aimbot", "Accuracy", "No Spread" ) and G.input.IsMouseDown( G.MOUSE_LEFT ) and R.CUserCmd.KeyDown( cmd, G.IN_ATTACK ) then
			R.CUserCmd.SetViewAngles( cmd, G.Aimbot.PredictSpread( cmd, view ))
			G.forceSendPacket = true
		end

		if G.Menu.Func.GetVar( "Aimbot", "Legit Settings", "Legit Backtrack" ) and G.input.IsMouseDown( G.MOUSE_LEFT ) and R.CUserCmd.KeyDown( cmd, G.IN_ATTACK ) and G.CanShoot() then
			legitBackTrack( cmd )
		end
	G.CFunc.EndPrediction( G.LocalPlayer(), cmd )
		-- end

	if G.forceSendPacket and !G.anti_aim.FakeDucking then
		sendPacket(true)
	end

	doRapidFire( cmd )
	doFastReload( cmd )

	

	local postView = R.CUserCmd.GetViewAngles( cmd )

	if postView.x != view.x or postView.y != view.y and G.Menu.Func.GetVar("Aimbot", "Rage Settings", "Silent Aim") then
		restoredView = false
		FixMovement( cmd, view, false )
	end

	if (G.LastEyeAngle) then -- for CW2 shit
		G.ViewAff = !G.ViewAff and 0 or
			G.Lerp(G.engine.TickInterval() * 10,
			G.ViewAff > 1 and 1 or G.ViewAff,
			R.Vector.Length(R.Angle.Forward(R.CUserCmd.GetViewAngles(cmd)) - R.Angle.Forward(G.LastEyeAngle)) * 0.5)
	end

	G.LastEyeAngle = R.CUserCmd.GetViewAngles( cmd )

	if sendingPacket then
		G.LastSentEyeAngle = R.CUserCmd.GetViewAngles( cmd )
	end

	if !animStateCreated and G.LocalPlayer() then
		G.ServerAnimState = G.CMultiplayerAnimState.new( G.LocalPlayer() )
		G.ClientAnimState = G.CMultiplayerAnimState.new( G.LocalPlayer() )
		animStateCreated = true
	end

	if animStateCreated then
		-- R.Entity.SetPlaybackRate( G.LocalPlayer(), 1.0 )
		-- R.Entity.InvalidateBoneCache( G.LocalPlayer() )
		-- R.Entity.SetupBones( G.LocalPlayer() )

		if G.ServerAnimState.m_pPoseParams then
			for k, v in G.pairs( G.ServerAnimState.m_pPoseParams ) do
				R.Entity.SetPoseParameter( G.LocalPlayer(), k, v )
			end
		end

		-- Update the server bone matrix
		G.ServerAnimState:Update( G.LastEyeAngle.y, G.LastEyeAngle.p )

		-- Do the things for the server
		if G.ServerAnimState.m_pPoseParams then
			for k, v in G.pairs( G.ServerAnimState.m_pPoseParams ) do
				R.Entity.SetPoseParameter( G.LocalPlayer(), k, v )
			end
		end

		if G.ServerAnimState.m_angRender then
			R.Player.SetRenderAngles( G.LocalPlayer(), G.ServerAnimState.m_angRender )
		end

		-- Make sure the bones are all bueno
		R.Entity.InvalidateBoneCache( G.LocalPlayer() )
		R.Entity.SetupBones( G.LocalPlayer() )

		-- If sending packet, update the bone matrix for the server
		if G.CFunc.GetSendPacket() then
			if G.ClientBoneMatrix then
				G.ClientSendBoneMatrix = {G.ClientBoneMatrix[1], G.ClientBoneMatrix[2]}
			end
			G.ServerBoneMatrix = {G.util.GetBoneMatrix( G.LocalPlayer() ), R.Entity.GetPos( G.LocalPlayer() )}
		end

		-- Now do the things for the client
		-- Update the client's bone matrix with the last eye angle sent to the server
		G.ClientAnimState:Update( G.LastSentEyeAngle.y, G.LastSentEyeAngle.p )

		-- Set pose parameters
		if G.ClientAnimState.m_pPoseParams then
			for k, v in G.pairs( G.ClientAnimState.m_pPoseParams ) do
				R.Entity.SetPoseParameter( G.LocalPlayer(), k, v )
			end
		end

		-- Set render angles
		if G.ClientAnimState.m_angRender then
			R.Player.SetRenderAngles( G.LocalPlayer(), G.ClientAnimState.m_angRender )
		end

		-- Make sure the bones are all bueno
		R.Entity.InvalidateBoneCache( G.LocalPlayer() )
		R.Entity.SetupBones( G.LocalPlayer() )

		-- Save for later use
		G.ClientBoneMatrix = {G.util.GetBoneMatrix( G.LocalPlayer() ), R.Entity.GetPos( G.LocalPlayer() )}
	end

	G.NeedToAnimate = true
	-- if animStateCreated then
	-- 	G.CMultiplayerAnimState.Update( 1, eyeang.y, eyeang.p )
	-- end

	if G.CFunc.GetSendPacket() and lastTick ~= R.CUserCmd.TickCount( cmd ) then
		local dist = R.Vector.DistToSqr(R.Entity.GetPos( G.LocalPlayer() ), lastPosition)

		if dist > 4096 then
			G.brokeLagComp = true
		else 
			G.brokeLagComp = false
		end

		--G.print(G.tostring(G.CFunc.GetSendPacket()) .. " " .. G.tostring(dist))
		
		lastPosition = R.Entity.GetPos( G.LocalPlayer() )
		lastTick = R.CUserCmd.TickCount( cmd )
	end
end

G.settings.DRAWBACKTRACK = false
local function drawBackTrack()
	if G.hideOverlay then return end
	for k, v in G.pairs(G.TickCopies) do
		if !R.ConVar.GetBool( G.settings.DRAWBACKTRACK ) then break end
		local ply = G.Player(k)
		if !G.IsValid(ply) then
			G.TickCopies[k] = nil
			continue
		end

		local pos
		for tick, tab in G.pairs(v) do
			if !tab.pos then continue end

			G.cam.Start3D()
				pos = R.Vector.ToScreen( tab.pos )
			G.cam.End3D()

			-- if hits[tick] then
			-- 	G.surface.SetDrawColor(0,255,0)
			-- 	--return true
			-- else
			if tab.isShooting then

				if tab.head then
					local hpos
					G.cam.Start3D()
						hpos = R.Vector.ToScreen( tab.head )
					G.cam.End3D()
					
					if tab.used then
						G.surface.SetDrawColor(0, 255, 255)
					else
						G.surface.SetDrawColor(255, 255, 0)
					end
					G.surface.DrawRect(hpos.x - 3, hpos.y - 3, 6, 6)
				end

				G.surface.SetDrawColor(0, 255, 0)
			elseif tab.usable then
				G.surface.SetDrawColor(0, 0, 255)
			else
				G.surface.SetDrawColor(255, 0, 0)
			end

			-- 	--return false
			-- end

			G.surface.DrawRect(pos.x - 3, pos.y - 3, 6, 6)
		end

		-- G.surface.SetDrawColor(255, 0, 255)

	end

	-- for k, v in G.pairs( G.player.GetAll() ) do
	-- 	for tick = 1, 60 do
	-- 		G.Aimbot.VelocityPrediction(  )
	-- 	end
	-- end
end

local Editor = {}
local vecZero = G.Vector(0, 0, 0)
local displaceView = G.Vector( 0, 0, 0)
local prevOrigin = G.Vector( 0, 0, 0 )
local togglePrevious = false
local fov_desired = G.GetConVar_Internal( "fov_desired" )
G.thirdperson_toggled = false
G.thirdperson_just_toggled = false
G.do_thirdperson = true

fov_changer = function( tab, ply, pos, ang, fov, znear, zfar ) -- CalcView
	G.MyEyeAngle = ang
	G.MyEyePos = pos
	if !G.IsValid( ply ) then return tab end
	if G.IsValid( R.Player.GetActiveWeapon( ply )) and R.Entity.GetClass( R.Player.GetActiveWeapon( ply )) == "gmod_camera" then return tab end

	-- if G.string.find( R.Entity.GetClass( R.Player.GetActiveWeapon( ply )), "m9k" ) and R.Player.KeyDown( ply, IN_ATTACK2 )
	-- 	or ( R.Entity.GetClass( R.Player.GetActiveWeapon( ply )) == "gmod_camera" )
	-- 	or ( R.Player.IsPlayingTaunt( ply ) ) then return end

	-- tab.znear = znear
	if G.Menu.Func.GetVar("Visuals", "View Mods", "Disable Draw Distance") then
		tab.zfar = tab.zfar and tab.zfar * 50 or zfar * 50
	end

	local mult = 300 * G.FrameTime()

	if !G.gui.IsGameUIVisible() then
		if G.input.IsKeyDown( G.KEY_UP ) then
			if prevOrigin == vecZero then
				prevOrigin = pos
			end
			prevAng = ang
			togglePrevious = false
			displaceView = displaceView + R.Angle.Forward( ang ) * mult
		end

		if G.input.IsKeyDown( G.KEY_DOWN ) then
			displaceView = vecZero
			prevOrigin = vecZero
		end

		if G.input.IsKeyDown( G.KEY_LEFT ) then
			togglePrevious = true
		end

		if G.input.IsKeyDown( G.KEY_RIGHT ) then
			togglePrevious = false
		end
	end

	if togglePrevious == true then
		tab.origin = pos
		tab.angles = R.Entity.EyeAngles( ply )
	elseif displaceView != vecZero then
		tab.origin = prevOrigin + displaceView
		tab.drawviewer = true
		-- tab.angles = prevAng -- locks in place
	end

	if G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person") then
		if G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person On Key") then

			if G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person Key") == "M3" then
				if G.input.IsMouseDown( G.MOUSE_MIDDLE ) then 
					if !G.thirdperson_just_toggled then 
						G.thirdperson_toggled = !G.thirdperson_toggled
						G.thirdperson_just_toggled = true
					 end
				else
					G.thirdperson_just_toggled = false
				end
			elseif G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person Key") == "V" then
				if G.input.IsKeyDown( G.KEY_V) then 
					if !G.thirdperson_just_toggled then 
						G.thirdperson_toggled = !G.thirdperson_toggled
						G.thirdperson_just_toggled = true
					 end
				else
					G.thirdperson_just_toggled = false
				end
			end

			if G.thirdperson_toggled then
				G.do_thirdperson = true
			else
				G.do_thirdperson = false
			end
		else
			G.do_thirdperson = true
		end

		if G.do_thirdperson then

			local height = R.Entity.GetPos( ply )
			height.z = height.z + 72

			if Editor.DelayPos == nil then
				Editor.DelayPos = height
			end

			if Editor.ViewPos == nil then
				Editor.ViewPos = height -- R.Entity.EyePos( ply )
			end

			Editor.DelayFov = fov
			local Forward = G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person Distance")
			local Up = 0
			local Right = 0--G.Menu.Func.GetVar("Visuals", "View Mods", "Third Person X Offset")
			local Pitch = 0
			local Yaw = 0

			-- if G.Menu.Func.GetVar("Aimbot", "Aimbot Settings", "Silent Aim") then ang = G.fakeView end

			ang.p = ang.p + Pitch
			ang.y = ang.y + Yaw

			Editor.DelayPos = height

			local traceData = {}
			traceData.start = Editor.DelayPos
			traceData.endpos = traceData.start + R.Angle.Forward(ang) * -Forward
			traceData.endpos = traceData.endpos + R.Angle.Right(ang) * Right
			traceData.endpos = traceData.endpos + R.Angle.Up( ang ) * Up
			traceData.filter = ply

			local trace = G.util.TraceLine(traceData)
			pos = trace.HitPos

			if trace.Fraction < 1.0 then
				pos = pos + trace.HitNormal * 5
			end

			tab.origin = pos
			tab.drawviewer = true
		else
			tab.drawviewer = false
		end
	-- else
	-- 	
	end

	if !R.Player.InVehicle( G.LocalPlayer() ) and G.Menu.Func.GetVar("Visuals", "View Mods", "No Visual Recoil") then
		tab.angles = R.Entity.EyeAngles( G.LocalPlayer() )
	end

	if G.Menu.Func.GetVar("Visuals", "View Mods", "Custom FOV") then
		if G.Menu.Func.GetVar("Visuals", "View Mods", "Always Force FOV" ) then
			tab.fov = G.Menu.Func.GetVar("Visuals", "View Mods", "Field of View")
		else
			tab.fov = tab.fov or G.Menu.Func.GetVar("Visuals", "View Mods", "Field of View")
		end

		local dFov = R.ConVar.GetInt( fov_desired )
		if tab.fov >= dFov - 5 or tab.fov == dFov then
			tab.fov = G.Menu.Func.GetVar("Visuals", "View Mods", "Field of View")
		end
	end
	-- tab.fov = G.Menu.Func.GetVar("Visuals", "View Mods", "Field of View")

	G.MyEyeAngle = tab.angles
	G.MyEyePos = tab.origin and tab.origin or pos

	return tab
end

local backthen = G.SysTime()
local c = {}
local counter = 0
local function infinitetrack()
	if counter > 10 then

		G.debug.sethook()

		counter = 0

		G.print("INFINITE LOOP DETECTED!")

		local calls = {}
		local prev
		for k,v in G.pairs(c) do
			local line = G.tostring(v.func) .. "\t line: \t" .. G.tostring( v.currentline )
			if prev == line then
				prev = line
				line = "^"
			else
				prev = line
			end
			calls[k] = k .. ": \t" .. line
		end

		c = {}
		G.error("Time limit exceeded",2)
	end

	counter = counter + 1
	local info = G.debug.getinfo(2)

	if info then G.table.insert(c,info) end
end

local function f()
	if G.SysTime() - backthen > 7 then -- enjoy your 7 second freeze
		counter = 0
		G.debug.sethook( infinitetrack, "", 1 )
	end
end

local function detector()
	backthen = G.SysTime()
	G.debug.sethook( f, "", 2^25 )
end

-- local function attack()
-- 	G.RunConsoleCommand("+attack")
-- end

-- local function attack2()
-- 	G.RunConsoleCommand("-attack")
-- end

-- local function Turn()
-- 	R.Player.SetEyeAngles( G.LocalPlayer(), R.Entity.EyeAngles( G.LocalPlayer() ) - G.Angle( 0, 10, 0 ))
-- end

-- local function TurnBack()
-- 	R.Player.SetEyeAngles( G.LocalPlayer(), R.Entity.EyeAngles( G.LocalPlayer() ) - G.Angle( 0, 180, 0 ))
-- end

-- local function MagnetoThrow() -- AKA THE UGLIEST SHIT I'VE EVER PASTED
-- -- Nice and easy, turn it slow 180 
-- 	G.timer.Simple( .02, Turn )
-- 	G.timer.Simple( .04, Turn )
-- 	G.timer.Simple( .06, Turn )
-- 	G.timer.Simple( .08, Turn )
-- 	G.timer.Simple( .10, Turn )
-- 	G.timer.Simple( .12, Turn )
-- 	G.timer.Simple( .14, Turn )
-- 	G.timer.Simple( .16, Turn )
-- 	G.timer.Simple( .18, Turn )
-- 	G.timer.Simple( .20, Turn )
-- 	G.timer.Simple( .22, Turn )
-- 	G.timer.Simple( .24, Turn )
-- 	G.timer.Simple( .26, Turn )
-- 	G.timer.Simple( .28, Turn )
-- 	G.timer.Simple( .30, Turn )
-- 	G.timer.Simple( .32, Turn )
-- 	G.timer.Simple( .34, Turn )
-- 	G.timer.Simple( .36, Turn )
-- 	-- OH MY GOD WHIP AROUND 180
-- 	G.timer.Simple( .46, TurnBack )
-- 	-- And deliver the final blow by pressing right click
-- 	G.timer.Simple( .7, attack )
-- 	G.timer.Simple( .72, attack2 )
-- end



-- Name Changing function 
local function setSteamName( _, _, _, name )
	G.CFunc.SetConVar( "name", G.tostring( name ))
end

local function setNewLineName( _, _, _, name )
	G.CFunc.SetConVar( "name",  G.string.rep("\n", 10) ..  G.tostring( name ) )
end

local function setSpamName( _, _, _, name )
	G.CFunc.SetConVar( "name", G.string.rep( G.tostring( name ).. "\n" , 9 ) .. G.tostring ( name ) ) -- a little bit gay i know but its whatever
end

local function testbug( _, _, _, name )       
	G.print(name)     
	net.Start("MapVoteUpdate")
	net.WriteString(name)
	net.SendToServer()
end

-- // SPAMMER FOR ROPES // -- (from MS)

G.Encoding = {}

function G.util.decimalToBase85(num)
	local base = 85
	local final = {}

	while num > 0 do
		G.table.insert(final, 1, num % base)
		num = G.math.floor(num / base)
	end

	while #final < 5 do
		G.table.insert(final, 1, 0)
	end

	return final
end

function G.util.base85ToDecimal(b85)
	local base = 85
	local l = #b85
	local final = 0

	for i = l, 1, -1 do
		local digit = b85[i]
		local val = digit * base ^ (l - i)
		final = final + val
	end

	return final
end

function G.util.decimalToBinary(num)
	local base = 2
	local final = ""

	while num > 0 do
		final = "" .. (num % base) .. final
		num = G.math.floor(num / base)
	end

	local l = G.string.len(final)

	if l == 0 then
		final = "0" .. final
	end

	while G.string.len(final) % 8 != 0 do
		final = "0" .. final
	end

	return final
end

function G.util.binaryToDecimal(bin)
	local base = 2
	local l = G.string.len(bin)
	local final = 0

	for i = l, 1, -1 do
		local digit = G.string.sub(bin, i, i)
		local val = digit * base ^ (l - i)
		final = final + val
	end

	return final
end

local function encode(substr)
	local l = G.string.len(substr)
	local combine = ""

	for i = 1, l do
		local char = G.string.sub(substr, i, i)
		local byte = G.string.byte(char)
		local bin = G.util.decimalToBinary(byte)
		combine = combine .. bin
	end

	local num = G.util.binaryToDecimal(combine)
	local b85 = G.util.decimalToBase85(num)
	local final = ""

	for i = 1, #b85 do
		final = final .. G.string.char( G.tostring(b85[i] + 33) )
	end

	if final == "!!!!!" then
		final = "z"
	end

	return final
end

local function decode(substr)
	local final = ""
	local l = G.string.len(substr)
	local combine = {}

	for i = 1, l do
		local char = G.string.sub(substr, i, i)
		local byte = G.string.byte(char)
		byte = byte - 33
		combine[i] = byte
	end

	local num = G.util.base85ToDecimal(combine)
	local bin = G.util.decimalToBinary(num)

	while G.string.len(bin) < 32 do
		bin = "0" .. bin
	end

	local l = G.string.len(bin)
	local split = 8

	for i = 1, l, split do
		local sub = G.string.sub(bin, i, i + split - 1)
		local byte = G.util.binaryToDecimal(sub)
		local char = G.string.char(G.tostring(byte))
		final = final .. char
	end

	return final
end

function G.Encoding.Base85Encode(str)
	local final = ""
	local noOfZeros = 0

	while G.string.len(str) % 4 != 0 do
		noOfZeros = noOfZeros + 1
		str = str .. "\0"
	end

	local l = G.string.len(str)

	for i = 1, l, 4 do
		local sub = G.string.sub(str, i, i + 3)
		final = final .. encode(sub)
	end

	final = G.string.sub(final, 1, -noOfZeros - 1)
	final = "~" .. final .. "" -- only use if you want padding

	return final
end

function G.Encoding.Base85Decode(str)
	local final = ""
	str = G.string.sub(str, 2, G.string.len(str)) -- only use if you use padding
	str = G.string.gsub(str, "z", "!!!!!")
	local c = 5
	local noOfZeros = 0

	while G.string.len(str) % c != 0 do
		noOfZeros = noOfZeros + 1
		str = str .. "u"
	end

	local l = G.string.len(str)

	for i = 1, l, c do
		local sub = G.string.sub(str, i, i + c - 1)
		final = final .. decode(sub)
	end

	final = G.string.sub(final, 1, -noOfZeros - 1)

	return final
end


G.Cipher = {}

local cipher_offsetct = 512 -- offset curtime()
local cipher_offsetind = 64 -- offset index
local cipher_time = 30 -- how many seconds til the key resets
G.Cipher.Key = G.game.GetIPAddress() .. "_" .. G.game.GetMap() .. "_" .. G.game.MaxPlayers() .. "_" -- implemented CAC crypto funcs
local base64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
function G.util.Base64Decode(data)
	data = G.string.gsub(data, "[^" .. base64chars .. "=]", "")

	return G.string.gsub( G.string.gsub(data, ".", function(x)
		if x == "=" then return "" end
		local r, f = "", (G.string.find(base64chars, x ) - 1)

		for i = 6, 1, -1 do
			r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
		end

		return r
	end), "%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if (#x != 8) then return "" end
		local c = 0

		for i = 1, 8 do
			c = c + (G.string.sub(x, i, i) == "1" and 2 ^ (8 - i) or 0)
		end

		return G.string.char(c)
	end)
end

function G.Cipher.GetKeyBytes(key)
	local keyBytes = {}

	for i = 1, G.string.len(key) do
		keyBytes[i] = G.string.byte(key, i)
	end

	return keyBytes
end

function G.Cipher.Encrypt(str, key)
	local output = {}

	if G.string.len(key) < G.string.len(str) then
		key = G.string.rep( key, G.math.ceil( G.string.len(str) / G.string.len(key) ))
	end

	local keyBytes = G.Cipher.GetKeyBytes(key)

	local carry = 0
	for i = 1, #str do
		local c = G.string.byte(str, i)
		c = G.bit.bxor(c, keyBytes[(i - 1) % G.string.len(key) + 1])
		c = G.bit.bxor(c,(carry + i) % 256)

		output[#output + 1] = G.string.char(c)

		carry = c
	end

	return G.table.concat(output)
end

function G.Cipher.Decrypt(str, key)
	local output = {}
	local carry = 0

	if G.string.len(key) < G.string.len(str) then
		key = G.string.rep( key, G.math.ceil( G.string.len(str) / G.string.len(key) ))
	end

	for i = 1, G.string.len(str) do
		local c = G.string.byte(str, i)
		local nextCarry = c
		c = G.bit.bxor(c, G.string.byte(key,(i - 1) % G.string.len(key) + 1))
		c = G.bit.bxor(c,(carry + i) % 256)

		output[#output + 1] = G.string.char(c)

		carry = nextCarry
	end

	return G.table.concat(output)
end


-- OnChatTab
local function caeChat(text)
	if G.string.sub(text, 0, 1) != "^" then return end

	local prefix = ""

	if G.string.sub(text, 0, 3) == "^//" then
		prefix = "// "
		text = "^" .. G.string.sub(text, 5)
	end

	if G.string.sub(text, 0, 4) == "^/pm" then
		local args = G.string.Explode(" ", text)
		prefix = "/pm " .. G.tostring(args[2]) .. " "
		text = "^" .. G.string.sub(text, G.string.len( prefix ) + 2)
	end

	text = "/" .. text -- padding

	local encoded = ""
	local curtime = G.math.floor(G.CurTime() / cipher_time)
	for i = 1, G.string.len(text) do -- loop thru every character in the text
		local key = curtime + cipher_offsetct -- original key resets every 10 seconds w/ curtime
		key = G.math.floor(key + i^3 + cipher_offsetind)
		key = (curtime % 2 == 0) and G.math.abs(G.math.sin(key) * 20) or G.math.abs(G.math.cos(key) * 20)
		local char = G.string.char(G.bit.bxor(G.string.byte(text[i]), G.math.floor(key)))
		encoded = char .. encoded
	end

	encoded = G.Cipher.Encrypt(encoded, G.Cipher.Key .. R.Player.SteamID64( G.LocalPlayer() ))
	encoded = G.Encoding.Base85Encode(encoded)
	return prefix .. encoded, G.gui.InternalKeyCodeTyped(64)
end


--HOOBLE TRANSLATE
local function HoobSpeak( txt ) -- OnChatTab
	if G.string.EndsWith( txt, "hs" ) then

		local function r( from, to )
			txt = G.string.Replace( txt, from, to )
		end

		txt = G.string.TrimRight( txt, "hs" )
		txt = G.string.lower( txt )

		r("admin", "admen")
		r("hello", "henlo")
		r("ing", "an")
		--r("er", "rer")
		r("cheat", "cheatan")
		r("script", "scriptan")
		r("hacks", "hackans")
		r("god", "overhoob")
		r("jesus", "holy hoob in the sky")
		r("hobo", "hoob")
		r("are cool", "suck dick")
		r("please", "pleas")
		--r("please", "sudo")
		r("attitude", "tude")
		r("player", "playor")
		r("hello", "helo")
		r("hey", "helo")
		r("come here", "to me")
		--r("better than", "more gooder then")
		r("rules", "rulse")
		r("minge", "mimge")
		r("/lh", "local hoob")
		r("/la", "local admen")
		r("/lp", "local playor")
		r(",", "")
		r("'", "")
		r(".", " .")
		--r("")

		return txt
	end
end

-- local neoPrimaryColorSetting = { 23, 147, 209 }
-- local neoSecondaryColorSetting = { 85, 255, 255 }
local function neoFetch()
	local neoForegroundColor = G.Color( 170, 170, 170 )
	local neoPrimaryColor = G.Color( 23, 147, 209 )
	local neoSecondaryColor = G.Color( 85, 255, 255 )

	local function neoPrint( field, text )
		G.MsgC( neoPrimaryColor, field, neoForegroundColor, ": " .. text .. "\n" )
	end

	neoPrint( "Username", R.Player.Nick( G.LocalPlayer() ))
	neoPrint( "Uptime", G.string.ToMinutesSeconds( G.system.AppTime() ))
	neoPrint( "Memory", G.math.floor( G.collectgarbage( "count" ), " KB" ))
	neoPrint( "Server", G.game.GetIPAddress() )
	neoPrint( "Name", G.GetHostName() )
	neoPrint( "Map", G.game.GetMap() )
end

local function fixErrors()
	for k, v in G.pairs( G.player.GetAll() ) do
		if R.Entity.GetModel( v ) == "models/error.mdl" then
			R.Entity.SetModel(v, "models/player/corpse1.mdl")
		end
	end
end

local function getNWstrings()
	for i = 1, 2048 do
		if G.util.NetworkIDToString( i ) == nil then
			break -- end of list
		else
			G.print( i, G.util.NetworkIDToString( i ))
		end
	end
end

local function execute( _, _, _, code )
	local func = G.CompileString( code, G.short_src, false )
	if G.isstring( func ) then G.print( func ) return end
	G.debug.setfenv( func, G )
	local _, err = G.pcall( function() func() end )
	if err then G.print( err ) end
end


local function SpamUse( cmd )
	if R.Player.KeyDown( G.LocalPlayer(), 32 ) and G.Menu.Func.GetVar( "Misc", "Spammers", "Use Spam" ) then
		R.CUserCmd.RemoveKey( cmd, 32 )
	end
end


--[[
{
	Type = "DropDown",
	Label = "Disconnect Key",
	Value = "Always",
	Values = { "Always", "N", "M", "0" },
	Opened = false,
	Centered = true
},
G.input.IsKeyDown( G.KEY_LALT )
]]
local function DisconnectInDanger( cmd )
	if G.Menu.Func.GetVar( "Misc", "Other", "Avoid Arrest") then
		if G.Menu.Func.GetVar( "Misc", "Other", "Avoid Arrest Key") != "Always" then
			if ( G.Menu.Func.GetVar( "Misc", "Other", "Avoid Arrest Key") == "N" and !G.input.IsKeyDown( G.KEY_N ) ) then
				return
			elseif ( G.Menu.Func.GetVar( "Misc", "Other", "Avoid Arrest Key") == "M" and !G.input.IsKeyDown( G.KEY_M ) ) then
				return
			elseif ( G.Menu.Func.GetVar( "Misc", "Other", "Avoid Arrest Key") == "0" and !G.input.IsKeyDown( G.KEY_0 ) ) then
				return
			end
		end
		local should_avoid = false
		for k, ent in G.pairs( G.player.GetAll() ) do
			if ent == G.LocalPlayer() or !G.IsValid( ent ) or !R.Player.Alive( ent ) or R.Entity.IsDormant( ent ) then continue end 

			local wep = R.Player.GetActiveWeapon( ent )

			if G.IsValid( wep ) and !R.Entity.IsDormant( ent ) then
				
				if R.Entity.GetClass( wep ) == "icefuse_baton" then

					if ( R.Vector.Distance( R.Entity.GetPos( ent ), R.Entity.GetPos( LocalPlayer() ) ) < 150 ) then
						should_avoid = true
						
					end

				elseif R.Entity.GetClass( wep ) == "arrest_stick" then
					
					if ( R.Vector.Distance( R.Entity.EyePos( ent ), R.Entity.GetPos( LocalPlayer() ) ) < (wep.stickRange or 90) ) then
						should_avoid = true
						
					end
					
				end
			end
		end

		if should_avoid then
			if G.Menu.Func.GetVar("Misc", "Other", "Avoid Arrest Method") == "Suicide" then
				G.RunConsoleCommand("kill")
			else
				G.RunConsoleCommand("retry")
			end

		end
	end
end

local function SpamClick( cmd )
	if R.Player.KeyDown( G.LocalPlayer(), 1 ) and G.Menu.Func.GetVar( "Misc", "Spammers", "Click Spam" ) then

		if G.Menu.Func.GetVar( "Misc", "Spammers", "Only With Camera" ) then
			local wep = R.Player.GetActiveWeapon( G.LocalPlayer() )
			if G.IsValid( wep ) then
				local wepStr = R.Entity.GetClass( wep )

				-- print(wepStr)
				-- R.CUserCmd.RemoveKey( cmd, 1 )
				if G.tostring(wepStr) == "gmod_camera" then
					R.CUserCmd.RemoveKey( cmd, 1 )
				end
			end

		else
			R.CUserCmd.RemoveKey( cmd, 1 )
		end
		-- R.CUserCmd.RemoveKey( cmd, 2048 )
	end
end

-- local function onEmitSound(s)
-- 	if s.Entity == nil or s.Pos == nil or s.Entity == G.LocalPlayer() or not s.Entity:IsPlayer() then
-- 		return
-- 	end

-- 	s.Pos.y = s.Pos.y + 1

-- 	G.effects.BeamRingPoint( s.Pos, s.Volume * 5, 0, 200, 1, 1, Color( 255, 122, 122, s.Volume * 510 ), {		
-- 		speed=0,
-- 		spread=0,
-- 		delay=0,
-- 		framerate=2,		
-- 		material="sprites/laserbeam"
-- 	} )
-- end

local function wndproc(s)
	G.print(G.string.format("message: %i\twparam: %i\tlparam: %i", 
		s.message,
		s.wparam,
		s.lparam
 	))
end

local function net_Start(s)
	G.print("net_Start ", s)
end

local ghook
local function detourhook()
	ghook = G.rawget( _G, "hook" )

	if ghook.Call != G.string.ToTable then
		G.detour( ghook.Call, G.Lib.Hook.Call, "hook.Call" )
		G.rawset( ghook, "Call", G.Lib.Hook.Call )
	end

	if ghook.Add != G.Lib.Hook.AddGlobal then
		G.detour( ghook.Add, G.Lib.Hook.AddGlobal, "hook.Add" )
		G.rawset( ghook, "Add", G.Lib.Hook.AddGlobal )
	end

	if ghook.Remove != G.Lib.Hook.RemoveGlobal then
		G.detour( ghook.Remove, G.Lib.Hook.RemoveGlobal, "hook.Remove" )
		G.rawset( ghook, "Remove", G.Lib.Hook.RemoveGlobal )
	end

	if ghook.Run != G.Lib.Hook.Run then
		G.detour( ghook.Run, G.Lib.Hook.Run, "hook.Run" )
		G.rawset( ghook, "Run", G.Lib.Hook.Run )
	end

	if ghook.GetTable != G.Lib.Hook.GetGlobalTable then
		G.detour( ghook.GetTable, G.Lib.Hook.GetGlobalTable, "hook.GetTable" )
		G.rawset( ghook, "GetTable", G.Lib.Hook.GetGlobalTable )
	end

	G.debugNotif( "HOOK LIBRARY DETOURED" )

	-- ANCHOR: INSERT HOOKS HERE

	-- TESTSHIT
	--G.Lib.Hook.Add( "HUDPaint", "♕😒ɇû🙇ǲ♷ĥ8☬ǗŗŻÂǏz­⚒g(Uá⚕ĪǫĞADASDASDADA", AngRenderTest )

	-- G.Lib.Hook.Add( "Think", "PXBv~yv.P34*LN%g}}r0NqFmt5]N.1sS", detector )
	-- G.Lib.Hook.Add( "CalcView", "☔ǂż😗,Ĝ🙎Wɉ😩ČȚt😓ǈƠŖÆŚ☂😭😱ǥ😌đ☗", fov_changer )
	G.Lib.Hook.Add( "Think", "jk31h2jk4h123jkgCSDDGADFGADGa243lk51kl6j", G.KeypadThink )
	

	G.Lib.Hook.Add( "HUDPaint", "Cy(r-5M@S)`F[RmKn$Wq=eYYuhJXZ/:u", GetPossibleAdmins )
	-- mG.Lib.Hook.Add( "CreateMove", "#OIh$h#4*,SgxwJ>(3YpD4I-X\"lwpsyv", NoRecoil )
	G.Lib.Hook.Add( "OnChatTab", "Z<k0>^Y]M%xl(nLfG*?4_/5[J4wp(N$?", HoobSpeak )
	-- G.Lib.Hook.Add( "RenderScene", "Y<qf=}c&J5,)E6tJ?z~\"x8\\/.=HJ]\"{W", renderTheScene )
	-- G.Lib.Hook.Add( "PreRender", "#;s:cdB(XDbG\"Wd>CAsur<!Y7'&%L.J}", mitigateSteamOverlayBug)
	G.Lib.Hook.Add( "PostRender", "J`H'A`p&yz^'Uv4z]9yew97U.frV`vvM", fakeSG )
	G.Lib.Hook.Add( "ShutDown", "4fLU%3;Y!?Q`u3G.\"ax}D_PP7'}nS$a[", ShutdownSG )
	-- G.Lib.Hook.Add( "CreateMove", "9FLd{$c:IV#8}&b(\"U):yAgso4Y0~~|M", bhop )
	-- G.Lib.Hook.Add( "OnPlayerChat", "hvkS2H:,\\-^RZ;e?G+uAcknt\"C%rRKUz", caeDecode )
	G.Lib.Hook.Add( "OnChatTab", "pVKh6TNS\"#CxU[{(s%E?cA3H>PU;s{<-", caeChat )

	G.Lib.Hook.Add( "HUDPaint", "♕😒ɇû🙇ǲ♷ĥ8☬ǗŗŻÂǏz­⚒g(Uá⚕ĪǫĞ", drawBackTrack )
	G.Lib.Hook.Add( "CreateMove", "♲ţ´ő😢Ɂå/Œ_😗⚐JôúÊĔ☬Ǆ😝ģĄȗ♇ŴT", CMove )
	G.Lib.Hook.Add( "DoAnimationEvent", "♕Ē6Ú☇Ö⚍Ţ@😦âs⚈😂☜ģ😬⚖nǯ⚊😬⚉OĕƳ", G.DoAnimationEvent )

	G.Lib.Hook.Add( "CreateMove", "$!#^TKLHKQAOasdasdasd$#!LTDPASG~~~!@!$!", G.EntityEsp )
	G.Lib.Hook.Add( "CreateMove", "^!@,AlPHC,04G;fccNJ`1Okl#W@d)?y(", DisconnectInDanger )
	G.Lib.Hook.Add( "CreateMove", "9s9_zh^6^JnYeOVdI@Pr>KibXw+GDnyo", SpamUse )
	G.Lib.Hook.Add( "CreateMove", "m^Z8zJ:4YYW7&s/j,)MhKd'~<A%'//?p", SpamClick ) 
	G.Lib.Hook.Add( "EntityEmitSound", "adsdafsdfgsdfjkuhsuidh", onEmitSound ) 
	--G.Lib.Hook.Add( "WndProc", "jighj9084wujt934w0jdfrlm", wndproc ) 
	--G.Lib.Hook.Add( "net_Start", "jg89sryhug9w4uijhngdksujnsdkljunfkl", net_Start ) 
	-- G.Lib.Hook.Add( "CreateMove", "jy$Fc^33bC}yZ,)T3YvAGd}{-Vofi[t'", SpamMove )
	-- G.Lib.Hook.Add( "ShouldDrawLocalPlayer", "j3h12jk4h12FDASFA)WOERP@FSAVM>?", ShouldDrawLocalPlayer)

	G.debugNotif( "BASE HOOKS LOADED" )
end

local function detourcommand()
	-- G.rawset( ghook, "Call", G.Lib.Hook.Call )
	concommand.GetTable = fakeConcommandTable
	G.detour( G.concommand.GetTable, fakeConcommandTable, "concommand.GetTable" )

	concommand.Add = globalConAdd
	G.detour( G.concommand.Add, globalConAdd, "concommand.Add" )

	concommand.Remove = globalConRemove
	G.detour( G.concommand.Remove, globalConRemove, "concommand.Remove" )

	concommand.Run = globalConRun
	G.detour( G.concommand.Run, globalConRun, "concommand.Run" )

	concommand.AutoComplete = globalConAC
	G.detour( G.concommand.AutoComplete, globalConAC, "concommand.AutoComplete" )

	-- ANCHOR: INSERT COMMANDS HERE
	G.settings.DRAWBACKTRACK = createConVar( "tog_backtrack_visuals", "0", true, false )

	-- R.ConVar.SetInt( G.settings.FAKELAG, 0 )
	-- R.ConVar.SetInt( G.settings.ANTIAIM, 0 )
	-- R.ConVar.SetInt( G.settings.DOSPIN, 0 )

	conadd( "neofetch", neoFetch )
	conadd( "lua_run_cheat", execute )
	conadd( "tog_force_hooks", detourhook )
	conadd( "tog_errors", fixErrors )
	conadd( "tog_magneto", MagnetoThrow )
	conadd( "tog_netstrings", getNWstrings )
	conadd( "tog_chathook", chathook )

	conadd( "set_name", setSteamName )
	conadd( "set_name_nl", setNewLineName )
	conadd( "set_name_spam", setSpamName )
	conadd( "testbug", testbug )
end

local goodModule = {
	concommand = true,
	saverestore = true,
	hook = true,
	gamemode = true,
	weapons = true,
	scripted_ents = true,
	player_manager = true,
	numpad = true,
	team = true,
	undo = true,
	cleanup = true,
	duplicator = true,
	constraint = true,
	construct = true,
	usermessage = true,
	list = true,
	cvars = true,
	http = true,
	properties = true,
	widget = true,
	cookie = true,
	utf8 = true,
	drive = true,
	draw = true,
	markup = true,
	effects = true,
	halo = true,
	killicon = true,
	spawnmenu = true,
	controlpanel = true,
	presets = true,
	menubar = true,
	matproxy = true,
	search = true
}

function _G.require( name )
	--G.MsgC( G.Color(139, 233, 253), "REQUIRE: ", G.debug.getinfo(2).short_src, " ", name, "\n" )

	if !G.isstring( name ) or !goodModule[name] then
		return G.require( name )
	end

	name = G.nullbyte( name )

	G.require( name )

	if !G[name] and goodModule[name] then G[name] = stc( G.rawget( _G, name )) end

	if name == "hook" then
		detourhook()
		return
	end

	if name == "concommand" then
		detourcommand()
		return
	end
end

G.detour( G.require, _G.require, "require" )


local function fuckLib( fileName ) -- your gmod lib sucks fucking DICK
	G.include( fileName )
	G["hook"] = stc( G.rawget( _G, "hook" )) -- make sure all the global functions return the right shit
	detourhook()
	return
end

local retardedLib = {
	["ulib/shared/hook.lua"] = true,
	["_ulib/lua/autorun/_ulib_hooks.lua"] = true, -- who tf does this
	["dlib/modules/hook.lua"] = true,
	["dash/libraries/hook.lua"] = true,
	["addons/gmcpanel-workshop-merged/lua/dlib/modules/hook.lua"] = true,
	-- ["gamemodes/clockwork/framework/cl_kernel.lua"] = true,
	["plib/libraries/hook.lua"] = true,
	["system/app/yugh/libraries/hook.lua"] = true
} -- https://github.com/SuperiorServers/dash
-- moat servers use something called mlib which is a paste of dash

local anticheats = {
	["swiftac.lua"] = "Server is running SwiftAC by Ley",
	["cl_mac.lua"] = "Server is running Modern-Anti-Cheat",
	["cl_screenshot.lua"] = "Server has Discord integration (with screengrab)",
	["__loadfirst.lua"] = "SWAD'S ANTICHEAT (LEAVE!!)"
}

local shitChatBox = {
	-- ["atlaschat/"] = true,
	-- ["scb/"] = true,
	-- ["chatbox/"] = true
	-- ["edgehud"] = true,
	-- ["edgescoreboard"] = true
	-- ["atlaschat/cl_init.lua"] = true,
	-- ["atlaschat/lua/atlaschat/cl_init.lua"] = true
}

local function hasString( hay, needles )
	for k, v in G.pairs( needles ) do
		if G.string.find( hay, k ) then
			return v
		end
	end

	return false
end

function _G.include( fileName )
	-- if G.string.find( fileName, "hook.lua" ) then
	-- 	G.MsgC( G.Color(189, 147, 249), "INCLUDE: ", G.debug.getinfo(2).short_src, " ", fileName, "\n" )
	-- end

	if retardedLib[fileName] then -- fuck custom hook libs
		G.debugNotif( "CUSTOM HOOK LIB: " .. fileName )
		fuckLib( fileName )
		return
	end

	-- if hasString(fileName, shitChatBox) then
	-- 	return
	-- end

	if anticheats[fileName] then
		G.debugNotif( anticheats[fileName] )
	end

	-- if G.nullbyte(fileName) == "extensions/net.lua" then
	-- 	G.include( fileName )
	-- 	G["net"] = stc( G.rawget( _G, "net" ))
	-- 	function _G.net.WriteTable( tab )
	-- 		if G.fuckNutScript then
	-- 			for k, v in G.pairs(tab) do G.print( k, v ) end
	-- 			tab["endv"] = 0 / 0
	-- 			tab["stmv"] = 0 / 0
	-- 			tab["strv"] = -(2^2048)
	-- 			G.fuckNutScript = false
	-- 		end

	-- 		return G.net.WriteTable( tab )
	-- 	end

	-- 	G.detour( G.net.WriteTable, net.WriteTable, "net.WriteTable" )
	-- 	return
	-- end

	return G.include( fileName )
end

G.detour( G.include, _G.include, "include")

G.Module = {}
function G.Module.Include( name )
	-- name = "pomf/modules/" .. name .. ".vtf"
	--local script = G.file.Open( name, "r", "DATA" )
	local func = G.CompileString( G.CFunc.ReadFile("C:\\fffModule\\modules\\" .. name .. ".lua"), G.short_src, false )
	--local func = G.CompileString( G.CFunc.ReadFile("C:\\fffModule\\modules\\" .. name .. ".vtf"), G.short_src, false )

	if G.isstring( func ) then 
		G.debugNotif( "[Error]", G.Color(254, 55, 55, 230), "Error in file \"".. G.tostring(name).. "\" chunk: ".. G.tostring(func))
		return 
	end


	G.debug.setfenv( func, G )

	return func()
end

-- for k, v in pairs(G.CFunc) do
-- 	print(k,v)
-- end



G.Module.Include( "draw" )
G.Module.Include( "util" )
G.Module.Include( "menu" )

G.Module.Include( "nospread" )
G.Module.Include( "autowall" )
G.Module.Include( "exploits" )
--VISUALS
G.Module.Include( "visuals" )
G.Module.Include( "esp" )
G.Module.Include( "chams" )
G.Module.Include( "glow")

-- G.Module.Include( "logs" )
G.Module.Include( "animfix" )
G.Module.Include( "antiaim" )
G.Module.Include( "net" )

G.debugNotif( "BASE LOADED" )
G.debugNotif( G.tostring( #FS.Detours ) .. " DETOURS ACTIVE" )
endMemory = G.collectgarbage( "count" )
diffMemory = (endMemory - startMemory) - 514.72781
G.collectgarbage( "collect" )