Menu = Menu or {}

surface.CreateFont("NonOutlinedMenuFont", {
	font = "Tahoma",
	size = 13,
	antialias = false,
	shadow = true,
	outline = false,
	weight = 400
})


surface.CreateFont("MenuFont", {
	font = "Tahoma",
	size = 13,
	antialias = false,
	shadow = false,
	outline = true,
	weight = 400
})

surface.CreateFont("BoldMenuFont", {
	font = "Tahoma",
	size = 13,
	antialias = false,
	shadow = false,
	outline = true,
	weight = 1000
})

surface.CreateFont("MenuTiny", {
	font = "ProggyTinyTTSZ",
	antialias = false,
	weight = 500,
	outline = true,
	size = 10,
})

Menu.Func = {}
Menu.Base = {
	Visible = false,
	MenuFadeTime = 0,
	MenuAlpha = 0,
	Closing = false,
	MenuFading = false,--G.SysTime()
	-- SizeX = 430,
	-- SizeY = 600,
	SizeX = 550,
	SizeY = 400,
	MinSizeX = 550,
	MinSizeY = 400,
	PosX = math.abs(ScrW() / 2),
	PosY = math.abs(ScrH() / 2),
	Bezel = 3,
	LeftAreaPadding = 120,
	MouseX = 0,
	MouseY = 0,
	GrabbableBezel = 3,
	PreviousTab = 1,
	ActiveTab = 1,
	TabSwitchTime = 0,
	TabHeight = 22,
	HighlightTab = Color( 255, 0, 151, 255 ),
	ScrollOffset = 0,
	ScrollBarWidth = 10,
	DropDownBuffer = nil,
	ColorPickerBuffer = nil,
	DraggingPanel = false,
	DraggedPanel = nil,
	Focused = true,
	ColorPickerCursor = Material( "vgui/minixhair" ),
	GradientRight = Material( "vgui/gradient-r" ),
	GradientDown = Material( "vgui/gradient-d" ),
	GradientUp = Material( "vgui/gradient-u"),
	GradientLeft = Material( "vgui/gradient-l"),
	Grid = Material( "gui/alpha_grid.png" ),
	HueBar = Material( "gui/colors.png" ),
	ClearMaterial = Material( "" ),
}

Menu.TextWindow = {
	Visible = false,
	SizeX = 430,
	SizeY = 600,
	PosX = math.abs(ScrW() / 2),
	PosY = math.abs(ScrH() / 2),
	Bezel = 10,
	MouseX = 0,
	MouseY = 0
}

Menu.Values = {}

