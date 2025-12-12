
local lastFakeYawOffset = 0
local function Adaptive(mode)

	local eyepos = Aimbot.VelocityPrediction( LocalPlayer(), R.Player.GetShootPos( LocalPlayer() ))

	local closest = nil
	local center = {x = ScrW() / 2, y = ScrH() / 2}

	if mode == 1 then

		for k, v in next, player.GetAll() do
			if v == LocalPlayer() or !R.Player.Alive( v ) or R.Entity.IsDormant( v ) or !IsValid( v ) then continue end

			local playereye = R.Player.GetShootPos( v )

			local dist = R.Vector.Distance(playereye, eyepos)

			if closest then
				
				if dist < closest.dist then
					closest = {dist = dist, plyr = v, eyes = playereye}
				end
			else
				closest = {dist = dist, plyr = v, eyes = playereye}
			end
		end

	else
		for k, v in next, player.GetAll() do
			if v == LocalPlayer() or !R.Player.Alive( v ) or R.Entity.IsDormant( v ) or !IsValid( v ) then continue end

			local playereye = R.Player.GetShootPos( v )

			cam.Start3D()
				local top = R.Vector.ToScreen( playereye )
			cam.End3D()

			if top.visible then
				local dist = util.getDistance(top, center)

				if closest then
					if dist < closest.dist then 
						closest = {dist = dist, plyr = v, eyes = playereye } 
					end
				else
					closest = {dist = dist, plyr = v, eyes = playereye } 
				end
			end
		end

	end

	if !closest then 
		return nil
	end

	closest.eyes = Aimbot.VelocityPrediction( closest.plyr, closest.eyes )

	local ang = R.Vector.Angle(closest.eyes - eyepos)
	R.Angle.Normalize( ang )

	-- if math.abs(math.NormalizeAngle(ang.y) - math.NormalizeAngle( lastFakeYawOffset )) >= 20 then

	-- 	sendPacket( true )
	-- end

	if ang then
		return {ang = ang, info = closest}
	else 
		return nil
	end
end

local lastbug = false
local needToBreakLBY
local lbyang
local lastRealFlick = 0
local needToFlickClient = false
function Desync( cmd, view, sendingPacket )
	local isMoving = R.Vector.Length( R.Entity.GetAbsVelocity( LocalPlayer() )) >= 0.001
	local breakleft = Menu.Func.GetVar( "Misc", "Fake Angles", "Desync Direction" ) == "Left"

	if Menu.Func.GetVar( "Misc", "Fake Angles", "Desync Direction" ) == "Jitter" then
		breakleft = anti_aim.JitterDir == 1
	end

	local flickAmount =  Menu.Func.GetVar( "Misc", "Fake Angles", "Flick Yaw" )

	local yawoffset = 0
	if Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "Static" then
		yawoffset = yawoffset + Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw Additive")
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "180" then
		breakleft = not breakleft
		yawoffset = yawoffset + 180 + Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw Additive")
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "Spin" then
		yawoffset = ( CurTime() * Menu.Func.GetVar("Misc", "Anti-Aim", "Spin Speed") ) % 360
	end

	local pitchoffset = view.x

	if Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Up" then
		pitchoffset = -89
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Down" then
		pitchoffset = 89
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Zero" then
		pitchoffset = 0
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Fake Down" then
		pitchoffset = 540
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Fake Jitter" then
		if lastbug then
			pitchoffset = math.random(-182, -192)
		else
			pitchoffset = 540
		end

		lastbug = not lastbug
	end
	
	local ang = (lbyang and Menu.Func.GetVar( "Misc", "Fake Angles", "Break LBY" )) and Angle( lbyang[1], lbyang[2] + yawoffset, 0 ) or Angle( pitchoffset, view[2] + yawoffset, 0 )
	local choked = CFunc.GetChokedPackets() < (Menu.Func.GetVar("Misc", "Fake Lag", "Enabled") and Menu.Func.GetVar("Misc", "Fake Lag", "Max Choke") or 3)
	local sendthispacket = !choked -- or pleaseSendPacket

	if !ServerAnimState or !ServerAnimState.m_angRender then return end

	local desyncDiff = (ServerAnimState.m_angRender - ClientAnimState.m_angRender)

	R.Angle.Normalize( desyncDiff )

	desyncDiff = math.abs( desyncDiff.y )

	if desyncDiff < 15 and desyncDiff > 5 then
		needToBreakLBY = true
	elseif desyncDiff > 5 and desyncDiff < 90 and Menu.Func.GetVar( "Misc", "Fake Angles", "Break LBY" ) then
		needToFlickClient = true
	end

	if (isMoving and sendthispacket ) then
		lastLBYupdate = 0.0
		needToBreakLBY = true
	end

	if (isMoving) then
		local fallback = Angle( pitchoffset, view.y + yawoffset, 0 )
		sendPacket( forceSendPacket or sendthispacket )
		R.Angle.Normalize( fallback )
		R.CUserCmd.SetViewAngles( cmd, fallback )
		lastRealFlick = 0
		needToFlickClient = false
		return
	end

	if needToFlickClient and lbyang and ServerTime - lastRealFlick >= 1.5 then
		sendPacket( true )
		ang.y = ServerAnimState.m_angRender.y + (breakleft and 181 or 179)
		needToFlickClient = false
		lastRealFlick = ServerTime
	elseif (sendthispacket and lbyang) then
		sendPacket( true )
	else
		if !lbyang or needToBreakLBY then
			if third then
				lbyang = Angle( view[1], view[2], 0 )
			else
				lbyang = R.CUserCmd.GetViewAngles( cmd )
			end

			lbyang.pitch = pitchoffset

			skipAimbot = true
			sendPacket( false )
			ang.y = lbyang.y + (breakleft and flickAmount or -flickAmount)
			needToBreakLBY = false
			fakeflick = true
		else
			sendPacket( false )
		end
	end

	if sendingPacket then
		if anti_aim.JitterDir == 0 then
			anti_aim.JitterDir = 1
		else
			anti_aim.JitterDir = 0
		end
	end


	R.Angle.Normalize( ang )

	R.CUserCmd.SetViewAngles( cmd, ang )
