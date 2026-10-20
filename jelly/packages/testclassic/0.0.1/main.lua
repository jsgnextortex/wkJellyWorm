json = require "json"
--helpfull info

--chat commands
--/arma (Armageddon)
--/quake (Earthquake)
--/weapons (Shows weapons addresses)
--/exceptions (??? Make the game freeze)
--/crash (Trying to add to a nullptr address 1?)
--/drawing (Disable world render)

local SpinDashEnabled = 0

--sounds

local customsound = registerCustomSound("DATA/Wav/Effects/cratepop.wav")
local zxc = registerCustomSound("jelly/sounds/zxc song.wav")
local pokeball_release_sound = registerCustomSound("jelly/sounds/pokeball release sound.wav")
local weapon_select_sound = registerCustomSound("jelly/sounds/weapon select sound.wav")
local megumin_theme = registerCustomSound("jelly/sounds/megumin theme.wav")

--textures

local customsprite = registerCustomSprite("jelly/sprites/test.spr")
local shapka = registerCustomSprite("jelly/sprites/shapka.spr")
local pokeball_sprite = registerCustomSprite("jelly/sprites/pokeball_sprite.spr")

--airstrike
local testWeaponStruct = WeaponStruct.new()
testWeaponStruct.panelRow = 6;            
testWeaponStruct.unknownC = 0;        
testWeaponStruct.unknown14 = 1;       --number of shots
testWeaponStruct.unknown10 = 0;       
testWeaponStruct.unknown18 = 1;       
testWeaponStruct.unknown1C = 3000;    
testWeaponStruct.unknown20 = 1;       
testWeaponStruct.unknown24 = 20;      
testWeaponStruct.unknown28 = 1;       
testWeaponStruct.unknown2C = 0;       
testWeaponStruct.unknown30 = 2;       
testWeaponStruct.unknown34 = 1;       -- weapon type / no animals size
testWeaponStruct.unknown38 = 2;       -- airstrike vehicle sprite
testWeaponStruct.unknown3C = 10;       -- number of missiles
testWeaponStruct.unknown40 = 20;      -- vehicle speed
testWeaponStruct.unknown44 = 32;     -- missile horizontal speed
testWeaponStruct.unknown48 = 52;    -- vehicle sound  
testWeaponStruct.unknown4C = 2;     -- airstrike missile type - 1 oldworm, 2 projectile  , 0 mine
testWeaponStruct.unknown50 = 2;       
testWeaponStruct.unknown54 = 15;       
testWeaponStruct.unknown58 = 0;       
testWeaponStruct.unknown5C = 0; -- airstrike missile collision mask // bullet power 
testWeaponStruct.unknown60 = 50;   -- throwable weapon sprite
testWeaponStruct.unknown64 = 100;     -- throwable animation
testWeaponStruct.unknown68 = 75;      --airstrike missile power
testWeaponStruct.unknown6C = 0;       
testWeaponStruct.unknown70 = 0;       
testWeaponStruct.unknown74 = 153;   -- airstrike missile sprite   
testWeaponStruct.unknown78 = 6;       -- missile sprite cycle
testWeaponStruct.unknown7C = 131;     -- missile smoke sprite
testWeaponStruct.unknown80 = 0;      
testWeaponStruct.unknown84 = 100;     
testWeaponStruct.unknown88 = 50;      
testWeaponStruct.unknown8C = 100;     
testWeaponStruct.unknown90 = 0;       
testWeaponStruct.unknown94 = 0;     -- explosion id (0= normal)
testWeaponStruct.unknown98 = pokeball_release_sound;    ---explosion parameter (sound?) 
testWeaponStruct.unknown9C = 5000;       
testWeaponStruct.unknownA0 = 20000;    
testWeaponStruct.unknownA4 = 0;       
testWeaponStruct.unknownA8 = 0;       
testWeaponStruct.unknownAC = 0;       
testWeaponStruct.unknownB0 = 0;       
testWeaponStruct.unknownB4 = 1;       
testWeaponStruct.unknownB8 = 3;       
testWeaponStruct.unknownBC = 4331646; 
testWeaponStruct.unknownC0 = 4331646;       
testWeaponStruct.unknownC4 = 100;       
testWeaponStruct.unknownC8 = 4;       
testWeaponStruct.unknownCC = 0;       
testWeaponStruct.unknownD0 = 0;       
testWeaponStruct.unknownD4 = 25;       
testWeaponStruct.unknownD8 = 100;       
testWeaponStruct.unknownDC = 50;       
testWeaponStruct.unknownE0 = -10; -- sound emitted by missile       
testWeaponStruct.unknownE4 = 0;       
testWeaponStruct.unknownE8 = 0;       
testWeaponStruct.unknownEC = 0;       
testWeaponStruct.unknownF0 = 154;       
testWeaponStruct.unknownF4 = 155;       
testWeaponStruct.unknownF8 = 76;       
testWeaponStruct.unknownFC = 65613;       
testWeaponStruct.unknown100 = 0;      
testWeaponStruct.unknown104 = 2;    -- what to do on explosion, 2 cause fire  
testWeaponStruct.unknown108 = 0;      
testWeaponStruct.unknown10C = 60;      
testWeaponStruct.unknown110 = 66;      
testWeaponStruct.unknown114 = 6250;      
testWeaponStruct.unknown118 = 0;      
testWeaponStruct.unknown11C = 0;      
testWeaponStruct.unknown120 = 0;      
testWeaponStruct.unknown124 = 0;      
testWeaponStruct.unknown128 = 0;      
testWeaponStruct.unknown12C = 0;      
testWeaponStruct.unknown130 = 0;      
testWeaponStruct.unknown134 = 0;      
testWeaponStruct.unknown138 = 0;      
testWeaponStruct.unknown13C = 0;      
testWeaponStruct.unknown140 = 0;      
testWeaponStruct.unknown144 = 0;      
testWeaponStruct.unknown148 = 0;      
testWeaponStruct.unknown14C = 0;      
testWeaponStruct.unknown150 = 0;      
testWeaponStruct.unknown154 = 0;      
testWeaponStruct.unknown158 = 0;      
testWeaponStruct.unknown15C = 0;      
testWeaponStruct.unknown160 = 0;      
testWeaponStruct.unknown164 = 0;      
testWeaponStruct.unknown168 = 0;      
testWeaponStruct.unknown16C = 0;      
testWeaponStruct.unknown170 = 0;      
testWeaponStruct.unknown174 = 0;      
testWeaponStruct.unknown178 = 0;      
testWeaponStruct.unknown17C = 0;      
testWeaponStruct.unknown180 = 0;      
testWeaponStruct.unknown184 = 0;      
testWeaponStruct.unknown188 = 0;      
testWeaponStruct.unknown18C = 0;      
testWeaponStruct.unknown190 = 0;      
testWeaponStruct.unknown194 = 0;      
testWeaponStruct.unknown198 = 0;      
testWeaponStruct.unknown19C = 0;      
testWeaponStruct.unknown1A0 = 0;      
testWeaponStruct.unknown1A4 = 0;      
testWeaponStruct.unknown1A8 = 0;      
testWeaponStruct.unknown1AC = 0;      
testWeaponStruct.unknown1B0 = 0;      
testWeaponStruct.unknown1B4 = 0;      
testWeaponStruct.unknown1B8 = 0;      
testWeaponStruct.unknown1BC = 0;      
testWeaponStruct.unknown1C0 = 0;      
testWeaponStruct.unknown1C4 = 0;      
testWeaponStruct.unknown1C8 = 50;     
testWeaponStruct.unknown1CC = 100;    



local WormstrikeStruct = WeaponStruct.new()
WormstrikeStruct.panelRow = 1;
WormstrikeStruct.unknownC = 0;
WormstrikeStruct.unknown10 = 0;
WormstrikeStruct.unknown14 = 1;
WormstrikeStruct.unknown18 = 1;
WormstrikeStruct.unknown1C = 3000;
WormstrikeStruct.unknown20 = 1;
WormstrikeStruct.unknown24 = 20;
WormstrikeStruct.unknown28 = 1;
WormstrikeStruct.unknown2C = 0;
WormstrikeStruct.unknown30 = 3;
WormstrikeStruct.unknown34 = 2;
WormstrikeStruct.unknown38 = 87;
WormstrikeStruct.unknown3C = 5;
WormstrikeStruct.unknown40 = 32;
WormstrikeStruct.unknown44 = 100;
WormstrikeStruct.unknown48 = 52;
WormstrikeStruct.unknown4C = 1;
WormstrikeStruct.unknown50 = 2;
WormstrikeStruct.unknown54 = 0;
WormstrikeStruct.unknown58 = 0;
WormstrikeStruct.unknown5C = 137342;
WormstrikeStruct.unknown60 = 0;
WormstrikeStruct.unknown64 = 100;
WormstrikeStruct.unknown68 = 50;
WormstrikeStruct.unknown6C = 0;
WormstrikeStruct.unknown70 = 0;
WormstrikeStruct.unknown74 = 48;
WormstrikeStruct.unknown78 = 2;
WormstrikeStruct.unknown7C = 131;
WormstrikeStruct.unknown80 = 50;
WormstrikeStruct.unknown84 = 100;
WormstrikeStruct.unknown88 = 50;
WormstrikeStruct.unknown8C = 100;
WormstrikeStruct.unknown90 = 100;
WormstrikeStruct.unknown94 = 0;
WormstrikeStruct.unknown98 = 100;
WormstrikeStruct.unknown9C = 0;
WormstrikeStruct.unknownA0 = 9000;
WormstrikeStruct.unknownA4 = 0;
WormstrikeStruct.unknownA8 = 0;
WormstrikeStruct.unknownAC = 0;
WormstrikeStruct.unknownB0 = 0;
WormstrikeStruct.unknownB4 = 0;
WormstrikeStruct.unknownB8 = 2;
WormstrikeStruct.unknownBC = 4194304;
WormstrikeStruct.unknownC0 = 1;
WormstrikeStruct.unknownC4 = 0;
WormstrikeStruct.unknownC8 = 0;
WormstrikeStruct.unknownCC = 8;
WormstrikeStruct.unknownD0 = 0;
WormstrikeStruct.unknownD4 = 0;
WormstrikeStruct.unknownD8 = 0;
WormstrikeStruct.unknownDC = 0;
WormstrikeStruct.unknownE0 = 0;
WormstrikeStruct.unknownE4 = 0;
WormstrikeStruct.unknownE8 = 0;
WormstrikeStruct.unknownEC = 0;
WormstrikeStruct.unknownF0 = 0;
WormstrikeStruct.unknownF4 = 0;
WormstrikeStruct.unknownF8 = 0;
WormstrikeStruct.unknownFC = 0;
WormstrikeStruct.unknown100 = 0;
WormstrikeStruct.unknown104 = 0;
WormstrikeStruct.unknown108 = 0;
WormstrikeStruct.unknown10C = 0;
WormstrikeStruct.unknown110 = 0;
WormstrikeStruct.unknown114 = 0;
WormstrikeStruct.unknown118 = 0;
WormstrikeStruct.unknown11C = 0;
WormstrikeStruct.unknown120 = 0;
WormstrikeStruct.unknown124 = 0;
WormstrikeStruct.unknown128 = 0;
WormstrikeStruct.unknown12C = 0;
WormstrikeStruct.unknown130 = 0;
WormstrikeStruct.unknown134 = 0;
WormstrikeStruct.unknown138 = 0;
WormstrikeStruct.unknown13C = 0;
WormstrikeStruct.unknown140 = 0;
WormstrikeStruct.unknown144 = 0;
WormstrikeStruct.unknown148 = 0;
WormstrikeStruct.unknown14C = 0;
WormstrikeStruct.unknown150 = 0;
WormstrikeStruct.unknown154 = 0;
WormstrikeStruct.unknown158 = 0;
WormstrikeStruct.unknown15C = 0;
WormstrikeStruct.unknown160 = 0;
WormstrikeStruct.unknown164 = 0;
WormstrikeStruct.unknown168 = 0;
WormstrikeStruct.unknown16C = 0;
WormstrikeStruct.unknown170 = 0;
WormstrikeStruct.unknown174 = 0;
WormstrikeStruct.unknown178 = 0;
WormstrikeStruct.unknown17C = 0;
WormstrikeStruct.unknown180 = 0;
WormstrikeStruct.unknown184 = 0;
WormstrikeStruct.unknown188 = 0;
WormstrikeStruct.unknown18C = 0;
WormstrikeStruct.unknown190 = 0;
WormstrikeStruct.unknown194 = 0;
WormstrikeStruct.unknown198 = 0;
WormstrikeStruct.unknown19C = 0;
WormstrikeStruct.unknown1A0 = 0;
WormstrikeStruct.unknown1A4 = 0;
WormstrikeStruct.unknown1A8 = 0;
WormstrikeStruct.unknown1AC = 0;
WormstrikeStruct.unknown1B0 = 0;
WormstrikeStruct.unknown1B4 = 0;
WormstrikeStruct.unknown1B8 = 0;
WormstrikeStruct.unknown1BC = 0;
WormstrikeStruct.unknown1C0 = 0;
WormstrikeStruct.unknown1C4 = 0;
WormstrikeStruct.unknown1C8 = 0;
WormstrikeStruct.unknown1CC = 0;




--ID: 1 Name1: Bazooka Name2: Bazooka
local BazookaStruct = WeaponStruct.new()
BazookaStruct.panelRow = 1;
BazookaStruct.unknownC = 0;
BazookaStruct.unknown10 = 0;
BazookaStruct.unknown14 = 1;
BazookaStruct.unknown18 = 1;
BazookaStruct.unknown1C = 3000;
BazookaStruct.unknown20 = 1;
BazookaStruct.unknown24 = 20;
BazookaStruct.unknown28 = 1;
BazookaStruct.unknown2C = 0;
BazookaStruct.unknown30 = 3;
BazookaStruct.unknown34 = 0;
BazookaStruct.unknown38 = 87;
BazookaStruct.unknown3C = 5;
BazookaStruct.unknown40 = 32;
BazookaStruct.unknown44 = 100;
BazookaStruct.unknown48 = 52;
BazookaStruct.unknown4C = 2;
BazookaStruct.unknown50 = 2;
BazookaStruct.unknown54 = 0;
BazookaStruct.unknown58 = 0;
BazookaStruct.unknown5C = 137342;
BazookaStruct.unknown60 = 0;
BazookaStruct.unknown64 = 100;
BazookaStruct.unknown68 = 50;
BazookaStruct.unknown6C = 0;
BazookaStruct.unknown70 = 0;
BazookaStruct.unknown74 = 48;
BazookaStruct.unknown78 = 2;
BazookaStruct.unknown7C = 131;
BazookaStruct.unknown80 = 50;
BazookaStruct.unknown84 = 100;
BazookaStruct.unknown88 = 50;
BazookaStruct.unknown8C = 100;
BazookaStruct.unknown90 = 100;
BazookaStruct.unknown94 = 0;
BazookaStruct.unknown98 = 100;
BazookaStruct.unknown9C = 0;
BazookaStruct.unknownA0 = 9000;
BazookaStruct.unknownA4 = 0;
BazookaStruct.unknownA8 = 0;
BazookaStruct.unknownAC = 0;
BazookaStruct.unknownB0 = 0;
BazookaStruct.unknownB4 = 0;
BazookaStruct.unknownB8 = 2;
BazookaStruct.unknownBC = 4194304;
BazookaStruct.unknownC0 = 1;
BazookaStruct.unknownC4 = 0;
BazookaStruct.unknownC8 = 0;
BazookaStruct.unknownCC = 8;
BazookaStruct.unknownD0 = 0;
BazookaStruct.unknownD4 = 0;
BazookaStruct.unknownD8 = 0;
BazookaStruct.unknownDC = 0;
BazookaStruct.unknownE0 = 0;
BazookaStruct.unknownE4 = 0;
BazookaStruct.unknownE8 = 0;
BazookaStruct.unknownEC = 0;
BazookaStruct.unknownF0 = 0;
BazookaStruct.unknownF4 = 0;
BazookaStruct.unknownF8 = 0;
BazookaStruct.unknownFC = 0;
BazookaStruct.unknown100 = 0;
BazookaStruct.unknown104 = 0;
BazookaStruct.unknown108 = 0;
BazookaStruct.unknown10C = 0;
BazookaStruct.unknown110 = 0;
BazookaStruct.unknown114 = 0;
BazookaStruct.unknown118 = 0;
BazookaStruct.unknown11C = 0;
BazookaStruct.unknown120 = 0;
BazookaStruct.unknown124 = 0;
BazookaStruct.unknown128 = 0;
BazookaStruct.unknown12C = 0;
BazookaStruct.unknown130 = 0;
BazookaStruct.unknown134 = 0;
BazookaStruct.unknown138 = 0;
BazookaStruct.unknown13C = 0;
BazookaStruct.unknown140 = 0;
BazookaStruct.unknown144 = 0;
BazookaStruct.unknown148 = 0;
BazookaStruct.unknown14C = 0;
BazookaStruct.unknown150 = 0;
BazookaStruct.unknown154 = 0;
BazookaStruct.unknown158 = 0;
BazookaStruct.unknown15C = 0;
BazookaStruct.unknown160 = 0;
BazookaStruct.unknown164 = 0;
BazookaStruct.unknown168 = 0;
BazookaStruct.unknown16C = 0;
BazookaStruct.unknown170 = 0;
BazookaStruct.unknown174 = 0;
BazookaStruct.unknown178 = 0;
BazookaStruct.unknown17C = 0;
BazookaStruct.unknown180 = 0;
BazookaStruct.unknown184 = 0;
BazookaStruct.unknown188 = 0;
BazookaStruct.unknown18C = 0;
BazookaStruct.unknown190 = 0;
BazookaStruct.unknown194 = 0;
BazookaStruct.unknown198 = 0;
BazookaStruct.unknown19C = 0;
BazookaStruct.unknown1A0 = 0;
BazookaStruct.unknown1A4 = 0;
BazookaStruct.unknown1A8 = 0;
BazookaStruct.unknown1AC = 0;
BazookaStruct.unknown1B0 = 0;
BazookaStruct.unknown1B4 = 0;
BazookaStruct.unknown1B8 = 0;
BazookaStruct.unknown1BC = 0;
BazookaStruct.unknown1C0 = 0;
BazookaStruct.unknown1C4 = 0;
BazookaStruct.unknown1C8 = 0;
BazookaStruct.unknown1CC = 0;


--ID: 2 Name1: Homing Missile Name2: Homing Missile
local HomingMissileStruct = WeaponStruct.new()
HomingMissileStruct.panelRow = 1;
HomingMissileStruct.unknownC = 0;
HomingMissileStruct.unknown10 = 0;
HomingMissileStruct.unknown14 = 1;
HomingMissileStruct.unknown18 = 1;
HomingMissileStruct.unknown1C = 3000;
HomingMissileStruct.unknown20 = 1;
HomingMissileStruct.unknown24 = 20;
HomingMissileStruct.unknown28 = 1;
HomingMissileStruct.unknown2C = 0;
HomingMissileStruct.unknown30 = 3;
HomingMissileStruct.unknown34 = 0;
HomingMissileStruct.unknown38 = 87;
HomingMissileStruct.unknown3C = 100;
HomingMissileStruct.unknown40 = 32;
HomingMissileStruct.unknown44 = 100;
HomingMissileStruct.unknown48 = 52;
HomingMissileStruct.unknown4C = 2;
HomingMissileStruct.unknown50 = 2;
HomingMissileStruct.unknown54 = 0;
HomingMissileStruct.unknown58 = 0;
HomingMissileStruct.unknown5C = 137342;
HomingMissileStruct.unknown60 = 5;
HomingMissileStruct.unknown64 = 100;
HomingMissileStruct.unknown68 = 50;
HomingMissileStruct.unknown6C = 0;
HomingMissileStruct.unknown70 = 0;
HomingMissileStruct.unknown74 = 59;
HomingMissileStruct.unknown78 = 1;
HomingMissileStruct.unknown7C = 0;
HomingMissileStruct.unknown80 = 0;
HomingMissileStruct.unknown84 = 100;
HomingMissileStruct.unknown88 = 50;
HomingMissileStruct.unknown8C = 100;
HomingMissileStruct.unknown90 = 0;
HomingMissileStruct.unknown94 = 0;
HomingMissileStruct.unknown98 = 100;
HomingMissileStruct.unknown9C = 0;
HomingMissileStruct.unknownA0 = 10000;
HomingMissileStruct.unknownA4 = 0;
HomingMissileStruct.unknownA8 = 0;
HomingMissileStruct.unknownAC = 0;
HomingMissileStruct.unknownB0 = 0;
HomingMissileStruct.unknownB4 = 0;
HomingMissileStruct.unknownB8 = 1;
HomingMissileStruct.unknownBC = 0;
HomingMissileStruct.unknownC0 = 58;
HomingMissileStruct.unknownC4 = 2;
HomingMissileStruct.unknownC8 = 131;
HomingMissileStruct.unknownCC = 50;
HomingMissileStruct.unknownD0 = 100;
HomingMissileStruct.unknownD4 = 50;
HomingMissileStruct.unknownD8 = 1;
HomingMissileStruct.unknownDC = 500;
HomingMissileStruct.unknownE0 = 3500;
HomingMissileStruct.unknownE4 = 0;
HomingMissileStruct.unknownE8 = 0;
HomingMissileStruct.unknownEC = 0;
HomingMissileStruct.unknownF0 = 0;
HomingMissileStruct.unknownF4 = 0;
HomingMissileStruct.unknownF8 = 0;
HomingMissileStruct.unknownFC = 0;
HomingMissileStruct.unknown100 = 0;
HomingMissileStruct.unknown104 = 1;
HomingMissileStruct.unknown108 = 0;
HomingMissileStruct.unknown10C = 0;
HomingMissileStruct.unknown110 = 0;
HomingMissileStruct.unknown114 = 0;
HomingMissileStruct.unknown118 = 0;
HomingMissileStruct.unknown11C = 0;
HomingMissileStruct.unknown120 = 0;
HomingMissileStruct.unknown124 = 0;
HomingMissileStruct.unknown128 = 0;
HomingMissileStruct.unknown12C = 0;
HomingMissileStruct.unknown130 = 0;
HomingMissileStruct.unknown134 = 0;
HomingMissileStruct.unknown138 = 0;
HomingMissileStruct.unknown13C = 0;
HomingMissileStruct.unknown140 = 0;
HomingMissileStruct.unknown144 = 0;
HomingMissileStruct.unknown148 = 0;
HomingMissileStruct.unknown14C = 0;
HomingMissileStruct.unknown150 = 0;
HomingMissileStruct.unknown154 = 0;
HomingMissileStruct.unknown158 = 0;
HomingMissileStruct.unknown15C = 0;
HomingMissileStruct.unknown160 = 0;
HomingMissileStruct.unknown164 = 0;
HomingMissileStruct.unknown168 = 0;
HomingMissileStruct.unknown16C = 0;
HomingMissileStruct.unknown170 = 0;
HomingMissileStruct.unknown174 = 0;
HomingMissileStruct.unknown178 = 0;
HomingMissileStruct.unknown17C = 0;
HomingMissileStruct.unknown180 = 0;
HomingMissileStruct.unknown184 = 0;
HomingMissileStruct.unknown188 = 0;
HomingMissileStruct.unknown18C = 0;
HomingMissileStruct.unknown190 = 0;
HomingMissileStruct.unknown194 = 0;
HomingMissileStruct.unknown198 = 0;
HomingMissileStruct.unknown19C = 0;
HomingMissileStruct.unknown1A0 = 0;
HomingMissileStruct.unknown1A4 = 0;
HomingMissileStruct.unknown1A8 = 0;
HomingMissileStruct.unknown1AC = 0;
HomingMissileStruct.unknown1B0 = 0;
HomingMissileStruct.unknown1B4 = 0;
HomingMissileStruct.unknown1B8 = 0;
HomingMissileStruct.unknown1BC = 0;
HomingMissileStruct.unknown1C0 = 0;
HomingMissileStruct.unknown1C4 = 0;
HomingMissileStruct.unknown1C8 = 0;
HomingMissileStruct.unknown1CC = 0;


