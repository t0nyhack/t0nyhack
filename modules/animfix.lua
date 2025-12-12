
CMultiplayerAnimState = {}
CMultiplayerAnimState.__index = CMultiplayerAnimState

local LEGANIM_9WAY = 0
local MOVING_MINIMUM_SPEED = 0.5

function CMultiplayerAnimState.new( player )
	local AnimState = setmetatable({
		m_bPoseParameterInit = false,
		m_PoseParameterData = {
			m_flEstimateYaw = 0.0,
			m_flLastAimTurnTime = 0.0
		},
		m_flMaxSpeed = 0,
		m_bOverrideMaxSpeed = false,
		m_pPlayer = player,
		m_angRender = Angle(0, 0, 0),
		m_bCurrentFeetYawInitialized = false,
		m_flLastAnimationStateClearTime = 0.0,
		m_flEyeYaw = 0.0,
		m_flEyePitch = 0.0,
		m_flGoalFeetYaw = 0.0,
		m_flCurrentFeetYaw = 0.0,
		m_flLastAimTurnTime = 0.0,
		m_bDying = false,
		m_bForceAimYaw = false,
		m_LegAnimType = LEGANIM_9WAY,
		m_pPoseParams = {
			head_yaw = 0,
			head_pitch = 0
		}
	}, CMultiplayerAnimState)

	return AnimState
end

local function tofloat( num )
	return tonumber( string.format( "%f", num ))
end

function CMultiplayerAnimState:ShouldUpdateAnimState()
	-- Don't update anim state if we're not visible
	if !self.m_pPlayer then self.m_pPlayer = LocalPlayer() end

	if (R.Entity.IsEffectActive( self.m_pPlayer, EF_NODRAW )) then
		return false
	end

	return R.Player.Alive(self.m_pPlayer) or self.m_bDying
end

function CMultiplayerAnimState:ClearAnimationState()
	-- Reset state.
	self.m_bDying = false
	self.m_bCurrentFeetYawInitialized = false
	self.m_flLastAnimationStateClearTime = ServerTime
end

function CMultiplayerAnimState:SetMaxSpeed( speed )
	self.m_flMaxSpeed = speed
end

function CMultiplayerAnimState:SetupPoseParameters()
	-- Check to see if this has already been done.
	if (self.m_bPoseParameterInit) then
		return true
	end

	-- Save off the pose parameter indices.
	if (!self.m_pPlayer) then
		return false
	end

	self.m_bPoseParameterInit = true

	-- Look for the movement blenders.
	self.m_PoseParameterData.move_x = R.Entity.GetPoseParameterName( self.m_pPlayer, R.Entity.LookupPoseParameter( self.m_pPlayer, "move_x"))
	self.m_PoseParameterData.move_y = R.Entity.GetPoseParameterName( self.m_pPlayer, R.Entity.LookupPoseParameter( self.m_pPlayer, "move_y"))

	-- Look for the aim pitch blender.
	self.m_PoseParameterData.aim_pitch = R.Entity.GetPoseParameterName( self.m_pPlayer, R.Entity.LookupPoseParameter( self.m_pPlayer, "aim_pitch"))

	-- Look for aim yaw blender.
	self.m_PoseParameterData.aim_yaw = R.Entity.GetPoseParameterName( self.m_pPlayer, R.Entity.LookupPoseParameter( self.m_pPlayer, "aim_yaw"))

	self.m_PoseParameterData.move_yaw = R.Entity.GetPoseParameterName( self.m_pPlayer, R.Entity.LookupPoseParameter( self.m_pPlayer, "move_yaw"))
	self.m_PoseParameterData.move_scale = R.Entity.GetPoseParameterName( self.m_pPlayer, R.Entity.LookupPoseParameter( self.m_pPlayer, "move_scale"))

	return true
end