Menu.Layout = {
	{
		Title = "Aimbot",
		Active = true,
		Hovered = false,
		ActiveSubTab = 1,
        SubTabs = {
            {
                Title = "Main",
                Children = {
					{
						Type = "Panel",
						Title = "Aimbot Settings",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 2,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Aimbot Enabled",
								Value = true,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Aimbot On Key",
								Value = true,
							},
							{
								Type = "DropDown",
								Label = "Aimbot Key",
								DrawLabel = false,
								Value = "M4",
								Values = { "M4", "ALT", "F", "J"},
								Opened = false,
								Centered = true
							},
							{
								Type = "CheckBox",
								Label = "Bullet Time",
								Value = true
							},
							{
								Type = "DropDown",
								Label = "Aimbot Target",
								Value = "Head",
								Values = { "Head", "Body", "Hitbox Scan", "Hitbone Scan", "Bone Scan" },
								Opened = false,
								Centered = true
							},
							{
								Type = "CheckBox",
								Label = "Filter",
								Value = true,
							},
							{
								Type = "ComboBox",
								Label = "Ignore Conditions",
								Value = {"Friends", "No Clipping"},
								Values = {"Friends", "No Clipping", "In Vehicle", "Bot", "Build Mode", "Same Team", "Opposite Team"},
								DrawLabel = false,
							},
						},
					},
					{
						Type = "Panel",
						Title = "Rage Settings",
						PosX = 10,
						PosY = 187,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 1,
							y = 3,
							w = 2,
							h = 2,
						},
						Draggable = true,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Silent Aim",
								Value = true,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Auto Wall",
								Value = false,
							},
							{
								Type = "Slider",
								Label = "Max Walls",
								DrawLabel = false,
								Value = 4,
								Bounds = { 1.0, 10.0 },
								Decimals = 0,
								Round = 1,
								MaxLabel = true,
								Centered = false,
								Compact = true,
								Append = " walls"
							},
							{
								Type = "CheckBox",
								Label = "Backtrack",
								Value = true,
							},
							{
								Type = "Slider",
								Label = "Backtrack Amount",
								Value = .8,
								Bounds = { 0.1, 1 },
								Decimals = 1,
								Round = .1,
								Centered = false, -- not working yet
								Compact = true,
								Append = "s"
							},
							{
								Type = "CheckBox",
								Label = "Ammo Check",
								Value = true
							},
							{
								Type = "CheckBox",
								Label = "On-Shot Backtrack",
								Value = false,
							},
							{
								Type = "CheckBox",
								Label = "Force On-Shot",
								Value = false,
							},
						},
					},
					{
						Type = "Panel",
						Title = "Legit Settings",
						PosX = 220,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 1,
							w = 2,
							h = 2,
						},
						Controls = {
							{
								Type = "CheckBox",
								Label = "Aimbot FOV Enabled",
								Value = true
							},
							{
								Type = "Slider",
								Label = "Aimbot FOV",
								DrawLabel = false,
								Value = 30.0,
								Bounds = { 1.0, 180.0 },
								Decimals = 1,
								Round = 1,
								Centered = false,
								Compact = true,
								Append = "°"
							},
							{
								Type = "CheckBox",
								Label = "Triggerbot Enabled               (M5)",
								Value = true
							},
							-- {
							-- 	Type = "Slider",
							-- 	Label = "Aimbot Smoothing",
							-- 	DrawLabel = false,
							-- 	Value = 30.0,
							-- 	Bounds = { 1.0, 100.0 },
							-- 	Decimals = 1,
							-- 	Round = 1,
							-- 	Centered = false,
							-- 	Compact = true,
							-- 	Append = "%"
							-- },
							{
								Type = "CheckBox",
								Label = "Safe Aim",
								Value = true
							},
							{
								Type = "CheckBox",
								Label = "Sticky Lock",
								Value = false
							},
							{
								Type = "CheckBox",
								Label = "Legit Backtrack",
								Value = true
							},
						},
					},
					{
						Type = "Panel",
						Title = "Accuracy",
						PosX = 220,
						PosY = 124,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 3,
							w = 2,
							h = 2,
						},
						Controls = {
							{
								Type = "CheckBox",
								Label = "No Recoil",
								Value = true
							},
							-- {
							-- 	Type = "CheckBox",
							-- 	Label = "Passive Recoil Reduction",
							-- 	Value = true,
							-- },
							{
								Type = "Slider",
								Label = "Recoil Pitch Reduction",
								DrawLabel = true,
								Value = 100,
								Bounds = { 0, 100 },
								Decimals = 0,
								Round = 1,
								Centered = false,
								Compact = true,
								Append = "%"
							},
							{
								Type = "Slider",
								Label = "Recoil Yaw Reduction",
								DrawLabel = true,
								Value = 100,
								Bounds = { 0, 100 },
								Decimals = 0,
								Round = 1,
								Centered = false,
								Compact = true,
								Append = "%"
							},
							{
								Type = "CheckBox",
								Label = "No Spread",
								Value = true
							},
							{
								Type = "CheckBox",
								Label = "Static Aim",
								Value = false
							},
							{
								Type = "CheckBox",
								Label = "Fake Lag Fix",
								Value = false
							},
							{
								Type = "CheckBox",
								Label = "Forward Track",
								Value = false
							},
						}
					}
				}
			}	
		}
	},
	{
		Title = "Visuals",
		Active = false,
		Hovered = false,
		ActiveSubTab = 1,
        SubTabs = {
            {
                Title = "Players",
				Children = {
					{
						Type = "Panel",
						Title = "ESP",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Draggable = false,
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 4,
						},
						Controls = {
							{
								Type = "CheckBox",
								Label = "ESP Enabled",
								Value = true
							},
							{
								Type = "ColorCheckBox",
								Label = "Show Dormant Players",
								Value = {true, Color( 117, 117, 117, 100 )}
							},
							
							{
								Type = "ColorCheckBox",
								Label = "Steam Name",
								Value = {true, Color( 255, 255, 255, 255 )}
							},
							{
								Type = "ColorCheckBox",
								Label = "Box",
								Value = {false, Color( 80, 129, 252, 255 )},
							},
							{
								Type = "ColorCheckBox",
								Label = "Active Weapon",
								Value = {true, Color( 255, 255, 255, 255 )}
							},
							{
								Type = "ColorCheckBox",
								Label = "User Group",
								Value = {false, Color( 255, 255, 255, 255 )}
							},
							{
								Type = "CheckBox",
								Label = "Flags",
								Value = true,
							},
							{
								Type = "ComboBox",
								Label = "Active Flags",
								Value = {"Bot"},
								Values = {"Team", "Armor", "Distance", "Over Heal", "Ping", "Bot", "Chocked Packets", "Murderer", "Money"},
								DrawLabel = false,
							},
							{
								Type = "CheckBox",
								Label = "Health Bar",
								Value = true,
							},
							{
								Type = "ColorPicker",
								Label = "Full Health",
								Value = Color( 0, 255, 0 ),
							},
							{
								Type = "ColorPicker",
								Label = "Low Health",
								Value = Color( 255, 0, 0 ),
							},
							{
								Type = "ColorCheckBox",
								Label = "Glow",
								Value = {true,  Color( 255, 0, 151, 255 )},
							},
							{
								Type = "DropDown",
								Label = "Glow Color Base",
								Value = "Color Picker",
								Values = {"Color Picker", "Health Color", "Team Color"},
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "ColorPicker",
								Label = "Weapon Glow",
								Value = Color( 200, 200, 200, 128 ),
							},
							{
								Type = "ColorCheckBox",
								Label = "Skeleton",
								Value = {false, Color( 255, 0, 151, 255 )},
							},
							-- {
							-- 	Type = "DropDown",
							-- 	Label = "Box ESP",
							-- 	Value = "2D",
							-- 	Values = {"Off", "2D", "3D"},
							-- 	Opened = false,
							-- 	Centered = true
							-- },
							-- {
							-- 	Type = "ColorPicker",
							-- 	Label = "Box Color",
							-- 	Value = Color( 80, 129, 252, 255 ),
							-- },
							{
								Type = "ColorCheckBox",
								Label = "Out Of FOV Arrows",
								Value = {true, Color( 80, 129, 252, 170 )},

							},
							{
								Type = "Slider",
								Label = "Indicator Size",
								Value = 12,
								Bounds = { 3, 25},
								Decimals = 0,
								Round = 1,
								Compact = true,
								Centered = false, -- not working yet
								Append = "px",
								DrawLabel = false,
							},
							{
								Type = "Slider",
								Label = "Indicator Distance",
								Value = 30,
								Bounds = { 10, 80},
								Decimals = 0,
								Round = 1,
								Compact = true,
								Centered = false, -- not working yet
								Append = "%",
								DrawLabel = false,
							},
							-- {
							-- 	Type = "CheckBox",
							-- 	Label = "Hitbox ESP",
							-- 	Value = false,
							-- 	SubPanel = {
							-- 		{
							-- 			Type = "CheckBox",
							-- 			Label = "Head Only",
							-- 			Value = false,
							-- 		},
							-- 		{
							-- 			Type = "ColorCheckBox",
							-- 			Label = "Solid Color",
							-- 			Value = {false, Color( 255, 0, 151, 255 )},
							-- 		},
							-- 		{
							-- 			Type = "ColorCheckBox",
							-- 			Label = "Outline Color",
							-- 			Value = {true, Color( 255, 0, 151, 255 )},
							-- 		},
							-- 	}
							-- },
							{
								Type = "CheckBox",
								Label = "Arrest Baton Radius",
								Value = true,
							},
							{
								Type = "DropDown",
								Label = "ABR Style",
								Value = "3D2D",
								Values = { "3D2D", "3D" },
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "ColorPicker",
								Label = "Warning Color",
								Value = Color( 255, 0, 151, 200 ),
							},
							{
								Type = "ColorPicker",
								Label = "Passive Color",
								Value = Color( 150, 255, 52, 128),
							},
						}
					},
					{
						Type = "Panel",
						Title = "Chams",
						PosX = 220,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Draggable = false,
						Snap = {
							x = 3,
							y = 1,
							w = 2,
							h = 2,
						},
						Controls = {

							{
								Type = "ColorCheckBox",
								Label = "Player Chams",
								Value = {true, Color( 170, 255, 52)},
							},
							{
								Type = "ColorPicker",
								Label = "Weapon Color",
								Value = Color( 252, 232, 248, 255 ),
							},
							{
								Type = "DropDown",
								Label = "Player Material",
								Value = "Original",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
							-- {
							-- 	Type = "ColorPicker",
							-- 	Label = "Secondary Color",
							-- 	Value = Color( 255, 0, 151, 255 ),
							-- },
							--[[

							{
								Type = "CheckBox",
								Label = "Fake Angle Chams",
								Value = true,
								SubPanel = {
									{
										Type = "CheckBox",
										Label = "Full Bright",
										Value = true
									},
									{
										Type = "ColorPicker",
										Label = "Chams Color",
										Value = Color( 252, 27, 102, 100 ),
									},
									{
										Type = "DropDown",
										Label = "Chams Material",
										Value = "Solid",
										Values = { "Solid", "Wireframe", "Shiny" },
										Opened = false,
										Centered = true
									},
								}
							},
							]]
							{
								Type = "ColorCheckBox",
								Label = "Backtrack Chams",
								Value = {true, Color( 33, 33, 33, 100 )},
							},
							{
								Type = "DropDown",
								Label = "Backtrack Material",
								Value = "Flat",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "ColorCheckBox",
								Label = "Target Chams",
								Value = {true, Color( 68, 124, 255, 60) }
							},
							{
								Type = "DropDown",
								Label = "Target Material",
								Value = "Flat",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "Slider",
								Label = "Time",
								DrawLabel = true,
								Value = 2,
								Bounds = { 1, 8 },
								Decimals = 1,
								Round = 0.1,
								Append = "s",
								DrawLabel = false,
							},
							
						}
					},
					{
						Type = "Panel",
						Title = "ESP Filtering",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Draggable = false,
						Snap = {
							x = 3,
							y = 3,
							w = 2,
							h = 2,
						},
						Controls = {
							{
								Type = "CheckBox",
								Label = "ESP Highlight",
								Value = true
							},
							{
								Type = "ComboBox",
								Label = "Visual Overrides",
								Value = {"Show Flag"},
								Values = { "Show Flag", "Glow", "Chams", "Skeleton", "Box", "Arrows" },
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "ColorCheckBox",
								Label = "Highlight Admins",
								Value = {true, Color( 249, 49, 49, 255 )}
							},
							{
								Type = "ColorCheckBox",
								Label = "Highlight Friends",
								Value = {true, Color( 143, 235, 52, 255 )}
							},
							{
								Type = "ColorCheckBox",
								Label = "Highlight Priority",
								Value = {true, Color( 219, 202, 50)}
							},
							{
								Type = "CheckBox",
								Label = "Ignore Conditions",
								Value = true
							},
							{
								Type = "ComboBox",
								Label = "Ignore Overide",
								Value = {"Aimbot Filters", "Distance"},
								Values = { "Aimbot Filters", "Distance", "Same Team", "Opposite Team" },
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "Slider",
								Label = "Max Distance",
								Value = 100,
								Bounds = { 10, 500},
								Decimals = 1,
								Round = 10,
								DrawLabel = false,
								Centered = false, -- not working yet
								Append = "m"
							},
						}
					}
						
				}
			},
			{
                Title = "Local Player",
				Children = {
					{
						Type = "Panel",
						Title = "View Mods",
						PosX = 10,
						PosY = 287,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 2,
						},
						Controls = {
							{
								Type = "CheckBox",
								Label = "No Visual Recoil",
								Value = true
							},
							{
								Type = "CheckBox",
								Label = "Third Person",
								Value = false
							},
							{
								Type = "CheckBox",
								Label = "Third Person On Key",
								Value = true
							},
							{
								Type = "DropDown",
								Label = "Third Person Key",
								Value = "M3",
								Values = { "M3", "V"},
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "Slider",
								Label = "Third Person Distance",
								Value = 10,
								Bounds = { 10, 200 },
								Decimals = 0,
								Round = 1,
								Compact = true,
								Centered = false, -- not working yet
							},
							{
								Type = "CheckBox",
								Label = "Custom FOV",
								Value = false,
							},	
							{
								Type = "Slider",
								Label = "Field of View",
								Value = 90,
								Bounds = { 60, 140 },
								Decimals = 1,
								Round = 1,
								Compact = true,
								Centered = false,
								Append = "°",
								DrawLabel = false,
							},
							{
								Type = "CheckBox",
								Label = "Always Force FOV",
								Value = true,
							},
							
							{
								Type = "CheckBox",
								Label = "Disable Draw Distance",
								Value = false
							},
						}
					},
					{
						Type = "Panel",
						Title = "View Model",
						PosX = 10,
						PosY = 287,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 1,
							y = 3,
							w = 2,
							h = 2,
						},
						Controls = {
							{
								Type = "ColorCheckBox",
								Label = "Hand Chams",
								Value = {true, Color( 251, 201, 119, 253)},
							},
							{
								Type = "DropDown",
								Label = "Hand Chams Material",
								Value = "Original Glow",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "ColorCheckBox",
								Label = "Weapon Chams",
								Value = {true, Color( 255, 138, 216)},
							},
							{
								Type = "DropDown",
								Label = "Weapon Chams Material",
								Value = "Original Glow",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
						},
					},
					{
						Type = "Panel",
						Title = "Local Models",
						PosX = 10,
						PosY = 287,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 1,
							w = 2,
							h = 4,
						},
						Controls = {
							--LOCAL
							{
								Type = "ColorCheckBox",
								Label = "Local Chams",
								Value = {true, Color( 216, 131, 255)},
							},
							{
								Type = "ColorPicker",
								Label = "Attachment Chams",
								Value = Color( 252, 232, 248, 255 ),
							},
							{
								Type = "DropDown",
								Label = "Local Material",
								Value = "Lit",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "ColorCheckBox",
								Label = "Glow",
								Value = {true, Color( 89, 52, 255)},
							},
							{
								Type = "ColorPicker",
								Label = "Attachment Glow",
								Value = Color( 255, 178, 240),
							},
							--FAKE
							{
								Type = "ColorCheckBox",
								Label = "Fake Angle Chams",
								Value = {true, Color( 255, 38, 125, 104)},
							},
							{
								Type = "DropDown",
								Label = "Fake Angle Material",
								Value = "Flat",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "ColorCheckBox",
								Label = "Fake Angle Glow",
								Value = {true, Color( 255, 52, 130, 156)},
							},
							--FAKE LAG
							{
								Type = "ColorCheckBox",
								Label = "Fake Lag Chams",
								Value = {true, Color( 255, 255, 255, 50)},
							},
							{
								Type = "DropDown",
								Label = "Fake Lag Material",
								Value = "Flat",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "ColorCheckBox",
								Label = "Fake Lag Glow",
								Value = {false, Color( 255, 255, 255, 104)},
							},
						}
					},
				}
			},
			{
                Title = "Entity",
				Children = {
					{
						Type = "Panel",
						Title = "Entity ESP",
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 4
						},
						Controls = {
							{
								Type = "CheckBox",
								Label = "Enabled",
								Value = false,
							},
							{
								Type = "ColorCheckBox",
								Label = "Name",
								Value = {true, Color( 156, 128, 255, 255)},
							},
							{
								Type = "ColorCheckBox",
								Label = "Distance",
								Value = {true, Color( 255, 255, 255, 255 )},
							},
							{
								Type = "Slider",
								Label = "Max Distance",
								Value = 100,
								Bounds = { 10, 500},
								Decimals = 1,
								Round = 10,
								DrawLabel = false,
								Centered = false, -- not working yet
								Append = "m"
							},
							{
								Type = "ColorCheckBox",
								Label = "Glow",
								Value = {true, Color( 255, 255, 255, 255 )},
							},
							{
								Type = "CheckBox",
								Label = "Chams",
								Value = false,
							},
							{
								Type = "DropDown",
								Label = "Entity Material",
								Value = "Original Glow",
								Values = { "Lit", "Color", "Flat", "Shiny", "Glow", "Original", "Original Glow" },
								Opened = false,
								DrawLabel = false
							},

							{
								Type = "ColorCheckBox",
								Label = "Target Entity",
								Value = {false, Color( 255, 255, 255, 255 )},
							},
							{
								Type = "CheckBox",
								Label = "Weapons",
								Value = true,
							},
							{
								Type = "CheckBox",
								Label = "Ammo",
								Value = false,
							},

							{
								Type = "ColorCheckBox",
								Label = "Keypads",
								Value = {false, Color( 250, 42, 97, 255)},
							},
						}
					},
				}
			},
			{
                Title = "Other",
				Children = {
					{
						Type = "Panel",
						Title = "Misc",
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 4
						},
						Controls = {
							{
								Type = "ColorCheckBox",
								Label = "Crosshair",
								Value = {true, Color(255, 255, 255, 255)}		
							},
							{
								Type = "DropDown",
								Label = "Crosshair Style",
								Value = "Normal",
								Values = { "Normal", "No Dot", "Classic" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "Slider",
								Label = "Crosshair Size",
								Value = 7,
								Bounds = { 3, 20 },
								Decimals = 0,
								Round = 1,
								Centered = false, -- not working yet
								Compact = true,
								Append = "px",
								DrawLabel = false,
							},
							
							{
								Type = "ComboBox",
								Label = "Logs",
								Value = {},
								Values = {"Death", "Kill", "Suicide", "Damage", "Screen Grab"},
								Opened = false,
								DrawLabel = true,
							},
							{
								Type = "ColorCheckBox",
								Label = "Bullet Tracers",
								Value = {true, Color(141, 202, 255, 230)},
							},
							{
								Type = "DropDown",
								Label = "Bullet Tracer Style",
								Value = "Line",
								Values = { "Line", "Beam" },
								Opened = false,
								DrawLabel = false
							},
							{
								Type = "Slider",
								Label = "Bullet Tracer Time",
								DrawLabel = true,
								Value = 2,
								Bounds = { 1, 8 },
								Decimals = 1,
								Round = 0.1,
								Append = "s",
								DrawLabel = false,
							},
							{
								Type = "CheckBox",
								Label = "Hit Marker",
								Value = true,
							},
							{
								Type = "ColorCheckBox",
								Label = "FOV Circle",
								Value = {true, Color( 255, 255, 255, 100 )},
							},
							{
								Type = "ColorCheckBox",
								Label = "Velocity Meter",
								Value = {true, Color( 255, 208, 64, 255 )},
							},
							{
								Type = "CheckBox",
								Label = "Spectator List",
								Value = true,
								Risk = true
							},
							{
								Type = "ComboBox",
								Label = "Spec Info",
								Value = {"Rank", "Observer Mode"},
								Values = {"Rank", "Observer Mode"},
								Opened = false,
								DrawLabel = false,
							},
							{
								Type = "CheckBox",
								Label = "Admin List",
								Value = true,
								Risk = true
							},
							{
								Type = "ComboBox",
								Label = "Admin Info",
								Value = {"Dormant", "Distance"},
								Values = {"Dormant", "Distance"},
								Opened = false,
								DrawLabel = false,
							},
						}
					},
					
				}
			},

		}
	},
	{
		Title = "Misc",
		Active = false,
		Hovered = false,
		ActiveSubTab = 1,
        SubTabs = {
            {
                Title = "Main",
				Children = {
					{
						Type = "Panel",
						Title = "Movement",
						PosX = 220,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 1,
							w = 2,
							h = 2,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Bunny Hop",
								Value = false,
							},
							{
								Type = "CheckBox",
								Label = "Auto Strafe",
								Value = false,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Omni-Directional Strafing",
								Value = true,
								Risk = true
							},
							{
								Type = "Slider",
								Label = "Curve Speed",
								DrawLabel = true,
								Value = 50,
								Bounds = { 20, 100 },
								Decimals = 0,
								Round = 1,
								Centered = false,
								Compact = true,
								Append = "%"
							},
							{
								Type = "CheckBox",
								Label = "Duck In Air",
								Value = false,
							},
							{
								Type = "DropDown",
								Label = "Fix Movement",
								Value = "Enabled",
								Values = { "Enabled", "Safe", "Off" },
								Opened = false,
								Centered = true,
								Risk = true
							},
						}
					},
					{
						Type = "Panel",
						Title = "Spammers",
						PosX = 10,
						PosY = 79,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 3,
							w = 2,
							h = 2,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Click Spam",
								Value = false,
							},
							{
								Type = "CheckBox",
								Label = "Only With Camera",
								Value = true,
							},
							{
								Type = "CheckBox",
								Label = "Use Spam",
								Value = false,
							},
							{
								Type = "CheckBox",
								Label = "Rope Spam",
								Value = false,
							},
							
						}
					},
					{
						Type = "Panel",
						Title = "Other",
						PosX = 10,
						PosY = 147,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 4,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Avoid Arrest",
								Value = false
							},
							{
								Type = "DropDown",
								Label = "Avoid Arrest Method",
								Value = "Suicide",
								Values = { "Suicide", "Retry" },
								Opened = false,
								Centered = true,
								DrawLabel = false,
							},
							{
								Type = "DropDown",
								Label = "Avoid Arrest Key",
								Value = "Always",
								Values = { "Always", "N", "M", "0" },
								Opened = false,
								Centered = true
							},

							{
								Type = "CheckBox",
								Label = "Sequence Freezing (X)",
								Value = false,
								Risk = true
							},
							{
								Type = "DropDown",
								Label = "Sequence Freeze Mode",
								Value = "Sine",
								Values = { "Static", "Adaptive", "Sine" },
								Opened = false,
								Centered = true,
								DrawLabel = false,
							},
							{
								Type = "Slider",
								Label = "Sequence Freeze Amount",
								Value = 16,
								Bounds = { 1, 200 },
								Decimals = 0,
								Round = 1,
								Compact = true
							},
							{
								Type = "CheckBox",
								Label = "Air Stuck (Z)",
								Value = false,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Fake Duck (V)",
								Value = false,
								Risk = true
							},
							{
								Type = "Slider",
								Label = "Fake Duck Choke",
								Value = 1,
								Bounds = { 1, 21 },
								Decimals = 0,
								Round = 1,
								Centered = false, -- not working yet
								Compact = true,
								Append = " tick"
							},
							{
								Type = "CheckBox",
								Label = "Rapid Fire",
								Value = false,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Fast Reload",
								Value = false,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Fast Weapon Swap",
								Value = false,
								Risk = true
							},
						}
					},
				}
			},
			{
				Title = "Anti-Aim",
				Children = {
					{
						Type = "Panel",
						Title = "Anti-Aim",
						PosX = 10,
						PosY = 147,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 1,
							y = 1,
							w = 2,
							h = 4,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Enabled",
								Value = false,
								Risk = true
							},
							{
								Type = "CheckBox",
								Label = "Disablers",
								Value = true,
							},
							{
								Type = "DropDown",
								Label = "Point Angles At",
								Value = "Current View",
								Values = { "Current View", "Closest Player By Distance", "Closest Player To Crosshair" },
								Opened = false,
								Centered = true
							},
							{
								Type = "DropDown",
								Label = "Pitch",
								Value = "Off",
								Values = { "Off", "Up", "Down", "Zero", "Fake Down", "Fake Jitter" },
								Opened = false,
								Centered = true
							},
							{
								Type = "DropDown",
								Label = "Yaw",
								Value = "Off",
								Values = { "Off", "Static", "180", "Spin"},
								Opened = false,
								Centered = true
							},
							{
								Type = "Slider",
								Label = "Yaw Additive",
								Value = 0,
								Bounds = { -180, 180 },
								Decimals = 1,
								Round = 15,
								Centered = true, -- not working yet
								Append = "°",
								Compact = true
							},
							{
								Type = "Slider",
								Label = "Spin Speed",
								Value = 500,
								Bounds = { 0, 2000 },
								Decimals = 0,
								Round = 100,
								Compact = true
							},
							{
								Type = "CheckBox",
								Label = "Correct Dancing Players",
								Value = true,
							},
						}
					},
					{
						Type = "Panel",
						Title = "Fake Lag",
						PosX = 10,
						PosY = 147,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 1,
							w = 2,
							h = 1,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Enabled",
								Value = false,
								Risk = true
							},
							{
								Type = "DropDown",
								Label = "Fake Lag Mode",
								Value = "Static",
								Values = { "Static", "Adaptive" },
								Opened = false,
								Centered = true,
								DrawLabel = false,
							},
							{
								Type = "Slider",
								Label = "Max Choke",
								Value = 1,
								Bounds = { 1, 21 },
								Decimals = 0,
								Round = 1,
								Centered = false, -- not working yet
								Compact = true,
								Append = " tick"
							}

						}
					},
					{
						Type = "Panel",
						Title = "Fake Angles",
						PosX = 10,
						PosY = 147,
						SizeX = 200,
						SizeY = 0,
						Snap = {
							x = 3,
							y = 2,
							w = 2,
							h = 3,
						},
						Draggable = false,
						Controls = {
							{
								Type = "CheckBox",
								Label = "Enabled",
								Value = false,
								Risk = true
							},
							{
								Type = "DropDown",
								Label = "Fake Mode",
								Value = "Fake Angles",
								Values = { "Fake Angles", "Desync" },
								Opened = false,
								Centered = true,
							},
							-- FAKE ANGLE OPTS
							{
								Type = "DropDown",
								Label = "Fake Direction",
								Value = "Left",
								Values = { "Left", "Right", "Freestanding", "Jitter", "test" },
								Opened = false,
								Centered = true,
							},
							{
								Type = "Slider",
								Label = "Fake Yaw",
								Value = 90,
								Bounds = { 0, 180 },
								Decimals = 0,
								Round = 1,
								Compact = true,
								Append = "°",
							},

							-- DESYNC OPTS
							{
								Type = "DropDown",
								Label = "Desync Direction",
								Value = "Left",
								Values = { "Left", "Right" },
								Opened = false,
								Centered = true,
							},
							{
								Type = "CheckBox",
								Label = "Break LBY",
								Value = false,
							},
							{
								Type = "Slider",
								Label = "Flick Yaw",
								Value = 90,
								Bounds = { 90, 120 },
								Decimals = 0,
								Round = 1,
								Compact = true,
								Append = "°",
								DrawLabel = false,
							},
						}
					},
				},
			},
			{
				Title = "Exploits",
				Children = {
					{
						Type = "Panel",
						Title = "Lighting",
						PosX = 220,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Draggable = true,
						Controls = {
							{
								Type = "Button",
								Label = "Lights Out"
							},
							{
								Type = "Button",
								Label = "Full Bright Lights"
							},
							{
								Type = "DropDown",
								Label = "Spam Lights",
								Value = "Off",
								Values = { "Off", "Lights On", "Lights Off" },
								Opened = false,
								Centered = true
							},

							{
								Type = "Slider",
								Label = "Spam Interval",
								Value = .5,
								Bounds = { 0.2, 2 },
								Decimals = 1,
								Round = .1,
								Centered = false, -- not working yet
								Compact = true,
								Append = "s"
							}

						}
					},
					{
						Type = "Panel",
						Title = "MutinyRP",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Draggable = true,
						Controls = {
							{
								Type = "Button",
								Label = "Create bugged arena"
							},
							{
								Type = "Button",
								Label = "Mass invite to arena"
							}
						}
					}
				}
			}
		}
	},
	{
		Title = "Settings",
		Active = false,
		Hovered = false,
		ActiveSubTab = 1,
        SubTabs = {
            {
                Title = "Configuration",
                Children = {
					
                    {
						Type = "Panel",
						Title = "Configs",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Snap = {
                            x = 1,
                            y = 1,
                            w = 2,
                            h = 4,
                        },
						Controls = {
							{
								Type = "DropDown",
								Label = "Config",
								Value = "1",
								Values = { "1", "2", "3", "TTT Legit", "TTT Rage", "Dark RP", "SWRP", "Military Sim" },
								Opened = false,
								Centered = true
							},
							{
								Type = "Button",
								Label = "Load Config"
							},
							{
								Type = "Button",
								Label = "Save Config"
							},
							{
								Type = "Button",
								Label = "Set As Default"
							},
						}
					},
					{
						Type = "Panel",
						Title = "Debug",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Snap = {
                            x = 3,
                            y = 1,
                            w = 2,
                            h = 2,
                        },
						Controls = {

							{
								Type = "CheckBox",
								Label = "Show Aimbot Target Points",
								Value = false,
							},
							{
								Type = "CheckBox",
								Label = "Back Track Debug",
								Value = false,
							}
						}
					},
					{
						Type = "Panel",
						Title = "Other Settings",
						PosX = 10,
						PosY = 10,
						SizeX = 200,
						SizeY = 0,
						Snap = {
                            x = 3,
                            y = 3,
                            w = 2,
                            h = 2,
                        },
						Controls = {
							{
								Type = "CheckBox",
								Label = "Water Mark",
								Value = true,
							},
							{
								Type = "ColorPicker",
								Label = "Menu Accent Color",
								Value = Color( 143, 188, 248),
							},
							{
								Type = "DropDown",
								Label = "Anti Screen Grab",
								Value = "Automatic",
								Values = { "Automatic", "On", "Off"},
								Opened = false,
								Centered = true
							},
						}
					},
				}
			},
		},	
	}
}