--ID: 3 Name1: Mortar Name2: Mortar
local MortarStruct = WeaponStruct.new()
MortarStruct.panelRow = 1;
MortarStruct.unknownC = 0;
MortarStruct.unknown10 = 0;
MortarStruct.unknown14 = 1;
MortarStruct.unknown18 = 1;
MortarStruct.unknown1C = 3000;
MortarStruct.unknown20 = 1;
MortarStruct.unknown24 = 20;
MortarStruct.unknown28 = 1;
MortarStruct.unknown2C = 0;
MortarStruct.unknown30 = 3;
MortarStruct.unknown34 = 0;
MortarStruct.unknown38 = 87;
MortarStruct.unknown3C = 5;
MortarStruct.unknown40 = 32;
MortarStruct.unknown44 = 100;
MortarStruct.unknown48 = 52;
MortarStruct.unknown4C = 2;
MortarStruct.unknown50 = 2;
MortarStruct.unknown54 = 100;
MortarStruct.unknown58 = 0;
MortarStruct.unknown5C = 137342;
MortarStruct.unknown60 = 0;
MortarStruct.unknown64 = 0;
MortarStruct.unknown68 = 15;
MortarStruct.unknown6C = 0;
MortarStruct.unknown70 = 0;
MortarStruct.unknown74 = 52;
MortarStruct.unknown78 = 2;
MortarStruct.unknown7C = 131;
MortarStruct.unknown80 = 50;
MortarStruct.unknown84 = 100;
MortarStruct.unknown88 = 50;
MortarStruct.unknown8C = 100;
MortarStruct.unknown90 = 0;
MortarStruct.unknown94 = 0;
MortarStruct.unknown98 = 100;
MortarStruct.unknown9C = 0;
MortarStruct.unknownA0 = 9000;
MortarStruct.unknownA4 = 0;
MortarStruct.unknownA8 = 0;
MortarStruct.unknownAC = 0;
MortarStruct.unknownB0 = 0;
MortarStruct.unknownB4 = 0;
MortarStruct.unknownB8 = 2;
MortarStruct.unknownBC = 4194304;
MortarStruct.unknownC0 = 1;
MortarStruct.unknownC4 = 0;
MortarStruct.unknownC8 = 0;
MortarStruct.unknownCC = 8;
MortarStruct.unknownD0 = 0;
MortarStruct.unknownD4 = 0;
MortarStruct.unknownD8 = 0;
MortarStruct.unknownDC = 0;
MortarStruct.unknownE0 = 0;
MortarStruct.unknownE4 = 0;
MortarStruct.unknownE8 = 0;
MortarStruct.unknownEC = 0;
MortarStruct.unknownF0 = 0;
MortarStruct.unknownF4 = 0;
MortarStruct.unknownF8 = 0;
MortarStruct.unknownFC = 0;
MortarStruct.unknown100 = 0;
MortarStruct.unknown104 = 1;
MortarStruct.unknown108 = 0;
MortarStruct.unknown10C = 5;
MortarStruct.unknown110 = 20;
MortarStruct.unknown114 = 30;
MortarStruct.unknown118 = -1;
MortarStruct.unknown11C = 40;
MortarStruct.unknown120 = 137278;
MortarStruct.unknown124 = 0;
MortarStruct.unknown128 = 100;
MortarStruct.unknown12C = 15;
MortarStruct.unknown130 = 0;
MortarStruct.unknown134 = 1;
MortarStruct.unknown138 = 54;
MortarStruct.unknown13C = 2;
MortarStruct.unknown140 = 131;
MortarStruct.unknown144 = 20;
MortarStruct.unknown148 = 100;
MortarStruct.unknown14C = 50;
MortarStruct.unknown150 = 100;
MortarStruct.unknown154 = 0;
MortarStruct.unknown158 = 0;
MortarStruct.unknown15C = 100;
MortarStruct.unknown160 = 0;
MortarStruct.unknown164 = 9000;
MortarStruct.unknown168 = 0;
MortarStruct.unknown16C = 0;
MortarStruct.unknown170 = 0;
MortarStruct.unknown174 = 0;
MortarStruct.unknown178 = 0;
MortarStruct.unknown17C = 2;
MortarStruct.unknown180 = 4194304;
MortarStruct.unknown184 = 1;
MortarStruct.unknown188 = 0;
MortarStruct.unknown18C = 0;
MortarStruct.unknown190 = 8;
MortarStruct.unknown194 = 0;
MortarStruct.unknown198 = 0;
MortarStruct.unknown19C = 0;
MortarStruct.unknown1A0 = 0;
MortarStruct.unknown1A4 = 0;
MortarStruct.unknown1A8 = 0;
MortarStruct.unknown1AC = 0;
MortarStruct.unknown1B0 = 0;
MortarStruct.unknown1B4 = 0;
MortarStruct.unknown1B8 = 0;
MortarStruct.unknown1BC = 0;
MortarStruct.unknown1C0 = 0;
MortarStruct.unknown1C4 = 0;
MortarStruct.unknown1C8 = 0;
MortarStruct.unknown1CC = 0;



--ID: 4 Name1: Homing Pigeon Name2: Homing Pigeon
local HomingPigeonStruct = WeaponStruct.new()
HomingPigeonStruct.panelRow = 1;
HomingPigeonStruct.unknownC = 0;
HomingPigeonStruct.unknown10 = 0;
HomingPigeonStruct.unknown14 = 1;
HomingPigeonStruct.unknown18 = 1;
HomingPigeonStruct.unknown1C = 3000;
HomingPigeonStruct.unknown20 = 1;
HomingPigeonStruct.unknown24 = 20;
HomingPigeonStruct.unknown28 = 1;
HomingPigeonStruct.unknown2C = 0;
HomingPigeonStruct.unknown30 = 3;
HomingPigeonStruct.unknown34 = 0;
HomingPigeonStruct.unknown38 = 87;
HomingPigeonStruct.unknown3C = 5;
HomingPigeonStruct.unknown40 = 32;
HomingPigeonStruct.unknown44 = 100;
HomingPigeonStruct.unknown48 = 52;
HomingPigeonStruct.unknown4C = 2;
HomingPigeonStruct.unknown50 = 2;
HomingPigeonStruct.unknown54 = 33;
HomingPigeonStruct.unknown58 = 0;
HomingPigeonStruct.unknown5C = 4331646;
HomingPigeonStruct.unknown60 = 25;
HomingPigeonStruct.unknown64 = 100;
HomingPigeonStruct.unknown68 = 75;
HomingPigeonStruct.unknown6C = 0;
HomingPigeonStruct.unknown70 = 0;
HomingPigeonStruct.unknown74 = 175;
HomingPigeonStruct.unknown78 = 3;
HomingPigeonStruct.unknown7C = 0;
HomingPigeonStruct.unknown80 = 0;
HomingPigeonStruct.unknown84 = 100;
HomingPigeonStruct.unknown88 = 50;
HomingPigeonStruct.unknown8C = 100;
HomingPigeonStruct.unknown90 = 0;
HomingPigeonStruct.unknown94 = 0;
HomingPigeonStruct.unknown98 = 100;
HomingPigeonStruct.unknown9C = 0;
HomingPigeonStruct.unknownA0 = 10000;
HomingPigeonStruct.unknownA4 = 0;
HomingPigeonStruct.unknownA8 = 0;
HomingPigeonStruct.unknownAC = 0;
HomingPigeonStruct.unknownB0 = 0;
HomingPigeonStruct.unknownB4 = 0;
HomingPigeonStruct.unknownB8 = 1;
HomingPigeonStruct.unknownBC = 0;
HomingPigeonStruct.unknownC0 = 175;
HomingPigeonStruct.unknownC4 = 3;
HomingPigeonStruct.unknownC8 = 134;
HomingPigeonStruct.unknownCC = 10;
HomingPigeonStruct.unknownD0 = 20;
HomingPigeonStruct.unknownD4 = 50;
HomingPigeonStruct.unknownD8 = 2;
HomingPigeonStruct.unknownDC = 505;
HomingPigeonStruct.unknownE0 = 4540;
HomingPigeonStruct.unknownE4 = 0;
HomingPigeonStruct.unknownE8 = 0;
HomingPigeonStruct.unknownEC = 0;
HomingPigeonStruct.unknownF0 = 0;
HomingPigeonStruct.unknownF4 = 0;
HomingPigeonStruct.unknownF8 = 0;
HomingPigeonStruct.unknownFC = 0;
HomingPigeonStruct.unknown100 = 0;
HomingPigeonStruct.unknown104 = 0;
HomingPigeonStruct.unknown108 = 51;
HomingPigeonStruct.unknown10C = 0;
HomingPigeonStruct.unknown110 = 0;
HomingPigeonStruct.unknown114 = 0;
HomingPigeonStruct.unknown118 = 0;
HomingPigeonStruct.unknown11C = 0;
HomingPigeonStruct.unknown120 = 0;
HomingPigeonStruct.unknown124 = 0;
HomingPigeonStruct.unknown128 = 0;
HomingPigeonStruct.unknown12C = 0;
HomingPigeonStruct.unknown130 = 0;
HomingPigeonStruct.unknown134 = 0;
HomingPigeonStruct.unknown138 = 0;
HomingPigeonStruct.unknown13C = 0;
HomingPigeonStruct.unknown140 = 0;
HomingPigeonStruct.unknown144 = 0;
HomingPigeonStruct.unknown148 = 0;
HomingPigeonStruct.unknown14C = 0;
HomingPigeonStruct.unknown150 = 0;
HomingPigeonStruct.unknown154 = 0;
HomingPigeonStruct.unknown158 = 0;
HomingPigeonStruct.unknown15C = 0;
HomingPigeonStruct.unknown160 = 0;
HomingPigeonStruct.unknown164 = 0;
HomingPigeonStruct.unknown168 = 0;
HomingPigeonStruct.unknown16C = 0;
HomingPigeonStruct.unknown170 = 0;
HomingPigeonStruct.unknown174 = 0;
HomingPigeonStruct.unknown178 = 0;
HomingPigeonStruct.unknown17C = 0;
HomingPigeonStruct.unknown180 = 0;
HomingPigeonStruct.unknown184 = 0;
HomingPigeonStruct.unknown188 = 0;
HomingPigeonStruct.unknown18C = 0;
HomingPigeonStruct.unknown190 = 0;
HomingPigeonStruct.unknown194 = 0;
HomingPigeonStruct.unknown198 = 0;
HomingPigeonStruct.unknown19C = 0;
HomingPigeonStruct.unknown1A0 = 0;
HomingPigeonStruct.unknown1A4 = 0;
HomingPigeonStruct.unknown1A8 = 0;
HomingPigeonStruct.unknown1AC = 0;
HomingPigeonStruct.unknown1B0 = 0;
HomingPigeonStruct.unknown1B4 = 0;
HomingPigeonStruct.unknown1B8 = 0;
HomingPigeonStruct.unknown1BC = 0;
HomingPigeonStruct.unknown1C0 = 0;
HomingPigeonStruct.unknown1C4 = 0;
HomingPigeonStruct.unknown1C8 = 0;
HomingPigeonStruct.unknown1CC = 0;


--ID: 5 Name1: Sheep Launcher Name2: Sheep Launcher
local SheepLauncherStruct = WeaponStruct.new()
SheepLauncherStruct.panelRow = 1;
SheepLauncherStruct.unknownC = 0;
SheepLauncherStruct.unknown10 = 0;
SheepLauncherStruct.unknown14 = 1;
SheepLauncherStruct.unknown18 = 1;
SheepLauncherStruct.unknown1C = 3000;
SheepLauncherStruct.unknown20 = 1;
SheepLauncherStruct.unknown24 = 20;
SheepLauncherStruct.unknown28 = 1;
SheepLauncherStruct.unknown2C = 0;
SheepLauncherStruct.unknown30 = 3;
SheepLauncherStruct.unknown34 = 0;
SheepLauncherStruct.unknown38 = 87;
SheepLauncherStruct.unknown3C = 5;
SheepLauncherStruct.unknown40 = 32;
SheepLauncherStruct.unknown44 = 100;
SheepLauncherStruct.unknown48 = 52;
SheepLauncherStruct.unknown4C = 2;
SheepLauncherStruct.unknown50 = 2;
SheepLauncherStruct.unknown54 = 50;
SheepLauncherStruct.unknown58 = 0;
SheepLauncherStruct.unknown5C = 137342;
SheepLauncherStruct.unknown60 = 0;
SheepLauncherStruct.unknown64 = 0;
SheepLauncherStruct.unknown68 = 0;
SheepLauncherStruct.unknown6C = 0;
SheepLauncherStruct.unknown70 = 0;
SheepLauncherStruct.unknown74 = 65;
SheepLauncherStruct.unknown78 = 2;
SheepLauncherStruct.unknown7C = 131;
SheepLauncherStruct.unknown80 = 50;
SheepLauncherStruct.unknown84 = 100;
SheepLauncherStruct.unknown88 = 50;
SheepLauncherStruct.unknown8C = 100;
SheepLauncherStruct.unknown90 = 0;
SheepLauncherStruct.unknown94 = 0;
SheepLauncherStruct.unknown98 = 100;
SheepLauncherStruct.unknown9C = 0;
SheepLauncherStruct.unknownA0 = 20000;
SheepLauncherStruct.unknownA4 = 0;
SheepLauncherStruct.unknownA8 = 0;
SheepLauncherStruct.unknownAC = 0;
SheepLauncherStruct.unknownB0 = 0;
SheepLauncherStruct.unknownB4 = 1;
SheepLauncherStruct.unknownB8 = 5;
SheepLauncherStruct.unknownBC = 4194304;
SheepLauncherStruct.unknownC0 = 1;
SheepLauncherStruct.unknownC4 = 0;
SheepLauncherStruct.unknownC8 = 0;
SheepLauncherStruct.unknownCC = 8;
SheepLauncherStruct.unknownD0 = 0;
SheepLauncherStruct.unknownD4 = 0;
SheepLauncherStruct.unknownD8 = 0;
SheepLauncherStruct.unknownDC = 0;
SheepLauncherStruct.unknownE0 = 0;
SheepLauncherStruct.unknownE4 = 0;
SheepLauncherStruct.unknownE8 = 0;
SheepLauncherStruct.unknownEC = 0;
SheepLauncherStruct.unknownF0 = 0;
SheepLauncherStruct.unknownF4 = 0;
SheepLauncherStruct.unknownF8 = 0;
SheepLauncherStruct.unknownFC = 0;
SheepLauncherStruct.unknown100 = 0;
SheepLauncherStruct.unknown104 = 3;
SheepLauncherStruct.unknown108 = 50;
SheepLauncherStruct.unknown10C = 1;
SheepLauncherStruct.unknown110 = 0;
SheepLauncherStruct.unknown114 = 0;
SheepLauncherStruct.unknown118 = 0;
SheepLauncherStruct.unknown11C = 0;
SheepLauncherStruct.unknown120 = 0;
SheepLauncherStruct.unknown124 = 0;
SheepLauncherStruct.unknown128 = 100;
SheepLauncherStruct.unknown12C = 75;
SheepLauncherStruct.unknown130 = 0;
SheepLauncherStruct.unknown134 = 1;
SheepLauncherStruct.unknown138 = 152;
SheepLauncherStruct.unknown13C = 6;
SheepLauncherStruct.unknown140 = 131;
SheepLauncherStruct.unknown144 = 0;
SheepLauncherStruct.unknown148 = 100;
SheepLauncherStruct.unknown14C = 50;
SheepLauncherStruct.unknown150 = 100;
SheepLauncherStruct.unknown154 = 0;
SheepLauncherStruct.unknown158 = 0;
SheepLauncherStruct.unknown15C = 100;
SheepLauncherStruct.unknown160 = 5000;
SheepLauncherStruct.unknown164 = 20000;
SheepLauncherStruct.unknown168 = 0;
SheepLauncherStruct.unknown16C = 0;
SheepLauncherStruct.unknown170 = 0;
SheepLauncherStruct.unknown174 = 0;
SheepLauncherStruct.unknown178 = 1;
SheepLauncherStruct.unknown17C = 3;
SheepLauncherStruct.unknown180 = 4331646;
SheepLauncherStruct.unknown184 = 4331646;
SheepLauncherStruct.unknown188 = 100;
SheepLauncherStruct.unknown18C = 4;
SheepLauncherStruct.unknown190 = 0;
SheepLauncherStruct.unknown194 = 0;
SheepLauncherStruct.unknown198 = 0;
SheepLauncherStruct.unknown19C = 25;
SheepLauncherStruct.unknown1A0 = 100;
SheepLauncherStruct.unknown1A4 = 50;
SheepLauncherStruct.unknown1A8 = -10;
SheepLauncherStruct.unknown1AC = 0;
SheepLauncherStruct.unknown1B0 = 0;
SheepLauncherStruct.unknown1B4 = 0;
SheepLauncherStruct.unknown1B8 = 0;
SheepLauncherStruct.unknown1BC = 0;
SheepLauncherStruct.unknown1C0 = 0;
SheepLauncherStruct.unknown1C4 = 0;
SheepLauncherStruct.unknown1C8 = 0;
SheepLauncherStruct.unknown1CC = 0;


--ID: 6 Name1: Grenade Name2: Grenade
local GrenadeStruct = WeaponStruct.new()
GrenadeStruct.panelRow = 2;
GrenadeStruct.unknownC = 0;
GrenadeStruct.unknown10 = 0;
GrenadeStruct.unknown14 = 1;
GrenadeStruct.unknown18 = 1;
GrenadeStruct.unknown1C = 3000;
GrenadeStruct.unknown20 = 1;
GrenadeStruct.unknown24 = 20;
GrenadeStruct.unknown28 = 1;
GrenadeStruct.unknown2C = 0;
GrenadeStruct.unknown30 = 3;
GrenadeStruct.unknown34 = 0;
GrenadeStruct.unknown38 = 87;
GrenadeStruct.unknown3C = 5;
GrenadeStruct.unknown40 = 32;
GrenadeStruct.unknown44 = 100;
GrenadeStruct.unknown48 = 52;
GrenadeStruct.unknown4C = 2;
GrenadeStruct.unknown50 = 2;
GrenadeStruct.unknown54 = 0;
GrenadeStruct.unknown58 = 1;
GrenadeStruct.unknown5C = 0;
GrenadeStruct.unknown60 = 10;
GrenadeStruct.unknown64 = 100;
GrenadeStruct.unknown68 = 50;
GrenadeStruct.unknown6C = 0;
GrenadeStruct.unknown70 = 0;
GrenadeStruct.unknown74 = 50;
GrenadeStruct.unknown78 = 1;
GrenadeStruct.unknown7C = 131;
GrenadeStruct.unknown80 = 0;
GrenadeStruct.unknown84 = 100;
GrenadeStruct.unknown88 = 50;
GrenadeStruct.unknown8C = 100;
GrenadeStruct.unknown90 = 0;
GrenadeStruct.unknown94 = 0;
GrenadeStruct.unknown98 = 100;
GrenadeStruct.unknown9C = 5000;
GrenadeStruct.unknownA0 = 0;
GrenadeStruct.unknownA4 = 0;
GrenadeStruct.unknownA8 = 0;
GrenadeStruct.unknownAC = 0;
GrenadeStruct.unknownB0 = 0;
GrenadeStruct.unknownB4 = 0;
GrenadeStruct.unknownB8 = 2;
GrenadeStruct.unknownBC = 4331614;
GrenadeStruct.unknownC0 = 0;
GrenadeStruct.unknownC4 = 100;
GrenadeStruct.unknownC8 = 113;
GrenadeStruct.unknownCC = 8;
GrenadeStruct.unknownD0 = 0;
GrenadeStruct.unknownD4 = 0;
GrenadeStruct.unknownD8 = 0;
GrenadeStruct.unknownDC = 0;
GrenadeStruct.unknownE0 = 0;
GrenadeStruct.unknownE4 = 0;
GrenadeStruct.unknownE8 = 0;
GrenadeStruct.unknownEC = 0;
GrenadeStruct.unknownF0 = 0;
GrenadeStruct.unknownF4 = 0;
GrenadeStruct.unknownF8 = 0;
GrenadeStruct.unknownFC = 0;
GrenadeStruct.unknown100 = 0;
GrenadeStruct.unknown104 = 0;
GrenadeStruct.unknown108 = 0;
GrenadeStruct.unknown10C = 0;
GrenadeStruct.unknown110 = 0;
GrenadeStruct.unknown114 = 0;
GrenadeStruct.unknown118 = 0;
GrenadeStruct.unknown11C = 0;
GrenadeStruct.unknown120 = 0;
GrenadeStruct.unknown124 = 0;
GrenadeStruct.unknown128 = 0;
GrenadeStruct.unknown12C = 0;
GrenadeStruct.unknown130 = 0;
GrenadeStruct.unknown134 = 0;
GrenadeStruct.unknown138 = 0;
GrenadeStruct.unknown13C = 0;
GrenadeStruct.unknown140 = 0;
GrenadeStruct.unknown144 = 0;
GrenadeStruct.unknown148 = 0;
GrenadeStruct.unknown14C = 0;
GrenadeStruct.unknown150 = 0;
GrenadeStruct.unknown154 = 0;
GrenadeStruct.unknown158 = 0;
GrenadeStruct.unknown15C = 0;
GrenadeStruct.unknown160 = 0;
GrenadeStruct.unknown164 = 0;
GrenadeStruct.unknown168 = 0;
GrenadeStruct.unknown16C = 0;
GrenadeStruct.unknown170 = 0;
GrenadeStruct.unknown174 = 0;
GrenadeStruct.unknown178 = 0;
GrenadeStruct.unknown17C = 0;
GrenadeStruct.unknown180 = 0;
GrenadeStruct.unknown184 = 0;
GrenadeStruct.unknown188 = 0;
GrenadeStruct.unknown18C = 0;
GrenadeStruct.unknown190 = 0;
GrenadeStruct.unknown194 = 0;
GrenadeStruct.unknown198 = 0;
GrenadeStruct.unknown19C = 0;
GrenadeStruct.unknown1A0 = 0;
GrenadeStruct.unknown1A4 = 0;
GrenadeStruct.unknown1A8 = 0;
GrenadeStruct.unknown1AC = 0;
GrenadeStruct.unknown1B0 = 0;
GrenadeStruct.unknown1B4 = 0;
GrenadeStruct.unknown1B8 = 0;
GrenadeStruct.unknown1BC = 0;
GrenadeStruct.unknown1C0 = 0;
GrenadeStruct.unknown1C4 = 0;
GrenadeStruct.unknown1C8 = 0;
GrenadeStruct.unknown1CC = 0;

--ID: 7 Name1: Cluster Bomb Name2: Cluster Bomb
local ClusterBombStruct = WeaponStruct.new()
ClusterBombStruct.panelRow = 2;
ClusterBombStruct.unknownC = 0;
ClusterBombStruct.unknown10 = 0;
ClusterBombStruct.unknown14 = 1;
ClusterBombStruct.unknown18 = 1;
ClusterBombStruct.unknown1C = 3000;
ClusterBombStruct.unknown20 = 1;
ClusterBombStruct.unknown24 = 20;
ClusterBombStruct.unknown28 = 1;
ClusterBombStruct.unknown2C = 0;
ClusterBombStruct.unknown30 = 3;
ClusterBombStruct.unknown34 = 0;
ClusterBombStruct.unknown38 = 87;
ClusterBombStruct.unknown3C = 5;
ClusterBombStruct.unknown40 = 32;
ClusterBombStruct.unknown44 = 100;
ClusterBombStruct.unknown48 = 52;
ClusterBombStruct.unknown4C = 2;
ClusterBombStruct.unknown50 = 2;
ClusterBombStruct.unknown54 = 0;
ClusterBombStruct.unknown58 = 1;
ClusterBombStruct.unknown5C = 0;
ClusterBombStruct.unknown60 = 0;
ClusterBombStruct.unknown64 = 0;
ClusterBombStruct.unknown68 = 20;
ClusterBombStruct.unknown6C = 0;
ClusterBombStruct.unknown70 = 0;
ClusterBombStruct.unknown74 = 53;
ClusterBombStruct.unknown78 = 1;
ClusterBombStruct.unknown7C = 131;
ClusterBombStruct.unknown80 = 0;
ClusterBombStruct.unknown84 = 100;
ClusterBombStruct.unknown88 = 50;
ClusterBombStruct.unknown8C = 100;
ClusterBombStruct.unknown90 = 0;
ClusterBombStruct.unknown94 = 0;
ClusterBombStruct.unknown98 = 100;
ClusterBombStruct.unknown9C = 5000;
ClusterBombStruct.unknownA0 = 0;
ClusterBombStruct.unknownA4 = 0;
ClusterBombStruct.unknownA8 = 0;
ClusterBombStruct.unknownAC = 0;
ClusterBombStruct.unknownB0 = 0;
ClusterBombStruct.unknownB4 = 0;
ClusterBombStruct.unknownB8 = 2;
ClusterBombStruct.unknownBC = 4331614;
ClusterBombStruct.unknownC0 = 0;
ClusterBombStruct.unknownC4 = 100;
ClusterBombStruct.unknownC8 = 113;
ClusterBombStruct.unknownCC = 8;
ClusterBombStruct.unknownD0 = 0;
ClusterBombStruct.unknownD4 = 0;
ClusterBombStruct.unknownD8 = 0;
ClusterBombStruct.unknownDC = 0;
ClusterBombStruct.unknownE0 = 0;
ClusterBombStruct.unknownE4 = 0;
ClusterBombStruct.unknownE8 = 0;
ClusterBombStruct.unknownEC = 0;
ClusterBombStruct.unknownF0 = 0;
ClusterBombStruct.unknownF4 = 0;
ClusterBombStruct.unknownF8 = 0;
ClusterBombStruct.unknownFC = 0;
ClusterBombStruct.unknown100 = 0;
ClusterBombStruct.unknown104 = 1;
ClusterBombStruct.unknown108 = 0;
ClusterBombStruct.unknown10C = 5;
ClusterBombStruct.unknown110 = 30;
ClusterBombStruct.unknown114 = 30;
ClusterBombStruct.unknown118 = 0;
ClusterBombStruct.unknown11C = 45;
ClusterBombStruct.unknown120 = 137342;
ClusterBombStruct.unknown124 = 0;
ClusterBombStruct.unknown128 = 100;
ClusterBombStruct.unknown12C = 20;
ClusterBombStruct.unknown130 = 0;
ClusterBombStruct.unknown134 = 1;
ClusterBombStruct.unknown138 = 54;
ClusterBombStruct.unknown13C = 1;
ClusterBombStruct.unknown140 = 131;
ClusterBombStruct.unknown144 = 20;
ClusterBombStruct.unknown148 = 100;
ClusterBombStruct.unknown14C = 50;
ClusterBombStruct.unknown150 = 100;
ClusterBombStruct.unknown154 = 0;
ClusterBombStruct.unknown158 = 0;
ClusterBombStruct.unknown15C = 100;
ClusterBombStruct.unknown160 = 0;
ClusterBombStruct.unknown164 = 9000;
ClusterBombStruct.unknown168 = 0;
ClusterBombStruct.unknown16C = 0;
ClusterBombStruct.unknown170 = 0;
ClusterBombStruct.unknown174 = 0;
ClusterBombStruct.unknown178 = 0;
ClusterBombStruct.unknown17C = 2;
ClusterBombStruct.unknown180 = 4331614;
ClusterBombStruct.unknown184 = 0;
ClusterBombStruct.unknown188 = 100;
ClusterBombStruct.unknown18C = 113;
ClusterBombStruct.unknown190 = 8;
ClusterBombStruct.unknown194 = 0;
ClusterBombStruct.unknown198 = 0;
ClusterBombStruct.unknown19C = 0;
ClusterBombStruct.unknown1A0 = 0;
ClusterBombStruct.unknown1A4 = 0;
ClusterBombStruct.unknown1A8 = 0;
ClusterBombStruct.unknown1AC = 0;
ClusterBombStruct.unknown1B0 = 0;
ClusterBombStruct.unknown1B4 = 0;
ClusterBombStruct.unknown1B8 = 0;
ClusterBombStruct.unknown1BC = 0;
ClusterBombStruct.unknown1C0 = 0;
ClusterBombStruct.unknown1C4 = 0;
ClusterBombStruct.unknown1C8 = 0;
ClusterBombStruct.unknown1CC = 0;

