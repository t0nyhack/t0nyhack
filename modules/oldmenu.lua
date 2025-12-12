
Menu = {}
Menu.Funcs = {}
Menu.Options = {
	{
		"Aimbot",
		{"Aimbot", nil, "Break"},
		{"Aimbot Enabled", true, "Checkbox" },
		{"Aim Position", "Head", "Selection", { "Head", "Body", "Hitbox Scan", "Hitbone Scan", "Bone Scan" }},
		{"Use Aimbot FOV", true, "Checkbox" },
		{"Aimbot FOV", 10, "Slider", {0, 360, 0}},
		{"Silent Aim", true, "Checkbox"},
		{"Safe Aim", true, "Checkbox"},
		{"Sticky Lock", false, "Checkbox"},
		{"Static Aim", false, "Checkbox"},
		{"Backtrack", true, "Checkbox" },
		{"Backtrack Priority", "Most Recent", "Selection", { "Most Recent", "Shooting" }},
		{"Max Backtrack Time", 1, "Slider", {.1, 1, 1, .1}},
		{"Forward Track", false, "Checkbox"},
		{"No Spread", true, "Checkbox" },
		{"No Viewpunch", true, "Checkbox" },
		{"Rapid Fire", false, "Checkbox" },
		{"Bullet Time", true, "Checkbox"},
		{"Auto Wall", false, "Checkbox"}
	},
	{
		"Visuals",
		{"ESP", nil, "Break"},
		{"ESP Style", "Classic", "Selection", {"Off", "Classic", "Compact"}},
		{"Skeleton ESP", false, "Checkbox"},
		{"3D Box ESP", false, "Checkbox"},
		{"Chams", nil, "Break"},
		{"Chams Enabled", true, "Checkbox"},
		{"Chams Material",  "Solid", "Selection", { "Solid", "Wireframe", "Shiny" }},
		{"Fullbright Chams", false, "Checkbox"},
		{"Debug Text", nil, "Break"},
		{"Debug Text Stay Time", 60, "Slider", {10, 180, 0, 1}},
		{"Debug Text Rows", 10, "Slider", {10, 25, 0, 1}},
		{"Third Person", nil, "Break"},
		{"Enable Third Person", false, "Checkbox"},
		{"Third Person Distance", 100, "Slider", {100, 1000, 0, 100}},
		{"Third Person X", 0, "Slider", {-100, 100, 0, 5}},
		{"Misc.", nil, "Break"},
		{"View FOV", 120, "Slider", {10, 180, 0}},
		{"Fake Angle Chams", true, "Checkbox"},
		-- {"FakeLag Type", "Adaptive", "Selection", {"Adaptive", "Static", "Random", "HitGround", "Off"}},
	},
	{
		"HvH",
		{"Fake Lag", nil, "Break"},
		{"Fake Lag Type", "Adaptive", "Selection", {"Static", "Adaptive"}},
		{"Fake Lag Choke", 14, "Slider", {0, 14, 0}},
		{"Anti Aim", nil, "Break"},
		{"Anti Aim", false, "Checkbox"},
		{"LBY AA", false, "Checkbox"},
		{"LBY Side Move", 1, "Slider", {0, 15, 0, 1}},
		{"LBY Flick Yaw", 1, "Slider", {90, 150, 0, 1}},
		{"LBY Yaw Offset", 0, "Slider", {0, 180, 0, 1}},
		{"LBY Break Direction", "Left", "Selection", { "Left", "Right" }},
		{"Point Aim At", "Closest Player", "Selection", { "Closest Player", "Current View (Legit)" }},
		{"Fake Angles", nil, "Break"},
		{"Fake Angle Mode", "Static", "Selection", { "Static", "Spin", "Legit" }},
		{"Fake Pitch", 89, "Slider", {-89, 89, 0}},
		{"Fake Yaw", 89, "Slider", {-180, 180, 0, 5}},
		{"Fake Spin Speed", 500, "Slider", {100, 2000, 0, 100}},
		{"Fake Yaw Fuckery", "None", "Selection", { "None", "SineFuck", "SquareFuck", "TangentFuck", "ClampedTangentFuck" }},
		{"Fake Yaw Fuckery Max", 50, "Slider", {0, 200, 0, 10}},
		{"Fake Yaw Fuckery Speed", 1, "Slider", {1, 100, 0, 10}},
		{"Real Angles", nil, "Break"},
		{"Real Angle Mode", "Static", "Selection", { "Static", "Spin" }},
		{"Real Pitch", 89, "Slider", {-89, 89, 0}},
		{"Real Yaw", 89, "Slider", {-180, 180, 0, 5}},
		-- {"Fake Lag", false, "Checkbox"},
		{"Crouch Faking", "Off", "Selection", {"Off", "Fake Duck", "Fake Slow"} },
		{"Normalize Angles", false, "Checkbox"},
		{"Sequence Freezing", nil, "Break"},
		{"Sequence Freeze Mode", "SineFreeze", "Selection", { "SineFreeze", "Static" }},
		{"Sequence Freeze Amount", 60, "Slider", {1, 150, 0}},
		{"Disable Fakelag While Sequence Freezing", true, "Checkbox"}
	},
	{
		"Misc",
		{"Bunny Hop", true, "Checkbox"},
		{"Auto Strafe", false, "Checkbox"},
		{"Legit Backtrack", false, "Checkbox"}
	},
	{
		"Colors",
		{"Menu", nil, "Break"},
		{ "Menu - R", 80, "Slider", {0, 255, 0} },
		{ "Menu - G", 180, "Slider", {0, 255, 0} },
		{ "Menu - B", 240, "Slider", {0, 255, 0} }
	}
}