local M_PI = math.pi;
function CMultiplayerAnimState:EstimateYaw()
	-- Get the frame time.
	local flDeltaTime = engine.TickInterval();
	if (flDeltaTime == 0.0) then
		return;
	end

	-- Get the player's velocity and angles.
	local vecEstVelocity = R.Entity.GetVelocity(self.m_pPlayer);
	local angles = R.Entity.GetLocalAngles( self.m_pPlayer )

	-- If we are not moving, sync up the feet and eyes slowly.
	if (tofloat(vecEstVelocity.x) == 0.0 and tofloat(vecEstVelocity.y) == 0.0) then
		local flYawDelta = angles.y - self.m_PoseParameterData.m_flEstimateYaw;
		flYawDelta = math.NormalizeAngle(flYawDelta);

		if (flDeltaTime < 0.25) then
			flYawDelta = flYawDelta * (flDeltaTime * 4.0);
		else
			flYawDelta = flYawDelta * flDeltaTime;
		end

		self.m_PoseParameterData.m_flEstimateYaw = math.NormalizeAngle(self.m_PoseParameterData.m_flEstimateYaw + flYawDelta);
	else
		self.m_PoseParameterData.m_flEstimateYaw = (math.atan2(vecEstVelocity.y, vecEstVelocity.x) * 180.0 / M_PI);
		self.m_PoseParameterData.m_flEstimateYaw = math.Clamp(self.m_PoseParameterData.m_flEstimateYaw, -180.0, 180.0);
	end
end

function CMultiplayerAnimState:StorePoseParameter( name, value )
	self.m_pPoseParams[name] = value
end

function CMultiplayerAnimState:CalcMovementSpeed()
	-- Get the player's current velocity and speed.
	local vecVelocity = R.Entity.GetVelocity( self.m_pPlayer )
	local flSpeed = tofloat(R.Vector.Length2D( vecVelocity ))

	if (flSpeed > MOVING_MINIMUM_SPEED) then
		return flSpeed, true;
	end

	return 0.0, false;
end

-- function CMultiplayerAnimState:GetCurrentMaxGroundSpeed( animState )
-- 	local prevX = self.m_pPoseParams[move_x]
-- 	local prevY = self.m_pPoseParams[move_y]

-- 	if !prevX or !prevY then return 1 end

-- 	local distance = math.sqrt( prevX * prevX + prevY * prevY )

-- 	local newX, newY
-- 	if distance == 0 then
-- 		newX = 0
-- 		newY = 0
-- 	else
-- 		newX = prevX / distance
-- 		newY = prevY / distance
-- 	end


-- end

--local mp_slammoveyaw = GetConVar("mp_slammoveyaw");
function CMultiplayerAnimState:ComputePoseParam_MoveYaw()
	-- Get the estimated movement yaw.
	self:EstimateYaw(animState);

	-- Get the view yaw.
	local flAngle = math.NormalizeAngle(self.m_flEyeYaw);

	-- Calc side to side turning - the view vs. movement yaw.
	local flYaw = flAngle - self.m_PoseParameterData.m_flEstimateYaw;
	flYaw = math.NormalizeAngle(-flYaw);

	-- Get the current speed the character is running.
	local flSpeed, bMoving = self:CalcMovementSpeed(animState);

	-- Setup the 9-way blend parameters based on our speed and direction.
	local vecCurrentMoveYaw = Vector(0.0, 0.0, 0.0);
	if (bMoving) then
		--GetMovementFlags(self.m_pPlayer);

		--if (mp_slammoveyaw:GetBool()) then
		--	flYaw = SnapYawTo(flYaw);
		--end

		if (self.m_LegAnimType == LEGANIM_9WAY) then
			-- convert YAW back into vector
			vecCurrentMoveYaw.x = math.cos(math.rad(flYaw));
			vecCurrentMoveYaw.y = -math.sin(math.rad(flYaw));
			-- push edges out to -1 to 1 box
			local flInvScale = math.max(math.abs(vecCurrentMoveYaw.x), math.abs(vecCurrentMoveYaw.y));
			if (flInvScale != 0.0) then
				vecCurrentMoveYaw.x = vecCurrentMoveYaw.x / flInvScale;
				vecCurrentMoveYaw.y = vecCurrentMoveYaw.y / flInvScale;
			end

			-- find what speed was actually authored
			self:StorePoseParameter( self.m_PoseParameterData.move_x, vecCurrentMoveYaw.x );
			self:StorePoseParameter( self.m_PoseParameterData.move_y, vecCurrentMoveYaw.y );

			local flMaxSpeed = self.m_bOverrideMaxSpeed and self.m_flMaxSpeed or R.Entity.GetSequenceGroundSpeed( self.m_pPlayer, R.Entity.GetSequence( self.m_pPlayer ));
			self.m_flMaxSpeed = R.Entity.GetSequenceGroundSpeed( self.m_pPlayer, R.Entity.GetSequence( self.m_pPlayer ));

			-- scale playback
			if (flMaxSpeed > flSpeed) then
				vecCurrentMoveYaw.x = vecCurrentMoveYaw.x * (flSpeed / flMaxSpeed);
				vecCurrentMoveYaw.y = vecCurrentMoveYaw.y * (flSpeed / flMaxSpeed);
			end

			-- Set the 9-way blend movement pose parameters.
			self:StorePoseParameter( self.m_PoseParameterData.move_x, vecCurrentMoveYaw.x);
			self:StorePoseParameter( self.m_PoseParameterData.move_y, vecCurrentMoveYaw.y);
		else
			-- find what speed was actually authored
			self:StorePoseParameter( self.m_PoseParameterData.move_yaw, flYaw);
			self:StorePoseParameter( self.m_PoseParameterData.move_scale, 1.0);

			local flMaxSpeed = self.m_bOverrideMaxSpeed and self.m_flMaxSpeed or R.Entity.GetSequenceGroundSpeed( self.m_pPlayer, R.Entity.GetSequence( self.m_pPlayer ));
			self.m_flMaxSpeed = R.Entity.GetSequenceGroundSpeed( self.m_pPlayer, R.Entity.GetSequence( self.m_pPlayer ));

			-- scale playback
			if (flMaxSpeed > flSpeed) then
				self:StorePoseParameter( self.m_PoseParameterData.move_scale, flSpeed / flMaxSpeed );
			end
		end
	else
		-- Set the 9-way blend movement pose parameters.
		self:StorePoseParameter( self.m_PoseParameterData.move_x, 0.0 );
		self:StorePoseParameter( self.m_PoseParameterData.move_y, 0.0 );
	end