--ID: 8 Name1: Banana Bomb Name2: Banana Bomb
local BananaBombStruct = WeaponStruct.new()
BananaBombStruct.panelRow = 2;
BananaBombStruct.unknownC = 0;
BananaBombStruct.unknown10 = 0;
BananaBombStruct.unknown14 = 1;
BananaBombStruct.unknown18 = 1;
BananaBombStruct.unknown1C = 3000;
BananaBombStruct.unknown20 = 1;
BananaBombStruct.unknown24 = 20;
BananaBombStruct.unknown28 = 1;
BananaBombStruct.unknown2C = 0;
BananaBombStruct.unknown30 = 3;
BananaBombStruct.unknown34 = 0;
BananaBombStruct.unknown38 = 87;
BananaBombStruct.unknown3C = 5;
BananaBombStruct.unknown40 = 32;
BananaBombStruct.unknown44 = 100;
BananaBombStruct.unknown48 = 52;
BananaBombStruct.unknown4C = 2;
BananaBombStruct.unknown50 = 2;
BananaBombStruct.unknown54 = 0;
BananaBombStruct.unknown58 = 1;
BananaBombStruct.unknown5C = 0;
BananaBombStruct.unknown60 = 50;
BananaBombStruct.unknown64 = 100;
BananaBombStruct.unknown68 = 75;
BananaBombStruct.unknown6C = 0;
BananaBombStruct.unknown70 = 0;
BananaBombStruct.unknown74 = 51;
BananaBombStruct.unknown78 = 1;
BananaBombStruct.unknown7C = 131;
BananaBombStruct.unknown80 = 0;
BananaBombStruct.unknown84 = 100;
BananaBombStruct.unknown88 = 50;
BananaBombStruct.unknown8C = 100;
BananaBombStruct.unknown90 = 0;
BananaBombStruct.unknown94 = 0;
BananaBombStruct.unknown98 = 100;
BananaBombStruct.unknown9C = 5000;
BananaBombStruct.unknownA0 = 0;
BananaBombStruct.unknownA4 = 0;
BananaBombStruct.unknownA8 = 0;
BananaBombStruct.unknownAC = 0;
BananaBombStruct.unknownB0 = 0;
BananaBombStruct.unknownB4 = 0;
BananaBombStruct.unknownB8 = 2;
BananaBombStruct.unknownBC = 4331614;
BananaBombStruct.unknownC0 = 60;
BananaBombStruct.unknownC4 = 100;
BananaBombStruct.unknownC8 = 111;
BananaBombStruct.unknownCC = 8;
BananaBombStruct.unknownD0 = 0;
BananaBombStruct.unknownD4 = 0;
BananaBombStruct.unknownD8 = 0;
BananaBombStruct.unknownDC = 0;
BananaBombStruct.unknownE0 = 0;
BananaBombStruct.unknownE4 = 0;
BananaBombStruct.unknownE8 = 0;
BananaBombStruct.unknownEC = 0;
BananaBombStruct.unknownF0 = 0;
BananaBombStruct.unknownF4 = 0;
BananaBombStruct.unknownF8 = 0;
BananaBombStruct.unknownFC = 0;
BananaBombStruct.unknown100 = 0;
BananaBombStruct.unknown104 = 1;
BananaBombStruct.unknown108 = 0;
BananaBombStruct.unknown10C = 5;
BananaBombStruct.unknown110 = 45;
BananaBombStruct.unknown114 = 30;
BananaBombStruct.unknown118 = 0;
BananaBombStruct.unknown11C = 25;
BananaBombStruct.unknown120 = 137342;
BananaBombStruct.unknown124 = 0;
BananaBombStruct.unknown128 = 100;
BananaBombStruct.unknown12C = 75;
BananaBombStruct.unknown130 = 0;
BananaBombStruct.unknown134 = 1;
BananaBombStruct.unknown138 = 51;
BananaBombStruct.unknown13C = 1;
BananaBombStruct.unknown140 = 131;
BananaBombStruct.unknown144 = 0;
BananaBombStruct.unknown148 = 100;
BananaBombStruct.unknown14C = 50;
BananaBombStruct.unknown150 = 100;
BananaBombStruct.unknown154 = 0;
BananaBombStruct.unknown158 = 0;
BananaBombStruct.unknown15C = 100;
BananaBombStruct.unknown160 = 0;
BananaBombStruct.unknown164 = 9000;
BananaBombStruct.unknown168 = 0;
BananaBombStruct.unknown16C = 0;
BananaBombStruct.unknown170 = 0;
BananaBombStruct.unknown174 = 0;
BananaBombStruct.unknown178 = 0;
BananaBombStruct.unknown17C = 2;
BananaBombStruct.unknown180 = 4331614;
BananaBombStruct.unknown184 = 60;
BananaBombStruct.unknown188 = 100;
BananaBombStruct.unknown18C = 111;
BananaBombStruct.unknown190 = 8;
BananaBombStruct.unknown194 = 0;
BananaBombStruct.unknown198 = 0;
BananaBombStruct.unknown19C = 0;
BananaBombStruct.unknown1A0 = 0;
BananaBombStruct.unknown1A4 = 0;
BananaBombStruct.unknown1A8 = 0;
BananaBombStruct.unknown1AC = 0;
BananaBombStruct.unknown1B0 = 0;
BananaBombStruct.unknown1B4 = 0;
BananaBombStruct.unknown1B8 = 0;
BananaBombStruct.unknown1BC = 0;
BananaBombStruct.unknown1C0 = 0;
BananaBombStruct.unknown1C4 = 0;
BananaBombStruct.unknown1C8 = 0;
BananaBombStruct.unknown1CC = 0;



--ID: 21 Name1: Dynamite Name2: Dynamite
local DynamiteStruct = WeaponStruct.new()
DynamiteStruct.panelRow = 5;
DynamiteStruct.unknownC = 0;
DynamiteStruct.unknown10 = 0;
DynamiteStruct.unknown14 = 1;
DynamiteStruct.unknown18 = 1;
DynamiteStruct.unknown1C = 3000;
DynamiteStruct.unknown20 = 1;
DynamiteStruct.unknown24 = 20;
DynamiteStruct.unknown28 = 1;
DynamiteStruct.unknown2C = 0;
DynamiteStruct.unknown30 = 3;
DynamiteStruct.unknown34 = 0;
DynamiteStruct.unknown38 = 87;
DynamiteStruct.unknown3C = 5;
DynamiteStruct.unknown40 = 32;
DynamiteStruct.unknown44 = 100;
DynamiteStruct.unknown48 = 52;
DynamiteStruct.unknown4C = 2;
DynamiteStruct.unknown50 = 2;
DynamiteStruct.unknown54 = 5;
DynamiteStruct.unknown58 = 1;
DynamiteStruct.unknown5C = 0;
DynamiteStruct.unknown60 = 50;
DynamiteStruct.unknown64 = 100;
DynamiteStruct.unknown68 = 75;
DynamiteStruct.unknown6C = 0;
DynamiteStruct.unknown70 = 0;
DynamiteStruct.unknown74 = 78;
DynamiteStruct.unknown78 = 0;
DynamiteStruct.unknown7C = 131;
DynamiteStruct.unknown80 = 0;
DynamiteStruct.unknown84 = 100;
DynamiteStruct.unknown88 = 50;
DynamiteStruct.unknown8C = 100;
DynamiteStruct.unknown90 = 0;
DynamiteStruct.unknown94 = 0;
DynamiteStruct.unknown98 = 100;
DynamiteStruct.unknown9C = 5000;
DynamiteStruct.unknownA0 = 5000;
DynamiteStruct.unknownA4 = 65602;
DynamiteStruct.unknownA8 = 0;
DynamiteStruct.unknownAC = 0;
DynamiteStruct.unknownB0 = 0;
DynamiteStruct.unknownB4 = 0;
DynamiteStruct.unknownB8 = 2;
DynamiteStruct.unknownBC = 4331614;
DynamiteStruct.unknownC0 = 30;
DynamiteStruct.unknownC4 = 0;
DynamiteStruct.unknownC8 = 113;
DynamiteStruct.unknownCC = 8;
DynamiteStruct.unknownD0 = 0;
DynamiteStruct.unknownD4 = 0;
DynamiteStruct.unknownD8 = 0;
DynamiteStruct.unknownDC = 0;
DynamiteStruct.unknownE0 = 0;
DynamiteStruct.unknownE4 = 0;
DynamiteStruct.unknownE8 = 0;
DynamiteStruct.unknownEC = 0;
DynamiteStruct.unknownF0 = 0;
DynamiteStruct.unknownF4 = 0;
DynamiteStruct.unknownF8 = 0;
DynamiteStruct.unknownFC = 0;
DynamiteStruct.unknown100 = 0;
DynamiteStruct.unknown104 = 0;
DynamiteStruct.unknown108 = 0;
DynamiteStruct.unknown10C = 0;
DynamiteStruct.unknown110 = 0;
DynamiteStruct.unknown114 = 0;
DynamiteStruct.unknown118 = 0;
DynamiteStruct.unknown11C = 0;
DynamiteStruct.unknown120 = 0;
DynamiteStruct.unknown124 = 0;
DynamiteStruct.unknown128 = 0;
DynamiteStruct.unknown12C = 0;
DynamiteStruct.unknown130 = 0;
DynamiteStruct.unknown134 = 0;
DynamiteStruct.unknown138 = 0;
DynamiteStruct.unknown13C = 0;
DynamiteStruct.unknown140 = 0;
DynamiteStruct.unknown144 = 0;
DynamiteStruct.unknown148 = 0;
DynamiteStruct.unknown14C = 0;
DynamiteStruct.unknown150 = 0;
DynamiteStruct.unknown154 = 0;
DynamiteStruct.unknown158 = 0;
DynamiteStruct.unknown15C = 0;
DynamiteStruct.unknown160 = 0;
DynamiteStruct.unknown164 = 0;
DynamiteStruct.unknown168 = 0;
DynamiteStruct.unknown16C = 0;
DynamiteStruct.unknown170 = 0;
DynamiteStruct.unknown174 = 0;
DynamiteStruct.unknown178 = 0;
DynamiteStruct.unknown17C = 0;
DynamiteStruct.unknown180 = 0;
DynamiteStruct.unknown184 = 0;
DynamiteStruct.unknown188 = 0;
DynamiteStruct.unknown18C = 0;
DynamiteStruct.unknown190 = 0;
DynamiteStruct.unknown194 = 0;
DynamiteStruct.unknown198 = 0;
DynamiteStruct.unknown19C = 0;
DynamiteStruct.unknown1A0 = 0;
DynamiteStruct.unknown1A4 = 0;
DynamiteStruct.unknown1A8 = 0;
DynamiteStruct.unknown1AC = 0;
DynamiteStruct.unknown1B0 = 0;
DynamiteStruct.unknown1B4 = 0;
DynamiteStruct.unknown1B8 = 0;
DynamiteStruct.unknown1BC = 0;
DynamiteStruct.unknown1C0 = 0;
DynamiteStruct.unknown1C4 = 0;
DynamiteStruct.unknown1C8 = 0;
DynamiteStruct.unknown1CC = 0;


--ID: 23 Name1: Sheep Name2: Sheep
local SheepStruct = WeaponStruct.new()
SheepStruct.panelRow = 5;
SheepStruct.unknownC = 0;
SheepStruct.unknown10 = 0;
SheepStruct.unknown14 = 1;
SheepStruct.unknown18 = 1;
SheepStruct.unknown1C = 3000;
SheepStruct.unknown20 = 1;
SheepStruct.unknown24 = 20;
SheepStruct.unknown28 = 1;
SheepStruct.unknown2C = 0;
SheepStruct.unknown30 = 3;
SheepStruct.unknown34 = 0;
SheepStruct.unknown38 = 87;
SheepStruct.unknown3C = 5;
SheepStruct.unknown40 = 32;
SheepStruct.unknown44 = 100;
SheepStruct.unknown48 = 52;
SheepStruct.unknown4C = 2;
SheepStruct.unknown50 = 2;
SheepStruct.unknown54 = 5;
SheepStruct.unknown58 = 0;
SheepStruct.unknown5C = 0;
SheepStruct.unknown60 = 50;
SheepStruct.unknown64 = 100;
SheepStruct.unknown68 = 75;
SheepStruct.unknown6C = 0;
SheepStruct.unknown70 = 0;
SheepStruct.unknown74 = 153;
SheepStruct.unknown78 = 6;
SheepStruct.unknown7C = 131;
SheepStruct.unknown80 = 0;
SheepStruct.unknown84 = 100;
SheepStruct.unknown88 = 50;
SheepStruct.unknown8C = 100;
SheepStruct.unknown90 = 0;
SheepStruct.unknown94 = 0;
SheepStruct.unknown98 = 100;
SheepStruct.unknown9C = 5000;
SheepStruct.unknownA0 = 20000;
SheepStruct.unknownA4 = 0;
SheepStruct.unknownA8 = 0;
SheepStruct.unknownAC = 0;
SheepStruct.unknownB0 = 0;
SheepStruct.unknownB4 = 1;
SheepStruct.unknownB8 = 3;
SheepStruct.unknownBC = 4331646;
SheepStruct.unknownC0 = 4331646;
SheepStruct.unknownC4 = 100;
SheepStruct.unknownC8 = 4;
SheepStruct.unknownCC = 0;
SheepStruct.unknownD0 = 0;
SheepStruct.unknownD4 = 0;
SheepStruct.unknownD8 = 25;
SheepStruct.unknownDC = 100;
SheepStruct.unknownE0 = 50;
SheepStruct.unknownE4 = -10;
SheepStruct.unknownE8 = 0;
SheepStruct.unknownEC = 0;
SheepStruct.unknownF0 = 0;
SheepStruct.unknownF4 = 0;
SheepStruct.unknownF8 = 0;
SheepStruct.unknownFC = 0;
SheepStruct.unknown100 = 0;
SheepStruct.unknown104 = 0;
SheepStruct.unknown108 = 0;
SheepStruct.unknown10C = 0;
SheepStruct.unknown110 = 0;
SheepStruct.unknown114 = 0;
SheepStruct.unknown118 = 0;
SheepStruct.unknown11C = 0;
SheepStruct.unknown120 = 0;
SheepStruct.unknown124 = 0;
SheepStruct.unknown128 = 0;
SheepStruct.unknown12C = 0;
SheepStruct.unknown130 = 0;
SheepStruct.unknown134 = 0;
SheepStruct.unknown138 = 0;
SheepStruct.unknown13C = 0;
SheepStruct.unknown140 = 0;
SheepStruct.unknown144 = 0;
SheepStruct.unknown148 = 0;
SheepStruct.unknown14C = 0;
SheepStruct.unknown150 = 0;
SheepStruct.unknown154 = 0;
SheepStruct.unknown158 = 0;
SheepStruct.unknown15C = 0;
SheepStruct.unknown160 = 0;
SheepStruct.unknown164 = 0;
SheepStruct.unknown168 = 0;
SheepStruct.unknown16C = 0;
SheepStruct.unknown170 = 0;
SheepStruct.unknown174 = 0;
SheepStruct.unknown178 = 0;
SheepStruct.unknown17C = 0;
SheepStruct.unknown180 = 0;
SheepStruct.unknown184 = 0;
SheepStruct.unknown188 = 0;
SheepStruct.unknown18C = 0;
SheepStruct.unknown190 = 0;
SheepStruct.unknown194 = 0;
SheepStruct.unknown198 = 0;
SheepStruct.unknown19C = 0;
SheepStruct.unknown1A0 = 0;
SheepStruct.unknown1A4 = 0;
SheepStruct.unknown1A8 = 0;
SheepStruct.unknown1AC = 0;
SheepStruct.unknown1B0 = 0;
SheepStruct.unknown1B4 = 0;
SheepStruct.unknown1B8 = 0;
SheepStruct.unknown1BC = 0;
SheepStruct.unknown1C0 = 0;
SheepStruct.unknown1C4 = 0;
SheepStruct.unknown1C8 = 0;
SheepStruct.unknown1CC = 0;


--ID: 24 Name1: Super Sheep Name2: Super Sheep
local SuperSheepStruct = WeaponStruct.new()
SuperSheepStruct.panelRow = 5;
SuperSheepStruct.unknownC = 0;
SuperSheepStruct.unknown10 = 0;
SuperSheepStruct.unknown14 = 1;
SuperSheepStruct.unknown18 = 1;
SuperSheepStruct.unknown1C = 3000;
SuperSheepStruct.unknown20 = 1;
SuperSheepStruct.unknown24 = 20;
SuperSheepStruct.unknown28 = 1;
SuperSheepStruct.unknown2C = 0;
SuperSheepStruct.unknown30 = 3;
SuperSheepStruct.unknown34 = 0;
SuperSheepStruct.unknown38 = 87;
SuperSheepStruct.unknown3C = 5;
SuperSheepStruct.unknown40 = 32;
SuperSheepStruct.unknown44 = 100;
SuperSheepStruct.unknown48 = 52;
SuperSheepStruct.unknown4C = 2;
SuperSheepStruct.unknown50 = 2;
SuperSheepStruct.unknown54 = 5;
SuperSheepStruct.unknown58 = 0;
SuperSheepStruct.unknown5C = 0;
SuperSheepStruct.unknown60 = 50;
SuperSheepStruct.unknown64 = 100;
SuperSheepStruct.unknown68 = 75;
SuperSheepStruct.unknown6C = 0;
SuperSheepStruct.unknown70 = 0;
SuperSheepStruct.unknown74 = 153;
SuperSheepStruct.unknown78 = 6;
SuperSheepStruct.unknown7C = 131;
SuperSheepStruct.unknown80 = 0;
SuperSheepStruct.unknown84 = 100;
SuperSheepStruct.unknown88 = 50;
SuperSheepStruct.unknown8C = 100;
SuperSheepStruct.unknown90 = 0;
SuperSheepStruct.unknown94 = 0;
SuperSheepStruct.unknown98 = 100;
SuperSheepStruct.unknown9C = 5000;
SuperSheepStruct.unknownA0 = 20000;
SuperSheepStruct.unknownA4 = 0;
SuperSheepStruct.unknownA8 = 0;
SuperSheepStruct.unknownAC = 0;
SuperSheepStruct.unknownB0 = 0;
SuperSheepStruct.unknownB4 = 1;
SuperSheepStruct.unknownB8 = 3;
SuperSheepStruct.unknownBC = 4331646;
SuperSheepStruct.unknownC0 = 4331646;
SuperSheepStruct.unknownC4 = 100;
SuperSheepStruct.unknownC8 = 4;
SuperSheepStruct.unknownCC = 0;
SuperSheepStruct.unknownD0 = 0;
SuperSheepStruct.unknownD4 = 0;
SuperSheepStruct.unknownD8 = 25;
SuperSheepStruct.unknownDC = 100;
SuperSheepStruct.unknownE0 = 50;
SuperSheepStruct.unknownE4 = -10;
SuperSheepStruct.unknownE8 = 0;
SuperSheepStruct.unknownEC = 0;
SuperSheepStruct.unknownF0 = 0;
SuperSheepStruct.unknownF4 = 154;
SuperSheepStruct.unknownF8 = 155;
SuperSheepStruct.unknownFC = 76;
SuperSheepStruct.unknown100 = 65613;
SuperSheepStruct.unknown104 = 0;
SuperSheepStruct.unknown108 = 0;
SuperSheepStruct.unknown10C = 0;
SuperSheepStruct.unknown110 = 0;
SuperSheepStruct.unknown114 = 0;
SuperSheepStruct.unknown118 = 0;
SuperSheepStruct.unknown11C = 0;
SuperSheepStruct.unknown120 = 0;
SuperSheepStruct.unknown124 = 0;
SuperSheepStruct.unknown128 = 0;
SuperSheepStruct.unknown12C = 0;
SuperSheepStruct.unknown130 = 0;
SuperSheepStruct.unknown134 = 0;
SuperSheepStruct.unknown138 = 0;
SuperSheepStruct.unknown13C = 0;
SuperSheepStruct.unknown140 = 0;
SuperSheepStruct.unknown144 = 0;
SuperSheepStruct.unknown148 = 0;
SuperSheepStruct.unknown14C = 0;
SuperSheepStruct.unknown150 = 0;
SuperSheepStruct.unknown154 = 0;
SuperSheepStruct.unknown158 = 0;
SuperSheepStruct.unknown15C = 0;
SuperSheepStruct.unknown160 = 0;
SuperSheepStruct.unknown164 = 0;
SuperSheepStruct.unknown168 = 0;
SuperSheepStruct.unknown16C = 0;
SuperSheepStruct.unknown170 = 0;
SuperSheepStruct.unknown174 = 0;
SuperSheepStruct.unknown178 = 0;
SuperSheepStruct.unknown17C = 0;
SuperSheepStruct.unknown180 = 0;
SuperSheepStruct.unknown184 = 0;
SuperSheepStruct.unknown188 = 0;
SuperSheepStruct.unknown18C = 0;
SuperSheepStruct.unknown190 = 0;
SuperSheepStruct.unknown194 = 0;
SuperSheepStruct.unknown198 = 0;
SuperSheepStruct.unknown19C = 0;
SuperSheepStruct.unknown1A0 = 0;
SuperSheepStruct.unknown1A4 = 0;
SuperSheepStruct.unknown1A8 = 0;
SuperSheepStruct.unknown1AC = 0;
SuperSheepStruct.unknown1B0 = 0;
SuperSheepStruct.unknown1B4 = 0;
SuperSheepStruct.unknown1B8 = 0;
SuperSheepStruct.unknown1BC = 0;
SuperSheepStruct.unknown1C0 = 0;
SuperSheepStruct.unknown1C4 = 0;
SuperSheepStruct.unknown1C8 = 0;
SuperSheepStruct.unknown1CC = 0;


--ID: 25 Name1: Aqua Sheep Name2: Aqua Sheep
local AquaSheepStruct = WeaponStruct.new()
AquaSheepStruct.panelRow = 5;
AquaSheepStruct.unknownC = 0;
AquaSheepStruct.unknown10 = 0;
AquaSheepStruct.unknown14 = 1;
AquaSheepStruct.unknown18 = 1;
AquaSheepStruct.unknown1C = 3000;
AquaSheepStruct.unknown20 = 1;
AquaSheepStruct.unknown24 = 20;
AquaSheepStruct.unknown28 = 1;
AquaSheepStruct.unknown2C = 0;
AquaSheepStruct.unknown30 = 3;
AquaSheepStruct.unknown34 = 0;
AquaSheepStruct.unknown38 = 87;
AquaSheepStruct.unknown3C = 5;
AquaSheepStruct.unknown40 = 32;
AquaSheepStruct.unknown44 = 100;
AquaSheepStruct.unknown48 = 52;
AquaSheepStruct.unknown4C = 2;
AquaSheepStruct.unknown50 = 2;
AquaSheepStruct.unknown54 = 5;
AquaSheepStruct.unknown58 = 0;
AquaSheepStruct.unknown5C = 0;
AquaSheepStruct.unknown60 = 50;
AquaSheepStruct.unknown64 = 100;
AquaSheepStruct.unknown68 = 75;
AquaSheepStruct.unknown6C = 0;
AquaSheepStruct.unknown70 = 0;
AquaSheepStruct.unknown74 = 153;
AquaSheepStruct.unknown78 = 6;
AquaSheepStruct.unknown7C = 131;
AquaSheepStruct.unknown80 = 0;
AquaSheepStruct.unknown84 = 100;
AquaSheepStruct.unknown88 = 200;
AquaSheepStruct.unknown8C = 100;
AquaSheepStruct.unknown90 = 0;
AquaSheepStruct.unknown94 = 0;
AquaSheepStruct.unknown98 = 100;
AquaSheepStruct.unknown9C = 5000;
AquaSheepStruct.unknownA0 = 20000;
AquaSheepStruct.unknownA4 = 0;
AquaSheepStruct.unknownA8 = 0;
AquaSheepStruct.unknownAC = 0;
AquaSheepStruct.unknownB0 = 0;
AquaSheepStruct.unknownB4 = 1;
AquaSheepStruct.unknownB8 = 3;
AquaSheepStruct.unknownBC = 4331646;
AquaSheepStruct.unknownC0 = 137342;
AquaSheepStruct.unknownC4 = 100;
AquaSheepStruct.unknownC8 = 4;
AquaSheepStruct.unknownCC = 0;
AquaSheepStruct.unknownD0 = 0;
AquaSheepStruct.unknownD4 = 0;
AquaSheepStruct.unknownD8 = 25;
AquaSheepStruct.unknownDC = 100;
AquaSheepStruct.unknownE0 = 50;
AquaSheepStruct.unknownE4 = -10;
AquaSheepStruct.unknownE8 = 0;
AquaSheepStruct.unknownEC = 0;
AquaSheepStruct.unknownF0 = 0;
AquaSheepStruct.unknownF4 = 156;
AquaSheepStruct.unknownF8 = 157;
AquaSheepStruct.unknownFC = 76;
AquaSheepStruct.unknown100 = 65613;
AquaSheepStruct.unknown104 = 0;
AquaSheepStruct.unknown108 = 0;
AquaSheepStruct.unknown10C = 0;
AquaSheepStruct.unknown110 = 0;
AquaSheepStruct.unknown114 = 0;
AquaSheepStruct.unknown118 = 0;
AquaSheepStruct.unknown11C = 0;
AquaSheepStruct.unknown120 = 0;
AquaSheepStruct.unknown124 = 0;
AquaSheepStruct.unknown128 = 0;
AquaSheepStruct.unknown12C = 0;
AquaSheepStruct.unknown130 = 0;
AquaSheepStruct.unknown134 = 0;
AquaSheepStruct.unknown138 = 0;
AquaSheepStruct.unknown13C = 0;
AquaSheepStruct.unknown140 = 0;
AquaSheepStruct.unknown144 = 0;
AquaSheepStruct.unknown148 = 0;
AquaSheepStruct.unknown14C = 0;
AquaSheepStruct.unknown150 = 0;
AquaSheepStruct.unknown154 = 0;
AquaSheepStruct.unknown158 = 0;
AquaSheepStruct.unknown15C = 0;
AquaSheepStruct.unknown160 = 0;
AquaSheepStruct.unknown164 = 0;
AquaSheepStruct.unknown168 = 0;
AquaSheepStruct.unknown16C = 0;
AquaSheepStruct.unknown170 = 0;
AquaSheepStruct.unknown174 = 0;
AquaSheepStruct.unknown178 = 0;
AquaSheepStruct.unknown17C = 0;
AquaSheepStruct.unknown180 = 0;
AquaSheepStruct.unknown184 = 0;
AquaSheepStruct.unknown188 = 0;
AquaSheepStruct.unknown18C = 0;
AquaSheepStruct.unknown190 = 0;
AquaSheepStruct.unknown194 = 0;
AquaSheepStruct.unknown198 = 0;
AquaSheepStruct.unknown19C = 0;
AquaSheepStruct.unknown1A0 = 0;
AquaSheepStruct.unknown1A4 = 0;
AquaSheepStruct.unknown1A8 = 0;
AquaSheepStruct.unknown1AC = 0;
AquaSheepStruct.unknown1B0 = 0;
AquaSheepStruct.unknown1B4 = 0;
AquaSheepStruct.unknown1B8 = 0;
AquaSheepStruct.unknown1BC = 0;
AquaSheepStruct.unknown1C0 = 0;
AquaSheepStruct.unknown1C4 = 0;
AquaSheepStruct.unknown1C8 = 0;
AquaSheepStruct.unknown1CC = 0;