local Base = Menu.Base

setmetatable( Base, {__index = Menu})

function Base:BuildLookupTable()
	for k, tabs in ipairs( self.Layout ) do
		if tabs.Title and !self.Values[tabs.Title] then
			self.Values[tabs.Title] = {}
		end

		
		if tabs.SubTabs == nil then
			if !tabs.Children then continue end

			for w, panels in ipairs(tabs.Children) do
				if panels.Title and !self.Values[tabs.Title][panels.Title] then
					self.Values[tabs.Title][panels.Title] = {}
					self.Values[tabs.Title][panels.Title][0] = panels
				end

				if !panels.Controls then continue end

				for v, controls in ipairs(panels.Controls) do
					if controls.Label and !self.Values[tabs.Title][panels.Title][controls.Label] then
						self.Values[tabs.Title][panels.Title][controls.Label] = controls

						if controls.SubPanel then
							for v, subControl in ipairs(controls.SubPanel) do
								if subControl.Label and !self.Values[tabs.Title][panels.Title][controls.Label][subControl.Label] then
									self.Values[tabs.Title][panels.Title][controls.Label][subControl.Label] = subControl
								end
							end
						end
					end
				end
			end

		else
			local SubTabs = {}
			
			for k , v in pairs(tabs.SubTabs) do

				table.insert(SubTabs, v)
				for k1, v1 in pairs(v) do

				end
			end 
		
			for i, panelcontent in pairs(SubTabs) do
				for w, panels in ipairs(panelcontent.Children) do
					if panels.Title and !self.Values[tabs.Title][panels.Title] then
						self.Values[tabs.Title][panels.Title] = {}
						self.Values[tabs.Title][panels.Title][0] = panels
					end

					
					

					for v, controls in ipairs(panels.Controls) do
						if controls.Label and !self.Values[tabs.Title][panels.Title][controls.Label] then
							self.Values[tabs.Title][panels.Title][controls.Label] = controls

							if controls.SubPanel then
								for v, subControl in ipairs(controls.SubPanel) do
									if subControl.Label and !self.Values[tabs.Title][panels.Title][controls.Label][subControl.Label] then
										self.Values[tabs.Title][panels.Title][controls.Label][subControl.Label] = subControl
									end
								end
							end
						end
					end
				end
			end
		end
	end
end



function Menu.Func.GetTabName( tab )
	return Menu.Layout[tab].Title
end

function Menu.Func.GetVar( tab, panel, label, subp )
    if not Menu.Values[tab] or not Menu.Values[tab][panel] or not Menu.Values[tab][panel][label] then
        local reason = not Menu.Values[tab] and "tab" or not Menu.Values[tab][panel] and "panel" or "label"
        print("callback missing")
        return false
    end

    if Menu.Values[tab][panel][label].Type == "ComboBox" then
        return util.TableContains(Menu.Values[tab][panel][label].Value, subp)
    elseif subp then
        if not Menu.Values[tab][panel][label][subp] then
            print("callback missing")
            return false
        end
        return Menu.Values[tab][panel][label][subp].Value
    end

    return Menu.Values[tab][panel][label].Value
end

function Menu.Func.AddCallback( func, tab, panel, label, subp )
	if subp then
		Menu.Values[tab][panel][label][subp].Callback = func
		func( Menu.Values[tab][panel][label][subp].Value, subp )
		return
	end

	Menu.Values[tab][panel][label].Callback = func
end

function Menu.Func.Visible( bool, tab, panel, label, subp )
	if subp then
		Menu.Values[tab][panel][label][subp].Visible = bool
		return
	end

	Menu.Values[tab][panel][label].Visible = bool
end

function Menu.Func.IsVisible( tab, panel, label, subp )
	if subp then
		return Menu.Values[tab][panel][label][subp].Visible != false
	end

	return Menu.Values[tab][panel][label].Visible != false
end


function Base:SaveVars(cfg_name)
	file.CreateDir( "tsettings" )


	local file_dir = cfg_name == nil and "tsettings/bestmenu.dat" or "tsettings/"..cfg_name..".dat"
	local f = file.Open( file_dir, "wb", "DATA" )

	if !f then return end

	R.File.Write( f, util.TableToJSON( Menu.Values, true ))
	R.File.Close( f )
end


function Base:LoadVars(cfg_name)
	file.CreateDir( "tsettings" )
	local file_dir = cfg_name == nil and "tsettings/bestmenu.dat" or "tsettings/"..cfg_name..".dat"
	
	local f = file.Open( file_dir, "rb", "DATA" )
	if !f then return end

	local opt = util.JSONToTable(R.File.Read( f, R.File.Size( f )))
	R.File.Close( f )

	for k, v in pairs(self.Values) do
		if opt[k] then -- if tab exists
			for i, w in pairs( v ) do
				if opt[k][i] then -- panels
					-- if w[0]["Draggable"] then
					-- 	w[0].PosX = opt[k][i][0].PosX
					-- 	w[0].PosY = opt[k][i][0].PosY
					-- end

					for x, z in pairs(w) do -- controls
						if opt[k][i][x] and opt[k][i][x].Value != nil and opt[k][i][x].Type == z.Type then
							z.Value = opt[k][i][x].Value
						end

						if z.SubPanel then -- subpanels
							for fuck, you in ipairs( z.SubPanel ) do
								if !opt[k][i][x] then break end
								if opt[k][i][x].SubPanel and opt[k][i][x].SubPanel[fuck] and opt[k][i][x].SubPanel[fuck].Type == you.Type then
									you.Value = opt[k][i][x].SubPanel[fuck].Value
								end
							end
						end
					end
				end
			end
		end
	end
end

local tex_corner8	= surface.GetTextureID( "gui/corner8" )
local tex_corner16	= surface.GetTextureID( "gui/corner16" )
local tex_corner32	= surface.GetTextureID( "gui/corner32" )
local tex_corner64	= surface.GetTextureID( "gui/corner64" )
local tex_corner512	= surface.GetTextureID( "gui/corner512" )
local tex_white		= surface.GetTextureID( "vgui/white" )

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i = 0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

function draw.MaterialBox( x, y, w, h, mat )
	surface.SetMaterial( mat )
	local matW = R.IMaterial.Width( mat )
	local matH = R.IMaterial.Height( mat )
	for i = 0, math.ceil( h / matH ) * matH, matH do
		for v = 0, math.ceil( w / matW ) * matW, matW do
			surface.DrawTexturedRect( x + v, y + i, matW, matH )
		end
	end
end

function draw.RoundedBox( bordersize, x, y, w, h, color )
	return draw.RoundedBoxEx( bordersize, x, y, w, h, color, true, true, true, true )
end

--[[---------------------------------------------------------
	Name: RoundedBox( bordersize, x, y, w, h, color )
	Desc: Draws a rounded box - ideally bordersize will be 8 or 16
	Usage: color is a table with r/g/b/a elements
-----------------------------------------------------------]]
function draw.RoundedBoxEx( bordersize, x, y, w, h, color, tl, tr, bl, br )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )

	-- Do not waste performance if they don't want rounded corners
	if ( bordersize <= 0 ) then
		surface.DrawRect( x, y, w, h )
		return
	end

	x = math.Round( x )
	y = math.Round( y )
	w = math.Round( w )
	h = math.Round( h )
	bordersize = math.min( math.Round( bordersize ), math.floor( w / 2 ) )

	-- Draw as much of the rect as we can without textures
	surface.DrawRect( x + bordersize, y, w - bordersize * 2, h )
	surface.DrawRect( x, y + bordersize, bordersize, h - bordersize * 2 )
	surface.DrawRect( x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2 )

	local tex = tex_corner8
	if ( bordersize > 8 ) then tex = tex_corner16 end
	if ( bordersize > 16 ) then tex = tex_corner32 end
	if ( bordersize > 32 ) then tex = tex_corner64 end
	if ( bordersize > 64 ) then tex = tex_corner512 end

	surface.SetTexture( tex )

	if ( tl ) then
		surface.DrawTexturedRectUV( x, y, bordersize, bordersize, 0, 0, 1, 1 )
	else
		surface.DrawRect( x, y, bordersize, bordersize )
	end

	if ( tr ) then
		surface.DrawTexturedRectUV( x + w - bordersize, y, bordersize, bordersize, 1, 0, 0, 1 )
	else
		surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end

	if ( bl ) then
		surface.DrawTexturedRectUV( x, y + h -bordersize, bordersize, bordersize, 0, 1, 1, 0 )
	else
		surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end

	if ( br ) then
		surface.DrawTexturedRectUV( x + w - bordersize, y + h - bordersize, bordersize, bordersize, 1, 1, 0, 0 )
	else
		surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end

