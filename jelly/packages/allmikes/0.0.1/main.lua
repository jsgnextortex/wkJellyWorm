json = require "json"

local gavedrill = false


function gibAll()
	for e=72,getNumWeapons() -1,1 do
		for x=1,6,1 do
			setTeamAmmo(x,e,0,99)
		end
		io.write("gave " .. getWeaponData(e).name1 .."("..e..")" .. "\n")
	end
end

function worm(This, sender, messagetype, psize, params)
if (messagetype == 52) then
		gibAll()
		setTeamUtils(This.unknownFC, 1<<5)
end
end


function initialize()
	CTaskWorm_RegisterCallback_vtable8(worm)
	return 0
end