--ID: 26 Name1: Mole Bomb Name2: Mole Bomb
local MoleBombStruct = WeaponStruct.new()
MoleBombStruct.panelRow = 5;
MoleBombStruct.unknownC = 0;
MoleBombStruct.unknown10 = 0;
MoleBombStruct.unknown14 = 1;
MoleBombStruct.unknown18 = 1;
MoleBombStruct.unknown1C = 3000;
MoleBombStruct.unknown20 = 1;
MoleBombStruct.unknown24 = 20;
MoleBombStruct.unknown28 = 1;
MoleBombStruct.unknown2C = 0;
MoleBombStruct.unknown30 = 3;
MoleBombStruct.unknown34 = 0;
MoleBombStruct.unknown38 = 87;
MoleBombStruct.unknown3C = 5;
MoleBombStruct.unknown40 = 32;
MoleBombStruct.unknown44 = 100;
MoleBombStruct.unknown48 = 52;
MoleBombStruct.unknown4C = 2;
MoleBombStruct.unknown50 = 2;
MoleBombStruct.unknown54 = 5;
MoleBombStruct.unknown58 = 0;
MoleBombStruct.unknown5C = 0;
MoleBombStruct.unknown60 = 0;
MoleBombStruct.unknown64 = 100;
MoleBombStruct.unknown68 = 0;
MoleBombStruct.unknown6C = 0;
MoleBombStruct.unknown70 = 0;
MoleBombStruct.unknown74 = 166;
MoleBombStruct.unknown78 = 6;
MoleBombStruct.unknown7C = 131;
MoleBombStruct.unknown80 = 0;
MoleBombStruct.unknown84 = 100;
MoleBombStruct.unknown88 = 50;
MoleBombStruct.unknown8C = 100;
MoleBombStruct.unknown90 = 0;
MoleBombStruct.unknown94 = 0;
MoleBombStruct.unknown98 = 100;
MoleBombStruct.unknown9C = 5000;
MoleBombStruct.unknownA0 = 10000;
MoleBombStruct.unknownA4 = 65575;
MoleBombStruct.unknownA8 = 0;
MoleBombStruct.unknownAC = 0;
MoleBombStruct.unknownB0 = 0;
MoleBombStruct.unknownB4 = 1;
MoleBombStruct.unknownB8 = 3;
MoleBombStruct.unknownBC = 4331646;
MoleBombStruct.unknownC0 = 4331646;
MoleBombStruct.unknownC4 = 50;
MoleBombStruct.unknownC8 = 8;
MoleBombStruct.unknownCC = 0;
MoleBombStruct.unknownD0 = 0;
MoleBombStruct.unknownD4 = 0;
MoleBombStruct.unknownD8 = 15;
MoleBombStruct.unknownDC = 75;
MoleBombStruct.unknownE0 = 40;
MoleBombStruct.unknownE4 = -4;
MoleBombStruct.unknownE8 = 0;
MoleBombStruct.unknownEC = 0;
MoleBombStruct.unknownF0 = 0;
MoleBombStruct.unknownF4 = 0;
MoleBombStruct.unknownF8 = 0;
MoleBombStruct.unknownFC = 0;
MoleBombStruct.unknown100 = 0;
MoleBombStruct.unknown104 = 1;
MoleBombStruct.unknown108 = 0;
MoleBombStruct.unknown10C = 1;
MoleBombStruct.unknown110 = 0;
MoleBombStruct.unknown114 = 0;
MoleBombStruct.unknown118 = 0;
MoleBombStruct.unknown11C = 0;
MoleBombStruct.unknown120 = 137340;
MoleBombStruct.unknown124 = 0;
MoleBombStruct.unknown128 = 110;
MoleBombStruct.unknown12C = 33;
MoleBombStruct.unknown130 = 0;
MoleBombStruct.unknown134 = 1;
MoleBombStruct.unknown138 = 152;
MoleBombStruct.unknown13C = 6;
MoleBombStruct.unknown140 = 80;
MoleBombStruct.unknown144 = 50;
MoleBombStruct.unknown148 = 50;
MoleBombStruct.unknown14C = 50;
MoleBombStruct.unknown150 = 100;
MoleBombStruct.unknown154 = 0;
MoleBombStruct.unknown158 = 0;
MoleBombStruct.unknown15C = 100;
MoleBombStruct.unknown160 = 5000;
MoleBombStruct.unknown164 = 20000;
MoleBombStruct.unknown168 = 0;
MoleBombStruct.unknown16C = 0;
MoleBombStruct.unknown170 = 0;
MoleBombStruct.unknown174 = 0;
MoleBombStruct.unknown178 = 1;
MoleBombStruct.unknown17C = 4;
MoleBombStruct.unknown180 = 50;
MoleBombStruct.unknown184 = 50;
MoleBombStruct.unknown188 = 65574;
MoleBombStruct.unknown18C = 158;
MoleBombStruct.unknown190 = 159;
MoleBombStruct.unknown194 = 160;
MoleBombStruct.unknown198 = 160;
MoleBombStruct.unknown19C = 0;
MoleBombStruct.unknown1A0 = 0;
MoleBombStruct.unknown1A4 = 0;
MoleBombStruct.unknown1A8 = 0;
MoleBombStruct.unknown1AC = 0;
MoleBombStruct.unknown1B0 = 0;
MoleBombStruct.unknown1B4 = 0;
MoleBombStruct.unknown1B8 = 0;
MoleBombStruct.unknown1BC = 0;
MoleBombStruct.unknown1C0 = 0;
MoleBombStruct.unknown1C4 = 0;
MoleBombStruct.unknown1C8 = 0;
MoleBombStruct.unknown1CC = 0;



--ID: 42 Name1: Super Banana Bomb Name2: Super Banana
local SuperBananaStruct = WeaponStruct.new()
SuperBananaStruct.panelRow = 9;
SuperBananaStruct.unknownC = 0;
SuperBananaStruct.unknown10 = 0;
SuperBananaStruct.unknown14 = 1;
SuperBananaStruct.unknown18 = 1;
SuperBananaStruct.unknown1C = 3000;
SuperBananaStruct.unknown20 = 1;
SuperBananaStruct.unknown24 = 20;
SuperBananaStruct.unknown28 = 1;
SuperBananaStruct.unknown2C = 0;
SuperBananaStruct.unknown30 = 3;
SuperBananaStruct.unknown34 = 0;
SuperBananaStruct.unknown38 = 87;
SuperBananaStruct.unknown3C = 5;
SuperBananaStruct.unknown40 = 32;
SuperBananaStruct.unknown44 = 100;
SuperBananaStruct.unknown48 = 52;
SuperBananaStruct.unknown4C = 2;
SuperBananaStruct.unknown50 = 2;
SuperBananaStruct.unknown54 = 0;
SuperBananaStruct.unknown58 = 0;
SuperBananaStruct.unknown5C = 0;
SuperBananaStruct.unknown60 = 0;
SuperBananaStruct.unknown64 = 100;
SuperBananaStruct.unknown68 = 75;
SuperBananaStruct.unknown6C = 0;
SuperBananaStruct.unknown70 = 0;
SuperBananaStruct.unknown74 = 51;
SuperBananaStruct.unknown78 = 1;
SuperBananaStruct.unknown7C = 131;
SuperBananaStruct.unknown80 = 0;
SuperBananaStruct.unknown84 = 100;
SuperBananaStruct.unknown88 = 50;
SuperBananaStruct.unknown8C = 100;
SuperBananaStruct.unknown90 = 0;
SuperBananaStruct.unknown94 = 0;
SuperBananaStruct.unknown98 = 100;
SuperBananaStruct.unknown9C = 3000;
SuperBananaStruct.unknownA0 = 10000;
SuperBananaStruct.unknownA4 = 0;
SuperBananaStruct.unknownA8 = 0;
SuperBananaStruct.unknownAC = 0;
SuperBananaStruct.unknownB0 = 0;
SuperBananaStruct.unknownB4 = 1;
SuperBananaStruct.unknownB8 = 2;
SuperBananaStruct.unknownBC = 4331646;
SuperBananaStruct.unknownC0 = 60;
SuperBananaStruct.unknownC4 = 100;
SuperBananaStruct.unknownC8 = 111;
SuperBananaStruct.unknownCC = 8;
SuperBananaStruct.unknownD0 = 0;
SuperBananaStruct.unknownD4 = 0;
SuperBananaStruct.unknownD8 = 0;
SuperBananaStruct.unknownDC = 0;
SuperBananaStruct.unknownE0 = 0;
SuperBananaStruct.unknownE4 = 0;
SuperBananaStruct.unknownE8 = 0;
SuperBananaStruct.unknownEC = 0;
SuperBananaStruct.unknownF0 = 0;
SuperBananaStruct.unknownF4 = 0;
SuperBananaStruct.unknownF8 = 0;
SuperBananaStruct.unknownFC = 0;
SuperBananaStruct.unknown100 = 0;
SuperBananaStruct.unknown104 = 1;
SuperBananaStruct.unknown108 = 0;
SuperBananaStruct.unknown10C = 5;
SuperBananaStruct.unknown110 = 45;
SuperBananaStruct.unknown114 = 30;
SuperBananaStruct.unknown118 = 0;
SuperBananaStruct.unknown11C = 25;
SuperBananaStruct.unknown120 = 0;
SuperBananaStruct.unknown124 = 0;
SuperBananaStruct.unknown128 = 100;
SuperBananaStruct.unknown12C = 75;
SuperBananaStruct.unknown130 = 0;
SuperBananaStruct.unknown134 = 1;
SuperBananaStruct.unknown138 = 51;
SuperBananaStruct.unknown13C = 1;
SuperBananaStruct.unknown140 = 131;
SuperBananaStruct.unknown144 = 0;
SuperBananaStruct.unknown148 = 100;
SuperBananaStruct.unknown14C = 50;
SuperBananaStruct.unknown150 = 100;
SuperBananaStruct.unknown154 = 0;
SuperBananaStruct.unknown158 = 0;
SuperBananaStruct.unknown15C = 100;
SuperBananaStruct.unknown160 = 0;
SuperBananaStruct.unknown164 = 9000;
SuperBananaStruct.unknown168 = 0;
SuperBananaStruct.unknown16C = 0;
SuperBananaStruct.unknown170 = 0;
SuperBananaStruct.unknown174 = 0;
SuperBananaStruct.unknown178 = 1;
SuperBananaStruct.unknown17C = 2;
SuperBananaStruct.unknown180 = 4331646;
SuperBananaStruct.unknown184 = 60;
SuperBananaStruct.unknown188 = 100;
SuperBananaStruct.unknown18C = 111;
SuperBananaStruct.unknown190 = 8;
SuperBananaStruct.unknown194 = 0;
SuperBananaStruct.unknown198 = 0;
SuperBananaStruct.unknown19C = 0;
SuperBananaStruct.unknown1A0 = 0;
SuperBananaStruct.unknown1A4 = 0;
SuperBananaStruct.unknown1A8 = 0;
SuperBananaStruct.unknown1AC = 0;
SuperBananaStruct.unknown1B0 = 0;
SuperBananaStruct.unknown1B4 = 0;
SuperBananaStruct.unknown1B8 = 0;
SuperBananaStruct.unknown1BC = 0;
SuperBananaStruct.unknown1C0 = 0;
SuperBananaStruct.unknown1C4 = 0;
SuperBananaStruct.unknown1C8 = 0;
SuperBananaStruct.unknown1CC = 0;

--ID: 43 Name1: Holy Hand-Grenade Name2: Holy Grenade
local HolyGrenadeStruct = WeaponStruct.new()
HolyGrenadeStruct.panelRow = 9;
HolyGrenadeStruct.unknownC = 0;
HolyGrenadeStruct.unknown10 = 0;
HolyGrenadeStruct.unknown14 = 1;
HolyGrenadeStruct.unknown18 = 1;
HolyGrenadeStruct.unknown1C = 3000;
HolyGrenadeStruct.unknown20 = 1;
HolyGrenadeStruct.unknown24 = 20;
HolyGrenadeStruct.unknown28 = 1;
HolyGrenadeStruct.unknown2C = 0;
HolyGrenadeStruct.unknown30 = 3;
HolyGrenadeStruct.unknown34 = 0;
HolyGrenadeStruct.unknown38 = 87;
HolyGrenadeStruct.unknown3C = 5;
HolyGrenadeStruct.unknown40 = 32;
HolyGrenadeStruct.unknown44 = 100;
HolyGrenadeStruct.unknown48 = 52;
HolyGrenadeStruct.unknown4C = 2;
HolyGrenadeStruct.unknown50 = 2;
HolyGrenadeStruct.unknown54 = 0;
HolyGrenadeStruct.unknown58 = 1;
HolyGrenadeStruct.unknown5C = 0;
HolyGrenadeStruct.unknown60 = 75;
HolyGrenadeStruct.unknown64 = 125;
HolyGrenadeStruct.unknown68 = 100;
HolyGrenadeStruct.unknown6C = 0;
HolyGrenadeStruct.unknown70 = 0;
HolyGrenadeStruct.unknown74 = 56;
HolyGrenadeStruct.unknown78 = 1;
HolyGrenadeStruct.unknown7C = 131;
HolyGrenadeStruct.unknown80 = 0;
HolyGrenadeStruct.unknown84 = 100;
HolyGrenadeStruct.unknown88 = 50;
HolyGrenadeStruct.unknown8C = 100;
HolyGrenadeStruct.unknown90 = 0;
HolyGrenadeStruct.unknown94 = 0;
HolyGrenadeStruct.unknown98 = 100;
HolyGrenadeStruct.unknown9C = 3000;
HolyGrenadeStruct.unknownA0 = 3000;
HolyGrenadeStruct.unknownA4 = 0;
HolyGrenadeStruct.unknownA8 = 1;
HolyGrenadeStruct.unknownAC = 104;
HolyGrenadeStruct.unknownB0 = 1800;
HolyGrenadeStruct.unknownB4 = 0;
HolyGrenadeStruct.unknownB8 = 2;
HolyGrenadeStruct.unknownBC = 1078073438;
HolyGrenadeStruct.unknownC0 = 30;
HolyGrenadeStruct.unknownC4 = 100;
HolyGrenadeStruct.unknownC8 = 105;
HolyGrenadeStruct.unknownCC = 8;
HolyGrenadeStruct.unknownD0 = 0;
HolyGrenadeStruct.unknownD4 = 0;
HolyGrenadeStruct.unknownD8 = 0;
HolyGrenadeStruct.unknownDC = 0;
HolyGrenadeStruct.unknownE0 = 0;
HolyGrenadeStruct.unknownE4 = 0;
HolyGrenadeStruct.unknownE8 = 0;
HolyGrenadeStruct.unknownEC = 0;
HolyGrenadeStruct.unknownF0 = 0;
HolyGrenadeStruct.unknownF4 = 0;
HolyGrenadeStruct.unknownF8 = 0;
HolyGrenadeStruct.unknownFC = 0;
HolyGrenadeStruct.unknown100 = 0;
HolyGrenadeStruct.unknown104 = 0;
HolyGrenadeStruct.unknown108 = 0;
HolyGrenadeStruct.unknown10C = 0;
HolyGrenadeStruct.unknown110 = 0;
HolyGrenadeStruct.unknown114 = 0;
HolyGrenadeStruct.unknown118 = 0;
HolyGrenadeStruct.unknown11C = 0;
HolyGrenadeStruct.unknown120 = 0;
HolyGrenadeStruct.unknown124 = 0;
HolyGrenadeStruct.unknown128 = 0;
HolyGrenadeStruct.unknown12C = 0;
HolyGrenadeStruct.unknown130 = 0;
HolyGrenadeStruct.unknown134 = 0;
HolyGrenadeStruct.unknown138 = 0;
HolyGrenadeStruct.unknown13C = 0;
HolyGrenadeStruct.unknown140 = 0;
HolyGrenadeStruct.unknown144 = 0;
HolyGrenadeStruct.unknown148 = 0;
HolyGrenadeStruct.unknown14C = 0;
HolyGrenadeStruct.unknown150 = 0;
HolyGrenadeStruct.unknown154 = 0;
HolyGrenadeStruct.unknown158 = 0;
HolyGrenadeStruct.unknown15C = 0;
HolyGrenadeStruct.unknown160 = 0;
HolyGrenadeStruct.unknown164 = 0;
HolyGrenadeStruct.unknown168 = 0;
HolyGrenadeStruct.unknown16C = 0;
HolyGrenadeStruct.unknown170 = 0;
HolyGrenadeStruct.unknown174 = 0;
HolyGrenadeStruct.unknown178 = 0;
HolyGrenadeStruct.unknown17C = 0;
HolyGrenadeStruct.unknown180 = 0;
HolyGrenadeStruct.unknown184 = 0;
HolyGrenadeStruct.unknown188 = 0;
HolyGrenadeStruct.unknown18C = 0;
HolyGrenadeStruct.unknown190 = 0;
HolyGrenadeStruct.unknown194 = 0;
HolyGrenadeStruct.unknown198 = 0;
HolyGrenadeStruct.unknown19C = 0;
HolyGrenadeStruct.unknown1A0 = 0;
HolyGrenadeStruct.unknown1A4 = 0;
HolyGrenadeStruct.unknown1A8 = 0;
HolyGrenadeStruct.unknown1AC = 0;
HolyGrenadeStruct.unknown1B0 = 0;
HolyGrenadeStruct.unknown1B4 = 0;
HolyGrenadeStruct.unknown1B8 = 0;
HolyGrenadeStruct.unknown1BC = 0;
HolyGrenadeStruct.unknown1C0 = 0;
HolyGrenadeStruct.unknown1C4 = 0;
HolyGrenadeStruct.unknown1C8 = 0;
HolyGrenadeStruct.unknown1CC = 0;



--ID: 45 Name1: Salvation Army Name2: Salvation Army
local SalvationArmyStruct = WeaponStruct.new()
SalvationArmyStruct.panelRow = 9;
SalvationArmyStruct.unknownC = 0;
SalvationArmyStruct.unknown10 = 0;
SalvationArmyStruct.unknown14 = 1;
SalvationArmyStruct.unknown18 = 1;
SalvationArmyStruct.unknown1C = 3000;
SalvationArmyStruct.unknown20 = 1;
SalvationArmyStruct.unknown24 = 20;
SalvationArmyStruct.unknown28 = 1;
SalvationArmyStruct.unknown2C = 0;
SalvationArmyStruct.unknown30 = 3;
SalvationArmyStruct.unknown34 = 0;
SalvationArmyStruct.unknown38 = 87;
SalvationArmyStruct.unknown3C = 5;
SalvationArmyStruct.unknown40 = 32;
SalvationArmyStruct.unknown44 = 100;
SalvationArmyStruct.unknown48 = 52;
SalvationArmyStruct.unknown4C = 2;
SalvationArmyStruct.unknown50 = 2;
SalvationArmyStruct.unknown54 = 5;
SalvationArmyStruct.unknown58 = 0;
SalvationArmyStruct.unknown5C = 0;
SalvationArmyStruct.unknown60 = 0;
SalvationArmyStruct.unknown64 = 100;
SalvationArmyStruct.unknown68 = 75;
SalvationArmyStruct.unknown6C = 0;
SalvationArmyStruct.unknown70 = 0;
SalvationArmyStruct.unknown74 = 163;
SalvationArmyStruct.unknown78 = 6;
SalvationArmyStruct.unknown7C = 131;
SalvationArmyStruct.unknown80 = 0;
SalvationArmyStruct.unknown84 = 100;
SalvationArmyStruct.unknown88 = 50;
SalvationArmyStruct.unknown8C = 100;
SalvationArmyStruct.unknown90 = 0;
SalvationArmyStruct.unknown94 = 0;
SalvationArmyStruct.unknown98 = 100;
SalvationArmyStruct.unknown9C = 5000;
SalvationArmyStruct.unknownA0 = 10000;
SalvationArmyStruct.unknownA4 = 65597;
SalvationArmyStruct.unknownA8 = 0;
SalvationArmyStruct.unknownAC = 0;
SalvationArmyStruct.unknownB0 = 0;
SalvationArmyStruct.unknownB4 = 1;
SalvationArmyStruct.unknownB8 = 3;
SalvationArmyStruct.unknownBC = 4331646;
SalvationArmyStruct.unknownC0 = 4331646;
SalvationArmyStruct.unknownC4 = 33;
SalvationArmyStruct.unknownC8 = 4;
SalvationArmyStruct.unknownCC = 45;
SalvationArmyStruct.unknownD0 = 25;
SalvationArmyStruct.unknownD4 = 0;
SalvationArmyStruct.unknownD8 = 0;
SalvationArmyStruct.unknownDC = 100;
SalvationArmyStruct.unknownE0 = 50;
SalvationArmyStruct.unknownE4 = -8;
SalvationArmyStruct.unknownE8 = 0;
SalvationArmyStruct.unknownEC = 0;
SalvationArmyStruct.unknownF0 = 0;
SalvationArmyStruct.unknownF4 = 0;
SalvationArmyStruct.unknownF8 = 0;
SalvationArmyStruct.unknownFC = 0;
SalvationArmyStruct.unknown100 = 0;
SalvationArmyStruct.unknown104 = 1;
SalvationArmyStruct.unknown108 = 0;
SalvationArmyStruct.unknown10C = 5;
SalvationArmyStruct.unknown110 = 35;
SalvationArmyStruct.unknown114 = 50;
SalvationArmyStruct.unknown118 = 0;
SalvationArmyStruct.unknown11C = 60;
SalvationArmyStruct.unknown120 = 137342;
SalvationArmyStruct.unknown124 = 0;
SalvationArmyStruct.unknown128 = 100;
SalvationArmyStruct.unknown12C = 60;
SalvationArmyStruct.unknown130 = 0;
SalvationArmyStruct.unknown134 = 1;
SalvationArmyStruct.unknown138 = 57;
SalvationArmyStruct.unknown13C = 1;
SalvationArmyStruct.unknown140 = 131;
SalvationArmyStruct.unknown144 = 0;
SalvationArmyStruct.unknown148 = 100;
SalvationArmyStruct.unknown14C = 50;
SalvationArmyStruct.unknown150 = 100;
SalvationArmyStruct.unknown154 = 0;
SalvationArmyStruct.unknown158 = 0;
SalvationArmyStruct.unknown15C = 100;
SalvationArmyStruct.unknown160 = 0;
SalvationArmyStruct.unknown164 = 10000;
SalvationArmyStruct.unknown168 = 0;
SalvationArmyStruct.unknown16C = 0;
SalvationArmyStruct.unknown170 = 0;
SalvationArmyStruct.unknown174 = 1800;
SalvationArmyStruct.unknown178 = 0;
SalvationArmyStruct.unknown17C = 2;
SalvationArmyStruct.unknown180 = 4194304;
SalvationArmyStruct.unknown184 = 1;
SalvationArmyStruct.unknown188 = 0;
SalvationArmyStruct.unknown18C = 0;
SalvationArmyStruct.unknown190 = 8;
SalvationArmyStruct.unknown194 = 0;
SalvationArmyStruct.unknown198 = 0;
SalvationArmyStruct.unknown19C = 0;
SalvationArmyStruct.unknown1A0 = 0;
SalvationArmyStruct.unknown1A4 = 0;
SalvationArmyStruct.unknown1A8 = 0;
SalvationArmyStruct.unknown1AC = 0;
SalvationArmyStruct.unknown1B0 = 0;
SalvationArmyStruct.unknown1B4 = 0;
SalvationArmyStruct.unknown1B8 = 0;
SalvationArmyStruct.unknown1BC = 0;
SalvationArmyStruct.unknown1C0 = 0;
SalvationArmyStruct.unknown1C4 = 0;
SalvationArmyStruct.unknown1C8 = 0;
SalvationArmyStruct.unknown1CC = 0;