end



function draw.Rect(x, y, w, h, col)
	surface.SetDrawColor( col )
	surface.DrawRect(x, y, w, h )
end

function draw.GetTextSize(font, text)
	surface.SetFont( font )
	return surface.GetTextSize( text )
end

function draw.HalfRoundedBox(z, x, y, w, h, col)
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)
	draw.RoundedBox(z, x, y, w, 12, col)
	draw.Rect(x, y + 10, w, h - 10, col)
end



function math.Truncate( num, idp )
	local mult = 10 ^ ( idp or 0 )
	local FloorOrCeil = num < 0 and math.ceil or math.floor

	return FloorOrCeil( num * mult ) / mult
end

Base.MouseState = {
	[MOUSE_LEFT] = {false, false},
	[MOUSE_RIGHT] = {false, false},
	[MOUSE_WHEEL_UP] = {false, false},
	[MOUSE_WHEEL_DOWN] = {false, false}
}

Base.KeyState = {
	[KEY_INSERT] = {false, false}
}

function Base:RelativeCursor()
	local x, y = input.GetCursorPos()

	return x - self.PosX, y - self.PosY
end

function Base:UpdateButtons()
	for k, v in pairs( self.MouseState ) do
		self.MouseState[k][2] = self.MouseState[k][1]
		self.MouseState[k][1] = input.IsMouseDown( k )
	end

	for k, v in pairs( self.KeyState ) do
		self.KeyState[k][2] = self.KeyState[k][1]
		self.KeyState[k][1] = input.IsKeyDown( k )
	end
end

function Base:GetMouseState( MOUSE_BUTTON )
	return self.MouseState[MOUSE_BUTTON][1], self.MouseState[MOUSE_BUTTON][2]
end

function Base:MouseClick( MOUSE_BUTTON )
	return self.MouseState[MOUSE_BUTTON] and (self.MouseState[MOUSE_BUTTON][1] and !self.MouseState[MOUSE_BUTTON][2])
end

function Base:MouseDown( MOUSE_BUTTON )
	return self.MouseState[MOUSE_BUTTON] and self.MouseState[MOUSE_BUTTON][1]
end

function Base:MouseUnClick( MOUSE_BUTTON )
	return self.MouseState[MOUSE_BUTTON] and (!self.MouseState[MOUSE_BUTTON][1] and self.MouseState[MOUSE_BUTTON][2])
end

function Base:MouseHeld( MOUSE_BUTTON )
	return self.MouseState[MOUSE_BUTTON] and (self.MouseState[MOUSE_BUTTON][1] and self.MouseState[MOUSE_BUTTON][2])
end

function Base:KeyPress( KEY )
	return self.KeyState[KEY] and (self.KeyState[KEY][1] and !self.KeyState[KEY][2])
end

function Base:Resize( x, y )
	x = math.floor(x)
	y = math.floor(y)
	x = x >= self.MinSizeX and x or self.MinSizeX
	y = y >= self.MinSizeY and y or self.MinSizeY

	self.SizeX = x
	self.SizeY = y
	self.ScrollOffset = 0
	self.ScrollBarY = nil
end

function Base:SetPos( x, y )
	self.PosX = x
	self.PosY = y
end

function Base:Center()
	self:SetPos( math.Round(ScrW() / 2 - self.SizeX / 2), math.Round(ScrH() / 2 - self.SizeY / 2) )
end

function Base:CheckIfResize()
	local x, y = self:RelativeCursor()

	if self:MouseClick( MOUSE_LEFT ) and !self:IsBehindSubPanel() then
		self.grabbingSide = x - self.SizeX <= self.GrabbableBezel and x >= self.SizeX
		self.grabbingBottom = y - self.SizeY <= self.GrabbableBezel and y >= self.SizeY
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		self.grabbingSide = false
		self.grabbingBottom = false
	end

	if self.grabbingSide and self.grabbingBottom then
		self:Resize( x - self.GrabbableBezel / 2, y - self.GrabbableBezel / 2 )
	elseif self.grabbingSide and y <= self.SizeY + self.GrabbableBezel and -y <= self.GrabbableBezel then
		self:Resize( x - self.GrabbableBezel / 2, self.SizeY )
	elseif self.grabbingBottom and x >= 0 and x <= self.SizeX then
		self:Resize( self.SizeX, y - self.GrabbableBezel / 2 )
	end
end

function Base:IsMouseInRelativeArea( x, y, w, h )
	if !vgui.CursorVisible() then return false end
	return self.MouseX <= ( x + w ) and self.MouseX >= x and self.MouseY <= ( y + h ) and self.MouseY >= y
end

function Base:IsMouseInArea( x, y, w, h )
	if !vgui.CursorVisible() then return false end

	local MouseX, MouseY = input.GetCursorPos()
	return MouseX <= ( x + w ) and MouseX >= x and MouseY <= ( y + h ) and MouseY >= y
end

function Base:StoreMousePos()
	self.MouseX, self.MouseY = self:RelativeCursor()
	self.RawMouseX, self.RawMouseY = input.GetCursorPos()
end

function Base:IsBehindOpenedDropDown()
	local buf = self.DropDownBuffer

	if !buf then return false end

	local x, y, width, height = buf[1], buf[2], buf[3], #buf[4].Values * 18
	return self:IsMouseInArea( x, y, width, height )
end

function Base:IsBehindColorPicker()
	local buf = self.ColorPickerBuffer

	if !buf then return false end

	local x, y, width, height = buf[1], buf[2], 300, 200

	return self:IsMouseInArea( x, y, width, height )
end

function Base:IsBehindSubMenu()
	local buf = self.SubPanelBuffer

	if !buf then return false end

	local x, y, width, height = buf[1], buf[2], buf[3], buf[4]

	if buf[5][0] and buf[5][0].h then height = buf[5][0].h end

	return self:IsMouseInArea( x, y, width, height )
end

function Base:IsBehindSubPanel( inSubP )
	return self:IsBehindOpenedDropDown() or self:IsBehindColorPicker() or ( !inSubP and self:IsBehindSubMenu() )
end

function Base:CloseOpenDropDowns()
	local buf = self.DropDownBuffer

	if !buf then return end

	buf[4].Opened = false
	self.DropDownBuffer = nil
end

function Base:CloseOpenSubPanels()
	local buf = self.SubPanelBuffer

	if !buf then return end

	buf[6].SubPanelOpened = false
	self.SubPanelBuffer = nil
end

function Base:CloseOpenColorPickers()
	local buf = self.ColorPickerBuffer

	if !buf then return end

	buf[3].Opened = false
	self.ColorPickerBuffer = nil
end

function Base:IsInMainPanel( subp )
	if subp then return true end

	return Base:IsMouseInArea(self.PosX, self.PosY + 1 + self.TabHeight, self.SizeX - 1, self.SizeY - 1 - self.TabHeight )
end

--[[

-- local y_off = self.PosX + self.SizeX - 6
-- y_off - txtWidth - 6, self.PosY + self.TabHeight - txtHeight - 6, txtWidth + 12, 20


local y_off = self.SizeX - 10
for trunum, tab in ipairs( util.Table_reverse(Menu.Layout) ) do
	local num = #Menu.Layout - (trunum - 1)
	local txtWidth, txtHeight = draw.GetTextSize("MenuFont", tab.Title)
	tab.Hovered = self:IsMouseInRelativeArea( y_off - txtWidth - 6, self.TabHeight - txtHeight - 6, txtWidth + 10, 20)

	if tab.Hovered and self:MouseClick( MOUSE_LEFT ) then
		self:CloseOpenDropDowns() -- ensure dropdowns don't stay open in other tabs
		self:CloseOpenColorPickers() -- same here
		self:CloseOpenSubPanels()
		self.ActiveTab = num
	end

	y_off = y_off - txtWidth - 12

end
]]

function Base:CheckIfMoving()
	local x, y = self:RelativeCursor()
	local x2, y2 = input.GetCursorPos()


	local y_off = self.SizeX - 10
	for trunum, tab in ipairs( util.Table_reverse(Menu.Layout) ) do
		local num = #Menu.Layout - (trunum - 1)
		local txtWidth, txtHeight = draw.GetTextSize("MenuFont", tab.Title)

		y_off = y_off - txtWidth - 12
	end

	if self:MouseClick( MOUSE_LEFT ) then
		self.Moving = self:IsMouseInRelativeArea( self.Bezel - 3, self.Bezel - 3,  y_off - 1, self.TabHeight)
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		self.Moving = false
	end

	if self.Moving then
		self:SetPos( x2 - self.MouseX, y2 -self.MouseY )
	end
end

function Base:DragPanel( panel, x, y, w, h )
	if !panel.Draggable or !self:IsInMainPanel() then return end

	if true then return end

	if self:MouseClick( MOUSE_LEFT ) and self:IsMouseInArea( x, y, w, h ) and !self.DraggingPanel then
		panel.StartOffset = { x = self.MouseX - panel.PosX, y = self.MouseY - panel.PosY }
		panel.BeingDragged = true
		self.DraggingPanel = true
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		panel.BeingDragged = false
		self.DraggingPanel = false
		panel.StartOffset = nil
	end

	if panel.BeingDragged then
		panel.PosX = math.Clamp(self.MouseX - panel.StartOffset.x, 0, self.SizeX - panel.SizeX)
		panel.PosY = math.Clamp(self.MouseY - panel.StartOffset.y, 0 + self.TabHeight - 13, self.SizeY - panel.SizeY )
	end
end

--[[
	Visible = false,
	MenuFadeTime = 0,
	MenuAlpha = 0,
	Closing = false,
	MenuFading = false,--G.SysTime()
]]

function Base:AnimateMenu()
	if self.MenuFading then
		if self.Closing then
			local timesincefade = SysTime() - self.MenuFadeTime
			local dif = 1 - math.Clamp(timesincefade/.25, 0, 1)
			self.MenuAlpha = dif
			if dif == 0 then
				self.MenuFading = false
				self.Visible = false

				gui.EnableScreenClicker( self.Visible )
			end
		else
			local timesincefade = SysTime() - self.MenuFadeTime
			local dif = math.Clamp(timesincefade/.25, 0, 1)
			self.MenuAlpha = dif
			if dif == 1 then
				self.MenuFading = false
			end
		end
	end
end
--math.Clamp(num, min, max)
function Base:Think()
	self:UpdateButtons()

	if self:KeyPress( KEY_INSERT ) then

		if not self.MenuFading then
			if !self.Visible then
				self.MenuFadeTime = SysTime()
				self.MenuFading = true
				self.Closing = false
				self.Visible = true
			else
				self:SaveVars()
				self.MenuFadeTime = SysTime()
				self.MenuFading = true
				self.Closing = true
			end

			gui.EnableScreenClicker( self.Visible )
		end
	end

	self:AnimateMenu()

	if vgui.CursorVisible() and self.Visible and not self.MenuFading then
		self:CheckIfMoving()
		self:CheckIfResize()
		self:StoreMousePos()
		self:CheckHoveredTabs()
		self:CheckHoveredSubTabs()
	end
end

--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING
--	DRAWING DRAWING DRAWING DRAWING


function Base:CheckHoveredTabs()
	local tabWidth = self.SizeX / #Menu.Layout


	-- for num, tab in ipairs( Menu.Layout ) do
	-- 	tab.Hovered = self:IsMouseInRelativeArea( tabWidth * (num - 1), 0, tabWidth, self.TabHeight )

	-- 	if tab.Hovered and self:MouseClick( MOUSE_LEFT ) then
	-- 		self:CloseOpenDropDowns() -- ensure dropdowns don't stay open in other tabs
	-- 		self:CloseOpenColorPickers() -- same here
	-- 		self:CloseOpenSubPanels()
	-- 		self.ActiveTab = num
	-- 	end
	-- end

	local y_off = self.SizeX - 10
	for trunum, tab in ipairs( util.Table_reverse(Menu.Layout) ) do
		local num = #Menu.Layout - (trunum - 1)
		local txtWidth, txtHeight = draw.GetTextSize("MenuFont", tab.Title)

		-- local y_off = self.PosX + self.SizeX - 6
		-- y_off - txtWidth - 6, self.PosY + self.TabHeight - txtHeight - 6, txtWidth + 12, 20
		tab.Hovered = self:IsMouseInRelativeArea( y_off - txtWidth - 6, self.TabHeight - txtHeight - 6, txtWidth + 10, 20)

		if tab.Hovered and self:MouseClick( MOUSE_LEFT ) and self.ActiveTab ~= num and self.TabSwitchTime + .25 < SysTime() then
			self:CloseOpenDropDowns() -- ensure dropdowns don't stay open in other tabs
			self:CloseOpenColorPickers() -- same here
			self:CloseOpenSubPanels()
			self.PreviousTab = self.ActiveTab
			self.ActiveTab = num
			self.TabSwitchTime = SysTime()
		end
		y_off = y_off - txtWidth - 12
	
	end
end

function Base:CheckHoveredSubTabs()
	if Menu.Layout[self.ActiveTab].Children == nil then

		local y_off = self.TabHeight + 10
		local x_pos = 12
		local layout = Menu.Layout[self.ActiveTab]
		for num, tab in ipairs(layout.SubTabs) do
			
			tab.Hovered = self:IsMouseInRelativeArea(x_pos - 4, math.floor(y_off + 1) - 2, self.LeftAreaPadding - 20, 16)

			if tab.Hovered and self:MouseClick( MOUSE_LEFT ) and num != layout.ActiveSubTab then
				self:CloseOpenDropDowns() -- ensure dropdowns don't stay open in other tabs
				self:CloseOpenColorPickers() -- same here
				self:CloseOpenSubPanels()
				layout.PreviousSubTab = layout.ActiveSubTab
				layout.ActiveSubTab = num
				layout.SubTabTime = SysTime()
			end

			y_off = y_off + 20
		end
		
	end
	

end