end

function CMultiplayerAnimState:ComputePoseParam_AimPitch()
	-- Get the view pitch.
	local flAimPitch = self.m_flEyePitch;

	-- Set the aim pitch pose parameter and save.
	self:StorePoseParameter( self.m_PoseParameterData.aim_pitch, flAimPitch );
end

function CMultiplayerAnimState:ConvergeYawAngles(flGoalYaw, flYawRate, flDeltaTime, flCurrentYaw)
	local FADE_TURN_DEGREES = 60.0;

	-- Find the yaw delta.
	local flDeltaYaw = flGoalYaw - flCurrentYaw; -- tonumber( string.format( "%f", flDeltaYaw ))
	local flDeltaYawAbs = math.abs(flDeltaYaw);
	flDeltaYaw = math.NormalizeAngle(flDeltaYaw);

	-- Always do at least a bit of the turn (1%).
	local flScale = 1.0;
	flScale = flDeltaYawAbs / FADE_TURN_DEGREES;
	flScale = math.Clamp(flScale, 0.01, 1.0);

	local flYaw = flYawRate * flDeltaTime * flScale;
	if (flDeltaYawAbs < flYaw) then
		flCurrentYaw = flGoalYaw;
	else
		local flSide = (flDeltaYaw < 0.0) and -1.0 or 1.0;
		flCurrentYaw = flCurrentYaw + (flYaw * flSide);
	end

	return math.NormalizeAngle(flCurrentYaw);
end