--ID: 47 Name1: Petrol Bomb Name2: Petrol Bomb
local PetrolBombStruct = WeaponStruct.new()
PetrolBombStruct.panelRow = 10;
PetrolBombStruct.unknownC = 0;
PetrolBombStruct.unknown10 = 0;
PetrolBombStruct.unknown14 = 1;
PetrolBombStruct.unknown18 = 1;
PetrolBombStruct.unknown1C = 3000;
PetrolBombStruct.unknown20 = 1;
PetrolBombStruct.unknown24 = 20;
PetrolBombStruct.unknown28 = 1;
PetrolBombStruct.unknown2C = 0;
PetrolBombStruct.unknown30 = 3;
PetrolBombStruct.unknown34 = 0;
PetrolBombStruct.unknown38 = 87;
PetrolBombStruct.unknown3C = 5;
PetrolBombStruct.unknown40 = 32;
PetrolBombStruct.unknown44 = 100;
PetrolBombStruct.unknown48 = 52;
PetrolBombStruct.unknown4C = 2;
PetrolBombStruct.unknown50 = 2;
PetrolBombStruct.unknown54 = 0;
PetrolBombStruct.unknown58 = 1;
PetrolBombStruct.unknown5C = 137342;
PetrolBombStruct.unknown60 = 0;
PetrolBombStruct.unknown64 = 75;
PetrolBombStruct.unknown68 = 15;
PetrolBombStruct.unknown6C = 0;
PetrolBombStruct.unknown70 = 0;
PetrolBombStruct.unknown74 = 55;
PetrolBombStruct.unknown78 = 1;
PetrolBombStruct.unknown7C = 131;
PetrolBombStruct.unknown80 = 0;
PetrolBombStruct.unknown84 = 100;
PetrolBombStruct.unknown88 = 50;
PetrolBombStruct.unknown8C = 100;
PetrolBombStruct.unknown90 = 0;
PetrolBombStruct.unknown94 = 0;
PetrolBombStruct.unknown98 = 100;
PetrolBombStruct.unknown9C = 0;
PetrolBombStruct.unknownA0 = 9000;
PetrolBombStruct.unknownA4 = 0;
PetrolBombStruct.unknownA8 = 0;
PetrolBombStruct.unknownAC = 0;
PetrolBombStruct.unknownB0 = 0;
PetrolBombStruct.unknownB4 = 0;
PetrolBombStruct.unknownB8 = 2;
PetrolBombStruct.unknownBC = 4194304;
PetrolBombStruct.unknownC0 = 1;
PetrolBombStruct.unknownC4 = 100;
PetrolBombStruct.unknownC8 = 113;
PetrolBombStruct.unknownCC = 8;
PetrolBombStruct.unknownD0 = 0;
PetrolBombStruct.unknownD4 = 0;
PetrolBombStruct.unknownD8 = 0;
PetrolBombStruct.unknownDC = 0;
PetrolBombStruct.unknownE0 = 0;
PetrolBombStruct.unknownE4 = 0;
PetrolBombStruct.unknownE8 = 0;
PetrolBombStruct.unknownEC = 0;
PetrolBombStruct.unknownF0 = 0;
PetrolBombStruct.unknownF4 = 0;
PetrolBombStruct.unknownF8 = 0;
PetrolBombStruct.unknownFC = 0;
PetrolBombStruct.unknown100 = 0;
PetrolBombStruct.unknown104 = 2;
PetrolBombStruct.unknown108 = 0;
PetrolBombStruct.unknown10C = 40;
PetrolBombStruct.unknown110 = 100;
PetrolBombStruct.unknown114 = 4000;
PetrolBombStruct.unknown118 = 1;
PetrolBombStruct.unknown11C = 0;
PetrolBombStruct.unknown120 = 0;
PetrolBombStruct.unknown124 = 0;
PetrolBombStruct.unknown128 = 0;
PetrolBombStruct.unknown12C = 0;
PetrolBombStruct.unknown130 = 0;
PetrolBombStruct.unknown134 = 0;
PetrolBombStruct.unknown138 = 0;
PetrolBombStruct.unknown13C = 0;
PetrolBombStruct.unknown140 = 0;
PetrolBombStruct.unknown144 = 0;
PetrolBombStruct.unknown148 = 0;
PetrolBombStruct.unknown14C = 0;
PetrolBombStruct.unknown150 = 0;
PetrolBombStruct.unknown154 = 0;
PetrolBombStruct.unknown158 = 0;
PetrolBombStruct.unknown15C = 0;
PetrolBombStruct.unknown160 = 0;
PetrolBombStruct.unknown164 = 0;
PetrolBombStruct.unknown168 = 0;
PetrolBombStruct.unknown16C = 0;
PetrolBombStruct.unknown170 = 0;
PetrolBombStruct.unknown174 = 0;
PetrolBombStruct.unknown178 = 0;
PetrolBombStruct.unknown17C = 0;
PetrolBombStruct.unknown180 = 0;
PetrolBombStruct.unknown184 = 0;
PetrolBombStruct.unknown188 = 0;
PetrolBombStruct.unknown18C = 0;
PetrolBombStruct.unknown190 = 0;
PetrolBombStruct.unknown194 = 0;
PetrolBombStruct.unknown198 = 0;
PetrolBombStruct.unknown19C = 0;
PetrolBombStruct.unknown1A0 = 0;
PetrolBombStruct.unknown1A4 = 0;
PetrolBombStruct.unknown1A8 = 0;
PetrolBombStruct.unknown1AC = 0;
PetrolBombStruct.unknown1B0 = 0;
PetrolBombStruct.unknown1B4 = 0;
PetrolBombStruct.unknown1B8 = 0;
PetrolBombStruct.unknown1BC = 0;
PetrolBombStruct.unknown1C0 = 0;
PetrolBombStruct.unknown1C4 = 0;
PetrolBombStruct.unknown1C8 = 0;
PetrolBombStruct.unknown1CC = 0;


--ID: 48 Name1: Skunk Name2: Skunk
local SkunkStruct = WeaponStruct.new()
SkunkStruct.panelRow = 10;
SkunkStruct.unknownC = 0;
SkunkStruct.unknown10 = 0;
SkunkStruct.unknown14 = 1;
SkunkStruct.unknown18 = 1;
SkunkStruct.unknown1C = 3000;
SkunkStruct.unknown20 = 1;
SkunkStruct.unknown24 = 20;
SkunkStruct.unknown28 = 1;
SkunkStruct.unknown2C = 0;
SkunkStruct.unknown30 = 3;
SkunkStruct.unknown34 = 0;
SkunkStruct.unknown38 = 87;
SkunkStruct.unknown3C = 5;
SkunkStruct.unknown40 = 32;
SkunkStruct.unknown44 = 100;
SkunkStruct.unknown48 = 52;
SkunkStruct.unknown4C = 2;
SkunkStruct.unknown50 = 2;
SkunkStruct.unknown54 = 5;
SkunkStruct.unknown58 = 0;
SkunkStruct.unknown5C = 0;
SkunkStruct.unknown60 = 0;
SkunkStruct.unknown64 = 100;
SkunkStruct.unknown68 = 0;
SkunkStruct.unknown6C = 0;
SkunkStruct.unknown70 = 0;
SkunkStruct.unknown74 = 173;
SkunkStruct.unknown78 = 6;
SkunkStruct.unknown7C = 131;
SkunkStruct.unknown80 = 0;
SkunkStruct.unknown84 = 100;
SkunkStruct.unknown88 = 50;
SkunkStruct.unknown8C = 100;
SkunkStruct.unknown90 = 0;
SkunkStruct.unknown94 = 0;
SkunkStruct.unknown98 = 100;
SkunkStruct.unknown9C = 5000;
SkunkStruct.unknownA0 = 5000;
SkunkStruct.unknownA4 = 65578;
SkunkStruct.unknownA8 = 0;
SkunkStruct.unknownAC = 0;
SkunkStruct.unknownB0 = 0;
SkunkStruct.unknownB4 = 1;
SkunkStruct.unknownB8 = 3;
SkunkStruct.unknownBC = 4331646;
SkunkStruct.unknownC0 = 4331646;
SkunkStruct.unknownC4 = 100;
SkunkStruct.unknownC8 = 4;
SkunkStruct.unknownCC = 0;
SkunkStruct.unknownD0 = 0;
SkunkStruct.unknownD4 = 0;
SkunkStruct.unknownD8 = 15;
SkunkStruct.unknownDC = 100;
SkunkStruct.unknownE0 = 43;
SkunkStruct.unknownE4 = -4;
SkunkStruct.unknownE8 = 0;
SkunkStruct.unknownEC = 0;
SkunkStruct.unknownF0 = 0;
SkunkStruct.unknownF4 = 0;
SkunkStruct.unknownF8 = 0;
SkunkStruct.unknownFC = 0;
SkunkStruct.unknown100 = 0;
SkunkStruct.unknown104 = 1;
SkunkStruct.unknown108 = 0;
SkunkStruct.unknown10C = 1;
SkunkStruct.unknown110 = 0;
SkunkStruct.unknown114 = 0;
SkunkStruct.unknown118 = 0;
SkunkStruct.unknown11C = 0;
SkunkStruct.unknown120 = 0;
SkunkStruct.unknown124 = 0;
SkunkStruct.unknown128 = 100;
SkunkStruct.unknown12C = 30;
SkunkStruct.unknown130 = 0;
SkunkStruct.unknown134 = 1;
SkunkStruct.unknown138 = 173;
SkunkStruct.unknown13C = 6;
SkunkStruct.unknown140 = 131;
SkunkStruct.unknown144 = 0;
SkunkStruct.unknown148 = 100;
SkunkStruct.unknown14C = 50;
SkunkStruct.unknown150 = 100;
SkunkStruct.unknown154 = 0;
SkunkStruct.unknown158 = 0;
SkunkStruct.unknown15C = 100;
SkunkStruct.unknown160 = 5000;
SkunkStruct.unknown164 = 10000;
SkunkStruct.unknown168 = 65577;
SkunkStruct.unknown16C = 0;
SkunkStruct.unknown170 = 0;
SkunkStruct.unknown174 = 0;
SkunkStruct.unknown178 = 1;
SkunkStruct.unknown17C = 3;
SkunkStruct.unknown180 = 4331646;
SkunkStruct.unknown184 = 4331646;
SkunkStruct.unknown188 = 100;
SkunkStruct.unknown18C = 4;
SkunkStruct.unknown190 = 0;
SkunkStruct.unknown194 = 0;
SkunkStruct.unknown198 = 0;
SkunkStruct.unknown19C = 15;
SkunkStruct.unknown1A0 = 100;
SkunkStruct.unknown1A4 = 43;
SkunkStruct.unknown1A8 = -4;
SkunkStruct.unknown1AC = 1;
SkunkStruct.unknown1B0 = 5;
SkunkStruct.unknown1B4 = 174;
SkunkStruct.unknown1B8 = 0;
SkunkStruct.unknown1BC = 0;
SkunkStruct.unknown1C0 = 0;
SkunkStruct.unknown1C4 = 0;
SkunkStruct.unknown1C8 = 0;
SkunkStruct.unknown1CC = 0;

--ID: 49 Name1: Priceless Ming Vase Name2: Ming Vase
local MingVaseStruct = WeaponStruct.new()
MingVaseStruct.panelRow = 10;
MingVaseStruct.unknownC = 0;
MingVaseStruct.unknown10 = 0;
MingVaseStruct.unknown14 = 1;
MingVaseStruct.unknown18 = 1;
MingVaseStruct.unknown1C = 3000;
MingVaseStruct.unknown20 = 1;
MingVaseStruct.unknown24 = 20;
MingVaseStruct.unknown28 = 1;
MingVaseStruct.unknown2C = 0;
MingVaseStruct.unknown30 = 3;
MingVaseStruct.unknown34 = 0;
MingVaseStruct.unknown38 = 87;
MingVaseStruct.unknown3C = 5;
MingVaseStruct.unknown40 = 32;
MingVaseStruct.unknown44 = 100;
MingVaseStruct.unknown48 = 52;
MingVaseStruct.unknown4C = 2;
MingVaseStruct.unknown50 = 2;
MingVaseStruct.unknown54 = 5;
MingVaseStruct.unknown58 = 1;
MingVaseStruct.unknown5C = 0;
MingVaseStruct.unknown60 = 50;
MingVaseStruct.unknown64 = 100;
MingVaseStruct.unknown68 = 75;
MingVaseStruct.unknown6C = 0;
MingVaseStruct.unknown70 = 0;
MingVaseStruct.unknown74 = 74;
MingVaseStruct.unknown78 = 0;
MingVaseStruct.unknown7C = 131;
MingVaseStruct.unknown80 = 0;
MingVaseStruct.unknown84 = 100;
MingVaseStruct.unknown88 = 50;
MingVaseStruct.unknown8C = 100;
MingVaseStruct.unknown90 = 0;
MingVaseStruct.unknown94 = 0;
MingVaseStruct.unknown98 = 100;
MingVaseStruct.unknown9C = 5000;
MingVaseStruct.unknownA0 = 5000;
MingVaseStruct.unknownA4 = 0;
MingVaseStruct.unknownA8 = 0;
MingVaseStruct.unknownAC = 0;
MingVaseStruct.unknownB0 = 0;
MingVaseStruct.unknownB4 = 0;
MingVaseStruct.unknownB8 = 2;
MingVaseStruct.unknownBC = 4331614;
MingVaseStruct.unknownC0 = 30;
MingVaseStruct.unknownC4 = 0;
MingVaseStruct.unknownC8 = 113;
MingVaseStruct.unknownCC = 8;
MingVaseStruct.unknownD0 = 0;
MingVaseStruct.unknownD4 = 0;
MingVaseStruct.unknownD8 = 0;
MingVaseStruct.unknownDC = 0;
MingVaseStruct.unknownE0 = 0;
MingVaseStruct.unknownE4 = 0;
MingVaseStruct.unknownE8 = 0;
MingVaseStruct.unknownEC = 0;
MingVaseStruct.unknownF0 = 0;
MingVaseStruct.unknownF4 = 0;
MingVaseStruct.unknownF8 = 0;
MingVaseStruct.unknownFC = 0;
MingVaseStruct.unknown100 = 0;
MingVaseStruct.unknown104 = 1;
MingVaseStruct.unknown108 = 0;
MingVaseStruct.unknown10C = 3;
MingVaseStruct.unknown110 = 40;
MingVaseStruct.unknown114 = 30;
MingVaseStruct.unknown118 = 0;
MingVaseStruct.unknown11C = 25;
MingVaseStruct.unknown120 = 137342;
MingVaseStruct.unknown124 = 50;
MingVaseStruct.unknown128 = 100;
MingVaseStruct.unknown12C = 75;
MingVaseStruct.unknown130 = 0;
MingVaseStruct.unknown134 = 3;
MingVaseStruct.unknown138 = 75;
MingVaseStruct.unknown13C = 5;
MingVaseStruct.unknown140 = 132;
MingVaseStruct.unknown144 = 0;
MingVaseStruct.unknown148 = 100;
MingVaseStruct.unknown14C = 50;
MingVaseStruct.unknown150 = 100;
MingVaseStruct.unknown154 = 0;
MingVaseStruct.unknown158 = 0;
MingVaseStruct.unknown15C = 100;
MingVaseStruct.unknown160 = 0;
MingVaseStruct.unknown164 = 9000;
MingVaseStruct.unknown168 = 0;
MingVaseStruct.unknown16C = 0;
MingVaseStruct.unknown170 = 0;
MingVaseStruct.unknown174 = 0;
MingVaseStruct.unknown178 = 0;
MingVaseStruct.unknown17C = 2;
MingVaseStruct.unknown180 = 4331614;
MingVaseStruct.unknown184 = 30;
MingVaseStruct.unknown188 = 0;
MingVaseStruct.unknown18C = 113;
MingVaseStruct.unknown190 = 8;
MingVaseStruct.unknown194 = 0;
MingVaseStruct.unknown198 = 0;
MingVaseStruct.unknown19C = 0;
MingVaseStruct.unknown1A0 = 0;
MingVaseStruct.unknown1A4 = 0;
MingVaseStruct.unknown1A8 = 0;
MingVaseStruct.unknown1AC = 0;
MingVaseStruct.unknown1B0 = 0;
MingVaseStruct.unknown1B4 = 0;
MingVaseStruct.unknown1B8 = 0;
MingVaseStruct.unknown1BC = 0;
MingVaseStruct.unknown1C0 = 0;
MingVaseStruct.unknown1C4 = 0;
MingVaseStruct.unknown1C8 = 0;
MingVaseStruct.unknown1CC = 0;


--ID: 52 Name1: Mad Cow Name2: Mad Cow
local MadCowStruct = WeaponStruct.new()
MadCowStruct.panelRow = 11;
MadCowStruct.unknownC = 0;
MadCowStruct.unknown10 = 0;
MadCowStruct.unknown14 = 1;
MadCowStruct.unknown18 = 1;
MadCowStruct.unknown1C = 3000;
MadCowStruct.unknown20 = 1;
MadCowStruct.unknown24 = 20;
MadCowStruct.unknown28 = 1;
MadCowStruct.unknown2C = 0;
MadCowStruct.unknown30 = 3;
MadCowStruct.unknown34 = 0;
MadCowStruct.unknown38 = 87;
MadCowStruct.unknown3C = 5;
MadCowStruct.unknown40 = 32;
MadCowStruct.unknown44 = 100;
MadCowStruct.unknown48 = 52;
MadCowStruct.unknown4C = 2;
MadCowStruct.unknown50 = 2;
MadCowStruct.unknown54 = 5;
MadCowStruct.unknown58 = 0;
MadCowStruct.unknown5C = 0;
MadCowStruct.unknown60 = 50;
MadCowStruct.unknown64 = 100;
MadCowStruct.unknown68 = 75;
MadCowStruct.unknown6C = 0;
MadCowStruct.unknown70 = 0;
MadCowStruct.unknown74 = 164;
MadCowStruct.unknown78 = 6;
MadCowStruct.unknown7C = 131;
MadCowStruct.unknown80 = 0;
MadCowStruct.unknown84 = 100;
MadCowStruct.unknown88 = 50;
MadCowStruct.unknown8C = 100;
MadCowStruct.unknown90 = 0;
MadCowStruct.unknown94 = 0;
MadCowStruct.unknown98 = 100;
MadCowStruct.unknown9C = 5000;
MadCowStruct.unknownA0 = 10000;
MadCowStruct.unknownA4 = 0;
MadCowStruct.unknownA8 = 0;
MadCowStruct.unknownAC = 0;
MadCowStruct.unknownB0 = 0;
MadCowStruct.unknownB4 = 0;
MadCowStruct.unknownB8 = 3;
MadCowStruct.unknownBC = 4331646;
MadCowStruct.unknownC0 = 4331646;
MadCowStruct.unknownC4 = 100;
MadCowStruct.unknownC8 = 4;
MadCowStruct.unknownCC = 45;
MadCowStruct.unknownD0 = 25;
MadCowStruct.unknownD4 = 49;
MadCowStruct.unknownD8 = -1;
MadCowStruct.unknownDC = 100;
MadCowStruct.unknownE0 = 50;
MadCowStruct.unknownE4 = -10;
MadCowStruct.unknownE8 = 0;
MadCowStruct.unknownEC = 0;
MadCowStruct.unknownF0 = 0;
MadCowStruct.unknownF4 = 0;
MadCowStruct.unknownF8 = 0;
MadCowStruct.unknownFC = 0;
MadCowStruct.unknown100 = 0;
MadCowStruct.unknown104 = 0;
MadCowStruct.unknown108 = 0;
MadCowStruct.unknown10C = 0;
MadCowStruct.unknown110 = 0;
MadCowStruct.unknown114 = 0;
MadCowStruct.unknown118 = 0;
MadCowStruct.unknown11C = 0;
MadCowStruct.unknown120 = 0;
MadCowStruct.unknown124 = 0;
MadCowStruct.unknown128 = 0;
MadCowStruct.unknown12C = 0;
MadCowStruct.unknown130 = 0;
MadCowStruct.unknown134 = 0;
MadCowStruct.unknown138 = 0;
MadCowStruct.unknown13C = 0;
MadCowStruct.unknown140 = 0;
MadCowStruct.unknown144 = 0;
MadCowStruct.unknown148 = 0;
MadCowStruct.unknown14C = 0;
MadCowStruct.unknown150 = 0;
MadCowStruct.unknown154 = 0;
MadCowStruct.unknown158 = 0;
MadCowStruct.unknown15C = 0;
MadCowStruct.unknown160 = 0;
MadCowStruct.unknown164 = 0;
MadCowStruct.unknown168 = 0;
MadCowStruct.unknown16C = 0;
MadCowStruct.unknown170 = 0;
MadCowStruct.unknown174 = 0;
MadCowStruct.unknown178 = 0;
MadCowStruct.unknown17C = 0;
MadCowStruct.unknown180 = 0;
MadCowStruct.unknown184 = 0;
MadCowStruct.unknown188 = 0;
MadCowStruct.unknown18C = 0;
MadCowStruct.unknown190 = 0;
MadCowStruct.unknown194 = 0;
MadCowStruct.unknown198 = 0;
MadCowStruct.unknown19C = 0;
MadCowStruct.unknown1A0 = 0;
MadCowStruct.unknown1A4 = 0;
MadCowStruct.unknown1A8 = 0;
MadCowStruct.unknown1AC = 0;
MadCowStruct.unknown1B0 = 0;
MadCowStruct.unknown1B4 = 0;
MadCowStruct.unknown1B8 = 0;
MadCowStruct.unknown1BC = 0;
MadCowStruct.unknown1C0 = 0;
MadCowStruct.unknown1C4 = 0;
MadCowStruct.unknown1C8 = 0;
MadCowStruct.unknown1CC = 0;


--ID: 53 Name1: Old Woman Name2: Old Woman
local OldWomanStruct = WeaponStruct.new()
OldWomanStruct.panelRow = 11;
OldWomanStruct.unknownC = 0;
OldWomanStruct.unknown10 = 0;
OldWomanStruct.unknown14 = 1;
OldWomanStruct.unknown18 = 1;
OldWomanStruct.unknown1C = 3000;
OldWomanStruct.unknown20 = 1;
OldWomanStruct.unknown24 = 20;
OldWomanStruct.unknown28 = 1;
OldWomanStruct.unknown2C = 0;
OldWomanStruct.unknown30 = 3;
OldWomanStruct.unknown34 = 0;
OldWomanStruct.unknown38 = 87;
OldWomanStruct.unknown3C = 5;
OldWomanStruct.unknown40 = 32;
OldWomanStruct.unknown44 = 100;
OldWomanStruct.unknown48 = 52;
OldWomanStruct.unknown4C = 2;
OldWomanStruct.unknown50 = 2;
OldWomanStruct.unknown54 = 5;
OldWomanStruct.unknown58 = 0;
OldWomanStruct.unknown5C = 0;
OldWomanStruct.unknown60 = 50;
OldWomanStruct.unknown64 = 100;
OldWomanStruct.unknown68 = 75;
OldWomanStruct.unknown6C = 0;
OldWomanStruct.unknown70 = 0;
OldWomanStruct.unknown74 = 162;
OldWomanStruct.unknown78 = 6;
OldWomanStruct.unknown7C = 131;
OldWomanStruct.unknown80 = 0;
OldWomanStruct.unknown84 = 100;
OldWomanStruct.unknown88 = 50;
OldWomanStruct.unknown8C = 100;
OldWomanStruct.unknown90 = 0;
OldWomanStruct.unknown94 = 0;
OldWomanStruct.unknown98 = 100;
OldWomanStruct.unknown9C = 5000;
OldWomanStruct.unknownA0 = 5000;
OldWomanStruct.unknownA4 = 65601;
OldWomanStruct.unknownA8 = 0;
OldWomanStruct.unknownAC = 0;
OldWomanStruct.unknownB0 = 0;
OldWomanStruct.unknownB4 = 0;
OldWomanStruct.unknownB8 = 3;
OldWomanStruct.unknownBC = 4331646;
OldWomanStruct.unknownC0 = 4331646;
OldWomanStruct.unknownC4 = 33;
OldWomanStruct.unknownC8 = 4;
OldWomanStruct.unknownCC = 45;
OldWomanStruct.unknownD0 = 25;
OldWomanStruct.unknownD4 = 0;
OldWomanStruct.unknownD8 = 0;
OldWomanStruct.unknownDC = 100;
OldWomanStruct.unknownE0 = 50;
OldWomanStruct.unknownE4 = 0;
OldWomanStruct.unknownE8 = 0;
OldWomanStruct.unknownEC = 0;
OldWomanStruct.unknownF0 = 0;
OldWomanStruct.unknownF4 = 0;
OldWomanStruct.unknownF8 = 0;
OldWomanStruct.unknownFC = 0;
OldWomanStruct.unknown100 = 0;
OldWomanStruct.unknown104 = 0;
OldWomanStruct.unknown108 = 0;
OldWomanStruct.unknown10C = 0;
OldWomanStruct.unknown110 = 0;
OldWomanStruct.unknown114 = 0;
OldWomanStruct.unknown118 = 0;
OldWomanStruct.unknown11C = 0;
OldWomanStruct.unknown120 = 0;
OldWomanStruct.unknown124 = 0;
OldWomanStruct.unknown128 = 0;
OldWomanStruct.unknown12C = 0;
OldWomanStruct.unknown130 = 0;
OldWomanStruct.unknown134 = 0;
OldWomanStruct.unknown138 = 0;
OldWomanStruct.unknown13C = 0;
OldWomanStruct.unknown140 = 0;
OldWomanStruct.unknown144 = 0;
OldWomanStruct.unknown148 = 0;
OldWomanStruct.unknown14C = 0;
OldWomanStruct.unknown150 = 0;
OldWomanStruct.unknown154 = 0;
OldWomanStruct.unknown158 = 0;
OldWomanStruct.unknown15C = 0;
OldWomanStruct.unknown160 = 0;
OldWomanStruct.unknown164 = 0;
OldWomanStruct.unknown168 = 0;
OldWomanStruct.unknown16C = 0;
OldWomanStruct.unknown170 = 0;
OldWomanStruct.unknown174 = 0;
OldWomanStruct.unknown178 = 0;
OldWomanStruct.unknown17C = 0;
OldWomanStruct.unknown180 = 0;
OldWomanStruct.unknown184 = 0;
OldWomanStruct.unknown188 = 0;
OldWomanStruct.unknown18C = 0;
OldWomanStruct.unknown190 = 0;
OldWomanStruct.unknown194 = 0;
OldWomanStruct.unknown198 = 0;
OldWomanStruct.unknown19C = 0;
OldWomanStruct.unknown1A0 = 0;
OldWomanStruct.unknown1A4 = 0;
OldWomanStruct.unknown1A8 = 0;
OldWomanStruct.unknown1AC = 0;
OldWomanStruct.unknown1B0 = 0;
OldWomanStruct.unknown1B4 = 0;
OldWomanStruct.unknown1B8 = 0;
OldWomanStruct.unknown1BC = 0;
OldWomanStruct.unknown1C0 = 0;
OldWomanStruct.unknown1C4 = 0;
OldWomanStruct.unknown1C8 = 0;
OldWomanStruct.unknown1CC = 0;