--[[
FLOATS
]]
Menu.MenuFloats = {
	{
		"Key",
		{KEY_INSERT, false, false}
	},
	{
		"Mouse",
		{MOUSE_LEFT, false, false}
	},
	{
		"Menu",
		{"Active Tab", "Aimbot"},
		{"Visible", true},
		{"Scroll", 0},
		{"Scroller", false},
		{"Scroller Pos", 0}
	},
	{
		"Other",
		{"Cur Time", CurTime() + engine.TickInterval()}
	}
}

surface.CreateFont("MenuFont", {
	font = "Tahoma",
	antialias = true,
	shadow = false,
	outline = false,
	weight = 400
})

Menu.MenuMouse = {
	{
		MOUSE_LEFT,
		{false, false}
	}
}

		-- "Aimbot",
		-- {"Aimbot", nil, "Break"},
		-- {"Aimbot Enabled", true, "Checkbox"},
		-- {"Use Aimbot FOV", true, "Checkbox"},
		-- {"Aimbot FOV", 10, "Slider", {0, 360, 0}},
		-- {"Backtrack", true, "Checkbox"},
		-- {"No Spread", true, "Checkbox"}


--[[POMF FUNCS]]
--
function Menu.ShouldAimbot()
	return Menu.Funcs.GetVar("Aimbot", "Aimbot Enabled")
end

function Menu.ShouldAimbotFOV()
	return Menu.Funcs.GetVar("Aimbot", "Use Aimbot FOV")
end

function Menu.valueFOV()
	return Menu.Funcs.GetVar("Aimbot", "Aimbot FOV")
end

function Menu.ShouldBacktrack()
	return Menu.Funcs.GetVar("Aimbot", "Backtrack")
end

function Menu.ShouldNoSpread()
	return Menu.Funcs.GetVar("Aimbot", "No Spread")
end

function Menu.ShouldRapidFire()
	return Menu.Funcs.GetVar("Aimbot", "Rapid Fire")
end

function Menu.ShouldBulletTime()
	return Menu.Funcs.GetVar("Aimbot", "Bullet Time")
end

function Menu.ShouldSkeleton()
	return Menu.Funcs.GetVar("Visuals", "Skeleton ESP")
end

function Menu.ShouldChams()
	return Menu.Funcs.GetVar("Visuals", "Chams")
end

function Menu.valueViewFOV()
	return Menu.Funcs.GetVar("Visuals", "View FOV")
end

function Menu.ShouldSteal()
	return Menu.Funcs.GetVar("File Stealer", "Active")
end

function Menu.CustomLoading()
	return Menu.Funcs.GetVar("Aimbot", "Custom Loading Screen")
end

function Menu.Funcs.UpdateMouse()
	for i = 1, #Menu.MenuMouse do
		Menu.MenuMouse[i][2][2] = Menu.MenuMouse[i][2][1]
		Menu.MenuMouse[i][2][1] = input.IsMouseDown(Menu.MenuMouse[i][1])
	end
end

function Menu.Funcs.gMouse(b, t)
	for i = 1, #Menu.MenuMouse do
		if (Menu.MenuMouse[i][1] == b) then return t == 1 and (Menu.MenuMouse[i][2][1] and not Menu.MenuMouse[i][2][2]) or (not Menu.MenuMouse[i][2][1] and Menu.MenuMouse[i][2][2]) end
	end