function Base:DrawCheckBox( x, y, width, tab, subp )
	x = x + 5

	local hovering = false
	surface.SetDrawColor( 0, 0, 0, 255 )

	draw.OutlinedBox(x - 1, y - 1, 12, 12, 1, Color( 29, 29, 29))
	draw.OutlinedBox(x, y, 10, 10, 1, Color( 19, 19, 19))

	local labelColor = tab.Risk and Color(220, 220, 120, 255) or Color(255, 255, 255, 255)
	local w, h = draw.SimpleText(tab.Label, "MenuFont", x + 14, y - 3, labelColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	if tab.SubPanel then
		local w, _ = draw.SimpleText(!tab.SubPanelOpened and "+" or "--", "MenuFont", x + width - 12, y - 3, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		if self:IsMouseInArea( x - 5, y, width, 10 ) and self:MouseClick( MOUSE_RIGHT ) and tab.SubPanel and !self:IsBehindSubPanel( subp ) and self:IsInMainPanel( subp ) then
			tab.SubPanelOpened = !tab.SubPanelOpened

			self:CloseOpenSubPanels()
			self:CloseOpenDropDowns() -- ensure dropdowns don't stay open in other tabs
			self:CloseOpenColorPickers() -- same here

			if !tab.SubPanel[0] then tab.SubPanel[0] = {} end

			tab.SubPanel.OpenTime = SysTime()
		end
	end

	if self:IsMouseInArea( x, y, 14 + w, 10 ) and !self:IsBehindSubPanel( subp ) and self:IsInMainPanel( subp ) then
		hovering = true

		if self:MouseClick( MOUSE_LEFT ) then
			tab.Value = !tab.Value
			if tab.Callback then
				tab.Callback( tab.Value, tab )
			end
		end
	end

	if tab.Value then
		surface.SetDrawColor( self.HighlightTab.r, self.HighlightTab.g, self.HighlightTab.b )
		surface.DrawRect(x + 1, y + 1, 8, 8 )
	else
		surface.SetDrawColor( 41, 41, 41)
		surface.DrawRect(x + 1, y + 1, 8, 8 )
	end

	if hovering then

		if tab.Value then
			surface.SetDrawColor( self.HighlightTab.r + 50, self.HighlightTab.g + 50, self.HighlightTab.b + 50 )
		else
			surface.SetDrawColor( 60, 60, 60)
		end
		surface.DrawRect(x + 2, y + 2, 6, 6 )
	end

	surface.SetDrawColor( 0, 0, 0, 255 / 2 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x + 1, y + 1, 8, 8 )

	if tab.SubPanelOpened then
		self.SubPanelBuffer = { x, y + 14, width, 100, tab.SubPanel, tab }
	end
end

function Base:DrawSubPanel()
	local buf = self.SubPanelBuffer
	if !buf then return end

	if !buf[6].SubPanelOpened then self.SubPanelBuffer = nil end


	local x, y, width, height, tab = buf[1], buf[2], buf[3], buf[4], buf[5]

	width = width - 10

	if tab[0].h then
		height = tab[0].h
	end

	local startDropDown = self.DropDownBuffer
	local startColorPicker = self.ColorPickerBuffer

	local lerpHeight = Lerp( (SysTime() - tab.OpenTime) * 8, 0, height )

	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( 8 ) -- STENCIL_ALWAYS
	render.SetStencilPassOperation( 1 ) -- STENCIL_KEEP
	render.SetStencilFailOperation( 1 ) -- STENCIL_KEEP
	render.SetStencilZFailOperation( 1 ) -- STENCIL_KEEP
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilCompareFunction( 3 ) -- STENCIL_EQUAL
	render.SetStencilReferenceValue( 1 )
	render.ClearStencilBufferRectangle( x - 1, y - 1, x + width + 1, y + lerpHeight + 1, 1 )

	surface.SetDrawColor( 45, 45, 45, 255 )
	surface.DrawRect( x, y, width, height )

	local origY = y

	y = y + 5

	for k, v in ipairs( tab ) do
		if v.Visible == false then continue end
		if v.Type == "CheckBox" then
			self:DrawCheckBox( x, y, width, v, true )
			y = y + 14
		elseif v.Type == "Button" then
			self:DrawButton( PanelPosX, y, width, v, true)
			y = y + 22
		elseif v.Type == "Slider" then
			y = y + self:DrawSlider( x, y, width, v, true )
		elseif v.Type == "DropDown" then
			y = y + self:DrawDropDown( x, y, width, v, true )
		elseif v.Type == "ColorPicker" then
			self:DrawColorBox( x, y, width, v, true )
			y = y + 14
		elseif v.Type == "ColorCheckBox" then
			self:DrawColorCheckBox( x, y, width, v, true )
			y = y + 14
		end
	end

	surface.SetDrawColor( 20, 20, 20, 255 )
	surface.DrawOutlinedRect( x - 1, origY - 1, width + 2, lerpHeight + 2 )
	surface.DrawOutlinedRect( x + 1, origY + 1, width - 2, lerpHeight - 2 )
	surface.SetDrawColor( self.HighlightTab )
	surface.DrawOutlinedRect( x, origY, width, lerpHeight )

	render.SetStencilEnable( false )

	if startDropDown != self.DropDownBuffer then self:DrawDropDownMenu( true ) end
	if startColorPicker != self.ColorPickerBuffer then self:DrawColorPicker( true ) end

	tab[0].h = y - buf[2]

	-- if self.SubPanelBuffer != buf then Base:DrawSubPanel( drewDropDown ) end

	-- self.SubPanelBuffer = nil
end

function Base:DrawSlider( x, y, width, tab, subp )
	x = x + 14
	width = width - 18

	local origY = y

	if tab.DrawLabel != false then
		draw.SimpleText(tab.Label, "MenuFont", x + 3, y - 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		y = y + 14
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		tab.BeingDragged = false
	end

	if self:MouseClick( MOUSE_LEFT ) then
		tab.BeingDragged = self:IsMouseInArea( x, y, width, 9 ) and !self:IsBehindSubPanel(subp) and self:IsInMainPanel(subp)
	end

	if self:MouseDown( MOUSE_LEFT ) and tab.BeingDragged then
		tab.Value = math.Remap( self.RawMouseX, x, x + width, tab.Bounds[1], tab.Bounds[2] )

		if tab.Round and !input.IsKeyDown( KEY_LSHIFT ) then
			tab.Value = math.Round( tab.Value / tab.Round ) * tab.Round
		end

		if tab.Decimals then
			tab.Value = math.Truncate( tab.Value, tab.Decimals )
		end

		tab.Value = math.Clamp( tab.Value, tab.Bounds[1], tab.Bounds[2] )
	end

	surface.SetDrawColor( 41, 41, 41)
	surface.DrawRect( x, y, width, 8 )
	local value = math.Remap( tab.Value, tab.Bounds[1], tab.Bounds[2], 0, width )


	local valString

	if tab.MaxLabel and tab.Value == tab.Bounds[2] then
		valString = "MAX"
	else
		valString = tostring( tab.Value ) .. (tab.Append and tab.Append or "")
	end


	surface.SetDrawColor( self.HighlightTab )

	if tab.Centered then
		surface.DrawRect( x + width / 2, y, value - width / 2, 9 )
	else
		surface.DrawRect(x, y, value, 9 )
	end

	surface.SetDrawColor( 0, 0, 0, 255 * 0.5)
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x + 2, y + 2, width - 4, 5 )

	draw.OutlinedBox(x, y, width, 9, 1, Color( 30, 30, 30))
	draw.OutlinedBox(x + 1, y + 1, width - 2, 7, 1, Color( 19, 19, 19))

	--local txtWidth, txtHeight = draw.GetTextSize("MenuFont", tab.Title)
	local txtWidth, txtHeight = draw.GetTextSize("MenuFont", valString)

	local x_pos = x + value - (txtWidth/2)
	if x + value + (txtWidth/2) > x + width then
		x_pos = x_pos - (((x + value + (txtWidth/2) ) - (x + width)))
	elseif x + value - (txtWidth/2) < x then
		x_pos = x_pos + ((x) - (x + value - (txtWidth/2) ))
	end


	
	draw.SimpleText( valString, "MenuTiny", x_pos, y, tab.BeingDragged and Color(255, 255, 255) or Color(199, 199, 199), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	return 27 - (tab.DrawLabel == false and 14 or 0)

end

function Base:DrawButton( x, y, width, tab, subp )
	x = x + 14
	width = width - 18
	hovering = false
	

	if self:IsMouseInArea( x, y, width, 18 ) and !self:IsBehindSubPanel( subp ) and self:IsInMainPanel( subp ) then
		hovering = true

		if self:MouseClick( MOUSE_LEFT ) then
			if tab.TimeSinceClick == nil then
				tab.TimeSinceClick = CurTime()
				if tab.Callback then
					tab.Callback()
				else
					debugNotif("No callback for button!")
				end
			end
		end
	end

	if tab.TimeSinceClick != nil then	
		if ( CurTime() - tab.TimeSinceClick ) < 0.2 then
			surface.SetDrawColor( 50, 50, 50, 255 )
			surface.DrawRect(x, y, width, 18)
			surface.SetDrawColor( 0, 0, 0, 255 / 2 )
			surface.SetMaterial( self.GradientUp )
			surface.DrawTexturedRect( x, y, width, 18 )
		else
			tab.TimeSinceClick = nil
		end
	else

		surface.SetDrawColor( 40, 40, 40)
		surface.DrawRect(x, y, width, 18)
		surface.SetDrawColor( 0, 0, 0, 255 / 2 )
		surface.SetMaterial( self.GradientDown )
		surface.DrawTexturedRect( x, y, width, 18 )

		if hovering then
			surface.SetDrawColor( 60, 60, 60)
			surface.DrawRect( x + 2, y + 2, width - 4, 14 )
			surface.SetDrawColor( 0, 0, 0, 255 / 2 )
			surface.SetMaterial( self.GradientDown )
			surface.DrawTexturedRect( x + 2, y + 2, width - 4, 14 )
		end
	end
	
	draw.OutlinedBox(x, y, width, 18, 1, Color( 29, 29, 29))
	draw.OutlinedBox(x + 1, y + 1, width - 2, 16, 1, Color( 19, 19, 19))

	draw.SimpleText(tab.Label or "ERROR", "MenuFont", x + width / 2, y + 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.NoTexture()

	return 36 - 14
end

-- Combo Box Menu
function Base:DrawComboBox( x, y, width, tab, subp )
	x = x + 14
	width = width - 18

	if tab.DrawLabel != false then
		draw.SimpleText(tab.Label, "MenuFont", x + 5, y - 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		y = y + 14
	end

	if self:IsMouseInArea( x, y, width, 18 ) and self:IsInMainPanel( subp ) and !self:IsBehindSubPanel( subp ) then
		surface.SetDrawColor( 50, 50, 50)

		if self:MouseClick( MOUSE_LEFT ) then
			tab.Opened = !tab.Opened

			self:CloseOpenDropDowns()
		end
	elseif tab.Opened then
		surface.SetDrawColor( 50, 50, 50)
	else
		surface.SetDrawColor( 40, 40, 40)
	end

	surface.DrawRect(x, y, width, 18)

	surface.SetDrawColor( 0, 0, 0, 255 / 2 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x, y, width, 18 )
	
	draw.OutlinedBox(x, y, width, 18, 1, Color( 29, 29, 29))
	draw.OutlinedBox(x + 1, y + 1, width - 2, 16, 1, Color( 19, 19, 19))

	-- surface.DrawRect(x, y, width, 18)
	-- surface.SetDrawColor( 0, 0, 0, 255 / 2 )

	local ValueSting = "..."
	if #tab.Value > 0 then
		ValueSting = ""
	end
	local orginized_vals = {}
	for i = 1, #tab.Values do
		if util.TableContains(tab.Value, tab.Values[i]) then
			table.insert(orginized_vals, tab.Values[i])
		end
	end

	for i = 1, #orginized_vals do
		local txtWidth, txtHeight = draw.GetTextSize("MenuFont", ValueSting.. ", " .. tostring(orginized_vals[i]))
		if txtWidth > width - 30 then
			ValueSting = ValueSting.. "..."
			break
		end

		if i ~= 1 then
			ValueSting = ValueSting.. ", "
		end
		

		ValueSting = ValueSting.. tostring(orginized_vals[i])
	end
	
	


	draw.SimpleText(ValueSting or "ERROR", "MenuFont", x + 8, y + 2, Color(230, 230, 230, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	--draw.OutlinedBox(x, y, width, 18, 1, Color( 0, 0, 0, 255 ))

	draw.NoTexture()
	local rx = math.Round( x )
	local ry = math.Round( y )

	if !tab.Opened then
		surface.SetDrawColor( Color( 255, 255, 255 ) )

		surface.DrawPoly({
			{ x = rx + width - 11, y = ry + 8 },
			{ x = rx + width - 6, y = ry + 8 },
			{ x = rx + width - 8.5, y = ry + 11 }
		})
	else
		surface.SetDrawColor( Color( 255, 255, 255 ) )

		surface.DrawPoly({
			{ x = rx + width - 11, y = ry + 11 },
			{ x = rx + width - 8.5, y = ry + 8 },
			{ x = rx + width - 6, y = ry + 11 },
		})
	end

	y = y + 18

	if tab.Opened then
		self.DropDownBuffer = {x, y, width, tab, true}
	end

	if tab.DrawLabel == false then return 36 - 14 end

	return 36
end


-- Draw Dropdown Menu
function Base:DrawDropDown( x, y, width, tab, subp )
	x = x + 14
	width = width - 18

	if tab.DrawLabel != false then
		local labelColor = tab.Risk and Color(220, 220, 120, 255) or Color(255, 255, 255, 255)
		draw.SimpleText(tab.Label, "MenuFont", x + 5, y - 2, labelColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		y = y + 14
	end

	if self:IsMouseInArea( x, y, width, 18 ) and self:IsInMainPanel( subp ) and !self:IsBehindSubPanel( subp ) then
		surface.SetDrawColor( 50, 50, 50)

		if self:MouseClick( MOUSE_LEFT ) then
			tab.Opened = !tab.Opened

			self:CloseOpenDropDowns()
		end
	elseif tab.Opened then
		surface.SetDrawColor( 50, 50, 50)
	else
		surface.SetDrawColor( 40, 40, 40)
	end

	surface.DrawRect(x, y, width, 18)

	surface.SetDrawColor( 0, 0, 0, 255 / 2 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x, y, width, 18 )
	
	draw.OutlinedBox(x, y, width, 18, 1, Color( 29, 29, 29))
	draw.OutlinedBox(x + 1, y + 1, width - 2, 16, 1, Color( 19, 19, 19))

	-- surface.DrawRect(x, y, width, 18)
	-- surface.SetDrawColor( 0, 0, 0, 255 / 2 )


	
	draw.SimpleText(tab.Value or "ERROR", "MenuFont", x + 8, y + 2, Color(230, 230, 230, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	--draw.OutlinedBox(x, y, width, 18, 1, Color( 0, 0, 0, 255 ))

	draw.NoTexture()
	local rx = math.Round( x )
	local ry = math.Round( y )

	if !tab.Opened then
		surface.SetDrawColor( Color( 255, 255, 255 ) )

		surface.DrawPoly({
			{ x = rx + width - 11, y = ry + 8 },
			{ x = rx + width - 6, y = ry + 8 },
			{ x = rx + width - 8.5, y = ry + 11 }
		})
	else
		surface.SetDrawColor( Color( 255, 255, 255 ) )

		surface.DrawPoly({
			{ x = rx + width - 11, y = ry + 11 },
			{ x = rx + width - 8.5, y = ry + 8 },
			{ x = rx + width - 6, y = ry + 11 },
		})
	end

	y = y + 18

	if tab.Opened then
		self.DropDownBuffer = {x, y, width, tab, false}
	end

	if tab.DrawLabel == false then return 36 - 14 end

	return 36
end

function Base:DrawDropDownMenu( subp )
	local buf = self.DropDownBuffer
	if !buf then return end

	if !buf[4].Opened then self.DropDownBuffer = nil end

	local x, y, width, tab, combobox = buf[1], buf[2] + 2, buf[3], buf[4], buf[5]

	if not combobox then
		for i = 1, #tab.Values do
			local hovered = 0
			if self:IsMouseInArea( x, y, width, 17 ) and !self:IsBehindColorPicker() and (subp or !self:IsBehindSubMenu()) then
				surface.SetDrawColor( 50, 50, 50)
				hovered = 3
				if self:MouseClick( MOUSE_LEFT ) or self:MouseUnClick( MOUSE_LEFT ) then
					tab.Opened = false
					tab.Value = tab.Values[i]
				end
			else
				surface.SetDrawColor( 40, 40, 40)
			end

			surface.DrawRect(x, y, width, 18 )

		
			if tab.Value == tab.Values[i] then 
				draw.SimpleText(tab.Values[i] or "ERROR", "BoldMenuFont", x + 7 + hovered, y + 1, self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else
				draw.SimpleText(tab.Values[i] or "ERROR", "MenuFont", x + 7 + hovered, y + 1, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			
			

			y = y + 18
		end
	else
		
		for i = 1, #tab.Values do
			local hovered = 0
			if self:IsMouseInArea( x, y, width, 17 ) and !self:IsBehindColorPicker() and (subp or !self:IsBehindSubMenu()) then
				surface.SetDrawColor( 50, 50, 50)
				hovered = 3
				if self:MouseClick( MOUSE_LEFT ) then
					--tab.Opened = false
					if util.TableContains(tab.Value, tab.Values[i]) then
						util.TableRemoveByValue( tab.Value, tab.Values[i] )
					else 
						table.insert(tab.Value, tab.Values[i])
					end
				end
			else
				surface.SetDrawColor( 40, 40, 40)
			end

			surface.DrawRect(x, y, width, 18 )

			if util.TableContains(tab.Value, tab.Values[i]) then 
				draw.SimpleText(tab.Values[i] or "ERROR", "BoldMenuFont", x + 7 + hovered, y + 1, self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else
				draw.SimpleText(tab.Values[i] or "ERROR", "MenuFont", x + 7 + hovered, y + 1, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			

			y = y + 18
		end
	end

	draw.OutlinedBox(x, y - 18 * #tab.Values - 1, width, 18 * #tab.Values + 1, 1, Color( 29, 29, 29))
	draw.OutlinedBox(x + 1, y - 18 * #tab.Values, width - 2, 18 * #tab.Values - 1, 1, Color( 19, 19, 19))

	if not self:IsMouseInArea( x + 1, y - 18 * #tab.Values - 23, width - 2, 18 * #tab.Values - 1 + 23 ) and self:MouseClick( MOUSE_LEFT ) then tab.Opened = false end

	return true
end

function Base:DrawColorBox( x, y, width, tab, subp )
	x = x + 5
	width = width - 10

	if self.ColorPickerBuffer and self.ColorPickerBuffer[3] == tab then
		self.ColorPickerBuffer[1] = x
		self.ColorPickerBuffer[2] = y + 15
	end

	local w = draw.SimpleText(tab.Label, "MenuFont", x + 14, y - 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	local x_cp = x + width - 20
	-- surface.SetDrawColor( 255, 0, 0)
	-- surface.DrawRect(x_cp, y, 20, 10 )



	surface.SetDrawColor( tab.Value.r, tab.Value.g, tab.Value.b )
	surface.DrawRect( x_cp + 1, y + 1, 18, 8 )

	surface.SetDrawColor( 0, 0, 0, 255 / 2 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x_cp + 1, y + 1, 18, 8 )

	draw.OutlinedBox( x_cp - 1, y - 1, 22, 12, 1, Color(31,31,31))
	draw.OutlinedBox( x_cp, y, 20, 10, 1, Color( 19, 19, 19))

	local w = draw.SimpleText(tab.Label, "MenuFont", x + 14, y - 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	if (self:IsMouseInArea( x + 14, y, w, 10 ) or self:IsMouseInArea( x_cp, y, 20, 10 )) and self:MouseClick( MOUSE_LEFT ) and !self:IsBehindSubPanel( subp ) and self:IsInMainPanel( subp ) then
		tab.Opened = !tab.Opened
	end

	if tab.Opened then
		self.ColorPickerBuffer = { x_cp, y + 15, tab }
	end
end

function Base:DrawColorCheckBox( x, y, width, tab, subp )
	x = x + 5
	width = width - 10

	if self.ColorPickerBuffer and self.ColorPickerBuffer[3] == tab then
		self.ColorPickerBuffer[1] = x + width - 20
		self.ColorPickerBuffer[2] = y + 15
	end

	local hovering = false

	draw.OutlinedBox(x - 1, y - 1, 12, 12, 1, Color( 29, 29, 29))
	draw.OutlinedBox(x, y, 10, 10, 1, Color( 19, 19, 19))

	surface.DrawRect( x + width - 20, y, 20, 10 )


	surface.SetDrawColor( tab.Value[2].r, tab.Value[2].g, tab.Value[2].b )
	surface.DrawRect( x + 1 + width - 20, y + 1, 18, 8 )

	surface.SetDrawColor( 0, 0, 0, 255 / 2 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x + 1 + width - 20, y + 1, 18, 8 )

	draw.OutlinedBox( x + width - 20 - 1, y - 1, 22, 12, 1, Color(31,31,31))
	draw.OutlinedBox( x + width - 20, y, 20, 10, 1, Color( 19, 19, 19))

	local labelColor = tab.Risk and Color(220, 220, 120, 255)
	local w, h = draw.SimpleText(tab.Label, "MenuFont", x + 14, y - 3, labelColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	if self:IsMouseInArea( x, y, 14 + w, 10 ) and self:IsInMainPanel() then
		if self:MouseClick( MOUSE_LEFT ) and !self:IsBehindSubPanel( subp ) then
			tab.Value[1] = !tab.Value[1]
			if tab.Callback then
				tab.Callback( tab.Value[1], tab )
			end
		else
			hovering = true
		end
	end

	if self:IsMouseInArea(x + width - 20, y, 20, 10) and self:IsInMainPanel() and self:MouseClick(MOUSE_LEFT) and !self:IsBehindSubPanel( subp ) then
		tab.Opened = true
		if self.ColorPickerBuffer then
			self.ColorPickerBuffer[3].Opened = false
		end
	end

	if tab.Opened then
		self.ColorPickerBuffer = {x + width - 20, y + 15, tab}
	end

	
	if hovering and !tab.Value[1] then
		surface.SetDrawColor( 41, 41, 41)
		surface.DrawRect(x + 1, y + 1, 8, 8 )
		surface.SetDrawColor( 61, 61, 61)
		surface.DrawRect(x + 2, y + 2, 6, 6 )
	elseif tab.Value[1] then
		surface.SetDrawColor( 60, 60, 60)
		surface.DrawRect(x + 1, y + 1, 8, 8 )

		surface.SetDrawColor( self.HighlightTab.r, self.HighlightTab.g, self.HighlightTab.b )
		surface.DrawRect(x + 1, y + 1, 8, 8 )
	else
		surface.SetDrawColor( 39, 39, 39)
		surface.DrawRect(x + 1, y + 1, 8, 8 )
	end


	surface.SetDrawColor( 0, 0, 0, 255 / 2 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x + 1, y + 1, 8, 8 )
end

function Base:DrawColorPicker()
	local buf = self.ColorPickerBuffer
	if !buf then return end

	if !buf[3].Opened then self.ColorPickerBuffer = nil end

	local x, y, tab = buf[1], buf[2], buf[3]

	if !tab.HSV then
		tab.HSV = {}
	end

	local t
	local alp

	if !tab.Value.r then
		t = tab.Value[2]
		if !t.a then t.a = 255 end
		alp = t.a
	elseif !tab.Value.a then
		tab.Value.a = 255
		alp = 255
	end

	alp = t and t.a or tab.Value.a

	if !tab.HSV.h then
		tab.HSV.h, tab.HSV.s, tab.HSV.v = ColorToHSV( t and t or tab.Value )
	end

	local hue, sat, val = tab.HSV.h, tab.HSV.s, tab.HSV.v

	if self:IsMouseInArea( x + 200, y + 5, 20, 190 ) and self:MouseClick( MOUSE_LEFT ) then
		tab.SettingHue = true
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		tab.SettingHue = false
	end

	if tab.SettingHue then
		local clampedMouseY = math.Clamp( self.RawMouseY, y + 5, y + 190 + 5 )
		local desiredHue = math.Remap( clampedMouseY, y + 5, y + 190 + 5, 360, 0 )
		tab.HSV = { h = desiredHue, s = sat, v = val }

		if !tab.Value.r then
			tab.Value[2] = HSVToColor( hue, sat, val )
		else
			tab.Value = HSVToColor( hue, sat, val )
		end

		hue = desiredHue
	end

	draw.NoTexture()

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect(x - 1, y - 1, 300 + 2, 200 + 2)

	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawRect( x, y, 300, 200)

	-- surface.SetDrawColor( 255, 255, 255, 255 )
	-- surface.DrawTexturedRect( x + 5, y + 5, 190, 190 )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( x + 5, y + 5, 190, 190 )

	-- draw the saturation box ( how grey it is )
	surface.SetDrawColor( HSVToColor( hue, 1, 1 ), 255 )
	surface.SetMaterial( self.GradientRight )
	surface.DrawTexturedRect( x + 5, y + 5, 190, 190 )

	-- surface.SetDrawColor( 255, 255, 255, 255 )
	-- surface.SetMaterial( self.GradientLeft )
	-- surface.DrawTexturedRect( x + 5, y + 5, 190, 190 )

	-- draw the value box
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x + 5, y + 5, 190, 190 )
	surface.SetDrawColor( 0, 0, 0, 255 / 1.5 )
	surface.DrawTexturedRect( x + 5, y + 5, 190, 190 )

	-- draw the value box
	-- local colorRange = {
	-- 	[1] = {start = 0, color = HSVToColor( hue, 1, 1 )},
	-- 	[2] = {start = 190, color = Color( 0, 0, 0 )},
	-- }

	-- surface.SetDrawColor( HSVToColor( hue, 1, 1 ) )
	-- surface.DrawRect( x + 5, y + 5, 190, 190 )

	-- for i = 0, 190 do
	-- 	surface.SetDrawColor( 0, 0, 0, Lerp( i / 190, 0, 255 ) )
	-- 	surface.DrawRect( x + i + 5, y + 5, 1, 190 )
	-- end

	-- for i = 0, 190 do
	-- 	surface.SetDrawColor( Color( 255, 255, 255, Lerp( i / 190, 0, 255 ) ) )
	-- 	surface.DrawRect( x + 5, y + 5 + i, 190, 1 )
	-- end

	-- draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( x + 5, y + 5, 190, 190 )


	if self:IsMouseInArea( x + 225, y + 5, 20, 190 ) and self:MouseClick( MOUSE_LEFT ) then
		tab.SettingAlpha = true
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		tab.SettingAlpha = false
	end

	if tab.SettingAlpha then
		local clampedMouseY = math.Clamp( self.RawMouseY, y + 5, y + 190 + 5 )
		local desiredAlpha = math.Remap( clampedMouseY, y + 5, y + 190 + 5, 255, 0 )

		if !tab.Value.r then
			tab.Value[2].a = desiredAlpha
		else
			tab.Value.a = desiredAlpha
		end

		alp = desiredAlpha
	end

	if self:IsMouseInArea( x + 5, y + 5, 190, 190 ) and self:MouseClick( MOUSE_LEFT ) then
		tab.SettingSatAndVal = true
	end

	if self:MouseUnClick( MOUSE_LEFT ) then
		tab.SettingSatAndVal = false
	end

	if tab.SettingSatAndVal then
		local clampX = math.Clamp( self.RawMouseX, x + 5, x + 190 + 5 )
		local clampY = math.Clamp( self.RawMouseY, y + 5, y + 190 + 5 )
		local desiredSat = math.Remap( clampX, x + 5, x + 190 + 5, 0, 1 )
		local desiredVal = 1 - math.Remap( clampY, y + 5, y + 190 + 5, 0, 1 )
		tab.HSV.s = desiredSat
		tab.HSV.v = desiredVal
		if !tab.Value.r then
			tab.Value[2] = HSVToColor( hue, desiredSat, desiredVal )
		else
			tab.Value = HSVToColor( hue, desiredSat, desiredVal )
		end
	end

	local pickerW = 6
	local pickerX = math.Clamp( math.Remap( sat, 0, 1, x + 5, x + 190 + 5 ), x + 5 + pickerW / 2, x + 190 + 5 - pickerW / 2 )
	local pickerY = math.Clamp( math.Remap( 1 - val, 0, 1, y + 5, y + 190 + 5 ), y + 5 + pickerW / 2, y + 190 + 5 - pickerW / 2 )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( pickerX - pickerW / 2, pickerY - pickerW / 2, pickerW, pickerW )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( pickerX - pickerW / 2, pickerY - pickerW / 2, pickerW, pickerW )

	-- surface.SetMaterial( self.ColorPickerCursor )
	-- surface.DrawTexturedRect( pickerX - 4, pickerY - 4, 8, 8 )

	-- Draw the Hue bar
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.HueBar )
	surface.DrawTexturedRect( x + 200, y + 5, 20, 190 )

	local huePos = math.Remap( 360 - hue, 0, 360, y + 5, y + 5 + 190 )

	huePos = math.Clamp( huePos, y + 5 + 2, y + 190 + 5 - 3 )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( x + 200, huePos - 2, 20, 5 )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( x + 200, huePos, 20, 1 )
	surface.DrawRect( x + 200, huePos - 1, 20, 3 )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect(x + 200, y + 5, 20, 190)

	-- Draw the alpha bar
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.GradientUp )
	surface.DrawTexturedRect( x + 225, y + 5, 20, 190 )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetMaterial( self.GradientDown )
	surface.DrawTexturedRect( x + 225, y + 5, 20, 190 )

	if t then tab.Value[2].a = alp else tab.Value.a = alp end

	local alphaPos = math.Remap( t and t.a or tab.Value.a, 255, 0, y + 5, y + 5 + 190 )

	alphaPos = math.Clamp( alphaPos, y + 5 + 2, y + 190 + 5 - 3 )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( x + 225, alphaPos - 2, 20, 5 )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( x + 225, alphaPos, 20, 1 )
	surface.DrawRect( x + 225, alphaPos - 1, 20, 3 )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect(x + 225, y + 5, 20, 190)

	-- draw preview color
	local betweenX = x + (245 + 300) / 2 - 20
	surface.SetDrawColor( t and t.r or tab.Value.r, t and t.g or tab.Value.g, t and t.b or tab.Value.b, t and t.a or tab.Value.a )
	surface.DrawRect( betweenX, y + 5, 40, 40 )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( betweenX, y + 5, 40, 40 )

	local hexText = string.format( "#%02x%02x%02x", t and t.r or tab.Value.r, t and t.g or tab.Value.g, t and t.b or tab.Value.b )

	draw.SimpleText( hexText, "MenuFont", betweenX + 40 / 2, y + 45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	if self:IsMouseInArea( x + 255 - 1, y + 5 - 1, 40 + 2, 40 + 2 ) and self:MouseClick( MOUSE_LEFT ) then
		tab.Opened = false
	end
end

function Base:DrawScrollBar( lowestY )
	--if lowestY <= self.PosY + self.SizeY and self.ScrollOffset != 0 then
	--	self.ScrollOffset = 0
	--end
	-- if lowestY <= self.PosY + self.SizeY and self.ScrollOffset == 0 then return end
	--if self.ScrollOffset == 0 then return end

	-- lowestY = lowestY + self.ScrollOffset

	-- if self:MouseDown( MOUSE_WHEEL_DOWN ) then
	-- 	self.ScrollOffset = self.ScrollOffset + 10
	-- end
	-- surface.DrawRect( 0, lowestY, ScrW(), 3 )
	-- local barX = self.PosX + self.SizeX - self.ScrollBarWidth - 1
	-- local barH = self.SizeY - self.TabHeight - 2
	-- local barY = self.PosY + self.TabHeight + 1

	-- self.ScrollBarY = self.ScrollBarY or barY

	-- surface.SetDrawColor( 60, 60, 60, 255 )
	-- surface.DrawRect( barX, barY, self.ScrollBarWidth, barH)

	-- self.ScrollPos = {x = barX, y = barY, w = self.ScrollBarWidth, h = barH ^ 2 / (lowestY - barY) }
	--[[self.ScrollPos.y = math.Remap( self.ScrollOffset, barY - self.PosY, lowestY - self.PosY,
			barY, barY + (barH + self.ScrollPos.h))]]
	-- self.ScrollBarY = self.ScrollPos.y
	--self.PosY + el.PosY + self.TabHeight + 12 - self.ScrollOffset
	--self.ScrollBarY = math.Clamp( self.ScrollBarY, barY, self.SizeY - self.ScrollPos.h)
	--print(self.SizeY - self.ScrollPos.h)

	-- if self:MouseClick( MOUSE_LEFT ) then
	-- 	self.Scrolling = self:IsMouseInArea( self.ScrollPos.x, self.ScrollBarY, self.ScrollPos.w, self.ScrollPos.h )
	-- 	if self.Scrolling then
	-- 		self.ScrollYOffset = self.RawMouseY - self.ScrollBarY
	-- 	end
	-- end

	-- if self:MouseUnClick( MOUSE_LEFT ) then
	-- 	self.Scrolling = false
	-- end

	-- if self.Scrolling then
	-- 	self.ScrollBarY = self.RawMouseY - self.ScrollYOffset
	-- 	self.ScrollOffset = math.Remap( self.ScrollBarY, barY, barY + barH, 0, lowestY )
	-- -- 	--surface.DrawRect( barX + self.ScrollBarWidth / 2, barY, self.ScrollBarWidth / 2, self.ScrollPos.h)
	-- -- 	--[[self.ScrollOffset = math.Remap( self.RawMouseY - self.ScrollYOffset,
	-- -- 		barY, barY + (barH - self.ScrollPos.h),
	-- -- 		barY - self.PosY, lowestY - self.PosY)]]
	-- -- 	self.ScrollBarY = self.RawMouseY - self.ScrollYOffset
	-- -- 	--self.ScrollOffset = math.Remap( self.ScrollBarY, barY, barY + barH, barY, lowestY )
	-- -- 	self.ScrollOffset = math.Remap( self.ScrollBarY, barY, barY + barH, barY - self.ScrollOffset, lowestY )
	-- -- 	--self.ScrollOffset =

	-- -- 	self.ScrollOffset = self.ScrollOffset < 0 and 0 or self.ScrollOffset
	-- -- --	self.ScrollOffset = self.RawMouseY - self.ScrollYOffset - (self.PosY + self.TabHeight + 1)
	-- -- 	--self.ScrollOffset = math.Clamp( self.ScrollOffset, 0, self.SizeY - self.ScrollPos.h - self.TabHeight - 2)
	-- -- 	--self.ScrollOffset = self.ScrollOffset < 0 and 0 or self.ScrollOffset
	-- end

	-- surface.SetDrawColor( 100, 100, 100, 255 )

-- local drawPos =

	-- surface.DrawRect( self.ScrollPos.x, self.ScrollBarY, self.ScrollPos.w, self.ScrollPos.h )
end


function Base.QuadPortions(x, y, w, h)
	--print(h)
	local p = 4 -- use 8 too

	local points = {}
	local sizeX = math.floor(w/p)
	local sizeY = math.floor(h/p)
	local curpos ={
		x = x,
		y = y
	}
	for x_move = 0, p do
		points[x_move + 1] = {}
		curpos.x = x + (sizeX*x_move)
		for y_move = 0, p do
			curpos.y = y + (sizeY*y_move)		
			table.insert(points[x_move + 1], {x = curpos.x, y = curpos.y, rel = { x = curpos.x - x, y = curpos.y - y }})
		end
	end
	return points 
end

--[[
	Snap = {
		X = 1,
		Y = 1,
		W = 4,
		H = 4,
	},
	PosX = 10,
	PosY = 10,
	SizeX = 200,
	SizeY = 300,
]]

function Base.GetPointCorners(el, points)
	if el.Snap == nil then return nil end
	local snap = el.Snap

	local corner = {x = points[snap.x][snap.y].rel.x + 4, y = points[snap.x][snap.y].rel.y + 4}
	local size = {w = points[snap.x + snap.w][snap.y + snap.h].rel.x - 8, h = points[snap.x + snap.w][snap.y + snap.h].rel.y - 8} 
	size.w = size.w - corner.x
	size.h = size.h - corner.y + 26

	el.PosX = corner.x + 6
	el.PosY = corner.y + 6
	el.SizeX = size.w
	el.SizeY = size.h
	
end


--[[
local colorRange = {
	[1] = {start = 0, color = Color( 255, 0, 0 )},
	[2] = {start = 50, color = Color( 255, 255 / 2, 0 )},
	[3] = {start = 100, color = Color( 0, 255, 0 )}
}
--]]
function draw.GradientOutlinedRect(x, y, w, h, girth, col)
	local colorRange = {
		[1] = {start = 0, color = col},
		[2] = {start = girth - 1, color = Color(col.r, col.g, col.b, 0)},
	}

	for i = 0, girth - 1 do
		draw.OutlinedBox(x + i, y + i, w - (i * 2), h - (i * 2), 1, util.ColorLerp(i, colorRange) )
	end

end


function Base:Draw()
	--draw.GradientOutlinedRect(40, 40, 10, 10, 5, Color(20, 20, 20, 255))
	surface.SetAlphaMultiplier( 1 )
	if !self.Visible then return end

	
	if self.MenuFading then
		surface.SetAlphaMultiplier( self.MenuAlpha )
	end
	-- DRAW THE MAIN PANEL + BEZEL

	self.HighlightTab = Menu.Func.GetVar( "Settings", "Other Settings", "Menu Accent Color" )

	if self.grabbingBottom or self.grabbingSide then
		draw.OutlinedBox(self.PosX - self.Bezel - 1, self.PosY - self.Bezel - 1, self.SizeX + self.Bezel * 2 + 2, self.SizeY + self.Bezel * 2 + 2, 1, self.HighlightTab )
	end
	draw.OutlinedBox(self.PosX - self.Bezel, self.PosY - self.Bezel, self.SizeX + self.Bezel * 2, self.SizeY + self.Bezel * 2, 1, Color( 20, 20, 20, 255 ) )
	draw.OutlinedBox(self.PosX - self.Bezel + 1, self.PosY - self.Bezel + 1, self.SizeX + self.Bezel * 2 - 2, self.SizeY + self.Bezel * 2 - 2, 1, Color( 40, 40, 40, 255 ) )
	draw.Rect(self.PosX - self.Bezel + 2, self.PosY - self.Bezel + 2, self.SizeX + self.Bezel * 2 - 4, self.SizeY + self.Bezel * 2 - 4, Color( 20, 20, 20, 255 ) )
	-- THESE ARE THE TABS
	draw.Rect(self.PosX - self.Bezel + 3, self.PosY - self.Bezel + 3, self.SizeX, self.TabHeight - 3, Color( 30, 30, 30, 255 ) )
	

	draw.GradientOutlinedRect(self.PosX - self.Bezel + 3, self.PosY - self.Bezel + 3, self.SizeX, self.TabHeight - 3, 5, Color( 20, 20, 20, 170 ) )
	draw.Rect(self.PosX - self.Bezel + 3, self.PosY - self.Bezel + 3, self.SizeX, self.TabHeight - 3, Color( 30, 30, 30, 255 ) )

	surface.SetDrawColor( Color( 40, 40, 40, 255 ) )
	surface.DrawLine( self.PosX - self.Bezel + 1, self.PosY - self.Bezel + self.TabHeight + 1, self.PosX - self.Bezel + self.SizeX + self.Bezel * 2 - 1, self.PosY - self.Bezel + self.TabHeight + 1 )

	draw.Rect(self.PosX + self.LeftAreaPadding - 2, self.PosY - self.Bezel + self.TabHeight + 1, 1, self.SizeY - self.TabHeight + 4, Color( 40, 40, 40, 255 ) )




	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( 8 ) -- STENCIL_ALWAYS
	render.SetStencilPassOperation( 1 ) -- STENCIL_KEEP
	render.SetStencilFailOperation( 1 ) -- STENCIL_KEEP
	render.SetStencilZFailOperation( 1 ) -- STENCIL_KEEP
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilCompareFunction( 3 ) -- STENCIL_EQUAL
	render.SetStencilReferenceValue( 1 )
	render.ClearStencilBufferRectangle( self.PosX - self.Bezel + 3, self.PosY - self.Bezel + 3, self.PosX - self.Bezel + 3 + self.SizeX, self.PosY - self.Bezel + self.TabHeight + 2, 1 )
	draw.SimpleText( "t0ny hack", "BoldMenuFont", self.PosX + 5, self.PosY - self.Bezel + 6 , self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	--draw.SimpleText( "t0ny hack", "BoldMenuFont", self.PosX + 5 - ( 50 - ( 50 * util.Ease(self.MenuAlpha) ) ), self.PosY - self.Bezel + 6 , self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	local y_off = self.PosX + self.SizeX - 10 - util.EaseVal(math.abs(self.MenuAlpha - 1), 300, 0)

	local timesincefade = self.TabSwitchTime and SysTime() - self.TabSwitchTime or SysTime() - 1
	local dif = math.Clamp(timesincefade/.20, 0, 1)



	for trunum, tab in ipairs( util.Table_reverse(Menu.Layout) ) do

		-- print(tab.Title)
		-- print(#Menu.Layout - (trunum - 1))
		local num = #Menu.Layout - (trunum - 1)
		-- local tabWidth = self.SizeX / #Menu.Layout
		-- local tabXPos = self.PosX + tabWidth * (num - 1)

		local txtWidth, txtHeight = draw.GetTextSize("NonOutlinedMenuFont", tab.Title)


		local txt_clr = Color(230, 230, 230, 150)
		if tab.Hovered and self.ActiveTab != num then
			txt_clr = Color(230, 230, 230, 230)
		end

		-- surface.DrawRect( tabXPos, self.PosY, tabWidth, self.TabHeight )
		-- surface.SetDrawColor( 0, 0, 0, 255 / 2 )
		-- surface.SetMaterial( self.GradientDown )
		-- surface.DrawTexturedRect( tabXPos, self.PosY, tabWidth, self.TabHeight )

		-- Draw highlight shit on active tab

		if self.ActiveTab == num then
			draw.HalfRoundedBox( 4, y_off - txtWidth - 6, self.PosY + self.TabHeight - txtHeight - 6, txtWidth + 13, 18, Color( 20, 20, 20, 255 * dif ) )
			draw.HalfRoundedBox( 4, y_off - txtWidth - 5, self.PosY + self.TabHeight - txtHeight - 5, txtWidth + 11, 17, Color( 40, 40, 40, 255 * dif) )
			draw.HalfRoundedBox( 4, y_off - txtWidth - 4, self.PosY + self.TabHeight - txtHeight - 4, txtWidth + 9, 17, Color( 20, 20, 20, 255 * dif ) )

			draw.SimpleText( tab.Title, "NonOutlinedMenuFont", y_off - txtWidth + 1, self.PosY + self.TabHeight - txtHeight - 5 + (2 *dif), self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif self.PreviousTab == num then
			local revrseDif = math.abs(dif - 1)

			draw.HalfRoundedBox( 4, y_off - txtWidth - 6, self.PosY + self.TabHeight - txtHeight - 6, txtWidth + 13, 18, Color( 20, 20, 20, 255 * revrseDif ) )
			draw.HalfRoundedBox( 4, y_off - txtWidth - 5, self.PosY + self.TabHeight - txtHeight - 5, txtWidth + 11, 17, Color( 40, 40, 40, 255 * revrseDif) )
			draw.HalfRoundedBox( 4, y_off - txtWidth - 4, self.PosY + self.TabHeight - txtHeight - 4, txtWidth + 9, 17, Color( 20, 20, 20, 255 * revrseDif ) )

			draw.SimpleText( tab.Title, "NonOutlinedMenuFont", y_off - txtWidth + 1, self.PosY + self.TabHeight - txtHeight - 5 + (2 *revrseDif), txt_clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else-- draw normally
			-- surface.SetDrawColor( 0, 0, 0, 255 )
			draw.SimpleText( tab.Title, "NonOutlinedMenuFont", y_off - txtWidth + 1, self.PosY + self.TabHeight - txtHeight - 5, txt_clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
		y_off = y_off - txtWidth - 12
	end

	render.SetStencilEnable( false )


	-- DRAW THE TABS
	--[[
	for num, tab in ipairs( Menu.Layout ) do
		local tabWidth = self.SizeX / #Menu.Layout
		local tabXPos = self.PosX + tabWidth * (num - 1)

		if tab.Hovered and self.ActiveTab != num then
			surface.SetDrawColor( 80, 80, 80, 255 )
		else
			surface.SetDrawColor( 60, 60, 60, 255 )
		end

		-- surface.DrawRect( tabXPos, self.PosY, tabWidth, self.TabHeight )
		-- surface.SetDrawColor( 0, 0, 0, 255 / 2 )
		-- surface.SetMaterial( self.GradientDown )
		-- surface.DrawTexturedRect( tabXPos, self.PosY, tabWidth, self.TabHeight )

		-- Draw highlight shit on active tab
		if self.ActiveTab == num then
			tabToDraw = num
			draw.SimpleText( tab.Title, "MenuFont", tabXPos + tabWidth / 2, self.PosY + 20 / 2, self.HighlightTab, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			surface.SetDrawColor( self.HighlightTab.r, self.HighlightTab.g, self.HighlightTab.b )
			surface.DrawRect( tabXPos, self.PosY + self.TabHeight - 2, tabWidth, 3 )
		else -- draw normally
			surface.SetDrawColor( 0, 0, 0, 255 )
			draw.SimpleText( tab.Title, "MenuFont", tabXPos + tabWidth / 2, self.PosY + 20 / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end--]]

	-- inner dark outline to prevent overlapping
	-- draw.OutlinedBox(self.PosX - 1, self.PosY - 1, self.SizeX + 1, self.SizeY + 1, 1, Color( 0, 0, 0, 255 ))

	draw.Rect(self.PosX + self.LeftAreaPadding - 2, self.PosY + self.TabHeight, 1, self.SizeY - self.TabHeight, Color( 40, 40, 40, 255 ) )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( 8 ) -- STENCIL_ALWAYS
	render.SetStencilPassOperation( 1 ) -- STENCIL_KEEP
	render.SetStencilFailOperation( 1 ) -- STENCIL_KEEP
	render.SetStencilZFailOperation( 1 ) -- STENCIL_KEEP
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilCompareFunction( 3 ) -- STENCIL_EQUAL
	render.SetStencilReferenceValue( 1 )
	render.ClearStencilBufferRectangle( self.PosX, self.PosY + self.TabHeight, self.PosX + self.SizeX, self.PosY + self.SizeY, 1 )

	surface.SetDrawColor(25, 25, 25, 255)
	surface.DrawRect(self.PosX - self.Bezel + 3, self.PosY - self.Bezel + 3, self.SizeX + self.Bezel * 2 - 5, self.SizeY + self.Bezel * 2 - 5)

	draw.GradientOutlinedRect(self.PosX + self.LeftAreaPadding, self.PosY + self.TabHeight, self.SizeX - self.LeftAreaPadding, self.SizeY - self.TabHeight, 7, Color( 20, 20, 20, 255) )
	draw.Rect(self.PosX + self.LeftAreaPadding - 3, self.PosY + self.TabHeight, 3, self.SizeY - self.TabHeight, Color( 20, 20, 20, 255 ) )
	draw.Rect(self.PosX + self.LeftAreaPadding - 2, self.PosY + self.TabHeight, 1, self.SizeY - self.TabHeight, Color( 40, 40, 40, 255 ) )
	

	--draw.GradientOutlinedRect(self.PosX, self.PosY + self.TabHeight, self.LeftAreaPadding - 4, self.SizeY - self.TabHeight, 7, Color( 20, 20, 20, 255) )
	-- draw.Rect(self.PosX + self.LeftAreaPadding + 4, self.PosY + self.TabHeight + 4, self.SizeX - self.LeftAreaPadding - 8, self.SizeY - self.TabHeight - 8, Color( 0, 255, 255, 10 ) )
	self.Points = self.QuadPortions(self.PosX + self.LeftAreaPadding + 4, self.PosY + self.TabHeight + 4, self.SizeX - self.LeftAreaPadding - 8, self.SizeY - self.TabHeight - 8)
	-- for k, row in pairs(self.Points) do
	-- 	for k1, poin in pairs(row) do
	-- 		draw.Rect(poin.x-1, poin.y-1, 3, 3, Color( 255, 0, 255, 100 ) )
	-- 		draw.Rect(poin.x, poin.y, 1, 1, Color( 255, 255, 255, 255 ) )
	-- 	end
	-- end



	

	local lowestY = 0
	local children = Menu.Layout[self.ActiveTab].Children
	if children == nil then
		local layout = Menu.Layout[self.ActiveTab]

		local y_off = self.PosY + self.TabHeight + 10
		local x_pos = self.PosX + 12 - ( 100 - ( 100 * util.Ease(self.MenuAlpha) ) )

		local timesincefade = layout.SubTabTime and SysTime() - layout.SubTabTime or SysTime() - 1
		local dif = math.Clamp(timesincefade/.20, 0, 1)

		for num, tab in ipairs(layout.SubTabs) do
			
			if num == layout.ActiveSubTab then
				surface.SetDrawColor( 40, 40, 40, 255 )
				surface.SetMaterial( self.GradientLeft )
				surface.DrawTexturedRect(x_pos - 10, math.floor(y_off + 1) - 4, (self.LeftAreaPadding *.8) * util.Ease(dif), 20)
				--draw.Rect(x_pos, math.floor(y_off + 1), 2, 12, self.HighlightTab )
				draw.SimpleText( tab.Title, "MenuFont", x_pos + (4 * util.Ease(dif)), y_off, self.HighlightTab, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			elseif layout.PreviousSubTab == num and dif != 1 then
				local dif = 1 - dif
				surface.SetDrawColor( 40, 40, 40, 255 )
				surface.SetMaterial( self.GradientLeft )
				surface.DrawTexturedRect(x_pos - 10, math.floor(y_off + 1) - 4, (self.LeftAreaPadding *.8) * util.Ease(dif), 20)
				--draw.Rect(x_pos, math.floor(y_off + 1), 2, 12, self.HighlightTab )
				draw.SimpleText( tab.Title, "MenuFont", x_pos + (4 * util.Ease(dif)), y_off, tab.Hovered and Color(230, 230, 230, 230) or Color(230, 230, 230, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else

				draw.SimpleText( tab.Title, "MenuFont", x_pos, y_off, tab.Hovered and Color(230, 230, 230, 230) or Color(230, 230, 230, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			y_off = y_off + 20

		end
		children = layout.SubTabs[layout.ActiveSubTab].Children
	end
	draw.GradientOutlinedRect(self.PosX, self.PosY + self.TabHeight, self.LeftAreaPadding - 3, self.SizeY - self.TabHeight, 7, Color( 20, 20, 20, 255) )

	for num, el in ipairs(children) do
		if el.Type == "Panel" then
			if el.Snap ~= nil then
				self.GetPointCorners(el, self.Points)
			end
			local textW, textH = surface.GetTextSize( el.Title )
			textW = textW + 14
			local PanelPosX = self.PosX + self.LeftAreaPadding + el.PosX

			local y = self.PosY + el.PosY + self.TabHeight + 12 - self.ScrollOffset 
			local adjustedPosY = el.PosY - self.ScrollOffset

			--self:DragPanel( el, PanelPosX + el.SizeX / 2 - textW / 2, self.PosY + el.PosY + self.TabHeight - textH / 2, textW, textH )
			surface.SetDrawColor( 40, 40, 40, 128 )
			surface.DrawRect(PanelPosX, self.PosY + adjustedPosY + self.TabHeight, el.SizeX, el.SizeY - self.TabHeight)

			if !el.Controls then continue end

			if el.Title == "Fake Angles" then
				local showdesync = Menu.Func.GetVar("Misc", "Fake Angles", "Fake Mode") == "Desync"

				for i, v in ipairs({"Desync Direction", "Break LBY", "Flick Yaw"}) do
					Menu.Func.Visible(showdesync, "Misc", "Fake Angles", v)
				end

				for i, v in ipairs({"Fake Direction", "Fake Yaw"}) do
					Menu.Func.Visible(not showdesync, "Misc", "Fake Angles", v)
				end
			
			end

			for k, v in ipairs( el.Controls ) do
				if v.Visible == false then continue end
				if v.Type == "CheckBox" then
					self:DrawCheckBox( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v )
					y = y + 14
				elseif v.Type == "Button" then
					y = y + self:DrawButton( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v )
				elseif v.Type == "Slider" then
					y = y + self:DrawSlider( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v )
				elseif v.Type == "ComboBox" then
					y = y + self:DrawComboBox( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v )
				elseif v.Type == "DropDown" then
					y = y + self:DrawDropDown( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v )
				elseif v.Type == "ColorPicker" then
					self:DrawColorBox( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v)
					y = y + 14
				elseif v.Type == "SubPanel" then

				elseif v.Type == "ColorCheckBox" then
					self:DrawColorCheckBox( PanelPosX + 7, y, math.Clamp( el.SizeX - 15, 10, 255 ), v )
					y = y + 14
				end
			end
			

			if el.SizeY == 0 or el.AutoSized then
				el.SizeY = y - self.PosY - adjustedPosY + 5
				el.AutoSized = true
			end

			local panelY = self.PosY + adjustedPosY + self.TabHeight
			draw.GradientOutlinedRect(PanelPosX + 2, panelY + 2, el.SizeX - 4, el.SizeY - self.TabHeight - 4, 4, Color( 20, 20, 20, 255) )

			draw.OutlinedBox(PanelPosX, panelY, el.SizeX, el.SizeY - self.TabHeight, 1, Color( 20, 20, 20, 255 ))

			draw.OutlinedBox(PanelPosX + 1, panelY + 1, el.SizeX - 2, el.SizeY - self.TabHeight - 2, 1, Color( 40, 40, 40, 255 ))

			lowestY = lowestY < panelY + el.SizeY and panelY + el.SizeY - self.TabHeight or lowestY

			-- surface.SetDrawColor( 50, 50, 50, 255 )
			-- surface.DrawRect( PanelPosX + el.SizeX / 2 - textW / 2, self.PosY + adjustedPosY + self.TabHeight, textW, 2 )
			draw.SimpleText(el.Title, "MenuFont", PanelPosX  + 10, self.PosY + adjustedPosY + self.TabHeight - 6, el.Hovered and Color(255, 0 , 0, 255) or Color(230, 230, 230, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end
	surface.SetAlphaMultiplier( 1 )
	render.SetStencilEnable( false )
	surface.SetAlphaMultiplier( 1 )
	-- surface.DrawRect( 0, lowestY, ScrW(), 3 )
	self:DrawScrollBar(lowestY)
	self:DrawDropDownMenu()
	self:DrawColorPicker()
	self:DrawSubPanel()
end

Base:BuildLookupTable()
Base:LoadVars()
Base:Center()

Menu.Func.AddCallback( function()
	local cfg_name = Menu.Func.GetVar( "Settings", "Configs", "Config" )
	Menu.Base:SaveVars(cfg_name)
end
, "Settings", "Configs", "Save Config")

Menu.Func.AddCallback( function()
	local cfg_name = Menu.Func.GetVar( "Settings", "Configs", "Config" )
	Menu.Base:LoadVars(cfg_name)
end
, "Settings", "Configs", "Load Config")

function Menu.Draw()
	if hideOverlay then return end
	Base:Think()
	Base:Draw()
end

-- hook.Add("DrawOverlay", "asdf", drawMenu )