end


function doAntiAim( cmd, view, sendingPacket )
	if !view then return end

	if Menu.Func.GetVar("Misc", "Anti-Aim", "Disablers") then
		local doaa = false
		if R.Player.Alive( LocalPlayer() ) and
		!R.Player.InVehicle( LocalPlayer() ) and
		R.Entity.GetMoveType( LocalPlayer() ) != 9 and -- ladder
		R.Entity.GetMoveType( LocalPlayer() ) != 8 and -- noclip
		R.Entity.WaterLevel( LocalPlayer() ) <= 1 then
			doaa = true
		end
		if not doaa then return end
	end

	local whereToPoint = Menu.Func.GetVar("Misc", "Anti-Aim", "Point Angles At")

	local aa_targ

	if whereToPoint != "Current View" then
		aa_targ = Adaptive(whereToPoint == "Closest Player By Distance" and 1 or 2)

		if aa_targ then
			view = aa_targ.ang
		else
			view = view
		end
	else
		view = view
	end

	if Menu.Func.GetVar("Misc", "Fake Angles", "Enabled") and Menu.Func.GetVar("Misc", "Fake Angles", "Fake Mode") == "Desync" and !anti_aim.SequenceFreezing then
		Desync(cmd, view, sendingPacket)
		anti_aim.FakeAnglesEnabled = true
		return
	end

	local pitch = view.x
	local yaw = view.y

	if Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Up" then
		pitch = -89
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Down" then
		pitch = 89
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Zero" then
		pitch = 0
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Fake Down" then
		pitch = 540
	elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Pitch") == "Fake Jitter" then
		if lastbug then
			pitch = math.random(-182, -192)
		else
			pitch = 540
		end		

		lastbug = not lastbug
	end

	if sendingPacket then
		if anti_aim.JitterDir == 0 then
			anti_aim.JitterDir = 1
		else
			anti_aim.JitterDir = 0
		end
	end

	if sendingPacket or not Menu.Func.GetVar("Misc", "Fake Angles", "Enabled") then -- fake angles
		lastFakeYawOffset = view.y

        
		--local mode = Menu.Func.GetVar("Misc", "Fake Angles", "Fake Angle Mode")



        if Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "Static" then
            yaw = yaw + Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw Additive")
        elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "180" then
            yaw = yaw + 180 + Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw Additive")
        elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "Spin" then
			yaw = ( CurTime() * Menu.Func.GetVar("Misc", "Anti-Aim", "Spin Speed") ) % 360
        end


		-- if Menu.Func.GetVar("Misc", "Anti-Aim", "Fake Duck") and R.Entity.IsOnGround( LocalPlayer() ) then
		-- 	R.CUserCmd.SetButtons( cmd, bit.bor( IN_DUCK, R.CUserCmd.GetButtons( cmd )))
		-- end

		FakePitch = pitch
		FakeYaw = yaw
		FakePos = R.Entity.GetPos( LocalPlayer() )
	elseif Menu.Func.GetVar("Misc", "Fake Angles", "Fake Mode") == "Fake Angles" then -- real angles
		
		if Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "Static" then
            yaw = yaw + Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw Additive")
        elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "180" then
            yaw = yaw + 180 + Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw Additive")
        elseif Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "Spin" then
			yaw = ( CurTime() * Menu.Func.GetVar("Misc", "Anti-Aim", "Spin Speed") ) % 360
        end


		local fakeDir = Menu.Func.GetVar("Misc", "Fake Angles", "Fake Direction")
		if Menu.Func.GetVar("Misc", "Fake Angles", "Fake Direction") == "Jitter" then
			fakeDir = anti_aim.JitterDir == 1 and "Left" or "Right"
		end

		if fakeDir == "Left" then
			local yawadd = Menu.Func.GetVar("Misc", "Fake Angles", "Fake Yaw")
			if Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") == "180" then
				yawadd = yawadd * -1
			end
			yaw = yaw + yawadd
		elseif fakeDir == "Right" then
			local yawadd = Menu.Func.GetVar("Misc", "Fake Angles", "Fake Yaw")
			if Menu.Func.GetVar("Misc", "Anti-Aim", "Yaw") != "180" then
				yawadd = yawadd * -1
			end
			yaw = yaw + yawadd


		elseif fakeDir == "test" then			
			local yawadd = Menu.Func.GetVar("Misc", "Fake Angles", "Fake Yaw")

			-- private pud anti aimings

		elseif fakeDir == "Freestanding" then
			local target = Adaptive(2)
			if target ~= nil and target.info ~= nil then

			end
		end


		-- elseif Menu.Func.GetVar("Misc", "Crouch Faking") == "Fake Slow" and R.Entity.IsOnGround( LocalPlayer() ) then
		-- 	-- R.CUserCmd.SetSideMove( 0 )
		-- end
		RealPitch = pitch
		RealYaw = yaw
	end
	-- else
	-- 	yaw = ( CurTime() * 500 ) % 360
	-- end

	

	anti_aim.FakeAnglesEnabled = Menu.Func.GetVar("Misc", "Fake Angles", "Enabled")
	R.CUserCmd.SetViewAngles( cmd, Angle( pitch, math.NormalizeAngle( yaw ), 0 ))
	

end