end

function Menu.Funcs.CursorHovering(x, y, w, h)
	x = x + Menu.Menu.PosX
	y = y + Menu.Menu.PosY
	local cx, cy = input.GetCursorPos()

	return (cx > x and cx < (x + w) and cy > y and cy < (y + h))
end

function Menu.Funcs.GetVar(tab, name)
	return Menu.Funcs.gVal(Menu.Options, tab, name)
end

function Menu.Funcs.gVal(t, c, o)
	for k, v in next, t do
		if (c ~= t[k][1]) then continue end

		for i = 2, #t[k] do
			if (t[k][i][1] ~= o) then continue end
			if (t[k][i][3] == "Break") then continue end

			return t[k][i][2]
		end
	end
end

function Menu.Funcs.SaveVars()
	local f = file.Open( "menu.dat", "wb", "DATA" )
	if not f then return end

	R.File.Write( f, util.TableToJSON( Menu.Options, true ))
	R.File.Close( f )
end

function Menu.Funcs.LoadVars()
	if (file.Exists("menu.dat", "DATA")) then
		local f = file.Open( "menu.dat", "r", "DATA" )

		local tab = util.JSONToTable(R.File.Read( f, R.File.Size( f )))

		for k, v in next, tab do
			for i, l in next, v do
				if not istable(l) then continue end
				if not istable(Menu.Options[k][i]) then continue end

				for _, a in pairs(Menu.Options[k]) do
					if a[1] == l[1] then
						Menu.Options[k][_][2] = l[2]
					end
				end
			end
		end
	else
		Menu.Funcs.SaveVars()
	end
end

function Menu.Funcs.sVal(t, c, o, v)
	for k, _v in next, t do
		if (c ~= t[k][1]) then continue end

		for i = 2, #t[k] do
			if (t[k][i][1] ~= o) then continue end
			t[k][i][2] = v
		end
	end

	Menu.Funcs.SaveVars()

	return v
end

function Menu.Funcs.UpdateKeys()
	for i = 1, 2 do
		for _i = 2, #Menu.MenuFloats[i] do
			Menu.MenuFloats[i][_i][3] = Menu.MenuFloats[i][_i][2]
			Menu.MenuFloats[i][_i][2] = (i == 1) and input.IsKeyDown(Menu.MenuFloats[i][_i][1]) or (i == 2) and input.IsMouseDown(Menu.MenuFloats[i][_i][1])
		end
	end
end

function Menu.Funcs.gKey(c, o, t)
	for k, v in next, Menu.MenuFloats do
		if (c ~= Menu.MenuFloats[k][1] or k == 3) then continue end

		for _k, _v in next, Menu.MenuFloats[k] do
			if (Menu.MenuFloats[k][_k][1] ~= o or _k == 1) then continue end

			if (t == 1) then
				return Menu.MenuFloats[k][_k][2] and not Menu.MenuFloats[k][_k][3]
			elseif (t == 2) then
				return not Menu.MenuFloats[k][_k][2] and Menu.MenuFloats[k][_k][3]
			end
		end
	end
end

Menu.MenuBase = {}

function Menu.MenuBase:SetPos(x, y)
	self.PosX = x
	self.PosY = y
end

function Menu.MenuBase:Center()
	self.PosX = ScrW() / 2 - self.SizeX / 2
	self.PosY = ScrH() / 2 - self.SizeY / 2
end

function Menu.MenuBase:GetPos()
	x = self.PosX
	y = self.PosY

	return x, y
end

function Menu.MenuBase:SetSize(x, y)
	self.SizeX = x
	self.SizeY = y
	self._SizeX = x
	self._SizeY = y
end

function Menu.MenuBase:GetSize()
	return {
		x = self.sizex,
		y = self.sizex
	}
end

function Menu.MenuBase:SetColor(r, g, b, a)
	self.Col = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetOutline(b)
	self.Out = b
end

function Menu.MenuBase:SetOutlineColor(r, g, b, a)
	self.OutC = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetWindowColor(r, g, b, a)
	self.WinC = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetHoverColor(r, g, b, a)
	self.HovC = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetText(s)
	self.Text = s
end

function Menu.MenuBase:SetTextColor(r, g, b, a)
	self.TextC = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetTitle(s)
	self.Title = s
end

function Menu.MenuBase:SetTitleColor(r, g, b, a)
	self.TextC = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetDraggable(b)
	self.Draggable = b