--ID: 61 Name1: Patsy's Magic Bullet Name2: Magic Bullet
local MagicBullet = WeaponStruct.new()
MagicBullet.panelRow = 12;
MagicBullet.unknownC = 0;
MagicBullet.unknown10 = 0;
MagicBullet.unknown14 = 1;
MagicBullet.unknown18 = 1;
MagicBullet.unknown1C = 3000;
MagicBullet.unknown20 = 1;
MagicBullet.unknown24 = 20;
MagicBullet.unknown28 = 1;
MagicBullet.unknown2C = 0;
MagicBullet.unknown30 = 3;
MagicBullet.unknown34 = 0;
MagicBullet.unknown38 = 87;
MagicBullet.unknown3C = 5;
MagicBullet.unknown40 = 32;
MagicBullet.unknown44 = 100;
MagicBullet.unknown48 = 52;
MagicBullet.unknown4C = 2;
MagicBullet.unknown50 = 2;
MagicBullet.unknown54 = 66;
MagicBullet.unknown58 = 0;
MagicBullet.unknown5C = 137342;
MagicBullet.unknown60 = 0;
MagicBullet.unknown64 = 100;
MagicBullet.unknown68 = 100;
MagicBullet.unknown6C = 0;
MagicBullet.unknown70 = 0;
MagicBullet.unknown74 = 49;
MagicBullet.unknown78 = 1;
MagicBullet.unknown7C = 0;
MagicBullet.unknown80 = 0;
MagicBullet.unknown84 = 100;
MagicBullet.unknown88 = 50;
MagicBullet.unknown8C = 100;
MagicBullet.unknown90 = 0;
MagicBullet.unknown94 = 0;
MagicBullet.unknown98 = 100;
MagicBullet.unknown9C = 0;
MagicBullet.unknownA0 = 10000;
MagicBullet.unknownA4 = 65598;
MagicBullet.unknownA8 = 0;
MagicBullet.unknownAC = 0;
MagicBullet.unknownB0 = 0;
MagicBullet.unknownB4 = 0;
MagicBullet.unknownB8 = 1;
MagicBullet.unknownBC = 0;
MagicBullet.unknownC0 = 49;
MagicBullet.unknownC4 = 2;
MagicBullet.unknownC8 = 135;
MagicBullet.unknownCC = 50;
MagicBullet.unknownD0 = 100;
MagicBullet.unknownD4 = 50;
MagicBullet.unknownD8 = 2;
MagicBullet.unknownDC = 100;
MagicBullet.unknownE0 = 9900;
MagicBullet.unknownE4 = 0;
MagicBullet.unknownE8 = 0;
MagicBullet.unknownEC = 0;
MagicBullet.unknownF0 = 0;
MagicBullet.unknownF4 = 0;
MagicBullet.unknownF8 = 0;
MagicBullet.unknownFC = 0;
MagicBullet.unknown100 = 0;
MagicBullet.unknown104 = 0;
MagicBullet.unknown108 = 0;
MagicBullet.unknown10C = 0;
MagicBullet.unknown110 = 0;
MagicBullet.unknown114 = 0;
MagicBullet.unknown118 = 0;
MagicBullet.unknown11C = 0;
MagicBullet.unknown120 = 0;
MagicBullet.unknown124 = 0;
MagicBullet.unknown128 = 0;
MagicBullet.unknown12C = 0;
MagicBullet.unknown130 = 0;
MagicBullet.unknown134 = 0;
MagicBullet.unknown138 = 0;
MagicBullet.unknown13C = 0;
MagicBullet.unknown140 = 0;
MagicBullet.unknown144 = 0;
MagicBullet.unknown148 = 0;
MagicBullet.unknown14C = 0;
MagicBullet.unknown150 = 0;
MagicBullet.unknown154 = 0;
MagicBullet.unknown158 = 0;
MagicBullet.unknown15C = 0;
MagicBullet.unknown160 = 0;
MagicBullet.unknown164 = 0;
MagicBullet.unknown168 = 0;
MagicBullet.unknown16C = 0;
MagicBullet.unknown170 = 0;
MagicBullet.unknown174 = 0;
MagicBullet.unknown178 = 0;
MagicBullet.unknown17C = 0;
MagicBullet.unknown180 = 0;
MagicBullet.unknown184 = 0;
MagicBullet.unknown188 = 0;
MagicBullet.unknown18C = 0;
MagicBullet.unknown190 = 0;
MagicBullet.unknown194 = 0;
MagicBullet.unknown198 = 0;
MagicBullet.unknown19C = 0;
MagicBullet.unknown1A0 = 0;
MagicBullet.unknown1A4 = 0;
MagicBullet.unknown1A8 = 0;
MagicBullet.unknown1AC = 0;
MagicBullet.unknown1B0 = 0;
MagicBullet.unknown1B4 = 0;
MagicBullet.unknown1B8 = 0;
MagicBullet.unknown1BC = 0;
MagicBullet.unknown1C0 = 0;
MagicBullet.unknown1C4 = 0;
MagicBullet.unknown1C8 = 0;
MagicBullet.unknown1CC = 0;

--ID: 1 Name1: Armageddon Strike Name2: Armageddon Strike
local ArmageddonStrikeStruct = WeaponStruct.new()
ArmageddonStrikeStruct.panelRow = 1;
ArmageddonStrikeStruct.unknownC = 0;
ArmageddonStrikeStruct.unknown10 = 0;
ArmageddonStrikeStruct.unknown14 = 1;
ArmageddonStrikeStruct.unknown18 = 1;
ArmageddonStrikeStruct.unknown1C = 3000;
ArmageddonStrikeStruct.unknown20 = 1;
ArmageddonStrikeStruct.unknown24 = 20;
ArmageddonStrikeStruct.unknown28 = 1;
ArmageddonStrikeStruct.unknown2C = 0;
ArmageddonStrikeStruct.unknown30 = 3;
ArmageddonStrikeStruct.unknown34 = 0;
ArmageddonStrikeStruct.unknown38 = 87;
ArmageddonStrikeStruct.unknown3C = 5;
ArmageddonStrikeStruct.unknown40 = 32;
ArmageddonStrikeStruct.unknown44 = 100;
ArmageddonStrikeStruct.unknown48 = 52;
ArmageddonStrikeStruct.unknown4C = 2;
ArmageddonStrikeStruct.unknown50 = 2;
ArmageddonStrikeStruct.unknown54 = 0;
ArmageddonStrikeStruct.unknown58 = 0;
ArmageddonStrikeStruct.unknown5C = 137342;
ArmageddonStrikeStruct.unknown60 = 0;
ArmageddonStrikeStruct.unknown64 = 100;
ArmageddonStrikeStruct.unknown68 = 44;
ArmageddonStrikeStruct.unknown6C = 0;
ArmageddonStrikeStruct.unknown70 = 0;
ArmageddonStrikeStruct.unknown74 = 66;
ArmageddonStrikeStruct.unknown78 = 2;
ArmageddonStrikeStruct.unknown7C = 131;
ArmageddonStrikeStruct.unknown80 = 50;
ArmageddonStrikeStruct.unknown84 = 100;
ArmageddonStrikeStruct.unknown88 = 50;
ArmageddonStrikeStruct.unknown8C = 100;
ArmageddonStrikeStruct.unknown90 = 0;
ArmageddonStrikeStruct.unknown94 = 0;
ArmageddonStrikeStruct.unknown98 = 100;
ArmageddonStrikeStruct.unknown9C = 0;
ArmageddonStrikeStruct.unknownA0 = 9000;
ArmageddonStrikeStruct.unknownA4 = 0;
ArmageddonStrikeStruct.unknownA8 = 0;
ArmageddonStrikeStruct.unknownAC = 0;
ArmageddonStrikeStruct.unknownB0 = 0;
ArmageddonStrikeStruct.unknownB4 = 0;
ArmageddonStrikeStruct.unknownB8 = 2;
ArmageddonStrikeStruct.unknownBC = 4194304;
ArmageddonStrikeStruct.unknownC0 = 1;
ArmageddonStrikeStruct.unknownC4 = 0;
ArmageddonStrikeStruct.unknownC8 = 0;
ArmageddonStrikeStruct.unknownCC = 8;
ArmageddonStrikeStruct.unknownD0 = 0;
ArmageddonStrikeStruct.unknownD4 = 0;
ArmageddonStrikeStruct.unknownD8 = 0;
ArmageddonStrikeStruct.unknownDC = 0;
ArmageddonStrikeStruct.unknownE0 = 0;
ArmageddonStrikeStruct.unknownE4 = 0;
ArmageddonStrikeStruct.unknownE8 = 0;
ArmageddonStrikeStruct.unknownEC = 0;
ArmageddonStrikeStruct.unknownF0 = 0;
ArmageddonStrikeStruct.unknownF4 = 0;
ArmageddonStrikeStruct.unknownF8 = 0;
ArmageddonStrikeStruct.unknownFC = 0;
ArmageddonStrikeStruct.unknown100 = 0;
ArmageddonStrikeStruct.unknown104 = 0;
ArmageddonStrikeStruct.unknown108 = 0;
ArmageddonStrikeStruct.unknown10C = 0;
ArmageddonStrikeStruct.unknown110 = 0;
ArmageddonStrikeStruct.unknown114 = 0;
ArmageddonStrikeStruct.unknown118 = 0;
ArmageddonStrikeStruct.unknown11C = 0;
ArmageddonStrikeStruct.unknown120 = 0;
ArmageddonStrikeStruct.unknown124 = 0;
ArmageddonStrikeStruct.unknown128 = 0;
ArmageddonStrikeStruct.unknown12C = 0;
ArmageddonStrikeStruct.unknown130 = 0;
ArmageddonStrikeStruct.unknown134 = 0;
ArmageddonStrikeStruct.unknown138 = 0;
ArmageddonStrikeStruct.unknown13C = 0;
ArmageddonStrikeStruct.unknown140 = 0;
ArmageddonStrikeStruct.unknown144 = 0;
ArmageddonStrikeStruct.unknown148 = 0;
ArmageddonStrikeStruct.unknown14C = 0;
ArmageddonStrikeStruct.unknown150 = 0;
ArmageddonStrikeStruct.unknown154 = 0;
ArmageddonStrikeStruct.unknown158 = 0;
ArmageddonStrikeStruct.unknown15C = 0;
ArmageddonStrikeStruct.unknown160 = 0;
ArmageddonStrikeStruct.unknown164 = 0;
ArmageddonStrikeStruct.unknown168 = 0;
ArmageddonStrikeStruct.unknown16C = 0;
ArmageddonStrikeStruct.unknown170 = 0;
ArmageddonStrikeStruct.unknown174 = 0;
ArmageddonStrikeStruct.unknown178 = 0;
ArmageddonStrikeStruct.unknown17C = 0;
ArmageddonStrikeStruct.unknown180 = 0;
ArmageddonStrikeStruct.unknown184 = 0;
ArmageddonStrikeStruct.unknown188 = 0;
ArmageddonStrikeStruct.unknown18C = 0;
ArmageddonStrikeStruct.unknown190 = 0;
ArmageddonStrikeStruct.unknown194 = 0;
ArmageddonStrikeStruct.unknown198 = 0;
ArmageddonStrikeStruct.unknown19C = 0;
ArmageddonStrikeStruct.unknown1A0 = 0;
ArmageddonStrikeStruct.unknown1A4 = 0;
ArmageddonStrikeStruct.unknown1A8 = 0;
ArmageddonStrikeStruct.unknown1AC = 0;
ArmageddonStrikeStruct.unknown1B0 = 0;
ArmageddonStrikeStruct.unknown1B4 = 0;
ArmageddonStrikeStruct.unknown1B8 = 0;
ArmageddonStrikeStruct.unknown1BC = 0;
ArmageddonStrikeStruct.unknown1C0 = 0;
ArmageddonStrikeStruct.unknown1C4 = 0;
ArmageddonStrikeStruct.unknown1C8 = 0;
ArmageddonStrikeStruct.unknown1CC = 0;

--ID: 62 Name1: Pokeball Sheep Name2: Pokeball Sheep
local PokeballSheepStruct = WeaponStruct.new()
PokeballSheepStruct.panelRow = 2;
PokeballSheepStruct.unknownC = 0;
PokeballSheepStruct.unknown10 = 1;
PokeballSheepStruct.unknown14 = 1;
PokeballSheepStruct.unknown18 = 1;
PokeballSheepStruct.unknown1C = 3000;
PokeballSheepStruct.unknown20 = 1;
PokeballSheepStruct.unknown24 = 0;
PokeballSheepStruct.unknown28 = 1;
PokeballSheepStruct.unknown2C = 0;
PokeballSheepStruct.unknown30 = 1;
PokeballSheepStruct.unknown34 = 2;
PokeballSheepStruct.unknown38 = 3;
PokeballSheepStruct.unknown3C = 2;
PokeballSheepStruct.unknown40 = 0;
PokeballSheepStruct.unknown44 = 1;
PokeballSheepStruct.unknown48 = 0;
PokeballSheepStruct.unknown4C = 0;
PokeballSheepStruct.unknown50 = 0;
PokeballSheepStruct.unknown54 = 0;
PokeballSheepStruct.unknown58 = 0;
PokeballSheepStruct.unknown5C = 0;
PokeballSheepStruct.unknown60 = pokeball_sprite;
PokeballSheepStruct.unknown64 = 1;
PokeballSheepStruct.unknown68 = 131;
PokeballSheepStruct.unknown6C = 0;
PokeballSheepStruct.unknown70 = 100;
PokeballSheepStruct.unknown74 = 0;
PokeballSheepStruct.unknown78 = 100;
PokeballSheepStruct.unknown7C = 0;
PokeballSheepStruct.unknown80 = 0;
PokeballSheepStruct.unknown84 = 100;
PokeballSheepStruct.unknown88 = 0;
PokeballSheepStruct.unknown8C = 1;
PokeballSheepStruct.unknown90 = 0;
PokeballSheepStruct.unknown94 = 250;
PokeballSheepStruct.unknown98 = pokeball_release_sound;
PokeballSheepStruct.unknown9C = 500;
PokeballSheepStruct.unknownA0 = 0;
PokeballSheepStruct.unknownA4 = 2;
PokeballSheepStruct.unknownA8 = 4331646;
PokeballSheepStruct.unknownAC = 0;
PokeballSheepStruct.unknownB0 = 100;
PokeballSheepStruct.unknownB4 = 113;
PokeballSheepStruct.unknownB8 = 8;
PokeballSheepStruct.unknownBC = 0;
PokeballSheepStruct.unknownC0 = 0;
PokeballSheepStruct.unknownC4 = 0;
PokeballSheepStruct.unknownC8 = 0;
PokeballSheepStruct.unknownCC = 0;
PokeballSheepStruct.unknownD0 = 0;
PokeballSheepStruct.unknownD4 = 0;
PokeballSheepStruct.unknownD8 = 0;
PokeballSheepStruct.unknownDC = 0;
PokeballSheepStruct.unknownE0 = 0;
PokeballSheepStruct.unknownE4 = 0;
PokeballSheepStruct.unknownE8 = 0;
PokeballSheepStruct.unknownEC = 0;
PokeballSheepStruct.unknownF0 = 3;
PokeballSheepStruct.unknownF4 = 0;
PokeballSheepStruct.unknownF8 = 1;
PokeballSheepStruct.unknownFC = 0;
PokeballSheepStruct.unknown100 = 0;
PokeballSheepStruct.unknown104 = 0;
PokeballSheepStruct.unknown108 = 0;
PokeballSheepStruct.unknown10C = 0;
PokeballSheepStruct.unknown110 = 0;
PokeballSheepStruct.unknown114 = 120;
PokeballSheepStruct.unknown118 = 90;
PokeballSheepStruct.unknown11C = 0;
PokeballSheepStruct.unknown120 = 1;
PokeballSheepStruct.unknown124 = 153;
PokeballSheepStruct.unknown128 = 6;
PokeballSheepStruct.unknown12C = 131;
PokeballSheepStruct.unknown130 = 0;
PokeballSheepStruct.unknown134 = 100;
PokeballSheepStruct.unknown138 = 50;
PokeballSheepStruct.unknown13C = 100;
PokeballSheepStruct.unknown140 = 0;
PokeballSheepStruct.unknown144 = 0;
PokeballSheepStruct.unknown148 = 100;
PokeballSheepStruct.unknown14C = 5000;
PokeballSheepStruct.unknown150 = 20000;
PokeballSheepStruct.unknown154 = 0;
PokeballSheepStruct.unknown158 = 0;
PokeballSheepStruct.unknown15C = 0;
PokeballSheepStruct.unknown160 = 0;
PokeballSheepStruct.unknown164 = 1;
PokeballSheepStruct.unknown168 = 3;
PokeballSheepStruct.unknown16C = 4331646;
PokeballSheepStruct.unknown170 = 4331646;
PokeballSheepStruct.unknown174 = 100;
PokeballSheepStruct.unknown178 = 4;
PokeballSheepStruct.unknown17C = 0;
PokeballSheepStruct.unknown180 = 0;
PokeballSheepStruct.unknown184 = 0;
PokeballSheepStruct.unknown188 = 25;
PokeballSheepStruct.unknown18C = 100;
PokeballSheepStruct.unknown190 = 50;
PokeballSheepStruct.unknown194 = -10;
PokeballSheepStruct.unknown198 = 0;
PokeballSheepStruct.unknown19C = 0;
PokeballSheepStruct.unknown1A0 = 0;
PokeballSheepStruct.unknown1A4 = 0;
PokeballSheepStruct.unknown1A8 = 0;
PokeballSheepStruct.unknown1AC = 0;
PokeballSheepStruct.unknown1B0 = 0;
PokeballSheepStruct.unknown1B4 = 0;
PokeballSheepStruct.unknown1B8 = 0;
PokeballSheepStruct.unknown1BC = 0;
PokeballSheepStruct.unknown1C0 = 0;
PokeballSheepStruct.unknown1C4 = 0;
PokeballSheepStruct.unknown1C8 = 100;
PokeballSheepStruct.unknown1CC = 0;

--ID: 63 Name1: Pokeball Super Sheep Name2: Pokeball Super Sheep
local PokeballSuperSheepStruct = WeaponStruct.new()
PokeballSuperSheepStruct.panelRow = 2;
PokeballSuperSheepStruct.unknownC = 1;
PokeballSuperSheepStruct.unknown10 = 1;
PokeballSuperSheepStruct.unknown14 = 1;
PokeballSuperSheepStruct.unknown18 = 1;
PokeballSuperSheepStruct.unknown1C = 3000;
PokeballSuperSheepStruct.unknown20 = 1;
PokeballSuperSheepStruct.unknown24 = 0;
PokeballSuperSheepStruct.unknown28 = 1;
PokeballSuperSheepStruct.unknown2C = 0;
PokeballSuperSheepStruct.unknown30 = 1;
PokeballSuperSheepStruct.unknown34 = 2;
PokeballSuperSheepStruct.unknown38 = 3;
PokeballSuperSheepStruct.unknown3C = 2;
PokeballSuperSheepStruct.unknown40 = 0;
PokeballSuperSheepStruct.unknown44 = 1;
PokeballSuperSheepStruct.unknown48 = 0;
PokeballSuperSheepStruct.unknown4C = 0;
PokeballSuperSheepStruct.unknown50 = 0;
PokeballSuperSheepStruct.unknown54 = 0;
PokeballSuperSheepStruct.unknown58 = 0;
PokeballSuperSheepStruct.unknown5C = 0;
PokeballSuperSheepStruct.unknown60 = pokeball_sprite;
PokeballSuperSheepStruct.unknown64 = 1;
PokeballSuperSheepStruct.unknown68 = 131;
PokeballSuperSheepStruct.unknown6C = 0;
PokeballSuperSheepStruct.unknown70 = 100;
PokeballSuperSheepStruct.unknown74 = 0;
PokeballSuperSheepStruct.unknown78 = 100;
PokeballSuperSheepStruct.unknown7C = 0;
PokeballSuperSheepStruct.unknown80 = 0;
PokeballSuperSheepStruct.unknown84 = 100;
PokeballSuperSheepStruct.unknown88 = 0;
PokeballSuperSheepStruct.unknown8C = 1;
PokeballSuperSheepStruct.unknown90 = 0;
PokeballSuperSheepStruct.unknown94 = 250;
PokeballSuperSheepStruct.unknown98 = pokeball_release_sound;
PokeballSuperSheepStruct.unknown9C = 500;
PokeballSuperSheepStruct.unknownA0 = 0;
PokeballSuperSheepStruct.unknownA4 = 2;
PokeballSuperSheepStruct.unknownA8 = 4331646;
PokeballSuperSheepStruct.unknownAC = 0;
PokeballSuperSheepStruct.unknownB0 = 100;
PokeballSuperSheepStruct.unknownB4 = 113;
PokeballSuperSheepStruct.unknownB8 = 8;
PokeballSuperSheepStruct.unknownBC = 0;
PokeballSuperSheepStruct.unknownC0 = 0;
PokeballSuperSheepStruct.unknownC4 = 0;
PokeballSuperSheepStruct.unknownC8 = 0;
PokeballSuperSheepStruct.unknownCC = 0;
PokeballSuperSheepStruct.unknownD0 = 0;
PokeballSuperSheepStruct.unknownD4 = 0;
PokeballSuperSheepStruct.unknownD8 = 0;
PokeballSuperSheepStruct.unknownDC = 0;
PokeballSuperSheepStruct.unknownE0 = 0;
PokeballSuperSheepStruct.unknownE4 = 0;
PokeballSuperSheepStruct.unknownE8 = 0;
PokeballSuperSheepStruct.unknownEC = 0;
PokeballSuperSheepStruct.unknownF0 = 3;
PokeballSuperSheepStruct.unknownF4 = 0;
PokeballSuperSheepStruct.unknownF8 = 1;
PokeballSuperSheepStruct.unknownFC = 0;
PokeballSuperSheepStruct.unknown100 = 0;
PokeballSuperSheepStruct.unknown104 = 0;
PokeballSuperSheepStruct.unknown108 = 0;
PokeballSuperSheepStruct.unknown10C = 0;
PokeballSuperSheepStruct.unknown110 = 0;
PokeballSuperSheepStruct.unknown114 = 120;
PokeballSuperSheepStruct.unknown118 = 90;
PokeballSuperSheepStruct.unknown11C = 0;
PokeballSuperSheepStruct.unknown120 = 1;
PokeballSuperSheepStruct.unknown124 = 153;
PokeballSuperSheepStruct.unknown128 = 6;
PokeballSuperSheepStruct.unknown12C = 131;
PokeballSuperSheepStruct.unknown130 = 0;
PokeballSuperSheepStruct.unknown134 = 100;
PokeballSuperSheepStruct.unknown138 = 50;
PokeballSuperSheepStruct.unknown13C = 100;
PokeballSuperSheepStruct.unknown140 = 0;
PokeballSuperSheepStruct.unknown144 = 0;
PokeballSuperSheepStruct.unknown148 = 100;
PokeballSuperSheepStruct.unknown14C = 5000;
PokeballSuperSheepStruct.unknown150 = 20000;
PokeballSuperSheepStruct.unknown154 = 0;
PokeballSuperSheepStruct.unknown158 = 0;
PokeballSuperSheepStruct.unknown15C = 0;
PokeballSuperSheepStruct.unknown160 = 0;
PokeballSuperSheepStruct.unknown164 = 1;
PokeballSuperSheepStruct.unknown168 = 3;
PokeballSuperSheepStruct.unknown16C = 4331646;
PokeballSuperSheepStruct.unknown170 = 4331646;
PokeballSuperSheepStruct.unknown174 = 100;
PokeballSuperSheepStruct.unknown178 = 4;
PokeballSuperSheepStruct.unknown17C = 0;
PokeballSuperSheepStruct.unknown180 = 0;
PokeballSuperSheepStruct.unknown184 = 0;
PokeballSuperSheepStruct.unknown188 = 25;
PokeballSuperSheepStruct.unknown18C = 100;
PokeballSuperSheepStruct.unknown190 = 50;
PokeballSuperSheepStruct.unknown194 = -10;
PokeballSuperSheepStruct.unknown198 = 0;
PokeballSuperSheepStruct.unknown19C = 0;
PokeballSuperSheepStruct.unknown1A0 = 0;
PokeballSuperSheepStruct.unknown1A4 = 154;
PokeballSuperSheepStruct.unknown1A8 = 155;
PokeballSuperSheepStruct.unknown1AC = 76;
PokeballSuperSheepStruct.unknown1B0 = 77;
PokeballSuperSheepStruct.unknown1B4 = 0;
PokeballSuperSheepStruct.unknown1B8 = 0;
PokeballSuperSheepStruct.unknown1BC = 0;
PokeballSuperSheepStruct.unknown1C0 = 0;
PokeballSuperSheepStruct.unknown1C4 = 0;
PokeballSuperSheepStruct.unknown1C8 = 100;
PokeballSuperSheepStruct.unknown1CC = 0;



--ID: 64 Name1: Laser Gun Name2: Laser Gun
local LaserGunStructure = WeaponStruct.new()
LaserGunStructure.panelRow = 3;
LaserGunStructure.unknownC = 1;
LaserGunStructure.unknown10 = 1;
LaserGunStructure.unknown14 = 1;
LaserGunStructure.unknown18 = 1;
LaserGunStructure.unknown1C = 3000;
LaserGunStructure.unknown20 = 1;
LaserGunStructure.unknown24 = 0;
LaserGunStructure.unknown28 = 1;
LaserGunStructure.unknown2C = 0;
LaserGunStructure.unknown30 = 1;
LaserGunStructure.unknown34 = 4;
LaserGunStructure.unknown38 = 2;
LaserGunStructure.unknown3C = 100;
LaserGunStructure.unknown40 = 0;
LaserGunStructure.unknown44 = 0;
LaserGunStructure.unknown48 = 1;
LaserGunStructure.unknown4C = 0;
LaserGunStructure.unknown50 = 4332670;
LaserGunStructure.unknown54 = 0;
LaserGunStructure.unknown58 = 300;
LaserGunStructure.unknown5C = 1;
LaserGunStructure.unknown60 = 0;
LaserGunStructure.unknown64 = 3;
LaserGunStructure.unknown68 = 32767;
LaserGunStructure.unknown6C = 0;
LaserGunStructure.unknown70 = 0;
LaserGunStructure.unknown74 = 0;
LaserGunStructure.unknown78 = 0;
LaserGunStructure.unknown7C = 0;
LaserGunStructure.unknown80 = 0;
LaserGunStructure.unknown84 = 0;
LaserGunStructure.unknown88 = 0;
LaserGunStructure.unknown8C = 0;
LaserGunStructure.unknown90 = 0;
LaserGunStructure.unknown94 = 0;
LaserGunStructure.unknown98 = 0;
LaserGunStructure.unknown9C = 0;
LaserGunStructure.unknownA0 = 0;
LaserGunStructure.unknownA4 = 0;
LaserGunStructure.unknownA8 = 0;
LaserGunStructure.unknownAC = 0;
LaserGunStructure.unknownB0 = 0;
LaserGunStructure.unknownB4 = 0;
LaserGunStructure.unknownB8 = 0;
LaserGunStructure.unknownBC = 0;
LaserGunStructure.unknownC0 = 0;
LaserGunStructure.unknownC4 = 0;
LaserGunStructure.unknownC8 = 0;
LaserGunStructure.unknownCC = 0;
LaserGunStructure.unknownD0 = 0;
LaserGunStructure.unknownD4 = 0;
LaserGunStructure.unknownD8 = 0;
LaserGunStructure.unknownDC = 0;
LaserGunStructure.unknownE0 = 0;
LaserGunStructure.unknownE4 = 0;
LaserGunStructure.unknownE8 = 0;
LaserGunStructure.unknownEC = 0;
LaserGunStructure.unknownF0 = 0;
LaserGunStructure.unknownF4 = 0;
LaserGunStructure.unknownF8 = 0;
LaserGunStructure.unknownFC = 0;
LaserGunStructure.unknown100 = 0;
LaserGunStructure.unknown104 = 0;
LaserGunStructure.unknown108 = 0;
LaserGunStructure.unknown10C = 0;
LaserGunStructure.unknown110 = 0;
LaserGunStructure.unknown114 = 0;
LaserGunStructure.unknown118 = 0;
LaserGunStructure.unknown11C = 0;
LaserGunStructure.unknown120 = 0;
LaserGunStructure.unknown124 = 0;
LaserGunStructure.unknown128 = 0;
LaserGunStructure.unknown12C = 0;
LaserGunStructure.unknown130 = 0;
LaserGunStructure.unknown134 = 0;
LaserGunStructure.unknown138 = 0;
LaserGunStructure.unknown13C = 0;
LaserGunStructure.unknown140 = 0;
LaserGunStructure.unknown144 = 0;
LaserGunStructure.unknown148 = 0;
LaserGunStructure.unknown14C = 0;
LaserGunStructure.unknown150 = 0;
LaserGunStructure.unknown154 = 0;
LaserGunStructure.unknown158 = 0;
LaserGunStructure.unknown15C = 0;
LaserGunStructure.unknown160 = 0;
LaserGunStructure.unknown164 = 0;
LaserGunStructure.unknown168 = 0;
LaserGunStructure.unknown16C = 0;
LaserGunStructure.unknown170 = 0;
LaserGunStructure.unknown174 = 0;
LaserGunStructure.unknown178 = 0;
LaserGunStructure.unknown17C = 0;
LaserGunStructure.unknown180 = 0;
LaserGunStructure.unknown184 = 0;
LaserGunStructure.unknown188 = 0;
LaserGunStructure.unknown18C = 0;
LaserGunStructure.unknown190 = 0;
LaserGunStructure.unknown194 = 0;
LaserGunStructure.unknown198 = 0;
LaserGunStructure.unknown19C = 0;
LaserGunStructure.unknown1A0 = 0;
LaserGunStructure.unknown1A4 = 0;
LaserGunStructure.unknown1A8 = 0;
LaserGunStructure.unknown1AC = 0;
LaserGunStructure.unknown1B0 = 0;
LaserGunStructure.unknown1B4 = 0;
LaserGunStructure.unknown1B8 = 0;
LaserGunStructure.unknown1BC = 0;
LaserGunStructure.unknown1C0 = 0;
LaserGunStructure.unknown1C4 = 0;
LaserGunStructure.unknown1C8 = 0;
LaserGunStructure.unknown1CC = 0;