function CMultiplayerAnimState:ComputePoseParam_AimYaw()
	-- Get the movement velocity.
	local vecVelocity = R.Entity.GetVelocity( self.m_pPlayer )
	-- Check to see if we are moving.
	local bMoving = (tofloat(R.Vector.Length(vecVelocity)) > 1.0);

	-- If we are moving or are prone and undeployed.
	if (bMoving or self.m_bForceAimYaw) then
		-- The feet match the eye direction when moving - the move yaw takes care of the rest.
		self.m_flGoalFeetYaw = self.m_flEyeYaw;
	-- Else if we are not moving.
	else
		-- Initialize the feet.
		if (self.m_PoseParameterData.m_flLastAimTurnTime <= 0.0) then
			self.m_flGoalFeetYaw = self.m_flEyeYaw;
			self.m_flCurrentFeetYaw = self.m_flEyeYaw;
			self.m_PoseParameterData.m_flLastAimTurnTime = ServerTime;
			-- Make sure the feet yaw isn't too far out of sync with the eye yaw.
			-- TODO: Do something better here!
		else
			local flYawDelta = math.NormalizeAngle(self.m_flGoalFeetYaw - self.m_flEyeYaw);
			if (math.abs(flYawDelta) > 45.0) then
				local flSide = ( flYawDelta > 0.0 ) and -1.0 or 1.0;
				self.m_flGoalFeetYaw = self.m_flGoalFeetYaw + (45.0 * flSide);
			end
		end
	end

	-- Fix up the feet yaw.
	self.m_flGoalFeetYaw = math.NormalizeAngle(self.m_flGoalFeetYaw);
	if (self.m_flGoalFeetYaw != self.m_flCurrentFeetYaw) then
		if (self.m_bForceAimYaw) then
			self.m_flCurrentFeetYaw = self.m_flGoalFeetYaw;
		else
			self.m_flCurrentFeetYaw = self:ConvergeYawAngles(self.m_flGoalFeetYaw, 720.0, engine.TickInterval(), self.m_flCurrentFeetYaw);
			self.m_PoseParameterData.m_flLastAimTurnTime = ServerTime;
		end
	end

	-- Rotate the body into position.
	self.m_angRender.y = self.m_flCurrentFeetYaw;

	-- Find the aim(torso) yaw base on the eye and feet yaws.
	local flAimYaw = math.NormalizeAngle(self.m_flEyeYaw - self.m_flCurrentFeetYaw);

	-- Set the aim yaw and save.
	self:StorePoseParameter( self.m_PoseParameterData.aim_yaw, flAimYaw);
	-- Turn off a force aim yaw - either we have already updated or we don't need to.
	self.m_bForceAimYaw = false;

	--QAngle angle = self.m_pPlayer:GetAbsAngles();
	--angle.y = self.m_flCurrentFeetYaw;
	--self.m_pPlayer:SetAbsAngles(angle);
end

function CMultiplayerAnimState:Update(eyeYaw, eyePitch)
	-- Check to see if we should be updating the animation state - dead, ragdolled?
	if (!self:ShouldUpdateAnimState(animState)) then
		self:ClearAnimationState(animState);
		return;
	end

	-- Store the eye angles.
	self.m_flEyeYaw = math.NormalizeAngle(eyeYaw);
	self.m_flEyePitch = math.NormalizeAngle(eyePitch);

	-- Compute the player sequences.
	--self:ComputeSequences(animState, self.m_pPlayer);

	if (self:SetupPoseParameters()) then
		-- Pose parameter - what direction are the player's legs running in.
		self:ComputePoseParam_MoveYaw();

		-- Pose parameter - Torso aiming (up/down).
		self:ComputePoseParam_AimPitch();

		-- Pose parameter - Torso aiming (rotation).
		self:ComputePoseParam_AimYaw();
	end

	if (R.Player.ShouldDrawLocalPlayer( self.m_pPlayer )) then
		R.Entity.SetPlaybackRate( self.m_pPlayer, 1.0 );
	end
end

Lib.Hook.Add( "PreDrawOpaqueRenderables", "FȎ😲^(ÕŲǞn♹ĜĚȜüŃŚčEȼ♞⚋QŃ¯łm", function()
	-- if ( ( Menu.Func.GetVar("HvH", "Anti-Aim", "Anti-Aim Enabled") or Menu.Func.GetVar("HvH", "Desync", "Enable Desync") or ( Menu.Func.GetVar("HvH", "Fake Lag", "Fake Lag") and Menu.Func.GetVar("HvH", "Fake Lag", "Fake Lag Choke") > 0  ) ) and !( input.IsKeyDown( KEY_X ) and Menu.Func.GetVar( "HvH", "Sequence Freezing", "Disable Fake Lag" ) ) ) then return end
	if ServerBoneMatrix and !R.Player.InVehicle( LocalPlayer() ) then

		R.Player.AnimResetGestureSlot( LocalPlayer(), 5 ) -- 5 = GESTURE_SLOT_VCD
		if engine.ActiveGamemode() == "darkrp" then
			R.Player.AnimResetGestureSlot( LocalPlayer(), 6 ) -- 6 = GESTURE_SLOT_CUSTOM
		end

		local LocalPos = R.Entity.GetPos( LocalPlayer() )
		local old_translation = util.GetMatrixTranslation( ServerBoneMatrix[1] )
		R.Entity.SetupBones( LocalPlayer() )
		util.OffSetMatrixPosition(ServerBoneMatrix[1], util.VectDiff(ServerBoneMatrix[2], LocalPos))
		util.SetBoneMatrix( LocalPlayer(), ServerBoneMatrix[1] )
		util.SetMatrixTranslation( ServerBoneMatrix[1], old_translation )
	end
end)