end

function Menu.MenuBase:SetVisible(b)
	self.Vis = b
end

function Menu.MenuBase:GetVisible()
	return self.Vis
end

function Menu.MenuBase:ShowCloseButton(b)
	self.CloseB = b
end

function Menu.MenuBase:IsHovering()
	return self.Hov
end

function Menu.MenuBase:IsTarget()
	return self.Target
end

function Menu.MenuBase:SetTargetColor(r, g, b, a)
	self.TargetC = istable(r) and r or Color(r, g, b, a or 255)
end

function Menu.MenuBase:SetParent(p)
	self.Parent = p
	p.Children[#self.Children + 1] = self

	if (p == nil) then
		if (not table.HasValue(Menu.MenuOrder, self.Id)) then
			table.insert(Menu.MenuOrder, 1, self.Id)
		end
	else
		table.RemoveByValue(Menu.MenuOrder, self.Id)
	end
end

function Menu.MenuBase:GetParent()
	return self.Parent
end

function Menu.MenuBase:Update()
	self.Hov = Menu.Funcs.CursorHovering(self.PosX, self.PosY, self.SizeX, self.SizeY)

	if (self.Type == "IButton") then
		self.Click = (self.Target and self.Hov and Menu.Funcs.gMouse(MOUSE_LEFT, 2))

		if (self.Click) then
			self:DoClick()
		end
	end

	self.Target = self.Target and input.IsMouseDown(MOUSE_LEFT) or (self.Hov and Menu.Funcs.gMouse(MOUSE_LEFT, 1) or false)

	if (self.Parent ~= nil) then
		self.PosX = self.Parent.PosX + self._PosX
		self.PosY = self.Parent.PosY + self._PosY
	end
end

function Menu.MenuBase:Draw()
	if (not self.Vis) then return end

	if (self.Type == "IButton") then
		Menu.Funcs.DrawRect(self.PosX, self.PosY, self.SizeX, self.SizeY, self.Target and self.TargetC or (self.Hov and self.HovC or self.Col))
		Menu.Funcs.DrawText(self.Text, "MenuFont", self.PosX + self.SizeX / 2, self.PosY + self.SizeY / 2, self.TextC, "c", "c")
	end

	if (self.Type == "IFrame") then
		Menu.Funcs.DrawRect(self.PosX, self.PosY, self.SizeX, self.SizeY, self.Col)
		Menu.Funcs.DrawRect(self.PosX + 4, self.PosY + 24, self.SizeX - 8, self.SizeY - 28, Color(self.Col.r * 0.8, self.Col.g * 0.8, self.Col.b * 0.8))
		Menu.Funcs.DrawText(self.Text, "MenuFont", self.PosX + self.SizeX / 2, self.PosY + 12, self.TextC, "c", "c")
		self._CloseB.Vis = self.CloseB
	end

	if (self.Out) then
		Menu.Funcs.DrawOutlinedRect(self.PosX, self.PosY, self.SizeX, self.SizeY, self.OutC)

		if (self.Type == "IFrame") then
			Menu.Funcs.DrawOutlinedRect(self.PosX + 4, self.PosY + 24, self.SizeX - 8, self.SizeY - 28, self.OutC)
		end
	end
end

--[[
DRAWING
]]
function Menu.Funcs.DrawRect(x, y, w, h, c)
	x = x + Menu.Menu.PosX
	y = y + Menu.Menu.PosY
	surface.SetDrawColor(c)
	surface.DrawRect(x, y, w, h)
end

function Menu.Funcs.DrawOutlinedRect(x, y, w, h, c)
	x = x + Menu.Menu.PosX
	y = y + Menu.Menu.PosY
	surface.SetDrawColor(c)
	surface.DrawOutlinedRect(x, y, w, h)
end

function Menu.Funcs.DrawText(s, f, x, y, c, ax, ay)
	x = x + Menu.Menu.PosX
	y = y + Menu.Menu.PosY
	surface.SetFont(f)
	local w, h = surface.GetTextSize(s)
	surface.SetTextColor(c)
	x = (ax == "c" and x - w / 2) or (ax == "r" and x - w) or x
	y = (ay == "c" and y - h / 2) or (ay == "b" and y - h) or y
	surface.SetTextPos(math.ceil(x), math.ceil(y))
	surface.DrawText(s)

	return w, h
end

function Menu.Funcs.DrawLine(x, y, _x, _y, c)
	x = x + Menu.Menu.PosX
	y = y + Menu.Menu.PosY
	_x = _x + Menu.Menu.PosX
	_y = _y + Menu.Menu.PosY
	surface.SetDrawColor(c)
	surface.DrawLine(x, y, _x, _y)
end

function Menu.Funcs.DrawTab(s, x, w, h, c, m)
	Menu.Funcs.DrawRect(x, 24, w, h, s == Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Active Tab") and c or Menu.Funcs.CursorHovering(x, 24, w, h, m) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller") and Color(c.r * 1.1, c.g * 1.1, c.b * 1.1) or Color(c.r / 1.5, c.g / 1.5, c.b / 1.5))
	Menu.Funcs.DrawText(s, "MenuFont", x + w / 2, 24 + h / 2, Color(255, 255, 255), "c", "c")

	if (Menu.Funcs.CursorHovering(x, 24, w, h, m) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller") and input.IsMouseDown(MOUSE_LEFT)) then
		Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroll", 0)
		Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Active Tab", s)
	end
end

function Menu.Funcs.DrawCheckbox(s, y, c, o, _c, m)
	Menu.Funcs.DrawOutlinedRect(10, y, 10, 10, Color(0, 0, 0))
	Menu.Funcs.DrawRect(11, y + 1, 8, 8, Color(255, 255, 255))
	surface.SetFont("MenuFont")
	local w, h = surface.GetTextSize(s or "")
	Menu.Funcs.DrawRect(12, y + 2, 6, 6, Menu.Funcs.gVal(Menu.Options, c, o) and _c or Menu.Funcs.CursorHovering(10, y, 15 + w, 10, m) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller") and Color(150, 150, 150) or Color(255, 255, 255))
	Menu.Funcs.DrawText(s, "MenuFont", 23, y + 4, Color(255, 255, 255), "l", "c")

	if (Menu.Funcs.CursorHovering(10, y, 15 + w, 10, m) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller") and Menu.Funcs.gKey("Mouse", MOUSE_LEFT, 2)) then
		Menu.Funcs.sVal(Menu.Options, c, o, not Menu.Funcs.gVal(Menu.Options, c, o))
	end
end

function Menu.Funcs.DrawBreak(s, y, c, m)
	surface.SetFont("MenuFont")
	local w, h = surface.GetTextSize(s)
	Menu.Funcs.DrawText(s, "MenuFont", 370, y + 5, Menu.Funcs.CursorHovering(370 - w, y, w, h, m) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller") and Color(math.random(10, 255), math.random(10, 255), math.random(10, 255)) or c, "r", "c")
	Menu.Funcs.DrawLine(10, y + 5, 366 - w, y + 5, c)
end

function Menu.Funcs.DrawSlider(s, y, c, o, _s, b, d, snap, _c, m)
	local x, _y = input.GetCursorPos()
	local _x, __y = m:GetPos()
	snap = snap or 0

	Menu.Funcs.DrawText(s, "MenuFont", 13, y + 4, Color(255, 255, 255), "l", "c")
	Menu.Funcs.DrawText(math.floor(Menu.Funcs.gVal(Menu.Options, c, o) * 10 ^ d) / 10 ^ d, "MenuFont", 370, y + 4, Color(255, 255, 255), "r", "c")
	Menu.Funcs.DrawLine(15, y + 25, 365, y + 25, _c)
	Menu.Funcs.DrawOutlinedRect(14, y + 24, 353, 3, Color(0, 0, 0))
	Menu.Funcs.DrawOutlinedRect(((Menu.Funcs.gVal(Menu.Options, c, o) - _s) / (b - _s) * 350) + 10, y + 15, 10, 20, Color(0, 0, 0))
	Menu.Funcs.DrawRect(((Menu.Funcs.gVal(Menu.Options, c, o) - _s) / (b - _s) * 350) + 11, y + 16, 8, 18, Color(255, 255, 255))
	Menu.Funcs.DrawRect(((Menu.Funcs.gVal(Menu.Options, c, o) - _s) / (b - _s) * 350) + 12, y + 17, 6, 16, Menu.Funcs.CursorHovering(((Menu.Funcs.gVal(Menu.Options, c, o) - _s) / (b - _s) * 350) + 10, y + 15, 10, 20, m) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller") and Color(150, 150, 150) or Color(255, 255, 255))

	if (Menu.Funcs.CursorHovering(15, y + 15, 351, 20, m) and input.IsMouseDown(MOUSE_LEFT) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller")) then
		local val = (x - _x - 15) / 350 * (b - _s) + _s
		val = snap == 0 and val or math.Round( val / snap ) * snap
		Menu.Funcs.sVal(Menu.Options, c, o, math.floor(val * 10 ^ d) / 10 ^ d)
	end
end

function Menu.Funcs.DrawSelection(s, y, c, o, t, _c, m)
	for i = 1, #t do
		if (t[i] == Menu.Funcs.gVal(Menu.Options, c, o)) then
			q = i
		end
	end

	Menu.Funcs.DrawText(s, "MenuFont", 13, y + 4, _c, "l", "c")
	Menu.Funcs.DrawText(q, "MenuFont", 370, y + 4, _c, "r", "c")
	Menu.Funcs.DrawRect(11, y + 16, 18, 18, _c)
	Menu.Funcs.DrawRect(12, y + 17, 16, 16, Menu.Funcs.CursorHovering(10, y + 15, 20, 20, m) and Color(150, 150, 150) or _c)
	Menu.Funcs.DrawLine(15, y + 25, 25, y + 25, Color(0, 0, 0))
	Menu.Funcs.DrawLine(29, y + 15, 29, y + 35, Color(0, 0, 0))
	Menu.Funcs.DrawOutlinedRect(10, y + 15, 360, 20, Color(0, 0, 0))
	Menu.Funcs.DrawRect(351, y + 16, 18, 18, _c)
	Menu.Funcs.DrawRect(352, y + 17, 16, 16, Menu.Funcs.CursorHovering(350, y + 15, 20, 20, m) and Color(150, 150, 150) or _c)
	Menu.Funcs.DrawLine(355, y + 25, 365, y + 25, Color(0, 0, 0))
	Menu.Funcs.DrawLine(360, y + 20, 360, y + 30, Color(0, 0, 0))
	Menu.Funcs.DrawLine(350, y + 15, 350, y + 35, Color(0, 0, 0))
	Menu.Funcs.DrawRect(30, y + 16, 320, 18, Color(150, 150, 150))
	Menu.Funcs.DrawText(Menu.Funcs.gVal(Menu.Options, c, o), "MenuFont", 190, y + 25, Menu.Funcs.CursorHovering(30, y + 15, 320, 20, m) and Color(math.random(10, 255), math.random(10, 255), math.random(10, 255)) or Color(255, 255, 255), "c", "c")

	if (Menu.Funcs.CursorHovering(10, y + 15, 20, 20, m) and Menu.Funcs.gKey("Mouse", MOUSE_LEFT, 2)) then
		Menu.Funcs.sVal(Menu.Options, c, o, t[math.Clamp(q - 1, 1, #t)])
	end

	if (Menu.Funcs.CursorHovering(350, y + 15, 20, 20, m) and Menu.Funcs.gKey("Mouse", MOUSE_LEFT, 2)) then
		Menu.Funcs.sVal(Menu.Options, c, o, t[math.Clamp(q + 1, 1, #t)])
	end

	if (Menu.Funcs.CursorHovering(30, y + 15, 320, 20, m) and Menu.Funcs.gKey("Mouse", MOUSE_LEFT, 2)) then
		Menu.Funcs.sVal(Menu.Options, c, o, t[math.random(1, #t)])
	end
end

function Menu.Funcs.DrawScroller(_c, m, my)
	local sw, sh = 450, 600 --m:GetWide(), m:GetTall()
	local x, y = input.GetCursorPos()
	local _x, _y = m:GetPos()

	Menu.Funcs.DrawRect(sw - 22, 45, 18, 18, _c)
	Menu.Funcs.DrawRect(sw - 21, 46, 16, 16, Menu.Funcs.CursorHovering(sw - 23, 44, 20, 20, m) and Color(150, 150, 150) or _c)
	Menu.Funcs.DrawLine(sw - 13, 51, sw - 19, 56, Color(0, 0, 0))
	Menu.Funcs.DrawLine(sw - 14, 51, sw - 8, 56, Color(0, 0, 0))
	Menu.Funcs.DrawLine(sw - 23, 63, sw - 4, 63, Color(0, 0, 0))
	Menu.Funcs.DrawRect(sw - 22, 64, 18, 413, Color(110, 110, 110))
	Menu.Funcs.DrawRect(sw - 22, 64 - ((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") / 490) * 414), 18, (414 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 414)) > 413 and 413 or 414 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 414), _c)
	Menu.Funcs.DrawRect(sw - 21, 65 - ((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") / 490) * 414), 16, (414 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 414)) > 413 and 411 or 414 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 414) - 2, Menu.Funcs.CursorHovering(sw - 22, 64 - ((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") / 490) * 414), 18, 413 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 413), m) and Color(150, 150, 150) or _c)
	Menu.Funcs.DrawRect(sw - 22, 478, 18, 18, _c)
	Menu.Funcs.DrawRect(sw - 21, 479, 16, 16, Menu.Funcs.CursorHovering(sw - 23, 477, 20, 20, m) and Color(150, 150, 150) or _c)
	Menu.Funcs.DrawLine(sw - 13, 489, sw - 19, 484, Color(0, 0, 0))
	Menu.Funcs.DrawLine(sw - 14, 489, sw - 8, 484, Color(0, 0, 0))
	Menu.Funcs.DrawLine(sw - 23, 477, sw - 4, 477, Color(0, 0, 0))
	Menu.Funcs.DrawOutlinedRect(sw - 23, 44, 20, 453, Color(0, 0, 0))

	if (Menu.Funcs.CursorHovering(sw - 23, 44, 20, 20, m) and input.IsMouseDown(MOUSE_LEFT)) then
		Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroll", (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 1) > 0 and Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") or (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 1))
	end

	if (Menu.Funcs.CursorHovering(sw - 23, 477, 20, 20, m) and input.IsMouseDown(MOUSE_LEFT)) then
		Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroll", (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") - 1) < (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) and Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") or (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") - 1))
	end

	if (Menu.Funcs.CursorHovering(sw - 22, 64 - ((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") / 490) * 414), 18, 413 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 413), m) and Menu.Funcs.gKey("Mouse", MOUSE_LEFT, 1) and not Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller")) then
		Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroller", true)
		Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroller Pos", -Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") - (((y - _y) * 490) / 414))
	end

	if (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller")) then
		if (input.IsMouseDown(MOUSE_LEFT) and (414 + (((Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) / 490) * 414)) < 413) then
			local num = -(((y - _y) * 490) / 414) - Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroller Pos")
			Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroll", num >= 0 and 0 or num <= (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) and (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll") + 490 - my) or num)
		else
			Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Scroller", false)
		end
	end
end

Menu.MenuElements = {}
Menu.MenuOrder = {}

function Menu.Funcs.Create(s)
	local Id = #Menu.MenuElements + 1
	Menu.MenuOrder[#Menu.MenuOrder + 1] = Id

	Menu.MenuElements[Id] = {
		Type = s,
		Id = Id,
		Vis = true,
		PosX = 0,
		PosY = 0,
		Out = true,
		Col = Menu.Color_White,
		OutC = Menu.Color_Black,
		TargetC = Menu.Color_Blue,
		HovC = Menu.Color_Grey,
		TextC = Menu.Color_Black,
		Children = {}
	}

	if (s == "IFrame") then
		Menu.MenuElements[Id]._CloseB = Menu.Funcs.Create("IButton")
		Menu.MenuElements[Id]._CloseB:SetParent(Menu.MenuElements[Id])
		Menu.MenuElements[Id]._CloseB.Col = Color(200, 80, 80)
		Menu.MenuElements[Id]._CloseB.HovC = Color(220, 100, 100)
		Menu.MenuElements[Id]._CloseB.TargetC = Color(180, 60, 60)
	end

	setmetatable(Menu.MenuElements[Id], Menu.MenuBase)
	Menu.MenuBase.__index = Menu.MenuBase

	return Menu.MenuElements[Id]
end

Menu.MenuDraw = false
Menu.HomeKey = false
Menu.Menu = Menu.Funcs.Create("IFrame")
Menu.Menu:SetSize(450, 600)
Menu.Menu:Center()
Menu.Menu:SetColor(0, 0, 0, 180)
Menu.Menu:SetText("")
Menu.Menu:SetTextColor(255, 255, 255, 255)
Menu.Menu:SetOutlineColor(0, 0, 0)

--Menu.Menu:ShowCloseButton( true )
--Menu.Menu:SetDraggable( true )
function Menu.Menu.Draw(self)
	local sw, sh = self.SizeX, self.SizeY
	Menu.Funcs.DrawRect(1, 1, sw - 2, sh - 2, Color(Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - R"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - G"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - B")))
	Menu.Funcs.DrawRect(4, 24, sw - 8, sh - 28, Color(80, 80, 80))
	local menuy = 50 + Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Scroll")

	for k, v in next, Menu.Options do
		if (Menu.Funcs.gVal(Menu.MenuFloats, "Menu", "Active Tab") == Menu.Options[k][1]) then
			for i = 2, #Menu.Options[k] do
				if (menuy + 30) > sh then continue end

				if (Menu.Options[k][i][3] == "Checkbox") then
					if (menuy > 35) then
						Menu.Funcs.DrawCheckbox(Menu.Options[k][i][1], menuy, Menu.Options[k][1], Menu.Options[k][i][1], Color(Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - R"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - G"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - B")), self)
					end

					menuy = menuy + 15
				elseif (Menu.Options[k][i][3] == "Slider") then
					if (menuy > 10) then
						Menu.Funcs.DrawSlider(Menu.Options[k][i][1], menuy, Menu.Options[k][1], Menu.Options[k][i][1], Menu.Options[k][i][4][1], Menu.Options[k][i][4][2], Menu.Options[k][i][4][3], Menu.Options[k][i][4][4], Color(255, 255, 255), self)
					end

					menuy = menuy + 40
				elseif (Menu.Options[k][i][3] == "Selection") then
					if (menuy > 10) then
						Menu.Funcs.DrawSelection(Menu.Options[k][i][1], menuy, Menu.Options[k][1], Menu.Options[k][i][1], Menu.Options[k][i][4], Color(255, 255, 255), self)
					end

					menuy = menuy + 40
				elseif (Menu.Options[k][i][3] == "Break") then
					if (menuy > 35) then
						menuy = menuy + (menuy > 50 and 10 or 0)
						Menu.Funcs.DrawBreak(Menu.Options[k][i][1], menuy, Color(255, 255, 255), self)
					end

					menuy = menuy + 20
				end
			end
		end
	end

	for k, v in next, Menu.Options do
		Menu.Funcs.DrawTab(Menu.Options[k][1], 4 + (((sw - 8) / #Menu.Options) * (k - 1)), math.ceil((sw - 8) / #Menu.Options), 20, Color(Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - R"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - G"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - B")), self)
	end

	Menu.Funcs.DrawRect(1, 1, sw - 2, 22, Color(Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - R"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - G"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - B")))
	Menu.Funcs.DrawText("Aimbot", "MenuFont", 450 / 2, 11, Color(255, 255, 255), "c", "c")
	Menu.Funcs.DrawRect(sw - 53, 1, 50, 20, Menu.Funcs.CursorHovering(sw - 53, 1, 50, 20, self) and Color(220, 100, 100) or Color(200, 80, 80))

	if (Menu.Funcs.CursorHovering(sw - 53, 1, 50, 20, self)) then
		self:SetDraggable(false)

		if (Menu.Funcs.gKey("Mouse", MOUSE_LEFT, 1)) then
			Menu.Funcs.sVal(Menu.MenuFloats, "Menu", "Visible", false)
			self:SetVisible(false)
		end
	else
		self:SetDraggable(true)
	end

	Menu.Funcs.DrawOutlinedRect(3, 23, sw - 6, sh - 26, Color(0, 0, 0))
	Menu.Funcs.DrawRect(4, sh - 3, sw - 8, 2, Color(Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - R"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - G"), Menu.Funcs.gVal(Menu.Options, "Colors", "Menu - B")))
	-- Menu.Funcs.DrawLine(4, sh - 1, sw - 4, sh - 1, Color(0, 0, 0))
	Menu.Funcs.DrawScroller(Color(255, 255, 255), self, menuy)
end

function Menu.Funcs.MenuHook()
	if (Menu.MenuDraw) then
		for i = 1, #Menu.MenuOrder do
			Menu.MenuElements[Menu.MenuOrder[i]]:Update()
			Menu.MenuElements[Menu.MenuOrder[i]]:Draw()
		end
	end

	if ((input.IsKeyDown(KEY_INSERT)) and (not Menu.MenuDraw) and (not Menu.HomeKey)) then
		Menu.MenuDraw = true

		gui.EnableScreenClicker( true )
	elseif ((input.IsKeyDown(KEY_INSERT)) and Menu.MenuDraw and (not Menu.HomeKey)) then
		Menu.MenuDraw = false

		gui.EnableScreenClicker( false )
	end

	Menu.HomeKey = input.IsKeyDown(KEY_INSERT)
end

Lib.Hook.Add("HUDPaint", "asdfasdfadsf :D", function()
	if hideOverlay then return end
	Menu.Funcs.UpdateMouse()
	Menu.Funcs.UpdateKeys()
	Menu.Funcs.MenuHook()
end)

Menu.Funcs.LoadVars()