--ID: 64 Name1: Bozar Name2: Bozar
local BozarGunStructure = WeaponStruct.new()
BozarGunStructure.panelRow = 3;
BozarGunStructure.unknownC = 1;
BozarGunStructure.unknown10 = 1;
BozarGunStructure.unknown14 = 1;
BozarGunStructure.unknown18 = 1;
BozarGunStructure.unknown1C = 3000;
BozarGunStructure.unknown20 = 1;
BozarGunStructure.unknown24 = 0;
BozarGunStructure.unknown28 = 1;
BozarGunStructure.unknown2C = 0;
BozarGunStructure.unknown30 = 1;
BozarGunStructure.unknown34 = 5;
BozarGunStructure.unknown38 = 2;
BozarGunStructure.unknown3C = 1;
BozarGunStructure.unknown40 = 500;
BozarGunStructure.unknown44 = 0;
BozarGunStructure.unknown48 = 1;
BozarGunStructure.unknown4C = 0;
BozarGunStructure.unknown50 = 4332670;
BozarGunStructure.unknown54 = 0;
BozarGunStructure.unknown58 = 300;
BozarGunStructure.unknown5C = 75;
BozarGunStructure.unknown60 = 0;
BozarGunStructure.unknown64 = 0;
BozarGunStructure.unknown68 = 32767;
BozarGunStructure.unknown6C = 0;
BozarGunStructure.unknown70 = 0;
BozarGunStructure.unknown74 = 0;
BozarGunStructure.unknown78 = 0;
BozarGunStructure.unknown7C = 0;
BozarGunStructure.unknown80 = 0;
BozarGunStructure.unknown84 = 0;
BozarGunStructure.unknown88 = 0;
BozarGunStructure.unknown8C = 0;
BozarGunStructure.unknown90 = 0;
BozarGunStructure.unknown94 = 0;
BozarGunStructure.unknown98 = 0;
BozarGunStructure.unknown9C = 0;
BozarGunStructure.unknownA0 = 0;
BozarGunStructure.unknownA4 = 0;
BozarGunStructure.unknownA8 = 0;
BozarGunStructure.unknownAC = 0;
BozarGunStructure.unknownB0 = 0;
BozarGunStructure.unknownB4 = 0;
BozarGunStructure.unknownB8 = 0;
BozarGunStructure.unknownBC = 0;
BozarGunStructure.unknownC0 = 0;
BozarGunStructure.unknownC4 = 0;
BozarGunStructure.unknownC8 = 0;
BozarGunStructure.unknownCC = 0;
BozarGunStructure.unknownD0 = 0;
BozarGunStructure.unknownD4 = 0;
BozarGunStructure.unknownD8 = 0;
BozarGunStructure.unknownDC = 0;
BozarGunStructure.unknownE0 = 0;
BozarGunStructure.unknownE4 = 0;
BozarGunStructure.unknownE8 = 0;
BozarGunStructure.unknownEC = 0;
BozarGunStructure.unknownF0 = 0;
BozarGunStructure.unknownF4 = 0;
BozarGunStructure.unknownF8 = 0;
BozarGunStructure.unknownFC = 0;
BozarGunStructure.unknown100 = 0;
BozarGunStructure.unknown104 = 0;
BozarGunStructure.unknown108 = 0;
BozarGunStructure.unknown10C = 0;
BozarGunStructure.unknown110 = 0;
BozarGunStructure.unknown114 = 0;
BozarGunStructure.unknown118 = 0;
BozarGunStructure.unknown11C = 0;
BozarGunStructure.unknown120 = 0;
BozarGunStructure.unknown124 = 0;
BozarGunStructure.unknown128 = 0;
BozarGunStructure.unknown12C = 0;
BozarGunStructure.unknown130 = 0;
BozarGunStructure.unknown134 = 0;
BozarGunStructure.unknown138 = 0;
BozarGunStructure.unknown13C = 0;
BozarGunStructure.unknown140 = 0;
BozarGunStructure.unknown144 = 0;
BozarGunStructure.unknown148 = 0;
BozarGunStructure.unknown14C = 0;
BozarGunStructure.unknown150 = 0;
BozarGunStructure.unknown154 = 0;
BozarGunStructure.unknown158 = 0;
BozarGunStructure.unknown15C = 0;
BozarGunStructure.unknown160 = 0;
BozarGunStructure.unknown164 = 0;
BozarGunStructure.unknown168 = 0;
BozarGunStructure.unknown16C = 0;
BozarGunStructure.unknown170 = 0;
BozarGunStructure.unknown174 = 0;
BozarGunStructure.unknown178 = 0;
BozarGunStructure.unknown17C = 0;
BozarGunStructure.unknown180 = 0;
BozarGunStructure.unknown184 = 0;
BozarGunStructure.unknown188 = 0;
BozarGunStructure.unknown18C = 0;
BozarGunStructure.unknown190 = 0;
BozarGunStructure.unknown194 = 0;
BozarGunStructure.unknown198 = 0;
BozarGunStructure.unknown19C = 0;
BozarGunStructure.unknown1A0 = 0;
BozarGunStructure.unknown1A4 = 0;
BozarGunStructure.unknown1A8 = 0;
BozarGunStructure.unknown1AC = 0;
BozarGunStructure.unknown1B0 = 0;
BozarGunStructure.unknown1B4 = 0;
BozarGunStructure.unknown1B8 = 0;
BozarGunStructure.unknown1BC = 0;
BozarGunStructure.unknown1C0 = 0;
BozarGunStructure.unknown1C4 = 0;
BozarGunStructure.unknown1C8 = 0;
BozarGunStructure.unknown1CC = 0;

--ID: 99 Name1: Explosion Magic Name2: Explosion Magic
local ExplosionMagicStructure = WeaponStruct.new()
ExplosionMagicStructure.panelRow = 0;
ExplosionMagicStructure.unknownC = 0;
ExplosionMagicStructure.unknown10 = 1;
ExplosionMagicStructure.unknown14 = 1;
ExplosionMagicStructure.unknown18 = 1;
ExplosionMagicStructure.unknown1C = 3000;
ExplosionMagicStructure.unknown20 = 1;
ExplosionMagicStructure.unknown24 = 0;
ExplosionMagicStructure.unknown28 = 1;
ExplosionMagicStructure.unknown2C = 0;
ExplosionMagicStructure.unknown30 = 4;
ExplosionMagicStructure.unknown34 = 14;
ExplosionMagicStructure.unknown38 = 0;
ExplosionMagicStructure.unknown3C = 0;
ExplosionMagicStructure.unknown40 = 0;
ExplosionMagicStructure.unknown44 = 0;
ExplosionMagicStructure.unknown48 = 0;
ExplosionMagicStructure.unknown4C = 0;
ExplosionMagicStructure.unknown50 = 0;
ExplosionMagicStructure.unknown54 = 0;
ExplosionMagicStructure.unknown58 = 0;
ExplosionMagicStructure.unknown5C = 0;
ExplosionMagicStructure.unknown60 = 0;
ExplosionMagicStructure.unknown64 = 0;
ExplosionMagicStructure.unknown68 = 0;
ExplosionMagicStructure.unknown6C = 0;
ExplosionMagicStructure.unknown70 = 0;
ExplosionMagicStructure.unknown74 = 0;
ExplosionMagicStructure.unknown78 = 0;
ExplosionMagicStructure.unknown7C = 0;
ExplosionMagicStructure.unknown80 = 0;
ExplosionMagicStructure.unknown84 = 0;
ExplosionMagicStructure.unknown88 = 0;
ExplosionMagicStructure.unknown8C = 0;
ExplosionMagicStructure.unknown90 = 0;
ExplosionMagicStructure.unknown94 = 0;
ExplosionMagicStructure.unknown98 = 0;
ExplosionMagicStructure.unknown9C = 0;
ExplosionMagicStructure.unknownA0 = 0;
ExplosionMagicStructure.unknownA4 = 0;
ExplosionMagicStructure.unknownA8 = 0;
ExplosionMagicStructure.unknownAC = 0;
ExplosionMagicStructure.unknownB0 = 0;
ExplosionMagicStructure.unknownB4 = 0;
ExplosionMagicStructure.unknownB8 = 0;
ExplosionMagicStructure.unknownBC = 0;
ExplosionMagicStructure.unknownC0 = 0;
ExplosionMagicStructure.unknownC4 = 0;
ExplosionMagicStructure.unknownC8 = 0;
ExplosionMagicStructure.unknownCC = 0;
ExplosionMagicStructure.unknownD0 = 0;
ExplosionMagicStructure.unknownD4 = 0;
ExplosionMagicStructure.unknownD8 = 0;
ExplosionMagicStructure.unknownDC = 0;
ExplosionMagicStructure.unknownE0 = 0;
ExplosionMagicStructure.unknownE4 = 0;
ExplosionMagicStructure.unknownE8 = 0;
ExplosionMagicStructure.unknownEC = 0;
ExplosionMagicStructure.unknownF0 = 0;
ExplosionMagicStructure.unknownF4 = 0;
ExplosionMagicStructure.unknownF8 = 0;
ExplosionMagicStructure.unknownFC = 0;
ExplosionMagicStructure.unknown100 = 0;
ExplosionMagicStructure.unknown104 = 0;
ExplosionMagicStructure.unknown108 = 0;
ExplosionMagicStructure.unknown10C = 0;
ExplosionMagicStructure.unknown110 = 0;
ExplosionMagicStructure.unknown114 = 0;
ExplosionMagicStructure.unknown118 = 0;
ExplosionMagicStructure.unknown11C = 0;
ExplosionMagicStructure.unknown120 = 0;
ExplosionMagicStructure.unknown124 = 0;
ExplosionMagicStructure.unknown128 = 0;
ExplosionMagicStructure.unknown12C = 0;
ExplosionMagicStructure.unknown130 = 0;
ExplosionMagicStructure.unknown134 = 0;
ExplosionMagicStructure.unknown138 = 0;
ExplosionMagicStructure.unknown13C = 0;
ExplosionMagicStructure.unknown140 = 0;
ExplosionMagicStructure.unknown144 = 0;
ExplosionMagicStructure.unknown148 = 0;
ExplosionMagicStructure.unknown14C = 0;
ExplosionMagicStructure.unknown150 = 0;
ExplosionMagicStructure.unknown154 = 0;
ExplosionMagicStructure.unknown158 = 0;
ExplosionMagicStructure.unknown15C = 0;
ExplosionMagicStructure.unknown160 = 0;
ExplosionMagicStructure.unknown164 = 0;
ExplosionMagicStructure.unknown168 = 0;
ExplosionMagicStructure.unknown16C = 0;
ExplosionMagicStructure.unknown170 = 0;
ExplosionMagicStructure.unknown174 = 0;
ExplosionMagicStructure.unknown178 = 0;
ExplosionMagicStructure.unknown17C = 0;
ExplosionMagicStructure.unknown180 = 0;
ExplosionMagicStructure.unknown184 = 0;
ExplosionMagicStructure.unknown188 = 0;
ExplosionMagicStructure.unknown18C = 0;
ExplosionMagicStructure.unknown190 = 0;
ExplosionMagicStructure.unknown194 = 0;
ExplosionMagicStructure.unknown198 = 0;
ExplosionMagicStructure.unknown19C = 0;
ExplosionMagicStructure.unknown1A0 = 0;
ExplosionMagicStructure.unknown1A4 = 0;
ExplosionMagicStructure.unknown1A8 = 0;
ExplosionMagicStructure.unknown1AC = 0;
ExplosionMagicStructure.unknown1B0 = 0;
ExplosionMagicStructure.unknown1B4 = 0;
ExplosionMagicStructure.unknown1B8 = 0;
ExplosionMagicStructure.unknown1BC = 0;
ExplosionMagicStructure.unknown1C0 = 0;
ExplosionMagicStructure.unknown1C4 = 0;
ExplosionMagicStructure.unknown1C8 = 0;
ExplosionMagicStructure.unknown1CC = 0;

--ID: 99 Name1: Spin Dash Name2: Spin Dash
local SpinDashStruct = WeaponStruct.new()
SpinDashStruct.panelRow = 0;
SpinDashStruct.unknownC = 0;
SpinDashStruct.unknown10 = 1;
SpinDashStruct.unknown14 = 1;
SpinDashStruct.unknown18 = 1;
SpinDashStruct.unknown1C = 3000;
SpinDashStruct.unknown20 = 1;
SpinDashStruct.unknown24 = 0;
SpinDashStruct.unknown28 = 1;
SpinDashStruct.unknown2C = 0;
SpinDashStruct.unknown30 = 4;
SpinDashStruct.unknown34 = 14;
SpinDashStruct.unknown38 = 0;
SpinDashStruct.unknown3C = 0;
SpinDashStruct.unknown40 = 0;
SpinDashStruct.unknown44 = 0;
SpinDashStruct.unknown48 = 0;
SpinDashStruct.unknown4C = 0;
SpinDashStruct.unknown50 = 0;
SpinDashStruct.unknown54 = 0;
SpinDashStruct.unknown58 = 0;
SpinDashStruct.unknown5C = 0;
SpinDashStruct.unknown60 = 0;
SpinDashStruct.unknown64 = 0;
SpinDashStruct.unknown68 = 0;
SpinDashStruct.unknown6C = 0;
SpinDashStruct.unknown70 = 0;
SpinDashStruct.unknown74 = 0;
SpinDashStruct.unknown78 = 0;
SpinDashStruct.unknown7C = 0;
SpinDashStruct.unknown80 = 0;
SpinDashStruct.unknown84 = 0;
SpinDashStruct.unknown88 = 0;
SpinDashStruct.unknown8C = 0;
SpinDashStruct.unknown90 = 0;
SpinDashStruct.unknown94 = 0;
SpinDashStruct.unknown98 = 0;
SpinDashStruct.unknown9C = 0;
SpinDashStruct.unknownA0 = 0;
SpinDashStruct.unknownA4 = 0;
SpinDashStruct.unknownA8 = 0;
SpinDashStruct.unknownAC = 0;
SpinDashStruct.unknownB0 = 0;
SpinDashStruct.unknownB4 = 0;
SpinDashStruct.unknownB8 = 0;
SpinDashStruct.unknownBC = 0;
SpinDashStruct.unknownC0 = 0;
SpinDashStruct.unknownC4 = 0;
SpinDashStruct.unknownC8 = 0;
SpinDashStruct.unknownCC = 0;
SpinDashStruct.unknownD0 = 0;
SpinDashStruct.unknownD4 = 0;
SpinDashStruct.unknownD8 = 0;
SpinDashStruct.unknownDC = 0;
SpinDashStruct.unknownE0 = 0;
SpinDashStruct.unknownE4 = 0;
SpinDashStruct.unknownE8 = 0;
SpinDashStruct.unknownEC = 0;
SpinDashStruct.unknownF0 = 0;
SpinDashStruct.unknownF4 = 0;
SpinDashStruct.unknownF8 = 0;
SpinDashStruct.unknownFC = 0;
SpinDashStruct.unknown100 = 0;
SpinDashStruct.unknown104 = 0;
SpinDashStruct.unknown108 = 0;
SpinDashStruct.unknown10C = 0;
SpinDashStruct.unknown110 = 0;
SpinDashStruct.unknown114 = 0;
SpinDashStruct.unknown118 = 0;
SpinDashStruct.unknown11C = 0;
SpinDashStruct.unknown120 = 0;
SpinDashStruct.unknown124 = 0;
SpinDashStruct.unknown128 = 0;
SpinDashStruct.unknown12C = 0;
SpinDashStruct.unknown130 = 0;
SpinDashStruct.unknown134 = 0;
SpinDashStruct.unknown138 = 0;
SpinDashStruct.unknown13C = 0;
SpinDashStruct.unknown140 = 0;
SpinDashStruct.unknown144 = 0;
SpinDashStruct.unknown148 = 0;
SpinDashStruct.unknown14C = 0;
SpinDashStruct.unknown150 = 0;
SpinDashStruct.unknown154 = 0;
SpinDashStruct.unknown158 = 0;
SpinDashStruct.unknown15C = 0;
SpinDashStruct.unknown160 = 0;
SpinDashStruct.unknown164 = 0;
SpinDashStruct.unknown168 = 0;
SpinDashStruct.unknown16C = 0;
SpinDashStruct.unknown170 = 0;
SpinDashStruct.unknown174 = 0;
SpinDashStruct.unknown178 = 0;
SpinDashStruct.unknown17C = 0;
SpinDashStruct.unknown180 = 0;
SpinDashStruct.unknown184 = 0;
SpinDashStruct.unknown188 = 0;
SpinDashStruct.unknown18C = 0;
SpinDashStruct.unknown190 = 0;
SpinDashStruct.unknown194 = 0;
SpinDashStruct.unknown198 = 0;
SpinDashStruct.unknown19C = 0;
SpinDashStruct.unknown1A0 = 0;
SpinDashStruct.unknown1A4 = 0;
SpinDashStruct.unknown1A8 = 0;
SpinDashStruct.unknown1AC = 0;
SpinDashStruct.unknown1B0 = 0;
SpinDashStruct.unknown1B4 = 0;
SpinDashStruct.unknown1B8 = 0;
SpinDashStruct.unknown1BC = 0;
SpinDashStruct.unknown1C0 = 0;
SpinDashStruct.unknown1C4 = 0;
SpinDashStruct.unknown1C8 = 0;
SpinDashStruct.unknown1CC = 0;

local JumpStruct = WeaponStruct.new()
JumpStruct.panelRow = 0;
JumpStruct.unknownC = 1;
JumpStruct.unknown10 = 1;
JumpStruct.unknown14 = 1;
JumpStruct.unknown18 = 0;
JumpStruct.unknown1C = 0;
JumpStruct.unknown20 = 1;
JumpStruct.unknown24 = 0;
JumpStruct.unknown28 = 1;
JumpStruct.unknown2C = 0;
JumpStruct.unknown30 = 1;
JumpStruct.unknown34 = 2;
JumpStruct.unknown38 = 3;
JumpStruct.unknown3C = 2;
JumpStruct.unknown40 = 0;
JumpStruct.unknown44 = 0;
JumpStruct.unknown48 = 0;
JumpStruct.unknown4C = 0;
JumpStruct.unknown50 = 0;
JumpStruct.unknown54 = 0;
JumpStruct.unknown58 = 0;
JumpStruct.unknown5C = 0;
JumpStruct.unknown60 = 0;
JumpStruct.unknown64 = 0;
JumpStruct.unknown68 = 0;
JumpStruct.unknown6C = 0;
JumpStruct.unknown70 = 0;
JumpStruct.unknown74 = 0;
JumpStruct.unknown78 = 0;
JumpStruct.unknown7C = 0;
JumpStruct.unknown80 = 0;
JumpStruct.unknown84 = 0;
JumpStruct.unknown88 = -1;
JumpStruct.unknown8C = -1;

function lobbyHostCli(lobbyObj, command, args)
	io.write(string.format("lobbyhostcli: %s args: %s\n", command, args))
	return 0
end

function lobbyClientCli(lobbyObj, command, args)
	io.write(string.format("lobbyclientcli: %s args: %s\n", command, args))
	return 0
end

function writeConfig()
	io.write(string.format("writeConfig\n"))
	local test = 1000-7
	return json.encode({test = test})
end

function readConfig(config)
	io.write(string.format("readConfig: %s\n", config))
	return 0
end

function resetConfig()
	io.write(string.format("resetConfig\n"))
	return 0
end

function onChatInput(msg)
	io.write(string.format("onChatInput: %s\n", msg))
	--showChatMessage("Test", 2)
end

		TaskMessage_None = 0 
		TaskMessage_FrameStart=1 
		TaskMessage_FrameFinish=2 
		TaskMessage_RenderScene=3 
		TaskMessage_ProcessInput=4 
		TaskMessage_UpdateNonCritical=5 
		TaskMessage_MachineFinished=6 
		TaskMessage_CrateCollected=7 
		TaskMessage_StateChecksum=8 
		TaskMessage_MachineReady=9 

		TaskMessage_WormDrowned = 11 
		TaskMessage_FrameNumber=12 
		TaskMessage_MachineQuit=13 
		TaskMessage_EnableCheat=14 
		TaskMessage_PlayerChat=15 
		TaskMessage_CameraAuto=16 
		TaskMessage_CursorMoved=17 
		TaskMessage_GirderChanged=18 
		TaskMessage_StrikeChanged=19 
		TaskMessage_TeamVictory=20 
		TaskMessage_GameOver=21 
		TaskMessage_ExitMode=22 
		TaskMessage_Hurry=23 
		--24 runs once on a new turn but I dunno wtf it is
		--25 is mia

		TaskMessage_ThinkingShow = 26 
		TaskMessage_ThinkingHide=27 
		TaskMessage_Explosion=28 
		TaskMessage_ExplosionReport=29 
		TaskMessage_MoveLeft=30 
		TaskMessage_MoveRight=31 
		TaskMessage_MoveUp=32 
		TaskMessage_MoveDown=33 
		TaskMessage_FaceLeft=34 
		TaskMessage_FaceRight=35 
		TaskMessage_Jump=36 
		TaskMessage_JumpUp=37 
		TaskMessage_FireWeapon=38 
		TaskMessage_ReleaseWeapon=39 
		TaskMessage_SkipGo=40 
		TaskMessage_Freeze=41  --added
		--42 runs once on a new turn but I dunno wtf it is
		
		TaskMessage_Surrender = 43 
		TaskMessage_DetonateWeapon=44 
		TaskMessage_MoveWeaponLeft=45 
		TaskMessage_MoveWeaponRight=46 
		TaskMessage_SelectFuse=47 
		TaskMessage_SelectHerd=48 
		TaskMessage_SelectBounce=49 
		TaskMessage_SelectCursor=50 
		TaskMessage_SelectWeapon=51 
		TaskMessage_StartTurn=52 
		TaskMessage_PauseTurn=53 
		TaskMessage_ResumeTurn=54 
		TaskMessage_FinishTurn=55 
		TaskMessage_TurnStarted=56 
		TaskMessage_TurnFinished=57 
		TaskMessage_SuddenDeath=58 
		TaskMessage_DamageWorms=59 
		TaskMessage_RetreatStarted=60 
		TaskMessage_RetreatFinished=61 
		TaskMessage_ApplyPoison=62 
		TaskMessage_SetWorm=63 
		TaskMessage_KillWorm=64 


		TaskMessage_AdvanceWorm = 67 
		TaskMessage_ShowDamage=68 
		TaskMessage_EnableWeapons=69 
		TaskMessage_DisableWeapons=70 
		TaskMessage_WormMoved=71 
		TaskMessage_WormDamaged=72 
		TaskMessage_WeaponReleased=73 
		TaskMessage_WeaponFinished=74 
		TaskMessage_SpecialImpact=75 
		TaskMessage_WeaponCreated=76 
		TaskMessage_WeaponHoming=77 
		TaskMessage_WeaponDestroyed=78 
		TaskMessage_WeaponClaimControl=79 
		TaskMessage_WeaponReleaseControl=80 
		TaskMessage_PoisonWorm=81 


		TaskMessage_SetWind = 84 
		TaskMessage_GameText=85 
		TaskMessage_CreateAnimation=86 

		TaskMessage_BringForward = 88 
		TaskMessage_RaiseWater=89 
		TaskMessage_NukeBlast=90 
		TaskMessage_Armageddon=91 
		TaskMessage_DetonateCrate=92 
		TaskMessage_Earthquake=93 
		TaskMessage_ScalesOfJustice=94 

		TaskMessage_PauseTimer = 96 
		TaskMessage_ResumeTimer=97 
		TaskMessage_MoveSpecial=98 
		TaskMessage_StateWrongChecksum=99 
		TaskMessage_UpdateTween=100 
		TaskMessage_ProcessInputTween=101 
		TaskMessage_TimeReceivedObsolete=102 
		TaskMessage_Transferred=103 
		TaskMessage_TransferTimeFreq=104 
		TaskMessage_UpdatePanelTween=105 
		TaskMessage_StateWrongInitChecksum=106 
		TaskMessage_FrameFinishFiller=107 
		TaskMessage_MachineEvent=108 
		TaskMessage_InvalidDataCompressed=109 
		TaskMessage_InvalidDataUncompressed=110 
		TaskMessage_PacketIndexJump=111 
		TaskMessage_CancelPending=112 
		TaskMessage_BulletExplosion=113 
		TaskMessage_FrameNumberWinsock=114
		
		
		--127 airstrike
		--131 airstrike
		--132 airstrike
