json = require "json"

local fart = registerCustomSound("jelly/sounds/fart.wav")

Weapon_Kamikaze=18
TaskMessage_RenderScene=3 

local blacklist = {}
blacklist[Weapon_Kamikaze] = true

function ammo(teamid, weaponid, amount)
	if (not blacklist[weaponid]) and (getTeamAmmo(teamid,weaponid,0) > 0) then
		io.write(teamid ..",".. weaponid ..",".. amount .."\n")	
		pendsound = fart
		return 1
	end
end

local activepass = 16
local currteam = nil
function worm(This, sender, messagetype, psize, params)	
	if (This.active == 1) then
		currteam = This.unknownFC
	end
	if (This.active == 1) or (activepass <= 0) then
		if pendsound then
			playSoundLocal(0x10000 /2, 0x10000 /2, This, pendsound, 8)
			pendsound = nil
		end
		activepass = 16
	elseif pendsound then
		activepass = activepass -1
	end
end

local flipflop = {}

function crate(This, sender, messagetype, psize, params)
	if (messagetype == TaskMessage_RenderScene) then
		if currteam then
			local currammo = getTeamAmmo(currteam,This.unknown12C,0) 
			if currammo > 0 or currammo == -1 then
				drawSpriteLocal(This.posY,-99999,This.posX,41,1) --7
			end
		end
	end
end

local cratesprites = {}
cratesprites[636] = true
cratesprites[637] = true
cratesprites[638] = true
cratesprites[96] = true
cratesprites[97] = true
cratesprites[98] = true
cratesprites[99] = true
cratesprites[100] = true
cratesprites[101] = true

function render( layer, posx,posy, sprite,  frame)
	if cratesprites[sprite] then		
		drawSpriteLocal(posy,layer,posx,sprite | 0x200000,frame)
		return 1
	end
end


function initialize()
	fart = registerCustomSound("jelly/sounds/fart.wav")
	CTaskWorm_RegisterCallback_vtable8(worm)
	CTaskCrate_RegisterCallback_vtable8(crate)
	--registerCallback_drawSpriteLocal(render)
	registerCallback_addAmmo(ammo)
	return 0
end