local tab ={}
local cnt = 0

local shotsindadark = {
"unknownC",
"unknown10",
"unknown14",
"unknown18",
"unknown1C",
"unknown20",
"unknown24",
"unknown28",
"unknown2C",
"unknown30",
"unknown34",
"unknown38",
"unknown3C",
"unknown40",
"unknown44",
"unknown48",
"unknown4C",
"unknown50",
"unknown54",
"unknown58",
"unknown5C",
"unknown60",
"unknown64",
"unknown68",
"unknown6C",
"unknown70",
"unknown74",
"unknown78",
"unknown7C",
"unknown80",
"unknown84",
"unknown88",
"unknown8C",
"unknown90",
"unknown94",
"unknown98",
"unknown9C",
"unknownA0",
"unknownA4",
"unknownA8",
"unknownAC",
"unknownB0",
"unknownB4",
"unknownB8",
"unknownBC",
"unknownC0",
"unknownC4",
"unknownC8",
"unknownCC",
"unknownD0",
"unknownD4",
"unknownD8",
"unknownDC",
"unknownE0",
"unknownE4",
"unknownE8",
"unknownEC",
"unknownF0",
"unknownF4",
"unknownF8",
"unknownFC",
"unknown100",
"unknown104",
"unknown108",
"unknown10C",
"unknown110",
"unknown114",
"unknown118",
"unknown11C",
"unknown120",
"unknown124",
"unknown128",
"unknown12C",
"unknown130",
"unknown134",
"unknown138",
"unknown13C",
"unknown140",
"unknown144",
"unknown148",
"unknown14C",
"unknown150",
"unknown154",
"unknown158",
"unknown15C",
"unknown160",
"unknown164",
"unknown168",
"unknown16C",
"unknown170",
"unknown174",
"unknown178",
"unknown17C",
"unknown180",
"unknown184",
"unknown188",
"unknown18C",
"unknown190",
"unknown194",
"unknown198",
"unknown19C",
"unknown1A0",
"unknown1A4",
"unknown1A8",
"unknown1AC",
"unknown1B0",
"unknown1B4",
"unknown1B8",
"unknown1BC",
"unknown1C0",
"unknown1C4",
"unknown1C8",
"unknown1CC",
}

--this.__name: sol.CTaskTurnGame*


local mt = {
    -- __index metamethod to access elements
    __index = function(tbl, key)
            return tbl._data[key]  -- Return the first element of _data table
    end,
    -- __newindex metamethod to set elements
    __newindex = function(tbl, key, value)
            tbl._data[key] = value  -- Set the first element of _data table
    end
}

-- Create a function to create userdata with the desired structure
local function create_userdata(value)
    local udata = {_data = {value}}  -- Create a table with _data field
    setmetatable(udata, mt)  -- Set the metatable
    return udata
end

function Message(This, sender, messagetype, psize, params)
	if (not tab[tostring(This.__name) .. tostring(messagetype)]) then
		io.write(messagetype .. "//" .. tostring(psize) .. "\n")
		tab[tostring(This.__name) .. tostring(messagetype)] = true
		cnt = cnt +1
		--playSoundLocal(0x10000, 0x10000, This, weapon_select_sound, 8)
		--showChatMessage("message: " .. messagetype .. "/" .. cnt, 2)
		io.write(tostring(This.__name) .. ": " .. tostring(messagetype) .. "/" .. cnt .. "\n", 2)
		--for i,e in pairs(getmetatable(This)) do
			--	io.write(i .. ": " .. tostring(e) .. " \n", 2)
		--end
		--return 0		
	end
	if ((messagetype > 81) and(messagetype < 84)) or(messagetype == 65)or(messagetype == 95) or (messagetype == 66) or (messagetype == 25) then
	 io.write(tostring(This.__name) .. "-->" .. messagetype .. "!!!!!!!",2)
	end
	-- TaskMessage_CrateCollected funneh (no se usan armas hasta el proximo turno
	if (messagetype == TaskMessage_PauseTurn) or (messagetype == TaskMessage_PauseTimer)or (messagetype == TaskMessage_DisableWeapons)or (messagetype == 24) then
		return 1
	end
		--playSoundLocal(0x10000, 0x10000, This, weapon_select_sound, 8)
		--playSoundLocal(0x10000, 0x10000, This, zxc, 8)
		--for i = 1, 10 do
			--showChatMessage("noletmedaem???", 7)
		--end	
		--createExplosion(This, This.posX, This.posY, 100, 30, 1, 1)
		--This.speedY = -50 * 65536
		--This.speedX = 5 * 65536
	
	if messagetype == 30 and SpinDashEnabled == 1 then
		This.unknown44 = 128
		This.speedX = -500000
	end
	
	if messagetype == 31 and SpinDashEnabled == 1 then
		This.unknown44 = 128
		This.speedX = 500000
	end
	
	if messagetype == 51 then
		--showChatMessage("Weapon focused?: " .. messagetype .. "//" .. type(params), 2)
		--playSoundLocal(0x10000, 0x10000, This, weapon_select_sound, 8)
	end
	
	return 0
end  

function explosion_magic(this, custom_logic_weapon)
	if custom_logic_weapon.name1 == "Explosion Magic" then
		playSoundLocal(0x10000, 0x10000, this, megumin_theme, 8)
		for i = 1, 20 do 
			createExplosion(this, math.random (this.posX-300*65536,this.posX+300*65536), math.random (this.posY-300*65536,this.posY+300*65536), 100, 30, 1, 1)
		end	
	end
end

function spin_dash(this, spin_dash)
	if spin_dash.name1 == "Spin Dash" then
		if SpinDashEnabled == 0 then
			SpinDashEnabled = 1
			return 0
		end
		if SpinDashEnabled == 1 then
			SpinDashEnabled = 0
			return 0
		end
	end
end

function jump(this, jump_structure,jump_info)
	if jump_structure.name1 == "Jump" then
		this.speedX = jump_info.unknown10
		this.speedY = jump_info.unknown14
	end
end




local weapdark = {
"unknown320",
"unknown108",
"unknownF0",
"unknown10C",
"unknown21C",
"unknown374",
"unknown3A8",
"unknown168",
"unknown1B4",
"unknown1F0",
"unknown1E8",
"unknownFC:",
"unknown3C8",
"unknown1BC",
"unknown38C",
"unknown238",
"unknown31C",
"unknown2C8",
"unknown358",
"unknown3B0",
"unknown2C0",
"unknown12C",
"unknown19C",
"unknown198",
"unknown364",
"unknown150",
"unknown100",
"unknown33C",
"unknown124",
"unknown1F8",
"unknown2F0",
"unknown2F4",
"unknownF4:",
"unknown25C",
"unknown384",
"unknown3C4",
"unknown224",
"unknown1A8",
"unknown348",
"unknown1EC",
"unknown378",
"unknown2C4",
"unknown2CC",
"unknown210",
"unknown104",
"unknown14C",
"unknown26C",
"unknown3C0",
"unknown268",
"unknown154",
"unknown360",
"unknown1E0",
"unknown1C0",
"unknown174",
"unknown3F8",
"unknown3F4",
"unknown164",
"unknown3F0",
"unknown3EC",
"unknown138",
"unknown3E4",
"unknown158",
"unknown3E0",
"unknown270",
"unknown278",
"unknown228",
"unknown264",

"unknown3AC",
"unknown30C",
"unknown220",
"unknown1D4",
"unknown180",
"unknown13C",
"unknown144",
"unknown3CC",
"unknown1DC",
"unknown3BC",
"unknown15C",
"unknown29C",
"unknown3B4",

"unknown160",
"unknown3D4",
"unknown1B8",
"unknown2FC",
"unknown1A0",
"unknown3A0",
"unknown2E4",
"unknown248",
"unknown39C",
"unknown388",
"unknown398",
"unknown1FC",
"unknown390",
"unknown380",
"unknown27C",
"unknown36C",
"unknown370",
"unknown368",
"unknown230",
"unknown35C",
"unknown118",
"unknown2AC",
"unknown354",
"unknown298",
"unknown288",
"unknown11C",
"unknown148",
"unknown1B0",
"unknown344",
"unknown2F8",
"unknown120",
"unknown2A4",
"unknown340",
"unknown300",
"unknown204",
"unknown334",
"unknown1D8",
"unknown2B0",
"unknown130",
"unknown24C",
"unknown330",
"unknown294",
"unknown190",
"unknown110",
"unknown328",
"unknown314",
"unknown1AC",
"unknown244",
"unknown234",
"unknown1E4",
"unknown318",
"unknown1C8",
"unknown1C4",
"unknown324",
"unknown1D0",
"unknown310",
"unknown308",
"unknown250",
"unknown1A4",
"unknown304",
"unknown338",
"unknown2A8",
"unknown3A4",
"unknown3D8",
"unknown218",
"unknown2E0",
"unknown2E8",
"unknown2DC",
"unknown3D0",
"unknown2D4",
"unknown2D0",
"unknown17C",
"unknown3DC",
"unknown214",

"unknown178",
"unknown2BC",

"unknown2B8",
"unknown23C",
"unknown260",
"unknownF8:",

"unknown2B4",
"unknown258",
"unknown200",
"unknown37C",
"unknown194",
"unknown114",
"unknown3B8",
"unknown2D8",
"unknown188",
"unknown1F4",
"unknown350",

"unknown128",
"unknown284",
"unknown2EC",
"unknown16C",
"unknown134",
"unknown274",
"unknown1CC",
"unknown18C",
"unknown2A0",
"unknown280",

"unknown34C",
"unknown3E8",
"unknown22C",
"unknown290",
"unknown254",
"unknown28C",
"unknown240",
"unknown184",
"unknown20C",
"unknown32C",
"unknown208",
"unknown170",
"unknown394",
"unknown140",
}

local tst = 10
function weapcall(This, sender)
	for i,e in pairs(WeaponStruct) do
		io.write("YOOOO:" .. i .. ": " .. tostring(e) .. " \n", 2)
	end
	--if (messagetype == TaskMessage_SelectWeapon) then
		--for i,e in pairs(getmetatable(This)) do
			--io.write("YOOOO:" .. i .. ": " .. tostring(tonumber(e) or -1) .. " \n", 2)
			--if type(e) == "function" and (string.find(i, "unknown")) then
				--io.write("YOOOO:" .. i .. ": " .. tostring(e(This) or -1) .. " \n", 2)
			--end
		--end
		--io.write("YOOOOOOO:"..tostring(This.__name))
		--sender.unknown58 = 1
		--sender.unknown34 = 3
--sender.unknown5C = 100 --bullet powa		
	--	sender.unknownC = 1;
--sender.unknown10 = 1;
sender.unknown14 = 1; --shots
--sender.unknown18 = 1;
--sender.unknown1C = 3000;
--sender.unknown20 = 1;
--sender.unknown24 = 0;
--sender.unknown28 = 1;
--sender.unknown2C = 0;
--sender.unknown30 = 1;
--sender.unknown34 = 4; --weapon type
--sender.unknown38 = 2;
--sender.unknown3C = 100;
--sender.unknown40 = 0;
--sender.unknown44 = 0;
--sender.unknown48 = 1;
--sender.unknown4C = 0;
--sender.unknown50 = 4332670;
--sender.unknown54 = 0;
--sender.unknown58 = 300;
		
		for i,e in ipairs(weapdark) do
			if ((i < tst)) and This[e] then
				--showChatMessage(sender.name1 .. "sdsd" .. i .. ":" .. e ,2)
				sender[e] = 1
			end
		end
		tst = tst + 1
		--return 0
	--end
end

function initialize()
	registerCallback_fireWeapon(weapcall)
	registerCallback_fireWeapon(explosion_magic)
	registerCallback_fireWeapon(spin_dash)
	registerCallback_fireWeapon(jump)
	
	CTaskTurnGame_RegisterCallback_vtable8(Message)
	--CTaskTurnGame_RegisterCallback_vtable0(Message)
	--CTaskTurnGame_RegisterCallback_vtable4(Message)
	--CTaskTurnGame_RegisterCallback_vtableC(Message)
	--CTaskTurnGame_RegisterCallback_vtable10(Message)
	--CTaskTurnGame_RegisterCallback_vtable14(Message)
	--CTaskTurnGame_RegisterCallback_vtable18(Message)
	--CTaskTeam_RegisterCallback_vtable0(Message)
	--CTaskTeam_RegisterCallback_vtable4(Message)
	CTaskTeam_RegisterCallback_vtable8(Message)
	--CTaskTeam_RegisterCallback_vtableC(Message)
	--CTaskTeam_RegisterCallback_vtable10(Message)
	--CTaskTeam_RegisterCallback_vtable14(Message)
	--CTaskTeam_RegisterCallback_vtable18(Message)
	
	CTaskWorm_RegisterCallback_vtable8(Message)
	CTaskMine_RegisterCallback_vtable8(Message)
	CTaskFire_RegisterCallback_vtable8(Message)
	CTaskSmoke_RegisterCallback_vtable8(Message)
	CTaskSpriteAnimation_RegisterCallback_vtable8(Message)
	CTaskGass_RegisterCallback_vtable8(Message)
	CTaskCloud_RegisterCallback_vtable8(Message)
	CTaskDirt_RegisterCallback_vtable8(Message)
	CTaskFireBall_RegisterCallback_vtable8(Message)
	CTaskScoreBubble_RegisterCallback_vtable8(Message)
	CTaskSeaBubble_RegisterCallback_vtable8(Message)
	CTaskArrow_RegisterCallback_vtable8(Message)
	CTaskLand_RegisterCallback_vtable8(Message)
	CTaskCanister_RegisterCallback_vtable8(Message)
	CTaskCrate_RegisterCallback_vtable8(Message)
	CTaskCross_RegisterCallback_vtable8(Message)
	CTaskOildrum_RegisterCallback_vtable8(Message)
	CTaskOldWorm_RegisterCallback_vtable8(Message)
	CTaskMissile_RegisterCallback_vtable8(Message)
	CTaskCPU_RegisterCallback_vtable8(Message)
	CTaskFilter_RegisterCallback_vtable8(Message)
	CTaskFlame_RegisterCallback_vtable8(Message)
	CTaskAirStrike_RegisterCallback_vtable8(Message)
	
	--sounds must me in the same order as they are in the programm start
	
	customsound = registerCustomSound("DATA/Wav/Effects/cratepop.wav")
	io.write(string.format("customsound:%d\n", customsound))
	
	zxc = registerCustomSound("jelly/sounds/zxc song.wav")
	io.write(string.format("zxW:%d\n", zxc))
	
	pokeball_release_sound = registerCustomSound("jelly/sounds/pokeball release sound.wav")
	io.write(string.format("pokeball_release_sound:%d\n", pokeball_release_sound))
	
	weapon_select_sound = registerCustomSound("jelly/sounds/weapon select sound.wav")
	io.write(string.format("pokeball_sprite:%d\n", pokeball_sprite))
	
	megumin_theme = registerCustomSound("jelly/sounds/megumin theme.wav")
	io.write(string.format("megumin_theme:%d\n", megumin_theme))
	
	--sprites
	
	customsprite = registerCustomSprite("jelly/sprites/test.spr")
	io.write(string.format("customsprite:%d\n", customsprite))
	
	shapka = registerCustomSprite("jelly/sprites/shapka.spr")
	io.write(string.format("shapka:%d\n", shapka))
	
	pokeball_sprite = registerCustomSprite("jelly/sprites/pokeball_sprite.spr")
	io.write(string.format("pokeball_sprite:%d\n", pokeball_sprite))
	
	
	registerCustomWeapon(testWeaponStruct, "jelly/placeholders/weapon25.img", "wpn0 name1", "wpn0 name2")
	registerCustomWeapon(WormstrikeStruct, "jelly/placeholders/weapon0.img", "Worm Strike", "Worm Strike")
	registerCustomWeapon(BazookaStruct, "jelly/placeholders/weapon1.img", "Bazooka Strike", "Bazooka Strike")
	registerCustomWeapon(HomingMissileStruct, "jelly/placeholders/weapon2.img", "Homing Missile Strike", "Homing Missile Strike")
	registerCustomWeapon(MortarStruct, "jelly/placeholders/weapon3.img", "Mortar Strike", "Mortar Strike")
	registerCustomWeapon(HomingPigeonStruct, "jelly/placeholders/weapon4.img", "Homing Pigeon Strike", "Homing Pigeon Strike")
	registerCustomWeapon(SheepLauncherStruct, "jelly/placeholders/weapon5.img", "Sheep Launcher Strike", "Sheep Launcher Strike")
	registerCustomWeapon(GrenadeStruct, "jelly/placeholders/weapon6.img", "Grenade Strike", "Grenade Strike")
	registerCustomWeapon(ClusterBombStruct, "jelly/placeholders/weapon7.img", "Cluster Bomb Strike", "Cluster Bomb Strike")
	registerCustomWeapon(BananaBombStruct, "jelly/placeholders/weapon8.img", "Banana Bomb Strike", "Banana Bomb Strike")
	registerCustomWeapon(DynamiteStruct, "jelly/placeholders/weapon9.img", "Dynamite Strike", "Dynamite Strike")
	registerCustomWeapon(SheepStruct, "jelly/placeholders/weapon10.img", "Sheep Strike", "Sheep Strike")
	registerCustomWeapon(SuperSheepStruct, "jelly/placeholders/weapon11.img", "Super Sheep Strike", "Super Sheep Strike")
	registerCustomWeapon(AquaSheepStruct, "jelly/placeholders/weapon12.img", "Aqua Sheep Strike", "Aqua Sheep Strike")
	registerCustomWeapon(MoleBombStruct, "jelly/placeholders/weapon13.img", "Mole Bomb Strike", "Mole Bomb Strike")
	registerCustomWeapon(SuperBananaStruct, "jelly/placeholders/weapon14.img", "Super Banana Bomb Strike", "Super Banana Strike")
	registerCustomWeapon(HolyGrenadeStruct, "jelly/placeholders/weapon15.img", "Holy Hand-Grenade Strike", "Holy Grenade Strike")
	registerCustomWeapon(SalvationArmyStruct, "jelly/placeholders/weapon16.img", "Salvation Army Strike", "Salvation Army Strike")
	registerCustomWeapon(PetrolBombStruct, "jelly/placeholders/weapon17.img", "Petrol Bomb Strike", "Petrol Bomb Strike")
	registerCustomWeapon(SkunkStruct, "jelly/placeholders/weapon18.img", "Skunk Strike", "Skunk Strike")
	registerCustomWeapon(MingVaseStruct, "jelly/placeholders/weapon19.img", "Priceless Ming Vase Strike", "Ming Vase Strike")
	registerCustomWeapon(MadCowStruct, "jelly/placeholders/weapon20.img", "Mad Cow Strike", "Mad Cow Strike")
	registerCustomWeapon(OldWomanStruct, "jelly/placeholders/weapon21.img", "Old Woman Strike", "Old Woman Strike")
	registerCustomWeapon(MagicBullet, "jelly/placeholders/weapon22.img", "Patsy's Magic Bullet Strike", "Magic Bullet Strike")
	registerCustomWeapon(ArmageddonStrikeStruct, "jelly/placeholders/weapon27.img", "Armageddon Strike", "Armageddon Strike")
	registerCustomWeapon(PokeballSheepStruct, "jelly/placeholders/pokeball.img", "Pokeball Sheep", "Pokeball Sheep")
	registerCustomWeapon(PokeballSuperSheepStruct, "jelly/placeholders/pokeball.img", "Pokeball SuperSheep", "Pokeball SuperSheep")
	registerCustomWeapon(LaserGunStructure, "jelly/placeholders/weapon23.img", "Laser Gun", "Laser Gun")
	registerCustomWeapon(BozarGunStructure, "jelly/placeholders/weapon24.img", "Bozar", "Bozar")
	registerCustomWeapon(ExplosionMagicStructure, "jelly/placeholders/weapon25.img", "Explosion Magic", "Explosion Magic")
	--registerCustomWeapon(SpinDashStruct, "jelly/placeholders/Spindash.img", "Spin Dash", "Spin Dash")
	registerCustomWeapon(JumpStruct, "jelly/placeholders/Jump.img", "Jump", "Jump")
	return 0
end


--lua->set_function("showChatMessage", &callShowChatMessage);
--n\Documents\GitHub\wkJellyWorm\src\CustomWeapons.cpp (1 hit)
--lua->set_function("registerCustomWeapon", &registerCustomWeapon);
--n\Documents\GitHub\wkJellyWorm\src\entities\CGameTask.h (13 hits)
--lua->set_function(#classname "_RegisterCallback_vtable1C", &CGameTask_vtableHooks<classname>::registerCallbackVt1C); \
--lua->set_function(#classname "_RegisterCallback_vtable20", &CGameTask_vtableHooks<classname>::registerCallbackVt20); \
--lua->set_function(#classname "_RegisterCallback_vtable24", &CGameTask_vtableHooks<classname>::registerCallbackVt24); \
--lua->set_function(#classname "_RegisterCallback_vtable28", &CGameTask_vtableHooks<classname>::registerCallbackVt28); \
--lua->set_function(#classname "_RegisterCallback_vtable2C", &CGameTask_vtableHooks<classname>::registerCallbackVt2C); \
--lua->set_function(#classname "_RegisterCallback_vtable30", &CGameTask_vtableHooks<classname>::registerCallbackVt30); \
--lua->set_function(#classname "_RegisterCallback_vtable34", &CGameTask_vtableHooks<classname>::registerCallbackVt34); \
--lua->set_function(#classname "_RegisterCallback_vtable38", &CGameTask_vtableHooks<classname>::registerCallbackVt38); \
--lua->set_function(#classname "_RegisterCallback_vtable3C", &CGameTask_vtableHooks<classname>::registerCallbackVt3C); \
--lua->set_function(#classname "_RegisterCallback_vtable40", &CGameTask_vtableHooks<classname>::registerCallbackVt40); \
--lua->set_function(#classname "_RegisterCallback_vtable44", &CGameTask_vtableHooks<classname>::registerCallbackVt44); \
--lua->set_function(#classname "_RegisterCallback_vtable48", &CGameTask_vtableHooks<classname>::registerCallbackVt48); \
--lua->set_function(#classname "_CastCGameTask", &castCGameTask<classname>);
--n\Documents\GitHub\wkJellyWorm\src\entities\CTask.cpp (1 hit)
--lua->set_function("getHashStoreObject", &callGetHashStoreObject);
--n\Documents\GitHub\wkJellyWorm\src\entities\CTask.h (8 hits)
--lua->set_function(#classname "_RegisterCallback_vtable0", &CTask_vtableHooks<classname>::registerCallbackVt0); \
--lua->set_function(#classname "_RegisterCallback_vtable4", &CTask_vtableHooks<classname>::registerCallbackVt4); \
--lua->set_function(#classname "_RegisterCallback_vtable8", &CTask_vtableHooks<classname>::registerCallbackVt8); \
--lua->set_function(#classname "_RegisterCallback_vtableC", &CTask_vtableHooks<classname>::registerCallbackVtC); \
--lua->set_function(#classname "_RegisterCallback_vtable10", &CTask_vtableHooks<classname>::registerCallbackVt10); \
--lua->set_function(#classname "_RegisterCallback_vtable14", &CTask_vtableHooks<classname>::registerCallbackVt14); \
--lua->set_function(#classname "_RegisterCallback_vtable18", &CTask_vtableHooks<classname>::registerCallbackVt18); \
--lua->set_function(#classname "_CastCTask", &castCTask<classname>);
--n\Documents\GitHub\wkJellyWorm\src\entities\gametasks\CTaskWorm.cpp (1 hit)
--lua->set_function("CTaskWorm_CastCTask", &castCTask<CTaskWorm>);
--n\Documents\GitHub\wkJellyWorm\src\Explosions.cpp (2 hits)
--lua->set_function("createExplosion", &callCreateExplosion);
--lua->set_function("createSpecialImpact", &hookSpecialImpact);
--n\Documents\GitHub\wkJellyWorm\src\Landscape.cpp (3 hits)
--lua->set_function("writeLandRadius", &callWriteLandRadius);
--lua->set_function("writeLandMaskID", &callWriteLandMaskID);
--lua->set_function("writeLandRaw", &callWriteLandRaw);
--n\Documents\GitHub\wkJellyWorm\src\packages\PackageManager.cpp (10 hits)
--lua->set_function("registerCallback_gameGlobalInit", &Callbacks<&gameGlobalInit_t>::registerCallback);
--lua->set_function("registerCallback_handleCGameTaskPhysics", &Callbacks<&handleCGameTaskPhysics_t>::registerCallback);
--lua->set_function("registerCallback_handleCreateExplosion", &Callbacks<&createExplosion_t>::registerCallback);
--lua->set_function("registerCallback_handleSpecialImpact", &Callbacks<&specialImpact_t>::registerCallback);
--lua->set_function("registerCallback_writeLandRaw", &Callbacks<&writeLandRaw_t>::registerCallback);
--lua->set_function("registerCallback_writeLandMaskID", &Callbacks<&writeLandMaskID_t>::registerCallback);
--lua->set_function("registerCallback_weaponRelease", &Callbacks<&weaponRelease_t>::registerCallback);
--lua->set_function("registerCallback_wormStartFiringWeapon", &Callbacks<&wormStartFiringWeapon_t>::registerCallback);
--lua->set_function("registerCallback_fireWeapon", &Callbacks<&fireWeapon_t>::registerCallback);
--lua->set_function("registerCallback_createWeaponProjectile", &Callbacks<&createWeaponProjectile_t>::registerCallback);
--n\Documents\GitHub\wkJellyWorm\src\Sounds.cpp (2 hits)
--lua->set_function("registerCustomSound", &registerCustomSound);
--lua->set_function("playSoundLocal", &callPlaySoundLocal);
--n\Documents\GitHub\wkJellyWorm\src\Sprites.cpp (3 hits)
--lua->set_function("registerCustomSprite", &registerCustomSprite);
--lua->set_function("drawSpriteLocal", &callDrawSpriteLocal);
--lua->set_function("drawSpriteGlobal", &callDrawSpriteGlobal);
--n\Documents\GitHub\wkJellyWorm\src\Weapons.cpp (1 hit)
--lua->set_function("createWeaponProjectile", &callCreateWeaponProjectile);