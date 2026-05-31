json = require "json"
math.randomseed(getTime())
--helpfull info

--chat commands
--/arma (Armageddon)
--/quake (Earthquake)
--/weapons (Shows weapons addresses)
--/exceptions (??? Make the game freeze)
--/crash (Trying to add to a nullptr address 1?)
--/drawing (Disable world render)

local posmult = 65536
local flipsprite = 1 << 18;
local translatentsprite = 0x200000;
local damagedspmaag = -2147483647

local ispaused = false

local SpinDashEnabled = 0
local customweapons = {}
customweaponsbyname = {}
local customblockwhitelist = {}

--sounds

local stickyworm = {}

local customsound = registerCustomSound("DATA/User/Fanfare/Team17-Applauds.wav")
local customsound2 = registerCustomSound("DATA/Streams/new-win-bronze.wav")
local customsoundtele = registerCustomSound("DATA/Wav/Effects/TELEPORT.wav")
--local zxc = registerCustomSound("DATA/User/Fanfare/Gong.wav")
--local pokeball_release_sound = registerCustomSound("jelly/sounds/pokeball release sound.wav")
--local weapon_select_sound = registerCustomSound("jelly/sounds/weapon select sound.wav")
--local megumin_theme = registerCustomSound("jelly/sounds/megumin theme.wav")
local equino_sfx = registerCustomSound("jelly/sounds/equino.wav")
local LG_sfx = registerCustomSound("jelly/sounds/lowgravity.wav")
local LGoff_sfx = registerCustomSound("jelly/sounds/lowgravityoff.wav")
local equinoscream_sfx = registerCustomSound("jelly/sounds/equinoscream.wav")

local gotmail_sfx = registerCustomSound("jelly/sounds/gotmail.wav")
local afano_sfx = registerCustomSound("jelly/sounds/afano.wav")
local afanop_sfx = registerCustomSound("jelly/sounds/afanoplus.wav")
local sheepme_sfx = registerCustomSound("jelly/sounds/sheepme.wav")
local sentryplace_sfx = registerCustomSound("jelly/sounds/SentryPlace.wav")
local sentryfire1_sfx = registerCustomSound("jelly/sounds/SentryFireLoop_01.wav")
local sentryfiredry1_sfx = registerCustomSound("jelly/sounds/SentryDryFire_05.wav")
local sentryactivate_sfx = registerCustomSound("jelly/sounds/SentryActivate.wav")
local sentrydactivate_sfx = registerCustomSound("jelly/sounds/SentryDeactivate.wav")


--textures

local customsprite = registerCustomSprite("jelly/sprites/teleport.spr")
local shapka = registerCustomSprite("jelly/sprites/shapka.spr")
local pokeball_sprite = registerCustomSprite("jelly/sprites/pokeball_sprite.spr")
local magnet_sprite = registerCustomSprite("jelly/sprites/magnet.spr")
local magnetr_sprite = registerCustomSprite("jelly/sprites/magnetr.spr")
local magnetd_sprite = registerCustomSprite("jelly/sprites/magnetd.spr")
local magnetd_spritelnk = registerCustomSprite("jelly/sprites/wmagnetink.spr")
local magnetd_spritelnkr = registerCustomSprite("jelly/sprites/wmagnetinkr.spr")
local magnetd_spritelnkd = registerCustomSprite("jelly/sprites/wmagnetinkd.spr")
--local magnetd_spritelnkrd = registerCustomSprite("jelly/sprites/wmagnetinkrd.spr")
local magnetd_spritelnku = registerCustomSprite("jelly/sprites/wmagnetinku.spr")
--local magnetd_spritelnkru = registerCustomSprite("jelly/sprites/wmagnetinkru.spr")
local wdrill_sprite = registerCustomSprite("jelly/sprites/wdrill.spr")
local wjetgun_spriteinit = registerCustomSprite("jelly/sprites/jetguninit.spr")
local wjetgun_sprite = registerCustomSprite("jelly/sprites/wjetgun.spr")
local wjetgun_sprite2 = registerCustomSprite("jelly/sprites/wjetgun2.spr")
local wjetgun_sprite3 = registerCustomSprite("jelly/sprites/wjetgun3.spr")
local wjetgun_sprite4 = registerCustomSprite("jelly/sprites/wjetgun4.spr")
local wjetgun_spriteShoot = registerCustomSprite("jelly/sprites/wjetgunshoot.spr") 
local wave_sprite = registerCustomSprite("jelly/sprites/magnetwave.spr")
local equino_sprite = registerCustomSprite("jelly/sprites/equino.spr")
local hook_sprite = registerCustomSprite("jelly/sprites/hook.spr")

	local equinohold = registerCustomSprite("jelly/sprites/equinohold.spr")
	local equinoholdd = registerCustomSprite("jelly/sprites/equinoholdd.spr")
	local equinoholdu = registerCustomSprite("jelly/sprites/equinoholdu.spr")
	
	local turrethold = registerCustomSprite("jelly/sprites/turrethold.spr")
	local turretholdd = registerCustomSprite("jelly/sprites/turretholdd.spr")
	local turretholdu = registerCustomSprite("jelly/sprites/turretholdu.spr")
	
	local turret1hold = registerCustomSprite("jelly/sprites/turret1hold.spr")
	local turret1holdd = registerCustomSprite("jelly/sprites/turret1holdd.spr")
	local turret1holdu = registerCustomSprite("jelly/sprites/turret1holdu.spr")
	
	local estafetahold = registerCustomSprite("jelly/sprites/estafetahold.spr")
	local estafetaholdd = registerCustomSprite("jelly/sprites/estafetaholdd.spr")
	local estafetaholdu = registerCustomSprite("jelly/sprites/estafetaholdu.spr")
	
	local estafeta1hold = registerCustomSprite("jelly/sprites/estafeta1hold.spr")
	local estafeta1holdd = registerCustomSprite("jelly/sprites/estafeta1holdd.spr")
	local estafeta1holdu = registerCustomSprite("jelly/sprites/estafeta1holdu.spr")

local mailmike = {}
mailmike[1] = registerCustomSprite("jelly/sprites/mailmike.spr")
mailmike[2] = registerCustomSprite("jelly/sprites/mailmike1.spr")

local turretspr = {}
turretspr[0] = registerCustomSprite("jelly/sprites/turret0.spr")
turretspr[1] = registerCustomSprite("jelly/sprites/turret.spr")
turretspr[2] = registerCustomSprite("jelly/sprites/turret1.spr")
local turretstand = registerCustomSprite("jelly/sprites/turretstand.spr")
local turretfire = registerCustomSprite("jelly/sprites/turretfire.spr")

local drillup = false
local rerollframe = 0
local vacunastealframe = 0


function gibAll()
	local count = 1
	for i,e in pairs(customweapons) do
		for x=1,6,1 do
			setTeamAmmo(x,e,0,99)
	--		setTeamAmmo(x,e,1,0)
		end
		count = count +1
		if count > 25 then
			--break
		end
		io.write("gave " .. getWeaponData(e).name1 .."("..e..")" .. "\n")
	end
end



-- Build quarter-wave LUT once (256 entries = quarter circle)
-- thanks claude!, lol
local COS_LUT = {}
for i = 0, 256 do
    COS_LUT[i] = math.floor(math.cos(i * math.pi / 512) * 65536 + 0.5)
end

local function convertAngleY(x)
    local half_idx = x * 512 / 65526  -- map to 0..512 (half circle)
    local idx = math.floor(half_idx + 0.5)

    if idx <= 256 then
        return COS_LUT[idx]           -- first quarter: 65536 → 0
    else
        return -COS_LUT[512 - idx]    -- second quarter: 0 → -65536
    end
end

local SIN_LUT = {}
for i = 0, 256 do
    SIN_LUT[i] = math.floor(math.sin(i * math.pi / 512) * 65536 + 0.5)
end
local function convertAngleX(x, dir)
	if not dir then dir = 1 end
    local half_idx = x * 512 / 65526
    local idx = math.floor(half_idx + 0.5)

    if idx <= 256 then
        return SIN_LUT[idx] * dir    -- first quarter: 0 → 65536
    else
        return SIN_LUT[512 - idx] * dir -- second quarter: 65536 → 0
    end
end

--compacted custom values (1 int to 4 0-255)
function setCompactedA(t,p, a)
    t[p] = t[p] & ~(0xFF << 24)      -- clear old A
    t[p] = t[p] | (a << 24)       -- set new A
end

function setCompactedB(t,p, b)
    t[p] = t[p] & ~(0xFF << 16)
    t[p] = t[p] | (b << 16)
end

function setCompactedC(t,p, c)
    t[p] = t[p] & ~(0xFF << 8)
    t[p] = t[p] | (c << 8)
end

function setCompactedD(t,p, d)
    t[p] = t[p] & ~0xFF
    t[p] = t[p] | d
end

function getCompactedA(p) return (p >> 24) & 0xFF end
function getCompactedB(p) return (p >> 16) & 0xFF end
function getCompactedC(p) return (p >> 8)  & 0xFF end
function getCompactedD(p) return p & 0xFF end

--compacted custom values end




		Sound_Morse=1 
		Sound_CrowdPart1=2 
		Sound_CrowdPart2=3 
		Sound_NukePart1=4 
		Sound_NukePart2=5 
		Sound_FrenchAnthem=6 
		Sound_IndianAnthem=7 
		Sound_Twang1=8 
		Sound_Twang2=9 
		Sound_Twang3=10 
		Sound_Twang4=11 
		Sound_Twang5=12 
		Sound_Twang6=13 
		Sound_Cough1=14 
		Sound_Cough2=15 
		Sound_Cough3=16 
		Sound_Cough4=17 
		Sound_Cough5=18 
		Sound_Cough6=19 
		Sound_DonorCardAppears=20 
		Sound_DonorCardCollect=21 
		Sound_FlameThrowerAttack=22 
		Sound_FlameThrowerLoop=23 
		Sound_Freeze=24 
		Sound_UnFreeze=25 
		Sound_JetPackStart=26 
		Sound_JetPackFinish=27 
		Sound_LongbowImpact=28 
		Sound_LongbowRelease=29 
		Sound_NukeFlash=30 
		Sound_ScalesOfJustice=31 
		Sound_UnderWaterLoop=32 
		Sound_VikingAxeImpact=33 
		Sound_VikingAxeRelease=34 
		Sound_WormLanding=35 
		Sound_JetPackLoop1=36 
		Sound_JetPackLoop2=37 
		Sound_MoleBombDiggingLoop=38 
		Sound_MoleBombWalkLoop=39 
		Sound_MoleBombSqueak=40 
		Sound_SkunkGasLoop=41 
		Sound_SkunkWalkLoop=42 
		Sound_SkunkSqueak=43 
		Sound_Armageddon=44 
		Sound_StartRound=45 
		Sound_CameraPan=46 
		Sound_WalkCompress=47 
		Sound_WalkExpand=48 
		Sound_CowMoo=49 
		Sound_SheepBaa=50 
		Sound_PigeonCoo=51 
		Sound_AirStrike=52 
		Sound_BlowTorch=53 
		Sound_WormPop=54 
		Sound_Sizzle=55 
		Sound_SnotPlop=56 
		Sound_Splash=57 
		Sound_Splish=58 
		Sound_Petrol=59 
		Sound_WormBurned=60 
		Sound_SalvationArmy=61 
		Sound_MagicBullet=62 
		Sound_WormSpring=63 
		Sound_VaseSmash=64 
		Sound_OldWoman=65 
		Sound_Fuse=66 
		Sound_Teleport=67 
		Sound_Communicator=68 
		Sound_Explosion1=69 
		Sound_Explosion2=70 
		Sound_Explosion3=71 
		Sound_ThrowPowerup=72 
		Sound_ThrowRelease=73 
		Sound_RocketPowerup=74 
		Sound_RocketRelease=75 
		Sound_SuperSheepRelease=76 
		Sound_SuperSheepWhoosh=77 
		Sound_UziFire=78 
		Sound_MinigunFire=79 
		Sound_ShotgunFire=80 
		Sound_ShotgunReload=81 
		Sound_HandgunFire=82 
		Sound_Ricochet=83 
		Sound_Drill=84 
		Sound_DrillImpact=85 
		Sound_NinjaRopeFire=86 
		Sound_NinjaRopeImpact=87 
		Sound_MineArm=88 
		Sound_MineTick=89 
		Sound_MineDud=90 
		Sound_WeaponHoming=91 
		Sound_PauseTick=92 
		Sound_TimerTick=93 
		Sound_SuddenDeath=94 
		Sound_KamikazeRelease=95 
		Sound_BaseballBatRelease=96 
		Sound_BaseballBatImpact=97 
		Sound_BaseballBatJingle=98 
		Sound_DragonBallRelease=99 
		Sound_DragonBallImpact=100 
		Sound_FirePunchImpact=101 
		Sound_HolyDonkey=102 
		Sound_HolyDonkeyImpact=103 
		Sound_HolyGrenade=104 
		Sound_HolyGrenadeImpact=105 
		Sound_FrozenWormImpact=106 
		Sound_MineImpact=107 
		Sound_WormImpact=108 
		Sound_CrossImpact=109 
		Sound_CrateImpact=110 
		Sound_BananaImpact=111 
		Sound_GirderImpact=112 
		Sound_GrenadeImpact=113 
		Sound_OilDrumImpact=114 
		Sound_CratePop=115 
		Sound_KeyClick=116 
		Sound_KeyErase=117 
		Sound_WormSelect=118 
		Sound_CursorSelect=119 
		Sound_WarningBeep=120 
		Sound_LoadingTick=121 
		Sound_TeamDrop=122 
		Sound_TeamBounce=123 
		Sound_Collect=124 
		Sound_ThrowPowerdown=125 
		Sound_RocketPowerdown=126


		Sprite_cdrom = 1 
		Sprite_crshairr = 2 
		Sprite_crshairb = 3 
		Sprite_crshairg = 4 
		Sprite_crshairy = 5 
		Sprite_crshairp = 6 
		Sprite_crshairc = 7 
		Sprite_spangler = 8 
		Sprite_spangleb = 9 
		Sprite_spangleg = 10 
		Sprite_spangley = 11 
		Sprite_spanglep = 12 
		Sprite_spanglec = 13 
		Sprite_grave1 = 14 
		Sprite_grave2 = 15 
		Sprite_grave3 = 16 
		Sprite_grave4 = 17 
		Sprite_grave5 = 18 
		Sprite_grave6 = 19 
		Sprite_arrowdnr = 20 
		Sprite_arrowdnb = 21 
		Sprite_arrowdng = 22 
		Sprite_arrowdny = 23 
		Sprite_arrowdnp = 24 
		Sprite_arrowdnc = 25 
		Sprite_arrowsdr = 26 
		Sprite_arrowsdb = 27 
		Sprite_arrowsdg = 28 
		Sprite_arrowsdy = 29 
		Sprite_arrowsdp = 30 
		Sprite_arrowsdc = 31 
		Sprite_cursorr = 32 
		Sprite_cursorb = 33 
		Sprite_cursorg = 34 
		Sprite_cursory = 35 
		Sprite_cursorp = 36 
		Sprite_cursorc = 37 
		Sprite_markerr = 38 
		Sprite_markerb = 39 
		Sprite_markerg = 40 
		Sprite_markery = 41 
		Sprite_markerp = 42 
		Sprite_markerc = 43 
		Sprite_cmarker = 44 
		Sprite_mineon = 45 
		Sprite_arrow = 46 
		Sprite_mineoff = 47 
		Sprite_missile = 48 
		Sprite_bullet = 49 
		Sprite_grenade = 50 
		Sprite_banana = 51 
		Sprite_mortar = 52 
		Sprite_cluster = 53 
		Sprite_clustlet = 54 
		Sprite_petrolbm = 55 
		Sprite_hgrenade = 56 
		Sprite_tamborin = 57 
		Sprite_hmissil1 = 58 
		Sprite_hmissil2 = 59 
		Sprite_airmisl = 60 
		Sprite_sheepfal = 61 
		Sprite_carpet1 = 62 
		Sprite_carpet2 = 63 
		Sprite_sheepbrn = 64 
		Sprite_sheeplau = 65 
		Sprite_meteor = 66 
		Sprite_drill = 67 
		Sprite_ropetip = 68 
		Sprite_ropecuff = 69 
		Sprite_phone = 70 
		Sprite_mbbomb = 71 
		Sprite_letter1 = 72 
		Sprite_letter2 = 73 
		Sprite_vase = 74 
		Sprite_vasebit1 = 75 
		Sprite_vasebit2 = 76 
		Sprite_vasebit3 = 77 
		Sprite_dynamite = 78 
		Sprite_firehit = 79 
		Sprite_kamismk = 80 
		Sprite_basehit = 81 
		Sprite_donkey = 82 
		Sprite_fireball = 83 
		Sprite_flame1 = 84 
		Sprite_flame2 = 85 
		Sprite_airjetb = 86 
		Sprite_airjetg = 87 
		Sprite_airjeto = 88 
		Sprite_postbox = 89 
		Sprite_shptruck = 90 
		Sprite_cpttruck = 91 
		Sprite_targets = 92 
		Sprite_targetsv = 93 
		Sprite_targetw = 94 
		Sprite_targetwv = 95 
		Sprite_wcrate1 = 96 
		Sprite_mcrate1 = 97 
		Sprite_ucrate1 = 98 
		Sprite_wcrate2 = 99 
		Sprite_mcrate2 = 100 
		Sprite_ucrate2 = 101 
		Sprite_donor = 102 
		Sprite_wcratev = 103 
		Sprite_mcratev = 104 
		Sprite_ucratev = 105 
		Sprite_fallout = 106 
		Sprite_wcrate0 = 107 
		Sprite_mcrate0 = 108 
		Sprite_ucrate0 = 109 
		Sprite_oildrum1 = 110 
		Sprite_oildrum2 = 111 
		Sprite_oildrum3 = 112 
		Sprite_oildrum4 = 113 
		Sprite_uzihit = 114 
		Sprite_uzicase = 115 
		Sprite_shothit = 116 
		Sprite_shotcase = 117 
		Sprite_wormhit1 = 118 
		Sprite_wormhit2 = 119 
		Sprite_petrol_1 = 120 
		Sprite_petrol_2 = 121 
		Sprite_petrol_3 = 122 
		Sprite_petrol_4 = 123 
		Sprite_petrol1 = 124 
		Sprite_petrol2 = 125 
		Sprite_petrol3 = 126 
		Sprite_petrol4 = 127 
		Sprite_petrol5 = 128 
		Sprite_petrol6 = 129 
		Sprite_exhaust = 130 
		Sprite_hexhaust = 131 
		Sprite_wexhaust = 132 
		Sprite_qexhaust = 133 
		Sprite_feather = 134 
		Sprite_mexhaust = 135 
		Sprite_tcloud = 136 
		Sprite_wwalk = 137 
		Sprite_wwalku = 138 
		Sprite_wwalkd = 139 
		Sprite_wbloww = 140 
		Sprite_wblowwu = 141 
		Sprite_wblowwd = 142 
		Sprite_wblowa = 143 
		Sprite_wblowau = 144 
		Sprite_wblowad = 145 
		Sprite_wbungee = 146 
		Sprite_wbatrope = 147 
		Sprite_wroll = 148 
		Sprite_wfly1 = 149 
		Sprite_wfly2 = 150 
		Sprite_wfly3 = 151 
		Sprite_lshpwlk = 152 
		Sprite_sheepwlk = 153 
		Sprite_spsheep1 = 154 
		Sprite_spsheep2 = 155 
		Sprite_aquashp1 = 156 
		Sprite_aquashp2 = 157 
		Sprite_moledive = 158 
		Sprite_moledig1 = 159 
		Sprite_moledig2 = 160 
		Sprite_moledig3 = 161 
		Sprite_woman = 162 
		Sprite_sally = 163 
		Sprite_cowwalk = 164 
		Sprite_cowjump = 165 
		Sprite_molewalk = 166 
		Sprite_wjetfly1 = 167 
		Sprite_wjetfly2 = 168 
		Sprite_wjetfly3 = 169 
		Sprite_wjetfly4 = 170 
		Sprite_wjetflmb = 171 
		Sprite_wjetflmd = 172 
		Sprite_skunk1 = 173 
		Sprite_skunk2 = 174 
		Sprite_pigeonr0 = 175 
		Sprite_pigeonr1 = 176 
		Sprite_pigeonr2 = 177 
		Sprite_pigeonr3 = 178 
		Sprite_wpbrth = 179 
		Sprite_wpbrthu = 180 
		Sprite_wpbrthd = 181 
		Sprite_wcough = 182 
		Sprite_wcoughu = 183 
		Sprite_wcoughd = 184 
		Sprite_wbrth1 = 185 
		Sprite_wbrth1u = 186 
		Sprite_wbrth1d = 187 
		Sprite_wbrth2 = 188 
		Sprite_wbrth2u = 189 
		Sprite_wbrth2d = 190 
		Sprite_wblink1 = 191 
		Sprite_wblink1u = 192 
		Sprite_wblink1d = 193 
		Sprite_wblink2 = 194 
		Sprite_wblink2u = 195 
		Sprite_wblink2d = 196 
		Sprite_wglnce1 = 197 
		Sprite_wglnce1u = 198 
		Sprite_wglnce1d = 199 
		Sprite_wglnce2 = 200 
		Sprite_wglnce2u = 201 
		Sprite_wglnce2d = 202 
		Sprite_wbghead = 203 
		Sprite_wbgheadu = 204 
		Sprite_wbgheadd = 205 
		Sprite_wfist = 206 
		Sprite_wfistu = 207 
		Sprite_wfistd = 208 
		Sprite_wpeek = 209 
		Sprite_wpeeku = 210 
		Sprite_wpeekd = 211 
		Sprite_wulook = 212 
		Sprite_wulooku = 213 
		Sprite_wulookd = 214 
		Sprite_wolook = 215 
		Sprite_wolooku = 216 
		Sprite_wolookd = 217 
		Sprite_wscarey = 218 
		Sprite_wscareyu = 219 
		Sprite_wscareyd = 220 
		Sprite_wkami1 = 221 
		Sprite_wkami2 = 222 
		Sprite_wkami3 = 223 
		Sprite_wkami4 = 224 
		Sprite_wkami5 = 225 
		Sprite_wscrtch = 226 
		Sprite_wscrtchu = 227 
		Sprite_wscrtchd = 228 
		Sprite_waccuse = 229 
		Sprite_waccuseu = 230 
		Sprite_waccused = 231 
		Sprite_wtache = 232 
		Sprite_wtacheu = 233 
		Sprite_wtached = 234 
		Sprite_wmunch = 235 
		Sprite_wmunchu = 236 
		Sprite_wmunchd = 237 
		Sprite_wlazy = 238 
		Sprite_wlazyu = 239 
		Sprite_wlazyd = 240 
		Sprite_wwinner = 241 
		Sprite_wsurndr = 242 
		Sprite_wsurndru = 243 
		Sprite_wsurndrd = 244 
		Sprite_wsvr = 245 
		Sprite_wsvru = 246 
		Sprite_wsvrd = 247 
		Sprite_wsvb = 248 
		Sprite_wsvbu = 249 
		Sprite_wsvbd = 250 
		Sprite_wsvg = 251 
		Sprite_wsvgu = 252 
		Sprite_wsvgd = 253 
		Sprite_wsvy = 254 
		Sprite_wsvyu = 255 
		Sprite_wsvyd = 256 
		Sprite_wsvp = 257 
		Sprite_wsvpu = 258 
		Sprite_wsvpd = 259 
		Sprite_wsvc = 260 
		Sprite_wsvcu = 261 
		Sprite_wsvcd = 262 
		Sprite_wskipgo = 263 
		Sprite_wskipgou = 264 
		Sprite_wskipgod = 265 
		Sprite_wselect = 266 
		Sprite_wselectu = 267 
		Sprite_wselectd = 268 
		Sprite_wjump = 269 
		Sprite_wjumpu = 270 
		Sprite_wjumpd = 271 
		Sprite_wland1 = 272 
		Sprite_wland1u = 273 
		Sprite_wland1d = 274 
		Sprite_wland2 = 275 
		Sprite_wland2u = 276 
		Sprite_wland2d = 277 
		Sprite_wflylnk = 278 
		Sprite_wbackflp = 279 
		Sprite_wpnclnk = 280 
		Sprite_wpnclnku = 281 
		Sprite_wpnclnkd = 282 
		Sprite_wpnctop = 283 
		Sprite_wpncbak = 284 
		Sprite_wpncbaku = 285 
		Sprite_wpncbakd = 286 
		Sprite_wparalnk = 287 
		Sprite_wparacht = 288 
		Sprite_wparbak = 289 
		Sprite_wparbaku = 290 
		Sprite_wparbakd = 291 
		Sprite_wtwang = 292 
		Sprite_wtwangu = 293 
		Sprite_wtwangd = 294 
		Sprite_wsldlk1 = 295 
		Sprite_wsldlk1u = 296 
		Sprite_wsldlk1d = 297 
		Sprite_wsldlk2 = 298 
		Sprite_wsldlk2u = 299 
		Sprite_wsldlk2d = 300 
		Sprite_wpbrtlk = 301 
		Sprite_wpbrtlku = 302 
		Sprite_wpbrtlkd = 303 
		Sprite_wblowlk = 304 
		Sprite_wblowlku = 305 
		Sprite_wblowlkd = 306 
		Sprite_whatlnk = 307 
		Sprite_whatlnku = 308 
		Sprite_whatlnkd = 309 
		Sprite_wnukelk = 310 
		Sprite_wnukelku = 311 
		Sprite_wnukelkd = 312 
		Sprite_wgrnlnk = 313 
		Sprite_wgrnlnku = 314 
		Sprite_wgrnlnkd = 315 
		Sprite_wclslnk = 316 
		Sprite_wclslnku = 317 
		Sprite_wclslnkd = 318 
		Sprite_wbanlnk = 319 
		Sprite_wbanlnku = 320 
		Sprite_wbanlnkd = 321 
		Sprite_wpbmlnk = 322 
		Sprite_wpbmlnku = 323 
		Sprite_wpbmlnkd = 324 
		Sprite_whgrlnk = 325 
		Sprite_whgrlnku = 326 
		Sprite_whgrlnkd = 327 
		Sprite_wutllnk = 328 
		Sprite_wutllnku = 329 
		Sprite_wutllnkd = 330 
		Sprite_wjetlnk = 331 
		Sprite_wjetlnku = 332 
		Sprite_wjetlnkd = 333 
		Sprite_wdynlnk = 334 
		Sprite_wdynlnku = 335 
		Sprite_wdynlnkd = 336 
		Sprite_wvaslnk = 337 
		Sprite_wvaslnku = 338 
		Sprite_wvaslnkd = 339 
		Sprite_wcowlnk = 340 
		Sprite_wcowlnku = 341 
		Sprite_wcowlnkd = 342 
		Sprite_wshplnk = 343 
		Sprite_wshplnku = 344 
		Sprite_wshplnkd = 345 
		Sprite_wwmnlnk = 346 
		Sprite_wwmnlnku = 347 
		Sprite_wwmnlnkd = 348 
		Sprite_wsknlnk = 349 
		Sprite_wsknlnku = 350 
		Sprite_wsknlnkd = 351 
		Sprite_wmollnk = 352 
		Sprite_wmollnku = 353 
		Sprite_wmollnkd = 354 
		Sprite_wwmn2lk = 355 
		Sprite_wwmn2lku = 356 
		Sprite_wwmn2lkd = 357 
		Sprite_wdrllnk = 358 
		Sprite_wdrllnku = 359 
		Sprite_wdrllnkd = 360 
		Sprite_wdrill = 361 
		Sprite_wprdlnk = 362 
		Sprite_wprdlnku = 363 
		Sprite_wprdlnkd = 364 
		Sprite_wprod = 365 
		Sprite_wprodu = 366 
		Sprite_wprodd = 367 
		Sprite_wprdbk2 = 368 
		Sprite_wprdbk2u = 369 
		Sprite_wprdbk2d = 370 
		Sprite_wkamlnk = 371 
		Sprite_wkamlnku = 372 
		Sprite_wkamlnkd = 373 
		Sprite_wkamjmp = 374 
		Sprite_wkambmr = 375 
		Sprite_wkambmru = 376 
		Sprite_wkambmrd = 377 
		Sprite_wfirbl1 = 378 
		Sprite_wfirbl1u = 379 
		Sprite_wfirbl1d = 380 
		Sprite_wfirbl2 = 381 
		Sprite_wfirbl2u = 382 
		Sprite_wfirbl2d = 383 
		Sprite_wfirair = 384 
		Sprite_wjapbak = 385 
		Sprite_wjapbaku = 386 
		Sprite_wjapbakd = 387 
		Sprite_wminlnk = 388 
		Sprite_wminlnku = 389 
		Sprite_wminlnkd = 390 
		Sprite_wskplnk = 391 
		Sprite_wskplnku = 392 
		Sprite_wskplnkd = 393 
		Sprite_wsellnk = 394 
		Sprite_wsellnku = 395 
		Sprite_wsellnkd = 396 
		Sprite_waxelnk = 397 
		Sprite_waxelnku = 398 
		Sprite_waxelnkd = 399 
		Sprite_waxelk2 = 400 
		Sprite_waxelk2u = 401 
		Sprite_waxelk2d = 402 
		Sprite_waxeswn = 403 
		Sprite_waxeswnu = 404 
		Sprite_waxeswnd = 405 
		Sprite_waxebak = 406 
		Sprite_waxebaku = 407 
		Sprite_waxebakd = 408 
		Sprite_wbndlnk = 409 
		Sprite_wbndlnku = 410 
		Sprite_wbndlnkd = 411 
		Sprite_wairlnk = 412 
		Sprite_wairlnku = 413 
		Sprite_wairlnkd = 414 
		Sprite_wairtlk = 415 
		Sprite_wairtlku = 416 
		Sprite_wairtlkd = 417 
		Sprite_wtellnk = 418 
		Sprite_wtellnku = 419 
		Sprite_wtellnkd = 420 
		Sprite_wteltlk = 421 
		Sprite_wteltlku = 422 
		Sprite_wteltlkd = 423 
		Sprite_wteldsv = 424 
		Sprite_wteldsvu = 425 
		Sprite_wteldsvd = 426 
		Sprite_wthrbak = 427 
		Sprite_wthrbaku = 428 
		Sprite_wthrbakd = 429 
		Sprite_wbsblnk = 430 
		Sprite_wbsblnku = 431 
		Sprite_wbsblnkd = 432 
		Sprite_wbsbbk2 = 433 
		Sprite_wbsbbk2u = 434 
		Sprite_wbsbbk2d = 435 
		Sprite_wbazlnk = 436 
		Sprite_wbazlnku = 437 
		Sprite_wbazlnkd = 438 
		Sprite_wflmlnk = 439 
		Sprite_wflmlnku = 440 
		Sprite_wflmlnkd = 441 
		Sprite_wbz2lnk = 442 
		Sprite_wbz2lnku = 443 
		Sprite_wbz2lnkd = 444 
		Sprite_wbz3lnk = 445 
		Sprite_wbz3lnku = 446 
		Sprite_wbz3lnkd = 447 
		Sprite_wsurlnk = 448 
		Sprite_wsurlnku = 449 
		Sprite_wsurlnkd = 450 
		Sprite_wsvrlnk = 451 
		Sprite_wsvrlnku = 452 
		Sprite_wsvrlnkd = 453 
		Sprite_wsvblnk = 454 
		Sprite_wsvblnku = 455 
		Sprite_wsvblnkd = 456 
		Sprite_wsvglnk = 457 
		Sprite_wsvglnku = 458 
		Sprite_wsvglnkd = 459 
		Sprite_wsvylnk = 460 
		Sprite_wsvylnku = 461 
		Sprite_wsvylnkd = 462 
		Sprite_wsvplnk = 463 
		Sprite_wsvplnku = 464 
		Sprite_wsvplnkd = 465 
		Sprite_wsvclnk = 466 
		Sprite_wsvclnku = 467 
		Sprite_wsvclnkd = 468 
		Sprite_wicelnk = 469 
		Sprite_wicelnku = 470 
		Sprite_wicelnkd = 471 
		Sprite_wicelk2 = 472 
		Sprite_wicelk2u = 473 
		Sprite_wicelk2d = 474 
		Sprite_wicelk3 = 475 
		Sprite_wicelk3u = 476 
		Sprite_wicelk3d = 477 
		Sprite_wicelook = 478 
		Sprite_wiceblnk = 479 
		Sprite_wiceglnt = 480 
		Sprite_wicestnd = 481 
		Sprite_wbatlnk = 482 
		Sprite_wbatlnku = 483 
		Sprite_wbatlnkd = 484 
		Sprite_wbatbk2 = 485 
		Sprite_wbatbk2u = 486 
		Sprite_wbatbk2d = 487 
		Sprite_wuzilnk = 488 
		Sprite_wuzilnku = 489 
		Sprite_wuzilnkd = 490 
		Sprite_wshglnk = 491 
		Sprite_wshglnku = 492 
		Sprite_wshglnkd = 493 
		Sprite_wbowlnk = 494 
		Sprite_wbowlnku = 495 
		Sprite_wbowlnkd = 496 
		Sprite_wbowbk2 = 497 
		Sprite_wbowbk2u = 498 
		Sprite_wbowbk2d = 499 
		Sprite_whgnlnk = 500 
		Sprite_whgnlnku = 501 
		Sprite_whgnlnkd = 502 
		Sprite_wmgnlnk = 503 
		Sprite_wmgnlnku = 504 
		Sprite_wmgnlnkd = 505 
		Sprite_wdie = 506 
		Sprite_skdsmoke = 507 
		Sprite_wflyup = 508 
		Sprite_wflydn = 509 
		Sprite_wfall = 510 
		Sprite_wfalldn = 511 
		Sprite_wpncup = 512 
		Sprite_wslide = 513 
		Sprite_wslideu = 514 
		Sprite_wslided = 515 
		Sprite_wbow = 516 
		Sprite_wbowu = 517 
		Sprite_wbowd = 518 
		Sprite_wbsbaim = 519 
		Sprite_wbsbaimu = 520 
		Sprite_wbsbaimd = 521 
		Sprite_wbsbswn = 522 
		Sprite_wbsbswnu = 523 
		Sprite_wbsbswnd = 524 
		Sprite_wbaz = 525 
		Sprite_wbazu = 526 
		Sprite_wbazd = 527 
		Sprite_wflm = 528 
		Sprite_wflmu = 529 
		Sprite_wflmd = 530 
		Sprite_wbaz2 = 531 
		Sprite_wbaz2u = 532 
		Sprite_wbaz2d = 533 
		Sprite_wbaz3 = 534 
		Sprite_wbaz3u = 535 
		Sprite_wbaz3d = 536 
		Sprite_wbataim = 537 
		Sprite_wbataimu = 538 
		Sprite_wbataimd = 539 
		Sprite_wbatfrd = 540 
		Sprite_wbatfrdu = 541 
		Sprite_wbatfrdd = 542 
		Sprite_wshotg = 543 
		Sprite_wshotgu = 544 
		Sprite_wshotgd = 545 
		Sprite_wshotp = 546 
		Sprite_wshotpu = 547 
		Sprite_wshotpd = 548 
		Sprite_wshotf = 549 
		Sprite_wshotfu = 550 
		Sprite_wshotfd = 551 
		Sprite_wbowp = 552 
		Sprite_wbowpu = 553 
		Sprite_wbowpd = 554 
		Sprite_wbowf = 555 
		Sprite_wbowfu = 556 
		Sprite_wbowfd = 557 
		Sprite_whandg = 558 
		Sprite_whandgu = 559 
		Sprite_whandgd = 560 
		Sprite_whandf = 561 
		Sprite_whandfu = 562 
		Sprite_whandfd = 563 
		Sprite_wuzi = 564 
		Sprite_wuziu = 565 
		Sprite_wuzid = 566 
		Sprite_wuzif = 567 
		Sprite_wuzifu = 568 
		Sprite_wuzifd = 569 
		Sprite_wmini = 570 
		Sprite_wminiu = 571 
		Sprite_wminid = 572 
		Sprite_wminif = 573 
		Sprite_wminifu = 574 
		Sprite_wminifd = 575 
		Sprite_wthrgrn = 576 
		Sprite_wthrgrnu = 577 
		Sprite_wthrgrnd = 578 
		Sprite_wthrcls = 579 
		Sprite_wthrclsu = 580 
		Sprite_wthrclsd = 581 
		Sprite_wthrban = 582 
		Sprite_wthrbanu = 583 
		Sprite_wthrband = 584 
		Sprite_wthrpbm = 585 
		Sprite_wthrpbmu = 586 
		Sprite_wthrpbmd = 587 
		Sprite_wthrhgr = 588 
		Sprite_wthrhgru = 589 
		Sprite_wthrhgrd = 590 
		Sprite_wthrow = 591 
		Sprite_wthrowu = 592 
		Sprite_wthrowd = 593 
		Sprite_replay = 594 
		Sprite_netbreak = 595 
		Sprite_exfoom = 596 
		Sprite_exbiff = 597 
		Sprite_expoot = 598 
		Sprite_expow = 599 
		Sprite_circle25 = 600 
		Sprite_circle50 = 601 
		Sprite_circle75 = 602 
		Sprite_circl100 = 603 
		Sprite_elipse25 = 604 
		Sprite_elipse50 = 605 
		Sprite_elipse75 = 606 
		Sprite_elips100 = 607 
		Sprite_gassgrn = 608 
		Sprite_smklt25 = 609 
		Sprite_smklt50 = 610 
		Sprite_smklt75 = 611 
		Sprite_smklt100 = 612 
		Sprite_smkdrk20 = 613 
		Sprite_smkdrk30 = 614 
		Sprite_smkdrk40 = 615 
		Sprite_clouds = 616 
		Sprite_cloudm = 617 
		Sprite_cloudl = 618 
		Sprite_blob = 619 
		Sprite_debris = 622 
		Sprite_bubble1 = 623 
		Sprite_bubble2 = 624 
		Sprite_bubble3 = 625 
		Sprite_bubble4 = 626 
		Sprite_wfdrown = 627 
		Sprite_grave1_2 = 628 
		Sprite_grave2_2 = 629 
		Sprite_grave3_2 = 630 
		Sprite_grave4_2 = 631 
		Sprite_grave5_2 = 632 
		Sprite_grave6_2 = 633 
		Sprite_targets_2 = 634 
		Sprite_targetw_2 = 635 
		Sprite_wcrate1_2 = 636 
		Sprite_mcrate1_2 = 637 
		Sprite_ucrate1_2 = 638 
		Sprite_donor_2 = 639 
		Sprite_wdrown = 640 
		Sprite_oildrum = 641 
		Sprite_meteor_2 = 642 
		Sprite_mineon_2 = 643 
		Sprite_mineoff_2 = 644 
		Sprite_missile_2 = 645 
		Sprite_airmisl_2 = 646 
		Sprite_grenade_2 = 647 
		Sprite_mortar_2 = 648 
		Sprite_cluster_2 = 649 
		Sprite_clustlet_2 = 650 
		Sprite_bullet_2 = 651 
		Sprite_arrow_2 = 652 
		Sprite_sheep = 653 
		Sprite_carpet1_2 = 654 
		Sprite_carpet2_2 = 655 
		Sprite_sheepfal_2 = 656 
		Sprite_sheepbrn_2 = 657 
		Sprite_mbbomb_2 = 658 
		Sprite_drill_2 = 659 
		Sprite_woman_2 = 660 
		Sprite_sally_2 = 661 
		Sprite_skunk = 662 
		Sprite_mole = 663 
		Sprite_cowwalk_2 = 664 
		Sprite_pigeonr0_2 = 665 
		Sprite_pigeonr1_2 = 666 
		Sprite_pigeonr2_2 = 667 
		Sprite_pigeonr3_2 = 668 
		Sprite_banana_2 = 669 
		Sprite_petrolbm_2 = 670 
		Sprite_tamborin_2 = 671 
		Sprite_hgrenade_2 = 672 
		Sprite_hmissil1_2 = 673 
		Sprite_hmissil2_2 = 674 
		Sprite_aquashp1_2 = 675 
		Sprite_aquashp2_2 = 676 
		Sprite_vase_2 = 677 
		Sprite_vasebit1_2 = 678 
		Sprite_vasebit2_2 = 679 
		Sprite_vasebit3_2 = 680 
		Sprite_dynamite_2 = 681 
		Sprite_letter1_2 = 682 
		Sprite_letter2_2 = 683 
		Sprite_donkey_2 = 684 
		Sprite_wbaz4 = 685 
		Sprite_wbaz4u = 686 
		Sprite_wbaz4d = 687 
		Sprite_wbaz5 = 688 
		Sprite_wbaz5u = 689 
		Sprite_wbaz5d = 690 
		Sprite_wbz4lnk = 691 
		Sprite_wbz4lnku = 692 
		Sprite_wbz4lnkd = 693 
		Sprite_wbz5lnk = 694 
		Sprite_wbz5lnku = 695 
		Sprite_wbz5lnkd = 696

function CopyStruct(a,b)
	a.panelRow  = b.panelRow  or a.panelRow 
	a.unknownC  = b.unknownC  or a.unknownC 
	a.unknown10 = b.unknown10 or a.unknown10
	a.unknown14 = b.unknown14 or a.unknown14
	a.unknown18 = b.unknown18 or a.unknown18
	a.unknown1C = b.unknown1C or a.unknown1C
	a.unknown20 = b.unknown20 or a.unknown20
	a.unknown24 = b.unknown24 or a.unknown24
	a.unknown28 = b.unknown28 or a.unknown28
	a.unknown2C = b.unknown2C or a.unknown2C
	a.unknown30 = b.unknown30 or a.unknown30
	a.unknown34 = b.unknown34 or a.unknown34
	a.unknown38 = b.unknown38 or a.unknown38
	a.unknown3C = b.unknown3C or a.unknown3C
	a.unknown40 = b.unknown40 or a.unknown40
	a.unknown44 = b.unknown44 or a.unknown44
	a.unknown48 = b.unknown48 or a.unknown48
	a.unknown4C = b.unknown4C or a.unknown4C
	a.unknown50 = b.unknown50 or a.unknown50
	a.unknown54 = b.unknown54 or a.unknown54
	a.unknown58 = b.unknown58 or a.unknown58
	a.unknown5C = b.unknown5C or a.unknown5C
	a.unknown60 = b.unknown60 or a.unknown60
	a.unknown64 = b.unknown64 or a.unknown64
	a.unknown68 = b.unknown68 or a.unknown68
	a.unknown6C = b.unknown6C or a.unknown6C
	a.unknown70 = b.unknown70 or a.unknown70
	a.unknown74 = b.unknown74 or a.unknown74
	a.unknown78 = b.unknown78 or a.unknown78
	a.unknown7C = b.unknown7C or a.unknown7C
	a.unknown80 = b.unknown80 or a.unknown80
	a.unknown84 = b.unknown84 or a.unknown84
	a.unknown88 = b.unknown88 or a.unknown88
	a.unknown8C = b.unknown8C or a.unknown8C
	return a
end
function FillStruct(a,b)
	if a.unknownC  == 0 then a.unknownC  = b.unknownC  end
	if a.unknown10 == 0 then a.unknown10 = b.unknown10 end
	if a.unknown14 == 0 then a.unknown14 = b.unknown14 end
	if a.unknown18 == 0 then a.unknown18 = b.unknown18 end
	if a.unknown1C == 0 then a.unknown1C = b.unknown1C end
	if a.unknown20 == 0 then a.unknown20 = b.unknown20 end
	if a.unknown24 == 0 then a.unknown24 = b.unknown24 end
	if a.unknown28 == 0 then a.unknown28 = b.unknown28 end
	if a.unknown2C == 0 then a.unknown2C = b.unknown2C end
	if a.unknown30 == 0 then a.unknown30 = b.unknown30 end
	if a.unknown34 == 0 then a.unknown34 = b.unknown34 end
	if a.unknown38 == 0 then a.unknown38 = b.unknown38 end
	if a.unknown3C == 0 then a.unknown3C = b.unknown3C end
	if a.unknown40 == 0 then a.unknown40 = b.unknown40 end
	if a.unknown44 == 0 then a.unknown44 = b.unknown44 end
	if a.unknown48 == 0 then a.unknown48 = b.unknown48 end
	if a.unknown4C == 0 then a.unknown4C = b.unknown4C end
	if a.unknown50 == 0 then a.unknown50 = b.unknown50 end
	if a.unknown54 == 0 then a.unknown54 = b.unknown54 end
	if a.unknown58 == 0 then a.unknown58 = b.unknown58 end
	if a.unknown5C == 0 then a.unknown5C = b.unknown5C end
	if a.unknown60 == 0 then a.unknown60 = b.unknown60 end
	if a.unknown64 == 0 then a.unknown64 = b.unknown64 end
	if a.unknown68 == 0 then a.unknown68 = b.unknown68 end
	if a.unknown6C == 0 then a.unknown6C = b.unknown6C end
	if a.unknown70 == 0 then a.unknown70 = b.unknown70 end
	if a.unknown74 == 0 then a.unknown74 = b.unknown74 end
	if a.unknown78 == 0 then a.unknown78 = b.unknown78 end
	if a.unknown7C == 0 then a.unknown7C = b.unknown7C end
	if a.unknown80 == 0 then a.unknown80 = b.unknown80 end
	if a.unknown84 == 0 then a.unknown84 = b.unknown84 end
	if a.unknown88 == 0 then a.unknown88 = b.unknown88 end
	if a.unknown8C == 0 then a.unknown8C = b.unknown8C end
	if a.unknown90 == 0 then a.unknown90 = b.unknown90 end
	if a.unknown94 == 0 then a.unknown94 = b.unknown94 end
	if a.unknown98 == 0 then a.unknown98 = b.unknown98 end
	if a.unknown9C == 0 then a.unknown9C = b.unknown9C end
	if a.unknownA0 == 0 then a.unknownA0 = b.unknownA0 end
	if a.unknownA4 == 0 then a.unknownA4 = b.unknownA4 end
	if a.unknownA8 == 0 then a.unknownA8 = b.unknownA8 end
	if a.unknownAC == 0 then a.unknownAC = b.unknownAC end
	if a.unknownB0 == 0 then a.unknownB0 = b.unknownB0 end
	if a.unknownB4 == 0 then a.unknownB4 = b.unknownB4 end
	if a.unknownB8 == 0 then a.unknownB8 = b.unknownB8 end
	if a.unknownBC == 0 then a.unknownBC = b.unknownBC end
	if a.unknownC0 == 0 then a.unknownC0 = b.unknownC0 end
	if a.unknownC4 == 0 then a.unknownC4 = b.unknownC4 end
	if a.unknownC8 == 0 then a.unknownC8 = b.unknownC8 end
	if a.unknownCC == 0 then a.unknownCC = b.unknownCC end
	if a.unknownD0 == 0 then a.unknownD0 = b.unknownD0 end
	if a.unknownD4 == 0 then a.unknownD4 = b.unknownD4 end
	if a.unknownD8 == 0 then a.unknownD8 = b.unknownD8 end
	if a.unknownDC == 0 then a.unknownDC = b.unknownDC end
	if a.unknownE0 == 0 then a.unknownE0 = b.unknownE0 end
	if a.unknownE4 == 0 then a.unknownE4 = b.unknownE4 end
	if a.unknownE8 == 0 then a.unknownE8 = b.unknownE8 end
	if a.unknownEC == 0 then a.unknownEC = b.unknownEC end
	if a.unknownF0 == 0 then a.unknownF0 = b.unknownF0 end
	if a.unknownF4 == 0 then a.unknownF4 = b.unknownF4 end
	if a.unknownF8 == 0 then a.unknownF8 = b.unknownF8 end
	if a.unknownFC == 0 then a.unknownFC = b.unknownFC end
	if a.unknown100 == 0 then a.unknown100 = b.unknown100 end
	if a.unknown104 == 0 then a.unknown104 = b.unknown104 end
	if a.unknown108 == 0 then a.unknown108 = b.unknown108 end
	if a.unknown10C == 0 then a.unknown10C = b.unknown10C end
	if a.unknown110 == 0 then a.unknown110 = b.unknown110 end
	if a.unknown114 == 0 then a.unknown114 = b.unknown114 end
	if a.unknown118 == 0 then a.unknown118 = b.unknown118 end
	if a.unknown11C == 0 then a.unknown11C = b.unknown11C end
	if a.unknown120 == 0 then a.unknown120 = b.unknown120 end
	if a.unknown124 == 0 then a.unknown124 = b.unknown124 end
	if a.unknown128 == 0 then a.unknown128 = b.unknown128 end
	if a.unknown12C == 0 then a.unknown12C = b.unknown12C end
	if a.unknown130 == 0 then a.unknown130 = b.unknown130 end
	if a.unknown134 == 0 then a.unknown134 = b.unknown134 end
	if a.unknown138 == 0 then a.unknown138 = b.unknown138 end
	if a.unknown13C == 0 then a.unknown13C = b.unknown13C end
	if a.unknown140 == 0 then a.unknown140 = b.unknown140 end
	if a.unknown144 == 0 then a.unknown144 = b.unknown144 end
	if a.unknown148 == 0 then a.unknown148 = b.unknown148 end
	if a.unknown14C == 0 then a.unknown14C = b.unknown14C end
	if a.unknown150 == 0 then a.unknown150 = b.unknown150 end
	if a.unknown154 == 0 then a.unknown154 = b.unknown154 end
	if a.unknown158 == 0 then a.unknown158 = b.unknown158 end
	if a.unknown15C == 0 then a.unknown15C = b.unknown15C end
	if a.unknown160 == 0 then a.unknown160 = b.unknown160 end
	if a.unknown164 == 0 then a.unknown164 = b.unknown164 end
	if a.unknown168 == 0 then a.unknown168 = b.unknown168 end
	if a.unknown16C == 0 then a.unknown16C = b.unknown16C end
	if a.unknown170 == 0 then a.unknown170 = b.unknown170 end
	if a.unknown174 == 0 then a.unknown174 = b.unknown174 end
	if a.unknown178 == 0 then a.unknown178 = b.unknown178 end
	if a.unknown17C == 0 then a.unknown17C = b.unknown17C end
	if a.unknown180 == 0 then a.unknown180 = b.unknown180 end
	if a.unknown184 == 0 then a.unknown184 = b.unknown184 end
	if a.unknown188 == 0 then a.unknown188 = b.unknown188 end
	if a.unknown18C == 0 then a.unknown18C = b.unknown18C end
	if a.unknown190 == 0 then a.unknown190 = b.unknown190 end
	if a.unknown194 == 0 then a.unknown194 = b.unknown194 end
	if a.unknown198 == 0 then a.unknown198 = b.unknown198 end
	if a.unknown19C == 0 then a.unknown19C = b.unknown19C end
	if a.unknown1A0 == 0 then a.unknown1A0 = b.unknown1A0 end
	if a.unknown1A4 == 0 then a.unknown1A4 = b.unknown1A4 end
	if a.unknown1A8 == 0 then a.unknown1A8 = b.unknown1A8 end
	if a.unknown1AC == 0 then a.unknown1AC = b.unknown1AC end
	if a.unknown1B0 == 0 then a.unknown1B0 = b.unknown1B0 end
	if a.unknown1B4 == 0 then a.unknown1B4 = b.unknown1B4 end
	if a.unknown1B8 == 0 then a.unknown1B8 = b.unknown1B8 end
	if a.unknown1BC == 0 then a.unknown1BC = b.unknown1BC end
	if a.unknown1C0 == 0 then a.unknown1C0 = b.unknown1C0 end
	if a.unknown1C4 == 0 then a.unknown1C4 = b.unknown1C4 end
	if a.unknown1C8 == 0 then a.unknown1C8 = b.unknown1C8 end
	if a.unknown1CC == 0 then a.unknown1CC = b.unknown1CC end
	
	
	
	return a
end

local track 
function PrintStuff(This,size)
	if size then
		io.write("----- ARRAY PARAMS ------ \n")
		for i=1,size,1 do
			io.write("[" .. i .. "] = " .. tostring(This[i]) .. " \n")
		end
		return 
	end
	io.write("----- ".. tostring(This.__name) .." ------ \n")
	for i,e in pairs(getmetatable(This)) do
			io.write("This." .. i .. " = " .. tostring(This[i]) .. " \n")
	end
end


function changeTracker(This,exclude)
	if not track then
		track  = {}
		io.write("----- TRACKER ------ \n")
		for i,e in pairs(getmetatable(This)) do
			io.write(i .. ": " .. tostring(This[i]) .. " \n")
			track[i] = This[i]
		end
	else
		for i,e in pairs(getmetatable(This)) do
			if (track[i] ~= This[i]) and ((not exclude) or (not exclude[i])) then
				io.write(tostring(i) .. "changed from " .. tostring(track[i]) .. " to " .. tostring(This[i]) .. "\n")
				track[i] = This[i]
			end
		end
	end
end

--animation routines
local animations = {}
local sprites = {}

function playanimations()
	for i=#animations,1,-1 do
		e = animations[i]
		e.Frame = e.Frame + e.Step
		if e.End == e.Frame then
			if e.Loop then
				e.Frame =  e.Frame + ((e.Step * -1)* e.Length)
			else
				table.remove(animations,i)
			end
		end

	end
end

function renderanimations()
	for i=#animations,1,-1 do
		e = animations[i]
		if e.FollowEnt then
			--io.write(string.format("frame:" .. e.Frame .. "\n"))
			drawSpriteLocal(e.FollowEnt.posY,e.Layer,e.FollowEnt.posX,e.Sprite,e.Frame*1000)
		else
			drawSpriteLocal(e.posY,e.Layer,e.posX,e.Sprite,e.Frame*1000)
		end
	end
end

function clearentanims(addr)
	for i=#animations,1,-1 do
		e = animations[i]
		if e.FollowEnt and (e.FollowEnt:getAddr() == addr) then
			table.remove(animations,i)
		end
	end
end


function addanim(posX,posY,sprite,len,loop,startframe,endframe)
	if not startframe then startframe = 0 end
	if not endframe then endframe = len end
	local anim = {}
	anim.posX = posX
	anim.posY = posY
	anim.Layer = 1000
	anim.Loop = loop
	anim.Length = len
	anim.End = endframe
	anim.Start = 1
	if endframe ~= len then
		anim.Start = startframe
	end
	anim.Step = 1
	if (startframe > endframe) then anim.Step = -1 end
	anim.Frame = startframe
	anim.Sprite = sprite
	table.insert(animations,anim)
	--clearConsole();
	io.write(string.format("animations:" .. #animations .. "(".. sprite ..")\n"))
	return animations[#animations]
end

function addentanim(ent,sprite,len,loop,startframe,endframe)
	if not startframe then startframe = 0 end
	if not endframe then endframe = len end
	local anim = {}
	anim.FollowEnt = ent
	anim.Layer = 1000
	anim.Loop = loop
	anim.Length = len
	anim.End = endframe
	anim.Start = 1
	if endframe ~= len then
		anim.Start = startframe
	end
	anim.Step = 1
	if (startframe > endframe) then anim.Step = -1 end
	anim.Frame = startframe
	anim.Sprite = sprite
	table.insert(animations,anim)
	--clearConsole();
	io.write(string.format("animations:" .. #animations .. "(".. sprite ..")\n"))
	return animations[#animations]
end


local dummyprojparams  = WeaponProjectileParams.new()

local dummylaunchparams  = WeaponLaunchParams.new()
dummyprojparams.unknown0= 2;
dummyprojparams.unknown4= 0;
dummyprojparams.unknown8= 0;
dummyprojparams.unknownC= 137342; --collissionflags
dummyprojparams.unknown10= 0;
dummyprojparams.unknown14= 100;
dummyprojparams.unknown18= 50; --power
dummyprojparams.unknown1C= 0;
dummyprojparams.unknown20= 0;
dummyprojparams.unknown24= 49; --proj sprite
dummyprojparams.unknown28= 2; --proj sprite type
dummyprojparams.unknown2C= 130; --smoke sprite
dummyprojparams.unknown30= 50; --smoke trail len?
dummyprojparams.unknown34= 100; --trail fade speed
dummyprojparams.unknown38= 50;
dummyprojparams.unknown3C= 100;
dummyprojparams.unknown40= 100;
dummyprojparams.unknown44= 0;
dummyprojparams.unknown48= 100;
dummyprojparams.unknown4C= 0;
dummyprojparams.unknown50= 9000; --fuse time
dummyprojparams.unknown54= 0;
dummyprojparams.unknown58= 0;
dummyprojparams.unknown5C= 0;
dummyprojparams.unknown60= 0;
dummyprojparams.unknown64= 0;
dummyprojparams.unknown68= 2;
dummyprojparams.unknown6C= 4194304;
dummyprojparams.unknown70= 1;
dummyprojparams.unknown74= 0;
dummyprojparams.unknown78= 0;
dummyprojparams.unknown7C= 8;
dummyprojparams.unknown80= 0;
dummyprojparams.unknown84= 0;
dummyprojparams.unknown88= 0;
dummyprojparams.unknown8C= 0;
dummyprojparams.unknown90= 0;
dummyprojparams.unknown94= 0;
dummyprojparams.unknown98= 0;
dummyprojparams.unknown9C= 0;
dummyprojparams.unknownA0= 0;
dummyprojparams.unknownA4= 0;
dummyprojparams.unknownA8= 0;
dummyprojparams.unknownAC= 0;
dummyprojparams.unknownB0= 0;
dummyprojparams.unknownB4= 0;
dummyprojparams.unknownB8= 0;
dummyprojparams.unknownBC= 0;
dummyprojparams.unknownC0= 0;
dummyprojparams.unknownC4= 0;
dummyprojparams.unknownC8= 0;
dummyprojparams.unknownCC= 0;
dummyprojparams.unknownD0= 0;
dummyprojparams.unknownD4= 0;
dummyprojparams.unknownD8= 0;
dummyprojparams.unknownDC= 0;
dummyprojparams.unknownE0= 0;
dummyprojparams.unknownE4= 0;
dummyprojparams.unknownE8= 0;
dummyprojparams.unknownEC= 0;
dummyprojparams.unknownF0= 0;
dummyprojparams.unknownF4= 0;
dummyprojparams.unknownF8= 0;
dummyprojparams.unknownFC= 0;
dummyprojparams.unknown100= 0;
dummyprojparams.unknown104= 0;
dummyprojparams.unknown108= 0;
dummyprojparams.unknown10C= 0;
dummyprojparams.unknown110= 0;
dummyprojparams.unknown114= 0;
dummyprojparams.unknown118= 0;
dummyprojparams.unknown11C= 0;
dummyprojparams.unknown120= 0;
dummyprojparams.unknown124= 0;
dummyprojparams.unknown128= 0;
dummyprojparams.unknown12C= 0;
dummyprojparams.unknown130= 0;
dummyprojparams.unknown134= 0;
dummyprojparams.unknown138= 0;
dummyprojparams.unknown13C= 0;
dummyprojparams.unknown140= 0;
dummyprojparams.unknown144= 0;
dummyprojparams.unknown148= 0;
dummyprojparams.unknown14C= 0;
dummyprojparams.unknown150= 0;
dummyprojparams.unknown154= 0;
dummyprojparams.unknown158= 0;
dummyprojparams.unknown15C= 0;
dummyprojparams.unknown160= 0;
dummyprojparams.unknown164= 0;
dummyprojparams.unknown168= 0;
dummyprojparams.unknown16C= 0;
dummyprojparams.unknown170= 0;
dummyprojparams.unknown174= 0;
---WEAPONLAUNCHPARAMS--
dummylaunchparams.unknown0= 2;
dummylaunchparams.unknown4= 1;
dummylaunchparams.unknown8= 55312384;
dummylaunchparams.unknownC= 22413312;
dummylaunchparams.unknown10= 0;
dummylaunchparams.unknown14= -419040;
dummylaunchparams.unknown18= 62914560;
dummylaunchparams.unknown1C= 22806528;
dummylaunchparams.unknown20= 0;
dummylaunchparams.unknown24= 30;
dummylaunchparams.unknown28= 3000;

local bulletlaunchparams  = WeaponLaunchParams.new()
bulletlaunchparams.unknown0= 1
bulletlaunchparams.unknown4= 1
bulletlaunchparams.unknown8= 75628544
bulletlaunchparams.unknownC= 40304640
bulletlaunchparams.unknown10= -62953
bulletlaunchparams.unknown14= -18217
bulletlaunchparams.unknown18= 62914560
bulletlaunchparams.unknown1C= 22806528
bulletlaunchparams.unknown20= 0
bulletlaunchparams.unknown24= 30
bulletlaunchparams.unknown28= 3000

local bulletprojparams  = WeaponProjectileParams.new()

bulletprojparams.unknown0= 17712328;
bulletprojparams.unknown4= 437126352;
bulletprojparams.unknown8= 16;
bulletprojparams.unknownC= 0;
bulletprojparams.unknown10= 0;
bulletprojparams.unknown14= 437123696;
bulletprojparams.unknown18= 19;
bulletprojparams.unknown1C= 2;
bulletprojparams.unknown20= 18;
bulletprojparams.unknown24= 436063304;
bulletprojparams.unknown28= 0;
bulletprojparams.unknown2C= 395821064;
bulletprojparams.unknown30= 3;
bulletprojparams.unknown34= 4328646;
bulletprojparams.unknown38= 3;
bulletprojparams.unknown3C= 0;
bulletprojparams.unknown40= 1;
bulletprojparams.unknown44= 105;
bulletprojparams.unknown48= 0;
bulletprojparams.unknown4C= 65536;
bulletprojparams.unknown50= 1048576;
bulletprojparams.unknown54= 50726;
bulletprojparams.unknown58= 65536;
bulletprojparams.unknown5C= 0;
bulletprojparams.unknown60= 65536;
bulletprojparams.unknown64= 131072;
bulletprojparams.unknown68= 62259;
bulletprojparams.unknown6C= 39321;
bulletprojparams.unknown70= 0;
bulletprojparams.unknown74= 62914;
bulletprojparams.unknown78= 65208;
bulletprojparams.unknown7C= 39321;
bulletprojparams.unknown80= 15073;
bulletprojparams.unknown84= 47054848;
bulletprojparams.unknown88= 28114944;
bulletprojparams.unknown8C= 0;
bulletprojparams.unknown90= 0;
bulletprojparams.unknown94= 0;
bulletprojparams.unknown98= 0;
bulletprojparams.unknown9C= 13107;
bulletprojparams.unknownA0= 19660;
bulletprojparams.unknownA4= 0;
bulletprojparams.unknownA8= 131072;
bulletprojparams.unknownAC= 1;
bulletprojparams.unknownB0= 0;
bulletprojparams.unknownB4= 0;
bulletprojparams.unknownB8= 0;
bulletprojparams.unknownBC= 0;
bulletprojparams.unknownC0= 0;
bulletprojparams.unknownC4= 0;
bulletprojparams.unknownC8= 0;
bulletprojparams.unknownCC= 65536;
bulletprojparams.unknownD0= 0;
bulletprojparams.unknownD4= 0;
bulletprojparams.unknownD8= 256;
bulletprojparams.unknownDC= 397774944;
bulletprojparams.unknownE0= 0;
bulletprojparams.unknownE4= 0;
bulletprojparams.unknownE8= 17734904;
bulletprojparams.unknownEC= 395821064;
bulletprojparams.unknownF0= 1;
bulletprojparams.unknownF4= 0;
bulletprojparams.unknownF8= 436078648;
bulletprojparams.unknownFC= 1;
bulletprojparams.unknown100= 3;
bulletprojparams.unknown104= 1;
bulletprojparams.unknown108= 0;
bulletprojparams.unknown10C= 0;
bulletprojparams.unknown110= 1459617892;
bulletprojparams.unknown114= 544043631;
bulletprojparams.unknown118= 51;
bulletprojparams.unknown11C= 0;
bulletprojparams.unknown120= 0;
bulletprojparams.unknown124= 0;
bulletprojparams.unknown128= 0;
bulletprojparams.unknown12C= 0;
bulletprojparams.unknown130= 0;
bulletprojparams.unknown134= 0;
bulletprojparams.unknown138= 0;
bulletprojparams.unknown13C= 0;
bulletprojparams.unknown140= 0;
bulletprojparams.unknown144= 0;
bulletprojparams.unknown148= 0;
bulletprojparams.unknown14C= 0;
bulletprojparams.unknown150= 0;
bulletprojparams.unknown154= 1;
bulletprojparams.unknown158= 1013;
bulletprojparams.unknown15C= 0;
bulletprojparams.unknown160= 0;
bulletprojparams.unknown164= 0;
bulletprojparams.unknown168= 45180;
bulletprojparams.unknown16C= 0;
bulletprojparams.unknown170= 13;
bulletprojparams.unknown174= -1;




--airstrike
local testWeaponStruct = WeaponStruct.new()
testWeaponStruct.panelRow = 6;            
testWeaponStruct.unknownC = 0;        --usable in cavern? real table row?
testWeaponStruct.unknown14 = 1;       --number of shots
testWeaponStruct.unknown10 = 0;       --shot ends turn?
testWeaponStruct.unknown18 = 1;       
testWeaponStruct.unknown1C = 3000;    
testWeaponStruct.unknown20 = 1;       
testWeaponStruct.unknown24 = 20;      
testWeaponStruct.unknown28 = 1; 		--number of weap per crate      
testWeaponStruct.unknown2C = 0;       
testWeaponStruct.unknown30 = 2;       --weapontype
testWeaponStruct.unknown34 = 1;       -- weapon subtype / no animals size
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
testWeaponStruct.unknownA4 = 0;  --boing     
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
WormstrikeStruct.panelRow = 0;
WormstrikeStruct.unknownC = 1;
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
WormstrikeStruct.unknown38 = Sprite_cpttruck;
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
BazookaStruct.unknown38 =  Sprite_cpttruck;
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
HomingMissileStruct.panelRow = 0;
HomingMissileStruct.unknownC = 1;
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
HomingMissileStruct.unknown38 =  Sprite_cpttruck;
HomingMissileStruct.unknown3C = 10;
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
MortarStruct.panelRow = 0;
MortarStruct.unknownC = 1;
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
MortarStruct.unknown38 =  Sprite_cpttruck;
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


--ID: 3 Name1: Mortar Name2: Mortar
local CajasDeMikeStruct = WeaponStruct.new()
CajasDeMikeStruct.panelRow = 1;
CajasDeMikeStruct.unknownC = 1; --remembered
CajasDeMikeStruct.unknown10 = 0; --usable in cavern
CajasDeMikeStruct.unknown14 = 1; --shoots
CajasDeMikeStruct.unknown18 = 0; --ends turn
CajasDeMikeStruct.unknown1C = 3000; --retreat time
CajasDeMikeStruct.unknown20 = 1; -- unknown
CajasDeMikeStruct.unknown24 = 20; --crate chance? (unused for custom weapons for now)
CajasDeMikeStruct.unknown28 = 1; -- count in crate
CajasDeMikeStruct.unknown2C = 0; -- free real estate
CajasDeMikeStruct.unknown30 = 3; --activation type 0:none 1:crossair 2:throw 3:airstrike 4:spacebar
CajasDeMikeStruct.unknown34 = 0; --//Throw:herd size//Airstrike:subtype?//Space:Action-->0-None,1:FirePunch,2:Bat,3:DragonBall,4:Kamikazee,5:Bomber,6:NinjaRope,7:Bungee,8:Drill,9:Prod,10:Teleport,11:Blowtorch,12:Parachute,13:Surrender,14:Skip,15:SelectWorm,16:NuclearTest,17:Girder,18:Axe,19:Utility,20:Freeze,21:Earthquake,22:Justice,23:JetPack,24:Armageddon  
--weaponspecific shit below
CajasDeMikeStruct.unknown38 = 0; --CrossAir:1-flamethrower,2-Gun,3-Launcher,4-Bow//Throw:1-Mine,2-Launcher,3-Canister//Airstrike:PlaneSprite
CajasDeMikeStruct.unknown3C = 0; --AS:Bombs Count
CajasDeMikeStruct.unknown40 = 32; --AS:Distance between drops
CajasDeMikeStruct.unknown44 = 100; --AS:Horizontal Speed
CajasDeMikeStruct.unknown48 = 0; --AS:Sound
CajasDeMikeStruct.unknown4C = 2; --AS:0-Mines,1-Worms,2-General(followup below) 
CajasDeMikeStruct.unknown50 = 2;
CajasDeMikeStruct.unknown54 = 100;
CajasDeMikeStruct.unknown58 = 0;
CajasDeMikeStruct.unknown5C = 137342; --collisionflags?
CajasDeMikeStruct.unknown60 = 0;
CajasDeMikeStruct.unknown64 = 0;
CajasDeMikeStruct.unknown68 = 15;
CajasDeMikeStruct.unknown6C = 0;
CajasDeMikeStruct.unknown70 = 0;
CajasDeMikeStruct.unknown74 = 52;
CajasDeMikeStruct.unknown78 = 2;
CajasDeMikeStruct.unknown7C = 131;
CajasDeMikeStruct.unknown80 = 50;
CajasDeMikeStruct.unknown84 = 100;
CajasDeMikeStruct.unknown88 = 50;
CajasDeMikeStruct.unknown8C = 100;
CajasDeMikeStruct.unknown90 = 0;
CajasDeMikeStruct.unknown94 = 0;
CajasDeMikeStruct.unknown98 = 100;
CajasDeMikeStruct.unknown9C = 0;
CajasDeMikeStruct.unknownA0 = 9000;
CajasDeMikeStruct.unknownA4 = 0;
CajasDeMikeStruct.unknownA8 = 0;
CajasDeMikeStruct.unknownAC = 0;
CajasDeMikeStruct.unknownB0 = 0;
CajasDeMikeStruct.unknownB4 = 0;
CajasDeMikeStruct.unknownB8 = 2;
CajasDeMikeStruct.unknownBC = 4194304;
CajasDeMikeStruct.unknownC0 = 1;
CajasDeMikeStruct.unknownC4 = 0;
CajasDeMikeStruct.unknownC8 = 0;
CajasDeMikeStruct.unknownCC = 8;
CajasDeMikeStruct.unknownD0 = 0;
CajasDeMikeStruct.unknownD4 = 0;
CajasDeMikeStruct.unknownD8 = 0;
CajasDeMikeStruct.unknownDC = 0;
CajasDeMikeStruct.unknownE0 = 0;
CajasDeMikeStruct.unknownE4 = 0;
CajasDeMikeStruct.unknownE8 = 0;
CajasDeMikeStruct.unknownEC = 0;
CajasDeMikeStruct.unknownF0 = 0;
CajasDeMikeStruct.unknownF4 = 0;
CajasDeMikeStruct.unknownF8 = 0;
CajasDeMikeStruct.unknownFC = 0;
CajasDeMikeStruct.unknown100 = 0;
CajasDeMikeStruct.unknown104 = 1;
CajasDeMikeStruct.unknown108 = 0;
CajasDeMikeStruct.unknown10C = 5;
CajasDeMikeStruct.unknown110 = 20;
CajasDeMikeStruct.unknown114 = 30;
CajasDeMikeStruct.unknown118 = -1;
CajasDeMikeStruct.unknown11C = 40;
CajasDeMikeStruct.unknown120 = 137278;
CajasDeMikeStruct.unknown124 = 0;
CajasDeMikeStruct.unknown128 = 100;
CajasDeMikeStruct.unknown12C = 15;
CajasDeMikeStruct.unknown130 = 0;
CajasDeMikeStruct.unknown134 = 1;
CajasDeMikeStruct.unknown138 = 54;
CajasDeMikeStruct.unknown13C = 2;
CajasDeMikeStruct.unknown140 = 131;
CajasDeMikeStruct.unknown144 = 20;
CajasDeMikeStruct.unknown148 = 100;
CajasDeMikeStruct.unknown14C = 50;
CajasDeMikeStruct.unknown150 = 100;
CajasDeMikeStruct.unknown154 = 0;
CajasDeMikeStruct.unknown158 = 0;
CajasDeMikeStruct.unknown15C = 100;
CajasDeMikeStruct.unknown160 = 0;
CajasDeMikeStruct.unknown164 = 9000;
CajasDeMikeStruct.unknown168 = 0;
CajasDeMikeStruct.unknown16C = 0;
CajasDeMikeStruct.unknown170 = 0;
CajasDeMikeStruct.unknown174 = 0;
CajasDeMikeStruct.unknown178 = 0;
CajasDeMikeStruct.unknown17C = 2;
CajasDeMikeStruct.unknown180 = 4194304;
CajasDeMikeStruct.unknown184 = 1;
CajasDeMikeStruct.unknown188 = 0;
CajasDeMikeStruct.unknown18C = 0;
CajasDeMikeStruct.unknown190 = 8;
CajasDeMikeStruct.unknown194 = 0;
CajasDeMikeStruct.unknown198 = 0;
CajasDeMikeStruct.unknown19C = 0;
CajasDeMikeStruct.unknown1A0 = 0;
CajasDeMikeStruct.unknown1A4 = 0;
CajasDeMikeStruct.unknown1A8 = 0;
CajasDeMikeStruct.unknown1AC = 0;
CajasDeMikeStruct.unknown1B0 = 0;
CajasDeMikeStruct.unknown1B4 = 0;
CajasDeMikeStruct.unknown1B8 = 0;
CajasDeMikeStruct.unknown1BC = 0;
CajasDeMikeStruct.unknown1C0 = 0;
CajasDeMikeStruct.unknown1C4 = 0;
CajasDeMikeStruct.unknown1C8 = 0;
CajasDeMikeStruct.unknown1CC = 0;



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
HomingPigeonStruct.unknown38 =  Sprite_cpttruck;
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
SheepLauncherStruct.unknown38 =  Sprite_cpttruck;
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
GrenadeStruct.panelRow = 0;
GrenadeStruct.unknownC = 1;
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
GrenadeStruct.unknown38 =  Sprite_cpttruck;
GrenadeStruct.unknown3C = 15;
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
ClusterBombStruct.panelRow = 0;
ClusterBombStruct.unknownC = 1;
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
ClusterBombStruct.unknown38 =  Sprite_cpttruck;
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




--ID: 21 Name1: Dynamite Name2: Dynamite
local DynamiteStruct = WeaponStruct.new()
DynamiteStruct.panelRow = 0;
DynamiteStruct.unknownC = 1;
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
DynamiteStruct.unknown38 =  Sprite_cpttruck;
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
SheepStruct.panelRow = 0;
SheepStruct.unknownC = 1;
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
SheepStruct.unknown38 = Sprite_shptruck; 
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
SuperSheepStruct.unknown38 =  Sprite_cpttruck;
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
AquaSheepStruct.unknown38 =  Sprite_cpttruck;
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
MoleBombStruct.panelRow = 0;
MoleBombStruct.unknownC = 1;
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
MoleBombStruct.unknown38 = Sprite_shptruck;
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
SuperBananaStruct.unknown38 =  Sprite_cpttruck;
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
HolyGrenadeStruct.unknown38 =  Sprite_cpttruck;
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
SalvationArmyStruct.unknown38 =  Sprite_cpttruck;
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
PetrolBombStruct.panelRow = 0;
PetrolBombStruct.unknownC = 1;
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
PetrolBombStruct.unknown38 =  Sprite_cpttruck;
PetrolBombStruct.unknown3C = 15;
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
SkunkStruct.unknown38 =  Sprite_cpttruck;
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
MingVaseStruct.unknown38 =  Sprite_cpttruck;
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
MadCowStruct.panelRow = 0;
MadCowStruct.unknownC = 1;
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
MadCowStruct.unknown38 = Sprite_shptruck;--plane sprite
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
OldWomanStruct.panelRow = 0;
OldWomanStruct.unknownC = 1;
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
OldWomanStruct.unknown38 = Sprite_shptruck;
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
LaserGunStructure.panelRow = 0;
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
LaserGunStructure.unknown5C = 5;
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

local DDrillStruct = WeaponStruct.new()
DDrillStruct.panelRow = 0;

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
JumpStruct.unknown34 = 5;
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


local DJumpStruct = WeaponStruct.new()
DJumpStruct.panelRow = 1;

local HorseStruct = WeaponStruct.new()
HorseStruct.panelRow = 1;

local TeleparachuteStruct = WeaponStruct.new()
TeleparachuteStruct.panelRow = 1;


local MagnetStruct = WeaponStruct.new()
MagnetStruct.panelRow = 1;
--MagnetStruct.unknownC = 1;
--MagnetStruct.unknown34 = 1; --weapon type

local WormUziStruct = WeaponStruct.new()
WormUziStruct.panelRow = 0;

local SwapStruct = WeaponStruct.new()
SwapStruct.panelRow=1;
SwapStruct.unknownC=0;
SwapStruct.unknown10=1;
SwapStruct.unknown14=1;
SwapStruct.unknown18=1;
SwapStruct.unknown1C=-1000;
SwapStruct.unknown20=1;
SwapStruct.unknown24=0;
SwapStruct.unknown28=1;
SwapStruct.unknown2C=0;
SwapStruct.unknown30=3;
SwapStruct.unknown34=10;
SwapStruct.unknown38=0;
SwapStruct.unknown3C=0;
SwapStruct.unknown40=0;
SwapStruct.unknown44=0;
SwapStruct.unknown48=0;
SwapStruct.unknown4C=0;
SwapStruct.unknown50=0;
SwapStruct.unknown54=0;
SwapStruct.unknown58=0;
SwapStruct.unknown5C=0;
SwapStruct.unknown60=0;
SwapStruct.unknown64=0;
SwapStruct.unknown68=0;
SwapStruct.unknown6C=0;
SwapStruct.unknown70=0;
SwapStruct.unknown74=0;
SwapStruct.unknown78=0;
SwapStruct.unknown7C=0;
SwapStruct.unknown80=0;
SwapStruct.unknown84=0;
SwapStruct.unknown88=0;
SwapStruct.unknown8C=0;
SwapStruct.unknown90=0;
SwapStruct.unknown94=0;
SwapStruct.unknown98=0;
SwapStruct.unknown9C=0;
SwapStruct.unknownA0=0;
SwapStruct.unknownA4=0;
SwapStruct.unknownA8=0;
SwapStruct.unknownAC=0;
SwapStruct.unknownB0=0;
SwapStruct.unknownB4=0;
SwapStruct.unknownB8=0;
SwapStruct.unknownBC=0;
SwapStruct.unknownC0=0;
SwapStruct.unknownC4=0;
SwapStruct.unknownC8=0;
SwapStruct.unknownCC=0;
SwapStruct.unknownD0=0;
SwapStruct.unknownD4=0;
SwapStruct.unknownD8=0;
SwapStruct.unknownDC=0;
SwapStruct.unknownE0=0;
SwapStruct.unknownE4=0;
SwapStruct.unknownE8=0;
SwapStruct.unknownEC=0;
SwapStruct.unknownF0=0;
SwapStruct.unknownF4=0;
SwapStruct.unknownF8=0;
SwapStruct.unknownFC=0;
SwapStruct.unknown100=0;
SwapStruct.unknown104=0;
SwapStruct.unknown108=0;
SwapStruct.unknown10C=0;
SwapStruct.unknown110=0;
SwapStruct.unknown114=0;
SwapStruct.unknown118=0;
SwapStruct.unknown11C=0;
SwapStruct.unknown120=0;
SwapStruct.unknown124=0;
SwapStruct.unknown128=0;
SwapStruct.unknown12C=0;
SwapStruct.unknown130=0;
SwapStruct.unknown134=0;
SwapStruct.unknown138=0;
SwapStruct.unknown13C=0;
SwapStruct.unknown140=0;
SwapStruct.unknown144=0;
SwapStruct.unknown148=0;
SwapStruct.unknown14C=0;
SwapStruct.unknown150=0;
SwapStruct.unknown154=0;
SwapStruct.unknown158=0;
SwapStruct.unknown15C=0;
SwapStruct.unknown160=0;
SwapStruct.unknown164=0;
SwapStruct.unknown168=0;
SwapStruct.unknown16C=0;
SwapStruct.unknown170=0;
SwapStruct.unknown174=0;
SwapStruct.unknown178=0;
SwapStruct.unknown17C=0;
SwapStruct.unknown180=0;
SwapStruct.unknown184=0;
SwapStruct.unknown188=0;
SwapStruct.unknown18C=0;
SwapStruct.unknown190=0;
SwapStruct.unknown194=0;
SwapStruct.unknown198=0;
SwapStruct.unknown19C=0;
SwapStruct.unknown1A0=0;
SwapStruct.unknown1A4=0;
SwapStruct.unknown1A8=0;
SwapStruct.unknown1AC=0;
SwapStruct.unknown1B0=0;
SwapStruct.unknown1B4=0;
SwapStruct.unknown1B8=0;
SwapStruct.unknown1BC=0;
SwapStruct.unknown1C0=0;
SwapStruct.unknown1C4=0;
SwapStruct.unknown1C8=0;
SwapStruct.unknown1CC=0;

local AlabacionStruct = WeaponStruct.new()
AlabacionStruct.panelRow=1;
AlabacionStruct.unknownC=0;
AlabacionStruct.unknown10=1;
AlabacionStruct.unknown14=1;
AlabacionStruct.unknown18=1;
AlabacionStruct.unknown1C=-1000;
AlabacionStruct.unknown20=1;
AlabacionStruct.unknown24=0;
AlabacionStruct.unknown28=1;
AlabacionStruct.unknown2C=0;
AlabacionStruct.unknown30=3;
AlabacionStruct.unknown34=10;
AlabacionStruct.unknown38=0;
AlabacionStruct.unknown3C=0;
AlabacionStruct.unknown40=0;
AlabacionStruct.unknown44=0;
AlabacionStruct.unknown48=0;
AlabacionStruct.unknown4C=0;
AlabacionStruct.unknown50=0;
AlabacionStruct.unknown54=0;
AlabacionStruct.unknown58=0;
AlabacionStruct.unknown5C=0;
AlabacionStruct.unknown60=0;
AlabacionStruct.unknown64=0;
AlabacionStruct.unknown68=0;
AlabacionStruct.unknown6C=0;
AlabacionStruct.unknown70=0;
AlabacionStruct.unknown74=0;
AlabacionStruct.unknown78=0;
AlabacionStruct.unknown7C=0;
AlabacionStruct.unknown80=0;
AlabacionStruct.unknown84=0;
AlabacionStruct.unknown88=0;
AlabacionStruct.unknown8C=0;
AlabacionStruct.unknown90=0;
AlabacionStruct.unknown94=0;
AlabacionStruct.unknown98=0;
AlabacionStruct.unknown9C=0;
AlabacionStruct.unknownA0=0;
AlabacionStruct.unknownA4=0;
AlabacionStruct.unknownA8=0;
AlabacionStruct.unknownAC=0;
AlabacionStruct.unknownB0=0;
AlabacionStruct.unknownB4=0;
AlabacionStruct.unknownB8=0;
AlabacionStruct.unknownBC=0;
AlabacionStruct.unknownC0=0;
AlabacionStruct.unknownC4=0;
AlabacionStruct.unknownC8=0;
AlabacionStruct.unknownCC=0;
AlabacionStruct.unknownD0=0;
AlabacionStruct.unknownD4=0;
AlabacionStruct.unknownD8=0;
AlabacionStruct.unknownDC=0;
AlabacionStruct.unknownE0=0;
AlabacionStruct.unknownE4=0;
AlabacionStruct.unknownE8=0;
AlabacionStruct.unknownEC=0;
AlabacionStruct.unknownF0=0;
AlabacionStruct.unknownF4=0;
AlabacionStruct.unknownF8=0;
AlabacionStruct.unknownFC=0;
AlabacionStruct.unknown100=0;
AlabacionStruct.unknown104=0;
AlabacionStruct.unknown108=0;
AlabacionStruct.unknown10C=0;
AlabacionStruct.unknown110=0;
AlabacionStruct.unknown114=0;
AlabacionStruct.unknown118=0;
AlabacionStruct.unknown11C=0;
AlabacionStruct.unknown120=0;
AlabacionStruct.unknown124=0;
AlabacionStruct.unknown128=0;
AlabacionStruct.unknown12C=0;
AlabacionStruct.unknown130=0;
AlabacionStruct.unknown134=0;
AlabacionStruct.unknown138=0;
AlabacionStruct.unknown13C=0;
AlabacionStruct.unknown140=0;
AlabacionStruct.unknown144=0;
AlabacionStruct.unknown148=0;
AlabacionStruct.unknown14C=0;
AlabacionStruct.unknown150=0;
AlabacionStruct.unknown154=0;
AlabacionStruct.unknown158=0;
AlabacionStruct.unknown15C=0;
AlabacionStruct.unknown160=0;
AlabacionStruct.unknown164=0;
AlabacionStruct.unknown168=0;
AlabacionStruct.unknown16C=0;
AlabacionStruct.unknown170=0;
AlabacionStruct.unknown174=0;
AlabacionStruct.unknown178=0;
AlabacionStruct.unknown17C=0;
AlabacionStruct.unknown180=0;
AlabacionStruct.unknown184=0;
AlabacionStruct.unknown188=0;
AlabacionStruct.unknown18C=0;
AlabacionStruct.unknown190=0;
AlabacionStruct.unknown194=0;
AlabacionStruct.unknown198=0;
AlabacionStruct.unknown19C=0;
AlabacionStruct.unknown1A0=0;
AlabacionStruct.unknown1A4=0;
AlabacionStruct.unknown1A8=0;
AlabacionStruct.unknown1AC=0;
AlabacionStruct.unknown1B0=0;
AlabacionStruct.unknown1B4=0;
AlabacionStruct.unknown1B8=0;
AlabacionStruct.unknown1BC=0;
AlabacionStruct.unknown1C0=0;
AlabacionStruct.unknown1C4=0;
AlabacionStruct.unknown1C8=0;
AlabacionStruct.unknown1CC=0;

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

function onChatInput(command)
	io.write(string.format("onChatInput: %s\n", command))
	if command:sub(1, 4) == "lua " then
		local luaCode = command:sub(5)
        local success, result = pcall(function()
            return load(luaCode)()
        end)
	end
	if command:sub(1, 12) == "printweapon " then
		local weap = command:sub(13)
        if tonumber(weap) then
			PrintStuff(getWeaponData(weap))
		else
			PrintStuff(getWeaponData(_G["Weapon_" .. weap]))
		end
	end
	if command:sub(1, 2) == "g " then
		local weap = command:sub(3)
		local weapon = 1
        if tonumber(weap) then
			weapon = weap
		else
			if _G["Weapon_" .. weap] then
				weapon =  _G["Weapon_" .. weap]
			elseif customweaponsbyname[weap] then
				weapon = customweaponsbyname[weap]
			end			
		end
		for x=1,6,1 do
				setTeamAmmo(x,weapon,0,99)
		end
		io.write("gave " .. getWeaponData(e).name1 .."("..e..")" .. "\n")
	end
	if (command == "give all") or (command == "g all") or (command == "gall") then
		gibAll()
		--setTeamAmmo(This.team_number_dword38,Weapon_CrateSpy,0,1)
	elseif (command == "printworm") then
		if currworm then
			PrintStuff(currworm)
			PrintStuff(CGameTask_CastCTask(currworm))
		end
	end
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
		
		TaskMessage_WormState = 240
		TaskMessage_GameState = 241
		
		
		TaskMessage_WeaponPanelUpdate = 132
		--127 airstrike
		--TaskMessage_PlaceGirder? = 129
		--129 viga?
		--131 airstrike
		--132 airstrike
		
		Object_Mine=1  
		Object_Oildrum=2  
		Object_WeaponCrate=3  
		Object_HealthCrate=4  
		Object_Target=5  --utilitycrate?
		Object_WinRound=6  
		Object_TriggerGameText=7
		
		
		ClassType_None = 0
		ClassType_Task = 1
		ClassType_GameTask = 2
		ClassType_GameCollisionTask = 3
		ClassType_Task_Control = 4
		ClassType_Task_Game = 5
		ClassType_Task_TurnGame = 6
		ClassType_Task_Filter = 7
		ClassType_Task_Mine = 8
		ClassType_Task_Canister = 9
		ClassType_Task_Team = 10
		ClassType_Task_Missile = 11
		ClassType_Task_Arrow = 12
		ClassType_Task_Animation = 13
		ClassType_Task_Dirt = 14
		ClassType_Task_Crate = 15
		ClassType_Task_Flame = 16
		ClassType_Task_AirStrike = 17
		ClassType_Task_Worm = 18
		ClassType_Task_OldWorm = 19
		ClassType_Task_Drill = 20
		ClassType_Task_Cross = 21 --grave
		ClassType_Task_Smoke = 22
		ClassType_Task_Cloud = 23
		ClassType_Task_Fire = 24
		ClassType_Task_Gass = 25
		ClassType_Task_FireBall = 26
		ClassType_Task_SeaBubble = 27
		ClassType_Task_Land = 28
		ClassType_Task_ScoreBubble = 29
		ClassType_Task_OilDrum = 30
		ClassType_Task_CPU = 31
		ClassType_SpriteAnimation = 32
		ClassType_CollisionManager = 33
		ClassType_MAX = 34
		
		Util_LowGravity = 1<<0
		Util_FastWalk =   1<<1
		Util_LaserSight = 1<<2
		Util_Invisibility = 1<<3
		Util_DblDamage = 1<<4
		Util_CrateSpy = 1<<5
		
		Weapon_None = 0
		Weapon_Bazooka=1
		Weapon_HomingMissile=2
		Weapon_Mortar=3
		Weapon_HomingPigeon=4
		Weapon_SheepLauncher=5
		Weapon_Grenade=6
		Weapon_ClusterBomb=7
		Weapon_BananaBomb=8
		Weapon_BattleAxe=9
		Weapon_EarthQuake=10
		Weapon_Shotgun=11
		Weapon_Handgun=12
		Weapon_Uzi=13
		Weapon_Minigun=14
		Weapon_Longbow=15
		Weapon_FirePunch=16
		Weapon_DragonBall=17
		Weapon_Kamikaze=18
		Weapon_SuicideBomber=19
		Weapon_Prod=20
		Weapon_Dynamite=21
		Weapon_Mine=22
		Weapon_Sheep=23
		Weapon_SuperSheep=24
		Weapon_AquaSheep=25
		Weapon_MoleBomb=26
		Weapon_AirStrike=27
		Weapon_NapalmStrike=28
		Weapon_MailStrike=29
		Weapon_MineStrike=30
		Weapon_MoleSquadron=31
		Weapon_BlowTorch=32
		Weapon_PneumaticDrill=33
		Weapon_Girder=34
		Weapon_BaseballBat=35
		Weapon_GirderPack=36
		Weapon_NinjaRope=37
		Weapon_Bungee=38
		Weapon_Parachute=39
		Weapon_Teleport=40
		Weapon_ScalesofJustice=41
		Weapon_SuperBanana=42
		Weapon_HolyGrenade=43
		Weapon_FlameThrower=44
		Weapon_SalvationArmy=45
		Weapon_MBBomb=46
		Weapon_PetrolBomb=47
		Weapon_Skunk=48
		Weapon_MingVase=49
		Weapon_SheepStrike=50
		Weapon_CarpetBomb=51
		Weapon_MadCow=52
		Weapon_OldWoman=53
		Weapon_Donkey=54
		Weapon_NuclearTest=55
		Weapon_Armageddon=56
		Weapon_SkipGo=57
		Weapon_Surrender=58
		Weapon_SelectWorm=59
		Weapon_Freeze=60
		Weapon_MagicBullet=61
		Weapon_JetPack=62
		Weapon_LowGravity=63
		Weapon_FastWalk=64
		Weapon_LaserSight=65
		Weapon_Invisibility=66
		Weapon_DamageX2=67
		Weapon_CrateSpy=68
		Weapon_DoubleTurnTime=69
		Weapon_CrateShower=70
		
		
		
		
		
		

		
		local stealpriority = {
		"Afano de Mike",
		Weapon_Donkey,
		Weapon_SheepStrike,
		"Vaca de Mike",
		"Oveja de Mike",
		"Dinamita de Mike",
		"Anshiana de Mike",
		"Homer de Mike",
		"Cajas de Mike",
		Weapon_SuperBanana,
		Weapon_CarpetBomb,
		Weapon_MoleSquadron,
		"Dadodemike",
		"Mike",
		"Ataque de grenado",
		"Topu de Mike",
		"Worms de Mike",
		"Gasolina de Mike",
		Weapon_MailStrike,
		Weapon_MBBomb,
		Weapon_MagicBullet,		
		Weapon_SalvationArmy,
		"Centinela de Mike",
		Weapon_MingVase,
		"Salud de Mike",
		"Cluster de Mike",
		"Mortero de Mike",
		Weapon_MineStrike,
		Weapon_NinjaRope,
		Weapon_SuperSheep,
		Weapon_AquaSheep,
		Weapon_EarthQuake,
		Weapon_BananaBomb,
		Weapon_HolyGrenade,
		"Estafeta de Mike",
		"Imaik",
		Weapon_Kamikaze,
		"Taladro Inverso",
		"Telemikesporte",
		"Teletransparacaidas",
		Weapon_Freeze,
		Weapon_ScalesofJustice,
		Weapon_Teleport,
		"AmetraJetPack de Mike",
		"Vacunatorio de Mike",
		Weapon_AirStrike,
		Weapon_HomingPigeon,
		Weapon_NapalmStrike,
		Weapon_HomingMissile,
		Weapon_SheepLauncher,
		Weapon_JetPack,
		Weapon_MadCow,
		Weapon_SelectWorm,
		Weapon_Sheep,
		Weapon_Dynamite,
		Weapon_OldWoman,
		Weapon_BaseballBat,
		Weapon_ClusterBomb,
		Weapon_Grenade,
		Weapon_PetrolBomb,
		Weapon_Minigun,
		Weapon_Shotgun,
		Weapon_Uzi,
		Weapon_Bazooka,
		Weapon_BattleAxe,
		Weapon_Mine,
		Weapon_MoleBomb,
		Weapon_Handgun,
		Weapon_FlameThrower,
		Weapon_FirePunch,
		Weapon_DragonBall,		
		Weapon_Parachute,
		Weapon_PneumaticDrill,
		Weapon_GirderPack,
		Weapon_Mortar,
		Weapon_Longbow,
		Weapon_BlowTorch,
		Weapon_Bungee,
		--Weapon_NuclearTest,
		--Weapon_Armageddon,
		Weapon_Girder,
		Weapon_SuicideBomber,
		Weapon_FastWalk,
		Weapon_LaserSight,
		Weapon_Invisibility,
		Weapon_DamageX2,
		Weapon_CrateSpy,
		Weapon_DoubleTurnTime,
		Weapon_LowGravity,
		Weapon_CrateShower,
		"Ablacion de Mike",
		Weapon_Skunk,
		Weapon_Prod,	
		
		
		}
		
		
		
		--Weapon_Jump = registerCustomWeapon(JumpStruct, "jelly/placeholders/Jump.img", "Jump", "Jump")
		--Weapon_MikeCow = registerCustomWeapon(MadCowStruct, "jelly/placeholders/cow.img", "Vaca de Mike", "Vaca de Mike")
		--Weapon_MikeWorm = registerCustomWeapon(WormstrikeStruct, "jelly/placeholders/worm.img", "Worms de Mike", "Worms de Mike")
		
		
		
		

local defprojparams = {}
defprojparams[Weapon_Bazooka] = WeaponProjectileParams.new()
defprojparams[Weapon_Bazooka].unknown0= 2;
defprojparams[Weapon_Bazooka].unknown4= 0;
defprojparams[Weapon_Bazooka].unknown8= 0;
defprojparams[Weapon_Bazooka].unknownC= 137342;
defprojparams[Weapon_Bazooka].unknown10= 0;
defprojparams[Weapon_Bazooka].unknown14= 100;
defprojparams[Weapon_Bazooka].unknown18= 50;
defprojparams[Weapon_Bazooka].unknown1C= 0;
defprojparams[Weapon_Bazooka].unknown20= 0;
defprojparams[Weapon_Bazooka].unknown24= 48;
defprojparams[Weapon_Bazooka].unknown28= 2;
defprojparams[Weapon_Bazooka].unknown2C= 131;
defprojparams[Weapon_Bazooka].unknown30= 50;
defprojparams[Weapon_Bazooka].unknown34= 100;
defprojparams[Weapon_Bazooka].unknown38= 50;
defprojparams[Weapon_Bazooka].unknown3C= 100;
defprojparams[Weapon_Bazooka].unknown40= 100;
defprojparams[Weapon_Bazooka].unknown44= 0;
defprojparams[Weapon_Bazooka].unknown48= 100;
defprojparams[Weapon_Bazooka].unknown4C= 0;
defprojparams[Weapon_Bazooka].unknown50= 9000;
defprojparams[Weapon_Bazooka].unknown54= 0;
defprojparams[Weapon_Bazooka].unknown58= 0;
defprojparams[Weapon_Bazooka].unknown5C= 0;
defprojparams[Weapon_Bazooka].unknown60= 0;
defprojparams[Weapon_Bazooka].unknown64= 0;
defprojparams[Weapon_Bazooka].unknown68= 2;
defprojparams[Weapon_Bazooka].unknown6C= 4194304;
defprojparams[Weapon_Bazooka].unknown70= 1;
defprojparams[Weapon_Bazooka].unknown74= 0;
defprojparams[Weapon_Bazooka].unknown78= 0;
defprojparams[Weapon_Bazooka].unknown7C= 8;
defprojparams[Weapon_Bazooka].unknown80= 0;
defprojparams[Weapon_Bazooka].unknown84= 0;
defprojparams[Weapon_Bazooka].unknown88= 0;
defprojparams[Weapon_Bazooka].unknown8C= 0;
defprojparams[Weapon_Bazooka].unknown90= 0;
defprojparams[Weapon_Bazooka].unknown94= 0;
defprojparams[Weapon_Bazooka].unknown98= 0;
defprojparams[Weapon_Bazooka].unknown9C= 0;
defprojparams[Weapon_Bazooka].unknownA0= 0;
defprojparams[Weapon_Bazooka].unknownA4= 0;
defprojparams[Weapon_Bazooka].unknownA8= 0;
defprojparams[Weapon_Bazooka].unknownAC= 0;
defprojparams[Weapon_Bazooka].unknownB0= 0;
defprojparams[Weapon_Bazooka].unknownB4= 0;
defprojparams[Weapon_Bazooka].unknownB8= 0;
defprojparams[Weapon_Bazooka].unknownBC= 0;
defprojparams[Weapon_Bazooka].unknownC0= 0;
defprojparams[Weapon_Bazooka].unknownC4= 0;
defprojparams[Weapon_Bazooka].unknownC8= 0;
defprojparams[Weapon_Bazooka].unknownCC= 0;
defprojparams[Weapon_Bazooka].unknownD0= 0;
defprojparams[Weapon_Bazooka].unknownD4= 0;
defprojparams[Weapon_Bazooka].unknownD8= 0;
defprojparams[Weapon_Bazooka].unknownDC= 0;
defprojparams[Weapon_Bazooka].unknownE0= 0;
defprojparams[Weapon_Bazooka].unknownE4= 0;
defprojparams[Weapon_Bazooka].unknownE8= 0;
defprojparams[Weapon_Bazooka].unknownEC= 0;
defprojparams[Weapon_Bazooka].unknownF0= 0;
defprojparams[Weapon_Bazooka].unknownF4= 0;
defprojparams[Weapon_Bazooka].unknownF8= 0;
defprojparams[Weapon_Bazooka].unknownFC= 0;
defprojparams[Weapon_Bazooka].unknown100= 0;
defprojparams[Weapon_Bazooka].unknown104= 0;
defprojparams[Weapon_Bazooka].unknown108= 0;
defprojparams[Weapon_Bazooka].unknown10C= 0;
defprojparams[Weapon_Bazooka].unknown110= 0;
defprojparams[Weapon_Bazooka].unknown114= 0;
defprojparams[Weapon_Bazooka].unknown118= 0;
defprojparams[Weapon_Bazooka].unknown11C= 0;
defprojparams[Weapon_Bazooka].unknown120= 0;
defprojparams[Weapon_Bazooka].unknown124= 0;
defprojparams[Weapon_Bazooka].unknown128= 0;
defprojparams[Weapon_Bazooka].unknown12C= 0;
defprojparams[Weapon_Bazooka].unknown130= 0;
defprojparams[Weapon_Bazooka].unknown134= 0;
defprojparams[Weapon_Bazooka].unknown138= 0;
defprojparams[Weapon_Bazooka].unknown13C= 0;
defprojparams[Weapon_Bazooka].unknown140= 0;
defprojparams[Weapon_Bazooka].unknown144= 0;
defprojparams[Weapon_Bazooka].unknown148= 0;
defprojparams[Weapon_Bazooka].unknown14C= 0;
defprojparams[Weapon_Bazooka].unknown150= 0;
defprojparams[Weapon_Bazooka].unknown154= 0;
defprojparams[Weapon_Bazooka].unknown158= 0;
defprojparams[Weapon_Bazooka].unknown15C= 0;
defprojparams[Weapon_Bazooka].unknown160= 0;
defprojparams[Weapon_Bazooka].unknown164= 0;
defprojparams[Weapon_Bazooka].unknown168= 0;
defprojparams[Weapon_Bazooka].unknown16C= 0;
defprojparams[Weapon_Bazooka].unknown170= 0;
defprojparams[Weapon_Bazooka].unknown174= 0;
defprojparams[Weapon_HomingMissile] = WeaponProjectileParams.new()
defprojparams[Weapon_HomingMissile].unknown0= 2;
defprojparams[Weapon_HomingMissile].unknown4= 0;
defprojparams[Weapon_HomingMissile].unknown8= 0;
defprojparams[Weapon_HomingMissile].unknownC= 137342;
defprojparams[Weapon_HomingMissile].unknown10= 5;
defprojparams[Weapon_HomingMissile].unknown14= 100;
defprojparams[Weapon_HomingMissile].unknown18= 50;
defprojparams[Weapon_HomingMissile].unknown1C= 0;
defprojparams[Weapon_HomingMissile].unknown20= 0;
defprojparams[Weapon_HomingMissile].unknown24= 59;
defprojparams[Weapon_HomingMissile].unknown28= 1;
defprojparams[Weapon_HomingMissile].unknown2C= 0;
defprojparams[Weapon_HomingMissile].unknown30= 0;
defprojparams[Weapon_HomingMissile].unknown34= 100;
defprojparams[Weapon_HomingMissile].unknown38= 50;
defprojparams[Weapon_HomingMissile].unknown3C= 100;
defprojparams[Weapon_HomingMissile].unknown40= 0;
defprojparams[Weapon_HomingMissile].unknown44= 0;
defprojparams[Weapon_HomingMissile].unknown48= 100;
defprojparams[Weapon_HomingMissile].unknown4C= 0;
defprojparams[Weapon_HomingMissile].unknown50= 10000;
defprojparams[Weapon_HomingMissile].unknown54= 0;
defprojparams[Weapon_HomingMissile].unknown58= 0;
defprojparams[Weapon_HomingMissile].unknown5C= 0;
defprojparams[Weapon_HomingMissile].unknown60= 0;
defprojparams[Weapon_HomingMissile].unknown64= 0;
defprojparams[Weapon_HomingMissile].unknown68= 1;
defprojparams[Weapon_HomingMissile].unknown6C= 0;
defprojparams[Weapon_HomingMissile].unknown70= 58;
defprojparams[Weapon_HomingMissile].unknown74= 2;
defprojparams[Weapon_HomingMissile].unknown78= 131;
defprojparams[Weapon_HomingMissile].unknown7C= 50;
defprojparams[Weapon_HomingMissile].unknown80= 100;
defprojparams[Weapon_HomingMissile].unknown84= 50;
defprojparams[Weapon_HomingMissile].unknown88= 1;
defprojparams[Weapon_HomingMissile].unknown8C= 500;
defprojparams[Weapon_HomingMissile].unknown90= 3500;
defprojparams[Weapon_HomingMissile].unknown94= 0;
defprojparams[Weapon_HomingMissile].unknown98= 0;
defprojparams[Weapon_HomingMissile].unknown9C= 0;
defprojparams[Weapon_HomingMissile].unknownA0= 0;
defprojparams[Weapon_HomingMissile].unknownA4= 0;
defprojparams[Weapon_HomingMissile].unknownA8= 0;
defprojparams[Weapon_HomingMissile].unknownAC= 0;
defprojparams[Weapon_HomingMissile].unknownB0= 0;
defprojparams[Weapon_HomingMissile].unknownB4= 0;
defprojparams[Weapon_HomingMissile].unknownB8= 0;
defprojparams[Weapon_HomingMissile].unknownBC= 0;
defprojparams[Weapon_HomingMissile].unknownC0= 0;
defprojparams[Weapon_HomingMissile].unknownC4= 0;
defprojparams[Weapon_HomingMissile].unknownC8= 0;
defprojparams[Weapon_HomingMissile].unknownCC= 0;
defprojparams[Weapon_HomingMissile].unknownD0= 0;
defprojparams[Weapon_HomingMissile].unknownD4= 0;
defprojparams[Weapon_HomingMissile].unknownD8= 0;
defprojparams[Weapon_HomingMissile].unknownDC= 0;
defprojparams[Weapon_HomingMissile].unknownE0= 0;
defprojparams[Weapon_HomingMissile].unknownE4= 0;
defprojparams[Weapon_HomingMissile].unknownE8= 0;
defprojparams[Weapon_HomingMissile].unknownEC= 0;
defprojparams[Weapon_HomingMissile].unknownF0= 0;
defprojparams[Weapon_HomingMissile].unknownF4= 0;
defprojparams[Weapon_HomingMissile].unknownF8= 0;
defprojparams[Weapon_HomingMissile].unknownFC= 0;
defprojparams[Weapon_HomingMissile].unknown100= 0;
defprojparams[Weapon_HomingMissile].unknown104= 0;
defprojparams[Weapon_HomingMissile].unknown108= 0;
defprojparams[Weapon_HomingMissile].unknown10C= 0;
defprojparams[Weapon_HomingMissile].unknown110= 0;
defprojparams[Weapon_HomingMissile].unknown114= 0;
defprojparams[Weapon_HomingMissile].unknown118= 0;
defprojparams[Weapon_HomingMissile].unknown11C= 0;
defprojparams[Weapon_HomingMissile].unknown120= 0;
defprojparams[Weapon_HomingMissile].unknown124= 0;
defprojparams[Weapon_HomingMissile].unknown128= 0;
defprojparams[Weapon_HomingMissile].unknown12C= 0;
defprojparams[Weapon_HomingMissile].unknown130= 0;
defprojparams[Weapon_HomingMissile].unknown134= 0;
defprojparams[Weapon_HomingMissile].unknown138= 0;
defprojparams[Weapon_HomingMissile].unknown13C= 0;
defprojparams[Weapon_HomingMissile].unknown140= 0;
defprojparams[Weapon_HomingMissile].unknown144= 0;
defprojparams[Weapon_HomingMissile].unknown148= 0;
defprojparams[Weapon_HomingMissile].unknown14C= 0;
defprojparams[Weapon_HomingMissile].unknown150= 0;
defprojparams[Weapon_HomingMissile].unknown154= 0;
defprojparams[Weapon_HomingMissile].unknown158= 0;
defprojparams[Weapon_HomingMissile].unknown15C= 0;
defprojparams[Weapon_HomingMissile].unknown160= 0;
defprojparams[Weapon_HomingMissile].unknown164= 0;
defprojparams[Weapon_HomingMissile].unknown168= 0;
defprojparams[Weapon_HomingMissile].unknown16C= 0;
defprojparams[Weapon_HomingMissile].unknown170= 0;
defprojparams[Weapon_HomingMissile].unknown174= 0;
defprojparams[Weapon_Mortar] = WeaponProjectileParams.new()
defprojparams[Weapon_Mortar].unknown0= 2;
defprojparams[Weapon_Mortar].unknown4= 100;
defprojparams[Weapon_Mortar].unknown8= 0;
defprojparams[Weapon_Mortar].unknownC= 137342;
defprojparams[Weapon_Mortar].unknown10= 0;
defprojparams[Weapon_Mortar].unknown14= 0;
defprojparams[Weapon_Mortar].unknown18= 15;
defprojparams[Weapon_Mortar].unknown1C= 0;
defprojparams[Weapon_Mortar].unknown20= 0;
defprojparams[Weapon_Mortar].unknown24= 52;
defprojparams[Weapon_Mortar].unknown28= 2;
defprojparams[Weapon_Mortar].unknown2C= 131;
defprojparams[Weapon_Mortar].unknown30= 50;
defprojparams[Weapon_Mortar].unknown34= 100;
defprojparams[Weapon_Mortar].unknown38= 50;
defprojparams[Weapon_Mortar].unknown3C= 100;
defprojparams[Weapon_Mortar].unknown40= 0;
defprojparams[Weapon_Mortar].unknown44= 0;
defprojparams[Weapon_Mortar].unknown48= 100;
defprojparams[Weapon_Mortar].unknown4C= 0;
defprojparams[Weapon_Mortar].unknown50= 9000;
defprojparams[Weapon_Mortar].unknown54= 0;
defprojparams[Weapon_Mortar].unknown58= 0;
defprojparams[Weapon_Mortar].unknown5C= 0;
defprojparams[Weapon_Mortar].unknown60= 0;
defprojparams[Weapon_Mortar].unknown64= 0;
defprojparams[Weapon_Mortar].unknown68= 2;
defprojparams[Weapon_Mortar].unknown6C= 4194304;
defprojparams[Weapon_Mortar].unknown70= 1;
defprojparams[Weapon_Mortar].unknown74= 0;
defprojparams[Weapon_Mortar].unknown78= 0;
defprojparams[Weapon_Mortar].unknown7C= 8;
defprojparams[Weapon_Mortar].unknown80= 0;
defprojparams[Weapon_Mortar].unknown84= 0;
defprojparams[Weapon_Mortar].unknown88= 0;
defprojparams[Weapon_Mortar].unknown8C= 0;
defprojparams[Weapon_Mortar].unknown90= 0;
defprojparams[Weapon_Mortar].unknown94= 0;
defprojparams[Weapon_Mortar].unknown98= 0;
defprojparams[Weapon_Mortar].unknown9C= 0;
defprojparams[Weapon_Mortar].unknownA0= 0;
defprojparams[Weapon_Mortar].unknownA4= 0;
defprojparams[Weapon_Mortar].unknownA8= 0;
defprojparams[Weapon_Mortar].unknownAC= 0;
defprojparams[Weapon_Mortar].unknownB0= 0;
defprojparams[Weapon_Mortar].unknownB4= 1;
defprojparams[Weapon_Mortar].unknownB8= 0;
defprojparams[Weapon_Mortar].unknownBC= 5;
defprojparams[Weapon_Mortar].unknownC0= 20;
defprojparams[Weapon_Mortar].unknownC4= 30;
defprojparams[Weapon_Mortar].unknownC8= -1;
defprojparams[Weapon_Mortar].unknownCC= 40;
defprojparams[Weapon_Mortar].unknownD0= 137278;
defprojparams[Weapon_Mortar].unknownD4= 0;
defprojparams[Weapon_Mortar].unknownD8= 100;
defprojparams[Weapon_Mortar].unknownDC= 15;
defprojparams[Weapon_Mortar].unknownE0= 0;
defprojparams[Weapon_Mortar].unknownE4= 1;
defprojparams[Weapon_Mortar].unknownE8= 54;
defprojparams[Weapon_Mortar].unknownEC= 2;
defprojparams[Weapon_Mortar].unknownF0= 131;
defprojparams[Weapon_Mortar].unknownF4= 20;
defprojparams[Weapon_Mortar].unknownF8= 100;
defprojparams[Weapon_Mortar].unknownFC= 50;
defprojparams[Weapon_Mortar].unknown100= 100;
defprojparams[Weapon_Mortar].unknown104= 0;
defprojparams[Weapon_Mortar].unknown108= 0;
defprojparams[Weapon_Mortar].unknown10C= 100;
defprojparams[Weapon_Mortar].unknown110= 0;
defprojparams[Weapon_Mortar].unknown114= 9000;
defprojparams[Weapon_Mortar].unknown118= 0;
defprojparams[Weapon_Mortar].unknown11C= 0;
defprojparams[Weapon_Mortar].unknown120= 0;
defprojparams[Weapon_Mortar].unknown124= 0;
defprojparams[Weapon_Mortar].unknown128= 0;
defprojparams[Weapon_Mortar].unknown12C= 2;
defprojparams[Weapon_Mortar].unknown130= 4194304;
defprojparams[Weapon_Mortar].unknown134= 1;
defprojparams[Weapon_Mortar].unknown138= 0;
defprojparams[Weapon_Mortar].unknown13C= 0;
defprojparams[Weapon_Mortar].unknown140= 8;
defprojparams[Weapon_Mortar].unknown144= 0;
defprojparams[Weapon_Mortar].unknown148= 0;
defprojparams[Weapon_Mortar].unknown14C= 0;
defprojparams[Weapon_Mortar].unknown150= 0;
defprojparams[Weapon_Mortar].unknown154= 0;
defprojparams[Weapon_Mortar].unknown158= 0;
defprojparams[Weapon_Mortar].unknown15C= 0;
defprojparams[Weapon_Mortar].unknown160= 0;
defprojparams[Weapon_Mortar].unknown164= 0;
defprojparams[Weapon_Mortar].unknown168= 0;
defprojparams[Weapon_Mortar].unknown16C= 0;
defprojparams[Weapon_Mortar].unknown170= 0;
defprojparams[Weapon_Mortar].unknown174= 0;
defprojparams[Weapon_HomingPigeon] = WeaponProjectileParams.new()
defprojparams[Weapon_HomingPigeon].unknown0= 2;
defprojparams[Weapon_HomingPigeon].unknown4= 33;
defprojparams[Weapon_HomingPigeon].unknown8= 0;
defprojparams[Weapon_HomingPigeon].unknownC= 4331646;
defprojparams[Weapon_HomingPigeon].unknown10= 25;
defprojparams[Weapon_HomingPigeon].unknown14= 100;
defprojparams[Weapon_HomingPigeon].unknown18= 75;
defprojparams[Weapon_HomingPigeon].unknown1C= 0;
defprojparams[Weapon_HomingPigeon].unknown20= 0;
defprojparams[Weapon_HomingPigeon].unknown24= 175;
defprojparams[Weapon_HomingPigeon].unknown28= 3;
defprojparams[Weapon_HomingPigeon].unknown2C= 0;
defprojparams[Weapon_HomingPigeon].unknown30= 0;
defprojparams[Weapon_HomingPigeon].unknown34= 100;
defprojparams[Weapon_HomingPigeon].unknown38= 50;
defprojparams[Weapon_HomingPigeon].unknown3C= 100;
defprojparams[Weapon_HomingPigeon].unknown40= 0;
defprojparams[Weapon_HomingPigeon].unknown44= 0;
defprojparams[Weapon_HomingPigeon].unknown48= 100;
defprojparams[Weapon_HomingPigeon].unknown4C= 0;
defprojparams[Weapon_HomingPigeon].unknown50= 10000;
defprojparams[Weapon_HomingPigeon].unknown54= 0;
defprojparams[Weapon_HomingPigeon].unknown58= 0;
defprojparams[Weapon_HomingPigeon].unknown5C= 0;
defprojparams[Weapon_HomingPigeon].unknown60= 0;
defprojparams[Weapon_HomingPigeon].unknown64= 0;
defprojparams[Weapon_HomingPigeon].unknown68= 1;
defprojparams[Weapon_HomingPigeon].unknown6C= 0;
defprojparams[Weapon_HomingPigeon].unknown70= 175;
defprojparams[Weapon_HomingPigeon].unknown74= 3;
defprojparams[Weapon_HomingPigeon].unknown78= 134;
defprojparams[Weapon_HomingPigeon].unknown7C= 10;
defprojparams[Weapon_HomingPigeon].unknown80= 20;
defprojparams[Weapon_HomingPigeon].unknown84= 50;
defprojparams[Weapon_HomingPigeon].unknown88= 2;
defprojparams[Weapon_HomingPigeon].unknown8C= 505;
defprojparams[Weapon_HomingPigeon].unknown90= 4540;
defprojparams[Weapon_HomingPigeon].unknown94= 0;
defprojparams[Weapon_HomingPigeon].unknown98= 0;
defprojparams[Weapon_HomingPigeon].unknown9C= 0;
defprojparams[Weapon_HomingPigeon].unknownA0= 0;
defprojparams[Weapon_HomingPigeon].unknownA4= 0;
defprojparams[Weapon_HomingPigeon].unknownA8= 0;
defprojparams[Weapon_HomingPigeon].unknownAC= 0;
defprojparams[Weapon_HomingPigeon].unknownB0= 0;
defprojparams[Weapon_HomingPigeon].unknownB4= 0;
defprojparams[Weapon_HomingPigeon].unknownB8= 51;
defprojparams[Weapon_HomingPigeon].unknownBC= 0;
defprojparams[Weapon_HomingPigeon].unknownC0= 0;
defprojparams[Weapon_HomingPigeon].unknownC4= 0;
defprojparams[Weapon_HomingPigeon].unknownC8= 0;
defprojparams[Weapon_HomingPigeon].unknownCC= 0;
defprojparams[Weapon_HomingPigeon].unknownD0= 0;
defprojparams[Weapon_HomingPigeon].unknownD4= 0;
defprojparams[Weapon_HomingPigeon].unknownD8= 0;
defprojparams[Weapon_HomingPigeon].unknownDC= 0;
defprojparams[Weapon_HomingPigeon].unknownE0= 0;
defprojparams[Weapon_HomingPigeon].unknownE4= 0;
defprojparams[Weapon_HomingPigeon].unknownE8= 0;
defprojparams[Weapon_HomingPigeon].unknownEC= 0;
defprojparams[Weapon_HomingPigeon].unknownF0= 0;
defprojparams[Weapon_HomingPigeon].unknownF4= 0;
defprojparams[Weapon_HomingPigeon].unknownF8= 0;
defprojparams[Weapon_HomingPigeon].unknownFC= 0;
defprojparams[Weapon_HomingPigeon].unknown100= 0;
defprojparams[Weapon_HomingPigeon].unknown104= 0;
defprojparams[Weapon_HomingPigeon].unknown108= 0;
defprojparams[Weapon_HomingPigeon].unknown10C= 0;
defprojparams[Weapon_HomingPigeon].unknown110= 0;
defprojparams[Weapon_HomingPigeon].unknown114= 0;
defprojparams[Weapon_HomingPigeon].unknown118= 0;
defprojparams[Weapon_HomingPigeon].unknown11C= 0;
defprojparams[Weapon_HomingPigeon].unknown120= 0;
defprojparams[Weapon_HomingPigeon].unknown124= 0;
defprojparams[Weapon_HomingPigeon].unknown128= 0;
defprojparams[Weapon_HomingPigeon].unknown12C= 0;
defprojparams[Weapon_HomingPigeon].unknown130= 0;
defprojparams[Weapon_HomingPigeon].unknown134= 0;
defprojparams[Weapon_HomingPigeon].unknown138= 0;
defprojparams[Weapon_HomingPigeon].unknown13C= 0;
defprojparams[Weapon_HomingPigeon].unknown140= 0;
defprojparams[Weapon_HomingPigeon].unknown144= 0;
defprojparams[Weapon_HomingPigeon].unknown148= 0;
defprojparams[Weapon_HomingPigeon].unknown14C= 0;
defprojparams[Weapon_HomingPigeon].unknown150= 0;
defprojparams[Weapon_HomingPigeon].unknown154= 0;
defprojparams[Weapon_HomingPigeon].unknown158= 0;
defprojparams[Weapon_HomingPigeon].unknown15C= 0;
defprojparams[Weapon_HomingPigeon].unknown160= 0;
defprojparams[Weapon_HomingPigeon].unknown164= 0;
defprojparams[Weapon_HomingPigeon].unknown168= 0;
defprojparams[Weapon_HomingPigeon].unknown16C= 0;
defprojparams[Weapon_HomingPigeon].unknown170= 0;
defprojparams[Weapon_HomingPigeon].unknown174= 0;
defprojparams[Weapon_SheepLauncher] = WeaponProjectileParams.new()
defprojparams[Weapon_SheepLauncher].unknown0= 2;
defprojparams[Weapon_SheepLauncher].unknown4= 50;
defprojparams[Weapon_SheepLauncher].unknown8= 0;
defprojparams[Weapon_SheepLauncher].unknownC= 137342;
defprojparams[Weapon_SheepLauncher].unknown10= 0;
defprojparams[Weapon_SheepLauncher].unknown14= 0;
defprojparams[Weapon_SheepLauncher].unknown18= 0;
defprojparams[Weapon_SheepLauncher].unknown1C= 0;
defprojparams[Weapon_SheepLauncher].unknown20= 0;
defprojparams[Weapon_SheepLauncher].unknown24= 65;
defprojparams[Weapon_SheepLauncher].unknown28= 2;
defprojparams[Weapon_SheepLauncher].unknown2C= 131;
defprojparams[Weapon_SheepLauncher].unknown30= 50;
defprojparams[Weapon_SheepLauncher].unknown34= 100;
defprojparams[Weapon_SheepLauncher].unknown38= 50;
defprojparams[Weapon_SheepLauncher].unknown3C= 100;
defprojparams[Weapon_SheepLauncher].unknown40= 0;
defprojparams[Weapon_SheepLauncher].unknown44= 0;
defprojparams[Weapon_SheepLauncher].unknown48= 100;
defprojparams[Weapon_SheepLauncher].unknown4C= 0;
defprojparams[Weapon_SheepLauncher].unknown50= 20000;
defprojparams[Weapon_SheepLauncher].unknown54= 0;
defprojparams[Weapon_SheepLauncher].unknown58= 0;
defprojparams[Weapon_SheepLauncher].unknown5C= 0;
defprojparams[Weapon_SheepLauncher].unknown60= 0;
defprojparams[Weapon_SheepLauncher].unknown64= 1;
defprojparams[Weapon_SheepLauncher].unknown68= 5;
defprojparams[Weapon_SheepLauncher].unknown6C= 4194304;
defprojparams[Weapon_SheepLauncher].unknown70= 1;
defprojparams[Weapon_SheepLauncher].unknown74= 0;
defprojparams[Weapon_SheepLauncher].unknown78= 0;
defprojparams[Weapon_SheepLauncher].unknown7C= 8;
defprojparams[Weapon_SheepLauncher].unknown80= 0;
defprojparams[Weapon_SheepLauncher].unknown84= 0;
defprojparams[Weapon_SheepLauncher].unknown88= 0;
defprojparams[Weapon_SheepLauncher].unknown8C= 0;
defprojparams[Weapon_SheepLauncher].unknown90= 0;
defprojparams[Weapon_SheepLauncher].unknown94= 0;
defprojparams[Weapon_SheepLauncher].unknown98= 0;
defprojparams[Weapon_SheepLauncher].unknown9C= 0;
defprojparams[Weapon_SheepLauncher].unknownA0= 0;
defprojparams[Weapon_SheepLauncher].unknownA4= 0;
defprojparams[Weapon_SheepLauncher].unknownA8= 0;
defprojparams[Weapon_SheepLauncher].unknownAC= 0;
defprojparams[Weapon_SheepLauncher].unknownB0= 0;
defprojparams[Weapon_SheepLauncher].unknownB4= 3;
defprojparams[Weapon_SheepLauncher].unknownB8= 50;
defprojparams[Weapon_SheepLauncher].unknownBC= 1;
defprojparams[Weapon_SheepLauncher].unknownC0= 0;
defprojparams[Weapon_SheepLauncher].unknownC4= 0;
defprojparams[Weapon_SheepLauncher].unknownC8= 0;
defprojparams[Weapon_SheepLauncher].unknownCC= 0;
defprojparams[Weapon_SheepLauncher].unknownD0= 0;
defprojparams[Weapon_SheepLauncher].unknownD4= 0;
defprojparams[Weapon_SheepLauncher].unknownD8= 100;
defprojparams[Weapon_SheepLauncher].unknownDC= 75;
defprojparams[Weapon_SheepLauncher].unknownE0= 0;
defprojparams[Weapon_SheepLauncher].unknownE4= 1;
defprojparams[Weapon_SheepLauncher].unknownE8= 152;
defprojparams[Weapon_SheepLauncher].unknownEC= 6;
defprojparams[Weapon_SheepLauncher].unknownF0= 131;
defprojparams[Weapon_SheepLauncher].unknownF4= 0;
defprojparams[Weapon_SheepLauncher].unknownF8= 100;
defprojparams[Weapon_SheepLauncher].unknownFC= 50;
defprojparams[Weapon_SheepLauncher].unknown100= 100;
defprojparams[Weapon_SheepLauncher].unknown104= 0;
defprojparams[Weapon_SheepLauncher].unknown108= 0;
defprojparams[Weapon_SheepLauncher].unknown10C= 100;
defprojparams[Weapon_SheepLauncher].unknown110= 5000;
defprojparams[Weapon_SheepLauncher].unknown114= 20000;
defprojparams[Weapon_SheepLauncher].unknown118= 0;
defprojparams[Weapon_SheepLauncher].unknown11C= 0;
defprojparams[Weapon_SheepLauncher].unknown120= 0;
defprojparams[Weapon_SheepLauncher].unknown124= 0;
defprojparams[Weapon_SheepLauncher].unknown128= 1;
defprojparams[Weapon_SheepLauncher].unknown12C= 3;
defprojparams[Weapon_SheepLauncher].unknown130= 4331646;
defprojparams[Weapon_SheepLauncher].unknown134= 4331646;
defprojparams[Weapon_SheepLauncher].unknown138= 100;
defprojparams[Weapon_SheepLauncher].unknown13C= 4;
defprojparams[Weapon_SheepLauncher].unknown140= 0;
defprojparams[Weapon_SheepLauncher].unknown144= 0;
defprojparams[Weapon_SheepLauncher].unknown148= 0;
defprojparams[Weapon_SheepLauncher].unknown14C= 25;
defprojparams[Weapon_SheepLauncher].unknown150= 100;
defprojparams[Weapon_SheepLauncher].unknown154= 50;
defprojparams[Weapon_SheepLauncher].unknown158= -10;
defprojparams[Weapon_SheepLauncher].unknown15C= 0;
defprojparams[Weapon_SheepLauncher].unknown160= 0;
defprojparams[Weapon_SheepLauncher].unknown164= 0;
defprojparams[Weapon_SheepLauncher].unknown168= 0;
defprojparams[Weapon_SheepLauncher].unknown16C= 0;
defprojparams[Weapon_SheepLauncher].unknown170= 0;
defprojparams[Weapon_SheepLauncher].unknown174= 0;
defprojparams[Weapon_Grenade] = WeaponProjectileParams.new()
defprojparams[Weapon_Grenade].unknown0= 2;
defprojparams[Weapon_Grenade].unknown4= 0;
defprojparams[Weapon_Grenade].unknown8= 1;
defprojparams[Weapon_Grenade].unknownC= 0;
defprojparams[Weapon_Grenade].unknown10= 10;
defprojparams[Weapon_Grenade].unknown14= 100;
defprojparams[Weapon_Grenade].unknown18= 50;
defprojparams[Weapon_Grenade].unknown1C= 0;
defprojparams[Weapon_Grenade].unknown20= 0;
defprojparams[Weapon_Grenade].unknown24= 50;
defprojparams[Weapon_Grenade].unknown28= 1;
defprojparams[Weapon_Grenade].unknown2C= 131;
defprojparams[Weapon_Grenade].unknown30= 0;
defprojparams[Weapon_Grenade].unknown34= 100;
defprojparams[Weapon_Grenade].unknown38= 50;
defprojparams[Weapon_Grenade].unknown3C= 100;
defprojparams[Weapon_Grenade].unknown40= 0;
defprojparams[Weapon_Grenade].unknown44= 0;
defprojparams[Weapon_Grenade].unknown48= 100;
defprojparams[Weapon_Grenade].unknown4C= 5000;
defprojparams[Weapon_Grenade].unknown50= 0;
defprojparams[Weapon_Grenade].unknown54= 0;
defprojparams[Weapon_Grenade].unknown58= 0;
defprojparams[Weapon_Grenade].unknown5C= 0;
defprojparams[Weapon_Grenade].unknown60= 0;
defprojparams[Weapon_Grenade].unknown64= 0;
defprojparams[Weapon_Grenade].unknown68= 2;
defprojparams[Weapon_Grenade].unknown6C= 4331614;
defprojparams[Weapon_Grenade].unknown70= 0;
defprojparams[Weapon_Grenade].unknown74= 100;
defprojparams[Weapon_Grenade].unknown78= 113;
defprojparams[Weapon_Grenade].unknown7C= 8;
defprojparams[Weapon_Grenade].unknown80= 0;
defprojparams[Weapon_Grenade].unknown84= 0;
defprojparams[Weapon_Grenade].unknown88= 0;
defprojparams[Weapon_Grenade].unknown8C= 0;
defprojparams[Weapon_Grenade].unknown90= 0;
defprojparams[Weapon_Grenade].unknown94= 0;
defprojparams[Weapon_Grenade].unknown98= 0;
defprojparams[Weapon_Grenade].unknown9C= 0;
defprojparams[Weapon_Grenade].unknownA0= 0;
defprojparams[Weapon_Grenade].unknownA4= 0;
defprojparams[Weapon_Grenade].unknownA8= 0;
defprojparams[Weapon_Grenade].unknownAC= 0;
defprojparams[Weapon_Grenade].unknownB0= 0;
defprojparams[Weapon_Grenade].unknownB4= 0;
defprojparams[Weapon_Grenade].unknownB8= 0;
defprojparams[Weapon_Grenade].unknownBC= 0;
defprojparams[Weapon_Grenade].unknownC0= 0;
defprojparams[Weapon_Grenade].unknownC4= 0;
defprojparams[Weapon_Grenade].unknownC8= 0;
defprojparams[Weapon_Grenade].unknownCC= 0;
defprojparams[Weapon_Grenade].unknownD0= 0;
defprojparams[Weapon_Grenade].unknownD4= 0;
defprojparams[Weapon_Grenade].unknownD8= 0;
defprojparams[Weapon_Grenade].unknownDC= 0;
defprojparams[Weapon_Grenade].unknownE0= 0;
defprojparams[Weapon_Grenade].unknownE4= 0;
defprojparams[Weapon_Grenade].unknownE8= 0;
defprojparams[Weapon_Grenade].unknownEC= 0;
defprojparams[Weapon_Grenade].unknownF0= 0;
defprojparams[Weapon_Grenade].unknownF4= 0;
defprojparams[Weapon_Grenade].unknownF8= 0;
defprojparams[Weapon_Grenade].unknownFC= 0;
defprojparams[Weapon_Grenade].unknown100= 0;
defprojparams[Weapon_Grenade].unknown104= 0;
defprojparams[Weapon_Grenade].unknown108= 0;
defprojparams[Weapon_Grenade].unknown10C= 0;
defprojparams[Weapon_Grenade].unknown110= 0;
defprojparams[Weapon_Grenade].unknown114= 0;
defprojparams[Weapon_Grenade].unknown118= 0;
defprojparams[Weapon_Grenade].unknown11C= 0;
defprojparams[Weapon_Grenade].unknown120= 0;
defprojparams[Weapon_Grenade].unknown124= 0;
defprojparams[Weapon_Grenade].unknown128= 0;
defprojparams[Weapon_Grenade].unknown12C= 0;
defprojparams[Weapon_Grenade].unknown130= 0;
defprojparams[Weapon_Grenade].unknown134= 0;
defprojparams[Weapon_Grenade].unknown138= 0;
defprojparams[Weapon_Grenade].unknown13C= 0;
defprojparams[Weapon_Grenade].unknown140= 0;
defprojparams[Weapon_Grenade].unknown144= 0;
defprojparams[Weapon_Grenade].unknown148= 0;
defprojparams[Weapon_Grenade].unknown14C= 0;
defprojparams[Weapon_Grenade].unknown150= 0;
defprojparams[Weapon_Grenade].unknown154= 0;
defprojparams[Weapon_Grenade].unknown158= 0;
defprojparams[Weapon_Grenade].unknown15C= 0;
defprojparams[Weapon_Grenade].unknown160= 0;
defprojparams[Weapon_Grenade].unknown164= 0;
defprojparams[Weapon_Grenade].unknown168= 0;
defprojparams[Weapon_Grenade].unknown16C= 0;
defprojparams[Weapon_Grenade].unknown170= 0;
defprojparams[Weapon_Grenade].unknown174= 0;
defprojparams[Weapon_ClusterBomb] = WeaponProjectileParams.new()
defprojparams[Weapon_ClusterBomb].unknown0= 2;
defprojparams[Weapon_ClusterBomb].unknown4= 0;
defprojparams[Weapon_ClusterBomb].unknown8= 1;
defprojparams[Weapon_ClusterBomb].unknownC= 0;
defprojparams[Weapon_ClusterBomb].unknown10= 0;
defprojparams[Weapon_ClusterBomb].unknown14= 0;
defprojparams[Weapon_ClusterBomb].unknown18= 20;
defprojparams[Weapon_ClusterBomb].unknown1C= 0;
defprojparams[Weapon_ClusterBomb].unknown20= 0;
defprojparams[Weapon_ClusterBomb].unknown24= 53;
defprojparams[Weapon_ClusterBomb].unknown28= 1;
defprojparams[Weapon_ClusterBomb].unknown2C= 131;
defprojparams[Weapon_ClusterBomb].unknown30= 0;
defprojparams[Weapon_ClusterBomb].unknown34= 100;
defprojparams[Weapon_ClusterBomb].unknown38= 50;
defprojparams[Weapon_ClusterBomb].unknown3C= 100;
defprojparams[Weapon_ClusterBomb].unknown40= 0;
defprojparams[Weapon_ClusterBomb].unknown44= 0;
defprojparams[Weapon_ClusterBomb].unknown48= 100;
defprojparams[Weapon_ClusterBomb].unknown4C= 5000;
defprojparams[Weapon_ClusterBomb].unknown50= 0;
defprojparams[Weapon_ClusterBomb].unknown54= 0;
defprojparams[Weapon_ClusterBomb].unknown58= 0;
defprojparams[Weapon_ClusterBomb].unknown5C= 0;
defprojparams[Weapon_ClusterBomb].unknown60= 0;
defprojparams[Weapon_ClusterBomb].unknown64= 0;
defprojparams[Weapon_ClusterBomb].unknown68= 2;
defprojparams[Weapon_ClusterBomb].unknown6C= 4331614;
defprojparams[Weapon_ClusterBomb].unknown70= 0;
defprojparams[Weapon_ClusterBomb].unknown74= 100;
defprojparams[Weapon_ClusterBomb].unknown78= 113;
defprojparams[Weapon_ClusterBomb].unknown7C= 8;
defprojparams[Weapon_ClusterBomb].unknown80= 0;
defprojparams[Weapon_ClusterBomb].unknown84= 0;
defprojparams[Weapon_ClusterBomb].unknown88= 0;
defprojparams[Weapon_ClusterBomb].unknown8C= 0;
defprojparams[Weapon_ClusterBomb].unknown90= 0;
defprojparams[Weapon_ClusterBomb].unknown94= 0;
defprojparams[Weapon_ClusterBomb].unknown98= 0;
defprojparams[Weapon_ClusterBomb].unknown9C= 0;
defprojparams[Weapon_ClusterBomb].unknownA0= 0;
defprojparams[Weapon_ClusterBomb].unknownA4= 0;
defprojparams[Weapon_ClusterBomb].unknownA8= 0;
defprojparams[Weapon_ClusterBomb].unknownAC= 0;
defprojparams[Weapon_ClusterBomb].unknownB0= 0;
defprojparams[Weapon_ClusterBomb].unknownB4= 1;
defprojparams[Weapon_ClusterBomb].unknownB8= 0;
defprojparams[Weapon_ClusterBomb].unknownBC= 5;
defprojparams[Weapon_ClusterBomb].unknownC0= 30;
defprojparams[Weapon_ClusterBomb].unknownC4= 30;
defprojparams[Weapon_ClusterBomb].unknownC8= 0;
defprojparams[Weapon_ClusterBomb].unknownCC= 45;
defprojparams[Weapon_ClusterBomb].unknownD0= 137342;
defprojparams[Weapon_ClusterBomb].unknownD4= 0;
defprojparams[Weapon_ClusterBomb].unknownD8= 100;
defprojparams[Weapon_ClusterBomb].unknownDC= 20;
defprojparams[Weapon_ClusterBomb].unknownE0= 0;
defprojparams[Weapon_ClusterBomb].unknownE4= 1;
defprojparams[Weapon_ClusterBomb].unknownE8= 54;
defprojparams[Weapon_ClusterBomb].unknownEC= 1;
defprojparams[Weapon_ClusterBomb].unknownF0= 131;
defprojparams[Weapon_ClusterBomb].unknownF4= 20;
defprojparams[Weapon_ClusterBomb].unknownF8= 100;
defprojparams[Weapon_ClusterBomb].unknownFC= 50;
defprojparams[Weapon_ClusterBomb].unknown100= 100;
defprojparams[Weapon_ClusterBomb].unknown104= 0;
defprojparams[Weapon_ClusterBomb].unknown108= 0;
defprojparams[Weapon_ClusterBomb].unknown10C= 100;
defprojparams[Weapon_ClusterBomb].unknown110= 0;
defprojparams[Weapon_ClusterBomb].unknown114= 9000;
defprojparams[Weapon_ClusterBomb].unknown118= 0;
defprojparams[Weapon_ClusterBomb].unknown11C= 0;
defprojparams[Weapon_ClusterBomb].unknown120= 0;
defprojparams[Weapon_ClusterBomb].unknown124= 0;
defprojparams[Weapon_ClusterBomb].unknown128= 0;
defprojparams[Weapon_ClusterBomb].unknown12C= 2;
defprojparams[Weapon_ClusterBomb].unknown130= 4331614;
defprojparams[Weapon_ClusterBomb].unknown134= 0;
defprojparams[Weapon_ClusterBomb].unknown138= 100;
defprojparams[Weapon_ClusterBomb].unknown13C= 113;
defprojparams[Weapon_ClusterBomb].unknown140= 8;
defprojparams[Weapon_ClusterBomb].unknown144= 0;
defprojparams[Weapon_ClusterBomb].unknown148= 0;
defprojparams[Weapon_ClusterBomb].unknown14C= 0;
defprojparams[Weapon_ClusterBomb].unknown150= 0;
defprojparams[Weapon_ClusterBomb].unknown154= 0;
defprojparams[Weapon_ClusterBomb].unknown158= 0;
defprojparams[Weapon_ClusterBomb].unknown15C= 0;
defprojparams[Weapon_ClusterBomb].unknown160= 0;
defprojparams[Weapon_ClusterBomb].unknown164= 0;
defprojparams[Weapon_ClusterBomb].unknown168= 0;
defprojparams[Weapon_ClusterBomb].unknown16C= 0;
defprojparams[Weapon_ClusterBomb].unknown170= 0;
defprojparams[Weapon_ClusterBomb].unknown174= 0;
defprojparams[Weapon_BananaBomb] = WeaponProjectileParams.new()
defprojparams[Weapon_BananaBomb].unknown0= 2;
defprojparams[Weapon_BananaBomb].unknown4= 0;
defprojparams[Weapon_BananaBomb].unknown8= 1;
defprojparams[Weapon_BananaBomb].unknownC= 0;
defprojparams[Weapon_BananaBomb].unknown10= 40;
defprojparams[Weapon_BananaBomb].unknown14= 80;
defprojparams[Weapon_BananaBomb].unknown18= 60;
defprojparams[Weapon_BananaBomb].unknown1C= 0;
defprojparams[Weapon_BananaBomb].unknown20= 0;
defprojparams[Weapon_BananaBomb].unknown24= 51;
defprojparams[Weapon_BananaBomb].unknown28= 1;
defprojparams[Weapon_BananaBomb].unknown2C= 131;
defprojparams[Weapon_BananaBomb].unknown30= 0;
defprojparams[Weapon_BananaBomb].unknown34= 100;
defprojparams[Weapon_BananaBomb].unknown38= 50;
defprojparams[Weapon_BananaBomb].unknown3C= 100;
defprojparams[Weapon_BananaBomb].unknown40= 0;
defprojparams[Weapon_BananaBomb].unknown44= 0;
defprojparams[Weapon_BananaBomb].unknown48= 100;
defprojparams[Weapon_BananaBomb].unknown4C= 5000;
defprojparams[Weapon_BananaBomb].unknown50= 0;
defprojparams[Weapon_BananaBomb].unknown54= 0;
defprojparams[Weapon_BananaBomb].unknown58= 0;
defprojparams[Weapon_BananaBomb].unknown5C= 0;
defprojparams[Weapon_BananaBomb].unknown60= 0;
defprojparams[Weapon_BananaBomb].unknown64= 0;
defprojparams[Weapon_BananaBomb].unknown68= 2;
defprojparams[Weapon_BananaBomb].unknown6C= 4331614;
defprojparams[Weapon_BananaBomb].unknown70= 60;
defprojparams[Weapon_BananaBomb].unknown74= 100;
defprojparams[Weapon_BananaBomb].unknown78= 111;
defprojparams[Weapon_BananaBomb].unknown7C= 8;
defprojparams[Weapon_BananaBomb].unknown80= 0;
defprojparams[Weapon_BananaBomb].unknown84= 0;
defprojparams[Weapon_BananaBomb].unknown88= 0;
defprojparams[Weapon_BananaBomb].unknown8C= 0;
defprojparams[Weapon_BananaBomb].unknown90= 0;
defprojparams[Weapon_BananaBomb].unknown94= 0;
defprojparams[Weapon_BananaBomb].unknown98= 0;
defprojparams[Weapon_BananaBomb].unknown9C= 0;
defprojparams[Weapon_BananaBomb].unknownA0= 0;
defprojparams[Weapon_BananaBomb].unknownA4= 0;
defprojparams[Weapon_BananaBomb].unknownA8= 0;
defprojparams[Weapon_BananaBomb].unknownAC= 0;
defprojparams[Weapon_BananaBomb].unknownB0= 0;
defprojparams[Weapon_BananaBomb].unknownB4= 1;
defprojparams[Weapon_BananaBomb].unknownB8= 0;
defprojparams[Weapon_BananaBomb].unknownBC= 4;
defprojparams[Weapon_BananaBomb].unknownC0= 36;
defprojparams[Weapon_BananaBomb].unknownC4= 30;
defprojparams[Weapon_BananaBomb].unknownC8= 0;
defprojparams[Weapon_BananaBomb].unknownCC= 20;
defprojparams[Weapon_BananaBomb].unknownD0= 137342;
defprojparams[Weapon_BananaBomb].unknownD4= 0;
defprojparams[Weapon_BananaBomb].unknownD8= 100;
defprojparams[Weapon_BananaBomb].unknownDC= 60;
defprojparams[Weapon_BananaBomb].unknownE0= 0;
defprojparams[Weapon_BananaBomb].unknownE4= 1;
defprojparams[Weapon_BananaBomb].unknownE8= 51;
defprojparams[Weapon_BananaBomb].unknownEC= 1;
defprojparams[Weapon_BananaBomb].unknownF0= 131;
defprojparams[Weapon_BananaBomb].unknownF4= 0;
defprojparams[Weapon_BananaBomb].unknownF8= 100;
defprojparams[Weapon_BananaBomb].unknownFC= 50;
defprojparams[Weapon_BananaBomb].unknown100= 100;
defprojparams[Weapon_BananaBomb].unknown104= 0;
defprojparams[Weapon_BananaBomb].unknown108= 0;
defprojparams[Weapon_BananaBomb].unknown10C= 100;
defprojparams[Weapon_BananaBomb].unknown110= 0;
defprojparams[Weapon_BananaBomb].unknown114= 9000;
defprojparams[Weapon_BananaBomb].unknown118= 0;
defprojparams[Weapon_BananaBomb].unknown11C= 0;
defprojparams[Weapon_BananaBomb].unknown120= 0;
defprojparams[Weapon_BananaBomb].unknown124= 0;
defprojparams[Weapon_BananaBomb].unknown128= 0;
defprojparams[Weapon_BananaBomb].unknown12C= 2;
defprojparams[Weapon_BananaBomb].unknown130= 4331614;
defprojparams[Weapon_BananaBomb].unknown134= 60;
defprojparams[Weapon_BananaBomb].unknown138= 100;
defprojparams[Weapon_BananaBomb].unknown13C= 111;
defprojparams[Weapon_BananaBomb].unknown140= 8;
defprojparams[Weapon_BananaBomb].unknown144= 0;
defprojparams[Weapon_BananaBomb].unknown148= 0;
defprojparams[Weapon_BananaBomb].unknown14C= 0;
defprojparams[Weapon_BananaBomb].unknown150= 0;
defprojparams[Weapon_BananaBomb].unknown154= 0;
defprojparams[Weapon_BananaBomb].unknown158= 0;
defprojparams[Weapon_BananaBomb].unknown15C= 0;
defprojparams[Weapon_BananaBomb].unknown160= 0;
defprojparams[Weapon_BananaBomb].unknown164= 0;
defprojparams[Weapon_BananaBomb].unknown168= 0;
defprojparams[Weapon_BananaBomb].unknown16C= 0;
defprojparams[Weapon_BananaBomb].unknown170= 0;
defprojparams[Weapon_BananaBomb].unknown174= 0;
defprojparams[Weapon_Dynamite] = WeaponProjectileParams.new()
defprojparams[Weapon_Dynamite].unknown0= 2;
defprojparams[Weapon_Dynamite].unknown4= 5;
defprojparams[Weapon_Dynamite].unknown8= 1;
defprojparams[Weapon_Dynamite].unknownC= 0;
defprojparams[Weapon_Dynamite].unknown10= 50;
defprojparams[Weapon_Dynamite].unknown14= 100;
defprojparams[Weapon_Dynamite].unknown18= 75;
defprojparams[Weapon_Dynamite].unknown1C= 0;
defprojparams[Weapon_Dynamite].unknown20= 0;
defprojparams[Weapon_Dynamite].unknown24= 78;
defprojparams[Weapon_Dynamite].unknown28= 0;
defprojparams[Weapon_Dynamite].unknown2C= 131;
defprojparams[Weapon_Dynamite].unknown30= 0;
defprojparams[Weapon_Dynamite].unknown34= 100;
defprojparams[Weapon_Dynamite].unknown38= 50;
defprojparams[Weapon_Dynamite].unknown3C= 100;
defprojparams[Weapon_Dynamite].unknown40= 0;
defprojparams[Weapon_Dynamite].unknown44= 0;
defprojparams[Weapon_Dynamite].unknown48= 100;
defprojparams[Weapon_Dynamite].unknown4C= 5000;
defprojparams[Weapon_Dynamite].unknown50= 5000;
defprojparams[Weapon_Dynamite].unknown54= 65602;
defprojparams[Weapon_Dynamite].unknown58= 0;
defprojparams[Weapon_Dynamite].unknown5C= 0;
defprojparams[Weapon_Dynamite].unknown60= 0;
defprojparams[Weapon_Dynamite].unknown64= 0;
defprojparams[Weapon_Dynamite].unknown68= 2;
defprojparams[Weapon_Dynamite].unknown6C= 4331614;
defprojparams[Weapon_Dynamite].unknown70= 30;
defprojparams[Weapon_Dynamite].unknown74= 0;
defprojparams[Weapon_Dynamite].unknown78= 113;
defprojparams[Weapon_Dynamite].unknown7C= 8;
defprojparams[Weapon_Dynamite].unknown80= 0;
defprojparams[Weapon_Dynamite].unknown84= 0;
defprojparams[Weapon_Dynamite].unknown88= 0;
defprojparams[Weapon_Dynamite].unknown8C= 0;
defprojparams[Weapon_Dynamite].unknown90= 0;
defprojparams[Weapon_Dynamite].unknown94= 0;
defprojparams[Weapon_Dynamite].unknown98= 0;
defprojparams[Weapon_Dynamite].unknown9C= 0;
defprojparams[Weapon_Dynamite].unknownA0= 0;
defprojparams[Weapon_Dynamite].unknownA4= 0;
defprojparams[Weapon_Dynamite].unknownA8= 0;
defprojparams[Weapon_Dynamite].unknownAC= 0;
defprojparams[Weapon_Dynamite].unknownB0= 0;
defprojparams[Weapon_Dynamite].unknownB4= 0;
defprojparams[Weapon_Dynamite].unknownB8= 0;
defprojparams[Weapon_Dynamite].unknownBC= 0;
defprojparams[Weapon_Dynamite].unknownC0= 0;
defprojparams[Weapon_Dynamite].unknownC4= 0;
defprojparams[Weapon_Dynamite].unknownC8= 0;
defprojparams[Weapon_Dynamite].unknownCC= 0;
defprojparams[Weapon_Dynamite].unknownD0= 0;
defprojparams[Weapon_Dynamite].unknownD4= 0;
defprojparams[Weapon_Dynamite].unknownD8= 0;
defprojparams[Weapon_Dynamite].unknownDC= 0;
defprojparams[Weapon_Dynamite].unknownE0= 0;
defprojparams[Weapon_Dynamite].unknownE4= 0;
defprojparams[Weapon_Dynamite].unknownE8= 0;
defprojparams[Weapon_Dynamite].unknownEC= 0;
defprojparams[Weapon_Dynamite].unknownF0= 0;
defprojparams[Weapon_Dynamite].unknownF4= 0;
defprojparams[Weapon_Dynamite].unknownF8= 0;
defprojparams[Weapon_Dynamite].unknownFC= 0;
defprojparams[Weapon_Dynamite].unknown100= 0;
defprojparams[Weapon_Dynamite].unknown104= 0;
defprojparams[Weapon_Dynamite].unknown108= 0;
defprojparams[Weapon_Dynamite].unknown10C= 0;
defprojparams[Weapon_Dynamite].unknown110= 0;
defprojparams[Weapon_Dynamite].unknown114= 0;
defprojparams[Weapon_Dynamite].unknown118= 0;
defprojparams[Weapon_Dynamite].unknown11C= 0;
defprojparams[Weapon_Dynamite].unknown120= 0;
defprojparams[Weapon_Dynamite].unknown124= 0;
defprojparams[Weapon_Dynamite].unknown128= 0;
defprojparams[Weapon_Dynamite].unknown12C= 0;
defprojparams[Weapon_Dynamite].unknown130= 0;
defprojparams[Weapon_Dynamite].unknown134= 0;
defprojparams[Weapon_Dynamite].unknown138= 0;
defprojparams[Weapon_Dynamite].unknown13C= 0;
defprojparams[Weapon_Dynamite].unknown140= 0;
defprojparams[Weapon_Dynamite].unknown144= 0;
defprojparams[Weapon_Dynamite].unknown148= 0;
defprojparams[Weapon_Dynamite].unknown14C= 0;
defprojparams[Weapon_Dynamite].unknown150= 0;
defprojparams[Weapon_Dynamite].unknown154= 0;
defprojparams[Weapon_Dynamite].unknown158= 0;
defprojparams[Weapon_Dynamite].unknown15C= 0;
defprojparams[Weapon_Dynamite].unknown160= 0;
defprojparams[Weapon_Dynamite].unknown164= 0;
defprojparams[Weapon_Dynamite].unknown168= 0;
defprojparams[Weapon_Dynamite].unknown16C= 0;
defprojparams[Weapon_Dynamite].unknown170= 0;
defprojparams[Weapon_Dynamite].unknown174= 0;
defprojparams[Weapon_Sheep] = WeaponProjectileParams.new()
defprojparams[Weapon_Sheep].unknown0= 2;
defprojparams[Weapon_Sheep].unknown4= 5;
defprojparams[Weapon_Sheep].unknown8= 0;
defprojparams[Weapon_Sheep].unknownC= 0;
defprojparams[Weapon_Sheep].unknown10= 50;
defprojparams[Weapon_Sheep].unknown14= 100;
defprojparams[Weapon_Sheep].unknown18= 75;
defprojparams[Weapon_Sheep].unknown1C= 0;
defprojparams[Weapon_Sheep].unknown20= 0;
defprojparams[Weapon_Sheep].unknown24= 153;
defprojparams[Weapon_Sheep].unknown28= 6;
defprojparams[Weapon_Sheep].unknown2C= 131;
defprojparams[Weapon_Sheep].unknown30= 0;
defprojparams[Weapon_Sheep].unknown34= 100;
defprojparams[Weapon_Sheep].unknown38= 50;
defprojparams[Weapon_Sheep].unknown3C= 100;
defprojparams[Weapon_Sheep].unknown40= 0;
defprojparams[Weapon_Sheep].unknown44= 0;
defprojparams[Weapon_Sheep].unknown48= 100;
defprojparams[Weapon_Sheep].unknown4C= 5000;
defprojparams[Weapon_Sheep].unknown50= 20000;
defprojparams[Weapon_Sheep].unknown54= 0;
defprojparams[Weapon_Sheep].unknown58= 0;
defprojparams[Weapon_Sheep].unknown5C= 0;
defprojparams[Weapon_Sheep].unknown60= 0;
defprojparams[Weapon_Sheep].unknown64= 1;
defprojparams[Weapon_Sheep].unknown68= 3;
defprojparams[Weapon_Sheep].unknown6C= 4331646;
defprojparams[Weapon_Sheep].unknown70= 4331646;
defprojparams[Weapon_Sheep].unknown74= 100;
defprojparams[Weapon_Sheep].unknown78= 4;
defprojparams[Weapon_Sheep].unknown7C= 0;
defprojparams[Weapon_Sheep].unknown80= 0;
defprojparams[Weapon_Sheep].unknown84= 0;
defprojparams[Weapon_Sheep].unknown88= 25;
defprojparams[Weapon_Sheep].unknown8C= 100;
defprojparams[Weapon_Sheep].unknown90= 50;
defprojparams[Weapon_Sheep].unknown94= -10;
defprojparams[Weapon_Sheep].unknown98= 0;
defprojparams[Weapon_Sheep].unknown9C= 0;
defprojparams[Weapon_Sheep].unknownA0= 0;
defprojparams[Weapon_Sheep].unknownA4= 0;
defprojparams[Weapon_Sheep].unknownA8= 0;
defprojparams[Weapon_Sheep].unknownAC= 0;
defprojparams[Weapon_Sheep].unknownB0= 0;
defprojparams[Weapon_Sheep].unknownB4= 0;
defprojparams[Weapon_Sheep].unknownB8= 0;
defprojparams[Weapon_Sheep].unknownBC= 0;
defprojparams[Weapon_Sheep].unknownC0= 0;
defprojparams[Weapon_Sheep].unknownC4= 0;
defprojparams[Weapon_Sheep].unknownC8= 0;
defprojparams[Weapon_Sheep].unknownCC= 0;
defprojparams[Weapon_Sheep].unknownD0= 0;
defprojparams[Weapon_Sheep].unknownD4= 0;
defprojparams[Weapon_Sheep].unknownD8= 0;
defprojparams[Weapon_Sheep].unknownDC= 0;
defprojparams[Weapon_Sheep].unknownE0= 0;
defprojparams[Weapon_Sheep].unknownE4= 0;
defprojparams[Weapon_Sheep].unknownE8= 0;
defprojparams[Weapon_Sheep].unknownEC= 0;
defprojparams[Weapon_Sheep].unknownF0= 0;
defprojparams[Weapon_Sheep].unknownF4= 0;
defprojparams[Weapon_Sheep].unknownF8= 0;
defprojparams[Weapon_Sheep].unknownFC= 0;
defprojparams[Weapon_Sheep].unknown100= 0;
defprojparams[Weapon_Sheep].unknown104= 0;
defprojparams[Weapon_Sheep].unknown108= 0;
defprojparams[Weapon_Sheep].unknown10C= 0;
defprojparams[Weapon_Sheep].unknown110= 0;
defprojparams[Weapon_Sheep].unknown114= 0;
defprojparams[Weapon_Sheep].unknown118= 0;
defprojparams[Weapon_Sheep].unknown11C= 0;
defprojparams[Weapon_Sheep].unknown120= 0;
defprojparams[Weapon_Sheep].unknown124= 0;
defprojparams[Weapon_Sheep].unknown128= 0;
defprojparams[Weapon_Sheep].unknown12C= 0;
defprojparams[Weapon_Sheep].unknown130= 0;
defprojparams[Weapon_Sheep].unknown134= 0;
defprojparams[Weapon_Sheep].unknown138= 0;
defprojparams[Weapon_Sheep].unknown13C= 0;
defprojparams[Weapon_Sheep].unknown140= 0;
defprojparams[Weapon_Sheep].unknown144= 0;
defprojparams[Weapon_Sheep].unknown148= 0;
defprojparams[Weapon_Sheep].unknown14C= 0;
defprojparams[Weapon_Sheep].unknown150= 0;
defprojparams[Weapon_Sheep].unknown154= 0;
defprojparams[Weapon_Sheep].unknown158= 0;
defprojparams[Weapon_Sheep].unknown15C= 0;
defprojparams[Weapon_Sheep].unknown160= 0;
defprojparams[Weapon_Sheep].unknown164= 0;
defprojparams[Weapon_Sheep].unknown168= 0;
defprojparams[Weapon_Sheep].unknown16C= 0;
defprojparams[Weapon_Sheep].unknown170= 0;
defprojparams[Weapon_Sheep].unknown174= 0;
defprojparams[Weapon_SuperSheep] = WeaponProjectileParams.new()
defprojparams[Weapon_SuperSheep].unknown0= 2;
defprojparams[Weapon_SuperSheep].unknown4= 5;
defprojparams[Weapon_SuperSheep].unknown8= 0;
defprojparams[Weapon_SuperSheep].unknownC= 0;
defprojparams[Weapon_SuperSheep].unknown10= 50;
defprojparams[Weapon_SuperSheep].unknown14= 100;
defprojparams[Weapon_SuperSheep].unknown18= 75;
defprojparams[Weapon_SuperSheep].unknown1C= 0;
defprojparams[Weapon_SuperSheep].unknown20= 0;
defprojparams[Weapon_SuperSheep].unknown24= 153;
defprojparams[Weapon_SuperSheep].unknown28= 6;
defprojparams[Weapon_SuperSheep].unknown2C= 131;
defprojparams[Weapon_SuperSheep].unknown30= 0;
defprojparams[Weapon_SuperSheep].unknown34= 100;
defprojparams[Weapon_SuperSheep].unknown38= 200;
defprojparams[Weapon_SuperSheep].unknown3C= 100;
defprojparams[Weapon_SuperSheep].unknown40= 0;
defprojparams[Weapon_SuperSheep].unknown44= 0;
defprojparams[Weapon_SuperSheep].unknown48= 100;
defprojparams[Weapon_SuperSheep].unknown4C= 5000;
defprojparams[Weapon_SuperSheep].unknown50= 20000;
defprojparams[Weapon_SuperSheep].unknown54= 0;
defprojparams[Weapon_SuperSheep].unknown58= 0;
defprojparams[Weapon_SuperSheep].unknown5C= 0;
defprojparams[Weapon_SuperSheep].unknown60= 0;
defprojparams[Weapon_SuperSheep].unknown64= 1;
defprojparams[Weapon_SuperSheep].unknown68= 3;
defprojparams[Weapon_SuperSheep].unknown6C= 4331646;
defprojparams[Weapon_SuperSheep].unknown70= 137342;
defprojparams[Weapon_SuperSheep].unknown74= 100;
defprojparams[Weapon_SuperSheep].unknown78= 4;
defprojparams[Weapon_SuperSheep].unknown7C= 0;
defprojparams[Weapon_SuperSheep].unknown80= 0;
defprojparams[Weapon_SuperSheep].unknown84= 0;
defprojparams[Weapon_SuperSheep].unknown88= 25;
defprojparams[Weapon_SuperSheep].unknown8C= 100;
defprojparams[Weapon_SuperSheep].unknown90= 50;
defprojparams[Weapon_SuperSheep].unknown94= -10;
defprojparams[Weapon_SuperSheep].unknown98= 0;
defprojparams[Weapon_SuperSheep].unknown9C= 0;
defprojparams[Weapon_SuperSheep].unknownA0= 0;
defprojparams[Weapon_SuperSheep].unknownA4= 156;
defprojparams[Weapon_SuperSheep].unknownA8= 157;
defprojparams[Weapon_SuperSheep].unknownAC= 76;
defprojparams[Weapon_SuperSheep].unknownB0= 65613;
defprojparams[Weapon_SuperSheep].unknownB4= 0;
defprojparams[Weapon_SuperSheep].unknownB8= 0;
defprojparams[Weapon_SuperSheep].unknownBC= 0;
defprojparams[Weapon_SuperSheep].unknownC0= 0;
defprojparams[Weapon_SuperSheep].unknownC4= 0;
defprojparams[Weapon_SuperSheep].unknownC8= 0;
defprojparams[Weapon_SuperSheep].unknownCC= 0;
defprojparams[Weapon_SuperSheep].unknownD0= 0;
defprojparams[Weapon_SuperSheep].unknownD4= 0;
defprojparams[Weapon_SuperSheep].unknownD8= 0;
defprojparams[Weapon_SuperSheep].unknownDC= 0;
defprojparams[Weapon_SuperSheep].unknownE0= 0;
defprojparams[Weapon_SuperSheep].unknownE4= 0;
defprojparams[Weapon_SuperSheep].unknownE8= 0;
defprojparams[Weapon_SuperSheep].unknownEC= 0;
defprojparams[Weapon_SuperSheep].unknownF0= 0;
defprojparams[Weapon_SuperSheep].unknownF4= 0;
defprojparams[Weapon_SuperSheep].unknownF8= 0;
defprojparams[Weapon_SuperSheep].unknownFC= 0;
defprojparams[Weapon_SuperSheep].unknown100= 0;
defprojparams[Weapon_SuperSheep].unknown104= 0;
defprojparams[Weapon_SuperSheep].unknown108= 0;
defprojparams[Weapon_SuperSheep].unknown10C= 0;
defprojparams[Weapon_SuperSheep].unknown110= 0;
defprojparams[Weapon_SuperSheep].unknown114= 0;
defprojparams[Weapon_SuperSheep].unknown118= 0;
defprojparams[Weapon_SuperSheep].unknown11C= 0;
defprojparams[Weapon_SuperSheep].unknown120= 0;
defprojparams[Weapon_SuperSheep].unknown124= 0;
defprojparams[Weapon_SuperSheep].unknown128= 0;
defprojparams[Weapon_SuperSheep].unknown12C= 0;
defprojparams[Weapon_SuperSheep].unknown130= 0;
defprojparams[Weapon_SuperSheep].unknown134= 0;
defprojparams[Weapon_SuperSheep].unknown138= 0;
defprojparams[Weapon_SuperSheep].unknown13C= 0;
defprojparams[Weapon_SuperSheep].unknown140= 0;
defprojparams[Weapon_SuperSheep].unknown144= 0;
defprojparams[Weapon_SuperSheep].unknown148= 0;
defprojparams[Weapon_SuperSheep].unknown14C= 0;
defprojparams[Weapon_SuperSheep].unknown150= 0;
defprojparams[Weapon_SuperSheep].unknown154= 0;
defprojparams[Weapon_SuperSheep].unknown158= 0;
defprojparams[Weapon_SuperSheep].unknown15C= 0;
defprojparams[Weapon_SuperSheep].unknown160= 0;
defprojparams[Weapon_SuperSheep].unknown164= 0;
defprojparams[Weapon_SuperSheep].unknown168= 0;
defprojparams[Weapon_SuperSheep].unknown16C= 0;
defprojparams[Weapon_SuperSheep].unknown170= 0;
defprojparams[Weapon_SuperSheep].unknown174= 0;
defprojparams[Weapon_AquaSheep] = defprojparams[Weapon_SuperSheep] --cant be bothered
defprojparams[Weapon_MoleBomb] = WeaponProjectileParams.new()
defprojparams[Weapon_MoleBomb].unknown0= 2;
defprojparams[Weapon_MoleBomb].unknown4= 5;
defprojparams[Weapon_MoleBomb].unknown8= 0;
defprojparams[Weapon_MoleBomb].unknownC= 0;
defprojparams[Weapon_MoleBomb].unknown10= 0;
defprojparams[Weapon_MoleBomb].unknown14= 100;
defprojparams[Weapon_MoleBomb].unknown18= 0;
defprojparams[Weapon_MoleBomb].unknown1C= 0;
defprojparams[Weapon_MoleBomb].unknown20= 0;
defprojparams[Weapon_MoleBomb].unknown24= 166;
defprojparams[Weapon_MoleBomb].unknown28= 6;
defprojparams[Weapon_MoleBomb].unknown2C= 131;
defprojparams[Weapon_MoleBomb].unknown30= 0;
defprojparams[Weapon_MoleBomb].unknown34= 100;
defprojparams[Weapon_MoleBomb].unknown38= 50;
defprojparams[Weapon_MoleBomb].unknown3C= 100;
defprojparams[Weapon_MoleBomb].unknown40= 0;
defprojparams[Weapon_MoleBomb].unknown44= 0;
defprojparams[Weapon_MoleBomb].unknown48= 100;
defprojparams[Weapon_MoleBomb].unknown4C= 5000;
defprojparams[Weapon_MoleBomb].unknown50= 10000;
defprojparams[Weapon_MoleBomb].unknown54= 65575;
defprojparams[Weapon_MoleBomb].unknown58= 0;
defprojparams[Weapon_MoleBomb].unknown5C= 0;
defprojparams[Weapon_MoleBomb].unknown60= 0;
defprojparams[Weapon_MoleBomb].unknown64= 1;
defprojparams[Weapon_MoleBomb].unknown68= 3;
defprojparams[Weapon_MoleBomb].unknown6C= 4331646;
defprojparams[Weapon_MoleBomb].unknown70= 4331646;
defprojparams[Weapon_MoleBomb].unknown74= 50;
defprojparams[Weapon_MoleBomb].unknown78= 8;
defprojparams[Weapon_MoleBomb].unknown7C= 0;
defprojparams[Weapon_MoleBomb].unknown80= 0;
defprojparams[Weapon_MoleBomb].unknown84= 0;
defprojparams[Weapon_MoleBomb].unknown88= 15;
defprojparams[Weapon_MoleBomb].unknown8C= 75;
defprojparams[Weapon_MoleBomb].unknown90= 40;
defprojparams[Weapon_MoleBomb].unknown94= -4;
defprojparams[Weapon_MoleBomb].unknown98= 0;
defprojparams[Weapon_MoleBomb].unknown9C= 0;
defprojparams[Weapon_MoleBomb].unknownA0= 0;
defprojparams[Weapon_MoleBomb].unknownA4= 0;
defprojparams[Weapon_MoleBomb].unknownA8= 0;
defprojparams[Weapon_MoleBomb].unknownAC= 0;
defprojparams[Weapon_MoleBomb].unknownB0= 0;
defprojparams[Weapon_MoleBomb].unknownB4= 1;
defprojparams[Weapon_MoleBomb].unknownB8= 0;
defprojparams[Weapon_MoleBomb].unknownBC= 1;
defprojparams[Weapon_MoleBomb].unknownC0= 0;
defprojparams[Weapon_MoleBomb].unknownC4= 0;
defprojparams[Weapon_MoleBomb].unknownC8= 0;
defprojparams[Weapon_MoleBomb].unknownCC= 0;
defprojparams[Weapon_MoleBomb].unknownD0= 137340;
defprojparams[Weapon_MoleBomb].unknownD4= 0;
defprojparams[Weapon_MoleBomb].unknownD8= 100;
defprojparams[Weapon_MoleBomb].unknownDC= 30;
defprojparams[Weapon_MoleBomb].unknownE0= 0;
defprojparams[Weapon_MoleBomb].unknownE4= 1;
defprojparams[Weapon_MoleBomb].unknownE8= 152;
defprojparams[Weapon_MoleBomb].unknownEC= 6;
defprojparams[Weapon_MoleBomb].unknownF0= 80;
defprojparams[Weapon_MoleBomb].unknownF4= 50;
defprojparams[Weapon_MoleBomb].unknownF8= 50;
defprojparams[Weapon_MoleBomb].unknownFC= 50;
defprojparams[Weapon_MoleBomb].unknown100= 100;
defprojparams[Weapon_MoleBomb].unknown104= 0;
defprojparams[Weapon_MoleBomb].unknown108= 0;
defprojparams[Weapon_MoleBomb].unknown10C= 100;
defprojparams[Weapon_MoleBomb].unknown110= 5000;
defprojparams[Weapon_MoleBomb].unknown114= 20000;
defprojparams[Weapon_MoleBomb].unknown118= 0;
defprojparams[Weapon_MoleBomb].unknown11C= 0;
defprojparams[Weapon_MoleBomb].unknown120= 0;
defprojparams[Weapon_MoleBomb].unknown124= 0;
defprojparams[Weapon_MoleBomb].unknown128= 1;
defprojparams[Weapon_MoleBomb].unknown12C= 4;
defprojparams[Weapon_MoleBomb].unknown130= 50;
defprojparams[Weapon_MoleBomb].unknown134= 50;
defprojparams[Weapon_MoleBomb].unknown138= 65574;
defprojparams[Weapon_MoleBomb].unknown13C= 158;
defprojparams[Weapon_MoleBomb].unknown140= 159;
defprojparams[Weapon_MoleBomb].unknown144= 160;
defprojparams[Weapon_MoleBomb].unknown148= 160;
defprojparams[Weapon_MoleBomb].unknown14C= 0;
defprojparams[Weapon_MoleBomb].unknown150= 0;
defprojparams[Weapon_MoleBomb].unknown154= 0;
defprojparams[Weapon_MoleBomb].unknown158= 0;
defprojparams[Weapon_MoleBomb].unknown15C= 0;
defprojparams[Weapon_MoleBomb].unknown160= 0;
defprojparams[Weapon_MoleBomb].unknown164= 0;
defprojparams[Weapon_MoleBomb].unknown168= 0;
defprojparams[Weapon_MoleBomb].unknown16C= 0;
defprojparams[Weapon_MoleBomb].unknown170= 0;
defprojparams[Weapon_MoleBomb].unknown174= 0;
defprojparams[Weapon_SuperBanana] = WeaponProjectileParams.new()
defprojparams[Weapon_SuperBanana].unknown0= 2;
defprojparams[Weapon_SuperBanana].unknown4= 0;
defprojparams[Weapon_SuperBanana].unknown8= 0;
defprojparams[Weapon_SuperBanana].unknownC= 0;
defprojparams[Weapon_SuperBanana].unknown10= 0;
defprojparams[Weapon_SuperBanana].unknown14= 100;
defprojparams[Weapon_SuperBanana].unknown18= 75;
defprojparams[Weapon_SuperBanana].unknown1C= 0;
defprojparams[Weapon_SuperBanana].unknown20= 0;
defprojparams[Weapon_SuperBanana].unknown24= 51;
defprojparams[Weapon_SuperBanana].unknown28= 1;
defprojparams[Weapon_SuperBanana].unknown2C= 131;
defprojparams[Weapon_SuperBanana].unknown30= 0;
defprojparams[Weapon_SuperBanana].unknown34= 100;
defprojparams[Weapon_SuperBanana].unknown38= 50;
defprojparams[Weapon_SuperBanana].unknown3C= 100;
defprojparams[Weapon_SuperBanana].unknown40= 0;
defprojparams[Weapon_SuperBanana].unknown44= 0;
defprojparams[Weapon_SuperBanana].unknown48= 100;
defprojparams[Weapon_SuperBanana].unknown4C= 3000;
defprojparams[Weapon_SuperBanana].unknown50= 10000;
defprojparams[Weapon_SuperBanana].unknown54= 0;
defprojparams[Weapon_SuperBanana].unknown58= 0;
defprojparams[Weapon_SuperBanana].unknown5C= 0;
defprojparams[Weapon_SuperBanana].unknown60= 0;
defprojparams[Weapon_SuperBanana].unknown64= 1;
defprojparams[Weapon_SuperBanana].unknown68= 2;
defprojparams[Weapon_SuperBanana].unknown6C= 4331646;
defprojparams[Weapon_SuperBanana].unknown70= 60;
defprojparams[Weapon_SuperBanana].unknown74= 100;
defprojparams[Weapon_SuperBanana].unknown78= 111;
defprojparams[Weapon_SuperBanana].unknown7C= 8;
defprojparams[Weapon_SuperBanana].unknown80= 0;
defprojparams[Weapon_SuperBanana].unknown84= 0;
defprojparams[Weapon_SuperBanana].unknown88= 0;
defprojparams[Weapon_SuperBanana].unknown8C= 0;
defprojparams[Weapon_SuperBanana].unknown90= 0;
defprojparams[Weapon_SuperBanana].unknown94= 0;
defprojparams[Weapon_SuperBanana].unknown98= 0;
defprojparams[Weapon_SuperBanana].unknown9C= 0;
defprojparams[Weapon_SuperBanana].unknownA0= 0;
defprojparams[Weapon_SuperBanana].unknownA4= 0;
defprojparams[Weapon_SuperBanana].unknownA8= 0;
defprojparams[Weapon_SuperBanana].unknownAC= 0;
defprojparams[Weapon_SuperBanana].unknownB0= 0;
defprojparams[Weapon_SuperBanana].unknownB4= 1;
defprojparams[Weapon_SuperBanana].unknownB8= 0;
defprojparams[Weapon_SuperBanana].unknownBC= 5;
defprojparams[Weapon_SuperBanana].unknownC0= 45;
defprojparams[Weapon_SuperBanana].unknownC4= 30;
defprojparams[Weapon_SuperBanana].unknownC8= 0;
defprojparams[Weapon_SuperBanana].unknownCC= 25;
defprojparams[Weapon_SuperBanana].unknownD0= 0;
defprojparams[Weapon_SuperBanana].unknownD4= 0;
defprojparams[Weapon_SuperBanana].unknownD8= 100;
defprojparams[Weapon_SuperBanana].unknownDC= 75;
defprojparams[Weapon_SuperBanana].unknownE0= 0;
defprojparams[Weapon_SuperBanana].unknownE4= 1;
defprojparams[Weapon_SuperBanana].unknownE8= 51;
defprojparams[Weapon_SuperBanana].unknownEC= 1;
defprojparams[Weapon_SuperBanana].unknownF0= 131;
defprojparams[Weapon_SuperBanana].unknownF4= 0;
defprojparams[Weapon_SuperBanana].unknownF8= 100;
defprojparams[Weapon_SuperBanana].unknownFC= 50;
defprojparams[Weapon_SuperBanana].unknown100= 100;
defprojparams[Weapon_SuperBanana].unknown104= 0;
defprojparams[Weapon_SuperBanana].unknown108= 0;
defprojparams[Weapon_SuperBanana].unknown10C= 100;
defprojparams[Weapon_SuperBanana].unknown110= 0;
defprojparams[Weapon_SuperBanana].unknown114= 9000;
defprojparams[Weapon_SuperBanana].unknown118= 0;
defprojparams[Weapon_SuperBanana].unknown11C= 0;
defprojparams[Weapon_SuperBanana].unknown120= 0;
defprojparams[Weapon_SuperBanana].unknown124= 0;
defprojparams[Weapon_SuperBanana].unknown128= 1;
defprojparams[Weapon_SuperBanana].unknown12C= 2;
defprojparams[Weapon_SuperBanana].unknown130= 4331646;
defprojparams[Weapon_SuperBanana].unknown134= 60;
defprojparams[Weapon_SuperBanana].unknown138= 100;
defprojparams[Weapon_SuperBanana].unknown13C= 111;
defprojparams[Weapon_SuperBanana].unknown140= 8;
defprojparams[Weapon_SuperBanana].unknown144= 0;
defprojparams[Weapon_SuperBanana].unknown148= 0;
defprojparams[Weapon_SuperBanana].unknown14C= 0;
defprojparams[Weapon_SuperBanana].unknown150= 0;
defprojparams[Weapon_SuperBanana].unknown154= 0;
defprojparams[Weapon_SuperBanana].unknown158= 0;
defprojparams[Weapon_SuperBanana].unknown15C= 0;
defprojparams[Weapon_SuperBanana].unknown160= 0;
defprojparams[Weapon_SuperBanana].unknown164= 0;
defprojparams[Weapon_SuperBanana].unknown168= 0;
defprojparams[Weapon_SuperBanana].unknown16C= 0;
defprojparams[Weapon_SuperBanana].unknown170= 0;
defprojparams[Weapon_SuperBanana].unknown174= 0;
defprojparams[Weapon_HolyGrenade] = WeaponProjectileParams.new()
defprojparams[Weapon_HolyGrenade].unknown0= 2;
defprojparams[Weapon_HolyGrenade].unknown4= 0;
defprojparams[Weapon_HolyGrenade].unknown8= 1;
defprojparams[Weapon_HolyGrenade].unknownC= 0;
defprojparams[Weapon_HolyGrenade].unknown10= 75;
defprojparams[Weapon_HolyGrenade].unknown14= 125;
defprojparams[Weapon_HolyGrenade].unknown18= 100;
defprojparams[Weapon_HolyGrenade].unknown1C= 0;
defprojparams[Weapon_HolyGrenade].unknown20= 0;
defprojparams[Weapon_HolyGrenade].unknown24= 56;
defprojparams[Weapon_HolyGrenade].unknown28= 1;
defprojparams[Weapon_HolyGrenade].unknown2C= 131;
defprojparams[Weapon_HolyGrenade].unknown30= 0;
defprojparams[Weapon_HolyGrenade].unknown34= 100;
defprojparams[Weapon_HolyGrenade].unknown38= 50;
defprojparams[Weapon_HolyGrenade].unknown3C= 100;
defprojparams[Weapon_HolyGrenade].unknown40= 0;
defprojparams[Weapon_HolyGrenade].unknown44= 0;
defprojparams[Weapon_HolyGrenade].unknown48= 100;
defprojparams[Weapon_HolyGrenade].unknown4C= 3000;
defprojparams[Weapon_HolyGrenade].unknown50= 3000;
defprojparams[Weapon_HolyGrenade].unknown54= 0;
defprojparams[Weapon_HolyGrenade].unknown58= 1;
defprojparams[Weapon_HolyGrenade].unknown5C= 104;
defprojparams[Weapon_HolyGrenade].unknown60= 1800;
defprojparams[Weapon_HolyGrenade].unknown64= 0;
defprojparams[Weapon_HolyGrenade].unknown68= 2;
defprojparams[Weapon_HolyGrenade].unknown6C= 1078073438;
defprojparams[Weapon_HolyGrenade].unknown70= 30;
defprojparams[Weapon_HolyGrenade].unknown74= 100;
defprojparams[Weapon_HolyGrenade].unknown78= 105;
defprojparams[Weapon_HolyGrenade].unknown7C= 8;
defprojparams[Weapon_HolyGrenade].unknown80= 0;
defprojparams[Weapon_HolyGrenade].unknown84= 0;
defprojparams[Weapon_HolyGrenade].unknown88= 0;
defprojparams[Weapon_HolyGrenade].unknown8C= 0;
defprojparams[Weapon_HolyGrenade].unknown90= 0;
defprojparams[Weapon_HolyGrenade].unknown94= 0;
defprojparams[Weapon_HolyGrenade].unknown98= 0;
defprojparams[Weapon_HolyGrenade].unknown9C= 0;
defprojparams[Weapon_HolyGrenade].unknownA0= 0;
defprojparams[Weapon_HolyGrenade].unknownA4= 0;
defprojparams[Weapon_HolyGrenade].unknownA8= 0;
defprojparams[Weapon_HolyGrenade].unknownAC= 0;
defprojparams[Weapon_HolyGrenade].unknownB0= 0;
defprojparams[Weapon_HolyGrenade].unknownB4= 0;
defprojparams[Weapon_HolyGrenade].unknownB8= 0;
defprojparams[Weapon_HolyGrenade].unknownBC= 0;
defprojparams[Weapon_HolyGrenade].unknownC0= 0;
defprojparams[Weapon_HolyGrenade].unknownC4= 0;
defprojparams[Weapon_HolyGrenade].unknownC8= 0;
defprojparams[Weapon_HolyGrenade].unknownCC= 0;
defprojparams[Weapon_HolyGrenade].unknownD0= 0;
defprojparams[Weapon_HolyGrenade].unknownD4= 0;
defprojparams[Weapon_HolyGrenade].unknownD8= 0;
defprojparams[Weapon_HolyGrenade].unknownDC= 0;
defprojparams[Weapon_HolyGrenade].unknownE0= 0;
defprojparams[Weapon_HolyGrenade].unknownE4= 0;
defprojparams[Weapon_HolyGrenade].unknownE8= 0;
defprojparams[Weapon_HolyGrenade].unknownEC= 0;
defprojparams[Weapon_HolyGrenade].unknownF0= 0;
defprojparams[Weapon_HolyGrenade].unknownF4= 0;
defprojparams[Weapon_HolyGrenade].unknownF8= 0;
defprojparams[Weapon_HolyGrenade].unknownFC= 0;
defprojparams[Weapon_HolyGrenade].unknown100= 0;
defprojparams[Weapon_HolyGrenade].unknown104= 0;
defprojparams[Weapon_HolyGrenade].unknown108= 0;
defprojparams[Weapon_HolyGrenade].unknown10C= 0;
defprojparams[Weapon_HolyGrenade].unknown110= 0;
defprojparams[Weapon_HolyGrenade].unknown114= 0;
defprojparams[Weapon_HolyGrenade].unknown118= 0;
defprojparams[Weapon_HolyGrenade].unknown11C= 0;
defprojparams[Weapon_HolyGrenade].unknown120= 0;
defprojparams[Weapon_HolyGrenade].unknown124= 0;
defprojparams[Weapon_HolyGrenade].unknown128= 0;
defprojparams[Weapon_HolyGrenade].unknown12C= 0;
defprojparams[Weapon_HolyGrenade].unknown130= 0;
defprojparams[Weapon_HolyGrenade].unknown134= 0;
defprojparams[Weapon_HolyGrenade].unknown138= 0;
defprojparams[Weapon_HolyGrenade].unknown13C= 0;
defprojparams[Weapon_HolyGrenade].unknown140= 0;
defprojparams[Weapon_HolyGrenade].unknown144= 0;
defprojparams[Weapon_HolyGrenade].unknown148= 0;
defprojparams[Weapon_HolyGrenade].unknown14C= 0;
defprojparams[Weapon_HolyGrenade].unknown150= 0;
defprojparams[Weapon_HolyGrenade].unknown154= 0;
defprojparams[Weapon_HolyGrenade].unknown158= 0;
defprojparams[Weapon_HolyGrenade].unknown15C= 0;
defprojparams[Weapon_HolyGrenade].unknown160= 0;
defprojparams[Weapon_HolyGrenade].unknown164= 0;
defprojparams[Weapon_HolyGrenade].unknown168= 0;
defprojparams[Weapon_HolyGrenade].unknown16C= 0;
defprojparams[Weapon_HolyGrenade].unknown170= 0;
defprojparams[Weapon_HolyGrenade].unknown174= 0;
defprojparams[Weapon_SalvationArmy] = WeaponProjectileParams.new()
defprojparams[Weapon_SalvationArmy].unknown0= 2;
defprojparams[Weapon_SalvationArmy].unknown4= 5;
defprojparams[Weapon_SalvationArmy].unknown8= 0;
defprojparams[Weapon_SalvationArmy].unknownC= 0;
defprojparams[Weapon_SalvationArmy].unknown10= 0;
defprojparams[Weapon_SalvationArmy].unknown14= 100;
defprojparams[Weapon_SalvationArmy].unknown18= 75;
defprojparams[Weapon_SalvationArmy].unknown1C= 0;
defprojparams[Weapon_SalvationArmy].unknown20= 0;
defprojparams[Weapon_SalvationArmy].unknown24= 163;
defprojparams[Weapon_SalvationArmy].unknown28= 6;
defprojparams[Weapon_SalvationArmy].unknown2C= 131;
defprojparams[Weapon_SalvationArmy].unknown30= 0;
defprojparams[Weapon_SalvationArmy].unknown34= 100;
defprojparams[Weapon_SalvationArmy].unknown38= 50;
defprojparams[Weapon_SalvationArmy].unknown3C= 100;
defprojparams[Weapon_SalvationArmy].unknown40= 0;
defprojparams[Weapon_SalvationArmy].unknown44= 0;
defprojparams[Weapon_SalvationArmy].unknown48= 100;
defprojparams[Weapon_SalvationArmy].unknown4C= 5000;
defprojparams[Weapon_SalvationArmy].unknown50= 10000;
defprojparams[Weapon_SalvationArmy].unknown54= 65597;
defprojparams[Weapon_SalvationArmy].unknown58= 0;
defprojparams[Weapon_SalvationArmy].unknown5C= 0;
defprojparams[Weapon_SalvationArmy].unknown60= 0;
defprojparams[Weapon_SalvationArmy].unknown64= 1;
defprojparams[Weapon_SalvationArmy].unknown68= 3;
defprojparams[Weapon_SalvationArmy].unknown6C= 4331646;
defprojparams[Weapon_SalvationArmy].unknown70= 4331646;
defprojparams[Weapon_SalvationArmy].unknown74= 33;
defprojparams[Weapon_SalvationArmy].unknown78= 4;
defprojparams[Weapon_SalvationArmy].unknown7C= 45;
defprojparams[Weapon_SalvationArmy].unknown80= 25;
defprojparams[Weapon_SalvationArmy].unknown84= 0;
defprojparams[Weapon_SalvationArmy].unknown88= 0;
defprojparams[Weapon_SalvationArmy].unknown8C= 100;
defprojparams[Weapon_SalvationArmy].unknown90= 50;
defprojparams[Weapon_SalvationArmy].unknown94= -8;
defprojparams[Weapon_SalvationArmy].unknown98= 0;
defprojparams[Weapon_SalvationArmy].unknown9C= 0;
defprojparams[Weapon_SalvationArmy].unknownA0= 0;
defprojparams[Weapon_SalvationArmy].unknownA4= 0;
defprojparams[Weapon_SalvationArmy].unknownA8= 0;
defprojparams[Weapon_SalvationArmy].unknownAC= 0;
defprojparams[Weapon_SalvationArmy].unknownB0= 0;
defprojparams[Weapon_SalvationArmy].unknownB4= 1;
defprojparams[Weapon_SalvationArmy].unknownB8= 0;
defprojparams[Weapon_SalvationArmy].unknownBC= 5;
defprojparams[Weapon_SalvationArmy].unknownC0= 35;
defprojparams[Weapon_SalvationArmy].unknownC4= 50;
defprojparams[Weapon_SalvationArmy].unknownC8= 0;
defprojparams[Weapon_SalvationArmy].unknownCC= 60;
defprojparams[Weapon_SalvationArmy].unknownD0= 137342;
defprojparams[Weapon_SalvationArmy].unknownD4= 0;
defprojparams[Weapon_SalvationArmy].unknownD8= 100;
defprojparams[Weapon_SalvationArmy].unknownDC= 60;
defprojparams[Weapon_SalvationArmy].unknownE0= 0;
defprojparams[Weapon_SalvationArmy].unknownE4= 1;
defprojparams[Weapon_SalvationArmy].unknownE8= 57;
defprojparams[Weapon_SalvationArmy].unknownEC= 1;
defprojparams[Weapon_SalvationArmy].unknownF0= 131;
defprojparams[Weapon_SalvationArmy].unknownF4= 0;
defprojparams[Weapon_SalvationArmy].unknownF8= 100;
defprojparams[Weapon_SalvationArmy].unknownFC= 50;
defprojparams[Weapon_SalvationArmy].unknown100= 100;
defprojparams[Weapon_SalvationArmy].unknown104= 0;
defprojparams[Weapon_SalvationArmy].unknown108= 0;
defprojparams[Weapon_SalvationArmy].unknown10C= 100;
defprojparams[Weapon_SalvationArmy].unknown110= 0;
defprojparams[Weapon_SalvationArmy].unknown114= 10000;
defprojparams[Weapon_SalvationArmy].unknown118= 0;
defprojparams[Weapon_SalvationArmy].unknown11C= 0;
defprojparams[Weapon_SalvationArmy].unknown120= 0;
defprojparams[Weapon_SalvationArmy].unknown124= 1800;
defprojparams[Weapon_SalvationArmy].unknown128= 0;
defprojparams[Weapon_SalvationArmy].unknown12C= 2;
defprojparams[Weapon_SalvationArmy].unknown130= 4194304;
defprojparams[Weapon_SalvationArmy].unknown134= 1;
defprojparams[Weapon_SalvationArmy].unknown138= 0;
defprojparams[Weapon_SalvationArmy].unknown13C= 0;
defprojparams[Weapon_SalvationArmy].unknown140= 8;
defprojparams[Weapon_SalvationArmy].unknown144= 0;
defprojparams[Weapon_SalvationArmy].unknown148= 0;
defprojparams[Weapon_SalvationArmy].unknown14C= 0;
defprojparams[Weapon_SalvationArmy].unknown150= 0;
defprojparams[Weapon_SalvationArmy].unknown154= 0;
defprojparams[Weapon_SalvationArmy].unknown158= 0;
defprojparams[Weapon_SalvationArmy].unknown15C= 0;
defprojparams[Weapon_SalvationArmy].unknown160= 0;
defprojparams[Weapon_SalvationArmy].unknown164= 0;
defprojparams[Weapon_SalvationArmy].unknown168= 0;
defprojparams[Weapon_SalvationArmy].unknown16C= 0;
defprojparams[Weapon_SalvationArmy].unknown170= 0;
defprojparams[Weapon_SalvationArmy].unknown174= 0;
defprojparams[Weapon_PetrolBomb] = WeaponProjectileParams.new()
defprojparams[Weapon_PetrolBomb].unknown0= 2;
defprojparams[Weapon_PetrolBomb].unknown4= 0;
defprojparams[Weapon_PetrolBomb].unknown8= 1;
defprojparams[Weapon_PetrolBomb].unknownC= 137342;
defprojparams[Weapon_PetrolBomb].unknown10= 0;
defprojparams[Weapon_PetrolBomb].unknown14= 75;
defprojparams[Weapon_PetrolBomb].unknown18= 15;
defprojparams[Weapon_PetrolBomb].unknown1C= 0;
defprojparams[Weapon_PetrolBomb].unknown20= 0;
defprojparams[Weapon_PetrolBomb].unknown24= 55;
defprojparams[Weapon_PetrolBomb].unknown28= 1;
defprojparams[Weapon_PetrolBomb].unknown2C= 131;
defprojparams[Weapon_PetrolBomb].unknown30= 0;
defprojparams[Weapon_PetrolBomb].unknown34= 100;
defprojparams[Weapon_PetrolBomb].unknown38= 50;
defprojparams[Weapon_PetrolBomb].unknown3C= 100;
defprojparams[Weapon_PetrolBomb].unknown40= 0;
defprojparams[Weapon_PetrolBomb].unknown44= 0;
defprojparams[Weapon_PetrolBomb].unknown48= 100;
defprojparams[Weapon_PetrolBomb].unknown4C= 0;
defprojparams[Weapon_PetrolBomb].unknown50= 9000;
defprojparams[Weapon_PetrolBomb].unknown54= 0;
defprojparams[Weapon_PetrolBomb].unknown58= 0;
defprojparams[Weapon_PetrolBomb].unknown5C= 0;
defprojparams[Weapon_PetrolBomb].unknown60= 0;
defprojparams[Weapon_PetrolBomb].unknown64= 0;
defprojparams[Weapon_PetrolBomb].unknown68= 2;
defprojparams[Weapon_PetrolBomb].unknown6C= 4194304;
defprojparams[Weapon_PetrolBomb].unknown70= 1;
defprojparams[Weapon_PetrolBomb].unknown74= 100;
defprojparams[Weapon_PetrolBomb].unknown78= 113;
defprojparams[Weapon_PetrolBomb].unknown7C= 8;
defprojparams[Weapon_PetrolBomb].unknown80= 0;
defprojparams[Weapon_PetrolBomb].unknown84= 0;
defprojparams[Weapon_PetrolBomb].unknown88= 0;
defprojparams[Weapon_PetrolBomb].unknown8C= 0;
defprojparams[Weapon_PetrolBomb].unknown90= 0;
defprojparams[Weapon_PetrolBomb].unknown94= 0;
defprojparams[Weapon_PetrolBomb].unknown98= 0;
defprojparams[Weapon_PetrolBomb].unknown9C= 0;
defprojparams[Weapon_PetrolBomb].unknownA0= 0;
defprojparams[Weapon_PetrolBomb].unknownA4= 0;
defprojparams[Weapon_PetrolBomb].unknownA8= 0;
defprojparams[Weapon_PetrolBomb].unknownAC= 0;
defprojparams[Weapon_PetrolBomb].unknownB0= 0;
defprojparams[Weapon_PetrolBomb].unknownB4= 2;
defprojparams[Weapon_PetrolBomb].unknownB8= 0;
defprojparams[Weapon_PetrolBomb].unknownBC= 40;
defprojparams[Weapon_PetrolBomb].unknownC0= 100;
defprojparams[Weapon_PetrolBomb].unknownC4= 4000;
defprojparams[Weapon_PetrolBomb].unknownC8= 1;
defprojparams[Weapon_PetrolBomb].unknownCC= 0;
defprojparams[Weapon_PetrolBomb].unknownD0= 0;
defprojparams[Weapon_PetrolBomb].unknownD4= 0;
defprojparams[Weapon_PetrolBomb].unknownD8= 0;
defprojparams[Weapon_PetrolBomb].unknownDC= 0;
defprojparams[Weapon_PetrolBomb].unknownE0= 0;
defprojparams[Weapon_PetrolBomb].unknownE4= 0;
defprojparams[Weapon_PetrolBomb].unknownE8= 0;
defprojparams[Weapon_PetrolBomb].unknownEC= 0;
defprojparams[Weapon_PetrolBomb].unknownF0= 0;
defprojparams[Weapon_PetrolBomb].unknownF4= 0;
defprojparams[Weapon_PetrolBomb].unknownF8= 0;
defprojparams[Weapon_PetrolBomb].unknownFC= 0;
defprojparams[Weapon_PetrolBomb].unknown100= 0;
defprojparams[Weapon_PetrolBomb].unknown104= 0;
defprojparams[Weapon_PetrolBomb].unknown108= 0;
defprojparams[Weapon_PetrolBomb].unknown10C= 0;
defprojparams[Weapon_PetrolBomb].unknown110= 0;
defprojparams[Weapon_PetrolBomb].unknown114= 0;
defprojparams[Weapon_PetrolBomb].unknown118= 0;
defprojparams[Weapon_PetrolBomb].unknown11C= 0;
defprojparams[Weapon_PetrolBomb].unknown120= 0;
defprojparams[Weapon_PetrolBomb].unknown124= 0;
defprojparams[Weapon_PetrolBomb].unknown128= 0;
defprojparams[Weapon_PetrolBomb].unknown12C= 0;
defprojparams[Weapon_PetrolBomb].unknown130= 0;
defprojparams[Weapon_PetrolBomb].unknown134= 0;
defprojparams[Weapon_PetrolBomb].unknown138= 0;
defprojparams[Weapon_PetrolBomb].unknown13C= 0;
defprojparams[Weapon_PetrolBomb].unknown140= 0;
defprojparams[Weapon_PetrolBomb].unknown144= 0;
defprojparams[Weapon_PetrolBomb].unknown148= 0;
defprojparams[Weapon_PetrolBomb].unknown14C= 0;
defprojparams[Weapon_PetrolBomb].unknown150= 0;
defprojparams[Weapon_PetrolBomb].unknown154= 0;
defprojparams[Weapon_PetrolBomb].unknown158= 0;
defprojparams[Weapon_PetrolBomb].unknown15C= 0;
defprojparams[Weapon_PetrolBomb].unknown160= 0;
defprojparams[Weapon_PetrolBomb].unknown164= 0;
defprojparams[Weapon_PetrolBomb].unknown168= 0;
defprojparams[Weapon_PetrolBomb].unknown16C= 0;
defprojparams[Weapon_PetrolBomb].unknown170= 0;
defprojparams[Weapon_PetrolBomb].unknown174= 0;
defprojparams[Weapon_Skunk] = WeaponProjectileParams.new()
defprojparams[Weapon_Skunk].unknown0= 2;
defprojparams[Weapon_Skunk].unknown4= 5;
defprojparams[Weapon_Skunk].unknown8= 0;
defprojparams[Weapon_Skunk].unknownC= 0;
defprojparams[Weapon_Skunk].unknown10= 0;
defprojparams[Weapon_Skunk].unknown14= 100;
defprojparams[Weapon_Skunk].unknown18= 0;
defprojparams[Weapon_Skunk].unknown1C= 0;
defprojparams[Weapon_Skunk].unknown20= 0;
defprojparams[Weapon_Skunk].unknown24= 173;
defprojparams[Weapon_Skunk].unknown28= 6;
defprojparams[Weapon_Skunk].unknown2C= 131;
defprojparams[Weapon_Skunk].unknown30= 0;
defprojparams[Weapon_Skunk].unknown34= 100;
defprojparams[Weapon_Skunk].unknown38= 50;
defprojparams[Weapon_Skunk].unknown3C= 100;
defprojparams[Weapon_Skunk].unknown40= 0;
defprojparams[Weapon_Skunk].unknown44= 0;
defprojparams[Weapon_Skunk].unknown48= 100;
defprojparams[Weapon_Skunk].unknown4C= 5000;
defprojparams[Weapon_Skunk].unknown50= 5000;
defprojparams[Weapon_Skunk].unknown54= 65578;
defprojparams[Weapon_Skunk].unknown58= 0;
defprojparams[Weapon_Skunk].unknown5C= 0;
defprojparams[Weapon_Skunk].unknown60= 0;
defprojparams[Weapon_Skunk].unknown64= 1;
defprojparams[Weapon_Skunk].unknown68= 3;
defprojparams[Weapon_Skunk].unknown6C= 4331646;
defprojparams[Weapon_Skunk].unknown70= 4331646;
defprojparams[Weapon_Skunk].unknown74= 100;
defprojparams[Weapon_Skunk].unknown78= 4;
defprojparams[Weapon_Skunk].unknown7C= 0;
defprojparams[Weapon_Skunk].unknown80= 0;
defprojparams[Weapon_Skunk].unknown84= 0;
defprojparams[Weapon_Skunk].unknown88= 15;
defprojparams[Weapon_Skunk].unknown8C= 100;
defprojparams[Weapon_Skunk].unknown90= 43;
defprojparams[Weapon_Skunk].unknown94= -4;
defprojparams[Weapon_Skunk].unknown98= 0;
defprojparams[Weapon_Skunk].unknown9C= 0;
defprojparams[Weapon_Skunk].unknownA0= 0;
defprojparams[Weapon_Skunk].unknownA4= 0;
defprojparams[Weapon_Skunk].unknownA8= 0;
defprojparams[Weapon_Skunk].unknownAC= 0;
defprojparams[Weapon_Skunk].unknownB0= 0;
defprojparams[Weapon_Skunk].unknownB4= 1;
defprojparams[Weapon_Skunk].unknownB8= 0;
defprojparams[Weapon_Skunk].unknownBC= 1;
defprojparams[Weapon_Skunk].unknownC0= 0;
defprojparams[Weapon_Skunk].unknownC4= 0;
defprojparams[Weapon_Skunk].unknownC8= 0;
defprojparams[Weapon_Skunk].unknownCC= 0;
defprojparams[Weapon_Skunk].unknownD0= 0;
defprojparams[Weapon_Skunk].unknownD4= 0;
defprojparams[Weapon_Skunk].unknownD8= 100;
defprojparams[Weapon_Skunk].unknownDC= 30;
defprojparams[Weapon_Skunk].unknownE0= 0;
defprojparams[Weapon_Skunk].unknownE4= 1;
defprojparams[Weapon_Skunk].unknownE8= 173;
defprojparams[Weapon_Skunk].unknownEC= 6;
defprojparams[Weapon_Skunk].unknownF0= 131;
defprojparams[Weapon_Skunk].unknownF4= 0;
defprojparams[Weapon_Skunk].unknownF8= 100;
defprojparams[Weapon_Skunk].unknownFC= 50;
defprojparams[Weapon_Skunk].unknown100= 100;
defprojparams[Weapon_Skunk].unknown104= 0;
defprojparams[Weapon_Skunk].unknown108= 0;
defprojparams[Weapon_Skunk].unknown10C= 100;
defprojparams[Weapon_Skunk].unknown110= 5000;
defprojparams[Weapon_Skunk].unknown114= 10000;
defprojparams[Weapon_Skunk].unknown118= 65577;
defprojparams[Weapon_Skunk].unknown11C= 0;
defprojparams[Weapon_Skunk].unknown120= 0;
defprojparams[Weapon_Skunk].unknown124= 0;
defprojparams[Weapon_Skunk].unknown128= 1;
defprojparams[Weapon_Skunk].unknown12C= 3;
defprojparams[Weapon_Skunk].unknown130= 4331646;
defprojparams[Weapon_Skunk].unknown134= 4331646;
defprojparams[Weapon_Skunk].unknown138= 100;
defprojparams[Weapon_Skunk].unknown13C= 4;
defprojparams[Weapon_Skunk].unknown140= 0;
defprojparams[Weapon_Skunk].unknown144= 0;
defprojparams[Weapon_Skunk].unknown148= 0;
defprojparams[Weapon_Skunk].unknown14C= 15;
defprojparams[Weapon_Skunk].unknown150= 100;
defprojparams[Weapon_Skunk].unknown154= 43;
defprojparams[Weapon_Skunk].unknown158= -4;
defprojparams[Weapon_Skunk].unknown15C= 1;
defprojparams[Weapon_Skunk].unknown160= 5;
defprojparams[Weapon_Skunk].unknown164= 174;
defprojparams[Weapon_Skunk].unknown168= 0;
defprojparams[Weapon_Skunk].unknown16C= 0;
defprojparams[Weapon_Skunk].unknown170= 0;
defprojparams[Weapon_Skunk].unknown174= 0;
defprojparams[Weapon_MingVase] = WeaponProjectileParams.new()
defprojparams[Weapon_MingVase].unknown0= 2;
defprojparams[Weapon_MingVase].unknown4= 5;
defprojparams[Weapon_MingVase].unknown8= 1;
defprojparams[Weapon_MingVase].unknownC= 0;
defprojparams[Weapon_MingVase].unknown10= 50;
defprojparams[Weapon_MingVase].unknown14= 100;
defprojparams[Weapon_MingVase].unknown18= 75;
defprojparams[Weapon_MingVase].unknown1C= 0;
defprojparams[Weapon_MingVase].unknown20= 0;
defprojparams[Weapon_MingVase].unknown24= 74;
defprojparams[Weapon_MingVase].unknown28= 0;
defprojparams[Weapon_MingVase].unknown2C= 131;
defprojparams[Weapon_MingVase].unknown30= 0;
defprojparams[Weapon_MingVase].unknown34= 100;
defprojparams[Weapon_MingVase].unknown38= 50;
defprojparams[Weapon_MingVase].unknown3C= 100;
defprojparams[Weapon_MingVase].unknown40= 0;
defprojparams[Weapon_MingVase].unknown44= 0;
defprojparams[Weapon_MingVase].unknown48= 100;
defprojparams[Weapon_MingVase].unknown4C= 5000;
defprojparams[Weapon_MingVase].unknown50= 5000;
defprojparams[Weapon_MingVase].unknown54= 0;
defprojparams[Weapon_MingVase].unknown58= 0;
defprojparams[Weapon_MingVase].unknown5C= 0;
defprojparams[Weapon_MingVase].unknown60= 0;
defprojparams[Weapon_MingVase].unknown64= 0;
defprojparams[Weapon_MingVase].unknown68= 2;
defprojparams[Weapon_MingVase].unknown6C= 4331614;
defprojparams[Weapon_MingVase].unknown70= 30;
defprojparams[Weapon_MingVase].unknown74= 0;
defprojparams[Weapon_MingVase].unknown78= 113;
defprojparams[Weapon_MingVase].unknown7C= 8;
defprojparams[Weapon_MingVase].unknown80= 0;
defprojparams[Weapon_MingVase].unknown84= 0;
defprojparams[Weapon_MingVase].unknown88= 0;
defprojparams[Weapon_MingVase].unknown8C= 0;
defprojparams[Weapon_MingVase].unknown90= 0;
defprojparams[Weapon_MingVase].unknown94= 0;
defprojparams[Weapon_MingVase].unknown98= 0;
defprojparams[Weapon_MingVase].unknown9C= 0;
defprojparams[Weapon_MingVase].unknownA0= 0;
defprojparams[Weapon_MingVase].unknownA4= 0;
defprojparams[Weapon_MingVase].unknownA8= 0;
defprojparams[Weapon_MingVase].unknownAC= 0;
defprojparams[Weapon_MingVase].unknownB0= 0;
defprojparams[Weapon_MingVase].unknownB4= 1;
defprojparams[Weapon_MingVase].unknownB8= 0;
defprojparams[Weapon_MingVase].unknownBC= 3;
defprojparams[Weapon_MingVase].unknownC0= 40;
defprojparams[Weapon_MingVase].unknownC4= 30;
defprojparams[Weapon_MingVase].unknownC8= 0;
defprojparams[Weapon_MingVase].unknownCC= 25;
defprojparams[Weapon_MingVase].unknownD0= 137342;
defprojparams[Weapon_MingVase].unknownD4= 50;
defprojparams[Weapon_MingVase].unknownD8= 100;
defprojparams[Weapon_MingVase].unknownDC= 75;
defprojparams[Weapon_MingVase].unknownE0= 0;
defprojparams[Weapon_MingVase].unknownE4= 3;
defprojparams[Weapon_MingVase].unknownE8= 75;
defprojparams[Weapon_MingVase].unknownEC= 5;
defprojparams[Weapon_MingVase].unknownF0= 132;
defprojparams[Weapon_MingVase].unknownF4= 0;
defprojparams[Weapon_MingVase].unknownF8= 100;
defprojparams[Weapon_MingVase].unknownFC= 50;
defprojparams[Weapon_MingVase].unknown100= 100;
defprojparams[Weapon_MingVase].unknown104= 0;
defprojparams[Weapon_MingVase].unknown108= 0;
defprojparams[Weapon_MingVase].unknown10C= 100;
defprojparams[Weapon_MingVase].unknown110= 0;
defprojparams[Weapon_MingVase].unknown114= 9000;
defprojparams[Weapon_MingVase].unknown118= 0;
defprojparams[Weapon_MingVase].unknown11C= 0;
defprojparams[Weapon_MingVase].unknown120= 0;
defprojparams[Weapon_MingVase].unknown124= 0;
defprojparams[Weapon_MingVase].unknown128= 0;
defprojparams[Weapon_MingVase].unknown12C= 2;
defprojparams[Weapon_MingVase].unknown130= 4331614;
defprojparams[Weapon_MingVase].unknown134= 30;
defprojparams[Weapon_MingVase].unknown138= 0;
defprojparams[Weapon_MingVase].unknown13C= 113;
defprojparams[Weapon_MingVase].unknown140= 8;
defprojparams[Weapon_MingVase].unknown144= 0;
defprojparams[Weapon_MingVase].unknown148= 0;
defprojparams[Weapon_MingVase].unknown14C= 0;
defprojparams[Weapon_MingVase].unknown150= 0;
defprojparams[Weapon_MingVase].unknown154= 0;
defprojparams[Weapon_MingVase].unknown158= 0;
defprojparams[Weapon_MingVase].unknown15C= 0;
defprojparams[Weapon_MingVase].unknown160= 0;
defprojparams[Weapon_MingVase].unknown164= 0;
defprojparams[Weapon_MingVase].unknown168= 0;
defprojparams[Weapon_MingVase].unknown16C= 0;
defprojparams[Weapon_MingVase].unknown170= 0;
defprojparams[Weapon_MingVase].unknown174= 0;
defprojparams[Weapon_MadCow] = WeaponProjectileParams.new()
defprojparams[Weapon_MadCow].unknown0= 2;
defprojparams[Weapon_MadCow].unknown4= 5;
defprojparams[Weapon_MadCow].unknown8= 0;
defprojparams[Weapon_MadCow].unknownC= 0;
defprojparams[Weapon_MadCow].unknown10= 50;
defprojparams[Weapon_MadCow].unknown14= 100;
defprojparams[Weapon_MadCow].unknown18= 75;
defprojparams[Weapon_MadCow].unknown1C= 0;
defprojparams[Weapon_MadCow].unknown20= 0;
defprojparams[Weapon_MadCow].unknown24= 164;
defprojparams[Weapon_MadCow].unknown28= 6;
defprojparams[Weapon_MadCow].unknown2C= 131;
defprojparams[Weapon_MadCow].unknown30= 0;
defprojparams[Weapon_MadCow].unknown34= 100;
defprojparams[Weapon_MadCow].unknown38= 50;
defprojparams[Weapon_MadCow].unknown3C= 100;
defprojparams[Weapon_MadCow].unknown40= 0;
defprojparams[Weapon_MadCow].unknown44= 0;
defprojparams[Weapon_MadCow].unknown48= 100;
defprojparams[Weapon_MadCow].unknown4C= 5000;
defprojparams[Weapon_MadCow].unknown50= 10000;
defprojparams[Weapon_MadCow].unknown54= 0;
defprojparams[Weapon_MadCow].unknown58= 0;
defprojparams[Weapon_MadCow].unknown5C= 0;
defprojparams[Weapon_MadCow].unknown60= 0;
defprojparams[Weapon_MadCow].unknown64= 0;
defprojparams[Weapon_MadCow].unknown68= 3;
defprojparams[Weapon_MadCow].unknown6C= 4331646;
defprojparams[Weapon_MadCow].unknown70= 4331646;
defprojparams[Weapon_MadCow].unknown74= 100;
defprojparams[Weapon_MadCow].unknown78= 4;
defprojparams[Weapon_MadCow].unknown7C= 45;
defprojparams[Weapon_MadCow].unknown80= 25;
defprojparams[Weapon_MadCow].unknown84= 49;
defprojparams[Weapon_MadCow].unknown88= -1;
defprojparams[Weapon_MadCow].unknown8C= 100;
defprojparams[Weapon_MadCow].unknown90= 50;
defprojparams[Weapon_MadCow].unknown94= -10;
defprojparams[Weapon_MadCow].unknown98= 0;
defprojparams[Weapon_MadCow].unknown9C= 0;
defprojparams[Weapon_MadCow].unknownA0= 0;
defprojparams[Weapon_MadCow].unknownA4= 0;
defprojparams[Weapon_MadCow].unknownA8= 0;
defprojparams[Weapon_MadCow].unknownAC= 0;
defprojparams[Weapon_MadCow].unknownB0= 0;
defprojparams[Weapon_MadCow].unknownB4= 0;
defprojparams[Weapon_MadCow].unknownB8= 0;
defprojparams[Weapon_MadCow].unknownBC= 0;
defprojparams[Weapon_MadCow].unknownC0= 0;
defprojparams[Weapon_MadCow].unknownC4= 0;
defprojparams[Weapon_MadCow].unknownC8= 0;
defprojparams[Weapon_MadCow].unknownCC= 0;
defprojparams[Weapon_MadCow].unknownD0= 0;
defprojparams[Weapon_MadCow].unknownD4= 0;
defprojparams[Weapon_MadCow].unknownD8= 0;
defprojparams[Weapon_MadCow].unknownDC= 0;
defprojparams[Weapon_MadCow].unknownE0= 0;
defprojparams[Weapon_MadCow].unknownE4= 0;
defprojparams[Weapon_MadCow].unknownE8= 0;
defprojparams[Weapon_MadCow].unknownEC= 0;
defprojparams[Weapon_MadCow].unknownF0= 0;
defprojparams[Weapon_MadCow].unknownF4= 0;
defprojparams[Weapon_MadCow].unknownF8= 0;
defprojparams[Weapon_MadCow].unknownFC= 0;
defprojparams[Weapon_MadCow].unknown100= 0;
defprojparams[Weapon_MadCow].unknown104= 0;
defprojparams[Weapon_MadCow].unknown108= 0;
defprojparams[Weapon_MadCow].unknown10C= 0;
defprojparams[Weapon_MadCow].unknown110= 0;
defprojparams[Weapon_MadCow].unknown114= 0;
defprojparams[Weapon_MadCow].unknown118= 0;
defprojparams[Weapon_MadCow].unknown11C= 0;
defprojparams[Weapon_MadCow].unknown120= 0;
defprojparams[Weapon_MadCow].unknown124= 0;
defprojparams[Weapon_MadCow].unknown128= 0;
defprojparams[Weapon_MadCow].unknown12C= 0;
defprojparams[Weapon_MadCow].unknown130= 0;
defprojparams[Weapon_MadCow].unknown134= 0;
defprojparams[Weapon_MadCow].unknown138= 0;
defprojparams[Weapon_MadCow].unknown13C= 0;
defprojparams[Weapon_MadCow].unknown140= 0;
defprojparams[Weapon_MadCow].unknown144= 0;
defprojparams[Weapon_MadCow].unknown148= 0;
defprojparams[Weapon_MadCow].unknown14C= 0;
defprojparams[Weapon_MadCow].unknown150= 0;
defprojparams[Weapon_MadCow].unknown154= 0;
defprojparams[Weapon_MadCow].unknown158= 0;
defprojparams[Weapon_MadCow].unknown15C= 0;
defprojparams[Weapon_MadCow].unknown160= 0;
defprojparams[Weapon_MadCow].unknown164= 0;
defprojparams[Weapon_MadCow].unknown168= 0;
defprojparams[Weapon_MadCow].unknown16C= 0;
defprojparams[Weapon_MadCow].unknown170= 0;
defprojparams[Weapon_MadCow].unknown174= 0;
defprojparams[Weapon_OldWoman] = WeaponProjectileParams.new()
defprojparams[Weapon_OldWoman].unknown0= 2;
defprojparams[Weapon_OldWoman].unknown4= 5;
defprojparams[Weapon_OldWoman].unknown8= 0;
defprojparams[Weapon_OldWoman].unknownC= 0;
defprojparams[Weapon_OldWoman].unknown10= 50;
defprojparams[Weapon_OldWoman].unknown14= 100;
defprojparams[Weapon_OldWoman].unknown18= 75;
defprojparams[Weapon_OldWoman].unknown1C= 0;
defprojparams[Weapon_OldWoman].unknown20= 0;
defprojparams[Weapon_OldWoman].unknown24= 162;
defprojparams[Weapon_OldWoman].unknown28= 6;
defprojparams[Weapon_OldWoman].unknown2C= 131;
defprojparams[Weapon_OldWoman].unknown30= 0;
defprojparams[Weapon_OldWoman].unknown34= 100;
defprojparams[Weapon_OldWoman].unknown38= 50;
defprojparams[Weapon_OldWoman].unknown3C= 100;
defprojparams[Weapon_OldWoman].unknown40= 0;
defprojparams[Weapon_OldWoman].unknown44= 0;
defprojparams[Weapon_OldWoman].unknown48= 100;
defprojparams[Weapon_OldWoman].unknown4C= 5000;
defprojparams[Weapon_OldWoman].unknown50= 5000;
defprojparams[Weapon_OldWoman].unknown54= 65601;
defprojparams[Weapon_OldWoman].unknown58= 0;
defprojparams[Weapon_OldWoman].unknown5C= 0;
defprojparams[Weapon_OldWoman].unknown60= 0;
defprojparams[Weapon_OldWoman].unknown64= 0;
defprojparams[Weapon_OldWoman].unknown68= 3;
defprojparams[Weapon_OldWoman].unknown6C= 4331646;
defprojparams[Weapon_OldWoman].unknown70= 4331646;
defprojparams[Weapon_OldWoman].unknown74= 33;
defprojparams[Weapon_OldWoman].unknown78= 4;
defprojparams[Weapon_OldWoman].unknown7C= 45;
defprojparams[Weapon_OldWoman].unknown80= 25;
defprojparams[Weapon_OldWoman].unknown84= 0;
defprojparams[Weapon_OldWoman].unknown88= 0;
defprojparams[Weapon_OldWoman].unknown8C= 100;
defprojparams[Weapon_OldWoman].unknown90= 50;
defprojparams[Weapon_OldWoman].unknown94= 0;
defprojparams[Weapon_OldWoman].unknown98= 0;
defprojparams[Weapon_OldWoman].unknown9C= 0;
defprojparams[Weapon_OldWoman].unknownA0= 0;
defprojparams[Weapon_OldWoman].unknownA4= 0;
defprojparams[Weapon_OldWoman].unknownA8= 0;
defprojparams[Weapon_OldWoman].unknownAC= 0;
defprojparams[Weapon_OldWoman].unknownB0= 0;
defprojparams[Weapon_OldWoman].unknownB4= 0;
defprojparams[Weapon_OldWoman].unknownB8= 0;
defprojparams[Weapon_OldWoman].unknownBC= 0;
defprojparams[Weapon_OldWoman].unknownC0= 0;
defprojparams[Weapon_OldWoman].unknownC4= 0;
defprojparams[Weapon_OldWoman].unknownC8= 0;
defprojparams[Weapon_OldWoman].unknownCC= 0;
defprojparams[Weapon_OldWoman].unknownD0= 0;
defprojparams[Weapon_OldWoman].unknownD4= 0;
defprojparams[Weapon_OldWoman].unknownD8= 0;
defprojparams[Weapon_OldWoman].unknownDC= 0;
defprojparams[Weapon_OldWoman].unknownE0= 0;
defprojparams[Weapon_OldWoman].unknownE4= 0;
defprojparams[Weapon_OldWoman].unknownE8= 0;
defprojparams[Weapon_OldWoman].unknownEC= 0;
defprojparams[Weapon_OldWoman].unknownF0= 0;
defprojparams[Weapon_OldWoman].unknownF4= 0;
defprojparams[Weapon_OldWoman].unknownF8= 0;
defprojparams[Weapon_OldWoman].unknownFC= 0;
defprojparams[Weapon_OldWoman].unknown100= 0;
defprojparams[Weapon_OldWoman].unknown104= 0;
defprojparams[Weapon_OldWoman].unknown108= 0;
defprojparams[Weapon_OldWoman].unknown10C= 0;
defprojparams[Weapon_OldWoman].unknown110= 0;
defprojparams[Weapon_OldWoman].unknown114= 0;
defprojparams[Weapon_OldWoman].unknown118= 0;
defprojparams[Weapon_OldWoman].unknown11C= 0;
defprojparams[Weapon_OldWoman].unknown120= 0;
defprojparams[Weapon_OldWoman].unknown124= 0;
defprojparams[Weapon_OldWoman].unknown128= 0;
defprojparams[Weapon_OldWoman].unknown12C= 0;
defprojparams[Weapon_OldWoman].unknown130= 0;
defprojparams[Weapon_OldWoman].unknown134= 0;
defprojparams[Weapon_OldWoman].unknown138= 0;
defprojparams[Weapon_OldWoman].unknown13C= 0;
defprojparams[Weapon_OldWoman].unknown140= 0;
defprojparams[Weapon_OldWoman].unknown144= 0;
defprojparams[Weapon_OldWoman].unknown148= 0;
defprojparams[Weapon_OldWoman].unknown14C= 0;
defprojparams[Weapon_OldWoman].unknown150= 0;
defprojparams[Weapon_OldWoman].unknown154= 0;
defprojparams[Weapon_OldWoman].unknown158= 0;
defprojparams[Weapon_OldWoman].unknown15C= 0;
defprojparams[Weapon_OldWoman].unknown160= 0;
defprojparams[Weapon_OldWoman].unknown164= 0;
defprojparams[Weapon_OldWoman].unknown168= 0;
defprojparams[Weapon_OldWoman].unknown16C= 0;
defprojparams[Weapon_OldWoman].unknown170= 0;
defprojparams[Weapon_OldWoman].unknown174= 0;
defprojparams[Weapon_MagicBullet] = WeaponProjectileParams.new()
defprojparams[Weapon_MagicBullet].unknown0= 2;
defprojparams[Weapon_MagicBullet].unknown4= 66;
defprojparams[Weapon_MagicBullet].unknown8= 0;
defprojparams[Weapon_MagicBullet].unknownC= 137342;
defprojparams[Weapon_MagicBullet].unknown10= 0;
defprojparams[Weapon_MagicBullet].unknown14= 100;
defprojparams[Weapon_MagicBullet].unknown18= 100;
defprojparams[Weapon_MagicBullet].unknown1C= 0;
defprojparams[Weapon_MagicBullet].unknown20= 0;
defprojparams[Weapon_MagicBullet].unknown24= 49;
defprojparams[Weapon_MagicBullet].unknown28= 1;
defprojparams[Weapon_MagicBullet].unknown2C= 0;
defprojparams[Weapon_MagicBullet].unknown30= 0;
defprojparams[Weapon_MagicBullet].unknown34= 100;
defprojparams[Weapon_MagicBullet].unknown38= 50;
defprojparams[Weapon_MagicBullet].unknown3C= 100;
defprojparams[Weapon_MagicBullet].unknown40= 0;
defprojparams[Weapon_MagicBullet].unknown44= 0;
defprojparams[Weapon_MagicBullet].unknown48= 100;
defprojparams[Weapon_MagicBullet].unknown4C= 0;
defprojparams[Weapon_MagicBullet].unknown50= 10000;
defprojparams[Weapon_MagicBullet].unknown54= 65598;
defprojparams[Weapon_MagicBullet].unknown58= 0;
defprojparams[Weapon_MagicBullet].unknown5C= 0;
defprojparams[Weapon_MagicBullet].unknown60= 0;
defprojparams[Weapon_MagicBullet].unknown64= 0;
defprojparams[Weapon_MagicBullet].unknown68= 1;
defprojparams[Weapon_MagicBullet].unknown6C= 0;
defprojparams[Weapon_MagicBullet].unknown70= 49;
defprojparams[Weapon_MagicBullet].unknown74= 2;
defprojparams[Weapon_MagicBullet].unknown78= 135;
defprojparams[Weapon_MagicBullet].unknown7C= 50;
defprojparams[Weapon_MagicBullet].unknown80= 100;
defprojparams[Weapon_MagicBullet].unknown84= 50;
defprojparams[Weapon_MagicBullet].unknown88= 2;
defprojparams[Weapon_MagicBullet].unknown8C= 100;
defprojparams[Weapon_MagicBullet].unknown90= 9900;
defprojparams[Weapon_MagicBullet].unknown94= 0;
defprojparams[Weapon_MagicBullet].unknown98= 0;
defprojparams[Weapon_MagicBullet].unknown9C= 0;
defprojparams[Weapon_MagicBullet].unknownA0= 0;
defprojparams[Weapon_MagicBullet].unknownA4= 0;
defprojparams[Weapon_MagicBullet].unknownA8= 0;
defprojparams[Weapon_MagicBullet].unknownAC= 0;
defprojparams[Weapon_MagicBullet].unknownB0= 0;
defprojparams[Weapon_MagicBullet].unknownB4= 0;
defprojparams[Weapon_MagicBullet].unknownB8= 0;
defprojparams[Weapon_MagicBullet].unknownBC= 0;
defprojparams[Weapon_MagicBullet].unknownC0= 0;
defprojparams[Weapon_MagicBullet].unknownC4= 0;
defprojparams[Weapon_MagicBullet].unknownC8= 0;
defprojparams[Weapon_MagicBullet].unknownCC= 0;
defprojparams[Weapon_MagicBullet].unknownD0= 0;
defprojparams[Weapon_MagicBullet].unknownD4= 0;
defprojparams[Weapon_MagicBullet].unknownD8= 0;
defprojparams[Weapon_MagicBullet].unknownDC= 0;
defprojparams[Weapon_MagicBullet].unknownE0= 0;
defprojparams[Weapon_MagicBullet].unknownE4= 0;
defprojparams[Weapon_MagicBullet].unknownE8= 0;
defprojparams[Weapon_MagicBullet].unknownEC= 0;
defprojparams[Weapon_MagicBullet].unknownF0= 0;
defprojparams[Weapon_MagicBullet].unknownF4= 0;
defprojparams[Weapon_MagicBullet].unknownF8= 0;
defprojparams[Weapon_MagicBullet].unknownFC= 0;
defprojparams[Weapon_MagicBullet].unknown100= 0;
defprojparams[Weapon_MagicBullet].unknown104= 0;
defprojparams[Weapon_MagicBullet].unknown108= 0;
defprojparams[Weapon_MagicBullet].unknown10C= 0;
defprojparams[Weapon_MagicBullet].unknown110= 0;
defprojparams[Weapon_MagicBullet].unknown114= 0;
defprojparams[Weapon_MagicBullet].unknown118= 0;
defprojparams[Weapon_MagicBullet].unknown11C= 0;
defprojparams[Weapon_MagicBullet].unknown120= 0;
defprojparams[Weapon_MagicBullet].unknown124= 0;
defprojparams[Weapon_MagicBullet].unknown128= 0;
defprojparams[Weapon_MagicBullet].unknown12C= 0;
defprojparams[Weapon_MagicBullet].unknown130= 0;
defprojparams[Weapon_MagicBullet].unknown134= 0;
defprojparams[Weapon_MagicBullet].unknown138= 0;
defprojparams[Weapon_MagicBullet].unknown13C= 0;
defprojparams[Weapon_MagicBullet].unknown140= 0;
defprojparams[Weapon_MagicBullet].unknown144= 0;
defprojparams[Weapon_MagicBullet].unknown148= 0;
defprojparams[Weapon_MagicBullet].unknown14C= 0;
defprojparams[Weapon_MagicBullet].unknown150= 0;
defprojparams[Weapon_MagicBullet].unknown154= 0;
defprojparams[Weapon_MagicBullet].unknown158= 0;
defprojparams[Weapon_MagicBullet].unknown15C= 0;
defprojparams[Weapon_MagicBullet].unknown160= 0;
defprojparams[Weapon_MagicBullet].unknown164= 0;
defprojparams[Weapon_MagicBullet].unknown168= 0;
defprojparams[Weapon_MagicBullet].unknown16C= 0;
defprojparams[Weapon_MagicBullet].unknown170= 0;
defprojparams[Weapon_MagicBullet].unknown174= 0;
		
		
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
	if jump_structure.name1 == "Salto" then
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





function PrintTurnGame(this)
	io.write("---TURN--\n",2)
	io.write("unknown30" .. ": " .. this.unknown30.. ": " .. "\n",2)
	io.write("unknown34" .. ": " .. this.unknown34.. ": " .. "\n",2)
	io.write("unknown38" .. ": " .. this.unknown38.. ": " .. "\n",2)
	io.write("unknown3C" .. ": " .. this.unknown3C.. ": " .. "\n",2)
	io.write("unknown40" .. ": " .. this.unknown40.. ": " .. "\n",2)
	io.write("unknown44" .. ": " .. this.unknown44.. ": " .. "\n",2)
	io.write("unknown48" .. ": " .. this.unknown48.. ": " .. "\n",2)
	io.write("unknown4C" .. ": " .. this.unknown4C.. ": " .. "\n",2)
	io.write("unknown50" .. ": " .. this.unknown50.. ": " .. "\n",2)
	io.write("unknown54" .. ": " .. this.unknown54.. ": " .. "\n",2)
	io.write("unknown58" .. ": " .. this.unknown58.. ": " .. "\n",2)
	io.write("unknown5C" .. ": " .. this.unknown5C.. ": " .. "\n",2)
	io.write("unknown60" .. ": " .. this.unknown60.. ": " .. "\n",2)
	io.write("unknown64" .. ": " .. this.unknown64.. ": " .. "\n",2)
	io.write("unknown68" .. ": " .. this.unknown68.. ": " .. "\n",2)
	io.write("unknown6C" .. ": " .. this.unknown6C.. ": " .. "\n",2)
	io.write("unknown70" .. ": " .. this.unknown70.. ": " .. "\n",2)
	io.write("unknown74" .. ": " .. this.unknown74.. ": " .. "\n",2)
	io.write("unknown78" .. ": " .. this.unknown78.. ": " .. "\n",2)
	io.write("unknown7C" .. ": " .. this.unknown7C.. ": " .. "\n",2)
	io.write("unknown80" .. ": " .. this.unknown80.. ": " .. "\n",2)
	io.write("unknown84" .. ": " .. this.unknown84.. ": " .. "\n",2)
	io.write("unknown88" .. ": " .. this.unknown88.. ": " .. "\n",2)
	io.write("unknown8C" .. ": " .. this.unknown8C.. ": " .. "\n",2)
	io.write("unknown90" .. ": " .. this.unknown90.. ": " .. "\n",2)
	io.write("unknown94" .. ": " .. this.unknown94.. ": " .. "\n",2)
	io.write("unknown98" .. ": " .. this.unknown98.. ": " .. "\n",2)
	io.write("unknown9C" .. ": " .. this.unknown9C.. ": " .. "\n",2)
	io.write("unknownA0" .. ": " .. this.unknownA0.. ": " .. "\n",2)
	io.write("unknownA4" .. ": " .. this.unknownA4.. ": " .. "\n",2)
	io.write("unknownA8" .. ": " .. this.unknownA8.. ": " .. "\n",2)
	io.write("unknownAC" .. ": " .. this.unknownAC.. ": " .. "\n",2)
	io.write("unknownB0" .. ": " .. this.unknownB0.. ": " .. "\n",2)
	io.write("unknownB4" .. ": " .. this.unknownB4.. ": " .. "\n",2)
	io.write("unknownB8" .. ": " .. this.unknownB8.. ": " .. "\n",2)
	io.write("unknownBC" .. ": " .. this.unknownBC.. ": " .. "\n",2)
	io.write("unknownC0" .. ": " .. this.unknownC0.. ": " .. "\n",2)
	io.write("unknownC4" .. ": " .. this.unknownC4.. ": " .. "\n",2)
	io.write("unknownC8" .. ": " .. this.unknownC8.. ": " .. "\n",2)
	io.write("unknownCC" .. ": " .. this.unknownCC.. ": " .. "\n",2)
	io.write("unknownD0" .. ": " .. this.unknownD0.. ": " .. "\n",2)
	io.write("unknownD4" .. ": " .. this.unknownD4.. ": " .. "\n",2)
	io.write("unknownD8" .. ": " .. this.unknownD8.. ": " .. "\n",2)
	io.write("unknownDC" .. ": " .. this.unknownDC.. ": " .. "\n",2)
	io.write("unknownE0" .. ": " .. this.unknownE0.. ": " .. "\n",2)
	io.write("unknownE4" .. ": " .. this.unknownE4.. ": " .. "\n",2)
	io.write("unknownE8" .. ": " .. this.unknownE8.. ": " .. "\n",2)
	io.write("TeamId" .. ": " .. this.unknownEC.. ": " .. "\n",2) --teamid
	io.write("unknownF0" .. ": " .. this.unknownF0.. ": " .. "\n",2)
	io.write("unknownF4" .. ": " .. this.unknownF4.. ": " .. "\n",2)
	io.write("unknownF8" .. ": " .. this.unknownF8.. ": " .. "\n",2)
	io.write("unknownFC" .. ": " .. this.unknownFC.. ": " .. "\n",2)
	io.write("unknown100" .. ": " .. this.unknown100.. ": " .. "\n",2)
	io.write("unknown104" .. ": " .. this.unknown104.. ": " .. "\n",2)
	io.write("unknown108" .. ": " .. this.unknown108.. ": " .. "\n",2)
	io.write("unknown10C" .. ": " .. this.unknown10C.. ": " .. "\n",2)
	io.write("unknown110" .. ": " .. this.unknown110.. ": " .. "\n",2)
	io.write("unknown114" .. ": " .. this.unknown114.. ": " .. "\n",2)
	io.write("unknown118" .. ": " .. this.unknown118.. ": " .. "\n",2)
	io.write("unknown11C" .. ": " .. this.unknown11C.. ": " .. "\n",2)
	io.write("unknown120" .. ": " .. this.unknown120.. ": " .. "\n",2)
	io.write("unknown124" .. ": " .. this.unknown124.. ": " .. "\n",2)
	io.write("unknown128" .. ": " .. this.unknown128.. ": " .. "\n",2)
	io.write("unknown12C" .. ": " .. this.unknown12C.. ": " .. "\n",2)
	io.write("unknown130" .. ": " .. this.unknown130.. ": " .. "\n",2)
	io.write("unknown134" .. ": " .. this.unknown134.. ": " .. "\n",2)
	io.write("unknown138" .. ": " .. this.unknown138.. ": " .. "\n",2)
	io.write("unknown13C" .. ": " .. this.unknown13C.. ": " .. "\n",2)
	io.write("unknown140" .. ": " .. this.unknown140.. ": " .. "\n",2)
	io.write("unknown144" .. ": " .. this.unknown144.. ": " .. "\n",2)
	io.write("unknown148" .. ": " .. this.unknown148.. ": " .. "\n",2)
	io.write("unknown14C" .. ": " .. this.unknown14C.. ": " .. "\n",2)
	io.write("unknown150" .. ": " .. this.unknown150.. ": " .. "\n",2)
	io.write("unknown154" .. ": " .. this.unknown154.. ": " .. "\n",2)
	io.write("unknown158" .. ": " .. this.unknown158.. ": " .. "\n",2)
	io.write("unknown15C" .. ": " .. this.unknown15C.. ": " .. "\n",2)
	io.write("unknown160" .. ": " .. this.unknown160.. ": " .. "\n",2)
	io.write("unknown164" .. ": " .. this.unknown164.. ": " .. "\n",2)
	io.write("unknown168" .. ": " .. this.unknown168.. ": " .. "\n",2)
	io.write("unknown16C" .. ": " .. this.unknown16C.. ": " .. "\n",2)
	io.write("unknown170" .. ": " .. this.unknown170.. ": " .. "\n",2)
	io.write("unknown174" .. ": " .. this.unknown174.. ": " .. "\n",2)
	io.write("unknown178" .. ": " .. this.unknown178.. ": " .. "\n",2)
	io.write("unknown17C" .. ": " .. this.unknown17C.. ": " .. "\n",2)
	io.write("unknown180" .. ": " .. this.unknown180.. ": " .. "\n",2)
	io.write("unknown184" .. ": " .. this.unknown184.. ": " .. "\n",2)
	io.write("unknown188" .. ": " .. this.unknown188.. ": " .. "\n",2)
	io.write("unknown18C" .. ": " .. this.unknown18C.. ": " .. "\n",2)
	io.write("unknown190" .. ": " .. this.unknown190.. ": " .. "\n",2)
	io.write("unknown194" .. ": " .. this.unknown194.. ": " .. "\n",2)
	io.write("unknown198" .. ": " .. this.unknown198.. ": " .. "\n",2)
	io.write("unknown19C" .. ": " .. this.unknown19C.. ": " .. "\n",2)
	io.write("unknown1A0" .. ": " .. this.unknown1A0.. ": " .. "\n",2)
	io.write("unknown1A4" .. ": " .. this.unknown1A4.. ": " .. "\n",2)
	io.write("unknown1A8" .. ": " .. this.unknown1A8.. ": " .. "\n",2)
	io.write("unknown1AC" .. ": " .. this.unknown1AC.. ": " .. "\n",2)
	io.write("unknown1B0" .. ": " .. this.unknown1B0.. ": " .. "\n",2)
	io.write("unknown1B4" .. ": " .. this.unknown1B4.. ": " .. "\n",2)
	io.write("unknown1B8" .. ": " .. this.unknown1B8.. ": " .. "\n",2)
	io.write("unknown1BC" .. ": " .. this.unknown1BC.. ": " .. "\n",2)
	io.write("unknown1C0" .. ": " .. this.unknown1C0.. ": " .. "\n",2)
	io.write("unknown1C4" .. ": " .. this.unknown1C4.. ": " .. "\n",2)
	io.write("unknown1C8" .. ": " .. this.unknown1C8.. ": " .. "\n",2)
	io.write("unknown1CC" .. ": " .. this.unknown1CC.. ": " .. "\n",2)
	io.write("unknown1D0" .. ": " .. this.unknown1D0.. ": " .. "\n",2)
	io.write("unknown1D4" .. ": " .. this.unknown1D4.. ": " .. "\n",2)
	io.write("unknown1D8" .. ": " .. this.unknown1D8.. ": " .. "\n",2)
	io.write("unknown1DC" .. ": " .. this.unknown1DC.. ": " .. "\n",2)
	io.write("unknown1E0" .. ": " .. this.unknown1E0.. ": " .. "\n",2)
	io.write("unknown1E4" .. ": " .. this.unknown1E4.. ": " .. "\n",2)
	io.write("unknown1E8" .. ": " .. this.unknown1E8.. ": " .. "\n",2)
	io.write("unknown1EC" .. ": " .. this.unknown1EC.. ": " .. "\n",2)
	io.write("unknown1F0" .. ": " .. this.unknown1F0.. ": " .. "\n",2)
	io.write("unknown1F4" .. ": " .. this.unknown1F4.. ": " .. "\n",2)
	io.write("unknown1F8" .. ": " .. this.unknown1F8.. ": " .. "\n",2)
	io.write("unknown1FC" .. ": " .. this.unknown1FC.. ": " .. "\n",2)
	io.write("unknown200" .. ": " .. this.unknown200.. ": " .. "\n",2)
	io.write("unknown204" .. ": " .. this.unknown204.. ": " .. "\n",2)
	io.write("unknown208" .. ": " .. this.unknown208.. ": " .. "\n",2)
	io.write("unknown20C" .. ": " .. this.unknown20C.. ": " .. "\n",2)
	io.write("unknown210" .. ": " .. this.unknown210.. ": " .. "\n",2)
	io.write("unknown214" .. ": " .. this.unknown214.. ": " .. "\n",2)
	io.write("unknown218" .. ": " .. this.unknown218.. ": " .. "\n",2)
	io.write("unknown21C" .. ": " .. this.unknown21C.. ": " .. "\n",2)
	io.write("unknown220" .. ": " .. this.unknown220.. ": " .. "\n",2)
	io.write("unknown224" .. ": " .. this.unknown224.. ": " .. "\n",2)
	io.write("unknown228" .. ": " .. this.unknown228.. ": " .. "\n",2)
	io.write("unknown22C" .. ": " .. this.unknown22C.. ": " .. "\n",2)
	io.write("unknown230" .. ": " .. this.unknown230.. ": " .. "\n",2)
	io.write("unknown234" .. ": " .. this.unknown234.. ": " .. "\n",2)
	io.write("unknown238" .. ": " .. this.unknown238.. ": " .. "\n",2)
	io.write("unknown23C" .. ": " .. this.unknown23C.. ": " .. "\n",2)
	io.write("unknown240" .. ": " .. this.unknown240.. ": " .. "\n",2)
	io.write("unknown244" .. ": " .. this.unknown244.. ": " .. "\n",2)
	io.write("unknown248" .. ": " .. this.unknown248.. ": " .. "\n",2)
	io.write("unknown24C" .. ": " .. this.unknown24C.. ": " .. "\n",2)
	io.write("unknown250" .. ": " .. this.unknown250.. ": " .. "\n",2)
	io.write("unknown254" .. ": " .. this.unknown254.. ": " .. "\n",2)
	io.write("unknown258" .. ": " .. this.unknown258.. ": " .. "\n",2)
	io.write("unknown25C" .. ": " .. this.unknown25C.. ": " .. "\n",2)
	io.write("unknown260" .. ": " .. this.unknown260.. ": " .. "\n",2)
	io.write("unknown264" .. ": " .. this.unknown264.. ": " .. "\n",2)
	io.write("unknown268" .. ": " .. this.unknown268.. ": " .. "\n",2)
	io.write("unknown26C" .. ": " .. this.unknown26C.. ": " .. "\n",2)
	io.write("unknown270" .. ": " .. this.unknown270.. ": " .. "\n",2)
	io.write("unknown274" .. ": " .. this.unknown274.. ": " .. "\n",2)
	io.write("unknown278" .. ": " .. this.unknown278.. ": " .. "\n",2)
	io.write("unknown27C" .. ": " .. this.unknown27C.. ": " .. "\n",2)
	io.write("unknown280" .. ": " .. this.unknown280.. ": " .. "\n",2)
	io.write("unknown284" .. ": " .. this.unknown284.. ": " .. "\n",2)
	io.write("unknown288" .. ": " .. this.unknown288.. ": " .. "\n",2)
	io.write("unknown28C" .. ": " .. this.unknown28C.. ": " .. "\n",2)
	io.write("unknown290" .. ": " .. this.unknown290.. ": " .. "\n",2)
	io.write("unknown294" .. ": " .. this.unknown294.. ": " .. "\n",2)
	io.write("unknown298" .. ": " .. this.unknown298.. ": " .. "\n",2)
	io.write("unknown29C" .. ": " .. this.unknown29C.. ": " .. "\n",2)
	io.write("unknown2A0" .. ": " .. this.unknown2A0.. ": " .. "\n",2)
	io.write("unknown2A4" .. ": " .. this.unknown2A4.. ": " .. "\n",2)
	io.write("unknown2A8" .. ": " .. this.unknown2A8.. ": " .. "\n",2)
	io.write("unknown2AC" .. ": " .. this.unknown2AC.. ": " .. "\n",2)
	io.write("unknown2B0" .. ": " .. this.unknown2B0.. ": " .. "\n",2)
	io.write("unknown2B4" .. ": " .. this.unknown2B4.. ": " .. "\n",2)
	io.write("unknown2B8" .. ": " .. this.unknown2B8.. ": " .. "\n",2)
	io.write("unknown2BC" .. ": " .. this.unknown2BC.. ": " .. "\n",2)
	io.write("unknown2C0" .. ": " .. this.unknown2C0.. ": " .. "\n",2)
	io.write("unknown2C4" .. ": " .. this.unknown2C4.. ": " .. "\n",2)
	io.write("unknown2C8" .. ": " .. this.unknown2C8.. ": " .. "\n",2)
	io.write("unknown2CC" .. ": " .. this.unknown2CC.. ": " .. "\n",2)
	io.write("unknown2D0" .. ": " .. this.unknown2D0.. ": " .. "\n",2)
	io.write("unknown2D4" .. ": " .. this.unknown2D4.. ": " .. "\n",2)
	io.write("unknown2D8" .. ": " .. this.unknown2D8.. ": " .. "\n",2)
	io.write("unknown2DC" .. ": " .. this.unknown2DC.. ": " .. "\n",2)
	
end

function PrintTeam(this)
	io.write("---TEAM--\n",2)
	io.write("unknown30" .. ": " ..  this.unknown30 .. ": " .. "\n",2)
	io.write("unknown34" .. ": " ..  this.unknown34 .. ": " .. "\n",2)
	io.write("team_number_dword38" .. ": " ..  this.team_number_dword38 .. ": " .. "\n",2)
	io.write("unknown3C" .. ": " ..  this.unknown3C .. ": " .. "\n",2)
	io.write("unknown40" .. ": " ..  this.unknown40 .. ": " .. "\n",2)
	io.write("unknown44" .. ": " ..  this.unknown44 .. ": " .. "\n",2)
	io.write("unknown48" .. ": " ..  this.unknown48 .. ": " .. "\n",2)
	io.write("unknown4C" .. ": " ..  this.unknown4C .. ": " .. "\n",2)
	io.write("unknown50" .. ": " ..  this.unknown50 .. ": " .. "\n",2)
	io.write("unknown54" .. ": " ..  this.unknown54 .. ": " .. "\n",2)
	io.write("unknown58" .. ": " ..  this.unknown58 .. ": " .. "\n",2)
	io.write("unknown5C" .. ": " ..  this.unknown5C .. ": " .. "\n",2)
	io.write("lastLaunchedWeapon_dword60" .. ": " ..  this.lastLaunchedWeapon_dword60 .. ": " .. "\n",2)
	io.write("unknown64" .. ": " ..  this.unknown64 .. ": " .. "\n",2)
	io.write("unknown68" .. ": " ..  this.unknown68 .. ": " .. "\n",2)
	io.write("unknown6C" .. ": " ..  this.unknown6C .. ": " .. "\n",2)
	io.write("unknown70" .. ": " ..  this.unknown70 .. ": " .. "\n",2)
	io.write("unknown74" .. ": " ..  this.unknown74 .. ": " .. "\n",2)
	io.write("unknown78" .. ": " ..  this.unknown78 .. ": " .. "\n",2)
	io.write("unknown7C" .. ": " ..  this.unknown7C .. ": " .. "\n",2)
	io.write("unknown80" .. ": " ..  this.unknown80 .. ": " .. "\n",2)
	io.write("unknown84" .. ": " ..  this.unknown84 .. ": " .. "\n",2)
	io.write("unknown88" .. ": " ..  this.unknown88 .. ": " .. "\n",2)
	io.write("unknown8C" .. ": " ..  this.unknown8C .. ": " .. "\n",2)
	io.write("unknown90" .. ": " ..  this.unknown90 .. ": " .. "\n",2)
	io.write("unknown94" .. ": " ..  this.unknown94 .. ": " .. "\n",2)
	io.write("unknown98" .. ": " ..  this.unknown98 .. ": " .. "\n",2)
	io.write("unknown9C" .. ": " ..  this.unknown9C .. ": " .. "\n",2)
	io.write("unknownA0" .. ": " ..  this.unknownA0 .. ": " .. "\n",2)
	io.write("unknownA4" .. ": " ..  this.unknownA4 .. ": " .. "\n",2)
	io.write("unknownA8" .. ": " ..  this.unknownA8 .. ": " .. "\n",2)
	io.write("unknownAC" .. ": " ..  this.unknownAC .. ": " .. "\n",2)
	io.write("unknownB0" .. ": " ..  this.unknownB0 .. ": " .. "\n",2)
	io.write("unknownB4" .. ": " ..  this.unknownB4 .. ": " .. "\n",2)
	io.write("unknownB8" .. ": " ..  this.unknownB8 .. ": " .. "\n",2)
	io.write("unknownBC" .. ": " ..  this.unknownBC .. ": " .. "\n",2)
	io.write("unknownC0" .. ": " ..  this.unknownC0 .. ": " .. "\n",2)
	io.write("unknownC4" .. ": " ..  this.unknownC4 .. ": " .. "\n",2)
	io.write("unknownC8" .. ": " ..  this.unknownC8 .. ": " .. "\n",2)
	io.write("unknownCC" .. ": " ..  this.unknownCC .. ": " .. "\n",2)
	io.write("unknownD0" .. ": " ..  this.unknownD0 .. ": " .. "\n",2)
	io.write("unknownD4" .. ": " ..  this.unknownD4 .. ": " .. "\n",2)
	io.write("unknownD8" .. ": " ..  this.unknownD8 .. ": " .. "\n",2)
	io.write("unknownDC" .. ": " ..  this.unknownDC .. ": " .. "\n",2)
	io.write("unknownE0" .. ": " ..  this.unknownE0 .. ": " .. "\n",2)
	io.write("unknownE4" .. ": " ..  this.unknownE4 .. ": " .. "\n",2)
	io.write("unknownE8" .. ": " ..  this.unknownE8 .. ": " .. "\n",2)
	io.write("unknownEC" .. ": " ..  this.unknownEC .. ": " .. "\n",2)
	io.write("unknownF0" .. ": " ..  this.unknownF0 .. ": " .. "\n",2)
	io.write("unknownF4" .. ": " ..  this.unknownF4 .. ": " .. "\n",2)
	io.write("unknownF8" .. ": " ..  this.unknownF8 .. ": " .. "\n",2)
	io.write("unknownFC" .. ": " ..  this.unknownFC .. ": " .. "\n",2)
	io.write("unknown100" .. ": " ..  this.unknown100 .. ": " .. "\n",2)
	io.write("unknown104" .. ": " ..  this.unknown104 .. ": " .. "\n",2)
	io.write("unknown108" .. ": " ..  this.unknown108 .. ": " .. "\n",2)
	io.write("unknown10C" .. ": " ..  this.unknown10C .. ": " .. "\n",2)
	io.write("unknown110" .. ": " ..  this.unknown110 .. ": " .. "\n",2)
	io.write("unknown114" .. ": " ..  this.unknown114 .. ": " .. "\n",2)
	io.write("unknown118" .. ": " ..  this.unknown118 .. ": " .. "\n",2)
	io.write("unknown11C" .. ": " ..  this.unknown11C .. ": " .. "\n",2)
	io.write("unknown120" .. ": " ..  this.unknown120 .. ": " .. "\n",2)
	io.write("unknown124" .. ": " ..  this.unknown124 .. ": " .. "\n",2)
	io.write("unknown128" .. ": " ..  this.unknown128 .. ": " .. "\n",2)
	io.write("unknown12C" .. ": " ..  this.unknown12C .. ": " .. "\n",2)
	io.write("unknown130" .. ": " ..  this.unknown130 .. ": " .. "\n",2)
	io.write("unknown134" .. ": " ..  this.unknown134 .. ": " .. "\n",2)
	io.write("unknown138" .. ": " ..  this.unknown138 .. ": " .. "\n",2)
	io.write("unknown13C" .. ": " ..  this.unknown13C .. ": " .. "\n",2)
	io.write("unknown140" .. ": " ..  this.unknown140 .. ": " .. "\n",2)
	io.write("unknown144" .. ": " ..  this.unknown144 .. ": " .. "\n",2)
	io.write("unknown148" .. ": " ..  this.unknown148 .. ": " .. "\n",2)
	io.write("unknown14C" .. ": " ..  this.unknown14C .. ": " .. "\n",2)
	io.write("unknown150" .. ": " ..  this.unknown150 .. ": " .. "\n",2)
	io.write("unknown154" .. ": " ..  this.unknown154 .. ": " .. "\n",2)
	io.write("unknown158" .. ": " ..  this.unknown158 .. ": " .. "\n",2)
	io.write("unknown15C" .. ": " ..  this.unknown15C .. ": " .. "\n",2)
	io.write("unknown160" .. ": " ..  this.unknown160 .. ": " .. "\n",2)
	io.write("unknown164" .. ": " ..  this.unknown164 .. ": " .. "\n",2)
	io.write("unknown168" .. ": " ..  this.unknown168 .. ": " .. "\n",2)
	io.write("unknown16C" .. ": " ..  this.unknown16C .. ": " .. "\n",2)
	io.write("unknown170" .. ": " ..  this.unknown170 .. ": " .. "\n",2)
	io.write("unknown174" .. ": " ..  this.unknown174 .. ": " .. "\n",2)
	io.write("unknown178" .. ": " ..  this.unknown178 .. ": " .. "\n",2)
	io.write("unknown17C" .. ": " ..  this.unknown17C .. ": " .. "\n",2)
	io.write("unknown180" .. ": " ..  this.unknown180 .. ": " .. "\n",2)
	io.write("unknown184" .. ": " ..  this.unknown184 .. ": " .. "\n",2)
	io.write("unknown188" .. ": " ..  this.unknown188 .. ": " .. "\n",2)
	io.write("unknown18C" .. ": " ..  this.unknown18C .. ": " .. "\n",2)
	io.write("unknown190" .. ": " ..  this.unknown190 .. ": " .. "\n",2)
	io.write("unknown194" .. ": " ..  this.unknown194 .. ": " .. "\n",2)
	io.write("unknown198" .. ": " ..  this.unknown198 .. ": " .. "\n",2)
	io.write("unknown19C" .. ": " ..  this.unknown19C .. ": " .. "\n",2)
	io.write("unknown1A0" .. ": " ..  this.unknown1A0 .. ": " .. "\n",2)
	io.write("unknown1A4" .. ": " ..  this.unknown1A4 .. ": " .. "\n",2)
	io.write("unknown1A8" .. ": " ..  this.unknown1A8 .. ": " .. "\n",2)
	io.write("unknown1AC" .. ": " ..  this.unknown1AC .. ": " .. "\n",2)
	io.write("unknown1B0" .. ": " ..  this.unknown1B0 .. ": " .. "\n",2)
	io.write("unknown1B4" .. ": " ..  this.unknown1B4 .. ": " .. "\n",2)
	io.write("unknown1B8" .. ": " ..  this.unknown1B8 .. ": " .. "\n",2)
	io.write("unknown1BC" .. ": " ..  this.unknown1BC .. ": " .. "\n",2)
	io.write("unknown1C0" .. ": " ..  this.unknown1C0 .. ": " .. "\n",2)
	io.write("unknown1C4" .. ": " ..  this.unknown1C4 .. ": " .. "\n",2)
	io.write("unknown1C8" .. ": " ..  this.unknown1C8 .. ": " .. "\n",2)
	io.write("unknown1CC" .. ": " ..  this.unknown1CC .. ": " .. "\n",2)
	io.write("unknown1D0" .. ": " ..  this.unknown1D0 .. ": " .. "\n",2)
	io.write("unknown1D4" .. ": " ..  this.unknown1D4 .. ": " .. "\n",2)
	io.write("unknown1D8" .. ": " ..  this.unknown1D8 .. ": " .. "\n",2)
	io.write("unknown1DC" .. ": " ..  this.unknown1DC .. ": " .. "\n",2)
	io.write("unknown1E0" .. ": " ..  this.unknown1E0 .. ": " .. "\n",2)
	io.write("unknown1E4" .. ": " ..  this.unknown1E4 .. ": " .. "\n",2)
	io.write("unknown1E8" .. ": " ..  this.unknown1E8 .. ": " .. "\n",2)
	io.write("unknown1EC" .. ": " ..  this.unknown1EC .. ": " .. "\n",2)
	io.write("unknown1F0" .. ": " ..  this.unknown1F0 .. ": " .. "\n",2)
	io.write("unknown1F4" .. ": " ..  this.unknown1F4 .. ": " .. "\n",2)
	io.write("unknown1F8" .. ": " ..  this.unknown1F8 .. ": " .. "\n",2)
	io.write("unknown1FC" .. ": " ..  this.unknown1FC .. ": " .. "\n",2)
	io.write("unknown200" .. ": " ..  this.unknown200 .. ": " .. "\n",2)
	io.write("unknown204" .. ": " ..  this.unknown204 .. ": " .. "\n",2)
	io.write("unknown208" .. ": " ..  this.unknown208 .. ": " .. "\n",2)
	io.write("unknown20C" .. ": " ..  this.unknown20C .. ": " .. "\n",2)
	io.write("unknown210" .. ": " ..  this.unknown210 .. ": " .. "\n",2)
	io.write("unknown214" .. ": " ..  this.unknown214 .. ": " .. "\n",2)
	io.write("unknown218" .. ": " ..  this.unknown218 .. ": " .. "\n",2)
	io.write("unknown21C" .. ": " ..  this.unknown21C .. ": " .. "\n",2)
	io.write("unknown220" .. ": " ..  this.unknown220 .. ": " .. "\n",2)
	io.write("unknown224" .. ": " ..  this.unknown224 .. ": " .. "\n",2)
	io.write("unknown228" .. ": " ..  this.unknown228 .. ": " .. "\n",2)
	io.write("unknown22C" .. ": " ..  this.unknown22C .. ": " .. "\n",2)
	io.write("unknown230" .. ": " ..  this.unknown230 .. ": " .. "\n",2)
	io.write("unknown234" .. ": " ..  this.unknown234 .. ": " .. "\n",2)
	io.write("unknown238" .. ": " ..  this.unknown238 .. ": " .. "\n",2)
	io.write("unknown23C" .. ": " ..  this.unknown23C .. ": " .. "\n",2)
	io.write("unknown240" .. ": " ..  this.unknown240 .. ": " .. "\n",2)
	io.write("unknown244" .. ": " ..  this.unknown244 .. ": " .. "\n",2)
	io.write("unknown248" .. ": " ..  this.unknown248 .. ": " .. "\n",2)
	io.write("unknown24C" .. ": " ..  this.unknown24C .. ": " .. "\n",2)
	io.write("unknown250" .. ": " ..  this.unknown250 .. ": " .. "\n",2)
	io.write("unknown254" .. ": " ..  this.unknown254 .. ": " .. "\n",2)
	io.write("unknown258" .. ": " ..  this.unknown258 .. ": " .. "\n",2)
	io.write("unknown25C" .. ": " ..  this.unknown25C .. ": " .. "\n",2)
	io.write("unknown260" .. ": " ..  this.unknown260 .. ": " .. "\n",2)
	io.write("unknown264" .. ": " ..  this.unknown264 .. ": " .. "\n",2)
	io.write("unknown268" .. ": " ..  this.unknown268 .. ": " .. "\n",2)
	io.write("unknown26C" .. ": " ..  this.unknown26C .. ": " .. "\n",2)
	io.write("unknown270" .. ": " ..  this.unknown270 .. ": " .. "\n",2)
	io.write("unknown274" .. ": " ..  this.unknown274 .. ": " .. "\n",2)
	io.write("unknown278" .. ": " ..  this.unknown278 .. ": " .. "\n",2)
	io.write("unknown27C" .. ": " ..  this.unknown27C .. ": " .. "\n",2)
	io.write("unknown280" .. ": " ..  this.unknown280 .. ": " .. "\n",2)
	io.write("unknown284" .. ": " ..  this.unknown284 .. ": " .. "\n",2)
	io.write("unknown288" .. ": " ..  this.unknown288 .. ": " .. "\n",2)
	io.write("unknown28C" .. ": " ..  this.unknown28C .. ": " .. "\n",2)
	io.write("unknown290" .. ": " ..  this.unknown290 .. ": " .. "\n",2)
	io.write("unknown294" .. ": " ..  this.unknown294 .. ": " .. "\n",2)
	io.write("unknown298" .. ": " ..  this.unknown298 .. ": " .. "\n",2)
	io.write("unknown29C" .. ": " ..  this.unknown29C .. ": " .. "\n",2)
	io.write("unknown2A0" .. ": " ..  this.unknown2A0 .. ": " .. "\n",2)
	io.write("unknown2A4" .. ": " ..  this.unknown2A4 .. ": " .. "\n",2)
	io.write("unknown2A8" .. ": " ..  this.unknown2A8 .. ": " .. "\n",2)
	io.write("unknown2AC" .. ": " ..  this.unknown2AC .. ": " .. "\n",2)
	io.write("unknown2B0" .. ": " ..  this.unknown2B0 .. ": " .. "\n",2)
	io.write("unknown2B4" .. ": " ..  this.unknown2B4 .. ": " .. "\n",2)
	io.write("unknown2B8" .. ": " ..  this.unknown2B8 .. ": " .. "\n",2)
	io.write("unknown2BC" .. ": " ..  this.unknown2BC .. ": " .. "\n",2)
	io.write("unknown2C0" .. ": " ..  this.unknown2C0 .. ": " .. "\n",2)
	io.write("unknown2C4" .. ": " ..  this.unknown2C4 .. ": " .. "\n",2)
	io.write("unknown2C8" .. ": " ..  this.unknown2C8 .. ": " .. "\n",2)
	io.write("unknown2CC" .. ": " ..  this.unknown2CC .. ": " .. "\n",2)
	io.write("unknown2D0" .. ": " ..  this.unknown2D0 .. ": " .. "\n",2)
	io.write("unknown2D4" .. ": " ..  this.unknown2D4 .. ": " .. "\n",2)
	io.write("unknown2D8" .. ": " ..  this.unknown2D8 .. ": " .. "\n",2)
	io.write("unknown2DC" .. ": " ..  this.unknown2DC .. ": " .. "\n",2)
	io.write("unknown2E0" .. ": " ..  this.unknown2E0 .. ": " .. "\n",2)
	io.write("unknown2E4" .. ": " ..  this.unknown2E4 .. ": " .. "\n",2)
	io.write("unknown2E8" .. ": " ..  this.unknown2E8 .. ": " .. "\n",2)
	io.write("unknown2EC" .. ": " ..  this.unknown2EC .. ": " .. "\n",2)
	io.write("unknown2F0" .. ": " ..  this.unknown2F0 .. ": " .. "\n",2)
	io.write("unknown2F4" .. ": " ..  this.unknown2F4 .. ": " .. "\n",2)
	io.write("unknown2F8" .. ": " ..  this.unknown2F8 .. ": " .. "\n",2)
	io.write("unknown2FC" .. ": " ..  this.unknown2FC .. ": " .. "\n",2)
	io.write("unknown300" .. ": " ..  this.unknown300 .. ": " .. "\n",2)
	io.write("unknown304" .. ": " ..  this.unknown304 .. ": " .. "\n",2)
	io.write("unknown308" .. ": " ..  this.unknown308 .. ": " .. "\n",2)
	io.write("unknown30C" .. ": " ..  this.unknown30C .. ": " .. "\n",2)
	io.write("unknown310" .. ": " ..  this.unknown310 .. ": " .. "\n",2)
	io.write("unknown314" .. ": " ..  this.unknown314 .. ": " .. "\n",2)
	io.write("unknown318" .. ": " ..  this.unknown318 .. ": " .. "\n",2)
	io.write("unknown31C" .. ": " ..  this.unknown31C .. ": " .. "\n",2)
	io.write("unknown320" .. ": " ..  this.unknown320 .. ": " .. "\n",2)
	io.write("unknown324" .. ": " ..  this.unknown324 .. ": " .. "\n",2)
	io.write("unknown328" .. ": " ..  this.unknown328 .. ": " .. "\n",2)
	io.write("unknown32C" .. ": " ..  this.unknown32C .. ": " .. "\n",2)
	io.write("unknown330" .. ": " ..  this.unknown330 .. ": " .. "\n",2)
	io.write("unknown334" .. ": " ..  this.unknown334 .. ": " .. "\n",2)
	io.write("unknown338" .. ": " ..  this.unknown338 .. ": " .. "\n",2)
	io.write("unknown33C" .. ": " ..  this.unknown33C .. ": " .. "\n",2)
	io.write("unknown340" .. ": " ..  this.unknown340 .. ": " .. "\n",2)
	io.write("unknown344" .. ": " ..  this.unknown344 .. ": " .. "\n",2)
	io.write("unknown348" .. ": " ..  this.unknown348 .. ": " .. "\n",2)
	io.write("unknown34C" .. ": " ..  this.unknown34C .. ": " .. "\n",2)
	io.write("unknown350" .. ": " ..  this.unknown350 .. ": " .. "\n",2)
	io.write("unknown354" .. ": " ..  this.unknown354 .. ": " .. "\n",2)
	io.write("unknown358" .. ": " ..  this.unknown358 .. ": " .. "\n",2)
	io.write("unknown35C" .. ": " ..  this.unknown35C .. ": " .. "\n",2)
	io.write("unknown360" .. ": " ..  this.unknown360 .. ": " .. "\n",2)
	io.write("unknown364" .. ": " ..  this.unknown364 .. ": " .. "\n",2)
	io.write("unknown368" .. ": " ..  this.unknown368 .. ": " .. "\n",2)
	io.write("unknown36C" .. ": " ..  this.unknown36C .. ": " .. "\n",2)
	io.write("unknown370" .. ": " ..  this.unknown370 .. ": " .. "\n",2)
	io.write("unknown374" .. ": " ..  this.unknown374 .. ": " .. "\n",2)
	io.write("unknown378" .. ": " ..  this.unknown378 .. ": " .. "\n",2)
	io.write("unknown37C" .. ": " ..  this.unknown37C .. ": " .. "\n",2)
	io.write("unknown380" .. ": " ..  this.unknown380 .. ": " .. "\n",2)
	io.write("unknown384" .. ": " ..  this.unknown384 .. ": " .. "\n",2)
	io.write("unknown388" .. ": " ..  this.unknown388 .. ": " .. "\n",2)
	io.write("unknown38C" .. ": " ..  this.unknown38C .. ": " .. "\n",2)
	io.write("unknown390" .. ": " ..  this.unknown390 .. ": " .. "\n",2)
	io.write("unknown394" .. ": " ..  this.unknown394 .. ": " .. "\n",2)
	io.write("unknown398" .. ": " ..  this.unknown398 .. ": " .. "\n",2)
	io.write("unknown39C" .. ": " ..  this.unknown39C .. ": " .. "\n",2)
	io.write("unknown3A0" .. ": " ..  this.unknown3A0 .. ": " .. "\n",2)
	io.write("unknown3A4" .. ": " ..  this.unknown3A4 .. ": " .. "\n",2)
	io.write("unknown3A8" .. ": " ..  this.unknown3A8 .. ": " .. "\n",2)
	io.write("unknown3AC" .. ": " ..  this.unknown3AC .. ": " .. "\n",2)
	io.write("unknown3B0" .. ": " ..  this.unknown3B0 .. ": " .. "\n",2)
	io.write("unknown3B4" .. ": " ..  this.unknown3B4 .. ": " .. "\n",2)
	io.write("unknown3B8" .. ": " ..  this.unknown3B8 .. ": " .. "\n",2)
	io.write("unknown3BC" .. ": " ..  this.unknown3BC .. ": " .. "\n",2)
	io.write("unknown3C0" .. ": " ..  this.unknown3C0 .. ": " .. "\n",2)
	io.write("unknown3C4" .. ": " ..  this.unknown3C4 .. ": " .. "\n",2)
	io.write("unknown3C8" .. ": " ..  this.unknown3C8 .. ": " .. "\n",2)
	io.write("unknown3CC" .. ": " ..  this.unknown3CC .. ": " .. "\n",2)
	io.write("unknown3D0" .. ": " ..  this.unknown3D0 .. ": " .. "\n",2)
	io.write("unknown3D4" .. ": " ..  this.unknown3D4 .. ": " .. "\n",2)
	io.write("unknown3D8" .. ": " ..  this.unknown3D8 .. ": " .. "\n",2)
	io.write("unknown3DC" .. ": " ..  this.unknown3DC .. ": " .. "\n",2)
	io.write("unknown3E0" .. ": " ..  this.unknown3E0 .. ": " .. "\n",2)
	io.write("unknown3E4" .. ": " ..  this.unknown3E4 .. ": " .. "\n",2)
	io.write("unknown3E8" .. ": " ..  this.unknown3E8 .. ": " .. "\n",2)
	io.write("unknown3EC" .. ": " ..  this.unknown3EC .. ": " .. "\n",2)
	io.write("unknown3F0" .. ": " ..  this.unknown3F0 .. ": " .. "\n",2)
	io.write("unknown3F4" .. ": " ..  this.unknown3F4 .. ": " .. "\n",2)
	io.write("unknown3F8" .. ": " ..  this.unknown3F8 .. ": " .. "\n",2)
	io.write("unknown3FC" .. ": " ..  this.unknown3FC .. ": " .. "\n",2)
	io.write("unknown400" .. ": " ..  this.unknown400 .. ": " .. "\n",2)
	io.write("unknown404" .. ": " ..  this.unknown404 .. ": " .. "\n",2)
	io.write("unknown408" .. ": " ..  this.unknown408 .. ": " .. "\n",2)
	io.write("unknown40C" .. ": " ..  this.unknown40C .. ": " .. "\n",2)
	io.write("unknown410" .. ": " ..  this.unknown410 .. ": " .. "\n",2)
	io.write("unknown414" .. ": " ..  this.unknown414 .. ": " .. "\n",2)
	io.write("unknown418" .. ": " ..  this.unknown418 .. ": " .. "\n",2)
	io.write("unknown41C" .. ": " ..  this.unknown41C .. ": " .. "\n",2)
	io.write("unknown420" .. ": " ..  this.unknown420 .. ": " .. "\n",2)
	io.write("unknown424" .. ": " ..  this.unknown424 .. ": " .. "\n",2)
	io.write("unknown428" .. ": " ..  this.unknown428 .. ": " .. "\n",2)
	io.write("unknown42C" .. ": " ..  this.unknown42C .. ": " .. "\n",2)
	io.write("unknown430" .. ": " ..  this.unknown430 .. ": " .. "\n",2)
	io.write("unknown434" .. ": " ..  this.unknown434 .. ": " .. "\n",2)
	io.write("unknown438" .. ": " ..  this.unknown438 .. ": " .. "\n",2)
	io.write("unknown43C" .. ": " ..  this.unknown43C .. ": " .. "\n",2)
	io.write("unknown440" .. ": " ..  this.unknown440 .. ": " .. "\n",2)
	io.write("unknown444" .. ": " ..  this.unknown444 .. ": " .. "\n",2)
	io.write("unknown448" .. ": " ..  this.unknown448 .. ": " .. "\n",2)
	io.write("unknown44C" .. ": " ..  this.unknown44C .. ": " .. "\n",2)
	io.write("unknown450" .. ": " ..  this.unknown450 .. ": " .. "\n",2)
	io.write("unknown454" .. ": " ..  this.unknown454 .. ": " .. "\n",2)
	io.write("unknown458" .. ": " ..  this.unknown458 .. ": " .. "\n",2)
	io.write("unknown45C" .. ": " ..  this.unknown45C .. ": " .. "\n",2)

end



function PrintAirstrike(this)
	io.write("---AIRSTRIKE--\n",2)
	io.write("unknown30" .. ": " ..  this.unknown30.. ": " .. "\n",2)
	io.write("unknown34" .. ": " ..  this.unknown34.. ": " .. "\n",2)
	io.write("unknown38" .. ": " ..  this.unknown38.. ": " .. "\n",2)
	io.write("unknown3C" .. ": " ..  this.unknown3C.. ": " .. "\n",2)
	io.write("unknown40" .. ": " ..  this.unknown40.. ": " .. "\n",2)
	io.write("unknown44" .. ": " ..  this.unknown44.. ": " .. "\n",2)
	io.write("unknown48" .. ": " ..  this.unknown48.. ": " .. "\n",2)
	io.write("unknown4C" .. ": " ..  this.unknown4C.. ": " .. "\n",2)
	io.write("unknown50" .. ": " ..  this.unknown50.. ": " .. "\n",2)
	io.write("unknown54" .. ": " ..  this.unknown54.. ": " .. "\n",2)
	io.write("unknown58" .. ": " ..  this.unknown58.. ": " .. "\n",2)
	io.write("unknown5C" .. ": " ..  this.unknown5C.. ": " .. "\n",2)
	io.write("unknown60" .. ": " ..  this.unknown60.. ": " .. "\n",2)
	io.write("unknown64" .. ": " ..  this.unknown64.. ": " .. "\n",2)
	io.write("unknown68" .. ": " ..  this.unknown68.. ": " .. "\n",2)
	io.write("unknown6C" .. ": " ..  this.unknown6C.. ": " .. "\n",2)
	io.write("unknown70" .. ": " ..  this.unknown70.. ": " .. "\n",2)
	io.write("unknown74" .. ": " ..  this.unknown74.. ": " .. "\n",2)
	io.write("unknown78" .. ": " ..  this.unknown78.. ": " .. "\n",2)
	io.write("unknown7C" .. ": " ..  this.unknown7C.. ": " .. "\n",2)
	io.write("unknown80" .. ": " ..  this.unknown80.. ": " .. "\n",2)
	io.write("unknown84" .. ": " ..  this.unknown84.. ": " .. "\n",2)
	io.write("unknown88" .. ": " ..  this.unknown88.. ": " .. "\n",2)
	io.write("unknown8C" .. ": " ..  this.unknown8C.. ": " .. "\n",2)
	io.write("unknown90" .. ": " ..  this.unknown90.. ": " .. "\n",2)
	io.write("unknown94" .. ": " ..  this.unknown94.. ": " .. "\n",2)
	io.write("unknown98" .. ": " ..  this.unknown98.. ": " .. "\n",2)
	io.write("unknown9C" .. ": " ..  this.unknown9C.. ": " .. "\n",2)
	io.write("unknownA0" .. ": " ..  this.unknownA0.. ": " .. "\n",2)
	io.write("unknownA4" .. ": " ..  this.unknownA4.. ": " .. "\n",2)
	io.write("unknownA8" .. ": " ..  this.unknownA8.. ": " .. "\n",2)
	io.write("unknownAC" .. ": " ..  this.unknownAC.. ": " .. "\n",2)
	io.write("unknownB0" .. ": " ..  this.unknownB0.. ": " .. "\n",2)
	io.write("unknownB4" .. ": " ..  this.unknownB4.. ": " .. "\n",2)
	io.write("unknownB8" .. ": " ..  this.unknownB8.. ": " .. "\n",2)
	io.write("unknownBC" .. ": " ..  this.unknownBC.. ": " .. "\n",2)
	io.write("unknownC0" .. ": " ..  this.unknownC0.. ": " .. "\n",2)
	io.write("unknownC4" .. ": " ..  this.unknownC4.. ": " .. "\n",2)
	io.write("unknownC8" .. ": " ..  this.unknownC8.. ": " .. "\n",2)
	io.write("unknownCC" .. ": " ..  this.unknownCC.. ": " .. "\n",2)
	io.write("unknownD0" .. ": " ..  this.unknownD0.. ": " .. "\n",2)
	io.write("unknownD4" .. ": " ..  this.unknownD4.. ": " .. "\n",2)
	io.write("unknownD8" .. ": " ..  this.unknownD8.. ": " .. "\n",2)
	io.write("unknownDC" .. ": " ..  this.unknownDC.. ": " .. "\n",2)
	io.write("unknownE0" .. ": " ..  this.unknownE0.. ": " .. "\n",2)
	io.write("unknownE4" .. ": " ..  this.unknownE4.. ": " .. "\n",2)
	io.write("unknownE8" .. ": " ..  this.unknownE8.. ": " .. "\n",2)
	io.write("unknownEC" .. ": " ..  this.unknownEC.. ": " .. "\n",2)
	io.write("unknownF0" .. ": " ..  this.unknownF0.. ": " .. "\n",2)
	io.write("unknownF4" .. ": " ..  this.unknownF4.. ": " .. "\n",2)
	io.write("unknownF8" .. ": " ..  this.unknownF8.. ": " .. "\n",2)
	io.write("unknownFC" .. ": " ..  this.unknownFC.. ": " .. "\n",2)
	io.write("unknown100" .. ": " ..  this.unknown100.. ": " .. "\n",2)
	io.write("unknown104" .. ": " ..  this.unknown104.. ": " .. "\n",2)
	io.write("unknown108" .. ": " ..  this.unknown108.. ": " .. "\n",2)
	io.write("unknown10C" .. ": " ..  this.unknown10C.. ": " .. "\n",2)
	io.write("unknown110" .. ": " ..  this.unknown110.. ": " .. "\n",2)
	io.write("unknown114" .. ": " ..  this.unknown114.. ": " .. "\n",2)
	io.write("unknown118" .. ": " ..  this.unknown118.. ": " .. "\n",2)
	io.write("unknown11C" .. ": " ..  this.unknown11C.. ": " .. "\n",2)
	io.write("unknown120" .. ": " ..  this.unknown120.. ": " .. "\n",2)
	io.write("unknown124" .. ": " ..  this.unknown124.. ": " .. "\n",2)
	io.write("unknown128" .. ": " ..  this.unknown128.. ": " .. "\n",2)
	io.write("unknown12C" .. ": " ..  this.unknown12C.. ": " .. "\n",2)
	io.write("unknown130" .. ": " ..  this.unknown130.. ": " .. "\n",2)
	io.write("unknown134" .. ": " ..  this.unknown134.. ": " .. "\n",2)
	io.write("unknown138" .. ": " ..  this.unknown138.. ": " .. "\n",2)
	io.write("unknown13C" .. ": " ..  this.unknown13C.. ": " .. "\n",2)
	io.write("unknown140" .. ": " ..  this.unknown140.. ": " .. "\n",2)
	io.write("unknown144" .. ": " ..  this.unknown144.. ": " .. "\n",2)
	io.write("unknown148" .. ": " ..  this.unknown148.. ": " .. "\n",2)
	io.write("unknown14C" .. ": " ..  this.unknown14C.. ": " .. "\n",2)
	io.write("unknown150" .. ": " ..  this.unknown150.. ": " .. "\n",2)
	io.write("unknown154" .. ": " ..  this.unknown154.. ": " .. "\n",2)
	io.write("unknown158" .. ": " ..  this.unknown158.. ": " .. "\n",2)
	io.write("unknown15C" .. ": " ..  this.unknown15C.. ": " .. "\n",2)
	io.write("unknown160" .. ": " ..  this.unknown160.. ": " .. "\n",2)
	io.write("unknown164" .. ": " ..  this.unknown164.. ": " .. "\n",2)
	io.write("unknown168" .. ": " ..  this.unknown168.. ": " .. "\n",2)
	io.write("unknown16C" .. ": " ..  this.unknown16C.. ": " .. "\n",2)
	io.write("unknown170" .. ": " ..  this.unknown170.. ": " .. "\n",2)
	io.write("unknown174" .. ": " ..  this.unknown174.. ": " .. "\n",2)
	io.write("unknown178" .. ": " ..  this.unknown178.. ": " .. "\n",2)
	io.write("unknown17C" .. ": " ..  this.unknown17C.. ": " .. "\n",2)
	io.write("unknown180" .. ": " ..  this.unknown180.. ": " .. "\n",2)
	io.write("unknown184" .. ": " ..  this.unknown184.. ": " .. "\n",2)
	io.write("unknown188" .. ": " ..  this.unknown188.. ": " .. "\n",2)
	io.write("unknown18C" .. ": " ..  this.unknown18C.. ": " .. "\n",2)
	io.write("unknown190" .. ": " ..  this.unknown190.. ": " .. "\n",2)
	io.write("unknown194" .. ": " ..  this.unknown194.. ": " .. "\n",2)
	io.write("unknown198" .. ": " ..  this.unknown198.. ": " .. "\n",2)
	io.write("unknown19C" .. ": " ..  this.unknown19C.. ": " .. "\n",2)
	io.write("unknown1A0" .. ": " ..  this.unknown1A0.. ": " .. "\n",2)
	io.write("unknown1A4" .. ": " ..  this.unknown1A4.. ": " .. "\n",2)
	io.write("unknown1A8" .. ": " ..  this.unknown1A8.. ": " .. "\n",2)
	io.write("unknown1AC" .. ": " ..  this.unknown1AC.. ": " .. "\n",2)
	io.write("unknown1B0" .. ": " ..  this.unknown1B0.. ": " .. "\n",2)
	io.write("unknown1B4" .. ": " ..  this.unknown1B4.. ": " .. "\n",2)
	io.write("unknown1B8" .. ": " ..  this.unknown1B8.. ": " .. "\n",2)
	io.write("unknown1BC" .. ": " ..  this.unknown1BC.. ": " .. "\n",2)
	io.write("unknown1C0" .. ": " ..  this.unknown1C0.. ": " .. "\n",2)
	io.write("unknown1C4" .. ": " ..  this.unknown1C4.. ": " .. "\n",2)
	io.write("unknown1C8" .. ": " ..  this.unknown1C8.. ": " .. "\n",2)
	io.write("unknown1CC" .. ": " ..  this.unknown1CC.. ": " .. "\n",2)
	io.write("unknown1D0" .. ": " ..  this.unknown1D0.. ": " .. "\n",2)
	io.write("unknown1D4" .. ": " ..  this.unknown1D4.. ": " .. "\n",2)
	io.write("unknown1D8" .. ": " ..  this.unknown1D8.. ": " .. "\n",2)
	io.write("unknown1DC" .. ": " ..  this.unknown1DC.. ": " .. "\n",2)
	io.write("unknown1E0" .. ": " ..  this.unknown1E0.. ": " .. "\n",2)
	io.write("unknown1E4" .. ": " ..  this.unknown1E4.. ": " .. "\n",2)
	io.write("unknown1E8" .. ": " ..  this.unknown1E8.. ": " .. "\n",2)
	io.write("unknown1EC" .. ": " ..  this.unknown1EC.. ": " .. "\n",2)
	io.write("unknown1F0" .. ": " ..  this.unknown1F0.. ": " .. "\n",2)
	io.write("unknown1F4" .. ": " ..  this.unknown1F4.. ": " .. "\n",2)
	io.write("unknown1F8" .. ": " ..  this.unknown1F8.. ": " .. "\n",2)
	io.write("unknown1FC" .. ": " ..  this.unknown1FC.. ": " .. "\n",2)
	io.write("unknown200" .. ": " ..  this.unknown200.. ": " .. "\n",2)
	io.write("unknown204" .. ": " ..  this.unknown204.. ": " .. "\n",2)
	io.write("unknown208" .. ": " ..  this.unknown208.. ": " .. "\n",2)
	io.write("unknown20C" .. ": " ..  this.unknown20C.. ": " .. "\n",2)
	io.write("unknown210" .. ": " ..  this.unknown210.. ": " .. "\n",2)
	io.write("unknown214" .. ": " ..  this.unknown214.. ": " .. "\n",2)
	io.write("unknown218" .. ": " ..  this.unknown218.. ": " .. "\n",2)
	io.write("unknown21C" .. ": " ..  this.unknown21C.. ": " .. "\n",2)
	io.write("unknown220" .. ": " ..  this.unknown220.. ": " .. "\n",2)
	io.write("unknown224" .. ": " ..  this.unknown224.. ": " .. "\n",2)
	io.write("unknown228" .. ": " ..  this.unknown228.. ": " .. "\n",2)
	io.write("unknown22C" .. ": " ..  this.unknown22C.. ": " .. "\n",2)
	io.write("unknown230" .. ": " ..  this.unknown230.. ": " .. "\n",2)
	io.write("unknown234" .. ": " ..  this.unknown234.. ": " .. "\n",2)
	

end	
function PrintWeaponLaunchParams(this)
	io.write("---WEAPONLAUNCHPARAMS--\n",2)
	io.write("unknown0" ..  "= " ..  this.unknown0 .. ": " .. "\n",2)
	io.write("unknown4" ..  "= " ..  this.unknown4 .. ": " .. "\n",2)
	io.write("unknown8" ..  "= " ..  this.unknown8 .. ": " .. "\n",2)
	io.write("unknownC" ..  "= " ..  this.unknownC .. ": " .. "\n",2)
	io.write("unknown10" ..  "= " ..  this.unknown10 .. ": " .. "\n",2)
	io.write("unknown14" ..  "= " ..  this.unknown14 .. ": " .. "\n",2)
	io.write("unknown18" ..  "= " ..  this.unknown18 .. ": " .. "\n",2)
	io.write("unknown1C" ..  "= " ..  this.unknown1C .. ": " .. "\n",2)
	io.write("unknown20" ..  "= " ..  this.unknown20 .. ": " .. "\n",2)
	io.write("unknown24" ..  "= " ..  this.unknown24 .. ": " .. "\n",2)
	io.write("unknown28" ..  "= " ..  this.unknown28 .. ": " .. "\n",2)
	
end
function PrintWeaponProjParams(this)
	io.write("---WEAPONPROJPARAMS--\n",2)
	io.write("unknown0" ..  "= " ..  this.unknown0 .. "; " .. "\n")
	io.write("unknown4" ..  "= " ..  this.unknown4 .. "; " .. "\n")
	io.write("unknown8" ..  "= " ..  this.unknown8 .. "; " .. "\n")
	io.write("unknownC" ..  "= " ..  this.unknownC .. "; " .. "\n")
	io.write("unknown10" .. "= " ..  this.unknown10.. "; " .. "\n")
	io.write("unknown14" .. "= " ..  this.unknown14.. "; " .. "\n")
	io.write("unknown18" .. "= " ..  this.unknown18.. "; " .. "\n")
	io.write("unknown1C" .. "= " ..  this.unknown1C.. "; " .. "\n")
	io.write("unknown20" .. "= " ..  this.unknown20.. "; " .. "\n")
	io.write("unknown24" .. "= " ..  this.unknown24.. "; " .. "\n")
	io.write("unknown28" .. "= " ..  this.unknown28.. "; " .. "\n")
	io.write("unknown2C" .. "= " ..  this.unknown2C.. "; " .. "\n")
	io.write("unknown30" .. "= " ..  this.unknown30.. "; " .. "\n")
	io.write("unknown34" .. "= " ..  this.unknown34.. "; " .. "\n")
	io.write("unknown38" .. "= " ..  this.unknown38.. "; " .. "\n")
	io.write("unknown3C" .. "= " ..  this.unknown3C.. "; " .. "\n")
	io.write("unknown40" .. "= " ..  this.unknown40.. "; " .. "\n")
	io.write("unknown44" .. "= " ..  this.unknown44.. "; " .. "\n")
	io.write("unknown48" .. "= " ..  this.unknown48.. "; " .. "\n")
	io.write("unknown4C" .. "= " ..  this.unknown4C.. "; " .. "\n")
	io.write("unknown50" .. "= " ..  this.unknown50.. "; " .. "\n")
	io.write("unknown54" .. "= " ..  this.unknown54.. "; " .. "\n")
	io.write("unknown58" .. "= " ..  this.unknown58.. "; " .. "\n")
	io.write("unknown5C" .. "= " ..  this.unknown5C.. "; " .. "\n")
	io.write("unknown60" .. "= " ..  this.unknown60.. "; " .. "\n")
	io.write("unknown64" .. "= " ..  this.unknown64.. "; " .. "\n")
	io.write("unknown68" .. "= " ..  this.unknown68.. "; " .. "\n")
	io.write("unknown6C" .. "= " ..  this.unknown6C.. "; " .. "\n")
	io.write("unknown70" .. "= " ..  this.unknown70.. "; " .. "\n")
	io.write("unknown74" .. "= " ..  this.unknown74.. "; " .. "\n")
	io.write("unknown78" .. "= " ..  this.unknown78.. "; " .. "\n")
	io.write("unknown7C" .. "= " ..  this.unknown7C.. "; " .. "\n")
	io.write("unknown80" .. "= " ..  this.unknown80.. "; " .. "\n")
	io.write("unknown84" .. "= " ..  this.unknown84.. "; " .. "\n")
	io.write("unknown88" .. "= " ..  this.unknown88.. "; " .. "\n")
	io.write("unknown8C" .. "= " ..  this.unknown8C.. "; " .. "\n")
	io.write("unknown90" .. "= " ..  this.unknown90.. "; " .. "\n")
	io.write("unknown94" .. "= " ..  this.unknown94.. "; " .. "\n")
	io.write("unknown98" .. "= " ..  this.unknown98.. "; " .. "\n")
	io.write("unknown9C" .. "= " ..  this.unknown9C.. "; " .. "\n")
	io.write("unknownA0" .. "= " ..  this.unknownA0.. "; " .. "\n")
	io.write("unknownA4" .. "= " ..  this.unknownA4.. "; " .. "\n")
	io.write("unknownA8" .. "= " ..  this.unknownA8.. "; " .. "\n")
	io.write("unknownAC" .. "= " ..  this.unknownAC.. "; " .. "\n")
	io.write("unknownB0" .. "= " ..  this.unknownB0.. "; " .. "\n")
	io.write("unknownB4" .. "= " ..  this.unknownB4.. "; " .. "\n")
	io.write("unknownB8" .. "= " ..  this.unknownB8.. "; " .. "\n")
	io.write("unknownBC" .. "= " ..  this.unknownBC.. "; " .. "\n")
	io.write("unknownC0" .. "= " ..  this.unknownC0.. "; " .. "\n")
	io.write("unknownC4" .. "= " ..  this.unknownC4.. "; " .. "\n")
	io.write("unknownC8" .. "= " ..  this.unknownC8.. "; " .. "\n")
	io.write("unknownCC" .. "= " ..  this.unknownCC.. "; " .. "\n")
	io.write("unknownD0" .. "= " ..  this.unknownD0.. "; " .. "\n")
	io.write("unknownD4" .. "= " ..  this.unknownD4.. "; " .. "\n")
	io.write("unknownD8" .. "= " ..  this.unknownD8.. "; " .. "\n")
	io.write("unknownDC" .. "= " ..  this.unknownDC.. "; " .. "\n")
	io.write("unknownE0" .. "= " ..  this.unknownE0.. "; " .. "\n")
	io.write("unknownE4" .. "= " ..  this.unknownE4.. "; " .. "\n")
	io.write("unknownE8" .. "= " ..  this.unknownE8.. "; " .. "\n")
	io.write("unknownEC" .. "= " ..  this.unknownEC.. "; " .. "\n")
	io.write("unknownF0" .. "= " ..  this.unknownF0.. "; " .. "\n")
	io.write("unknownF4" .. "= " ..  this.unknownF4.. "; " .. "\n")
	io.write("unknownF8" .. "= " ..  this.unknownF8.. "; " .. "\n")
	io.write("unknownFC" .. "= " ..  this.unknownFC.. "; " .. "\n")
	io.write("unknown100" .. "= " ..  this.unknown100.. "; " .. "\n")
	io.write("unknown104" .. "= " ..  this.unknown104.. "; " .. "\n")
	io.write("unknown108" .. "= " ..  this.unknown108.. "; " .. "\n")
	io.write("unknown10C" .. "= " ..  this.unknown10C.. "; " .. "\n")
	io.write("unknown110" .. "= " ..  this.unknown110.. "; " .. "\n")
	io.write("unknown114" .. "= " ..  this.unknown114.. "; " .. "\n")
	io.write("unknown118" .. "= " ..  this.unknown118.. "; " .. "\n")
	io.write("unknown11C" .. "= " ..  this.unknown11C.. "; " .. "\n")
	io.write("unknown120" .. "= " ..  this.unknown120.. "; " .. "\n")
	io.write("unknown124" .. "= " ..  this.unknown124.. "; " .. "\n")
	io.write("unknown128" .. "= " ..  this.unknown128.. "; " .. "\n")
	io.write("unknown12C" .. "= " ..  this.unknown12C.. "; " .. "\n")
	io.write("unknown130" .. "= " ..  this.unknown130.. "; " .. "\n")
	io.write("unknown134" .. "= " ..  this.unknown134.. "; " .. "\n")
	io.write("unknown138" .. "= " ..  this.unknown138.. "; " .. "\n")
	io.write("unknown13C" .. "= " ..  this.unknown13C.. "; " .. "\n")
	io.write("unknown140" .. "= " ..  this.unknown140.. "; " .. "\n")
	io.write("unknown144" .. "= " ..  this.unknown144.. "; " .. "\n")
	io.write("unknown148" .. "= " ..  this.unknown148.. "; " .. "\n")
	io.write("unknown14C" .. "= " ..  this.unknown14C.. "; " .. "\n")
	io.write("unknown150" .. "= " ..  this.unknown150.. "; " .. "\n")
	io.write("unknown154" .. "= " ..  this.unknown154.. "; " .. "\n")
	io.write("unknown158" .. "= " ..  this.unknown158.. "; " .. "\n")
	io.write("unknown15C" .. "= " ..  this.unknown15C.. "; " .. "\n")
	io.write("unknown160" .. "= " ..  this.unknown160.. "; " .. "\n")
	io.write("unknown164" .. "= " ..  this.unknown164.. "; " .. "\n")
	io.write("unknown168" .. "= " ..  this.unknown168.. "; " .. "\n")
	io.write("unknown16C" .. "= " ..  this.unknown16C.. "; " .. "\n")
	io.write("unknown170" .. "= " ..  this.unknown170.. "; " .. "\n")
	io.write("unknown174" .. "= " ..  this.unknown174.. "; " .. "\n")
end
function PrintWeaponParams(this)
	io.write("---WEAPONPARAMS--\n",2)
	io.write("unknown0" .. ": " ..  this.unknown0.. ": " .. "\n",2)
	io.write("unknown4" .. ": " ..  this.unknown4.. ": " .. "\n",2)
	io.write("unknown8" .. ": " ..  this.unknown8.. ": " .. "\n",2)
	io.write("unknownC" .. ": " ..  this.unknownC.. ": " .. "\n",2)
	io.write("unknown10" .. ": " ..  this.unknown10.. ": " .. "\n",2)
	io.write("unknown14" .. ": " ..  this.unknown14.. ": " .. "\n",2)
	io.write("posx" .. ": " ..  this.unknown18.. ": " .. "\n",2)
	io.write("unknown1C" .. ": " ..  this.unknown1C.. ": " .. "\n",2)
	io.write("unknown20" .. ": " ..  this.unknown20.. ": " .. "\n",2)
	io.write("unknown24" .. ": " ..  this.unknown24.. ": " .. "\n",2)
	io.write("unknown28" .. ": " ..  this.unknown28.. ": " .. "\n",2)
	
end
	
	function PrintWeapon(this)
	io.write("---WEAPON--\n",2)
	io.write("name1" .. ": " ..  this.name1.. ": " .. "\n",2)
	io.write("name2" .. ": " ..  this.name2.. ": " .. "\n",2)
	io.write("panelRow" .. ": " ..  this.panelRow .. ": " .. "\n",2)
	io.write("unknownC" .. ": " ..  this.unknownC .. ": " .. "\n",2)
	io.write("unknown10" .. ": " ..  this.unknown10.. ": " .. "\n",2)
	io.write("unknown14" .. ": " ..  this.unknown14.. ": " .. "\n",2)
	io.write("unknown18" .. ": " ..  this.unknown18.. ": " .. "\n",2)
	io.write("unknown1C" .. ": " ..  this.unknown1C.. ": " .. "\n",2)
	io.write("unknown20" .. ": " ..  this.unknown20.. ": " .. "\n",2)
	io.write("unknown24" .. ": " ..  this.unknown24.. ": " .. "\n",2)
	io.write("unknown28" .. ": " ..  this.unknown28.. ": " .. "\n",2)
	io.write("unknown2C" .. ": " ..  this.unknown2C.. ": " .. "\n",2)
	io.write("unknown30" .. ": " ..  this.unknown30.. ": " .. "\n",2)
	io.write("unknown34" .. ": " ..  this.unknown34.. ": " .. "\n",2)
	io.write("unknown38" .. ": " ..  this.unknown38.. ": " .. "\n",2)
	io.write("unknown3C" .. ": " ..  this.unknown3C.. ": " .. "\n",2)
	io.write("unknown40" .. ": " ..  this.unknown40.. ": " .. "\n",2)
	io.write("unknown44" .. ": " ..  this.unknown44.. ": " .. "\n",2)
	io.write("unknown48" .. ": " ..  this.unknown48.. ": " .. "\n",2)
	io.write("unknown4C" .. ": " ..  this.unknown4C.. ": " .. "\n",2)
	io.write("unknown50" .. ": " ..  this.unknown50.. ": " .. "\n",2)
	io.write("unknown54" .. ": " ..  this.unknown54.. ": " .. "\n",2)
	io.write("unknown58" .. ": " ..  this.unknown58.. ": " .. "\n",2)
	io.write("unknown5C" .. ": " ..  this.unknown5C.. ": " .. "\n",2)
	io.write("unknown60" .. ": " ..  this.unknown60.. ": " .. "\n",2)
	io.write("unknown64" .. ": " ..  this.unknown64.. ": " .. "\n",2)
	io.write("unknown68" .. ": " ..  this.unknown68.. ": " .. "\n",2)
	io.write("unknown6C" .. ": " ..  this.unknown6C.. ": " .. "\n",2)
	io.write("unknown70" .. ": " ..  this.unknown70.. ": " .. "\n",2)
	io.write("unknown74" .. ": " ..  this.unknown74.. ": " .. "\n",2)
	io.write("unknown78" .. ": " ..  this.unknown78.. ": " .. "\n",2)
	io.write("unknown7C" .. ": " ..  this.unknown7C.. ": " .. "\n",2)
	io.write("unknown80" .. ": " ..  this.unknown80.. ": " .. "\n",2)
	io.write("unknown84" .. ": " ..  this.unknown84.. ": " .. "\n",2)
	io.write("unknown88" .. ": " ..  this.unknown88.. ": " .. "\n",2)
	io.write("unknown8C" .. ": " ..  this.unknown8C.. ": " .. "\n",2)
	io.write("unknown90" .. ": " ..  this.unknown90.. ": " .. "\n",2)
	io.write("unknown94" .. ": " ..  this.unknown94.. ": " .. "\n",2)
	io.write("unknown98" .. ": " ..  this.unknown98.. ": " .. "\n",2)
	io.write("unknown9C" .. ": " ..  this.unknown9C.. ": " .. "\n",2)
	io.write("unknownA0" .. ": " ..  this.unknownA0.. ": " .. "\n",2)
	io.write("unknownA4" .. ": " ..  this.unknownA4.. ": " .. "\n",2)
	io.write("unknownA8" .. ": " ..  this.unknownA8.. ": " .. "\n",2)
	io.write("unknownAC" .. ": " ..  this.unknownAC.. ": " .. "\n",2)
	io.write("unknownB0" .. ": " ..  this.unknownB0.. ": " .. "\n",2)
	io.write("unknownB4" .. ": " ..  this.unknownB4.. ": " .. "\n",2)
	io.write("unknownB8" .. ": " ..  this.unknownB8.. ": " .. "\n",2)
	io.write("unknownBC" .. ": " ..  this.unknownBC.. ": " .. "\n",2)
	io.write("unknownC0" .. ": " ..  this.unknownC0.. ": " .. "\n",2)
	io.write("unknownC4" .. ": " ..  this.unknownC4.. ": " .. "\n",2)
	io.write("unknownC8" .. ": " ..  this.unknownC8.. ": " .. "\n",2)
	io.write("unknownCC" .. ": " ..  this.unknownCC.. ": " .. "\n",2)
	io.write("unknownD0" .. ": " ..  this.unknownD0.. ": " .. "\n",2)
	io.write("unknownD4" .. ": " ..  this.unknownD4.. ": " .. "\n",2)
	io.write("unknownD8" .. ": " ..  this.unknownD8.. ": " .. "\n",2)
	io.write("unknownDC" .. ": " ..  this.unknownDC.. ": " .. "\n",2)
	io.write("unknownE0" .. ": " ..  this.unknownE0.. ": " .. "\n",2)
	io.write("unknownE4" .. ": " ..  this.unknownE4.. ": " .. "\n",2)
	io.write("unknownE8" .. ": " ..  this.unknownE8.. ": " .. "\n",2)
	io.write("unknownEC" .. ": " ..  this.unknownEC.. ": " .. "\n",2)
	io.write("unknownF0" .. ": " ..  this.unknownF0.. ": " .. "\n",2)
	io.write("unknownF4" .. ": " ..  this.unknownF4.. ": " .. "\n",2)
	io.write("unknownF8" .. ": " ..  this.unknownF8.. ": " .. "\n",2)
	io.write("unknownFC" .. ": " ..  this.unknownFC.. ": " .. "\n",2)
	io.write("unknown100" .. ": " ..  this.unknown100.. ": " .. "\n",2)
	io.write("unknown104" .. ": " ..  this.unknown104.. ": " .. "\n",2)
	io.write("unknown108" .. ": " ..  this.unknown108.. ": " .. "\n",2)
	io.write("unknown10C" .. ": " ..  this.unknown10C.. ": " .. "\n",2)
	io.write("unknown110" .. ": " ..  this.unknown110.. ": " .. "\n",2)
	io.write("unknown114" .. ": " ..  this.unknown114.. ": " .. "\n",2)
	io.write("unknown118" .. ": " ..  this.unknown118.. ": " .. "\n",2)
	io.write("unknown11C" .. ": " ..  this.unknown11C.. ": " .. "\n",2)
	io.write("unknown120" .. ": " ..  this.unknown120.. ": " .. "\n",2)
	io.write("unknown124" .. ": " ..  this.unknown124.. ": " .. "\n",2)
	io.write("unknown128" .. ": " ..  this.unknown128.. ": " .. "\n",2)
	io.write("unknown12C" .. ": " ..  this.unknown12C.. ": " .. "\n",2)
	io.write("unknown130" .. ": " ..  this.unknown130.. ": " .. "\n",2)
	io.write("unknown134" .. ": " ..  this.unknown134.. ": " .. "\n",2)
	io.write("unknown138" .. ": " ..  this.unknown138.. ": " .. "\n",2)
	io.write("unknown13C" .. ": " ..  this.unknown13C.. ": " .. "\n",2)
	io.write("unknown140" .. ": " ..  this.unknown140.. ": " .. "\n",2)
	io.write("unknown144" .. ": " ..  this.unknown144.. ": " .. "\n",2)
	io.write("unknown148" .. ": " ..  this.unknown148.. ": " .. "\n",2)
	io.write("unknown14C" .. ": " ..  this.unknown14C.. ": " .. "\n",2)
	io.write("unknown150" .. ": " ..  this.unknown150.. ": " .. "\n",2)
	io.write("unknown154" .. ": " ..  this.unknown154.. ": " .. "\n",2)
	io.write("unknown158" .. ": " ..  this.unknown158.. ": " .. "\n",2)
	io.write("unknown15C" .. ": " ..  this.unknown15C.. ": " .. "\n",2)
	io.write("unknown160" .. ": " ..  this.unknown160.. ": " .. "\n",2)
	io.write("unknown164" .. ": " ..  this.unknown164.. ": " .. "\n",2)
	io.write("unknown168" .. ": " ..  this.unknown168.. ": " .. "\n",2)
	io.write("unknown16C" .. ": " ..  this.unknown16C.. ": " .. "\n",2)
	io.write("unknown170" .. ": " ..  this.unknown170.. ": " .. "\n",2)
	io.write("unknown174" .. ": " ..  this.unknown174.. ": " .. "\n",2)
	io.write("unknown178" .. ": " ..  this.unknown178.. ": " .. "\n",2)
	io.write("unknown17C" .. ": " ..  this.unknown17C.. ": " .. "\n",2)
	io.write("unknown180" .. ": " ..  this.unknown180.. ": " .. "\n",2)
	io.write("unknown184" .. ": " ..  this.unknown184.. ": " .. "\n",2)
	io.write("unknown188" .. ": " ..  this.unknown188.. ": " .. "\n",2)
	io.write("unknown18C" .. ": " ..  this.unknown18C.. ": " .. "\n",2)
	io.write("unknown190" .. ": " ..  this.unknown190.. ": " .. "\n",2)
	io.write("unknown194" .. ": " ..  this.unknown194.. ": " .. "\n",2)
	io.write("unknown198" .. ": " ..  this.unknown198.. ": " .. "\n",2)
	io.write("unknown19C" .. ": " ..  this.unknown19C.. ": " .. "\n",2)
	io.write("unknown1A0" .. ": " ..  this.unknown1A0.. ": " .. "\n",2)
	io.write("unknown1A4" .. ": " ..  this.unknown1A4.. ": " .. "\n",2)
	io.write("unknown1A8" .. ": " ..  this.unknown1A8.. ": " .. "\n",2)
	io.write("unknown1AC" .. ": " ..  this.unknown1AC.. ": " .. "\n",2)
	io.write("unknown1B0" .. ": " ..  this.unknown1B0.. ": " .. "\n",2)
	io.write("unknown1B4" .. ": " ..  this.unknown1B4.. ": " .. "\n",2)
	io.write("unknown1B8" .. ": " ..  this.unknown1B8.. ": " .. "\n",2)
	io.write("unknown1BC" .. ": " ..  this.unknown1BC.. ": " .. "\n",2)
	io.write("unknown1C0" .. ": " ..  this.unknown1C0.. ": " .. "\n",2)
	io.write("unknown1C4" .. ": " ..  this.unknown1C4.. ": " .. "\n",2)
	io.write("unknown1C8" .. ": " ..  this.unknown1C8.. ": " .. "\n",2)
	io.write("unknown1CC" .. ": " ..  this.unknown1CC.. ": " .. "\n",2)
	
end

function PrintCrate(this)
	io.write("---CRATE--\n",2)
	io.write("unknownF0" .. ": " ..  this.unknownF0.. ": " .. "\n",2)
	io.write("unknownF4" .. ": " ..  this.unknownF4.. ": " .. "\n",2)
	io.write("unknownF8" .. ": " ..  this.unknownF8.. ": " .. "\n",2)
	io.write("unknownFC" .. ": " ..  this.unknownFC.. ": " .. "\n",2)
	io.write("unknown100" .. ": " ..  this.unknown100.. ": " .. "\n",2)
	io.write("unknown104" .. ": " ..  this.unknown104.. ": " .. "\n",2)
	io.write("unknown108" .. ": " ..  this.unknown108.. ": " .. "\n",2)
	io.write("unknown10C" .. ": " ..  this.unknown10C.. ": " .. "\n",2)
	io.write("unknown110" .. ": " ..  this.unknown110.. ": " .. "\n",2)
	io.write("unknown114" .. ": " ..  this.unknown114.. ": " .. "\n",2)
	io.write("unknown118" .. ": " ..  this.unknown118.. ": " .. "\n",2)
	io.write("unknown11C" .. ": " ..  this.unknown11C.. ": " .. "\n",2)
	io.write("unknown120" .. ": " ..  this.unknown120.. ": " .. "\n",2)
	io.write("unknown124" .. ": " ..  this.unknown124.. ": " .. "\n",2)
	io.write("cantweap" .. ": " ..  this.unknown128.. ": " .. "\n",2)
	io.write("WeaponId" .. ": " ..  this.unknown12C.. ": " .. "\n",2)
	io.write("unknown130" .. ": " ..  this.unknown130.. ": " .. "\n",2)
	io.write("unknown134" .. ": " ..  this.unknown134.. ": " .. "\n",2)
	io.write("unknown138" .. ": " ..  this.unknown138.. ": " .. "\n",2)
	io.write("unknown13C" .. ": " ..  this.unknown13C.. ": " .. "\n",2)
	io.write("unknown140" .. ": " ..  this.unknown140.. ": " .. "\n",2)
	io.write("unknown144" .. ": " ..  this.unknown144.. ": " .. "\n",2)
	io.write("unknown148" .. ": " ..  this.unknown148.. ": " .. "\n",2)
	io.write("unknown14C" .. ": " ..  this.unknown14C.. ": " .. "\n",2)
	io.write("unknown150" .. ": " ..  this.unknown150.. ": " .. "\n",2)
	io.write("unknown154" .. ": " ..  this.unknown154.. ": " .. "\n",2)
	io.write("unknown158" .. ": " ..  this.unknown158.. ": " .. "\n",2)
	io.write("unknown15C" .. ": " ..  this.unknown15C.. ": " .. "\n",2)
	io.write("unknown160" .. ": " ..  this.unknown160.. ": " .. "\n",2)
	io.write("unknown164" .. ": " ..  this.unknown164.. ": " .. "\n",2)
	io.write("unknown168" .. ": " ..  this.unknown168.. ": " .. "\n",2)
	io.write("unknown16C" .. ": " ..  this.unknown16C.. ": " .. "\n",2)
	io.write("unknown170" .. ": " ..  this.unknown170.. ": " .. "\n",2)
	io.write("unknown174" .. ": " ..  this.unknown174.. ": " .. "\n",2)
	io.write("unknown178" .. ": " ..  this.unknown178.. ": " .. "\n",2)
	io.write("unknown17C" .. ": " ..  this.unknown17C.. ": " .. "\n",2)
	io.write("unknown180" .. ": " ..  this.unknown180.. ": " .. "\n",2)
	io.write("unknown184" .. ": " ..  this.unknown184.. ": " .. "\n",2)
	io.write("unknown188" .. ": " ..  this.unknown188.. ": " .. "\n",2)
	io.write("unknown18C" .. ": " ..  this.unknown18C.. ": " .. "\n",2)
	io.write("unknown190" .. ": " ..  this.unknown190.. ": " .. "\n",2)
	io.write("unknown194" .. ": " ..  this.unknown194.. ": " .. "\n",2)
	io.write("unknown198" .. ": " ..  this.unknown198.. ": " .. "\n",2)
	io.write("unknown19C" .. ": " ..  this.unknown19C.. ": " .. "\n",2)
	io.write("unknown1A0" .. ": " ..  this.unknown1A0.. ": " .. "\n",2)
	io.write("unknown1A4" .. ": " ..  this.unknown1A4.. ": " .. "\n",2)
	io.write("unknown1A8" .. ": " ..  this.unknown1A8.. ": " .. "\n",2)
	io.write("unknown1AC" .. ": " ..  this.unknown1AC.. ": " .. "\n",2)
	io.write("unknown1B0" .. ": " ..  this.unknown1B0.. ": " .. "\n",2)
	io.write("unknown1B4" .. ": " ..  this.unknown1B4.. ": " .. "\n",2)
	io.write("unknown1B8" .. ": " ..  this.unknown1B8.. ": " .. "\n",2)
	io.write("unknown1BC" .. ": " ..  this.unknown1BC.. ": " .. "\n",2)
	io.write("unknown1C0" .. ": " ..  this.unknown1C0.. ": " .. "\n",2)
	io.write("unknown1C4" .. ": " ..  this.unknown1C4.. ": " .. "\n",2)
	io.write("unknown1C8" .. ": " ..  this.unknown1C8.. ": " .. "\n",2)
	io.write("unknown1CC" .. ": " ..  this.unknown1CC.. ": " .. "\n",2)
	io.write("unknown1D0" .. ": " ..  this.unknown1D0.. ": " .. "\n",2)
	io.write("unknown1D4" .. ": " ..  this.unknown1D4.. ": " .. "\n",2)
	io.write("unknown1D8" .. ": " ..  this.unknown1D8.. ": " .. "\n",2)
	io.write("unknown1DC" .. ": " ..  this.unknown1DC.. ": " .. "\n",2)
	io.write("unknown1E0" .. ": " ..  this.unknown1E0.. ": " .. "\n",2)
	io.write("unknown1E4" .. ": " ..  this.unknown1E4.. ": " .. "\n",2)
	io.write("unknown1E8" .. ": " ..  this.unknown1E8.. ": " .. "\n",2)
	io.write("unknown1EC" .. ": " ..  this.unknown1EC.. ": " .. "\n",2)
	io.write("unknown1F0" .. ": " ..  this.unknown1F0.. ": " .. "\n",2)
	io.write("unknown1F4" .. ": " ..  this.unknown1F4.. ": " .. "\n",2)
	io.write("unknown1F8" .. ": " ..  this.unknown1F8.. ": " .. "\n",2)
	io.write("unknown1FC" .. ": " ..  this.unknown1FC.. ": " .. "\n",2)
	io.write("unknown200" .. ": " ..  this.unknown200.. ": " .. "\n",2)
	io.write("unknown204" .. ": " ..  this.unknown204.. ": " .. "\n",2)
	io.write("unknown208" .. ": " ..  this.unknown208.. ": " .. "\n",2)
	io.write("unknown20C" .. ": " ..  this.unknown20C.. ": " .. "\n",2)
	io.write("unknown210" .. ": " ..  this.unknown210.. ": " .. "\n",2)
	io.write("unknown214" .. ": " ..  this.unknown214.. ": " .. "\n",2)
	io.write("unknown218" .. ": " ..  this.unknown218.. ": " .. "\n",2)
	io.write("unknown21C" .. ": " ..  this.unknown21C.. ": " .. "\n",2)
	io.write("unknown220" .. ": " ..  this.unknown220.. ": " .. "\n",2)
	io.write("unknown224" .. ": " ..  this.unknown224.. ": " .. "\n",2)
	io.write("unknown228" .. ": " ..  this.unknown228.. ": " .. "\n",2)
	io.write("unknown22C" .. ": " ..  this.unknown22C.. ": " .. "\n",2)
	io.write("unknown230" .. ": " ..  this.unknown230.. ": " .. "\n",2)
	io.write("unknown234" .. ": " ..  this.unknown234.. ": " .. "\n",2)
	io.write("unknown238" .. ": " ..  this.unknown238.. ": " .. "\n",2)
	io.write("unknown23C" .. ": " ..  this.unknown23C.. ": " .. "\n",2)
	io.write("unknown240" .. ": " ..  this.unknown240.. ": " .. "\n",2)
	io.write("unknown244" .. ": " ..  this.unknown244.. ": " .. "\n",2)
	io.write("unknown248" .. ": " ..  this.unknown248.. ": " .. "\n",2)
	io.write("unknown24C" .. ": " ..  this.unknown24C.. ": " .. "\n",2)
	io.write("unknown250" .. ": " ..  this.unknown250.. ": " .. "\n",2)
	io.write("unknown254" .. ": " ..  this.unknown254.. ": " .. "\n",2)
	io.write("unknown258" .. ": " ..  this.unknown258.. ": " .. "\n",2)
	io.write("unknown25C" .. ": " ..  this.unknown25C.. ": " .. "\n",2)
	io.write("unknown260" .. ": " ..  this.unknown260.. ": " .. "\n",2)
	io.write("unknown264" .. ": " ..  this.unknown264.. ": " .. "\n",2)
	io.write("unknown268" .. ": " ..  this.unknown268.. ": " .. "\n",2)
	io.write("unknown26C" .. ": " ..  this.unknown26C.. ": " .. "\n",2)
	io.write("unknown270" .. ": " ..  this.unknown270.. ": " .. "\n",2)
	io.write("unknown274" .. ": " ..  this.unknown274.. ": " .. "\n",2)
	io.write("unknown278" .. ": " ..  this.unknown278.. ": " .. "\n",2)
	io.write("unknown27C" .. ": " ..  this.unknown27C.. ": " .. "\n",2)
	io.write("unknown280" .. ": " ..  this.unknown280.. ": " .. "\n",2)
	io.write("unknown284" .. ": " ..  this.unknown284.. ": " .. "\n",2)
	io.write("unknown288" .. ": " ..  this.unknown288.. ": " .. "\n",2)
	io.write("unknown28C" .. ": " ..  this.unknown28C.. ": " .. "\n",2)
	io.write("unknown290" .. ": " ..  this.unknown290.. ": " .. "\n",2)
	io.write("unknown294" .. ": " ..  this.unknown294.. ": " .. "\n",2)
	io.write("unknown298" .. ": " ..  this.unknown298.. ": " .. "\n",2)
	io.write("unknown29C" .. ": " ..  this.unknown29C.. ": " .. "\n",2)
	io.write("unknown2A0" .. ": " ..  this.unknown2A0.. ": " .. "\n",2)
	io.write("unknown2A4" .. ": " ..  this.unknown2A4.. ": " .. "\n",2)
	io.write("unknown2A8" .. ": " ..  this.unknown2A8.. ": " .. "\n",2)
	io.write("unknown2AC" .. ": " ..  this.unknown2AC.. ": " .. "\n",2)
	io.write("unknown2B0" .. ": " ..  this.unknown2B0.. ": " .. "\n",2)
	io.write("unknown2B4" .. ": " ..  this.unknown2B4.. ": " .. "\n",2)
	io.write("unknown2B8" .. ": " ..  this.unknown2B8.. ": " .. "\n",2)
	io.write("unknown2BC" .. ": " ..  this.unknown2BC.. ": " .. "\n",2)
	io.write("unknown2C0" .. ": " ..  this.unknown2C0.. ": " .. "\n",2)
	io.write("unknown2C4" .. ": " ..  this.unknown2C4.. ": " .. "\n",2)
	io.write("unknown2C8" .. ": " ..  this.unknown2C8.. ": " .. "\n",2)
	io.write("unknown2CC" .. ": " ..  this.unknown2CC.. ": " .. "\n",2)
	io.write("unknown2D0" .. ": " ..  this.unknown2D0.. ": " .. "\n",2)
	io.write("unknown2D4" .. ": " ..  this.unknown2D4.. ": " .. "\n",2)
	io.write("unknown2D8" .. ": " ..  this.unknown2D8.. ": " .. "\n",2)
	io.write("unknown2DC" .. ": " ..  this.unknown2DC.. ": " .. "\n",2)
	io.write("unknown2E0" .. ": " ..  this.unknown2E0.. ": " .. "\n",2)
	io.write("unknown2E4" .. ": " ..  this.unknown2E4.. ": " .. "\n",2)
	io.write("unknown2E8" .. ": " ..  this.unknown2E8.. ": " .. "\n",2)
	io.write("unknown2EC" .. ": " ..  this.unknown2EC.. ": " .. "\n",2)
	io.write("unknown2F0" .. ": " ..  this.unknown2F0.. ": " .. "\n",2)
	io.write("unknown2F4" .. ": " ..  this.unknown2F4.. ": " .. "\n",2)
	io.write("unknown2F8" .. ": " ..  this.unknown2F8.. ": " .. "\n",2)
	io.write("unknown2FC" .. ": " ..  this.unknown2FC.. ": " .. "\n",2)
	io.write("unknown300" .. ": " ..  this.unknown300.. ": " .. "\n",2)
	io.write("unknown304" .. ": " ..  this.unknown304.. ": " .. "\n",2)
	io.write("unknown308" .. ": " ..  this.unknown308.. ": " .. "\n",2)
	io.write("unknown30C" .. ": " ..  this.unknown30C.. ": " .. "\n",2)
	io.write("unknown310" .. ": " ..  this.unknown310.. ": " .. "\n",2)
	io.write("unknown314" .. ": " ..  this.unknown314.. ": " .. "\n",2)
	io.write("unknown318" .. ": " ..  this.unknown318.. ": " .. "\n",2)
	io.write("unknown31C" .. ": " ..  this.unknown31C.. ": " .. "\n",2)
	io.write("unknown320" .. ": " ..  this.unknown320.. ": " .. "\n",2)
	io.write("unknown324" .. ": " ..  this.unknown324.. ": " .. "\n",2)
	io.write("unknown328" .. ": " ..  this.unknown328.. ": " .. "\n",2)
	io.write("unknown32C" .. ": " ..  this.unknown32C.. ": " .. "\n",2)
	io.write("unknown330" .. ": " ..  this.unknown330.. ": " .. "\n",2)
	io.write("unknown334" .. ": " ..  this.unknown334.. ": " .. "\n",2)
	io.write("unknown338" .. ": " ..  this.unknown338.. ": " .. "\n",2)
	io.write("unknown33C" .. ": " ..  this.unknown33C.. ": " .. "\n",2)
	io.write("unknown340" .. ": " ..  this.unknown340.. ": " .. "\n",2)
	io.write("unknown344" .. ": " ..  this.unknown344.. ": " .. "\n",2)
	io.write("unknown348" .. ": " ..  this.unknown348.. ": " .. "\n",2)
	io.write("unknown34C" .. ": " ..  this.unknown34C.. ": " .. "\n",2)
	io.write("unknown350" .. ": " ..  this.unknown350.. ": " .. "\n",2)
	io.write("unknown354" .. ": " ..  this.unknown354.. ": " .. "\n",2)
	io.write("unknown358" .. ": " ..  this.unknown358.. ": " .. "\n",2)
	io.write("unknown35C" .. ": " ..  this.unknown35C.. ": " .. "\n",2)
	io.write("unknown360" .. ": " ..  this.unknown360.. ": " .. "\n",2)
	io.write("unknown364" .. ": " ..  this.unknown364.. ": " .. "\n",2)
	io.write("unknown368" .. ": " ..  this.unknown368.. ": " .. "\n",2)
	io.write("unknown36C" .. ": " ..  this.unknown36C.. ": " .. "\n",2)
	io.write("unknown370" .. ": " ..  this.unknown370.. ": " .. "\n",2)
	io.write("unknown374" .. ": " ..  this.unknown374.. ": " .. "\n",2)
	io.write("unknown378" .. ": " ..  this.unknown378.. ": " .. "\n",2)
	io.write("unknown37C" .. ": " ..  this.unknown37C.. ": " .. "\n",2)
	io.write("unknown380" .. ": " ..  this.unknown380.. ": " .. "\n",2)
	io.write("unknown384" .. ": " ..  this.unknown384.. ": " .. "\n",2)
	io.write("unknown388" .. ": " ..  this.unknown388.. ": " .. "\n",2)
	io.write("unknown38C" .. ": " ..  this.unknown38C.. ": " .. "\n",2)
	io.write("unknown390" .. ": " ..  this.unknown390.. ": " .. "\n",2)
	io.write("unknown394" .. ": " ..  this.unknown394.. ": " .. "\n",2)
	io.write("unknown398" .. ": " ..  this.unknown398.. ": " .. "\n",2)
	io.write("unknown39C" .. ": " ..  this.unknown39C.. ": " .. "\n",2)
	io.write("unknown3A0" .. ": " ..  this.unknown3A0.. ": " .. "\n",2)
	io.write("unknown3A4" .. ": " ..  this.unknown3A4.. ": " .. "\n",2)
	io.write("unknown3A8" .. ": " ..  this.unknown3A8.. ": " .. "\n",2)
	io.write("unknown3AC" .. ": " ..  this.unknown3AC.. ": " .. "\n",2)
	io.write("unknown3B0" .. ": " ..  this.unknown3B0.. ": " .. "\n",2)
	io.write("unknown3B4" .. ": " ..  this.unknown3B4.. ": " .. "\n",2)
	io.write("unknown3B8" .. ": " ..  this.unknown3B8.. ": " .. "\n",2)
	io.write("unknown3BC" .. ": " ..  this.unknown3BC.. ": " .. "\n",2)
	io.write("unknown3C0" .. ": " ..  this.unknown3C0.. ": " .. "\n",2)
	io.write("unknown3C4" .. ": " ..  this.unknown3C4.. ": " .. "\n",2)
	io.write("unknown3C8" .. ": " ..  this.unknown3C8.. ": " .. "\n",2)
	io.write("unknown3CC" .. ": " ..  this.unknown3CC.. ": " .. "\n",2)
	io.write("unknown3D0" .. ": " ..  this.unknown3D0.. ": " .. "\n",2)
	io.write("unknown3D4" .. ": " ..  this.unknown3D4.. ": " .. "\n",2)
	io.write("unknown3D8" .. ": " ..  this.unknown3D8.. ": " .. "\n",2)
	io.write("unknown3DC" .. ": " ..  this.unknown3DC.. ": " .. "\n",2)
	io.write("unknown3E0" .. ": " ..  this.unknown3E0.. ": " .. "\n",2)
	io.write("unknown3E4" .. ": " ..  this.unknown3E4.. ": " .. "\n",2)
	io.write("unknown3E8" .. ": " ..  this.unknown3E8.. ": " .. "\n",2)
	io.write("unknown3EC" .. ": " ..  this.unknown3EC.. ": " .. "\n",2)
	io.write("unknown3F0" .. ": " ..  this.unknown3F0.. ": " .. "\n",2)
	io.write("unknown3F4" .. ": " ..  this.unknown3F4.. ": " .. "\n",2)
	io.write("unknown3F8" .. ": " ..  this.unknown3F8.. ": " .. "\n",2)
	io.write("unknown3FC" .. ": " ..  this.unknown3FC.. ": " .. "\n",2)
	io.write("unknown400" .. ": " ..  this.unknown400.. ": " .. "\n",2)
	io.write("unknown404" .. ": " ..  this.unknown404.. ": " .. "\n",2)
	io.write("unknown408" .. ": " ..  this.unknown408.. ": " .. "\n",2)
	io.write("unknown40C" .. ": " ..  this.unknown40C.. ": " .. "\n",2)
	io.write("unknown410" .. ": " ..  this.unknown410.. ": " .. "\n",2)
	io.write("unknown414" .. ": " ..  this.unknown414.. ": " .. "\n",2)
	io.write("unknown418" .. ": " ..  this.unknown418.. ": " .. "\n",2)
	io.write("unknown41C" .. ": " ..  this.unknown41C.. ": " .. "\n",2)
	io.write("unknown420" .. ": " ..  this.unknown420.. ": " .. "\n",2)
	io.write("unknown424" .. ": " ..  this.unknown424.. ": " .. "\n",2)
	io.write("unknown428" .. ": " ..  this.unknown428.. ": " .. "\n",2)
	io.write("unknown42C" .. ": " ..  this.unknown42C.. ": " .. "\n",2)
	io.write("unknown430" .. ": " ..  this.unknown430.. ": " .. "\n",2)
	io.write("unknown434" .. ": " ..  this.unknown434.. ": " .. "\n",2)
	io.write("unknown438" .. ": " ..  this.unknown438.. ": " .. "\n",2)
	io.write("unknown43C" .. ": " ..  this.unknown43C.. ": " .. "\n",2)
	io.write("unknown440" .. ": " ..  this.unknown440.. ": " .. "\n",2)
	io.write("unknown444" .. ": " ..  this.unknown444.. ": " .. "\n",2)
	io.write("unknown448" .. ": " ..  this.unknown448.. ": " .. "\n",2)
	io.write("unknown44C" .. ": " ..  this.unknown44C.. ": " .. "\n",2)
	io.write("unknown450" .. ": " ..  this.unknown450.. ": " .. "\n",2)
	io.write("unknown454" .. ": " ..  this.unknown454.. ": " .. "\n",2)
	io.write("unknown458" .. ": " ..  this.unknown458.. ": " .. "\n",2)
	io.write("unknown45C" .. ": " ..  this.unknown45C.. ": " .. "\n",2)
	io.write("unknown460" .. ": " ..  this.unknown460.. ": " .. "\n",2)
	io.write("unknown464" .. ": " ..  this.unknown464.. ": " .. "\n",2)
	io.write("unknown468" .. ": " ..  this.unknown468.. ": " .. "\n",2)
	io.write("unknown46C" .. ": " ..  this.unknown46C.. ": " .. "\n",2)
	io.write("unknown470" .. ": " ..  this.unknown470.. ": " .. "\n",2)
	io.write("unknown474" .. ": " ..  this.unknown474.. ": " .. "\n",2)
	io.write("unknown478" .. ": " ..  this.unknown478.. ": " .. "\n",2)
	io.write("unknown47C" .. ": " ..  this.unknown47C.. ": " .. "\n",2)
	io.write("unknown480" .. ": " ..  this.unknown480.. ": " .. "\n",2)
	io.write("unknown484" .. ": " ..  this.unknown484.. ": " .. "\n",2)
	io.write("unknown488" .. ": " ..  this.unknown488.. ": " .. "\n",2)
	io.write("unknown48C" .. ": " ..  this.unknown48C.. ": " .. "\n",2)
	io.write("unknown490" .. ": " ..  this.unknown490.. ": " .. "\n",2)
	io.write("unknown494" .. ": " ..  this.unknown494.. ": " .. "\n",2)
	io.write("unknown498" .. ": " ..  this.unknown498.. ": " .. "\n",2)
	io.write("unknown49C" .. ": " ..  this.unknown49C.. ": " .. "\n",2)
	io.write("unknown4A0" .. ": " ..  this.unknown4A0.. ": " .. "\n",2)
	io.write("unknown4A4" .. ": " ..  this.unknown4A4.. ": " .. "\n",2)
	io.write("unknown4A8" .. ": " ..  this.unknown4A8.. ": " .. "\n",2)
	io.write("unknown4AC" .. ": " ..  this.unknown4AC.. ": " .. "\n",2)
end

function PrintWorm(this)
	io.write("---WORM--\n",2)
	io.write("unknownF0" .. ": " ..  this.unknownF0.. ": " .. "\n",2)
	io.write("unknownF4" .. ": " ..  this.unknownF4.. ": " .. "\n",2)
	io.write("unknownF8" .. ": " ..  this.unknownF8.. ": " .. "\n",2)
	io.write("TeamId" .. ": " ..  this.unknownFC.. ": " .. "\n",2) --teamid
	io.write("wormnumber" .. ": " .. this.wormnumber.. ": " .. "\n",2)
	io.write("unknown104" .. ": " .. this.unknown104.. ": " .. "\n",2)
	io.write("unknown108" .. ": " .. this.unknown108.. ": " .. "\n",2)
	io.write("unknown10C" .. ": " .. this.unknown10C.. ": " .. "\n",2)
	io.write("unknown110" .. ": " .. this.unknown110.. ": " .. "\n",2)
	io.write("unknown114" .. ": " .. this.unknown114.. ": " .. "\n",2)
	io.write("unknown118" .. ": " .. this.unknown118.. ": " .. "\n",2)
	io.write("unknown11C" .. ": " .. this.unknown11C.. ": " .. "\n",2)
	io.write("unknown120" .. ": " .. this.unknown120.. ": " .. "\n",2)
	io.write("unknown124" .. ": " .. this.unknown124.. ": " .. "\n",2)
	io.write("unknown128" .. ": " .. this.unknown128.. ": " .. "\n",2)
	io.write("unknown12C" .. ": " .. this.unknown12C.. ": " .. "\n",2)
	io.write("unknown130" .. ": " .. this.unknown130.. ": " .. "\n",2)
	io.write("unknown134" .. ": " .. this.unknown134.. ": " .. "\n",2)
	io.write("unknown138" .. ": " .. this.unknown138.. ": " .. "\n",2)
	io.write("unknown13C" .. ": " .. this.unknown13C.. ": " .. "\n",2)
	io.write("unknown140" .. ": " .. this.unknown140.. ": " .. "\n",2)
	io.write("unknown144" .. ": " .. this.unknown144.. ": " .. "\n",2)
	io.write("unknown148" .. ": " .. this.unknown148.. ": " .. "\n",2)
	io.write("unknown14C" .. ": " .. this.unknown14C.. ": " .. "\n",2)
	io.write("unknown150" .. ": " .. this.unknown150.. ": " .. "\n",2)
	io.write("unknown154" .. ": " .. this.unknown154.. ": " .. "\n",2)
	io.write("unknown158" .. ": " .. this.unknown158.. ": " .. "\n",2)
	io.write("unknown15C" .. ": " .. this.unknown15C.. ": " .. "\n",2)
	io.write("unknown160" .. ": " .. this.unknown160.. ": " .. "\n",2)
	io.write("unknown164" .. ": " .. this.unknown164.. ": " .. "\n",2)
	io.write("unknown168" .. ": " .. this.unknown168.. ": " .. "\n",2)
	io.write("unknown16C" .. ": " .. this.unknown16C.. ": " .. "\n",2)
	io.write("selectedweapon" .. ": " .. this.unknown170.. ": " .. "\n",2)
	io.write("unknown174" .. ": " .. this.unknown174.. ": " .. "\n",2)
	io.write("unknown178" .. ": " .. this.unknown178.. ": " .. "\n",2)
	io.write("unknown17C" .. ": " .. this.unknown17C.. ": " .. "\n",2)
	io.write("unknown180" .. ": " .. this.unknown180.. ": " .. "\n",2)
	io.write("unknown184" .. ": " .. this.unknown184.. ": " .. "\n",2)
	io.write("unknown188" .. ": " .. this.unknown188.. ": " .. "\n",2)
	io.write("unknown18C" .. ": " .. this.unknown18C.. ": " .. "\n",2)
	io.write("unknown190" .. ": " .. this.unknown190.. ": " .. "\n",2)
	io.write("unknown194" .. ": " .. this.unknown194.. ": " .. "\n",2)
	io.write("unknown198" .. ": " .. this.unknown198.. ": " .. "\n",2)
	io.write("unknown19C" .. ": " .. this.unknown19C.. ": " .. "\n",2)
	io.write("unknown1A0" .. ": " .. this.unknown1A0.. ": " .. "\n",2)
	io.write("unknown1A4" .. ": " .. this.unknown1A4.. ": " .. "\n",2)
	io.write("unknown1A8" .. ": " .. this.unknown1A8.. ": " .. "\n",2)
	io.write("unknown1AC" .. ": " .. this.unknown1AC.. ": " .. "\n",2)
	io.write("unknown1B0" .. ": " .. this.unknown1B0.. ": " .. "\n",2)
	io.write("unknown1B4" .. ": " .. this.unknown1B4.. ": " .. "\n",2)
	io.write("unknown1B8" .. ": " .. this.unknown1B8.. ": " .. "\n",2)
	io.write("unknown1BC" .. ": " .. this.unknown1BC.. ": " .. "\n",2)
	io.write("unknown1C0" .. ": " .. this.unknown1C0.. ": " .. "\n",2)
	io.write("unknown1C4" .. ": " .. this.unknown1C4.. ": " .. "\n",2)
	io.write("unknown1C8" .. ": " .. this.unknown1C8.. ": " .. "\n",2)
	io.write("unknown1CC" .. ": " .. this.unknown1CC.. ": " .. "\n",2)
	io.write("unknown1D0" .. ": " .. this.unknown1D0.. ": " .. "\n",2)
	io.write("unknown1D4" .. ": " .. this.unknown1D4.. ": " .. "\n",2)
	io.write("unknown1D8" .. ": " .. this.unknown1D8.. ": " .. "\n",2)
	io.write("unknown1DC" .. ": " .. this.unknown1DC.. ": " .. "\n",2)
	io.write("unknown1E0" .. ": " .. this.unknown1E0.. ": " .. "\n",2)
	io.write("unknown1E4" .. ": " .. this.unknown1E4.. ": " .. "\n",2)
	io.write("unknown1E8" .. ": " .. this.unknown1E8.. ": " .. "\n",2)
	io.write("unknown1EC" .. ": " .. this.unknown1EC.. ": " .. "\n",2)
	io.write("unknown1F0" .. ": " .. this.unknown1F0.. ": " .. "\n",2)
	io.write("unknown1F4" .. ": " .. this.unknown1F4.. ": " .. "\n",2)
	io.write("unknown1F8" .. ": " .. this.unknown1F8.. ": " .. "\n",2)
	io.write("unknown1FC" .. ": " .. this.unknown1FC.. ": " .. "\n",2)
	io.write("unknown200" .. ": " .. this.unknown200.. ": " .. "\n",2)
	io.write("unknown204" .. ": " .. this.unknown204.. ": " .. "\n",2)
	io.write("unknown208" .. ": " .. this.unknown208.. ": " .. "\n",2)
	io.write("unknown20C" .. ": " .. this.unknown20C.. ": " .. "\n",2)
	io.write("unknown210" .. ": " .. this.unknown210.. ": " .. "\n",2)
	io.write("unknown214" .. ": " .. this.unknown214.. ": " .. "\n",2)
	io.write("unknown218" .. ": " .. this.unknown218.. ": " .. "\n",2)
	io.write("unknown21C" .. ": " .. this.unknown21C.. ": " .. "\n",2)
	io.write("unknown220" .. ": " .. this.unknown220.. ": " .. "\n",2)
	io.write("unknown224" .. ": " .. this.unknown224.. ": " .. "\n",2)
	io.write("unknown228" .. ": " .. this.unknown228.. ": " .. "\n",2)
	io.write("unknown22C" .. ": " .. this.unknown22C.. ": " .. "\n",2)
	io.write("unknown230" .. ": " .. this.unknown230.. ": " .. "\n",2)
	io.write("unknown234" .. ": " .. this.unknown234.. ": " .. "\n",2)
	io.write("unknown238" .. ": " .. this.unknown238.. ": " .. "\n",2)
	io.write("unknown23C" .. ": " .. this.unknown23C.. ": " .. "\n",2)
	io.write("unknown240" .. ": " .. this.unknown240.. ": " .. "\n",2)
	io.write("unknown244" .. ": " .. this.unknown244.. ": " .. "\n",2)
	io.write("unknown248" .. ": " .. this.unknown248.. ": " .. "\n",2)
	io.write("unknown24C" .. ": " .. this.unknown24C.. ": " .. "\n",2)
	io.write("unknown250" .. ": " .. this.unknown250.. ": " .. "\n",2)
	io.write("unknown254" .. ": " .. this.unknown254.. ": " .. "\n",2)
	io.write("unknown258" .. ": " .. this.unknown258.. ": " .. "\n",2)
	io.write("unknown25C" .. ": " .. this.unknown25C.. ": " .. "\n",2)
	io.write("unknown260" .. ": " .. this.unknown260.. ": " .. "\n",2)
	io.write("unknown264" .. ": " .. this.unknown264.. ": " .. "\n",2)
	io.write("unknown268" .. ": " .. this.unknown268.. ": " .. "\n",2)
	io.write("unknown26C" .. ": " .. this.unknown26C.. ": " .. "\n",2)
	io.write("unknown270" .. ": " .. this.unknown270.. ": " .. "\n",2)
	io.write("unknown274" .. ": " .. this.unknown274.. ": " .. "\n",2)
	io.write("unknown278" .. ": " .. this.unknown278.. ": " .. "\n",2)
	io.write("unknown27C" .. ": " .. this.unknown27C.. ": " .. "\n",2)
	io.write("unknown280" .. ": " .. this.unknown280.. ": " .. "\n",2)
	io.write("unknown284" .. ": " .. this.unknown284.. ": " .. "\n",2)
	io.write("unknown288" .. ": " .. this.unknown288.. ": " .. "\n",2)
	io.write("unknown28C" .. ": " .. this.unknown28C.. ": " .. "\n",2)
	io.write("unknown290" .. ": " .. this.unknown290.. ": " .. "\n",2)
	io.write("unknown294" .. ": " .. this.unknown294.. ": " .. "\n",2)
	io.write("unknown298" .. ": " .. this.unknown298.. ": " .. "\n",2)
	io.write("unknown29C" .. ": " .. this.unknown29C.. ": " .. "\n",2)
	io.write("unknown2A0" .. ": " .. this.unknown2A0.. ": " .. "\n",2)
	io.write("unknown2A4" .. ": " .. this.unknown2A4.. ": " .. "\n",2)
	io.write("unknown2A8" .. ": " .. this.unknown2A8.. ": " .. "\n",2)
	io.write("unknown2AC" .. ": " .. this.unknown2AC.. ": " .. "\n",2)
	io.write("unknown2B0" .. ": " .. this.unknown2B0.. ": " .. "\n",2)
	io.write("unknown2B4" .. ": " .. this.unknown2B4.. ": " .. "\n",2)
	io.write("unknown2B8" .. ": " .. this.unknown2B8.. ": " .. "\n",2)
	io.write("unknown2BC" .. ": " .. this.unknown2BC.. ": " .. "\n",2)
	io.write("unknown2C0" .. ": " .. this.unknown2C0.. ": " .. "\n",2)
	io.write("unknown2C4" .. ": " .. this.unknown2C4.. ": " .. "\n",2)
	io.write("unknown2C8" .. ": " .. this.unknown2C8.. ": " .. "\n",2)
	io.write("unknown2CC" .. ": " .. this.unknown2CC.. ": " .. "\n",2)
	io.write("unknown2D0" .. ": " .. this.unknown2D0.. ": " .. "\n",2)
	io.write("unknown2D4" .. ": " .. this.unknown2D4.. ": " .. "\n",2)
	io.write("unknown2D8" .. ": " .. this.unknown2D8.. ": " .. "\n",2)
	io.write("unknown2DC" .. ": " .. this.unknown2DC.. ": " .. "\n",2)
	io.write("unknown2E0" .. ": " .. this.unknown2E0.. ": " .. "\n",2)
	io.write("unknown2E4" .. ": " .. this.unknown2E4.. ": " .. "\n",2)
	io.write("unknown2E8" .. ": " .. this.unknown2E8.. ": " .. "\n",2)
	io.write("unknown2EC" .. ": " .. this.unknown2EC.. ": " .. "\n",2)
	io.write("unknown2F0" .. ": " .. this.unknown2F0.. ": " .. "\n",2)
	io.write("unknown2F4" .. ": " .. this.unknown2F4.. ": " .. "\n",2)
	io.write("unknown2F8" .. ": " .. this.unknown2F8.. ": " .. "\n",2)
	io.write("unknown2FC" .. ": " .. this.unknown2FC.. ": " .. "\n",2)
	io.write("unknown300" .. ": " .. this.unknown300.. ": " .. "\n",2)
	io.write("unknown304" .. ": " .. this.unknown304.. ": " .. "\n",2)
	io.write("unknown308" .. ": " .. this.unknown308.. ": " .. "\n",2)
	io.write("unknown30C" .. ": " .. this.unknown30C.. ": " .. "\n",2)
	io.write("unknown310" .. ": " .. this.unknown310.. ": " .. "\n",2)
	io.write("unknown314" .. ": " .. this.unknown314.. ": " .. "\n",2)
	io.write("unknown318" .. ": " .. this.unknown318.. ": " .. "\n",2)
	io.write("unknown31C" .. ": " .. this.unknown31C.. ": " .. "\n",2)
	io.write("unknown320" .. ": " .. this.unknown320.. ": " .. "\n",2)
	io.write("unknown324" .. ": " .. this.unknown324.. ": " .. "\n",2)
	io.write("unknown328" .. ": " .. this.unknown328.. ": " .. "\n",2)
	io.write("unknown32C" .. ": " .. this.unknown32C.. ": " .. "\n",2)
	io.write("unknown330" .. ": " .. this.unknown330.. ": " .. "\n",2)
	io.write("unknown334" .. ": " .. this.unknown334.. ": " .. "\n",2)
	io.write("unknown338" .. ": " .. this.unknown338.. ": " .. "\n",2)
	io.write("unknown33C" .. ": " .. this.unknown33C.. ": " .. "\n",2)
	io.write("unknown340" .. ": " .. this.unknown340.. ": " .. "\n",2)
	io.write("unknown344" .. ": " .. this.unknown344.. ": " .. "\n",2)
	io.write("unknown348" .. ": " .. this.unknown348.. ": " .. "\n",2)
	io.write("unknown34C" .. ": " .. this.unknown34C.. ": " .. "\n",2)
	io.write("unknown350" .. ": " .. this.unknown350.. ": " .. "\n",2)
	io.write("unknown354" .. ": " .. this.unknown354.. ": " .. "\n",2)
	io.write("unknown358" .. ": " .. this.unknown358.. ": " .. "\n",2)
	io.write("unknown35C" .. ": " .. this.unknown35C.. ": " .. "\n",2)
	io.write("unknown360" .. ": " .. this.unknown360.. ": " .. "\n",2)
	io.write("unknown364" .. ": " .. this.unknown364.. ": " .. "\n",2)
	io.write("unknown368" .. ": " .. this.unknown368.. ": " .. "\n",2)
	io.write("unknown36C" .. ": " .. this.unknown36C.. ": " .. "\n",2)
	io.write("unknown370" .. ": " .. this.unknown370.. ": " .. "\n",2)
	io.write("unknown374" .. ": " .. this.unknown374.. ": " .. "\n",2)
	io.write("unknown378" .. ": " .. this.unknown378.. ": " .. "\n",2)
	io.write("unknown37C" .. ": " .. this.unknown37C.. ": " .. "\n",2)
	io.write("unknown380" .. ": " .. this.unknown380.. ": " .. "\n",2)
	io.write("unknown384" .. ": " .. this.unknown384.. ": " .. "\n",2)
	io.write("unknown388" .. ": " .. this.unknown388.. ": " .. "\n",2)
	io.write("unknown38C" .. ": " .. this.unknown38C.. ": " .. "\n",2)
	io.write("unknown390" .. ": " .. this.unknown390.. ": " .. "\n",2)
	io.write("unknown394" .. ": " .. this.unknown394.. ": " .. "\n",2)
	io.write("unknown398" .. ": " .. this.unknown398.. ": " .. "\n",2)
	io.write("unknown39C" .. ": " .. this.unknown39C.. ": " .. "\n",2)
	io.write("unknown3A0" .. ": " .. this.unknown3A0.. ": " .. "\n",2)
	io.write("unknown3A4" .. ": " .. this.unknown3A4.. ": " .. "\n",2)
	io.write("unknown3A8" .. ": " .. this.unknown3A8.. ": " .. "\n",2)
	io.write("unknown3AC" .. ": " .. this.unknown3AC.. ": " .. "\n",2)
	io.write("unknown3B0" .. ": " .. this.unknown3B0.. ": " .. "\n",2)
	io.write("unknown3B4" .. ": " .. this.unknown3B4.. ": " .. "\n",2)
	io.write("unknown3B8" .. ": " .. this.unknown3B8.. ": " .. "\n",2)
	io.write("unknown3BC" .. ": " .. this.unknown3BC.. ": " .. "\n",2)
	io.write("unknown3C0" .. ": " .. this.unknown3C0.. ": " .. "\n",2)
	io.write("unknown3C4" .. ": " .. this.unknown3C4.. ": " .. "\n",2)
	io.write("unknown3C8" .. ": " .. this.unknown3C8.. ": " .. "\n",2)
	io.write("unknown3CC" .. ": " .. this.unknown3CC.. ": " .. "\n",2)
	io.write("unknown3D0" .. ": " .. this.unknown3D0.. ": " .. "\n",2)
	io.write("unknown3D4" .. ": " .. this.unknown3D4.. ": " .. "\n",2)
	io.write("unknown3D8" .. ": " .. this.unknown3D8.. ": " .. "\n",2)
	io.write("unknown3DC" .. ": " .. this.unknown3DC.. ": " .. "\n",2)
	io.write("unknown3E0" .. ": " .. this.unknown3E0.. ": " .. "\n",2)
	io.write("unknown3E4" .. ": " .. this.unknown3E4.. ": " .. "\n",2)
	io.write("unknown3E8" .. ": " .. this.unknown3E8.. ": " .. "\n",2)
	io.write("unknown3EC" .. ": " .. this.unknown3EC.. ": " .. "\n",2)
	io.write("unknown3F0" .. ": " .. this.unknown3F0.. ": " .. "\n",2)
	io.write("unknown3F4" .. ": " .. this.unknown3F4.. ": " .. "\n",2)
	io.write("unknown3F8" .. ": " .. this.unknown3F8.. ": " .. "\n",2)
	
end
local wasgod = {}

function Message(This, sender, messagetype, psize, params)
	if (not tab[tostring(This.__name) .. tostring(messagetype)]) then
		--io.write(messagetype .. "//" .. tostring(This.__name)  .. "\n")
		------tab[tostring(This.__name) .. tostring(messagetype)] = true
		--cnt = cnt +1
		--playSoundLocal(0x10000, 0x10000, This, weapon_select_sound, 8)
		--showChatMessage("message: " .. messagetype .. "/" .. tostring(This.__name), 2)
		-----io.write(tostring(This.__name) .. ": " .. tostring(messagetype) .. "/" .. cnt .. "\n", 2)
		--for i,e in pairs(getmetatable(This)) do
			--	io.write(i .. ": " .. tostring(e) .. " \n", 2)
		--end
		--return 0		
	end
	--getObjects()
	--if (messagetype == 127)then
	--	local tt = CGameTask_CastCTask(sender)
	--	io.write(tt.posX .. "," .. tt.posY .. "\n")
	--end
	-- TaskMessage_CrateCollected funneh (no se usan armas hasta el proximo turno
	if (messagetype == TaskMessage_WeaponFinished)then
		--showChatMessage("message: " .. messagetype .. "/" .. tostring(This.__name), 2)
		--showChatMessage("VIGA",2);
	end
	if (messagetype == TaskMessage_PauseTurn) then
		return 1 --doesnt prevent timer freeze which can be exploited
	end
	
	if (messagetype == TaskMessage_KillWorm) or (messagetype ==TaskMessage_WormDrowned) then
		--showChatMessage("Weapon focused?: " .. messagetype .. "//" .. type(params), 2)
		--io.write(tostring(sender.__name) .. ": " .. tostring(messagetype) .. "\n", 2)
		--PrintTurnGame(This)
		--io.write("TeamId:" .. This.unknownEC .. "\n")
	end
	
	if messagetype == 51 then
		--showChatMessage("Weapon focused?: " .. messagetype .. "//" .. type(params), 2)
		--playSoundLocal(0x10000, 0x10000, This, weapon_select_sound, 8)
	end
	
	return 0
end  

local oneperturn = {}
oneperturn[Weapon_Girder] = true
oneperturn[Weapon_GirderPack] = true

local weapons = {}
weapons[Weapon_Bazooka]=true
weapons[Weapon_HomingMissile]=true
weapons[Weapon_Mortar]=true
weapons[Weapon_HomingPigeon]=true
weapons[Weapon_SheepLauncher]=true
weapons[Weapon_Grenade]=true
weapons[Weapon_ClusterBomb]=true
weapons[Weapon_BananaBomb]=true
weapons[Weapon_BattleAxe]=true
weapons[Weapon_EarthQuake]=true
weapons[Weapon_Shotgun]=true
weapons[Weapon_Handgun]=true
weapons[Weapon_Uzi]=true
weapons[Weapon_Minigun]=true
weapons[Weapon_Longbow]=true
weapons[Weapon_FirePunch]=true
weapons[Weapon_DragonBall]=true
weapons[Weapon_Kamikaze]=true
weapons[Weapon_SuicideBomber]=true
weapons[Weapon_Prod]=true
weapons[Weapon_Dynamite]=true
weapons[Weapon_Mine]=true
weapons[Weapon_Sheep]=true
weapons[Weapon_SuperSheep]=true
weapons[Weapon_AquaSheep]=true
weapons[Weapon_MoleBomb]=true
weapons[Weapon_AirStrike]=true
weapons[Weapon_NapalmStrike]=true
weapons[Weapon_MailStrike]=true
weapons[Weapon_MineStrike]=true
weapons[Weapon_MoleSquadron]=true
weapons[Weapon_BlowTorch]=true
weapons[Weapon_PneumaticDrill]=true
weapons[Weapon_Girder]=true
weapons[Weapon_BaseballBat]=true
weapons[Weapon_GirderPack]=true
weapons[Weapon_NinjaRope]=true
weapons[Weapon_Bungee]=true
weapons[Weapon_Parachute]=true
weapons[Weapon_Teleport]=true
weapons[Weapon_ScalesofJustice]=true
weapons[Weapon_SuperBanana]=true
weapons[Weapon_HolyGrenade]=true
weapons[Weapon_FlameThrower]=true
weapons[Weapon_SalvationArmy]=true
weapons[Weapon_MBBomb]=true
weapons[Weapon_PetrolBomb]=true
weapons[Weapon_Skunk]=true
weapons[Weapon_MingVase]=true
weapons[Weapon_SheepStrike]=true
weapons[Weapon_CarpetBomb]=true
weapons[Weapon_MadCow]=true
weapons[Weapon_OldWoman]=true
weapons[Weapon_Donkey]=true
weapons[Weapon_NuclearTest]=true
weapons[Weapon_Armageddon]=true
--weapons[Weapon_SkipGo]=true
weapons[Weapon_Surrender]=true
weapons[Weapon_SelectWorm]=true
weapons[Weapon_Freeze]=true
weapons[Weapon_MagicBullet]=true
weapons[Weapon_JetPack]=true
weapons[Weapon_LowGravity]=true
weapons[Weapon_FastWalk]=true
weapons[Weapon_LaserSight]=true
--weapons[Weapon_Invisibility]=true
--weapons[Weapon_DamageX2]=true
--weapons[Weapon_CrateSpy]=true
--weapons[Weapon_DoubleTurnTime]=true
--weapons[Weapon_CrateShower]=true


local utitilies = {}
--utitilies[Weapon_Bazooka]=true
--utitilies[Weapon_HomingMissile]=true
--utitilies[Weapon_Mortar]=true
--utitilies[Weapon_HomingPigeon]=true
--utitilies[Weapon_SheepLauncher]=true
--utitilies[Weapon_Grenade]=true
--utitilies[Weapon_ClusterBomb]=true
--utitilies[Weapon_BananaBomb]=true
--utitilies[Weapon_BattleAxe]=true
--utitilies[Weapon_EarthQuake]=true
--utitilies[Weapon_Shotgun]=true
--utitilies[Weapon_Handgun]=true
--utitilies[Weapon_Uzi]=true
--utitilies[Weapon_Minigun]=true
--utitilies[Weapon_Longbow]=true
--utitilies[Weapon_FirePunch]=true
--utitilies[Weapon_DragonBall]=true
--utitilies[Weapon_Kamikaze]=true
--utitilies[Weapon_SuicideBomber]=true
--utitilies[Weapon_Prod]=true
--utitilies[Weapon_Dynamite]=true
--utitilies[Weapon_Mine]=true
--utitilies[Weapon_Sheep]=true
--utitilies[Weapon_SuperSheep]=true
--utitilies[Weapon_AquaSheep]=true
--utitilies[Weapon_MoleBomb]=true
--utitilies[Weapon_AirStrike]=true
--utitilies[Weapon_NapalmStrike]=true
--utitilies[Weapon_MailStrike]=true
--utitilies[Weapon_MineStrike]=true
--utitilies[Weapon_MoleSquadron]=true
--utitilies[Weapon_BlowTorch]=true
--utitilies[Weapon_PneumaticDrill]=true
--utitilies[Weapon_Girder]=true
--utitilies[Weapon_BaseballBat]=true
--utitilies[Weapon_GirderPack]=true
--utitilies[Weapon_NinjaRope]=true
--utitilies[Weapon_Bungee]=true
--utitilies[Weapon_Parachute]=true
--utitilies[Weapon_Teleport]=true
--utitilies[Weapon_ScalesofJustice]=true
--utitilies[Weapon_SuperBanana]=true
--utitilies[Weapon_HolyGrenade]=true
--utitilies[Weapon_FlameThrower]=true
--utitilies[Weapon_SalvationArmy]=true
--utitilies[Weapon_MBBomb]=true
--utitilies[Weapon_PetrolBomb]=true
--utitilies[Weapon_Skunk]=true
--utitilies[Weapon_MingVase]=true
--utitilies[Weapon_SheepStrike]=true
--utitilies[Weapon_CarpetBomb]=true
--utitilies[Weapon_MadCow]=true
--utitilies[Weapon_OldWoman]=true
--utitilies[Weapon_Donkey]=true
--utitilies[Weapon_NuclearTest]=true
--utitilies[Weapon_Armageddon]=true
--utitilies[Weapon_SkipGo]=true
--utitilies[Weapon_Surrender]=true
--utitilies[Weapon_SelectWorm]=true
--utitilies[Weapon_Freeze]=true
--utitilies[Weapon_MagicBullet]=true
utitilies[Weapon_JetPack]=true
utitilies[Weapon_LowGravity]=true
utitilies[Weapon_FastWalk]=true
utitilies[Weapon_LaserSight]=true
utitilies[Weapon_Invisibility]=true
utitilies[Weapon_DamageX2]=true
utitilies[Weapon_CrateSpy]=true
utitilies[Weapon_DoubleTurnTime]=true
utitilies[Weapon_CrateShower]=true

local ultimoblock = {}
--ultimoblock[Weapon_Bazooka]=true
ultimoblock[Weapon_HomingMissile]=true
--ultimoblock[Weapon_Mortar]=true
ultimoblock[Weapon_HomingPigeon]=true
--ultimoblock[Weapon_SheepLauncher]=true
--ultimoblock[Weapon_Grenade]=true
--ultimoblock[Weapon_ClusterBomb]=true
ultimoblock[Weapon_BananaBomb]=true
--ultimoblock[Weapon_BattleAxe]=true
ultimoblock[Weapon_EarthQuake]=true
--ultimoblock[Weapon_Shotgun]=true
--ultimoblock[Weapon_Handgun]=true
--ultimoblock[Weapon_Uzi]=true
--ultimoblock[Weapon_Minigun]=true
--ultimoblock[Weapon_Longbow]=true
--ultimoblock[Weapon_FirePunch]=true
--ultimoblock[Weapon_DragonBall]=true
ultimoblock[Weapon_Kamikaze]=true
ultimoblock[Weapon_SuicideBomber]=true
--ultimoblock[Weapon_Prod]=true
--ultimoblock[Weapon_Dynamite]=true
--ultimoblock[Weapon_Mine]=true
--ultimoblock[Weapon_Sheep]=true
ultimoblock[Weapon_SuperSheep]=true
ultimoblock[Weapon_AquaSheep]=true
--ultimoblock[Weapon_MoleBomb]=true
ultimoblock[Weapon_AirStrike]=true
ultimoblock[Weapon_NapalmStrike]=true
ultimoblock[Weapon_MailStrike]=true
ultimoblock[Weapon_MineStrike]=true
ultimoblock[Weapon_MoleSquadron]=true
--ultimoblock[Weapon_BlowTorch]=true
--ultimoblock[Weapon_PneumaticDrill]=true
--ultimoblock[Weapon_Girder]=true
--ultimoblock[Weapon_BaseballBat]=true
--ultimoblock[Weapon_GirderPack]=true
ultimoblock[Weapon_NinjaRope]=true
--ultimoblock[Weapon_Bungee]=true
--ultimoblock[Weapon_Parachute]=true
ultimoblock[Weapon_Teleport]=true
--ultimoblock[Weapon_ScalesofJustice]=true
ultimoblock[Weapon_SuperBanana]=true
--ultimoblock[Weapon_HolyGrenade]=true
--ultimoblock[Weapon_FlameThrower]=true
--ultimoblock[Weapon_SalvationArmy]=true
ultimoblock[Weapon_MBBomb]=true
--ultimoblock[Weapon_PetrolBomb]=true
--ultimoblock[Weapon_Skunk]=true
--ultimoblock[Weapon_MingVase]=true
ultimoblock[Weapon_SheepStrike]=true
ultimoblock[Weapon_CarpetBomb]=true
--ultimoblock[Weapon_MadCow]=true
--ultimoblock[Weapon_OldWoman]=true
ultimoblock[Weapon_Donkey]=true
ultimoblock[Weapon_NuclearTest]=true
ultimoblock[Weapon_Armageddon]=true
--ultimoblock[Weapon_SkipGo]=true
--ultimoblock[Weapon_Surrender]=true
ultimoblock[Weapon_SelectWorm]=true
--ultimoblock[Weapon_Freeze]=true
ultimoblock[Weapon_MagicBullet]=true
ultimoblock[Weapon_JetPack]=true
--ultimoblock[Weapon_LowGravity]=true
--ultimoblock[Weapon_FastWalk]=true
--ultimoblock[Weapon_LaserSight]=true
--weapons[Weapon_Invisibility]=true
--weapons[Weapon_DamageX2]=true
--weapons[Weapon_CrateSpy]=true
--weapons[Weapon_DoubleTurnTime]=true
--weapons[Weapon_CrateShower]=true

local blockattacks = {}
--blockattacks[Weapon_Bazooka]=true
--blockattacks[Weapon_HomingMissile]=true
--blockattacks[Weapon_Mortar]=true
--blockattacks[Weapon_HomingPigeon]=true
--blockattacks[Weapon_SheepLauncher]=true
--blockattacks[Weapon_Grenade]=true
--blockattacks[Weapon_ClusterBomb]=true
--blockattacks[Weapon_BananaBomb]=true
--blockattacks[Weapon_BattleAxe]=true
--blockattacks[Weapon_EarthQuake]=true
--blockattacks[Weapon_Shotgun]=true
--blockattacks[Weapon_Handgun]=true
--blockattacks[Weapon_Uzi]=true
--blockattacks[Weapon_Minigun]=true
--blockattacks[Weapon_Longbow]=true
--blockattacks[Weapon_FirePunch]=true
--blockattacks[Weapon_DragonBall]=true
--blockattacks[Weapon_Kamikaze]=true
--blockattacks[Weapon_SuicideBomber]=true
--blockattacks[Weapon_Prod]=true
--blockattacks[Weapon_Dynamite]=true
--blockattacks[Weapon_Mine]=true
--blockattacks[Weapon_Sheep]=true
--blockattacks[Weapon_SuperSheep]=true
--blockattacks[Weapon_AquaSheep]=true
--blockattacks[Weapon_MoleBomb]=true
--blockattacks[Weapon_AirStrike]=true
--blockattacks[Weapon_NapalmStrike]=true
--blockattacks[Weapon_MailStrike]=true
--blockattacks[Weapon_MineStrike]=true
--blockattacks[Weapon_MoleSquadron]=true
blockattacks[Weapon_BlowTorch]=true
--blockattacks[Weapon_PneumaticDrill]=true
blockattacks[Weapon_Girder]=true
--blockattacks[Weapon_BaseballBat]=true
blockattacks[Weapon_GirderPack]=true
--blockattacks[Weapon_NinjaRope]=true
blockattacks[Weapon_Bungee]=true
--blockattacks[Weapon_Parachute]=true
--blockattacks[Weapon_Teleport]=true
--blockattacks[Weapon_ScalesofJustice]=true
--blockattacks[Weapon_SuperBanana]=true
--blockattacks[Weapon_HolyGrenade]=true
--blockattacks[Weapon_FlameThrower]=true
--blockattacks[Weapon_SalvationArmy]=true
--blockattacks[Weapon_MBBomb]=true
--blockattacks[Weapon_PetrolBomb]=true
blockattacks[Weapon_Skunk]=true
--blockattacks[Weapon_MingVase]=true
--blockattacks[Weapon_SheepStrike]=true
--blockattacks[Weapon_CarpetBomb]=true
--blockattacks[Weapon_MadCow]=true
--blockattacks[Weapon_OldWoman]=true
--blockattacks[Weapon_Donkey]=true
--blockattacks[Weapon_NuclearTest]=true
--blockattacks[Weapon_Armageddon]=true
blockattacks[Weapon_SkipGo]=true
blockattacks[Weapon_Surrender]=true
--blockattacks[Weapon_SelectWorm]=true
--blockattacks[Weapon_Freeze]=true
--blockattacks[Weapon_MagicBullet]=true
--blockattacks[Weapon_JetPack]=true
--blockattacks[Weapon_LowGravity]=true
--blockattacks[Weapon_FastWalk]=true
--blockattacks[Weapon_LaserSight]=true
--blockattacks[Weapon_Invisibility]=true
--blockattacks[Weapon_DamageX2]=true
--blockattacks[Weapon_CrateSpy]=true
--blockattacks[Weapon_DoubleTurnTime]=true
--blockattacks[Weapon_CrateShower]=true


local blockjetpack = {}
blockjetpack[Weapon_Bazooka]=true
blockjetpack[Weapon_HomingMissile]=true
blockjetpack[Weapon_Mortar]=true
blockjetpack[Weapon_HomingPigeon]=true
blockjetpack[Weapon_SheepLauncher]=true
--blockjetpack[Weapon_Grenade]=true
--blockjetpack[Weapon_ClusterBomb]=true
blockjetpack[Weapon_BananaBomb]=true
blockjetpack[Weapon_BattleAxe]=true
blockjetpack[Weapon_EarthQuake]=true
blockjetpack[Weapon_Shotgun]=true
blockjetpack[Weapon_Handgun]=true
blockjetpack[Weapon_Uzi]=true
blockjetpack[Weapon_Minigun]=true
blockjetpack[Weapon_Longbow]=true
blockjetpack[Weapon_FirePunch]=true
blockjetpack[Weapon_DragonBall]=true
blockjetpack[Weapon_Kamikaze]=true
blockjetpack[Weapon_SuicideBomber]=true
blockjetpack[Weapon_Prod]=true
blockjetpack[Weapon_Dynamite]=true
blockjetpack[Weapon_Mine]=true
blockjetpack[Weapon_Sheep]=true
blockjetpack[Weapon_SuperSheep]=true
blockjetpack[Weapon_AquaSheep]=true
blockjetpack[Weapon_MoleBomb]=true
blockjetpack[Weapon_AirStrike]=true
blockjetpack[Weapon_NapalmStrike]=true
blockjetpack[Weapon_MailStrike]=true
blockjetpack[Weapon_MineStrike]=true
blockjetpack[Weapon_MoleSquadron]=true
blockjetpack[Weapon_BlowTorch]=true
blockjetpack[Weapon_PneumaticDrill]=true
blockjetpack[Weapon_Girder]=true
blockjetpack[Weapon_BaseballBat]=true
blockjetpack[Weapon_GirderPack]=true
blockjetpack[Weapon_NinjaRope]=true
blockjetpack[Weapon_Bungee]=true
blockjetpack[Weapon_Parachute]=true
blockjetpack[Weapon_Teleport]=true
blockjetpack[Weapon_ScalesofJustice]=true
blockjetpack[Weapon_SuperBanana]=true
blockjetpack[Weapon_HolyGrenade]=true
blockjetpack[Weapon_FlameThrower]=true
blockjetpack[Weapon_SalvationArmy]=true
blockjetpack[Weapon_MBBomb]=true
blockjetpack[Weapon_PetrolBomb]=true
blockjetpack[Weapon_Skunk]=true
blockjetpack[Weapon_MingVase]=true
blockjetpack[Weapon_SheepStrike]=true
blockjetpack[Weapon_CarpetBomb]=true
blockjetpack[Weapon_MadCow]=true
blockjetpack[Weapon_OldWoman]=true
blockjetpack[Weapon_Donkey]=true
blockjetpack[Weapon_NuclearTest]=true
blockjetpack[Weapon_Armageddon]=true
--blockjetpack[Weapon_SkipGo]=true
blockjetpack[Weapon_Surrender]=true
blockjetpack[Weapon_SelectWorm]=true
blockjetpack[Weapon_Freeze]=true
blockjetpack[Weapon_MagicBullet]=true
blockjetpack[Weapon_JetPack]=true
blockjetpack[Weapon_LowGravity]=true
blockjetpack[Weapon_FastWalk]=true
blockjetpack[Weapon_LaserSight]=true
--blockjetpack[Weapon_Invisibility]=true
--blockjetpack[Weapon_DamageX2]=true
--blockjetpack[Weapon_CrateSpy]=true
--blockjetpack[Weapon_DoubleTurnTime]=true
--blockjetpack[Weapon_CrateShower]=true


local cowportalsout = {}
local cowportalsin = {}
local cowportalsleft = {}
local cowportalmaxid = 0
local cowportaldelaymax = 100
local isnextcowportalout = {true,true,true,true,true,true,true,true,true,true}

function CreateCowPortalOut(x,y,dir)
	local cowportal = {}
	cowportal.posX = x
	cowportal.posY = y
	cowportal.dir = dir
	cowportal.delay = cowportaldelaymax
	table.insert(cowportalsout,cowportal)
	cowportalmaxid = #cowportalsout
	cowportal.id = cowportalmaxid
	cowportalsleft[cowportal.id] = 3
	return cowportal
end

function CreateCowPortalIn(x,y)
	local cowportal = {}
	cowportal.posX = x
	cowportal.posY = y
	cowportal.id = cowportalmaxid
	table.insert(cowportalsin,cowportal)
	return cowportal
end

local cowrendermaxdelay = 60
local cowrenderdelay = cowrendermaxdelay

function RenderCowPortals()
	if cowrenderdelay % 20 == 0 then
		for i,cowportal in pairs(cowportalsout) do
			--addanim(cowportal.posX,cowportal.posY,Sprite_firehit | translatentsprite,60).Step = 5
			addanim(cowportal.posX,cowportal.posY,Sprite_elipse25 | translatentsprite,60).Step = 2
			--addanim(cowportal.posX,cowportal.posY,Sprite_wormhit1 | translatentsprite,60).Step = 1
			--drawSpriteLocal(cowportal.posY,1000,cowportal.posX,Sprite_circle25,1)
		end
		for i,cowportal in pairs(cowportalsin) do
		
			--addanim(cowportal.posX,cowportal.posY,Sprite_firehit | translatentsprite,60).Step = 5
			addanim(cowportal.posX,cowportal.posY,Sprite_elipse25 | translatentsprite,60).Step = 2
			--addanim(cowportal.posX,cowportal.posY,Sprite_wormhit2 | translatentsprite,60).Step = 1
			--drawSpriteLocal(cowportal.posY,1000,cowportal.posX,Sprite_circle25,1)
		end
	end
	if cowrenderdelay <= 0 then
		cowrenderdelay = cowrendermaxdelay
	end
	cowrenderdelay = cowrenderdelay -1
end

function HandleCowPortals(turnend)
	if not turnend then
		for i,cowportal in pairs(cowportalsout) do
			if (cowportal.delay <= 0) and (cowportalsleft[cowportal.id] > 0) then
				cowportalsleft[cowportal.id] = cowportalsleft[cowportal.id] -1
				cowportal.delay = cowportaldelaymax
				dummylaunchparams.unknown8= cowportal.posX; --cursor x
				dummylaunchparams.unknownC= cowportal.posY; --cursor y
				dummylaunchparams.unknown10= cowportal.dir; --cursor facing dir
				dummylaunchparams.unknown14= 0;
				dummylaunchparams.unknown18= 0;
				dummylaunchparams.unknown1C= 0;
				createWeaponProjectile(currworm, defprojparams[Weapon_MadCow], dummylaunchparams)
			end
			cowportal.delay = cowportal.delay -1
		end
	end
	for i,cowportal in pairs(cowportalsin) do
		local num = getNumObjects(ClassType_Task_Missile)
		for i=1,num,1 do
			local thing = CGameTask_CastCTask(getObject(ClassType_Task_Missile,i))	
			local dist = distance(cowportal.posX,cowportal.posY,thing.posX,thing.posY)
			if (CTaskMissile_CastCTask(thing).unknown180 == 164) and ((dist / 65536) < 25) then --proj type cow
				thing.posY = 9000 * posmult -- send into obvlivion
				cowportalsleft[cowportal.id] = cowportalsleft[cowportal.id] + 1
			end
		end
	end
end

function ResetCowPortals()
	cowportalsout = {}
	cowportalsin = {}
	cowportalsleft = {}
	cowportalmaxid = 0
end


local attractmode = {}
for i=0,8,1 do
	attractmode[i] = false
end

local tst = 10
local pendsound
local godworm = false
local godblock = false
local pendskipgo
local idletimer = 1

objparams = SpawnObjectParams.new()
 objparams.type = Object_WeaponCrate
 objparams.posX = 0
 objparams.posY = 0    -- crate extra time add
 objparams.unkC = 0    
 objparams.unk10 = 1   -- crate weaponid in crate
 objparams.unk14 = 1   -- crate weap amount
 objparams.unk18 = 0   -- crate pop spawn (bool?)
 objparams.unk1C = 0   -- crate point arrow (bool?)
 objparams.unk20 = 0   -- crate highlight
 objparams.unk24 = 0
 
 
 
 oildrumparams = SpawnObjectParams.new()
 oildrumparams.type = Object_Oildrum
 oildrumparams.posX = 0
 oildrumparams.posY = 0    -- crate extra time add
 oildrumparams.unkC = 0
 oildrumparams.unk10 = 1   -- crate weaponid in crate
 oildrumparams.unk14 = 1   -- crate weap amount
 oildrumparams.unk18 = 0   -- crate pop spawn (bool?)
 oildrumparams.unk1C = 0   -- crate point arrow (bool?)
 oildrumparams.unk20 = 0   -- crate highlight
 oildrumparams.unk24 = 0
 
 hpparams = SpawnObjectParams.new()
 hpparams.type = Object_HealthCrate
 hpparams.posX = 0    -- crate extra time add
 hpparams.posY = 0    
 hpparams.unkC = 0    -- crate weaponid in crate
 hpparams.unk10 = 200 -- crate hp amount
 hpparams.unk14 = 0   -- crate pop spawn (bool?)
 hpparams.unk18 = 0   -- crate point arrow (bool?)
 hpparams.unk1C = 0   -- crate highlight
 hpparams.unk20 = 0   
 hpparams.unk24 = 0
 
  mineparams = SpawnObjectParams.new()
 mineparams.type = Object_Mine
 mineparams.posX = 0    -- crate extra time add
 mineparams.posY = 0    
 mineparams.unkC = 0    -- crate weaponid in crate
 mineparams.unk10 = 200 -- crate hp amount
 mineparams.unk14 = 0   -- crate pop spawn (bool?)
 mineparams.unk18 = 0   -- crate point arrow (bool?)
 mineparams.unk1C = 0   -- crate highlight
 mineparams.unk20 = 0   
 mineparams.unk24 = 0

 targetparams = SpawnObjectParams.new()
 targetparams.type = Object_Target
 targetparams.posX = 0    --not posx
 targetparams.posY = 0    --not posy
 targetparams.unkC = 0    --posx int
 targetparams.unk10 = 1 -- targettype --0=target 1=oldwoman
 targetparams.unk14 = 100   -- fall speed
 targetparams.unk18 = 0   --timer
 targetparams.unk1C = 0   -- spawntype --0=airstrike 1=popin
 targetparams.unk20 = 0  --arrow(bool)   
 targetparams.unk24 = 0 --pulsate (bool)
 
 
 doomcountdownparams = SpawnObjectParams.new()
 doomcountdownparams.type = Object_Target
 doomcountdownparams.posX = 0    --not posx
 doomcountdownparams.posY = 0    --not posy
 doomcountdownparams.unkC = 0    --posx int
 doomcountdownparams.unk10 = 0 -- targettype --0=target 1=oldwoman
 doomcountdownparams.unk14 = 100   -- fall speed
 doomcountdownparams.unk18 = 69   --timer
 doomcountdownparams.unk1C = 0   -- spawntype --0=airstrike 1=popin
 doomcountdownparams.unk20 = 0  --arrow(bool)   
 doomcountdownparams.unk24 = 0 --pulsate (bool)


 textparams = SpawnObjectParams.new()
 textparams.type  = Object_TriggerGameText
 textparams.posX  = 16706    -- crate extra time add
 textparams.posY  = 16706    
 textparams.unkC  = 16706    -- crate weaponid in crate
 textparams.unk10 = 16706 -- crate hp amount
 textparams.unk14 = 16706   -- crate pop spawn (bool?)
 textparams.unk18 = 16706   -- crate point arrow (bool?)
 textparams.unk1C = 0   -- crate highlight
 textparams.unk20 = 0   
 textparams.unk24 = 0



function displaymorsetextmessage(input)
     local fields = { "posX", "posY", "unkC", "unk10", "unk14", "unk18", "unk1C", "unk20", "unk24" }
    local fieldSize = 4 
    local inputLen = #input
    local maxFields = #fields

    for _, field in ipairs(fields) do
        textparams[field] = 0
    end

    for i = 1, maxFields do
        local packedValue = 0

        for j = 1, fieldSize do
            local index = (i - 1) * fieldSize + j
            if index > inputLen then break end

            local byte = string.byte(input, index)
            packedValue = packedValue + byte * (256 ^ (j - 1)) 
        end

        textparams[fields[i]] = packedValue

        if (i - 1) * fieldSize >= inputLen then
            break
        end
    end
	spawnObject(textparams);
end


function airdrophp(pos)
		spawnObject(hpparams);
		CGameTask_CastCTask(getObject(ClassType_Task_Crate,getNumObjects(ClassType_Task_Crate))).posX = pos
end


function setcrate(crate, weaponid)
	if weaponid == 71 then --dummy spooky
	  setcrate(crate,math.random(customweapons[1],customweapons[#customweapons]))
	  return nil
	end
	crate.unknown12C = weaponid
	crate.unknown130 = getWeaponData(weaponid).unknown28
end

function airdropcrate(weaponid, pos)
	if weaponid == 71 then --dummy spooky
	  airdropcrate(math.random(customweapons[1],customweapons[#customweapons]),pos)
	  return nil
	end
		objparams.unk10 = weaponid
		objparams.unk14 = getWeaponData(weaponid).unknown28
		spawnObject(objparams);
		CGameTask_CastCTask(getObject(ClassType_Task_Crate,getNumObjects(ClassType_Task_Crate))).posX = pos
		objparams.unk14 = 1
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

--local nextismagnet = false
local djumpon = false

local ping = true 

local dummyuzilaunchparams = WeaponLaunchParams.new()

dummyuzilaunchparams.unknown0 = 1
dummyuzilaunchparams.unknown4 = 1
dummyuzilaunchparams.unknown8 = 44171264
dummyuzilaunchparams.unknownC = 10223616
dummyuzilaunchparams.unknown10 = -1376
dummyuzilaunchparams.unknown14 = 65520
dummyuzilaunchparams.unknown18 = 62914560
dummyuzilaunchparams.unknown1C = 22806528
dummyuzilaunchparams.unknown20 = 0
dummyuzilaunchparams.unknown24 = 30
dummyuzilaunchparams.unknown28 = 3000


local jetpackparams = WeaponLaunchParams.new()
jetpackparams.unknown18 = 62914560
jetpackparams.unknown1C = 22806528
jetpackparams.unknown14 = 0
jetpackparams.unknown20 = 0
jetpackparams.unknown28 = 3000
jetpackparams.unknown8 = 60598009
jetpackparams.unknown10 = 0
jetpackparams.unknown24 = 30
jetpackparams.unknown0 = 1
jetpackparams.unknownC = 20905983
jetpackparams.unknown4 = 2

function prefireweap(worm)
	if (worm.unknown170 == Weapon_JetPack)  then
		if (getTeamAmmo(worm.unknownFC,Weapon_JetPack,0) > 0) and (not pendskipgo) then
			local gtask = CGameTask_CastCTask(worm)
			if gtask.speedY ~= 0 then
				dummylaunchparams.unknown8= gtask.posX;
				dummylaunchparams.unknownC= gtask.posY;
				dummylaunchparams.unknown14 = posmult
				setTeamAmmo(worm.unknownFC,worm.unknown170,0,getTeamAmmo(worm.unknownFC,worm.unknown170,0)-1)
				if not godworm then
					for i,e in pairs(blockjetpack) do
						setTeamAmmo(worm.unknownFC,i,1,1)
					end
					pendskipgo = worm.wormnumber
					idletimer = 0
				end
				FireWeapon(worm,getWeaponData(Weapon_JetPack),dummylaunchparams)
				return 1
			end
		end
	end
	--if (worm.unknown170 == Weapon_Girder)  then
	--	if (getTeamAmmo(worm.unknownFC,Weapon_Girder,0) ~= 0) and (not pendskipgo) then
	--		local gtask = CGameTask_CastCTask(worm)
	--			dummylaunchparams.unknown8= gtask.posX;
	--			dummylaunchparams.unknownC= gtask.posY;
	--			dummylaunchparams.unknown14 = posmult
	--			setTeamAmmo(worm.unknownFC,worm.unknown170,0,getTeamAmmo(worm.unknownFC,worm.unknown170,0)-1)
	--			FireWeapon(worm,getWeaponData(Weapon_Girder),dummylaunchparams)
	--			return 1
	--	end
	--end
end

local ogkamidamage

local wormuzi = false

local mikes = {BazookaStruct,HomingMissileStruct,MortarStruct,HomingPigeonStruct,GrenadeStruct,ClusterBombStruct,BananaBombStruct,DynamiteStruct,SheepStruct,SuperSheepStruct,MoleBombStruct,SuperBananaStruct,HolyGrenadeStruct,SalvationArmyStruct,PetrolBombStruct,SkunkStruct,MingVaseStruct,MadCowStruct,OldWomanStruct,MagicBullet}

local pendonealert = {}
pendonealert[1] = {}
pendonealert[2] = {}
pendonealert[3] = {}
pendonealert[4] = {}
pendonealert[5] = {}
pendonealert[6] = {}
pendonealert[7] = {}
pendonealert[8] = {}

function cajasdemike(worm, structure,jump_info) --info is actually projparams	
	--structure.Param2 = 7 --firepunch angle
	--PrintStuff(jump_info)
	--io.write(structure.name1 .. "\n")
	if not ogkamidamage then
		ogkamidamage = getWeaponData(Weapon_SuicideBomber).unknown3C
	else
		getWeaponData(Weapon_SuicideBomber).unknown3C = ogkamidamage
	end
	
	--if (structure.name1 =="Bomba quasi-Suicida de Mike") or (structure.name1 =="Suicide Bomber")  then
	--	worm = CTaskWorm_CastCTask(worm)
	--	pendskipgo = worm.wormnumber	
	--	addWormHp(worm.unknownFC,worm.wormnumber,-getWormHp(worm.unknownFC,worm.wormnumber) + 1)
	--	addentanim(m,magnet_sprite,10000,false)
	--	getWeaponData(Weapon_SuicideBomber).unknown30 = 4
	--	getWeaponData(Weapon_SuicideBomber).unknown34 = 22
	--end
	if structure.name1 =="Mike" then
		FireWeapon(worm,mikes[math.random(1,#mikes)],jump_info)
		return 1
	end
	if structure.name1 =="AmetraJetPack de Mike" or (structure.name1 == "JetGancho de Mike")  then
		if structure.name1 =="AmetraJetPack de Mike" then
			uzipack = true
		else
			hookpack = true
		end 
		if (getTeamAmmo(worm.unknownFC,customweaponsbyname[structure.name1],0) > 0) and (not pendskipgo) then
			local gtask = CGameTask_CastCTask(worm)
			dummylaunchparams.unknown8= gtask.posX;
			dummylaunchparams.unknownC= gtask.posY;
			dummylaunchparams.unknown14 = posmult	
			--setTeamAmmo(worm.unknownFC,customweaponsbyname["AmetraJetPack de Mike"],0,getTeamAmmo(worm.unknownFC,customweaponsbyname["AmetraJetPack de Mike"],0)-1)		
			if not godworm then
				for i,e in pairs(blockjetpack) do
							setTeamAmmo(worm.unknownFC,i,1,1)
				end
				pendskipgo = worm.wormnumber
				idletimer = 0
			end
			FireWeapon(worm,getWeaponData(Weapon_JetPack),dummylaunchparams)
		end
		return 1
	end
	if structure.name1 == "Wormuzi de Mike" then
		
		return 1
	end
	if structure.name1 == "Cajas de Mike" then
		airdropcrate(math.random(1,customweapons[#customweapons]), jump_info.unknown18)
		airdropcrate(math.random(1,customweapons[#customweapons]), jump_info.unknown18 + (50 * 65536))
		airdropcrate(math.random(1,customweapons[#customweapons]), jump_info.unknown18 - (50 * 65536))
		airdropcrate(math.random(1,customweapons[#customweapons]), jump_info.unknown18 + (100 * 65536))
		airdropcrate(math.random(1,customweapons[#customweapons]), jump_info.unknown18 - (100 * 65536))
	end
	if structure.name1 == "Vacunos Interdimensionales de Mike" then
		if isnextcowportalout[worm.unknownFC] then
			CreateCowPortalOut(jump_info.unknown18,jump_info.unknown1C,jump_info.unknown10)--cursor x --cursor y --cursor facing dir
		else
			CreateCowPortalIn(jump_info.unknown18,jump_info.unknown1C,jump_info.unknown10)--cursor x --cursor y --cursor facing dir
		end
		isnextcowportalout[worm.unknownFC] = not isnextcowportalout[worm.unknownFC]
		return 1
	end
	if structure.name1 == "Doble Salto" then
		djumpon = true
		return 1
	end
	if structure.name1 == "Afano de Mike" then
		local num = getNumObjects(ClassType_Task_Worm)
		local targetworm = CGameTask_CastCTask(worm)
		local mindist
		for i=1,num,1 do
			local tworm = CTaskWorm_CastCTask(getObject(ClassType_Task_Worm,i))
			if (tworm.teamnumber ~= worm.teamnumber) and ((not mindist) or (distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY) < mindist)) then
				mindist = distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY)
				targetworm = tworm
			end
		end
		local steal = stealcandidate(targetworm.teamnumber)
		if steal > 0 then
			setTeamAmmo(worm.teamnumber,steal,0,getTeamAmmo(worm.teamnumber,steal,0)+1)
			setTeamAmmo(targetworm.teamnumber,steal,0,getTeamAmmo(targetworm.teamnumber,steal,0)-1)
		end
		local name = getWeaponData(steal).name2
		local last_char = string.sub(name, -1)
		pendsound = afano_sfx
		if steal == customweaponsbyname["Afano de Mike"] then
			displaymorsetextmessage("Ladron que roba ladron...roba x 2!")
			setTeamAmmo(worm.teamnumber,steal,0,getTeamAmmo(worm.teamnumber,steal,0)+1)
			setTeamAmmo(worm.teamnumber,steal,0,getTeamAmmo(worm.teamnumber,steal,0)+1)
			pendsound = afanop_sfx
		elseif (last_char == "a") or (name:find("Oveja")) or (name:find("Vaca")) or (name:find("Anciana")) or (name:find("Baja")) or (name:find("Bomba")) then
			displaymorsetextmessage("Se afano una " .. name .."!")
		else
			displaymorsetextmessage("Se afano un " .. name .."!")
		end
		return 1
	end
	if structure.name1 == "Inoculacion de Mike" then
		worm = CTaskWorm_CastCTask(worm)
		pendsound = Sound_DonorCardCollect
		addWormHp(worm.unknownFC,worm.wormnumber,250)
		return 1
	end
	if structure.name1 == "Vacunatorio de Mike" then
		vacunastealframe = 1
		--io.write(vacunastealframe .. "\n")
		return 1
	end
	if structure.name1 == "Dadodemike" or (structure.name1 == "Ovejame el Mike") then
		rerollframe = 1
		if (structure.name1 == "Ovejame el Mike") then
			ovejame = 1
			pendsound = sheepme_sfx
		end
		--io.write(rerollframe .. "\n")
		return 1
	end
	if structure.name1 == "Taladro Inverso" then
		drillup = true
	end
	if structure.name1 == "PoxiMike" then
		spawnObject(mineparams);
		local m = CGameTask_CastCTask(getObject(ClassType_Task_Mine,getNumObjects(ClassType_Task_Mine)))
		CTaskMine_CastCTask(m).active = 0
		CTaskMine_CastCTask(m).unknown118 = -6868 --lazy identifier
		m.posX = worm.posX + (worm.facingdirection * (10*65536))
		m.posY = worm.posY
		return 1
	end
	if structure.name1 == "Estafeta de Mike" then
		oildrumparams.unkC = worm.posX / 65536   --posx
		oildrumparams.posY = worm.posY / 65536
		oildrumparams.posX = (worm.posX / 65536) + (worm.facingdirection * (10))
		oildrumparams.unk1C = 1
		spawnObject(oildrumparams)
		local m = CGameTask_CastCTask(getObject(ClassType_Task_OilDrum,getNumObjects(ClassType_Task_OilDrum)))
		m.posX = worm.posX + (worm.facingdirection * (10*65536))
		m.posY = worm.posY
		worm.posY = worm.posY + 1
		setCompactedA(CTaskOildrum_CastCTask(m),"unknown10C", worm.teamnumber) --lazy identifier
		setCompactedB(CTaskOildrum_CastCTask(m),"unknown10C", 69) --lazy identifier
		return 1
	end
	
	if structure.name1 == "Lazor" then
		local targetangle = worm.shootingangle
		local targetdir = worm.facingdirection
		--
		local ax = convertAngleX(targetangle,targetdir)
		local ay = convertAngleY(targetangle)
		local did = false
		local distances = {}
		local dirX = ax / 65536
				local dirY = ay / 65536
				
				local len = math.sqrt(dirX * dirX + dirY * dirY)
				
				dirX = dirX / len
				dirY = dirY / len
				
				local beamX = (worm.posX + (ax * 1)) / 65536
				local beamY = (worm.posY + (ay * 1)) / 65536
				local perpX = -dirY
				local perpY = dirX
				
				local width = 31
					for i = -3, 3 do
						local offset = (i / 3) * width
						distances[i] = checkObjectCollision(CGameTask_CastCTask(worm),beamX + perpX * offset,beamY + perpY * offset,convertAngleX(worm.shootingangle,worm.facingdirection),convertAngleY(worm.shootingangle),1900,CollisionFlag_DEFAULT)
					end
		
	
		
		
		for hit=1,1900,1 do
				
			if hit > 50 then
				local dirX = ax / 65536
				local dirY = ay / 65536
				
				local len = math.sqrt(dirX * dirX + dirY * dirY)
				
				dirX = dirX / len
				dirY = dirY / len
				
				local beamX = (worm.posX + (ax * hit)) / 65536
				local beamY = (worm.posY + (ay * hit)) / 65536
				local perpX = -dirY
				local perpY = dirX
				
				local width = 31
				if hit == 51 then
					local offset = 1
					writeLandRadius(36,beamX + perpX *offset,beamY + perpY * offset)
				else
					for i = -3, 3 do
						if (distances[i] == -1) or (hit < distances[i]) then
							local offset = (i / 3) * width
							writeLandRadius(1,beamX + perpX * offset,beamY + perpY * offset)
						end
					end
				end
			end
		end
		return 1
	end
	if structure.name1 == "Test OBJCol" then
		--local rayland = checkLandCollision(posx,posy,ax,ay,range)
		local rayman = testcol()
		--io.write(rayman .. "\n")		
		--local rayman = checkObjectCollision(CGameTask_CastCTask(worm),worm.posX / posmult,worm.posY / posmult,100,100,1000,CollisionFlag_DEFAULT)
		return 1
	end
	if structure.name1 == "Test OBJCol2" then
		--local rayland = checkLandCollision(posx,posy,ax,ay,range)
		--local rayman = testcol()
		--io.write(rayman .. "\n")		
		local rayman = testcoltwo(CGameTask_CastCTask(worm),worm.posX / posmult,worm.posY / posmult,100,100,1000,CollisionFlag_DEFAULT)
		--io.write(rayman .. "\n")	
		return 1
	end
	if structure.name1 == "Test OBJCol3" then
		--local rayland = checkLandCollision(posx,posy,ax,ay,range)
		--local rayman = testcol()
		--io.write(rayman .. "\n")		
		local rayman = testcolthree()
		return 1
	end
	if structure.name1 == "Test TerrainCol" then
		local rayland = checkLandCollision(worm.posX,worm.posY,100,100,1000)
		--local rayman = checkObjectCollision(This,This.posX / posmult,This.posY / posmult,100,100,1000,CollisionFlag_DEFAULT)
		return 1
	end
	if structure.name1 == "Centinela de Mike" then
		oildrumparams.unkC = worm.posX / 65536   --posx
		oildrumparams.posY = (worm.posY / 65536)
		oildrumparams.posX = (worm.posX / 65536) + (worm.facingdirection * (10))
		oildrumparams.unk1C = 1
		spawnObject(oildrumparams)
		local m = CGameTask_CastCTask(getObject(ClassType_Task_OilDrum,getNumObjects(ClassType_Task_OilDrum)))
		m.posX = worm.posX + (worm.facingdirection * (10*65536))
		m.posY = worm.posY - (10 * posmult)
		worm.posY = worm.posY + 1
		setCompactedA(CTaskOildrum_CastCTask(m),"unknown10C",60 + worm.teamnumber) --lazy identifier
		setCompactedB(CTaskOildrum_CastCTask(m),"unknown10C",50) --lazy identifier
		CTaskOildrum_CastCTask(m).unknownF4 = posmult/2 --lazy identifier
		CTaskOildrum_CastCTask(m).unknownFC = worm.facingdirection --FC is kind of uinstable on collision detetcion but these values dont fuck it enough to be a worry, lol
		m.numberofropesegments = 50
		pendsound = sentryplace_sfx
		return 1
	end
	--if structure.name1 == "Imaik" then
	--	doomcountdownparams.unkC = worm.posX / 65536   --posx
	--	doomcountdownparams.posY = worm.posY / 65536
	--	doomcountdownparams.posX = (worm.posX / 65536) + (worm.facingdirection * (10))
	--	doomcountdownparams.unk1C = 1
	--	spawnObject(doomcountdownparams)
	--	local m = CGameTask_CastCTask(getObject(ClassType_Task_Crate,getNumObjects(ClassType_Task_Crate)))
	--	m.posX = worm.posX + (worm.facingdirection * (10*65536))
	--	m.posY = worm.posY
	--	worm.posY = worm.posY + 1
	--	CTaskMine_CastCTask(m).fusetime = worm.teamnumber --lazy identifier
	--	PrintStuff(CTaskCrate_CastCTask(m))
	--	return 1
	--end
	if structure.name1 == "Imaik" then
		spawnObject(mineparams)
		local m = CGameTask_CastCTask(getObject(ClassType_Task_Mine,getNumObjects(ClassType_Task_Mine)))
		CTaskMine_CastCTask(m).active = 0
		CTaskMine_CastCTask(m).fusetime = -6969 --lazy identifier
		m.posX = worm.posX + (worm.facingdirection * (10*65536))
		m.posY = worm.posY
		m.speedX = worm.facingdirection
		--nextismagnet = true
		--drawSpriteLocal(This.posY,-99999,This.posX,wave_sprite,400)
		--addentanim(m,magnet_sprite,10000,false)
		if attractmode[worm.unknownFC] then
			addentanim(m,wave_sprite | translatentsprite,60,true) --0x4000000 0x200000 0x8000000 0x10000000
			addentanim(m,wave_sprite | translatentsprite,60,true,30) --0x4000000 0x200000 0x8000000 0x10000000
			CTaskMine_CastCTask(m).fusetime = -6971 --lazy identifier
		else
			addentanim(m,wave_sprite | translatentsprite,60,true,60,0) --0x4000000 0x200000 0x8000000 0x10000000
			addentanim(m,wave_sprite | translatentsprite,60,true,30,0) --0x4000000 0x200000 0x8000000 0x10000000
		end
		return 1
	end
	if structure.name1 == "Salud de Mike" then
		airdrophp(jump_info.unknown18)
		airdrophp(jump_info.unknown18 + (50 * 65536))
		airdrophp(jump_info.unknown18 - (50 * 65536))
		airdrophp(jump_info.unknown18 + (100 * 65536))
		airdrophp(jump_info.unknown18 - (100 * 65536))
	end
	if (structure.name1 == "Telemikesporte") or (structure.name1 == "Ablacion de Mike") or (structure.name1 == "Tang") or (structure.name1 == "Teletransparacaidas") then		
		local num = getNumObjects(ClassType_Task_Worm)
		local targetworm = CTaskWorm_CastCTask(worm)
		local mindist
		local isownteam = (structure.name1 == "Tang")
		for i=1,num,1 do
			local tworm = CTaskWorm_CastCTask(getObject(ClassType_Task_Worm,i))
			--io.write("-"..jump_info.unknown18.."-"..jump_info.unknown1C.."-----"..tworm.posX.."-"..tworm.posY.."---("..distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY)..")\n")
			if ((not mindist) or (distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY) < mindist)) and ((not isownteam) or (tworm.teamnumber == worm.teamnumber)) then
				mindist = distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY)
				targetworm = tworm
			end
		end
		if (structure.name1 == "Tang") then
			for i=1,num,1 do
				local tworm = CTaskWorm_CastCTask(getObject(ClassType_Task_Worm,i))
				--io.write("-"..jump_info.unknown18.."-"..jump_info.unknown1C.."-----"..tworm.posX.."-"..tworm.posY.."---("..distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY)..")\n")
				if (tworm.wormnumber ~= targetworm.wormnumber) and (tworm.teamnumber == worm.teamnumber) then
					addWormHp(tworm.unknownFC,tworm.wormnumber,-getWormHp(tworm.unknownFC,tworm.wormnumber))
				end
			end
			if (worm.wormnumber ~= targetworm.wormnumber) then
				pendskipgo = worm.wormnumber
			end
			idletimer = 1  
			return 1
		elseif (structure.name1 == "Teletransparacaidas") then
			worm.posX = jump_info.unknown18
			worm.posY = jump_info.unknown1C
		elseif (structure.name1 == "Telemikesporte") then
			local ax = targetworm.posX
			local ay = targetworm.posY
			targetworm.posX = worm.posX
			targetworm.posY = worm.posY
			worm.posX = ax
			worm.posY = ay
		else
			targetworm = CTaskWorm_CastCTask(targetworm)
			worm = CTaskWorm_CastCTask(worm)
			addWormHp(targetworm.unknownFC,targetworm.wormnumber,getWormHp(worm.unknownFC,worm.wormnumber))
			addWormHp(worm.unknownFC,worm.wormnumber,-getWormHp(worm.unknownFC,worm.wormnumber))
		end
		addentanim(worm,customsprite,100,false)
		addentanim(targetworm,customsprite,100,false)
		pendsound = customsoundtele
		
		if (structure.name1 == "Teletransparacaidas") then
			pendchute = true
			--CGameTask_CastCTask(worm).state = WormState_PARACHUTE
			--FireWeapon(worm,getWeaponData(Weapon_Parachute),dummylaunchparams)
			--CGameTask_CastCTask(worm).state = WormState_PARACHUTE
			
		elseif (not godworm) then
			pendskipgo = worm.wormnumber
		end
		idletimer = 1  
	end
end

--direction: -1, angle:65527 ==> angleX: 0 ,angleY: -65536
--direction: 1, angle:65527 ==> angleX: 0 ,angleY: -65536
--direction: -1, angle:33268 ==> angleX: -65516 ,angleY: -1608
--direction: -1, angle:16893 ==> angleX: -47464 ,angleY: 45189
--direction: -1, angle:0 ==> angleX: 0 ,angleY: 65536
--direction: -1, angle:65527 ==> angleX: 0 ,angleY: -65536
--direction: 1, angle:34815 ==> angleX: 65220 ,angleY: -6423
--direction: -1, angle:34812 ==> angleX: -65220 ,angleY: -6423
--direction: -1, angle:32763 ==> angleX: -65536 ,angleY: 0
--direction: -1, angle:65527 ==> angleX: 0 ,angleY: -65536
--direction: -1, angle:65527 ==> angleX: 0 ,angleY: -65536
--direction: -1, angle:45052 ==> angleX: -54491 ,angleY: -36409
--direction: -1, angle:22013 ==> angleX: -57022 ,angleY: 32302
--direction: -1, angle:28668 ==> angleX: -64276 ,angleY: 12785


function weapcall(worm, weapon, params)
	--displayTransmissionText("Imaik (")
	--PrintStuff(worm)
	--PrintStuff(params)
		--io.write("-----------\n")
	--local num = getNumObjects(ClassType_Task_Worm)
		--for i=1,num,1 do
			--local tworm = CGameTask_CastCTask(getObject(ClassType_Task_Worm,i))
			--tworm.posX = worm.posX
			--tworm.posY = worm.posY
			--io.write("WormId:" .. CTaskWorm_CastCTask(getObject(ClassType_Task_Worm,i)).unknownFC .. "\n")
			--io.write("WormId:" .. CGameTask_CastCTask(getObject(ClassType_Task_Worm,i)).posX/65536 .. ",".. CGameTask_CastCTask(getObject(ClassType_Task_Worm,i)).posY/65536 .. "\n")
		--end

	--worm.unknown10C = 2 --worm color
	
	if (not godworm) and isenemyultimo(worm.unknownFC) and (ultimoblock[worm.unknown170]) then
		--showChatMessage(weapon.name2 .. "(" .. worm.unknown170 .. ")--" .. tostring(isenemyultimo(worm.unknownFC)) .. "fire in your asshole//" .. tostring(ultimoblock[worm.unknown170]) .. "/" .. worm.wormnumber, 2)
		--setTeamAmmo(worm.unknownFC,worm.unknown170,0,getTeamAmmo(worm.unknownFC,worm.unknown170,0)+1)
		return 1
	end
	
		if (worm.unknown170 == Weapon_Kamikaze) then
			for i=1,3,1 do
				local rand = math.random(1,#customweapons)
				setTeamAmmo(worm.unknownFC,customweapons[rand],0,getTeamAmmo(worm.unknownFC,customweapons[rand],0)+1)
			end
		end
		if worm.unknown170 == Weapon_SelectWorm then
			godblock = true
		end
	 
		if not godworm then
			if oneperturn[worm.unknown170]  then
				for i,e in pairs(oneperturn) do
					setTeamAmmo(worm.unknownFC,i,1,1)
				end
			end
			if (worm.unknown170 == Weapon_JetPack)  then
				for i,e in pairs(blockjetpack) do
					setTeamAmmo(worm.unknownFC,i,1,1)
				end
				pendskipgo = worm.wormnumber
				idletimer = 0
			end
			
			if worm.unknown170 == Weapon_Teleport then
				for i,e in pairs(weapons) do
						setTeamAmmo(worm.unknownFC,i,1,1)
				end
				pendskipgo = worm.wormnumber
			end
			
			if blockattacks[worm.unknown170]  then
				for i,e in pairs(weapons) do
					if not blockattacks[i] then
						setTeamAmmo(worm.unknownFC,i,1,1)
					end
				end
			end
		end
	--PrintWeapon(weapon)
	
	
	--for i,e in pairs(WeaponStruct) do
		--io.write("YOOOO:" .. i .. ": " .. tostring(e) .. " \n", 2)
	--end
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
--sender.unknown14 = 1; --shots
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
end


local noworms = {}
local nowormsdef = {}
local ultwarn = {}
noworms[0] = 0
noworms[1] = 0
noworms[2] = 0
noworms[3] = 0
noworms[4] = 0
noworms[5] = 0
noworms[6] = 0

function ResetStuff()
	noworms[0] = 0
	noworms[1] = 0
	noworms[2] = 0
	noworms[3] = 0
	noworms[4] = 0
	noworms[5] = 0
	noworms[6] = 0
	ultwarn = {}
end

--g Afano de Mike

function stealcandidate(teamnumber)
	for i=1,#stealpriority,1 do
		local target = stealpriority[i]
		if type(target) == "string" then
			target = customweaponsbyname[target]
		end
		if (not godworm) and ultwarn[teamnumber] and ((ultimoblock[target]) and (not customblockwhitelist[target])) then
		
		else
			if (getTeamAmmo(teamnumber,target,0) > 0) then
				return target
			end
		end
	end
	return Weapon_Prod
end


local function normalize(dx, dy)
    local mag = math.sqrt(dx * dx + dy * dy)
    return dx / mag, dy / mag
end

local currteam = nil

local magnets = {}
local repeltimers = {}
local repelmode = true
local renderflipflop = true

function countelems(ar)
local count = 0
	for i,e in pairs(ar) do
		count = count + 1
	end
	return count
end

function getRepelTimer(mag,this,update)
	local addr = this:getAddr()
	local magaddr = mag:getAddr()
	if not repeltimers[magaddr] then
		repeltimers[magaddr] = {}
	end
	if not repeltimers[magaddr][addr] then
		repeltimers[magaddr][addr] = 0
	end
	if update then
		repeltimers[magaddr][addr] = repeltimers[magaddr][addr] + update
	end
	return repeltimers[magaddr][addr]
end

local norepelmissiles = {}
norepelmissiles[55] = true --petrol
norepelmissiles[63] = true --carpet
norepelmissiles[64] = true --frenchsheep
norepelmissiles[65] = true --sheeplauncher
norepelmissiles[82] = true --donkey
norepelmissiles[72] = true --mail
norepelmissiles[74] = true --vase
norepelmissiles[153] = true --sheep
norepelmissiles[166] = true --mole
norepelmissiles[162] = true --granny
norepelmissiles[163] = true --sally
norepelmissiles[164] = true --cow
norepelmissiles[173] = true --skunk
norepelmissiles[175] = true --pidgeon
norepelmissiles[Sprite_moledive] = true 
norepelmissiles[Sprite_moledig1] = true 
norepelmissiles[Sprite_moledig2] = true 
norepelmissiles[Sprite_moledig3] = true 
norepelmissiles[Sprite_lshpwlk] = true  --this is the mole strike.....yea, I dont know either

function repelprojs(ent,repelForce,repelRadius)
	norepelmissiles[equino_sprite] = true 
	
	local this = CGameTask_CastCTask(ent)
	local repelstuff = {ClassType_Task_Missile,ClassType_Task_Mine}
	for _,clas in pairs(repelstuff) do
	local num = getNumObjects(clas)
		for i=1,num,1 do
			local thing = CGameTask_CastCTask(getObject(clas,i))	
			local dist = distance(this.posX,this.posY,thing.posX,thing.posY)
			--io.write((dist / 65536) .. "\n")
			if ((dist / 65536) < repelRadius) and ((dist / 65536) > (2)) then
				if (getRepelTimer(this,thing,1) > 300) or ((clas == ClassType_Task_Mine) and ((CTaskMine_CastCTask(thing).fusetime == -6969) or (CTaskMine_CastCTask(thing).fusetime == -6971))) or ((clas == ClassType_Task_Missile) and (norepelmissiles[CTaskMissile_CastCTask(thing).LauncherStructure.sprite.spriteid]))  then
					--magnetized
				else
					--io.write(CTaskMissile_CastCTask(thing).LauncherStructure.sprite.spriteid .. "-Missiletype \n")
					--io.write("magnetize amt: (".. getRepelTimer(this,thing) .. ") \n")
					local dx, dy = thing.posX - this.posX, thing.posY - this.posY
					local ndx, ndy = normalize(dx, dy)
					
					thing.speedX = (thing.speedX + ndx * repelForce * (dist-repelRadius) / repelRadius)  --*0.9 --adding some decay to avoid some annoying infinite bounces
					thing.speedY = (thing.speedY + ndy * repelForce * (dist-repelRadius) / repelRadius)  --*0.9 --adding some decay to avoid some annoying infinite bounces
					
					if ((thing.speedX == 0) and (dx == 0) and (thing.speedY > 0)) or (clas == ClassType_Task_Mine) then
						getRepelTimer(this,thing,3) -- advance it faster so it doesnt keep balancing the thing forever
					end
				end
			end
		end
	end
end

function depleteMagnets()
	for i,e in pairs(magnets) do
		e.turnsleft = e.turnsleft -1
		if e.turnsleft == 0 then
			clearentanims(i)
		end
	end
end

function getMagData(mag)
	local addr = CGameTask_CastCTask(mag):getAddr()
	if not magnets[addr] then
		magnets[addr] = {}
		magnets[addr].frame = 0
		magnets[addr].hp = 60
		magnets[addr].prevxspeed = 0
		magnets[addr].prevyspeed = 0
		magnets[addr].turnsleft = 11
		io.write("----- NEW MAGNET: " .. countelems(magnets) .. " ------ \n")
	end
	return magnets[addr]
end

function damageMagnets(posx, posy, sender, pushforce, power, a6, team)
	local apowa = power
	--io.write(posx .. " y:" .. posy .. " f:" .. pushforce .. " p:" .. power .. " a:" .. a6 .. " t:" .. team .. "\n")
	local num = getNumObjects(ClassType_Task_Mine)
		for i=1,num,1 do
			power = apowa
			local mag = CGameTask_CastCTask(getObject(ClassType_Task_Mine,i))
			if (CTaskMine_CastCTask(mag).fusetime == -6969) or (CTaskMine_CastCTask(mag).fusetime == -6971) then
				local data = getMagData(mag)
				local dist = distance(posx,posy,mag.posX,mag.posY)
				
				power = (1.0-(dist/ 65536)/(power*2)) * power --its not 1-1 because this is a magnet, not a worm (its a feature, I swear)
				
				if (power > 0) and ((apowa ~= 30) or (math.abs(mag.ropeanchorY - damagedspmaag) > 55)) then 
					mag.ropeanchorY = damagedspmaag
					data.hp = data.hp - power
					io.write("MagnetDamage: " .. (power) ..  "(left: " .. data.hp .. ") \n")
				end
			end
		end

end

function damageSentrys(posx, posy, sender, pushx,pushy, power, a6, team)
	local apowa = power
	--io.write(posx .. " y:" .. posy .. " f:" .. pushforce .. " p:" .. power .. " a:" .. a6 .. " t:" .. team .. "\n")
	local num = getNumObjects(ClassType_Task_OilDrum)
		for i=1,num,1 do
			local This = CTaskOildrum_CastCTask(getObject(ClassType_Task_OilDrum,i))
			if (getCompactedA(This.unknown10C) > 60)  then
				power = apowa
					--local data = getMagData(mag)
					local dist = distance(posx,posy,This.posX,This.posY + (3 * posmult))
					
					power = (1.0-(dist/ 65536)/(power*2)) * power --its not 1-1 because this is a magnet, not a worm (its a feature, I swear)
					
					if (power > 0) and ((apowa ~= 30) or(math.abs(This.ropeanchorY - damagedspmaag) > 55)) then 
						This.ropeanchorY = damagedspmaag
						This.numberofropesegments = This.numberofropesegments - power						
						if pushy ~= 0 then
							This.speedX = pushx
							This.speedY = pushy
						end
						io.write("SentryDamage: " .. (power) ..  "(hp: " .. This.numberofropesegments .. ") // " .. sender:getAddr() .. " // " .. apowa .. "  \n")
					end
			end
		end

end

function mine(This, sender, messagetype, psize, params)
	--if currworm then
		--io.write("raymine:" .. checkObjectCollision(This,This.posX / posmult,This.posY/ posmult,convertAngleX(currworm.shootingangle,currworm.facingdirection),convertAngleY(currworm.shootingangle),2000,CollisionFlag_DEFAULT) .. "\n")
	--end
	--This.unknown104 = 1 --active
	--This.unknown128= 1 --triggered
	--This.unknown118 = 0 --timer
	--This.unknownFC = 155
	--PrintStuff(CGameTask_CastCTask(This))
	--CGameTask_CastCTask(This).unknown30 = 10 --punchability/collision?
	--changeTracker(CGameTask_CastCTask(This))
	--This.unknownF0= 1
	
	--unknown190changed from 58986 to 0
	--This.unknownF0= 2
	
--if (messagetype == TaskMessage_SpecialImpact) then --SpecialImpact only triggers when the thing is actually damaged which is nice
		--This.speedY = -990000
		--return 1
	--end
	if (CTaskMine_CastCTask(This).unknown118 == -6868) then --sticky
		This.unknown104 = 0 --active
		This.unknown128= 0 --triggered
		CGameTask_CastCTask(This).speedX = 0
		CGameTask_CastCTask(This).airborne = 0
		CGameTask_CastCTask(This).state = 0
		--PrintStuff (CGameTask_CastCTask(This))
		--Sound_MineImpact
		if (messagetype == TaskMessage_RenderScene) then
			drawSpriteLocal(This.posY+ (65536 * 5),1000,This.posX - (65536 * 2),Sprite_smklt25,1)
		end
		
		local num = getNumObjects(ClassType_Task_Worm)
		for i=1,num,1 do
			local thing = CGameTask_CastCTask(getObject(ClassType_Task_Worm,i))	
			local dist = distance(This.posX,This.posY,thing.posX,thing.posY)
			--io.write((dist / 65536) .. "\n")
			if ((dist / 65536) < 12) then
				if (CGameTask_CastCTask(thing).state == WormState_JUMP) then --sticky
					thing.speedX = 0
					thing.speedY = 0
				end
			end
		end
		return 1
	end
	
	
	
	if (CTaskMine_CastCTask(This).fusetime == -6969) or (CTaskMine_CastCTask(This).fusetime == -6971) then --magnets
		local data = getMagData(This)
		local task = CGameTask_CastCTask(This)
		if (messagetype == TaskMessage_RenderScene) then
			if (data.turnsleft <= 0) or (CGameTask_CastCTask(This).unknownB0 == 1) then
				drawSpriteLocal(This.posY,1000,This.posX,magnetd_sprite,math.floor(data.frame)*1000)
			elseif (CTaskMine_CastCTask(This).fusetime == -6971) then
				drawSpriteLocal(This.posY,1000,This.posX,magnetr_sprite,math.floor(data.frame)*1000)
			else
				drawSpriteLocal(This.posY,1000,This.posX,magnet_sprite,math.floor(data.frame)*1000)
			end
			return 1
		end
		if (messagetype == TaskMessage_FrameStart) then
			local speed = task.speedX
			local abs = math.abs(speed)
			local amount = 1
			if abs > 246000 then --firepunch push
				amount = 2.5
			elseif abs > 206000 then
				amount = 2
			elseif abs > 106000 then
				amount = 1
			else
				amount = 0.5
			end
			
			if speed < 0 then
				data.frame = data.frame -amount
			elseif speed > 0 then
				data.frame = data.frame +amount
			end
			if data.frame< 0 then
				data.frame= 36 - (math.abs(data.frame) - 36)
			end
			if data.frame > 36 then
				data.frame = 0 + (data.frame - 36)
			end
			
			if data.turnsleft > 0 then
				if (CTaskMine_CastCTask(This).fusetime == -6971) then
					repelprojs(This,-5,150) -- 1.5 150 is nice but airstrike still hits
				else
					repelprojs(This,5,150) -- 1.5 150 is nice but airstrike still hits
				end
			end
			
			
			if (data.prevxspeed == 0) and (task.speedX ~= 0) then
				task.speedX = task.speedX * 0.3
			end
			data.prevxspeed = task.speedX
			if (data.prevyspeed == 0) and (task.speedY ~= 0) then
				task.speedY = task.speedY * 0.3
			end
			data.prevyspeed = task.speedY
			--This.unknownFC = 0
			
			if (CGameTask_CastCTask(This).unknownB0 == 1) then --hit the water
				local addr = task:getAddr()
				clearentanims(addr)
				repeltimers[addr] = nil
			elseif (data.hp <= 0) then
				local addr = task:getAddr()
				This.active = 1 --active
				This.triggered= 1 --triggered
				This.fusetime = 0 --timer
				clearentanims(addr)
				magnets[addr] = nil
				repeltimers[addr] = nil
			end
		end
	end
	
end



function getDirection(x1, y1, x2, y2)
    -- Calculate the difference between the points
    local dx = x2 - x1
    local dy = y2 - y1
    
    -- Calculate the magnitude of the vector
    local magnitude = math.sqrt(dx * dx + dy * dy)
    
    -- Avoid division by zero
    if magnitude == 0 then
        return 0, 0
    end
    
    -- Normalize the vector to range [-1, 1]
    local dirX = dx / magnitude
    local dirY = dy / magnitude
    
    return dirX, dirY
end

function SetDummyWorm(worm,launchparams)
worm.posX=7897088
worm.posY=33882112
--if true then return end
worm.unknown28C = 1
worm.unknown214 = 0
worm.unknown254 = 0
worm.unknown2EC = 0
worm.unknown3A4 = 1
worm.unknown30C = 0
worm.unknown3E0 = 0
worm.unknown36C = getWeaponData(Weapon_Shotgun)
worm.facingdirection = 1
worm.unknown188 = 0
worm.unknown3B4 = 0
worm.unknown348 = 0
worm.unknown3D8 = 32763
worm.unknown21C = 0
worm.unknown270 = 32763
worm.unknown1F0 = 0
worm.unknown1C0 = 0
worm.unknown138 = 0
worm.unknown1C8 = 0
worm.canfire = 1
worm.unknown300 = 1836009472
worm.unknown294 = 1
--worm.unknown364 = 365642280
worm.unknown23C = 0
worm.unknown324 = 0
worm.unknown194 = 0
worm.unknown33C = 0
worm.unknown250 = 0
worm.unknown238 = 0
--worm.unknown350 = 365627944
worm.unknown2AC = 0
worm.unknown2B8 = 0
worm.unknown280 = 0
worm.unknown2A4 = -1
worm.unknown1E8 = 0
worm.unknown2CC = 0
worm.unknown340 = 0
worm.unknown1C4 = 0
worm.hasnamearrow = 0
worm.unknown258 = 0
worm.unknown1E4 = 8388608
worm.unknown204 = 0
worm.unknown14C = 0
worm.unknown2BC = 2
worm.unknown170 = 11
worm.unknown234 = 0
--worm.__eq = function: 51948130
worm.unknown150 = 0
worm.unknown2C4 = 3
worm.unknown24C = 32768
worm.unknown1BC = 1
--worm.class_cast = userdata: 51A23060
worm.wormnumber = 1
worm.unknown13C = 0
worm.unknown228 = 0
worm.currweapentry = getWeaponData(Weapon_Shotgun)
--worm.__newindex = function: 050FE518
worm.unknown314 = 48
worm.unknown154 = 1
worm.unknown3F8 = 0
worm.unknown1D4 = 0
worm.unknown2E0 = 62914560
worm.unknown3F4 = 0
worm.unknown220 = 0
worm.unknown31C = 0
worm.unknown274 = 4328646
worm.unknown108 = 0
worm.unknown25C = 0
worm.unknown190 = 138446
worm.unknown3EC = 0
worm.unknown388 = 1430
worm.unknown3E8 = 0
worm.unknown380 = 1430
worm.unknown288 = 1
worm.unknown290 = 1
worm.unknown3DC = 1
worm.unknown224 = 0
worm.unknown3D4 = 65527
--worm.unknown35C = 365639048
--worm.__pairs = function: 519658F0
worm.unknown158 = 1015
worm.unknown3CC = 0
worm.unknown3C8 = 0
worm.unknown27C = 0
worm.unknown3C4 = 0
--worm.unknown3C0 = 365643624
worm.unknown3BC = 866
worm.unknown2FC = 0
worm.unknown2A8 = 0
worm.unknown3B0 = 0
worm.unknown34C = 255
worm.unknown100 = 1
worm.color = 0
worm.unknown264 = 0
worm.unknown3A8 = 0
worm.unknown15C = 0
worm.unknown328 = 0
worm.unknown384 = 0
worm.unknown398 = 0
worm.unknown140 = 0
worm.unknown180 = 0
worm.showname = 0
worm.unknown394 = 0
worm.unknown164 = 0
worm.unknown1A4 = 0
--worm.unknown360 = 365640664
worm.shownameslide = 0
worm.unknown38C = 0
worm.unknown11C = 0
worm.unknown3E4 = 0
worm.unknown39C = 0
worm.namearrowslide = 1430
worm.unknown334 = 0
worm.unknown2E8 = 0
worm.unknown37C = 0
worm.unknown378 = 1430
worm.unknown374 = 0
worm.unknown370 = 364273776
worm.unknown2D8 = 0
worm.unknown390 = 1430
worm.unknown148 = 0
worm.unknown3D0 = 785
worm.unknown12C = 0
worm.unknown1CC = 0
worm.unknown168 = 0
--worm.unknown354 = 365632824
worm.unknown198 = -21845
worm.unknown344 = 0
--worm.__index = function: 050FE378
worm.unknown330 = 0
worm.active = 1
worm.teamnumber = 1
worm.shootingangle = 32763
worm.unknown1B4 = 0
worm.unknown3A0 = 0
worm.unknown2C8 = 0
worm.unknown308 = 0
worm.unknown320 = 0
worm.unknown318 = 0
worm.unknown260 = 420
worm.unknown200 = 0
worm.unknown22C = 0
worm.unknown268 = 1
worm.unknown16C = 0
worm.unknown120 = 0
worm.unknown298 = 500
worm.unknown118 = 49
worm.unknown2F4 = 12576
worm.unknown17C = 6553600
worm.unknown114 = 544043631
worm.unknownF8 = 364560592
worm.unknown1B0 = 65536
worm.unknown29C = 1
worm.unknown2E4 = 22806528
worm.unknown1A8 = 1
worm.unknown2DC = 0
worm.unknownF4 = 1
worm.unknown124 = 0
--wormis.unknown368 = 365626544
worm.unknown2D4 = 0
worm.unknown1F4 = 0
worm.unknown2D0 = 0
worm.selectedweapon = 11
worm.unknown2C0 = 0
worm.unknown1EC = 0
worm.unknown1A0 = 0
worm.unknown2B4 = 234
worm.suspended = 0
worm.unknown3F0 = 0
worm.unknown3B8 = 16
worm.unknown134 = 0
worm.unknownFC = 1
--worm.unknown358 = 365637704
worm.unknown240 = 0
worm.unknown174 = -1
worm.unknown18C = 0
worm.unknown1FC = 0
worm.unknown26C = 65527
worm.unknown2B0 = 0
worm.unknown2F8 = 0
worm.unknown2A0 = 0
worm.unknown144 = 0
worm.unknown110 = 1459617892
worm.unknown208 = 0
worm.unknown32C = 0
worm.unknown284 = 1
worm.unknown3AC = 0
worm.unknown184 = 0
worm.unknown1E0 = 0
worm.unknown278 = 0
worm.unknown20C = 0
--worm.class_check = userdata: 51A230F0
worm.unknown1D0 = 0
worm.unknown160 = 0
worm.statecounter = 0
worm.unknown10C = 0
worm.unknown1B8 = 0
worm.unknown178 = 6553600
worm.unknown19C = 0
worm.unknown1DC = 0
worm.unknown338 = 0
worm.unknown248 = 0
worm.unknown244 = 0
worm.unknown310 = 808517632
worm.unknown230 = 0
worm.unknown1F8 = 65536
--worm.__name = sol.CTaskWorm*
worm.unknownF0 = 0
--worm.__type = table: 050E43F8
worm.unknown218 = 0
worm.unknown1AC = -1
worm.unknown304 = 7303781
worm.unknown1D8 = 0
worm.unknown2F0 = 1836216151
worm.unknown104 = 1
worm.unknown210 = 0
worm.unknown130 = 0
worm.unknown128 = 0

--launchparams.unknown4 = 500
--launchparams.unknown14 = 4332670
--launchparams.unknown10 = 0
--launchparams.unknown1C = 100
--launchparams.posx = 0
--launchparams.unknown8 = 0
--launchparams.unknown28 = 2
--launchparams.unknown24 = 0
--launchparams.unknownC = 1
--launchparams.unknown20 = 25
--launchparams.unknown18 = 5
--launchparams.offsety = 4332670
--launchparams.unknown0 = 1
--launchparams.offsetx = 0
--launchparams.posy = 1






launchparams.unknown14 = 0
launchparams.unknown8 = 7897088
launchparams.unknown0 = 1
launchparams.offsety = 0
launchparams.posx = 7897088
launchparams.unknown18 = 62914560
launchparams.unknown24 = 30
launchparams.unknown20 = 0
launchparams.unknown1C = 22806528
launchparams.unknown10 = 65536
launchparams.offsetx = 65536
launchparams.unknown28 = 3000
launchparams.posy = 33882112
launchparams.unknownC = 33882112
launchparams.unknown4 = 1

--worm.unknownF8 = 390600368
--worm.unknown100 = 2 --wormnumber
--worm.unknown35C = 391687136 --memdir
--worm.unknown354 = 391680912 memdir
--worm.unknown364 = 391693288 memdir
--worm.unknown360 = 391688752 memdir
--worm.unknown3C0 = 391695464 memdir
--worm.unknown358 = 391685792 -- mem dir
--worm.unknown350 = 391676032 -- mem dir
--worm.unknown368 = 391674632 --mem dir of some shit?
--worm.wormnumber = 2
end


function firebullet(worm)
	local range = 100000
	local dirx,diry = getDirection(posmult * 500, posmult * 500,posmult * 500 + 9000 ,posmult * 500 )
	--io.write("x:" .. dirx ..  " y:" .. diry .. "\n")
	
					bulletlaunchparams.unknown8= posmult * 500
					bulletlaunchparams.unknownC= posmult * 500
					bulletlaunchparams.unknown10 = range * dirx --xangle x range
					bulletlaunchparams.unknown14 = -1--range * diry --yangle x range
					--worm.unknown294= 1
					--local ax = worm.posX
					--local ay = worm.posY
					worm.posX = posmult * 500
					worm.posY = posmult * 500
					--worm.shootingangle = range * dirx
					--SetDummyWorm(worm,bulletlaunchparams)
					--FireWeapon(worm,getWeaponData(Weapon_Shotgun),bulletlaunchparams)
					--FireBulletProjectile(worm,bulletprojparams, bulletlaunchparams)
					FireBullet(worm,bulletlaunchparams)
end

function firebulletcall(This, projparams, launchparams)
	--PrintWeaponProjParams(projparams)
	--io.write("-------------START--------------------------")
	--io.write("posx:" .. currworm.posX)
	--io.write("posY:" .. currworm.posY)
	--PrintStuff(currworm)
	--io.write("----------------PPARAM-----------------------")
	--PrintStuff(projparams)
	--io.write("----------------LPARAM-----------------------")
	--PrintStuff(launchparams)
	--io.write("yeeehaw, partner")
	--PrintWeaponLaunchParams(launchparams)
	--if nextismagnet thend
		--nextismagnet= false
		--return 1
	--end
end

local stealpending = false
local teamweapondata = {}
function ResetTeamWeaponData (i)
	teamweapondata[i] = {}
	for j=0,900,1 do
		teamweapondata[i][j] = 0
	end
end

function RecordStealTeamWeaponData(i)
	ResetTeamWeaponData (i)
	for j=0, customweapons[#customweapons],1 do
		teamweapondata[i][j] = getTeamAmmo(i,j,0)
	end
end

function GiveStolenWeaponPreviews(i,y)
	ResetTeamWeaponData (i)
	for j=0, customweapons[#customweapons],1 do
		if teamweapondata[y][j] > 0 then
			setTeamAmmo(i,j,0,getTeamAmmo(i,j,0) + 1)
		end
	end
end

function ClearStolenWeaponPreviews(i,y,weapused)
	if stealpending then
		ResetTeamWeaponData (i)
		for j=0, customweapons[#customweapons],1 do
			if (teamweapondata[y][j] > 0) and (j ~= weapused) and (getTeamAmmo(i,j,0) > 0) then
				setTeamAmmo(i,j,0,getTeamAmmo(i,j,0) - 1)
			end
		end
		stealpending = false
	end
end

function InitSteal(i,y)
	stealpending = true
	RecordStealTeamWeaponData(y)
	GiveStolenWeaponPreviews(i,y)
end

function RecoverTeamWeaponData(i)
	for j=0, customweapons[#customweapons],1 do
		setTeamAmmo(i,j,0,teamweapondata[i])
	end
	ResetTeamWeaponData (i)
end

local wormdata = {}
function InitWormData()
	for i=0,255,1 do
		wormdata[i] = {}
	end
end
InitWormData()


WormState_IDLE = 103 -- idle on ground with gun out
WormState_WALK = 102 -- idle walk?
WormState_IDLE2 = 101 -- idle gunless
WormState_CHARGING = 104 -- idle gunless
WormState_FIRING = 105 -- idle gunless
WormState_FIRING_2 = 106 -- idle gunless
WormState_FIRING_3 = 107 -- idle gunless
WormState_DRILLING = 110
WormState_PREPARE_JUMP = 119
WormState_TELEPORTING = 111
WormState_FIRING_ROPE = 112
WormState_JUMPPREPARE = 119
WormState_JETPACK = 120
WormState_JUMP = 121
WormState_JUMPDOWN = 122
WormState_PARACHUTE = 125

local skipgostates = {}
skipgostates[WormState_IDLE2] = true
skipgostates[WormState_IDLE] = true
skipgostates[WormState_WALK] = true

local idlestates = {}
idlestates[WormState_IDLE2] = true
idlestates[WormState_IDLE] = true

local turretignorestates = {}
turretignorestates[WormState_IDLE2] = true
turretignorestates[WormState_IDLE] = true
turretignorestates[WormState_FIRING] = true
turretignorestates[WormState_FIRING_2] = true
turretignorestates[WormState_FIRING_3] = true
turretignorestates[WormState_CHARGING] = true
turretignorestates[WormState_PREPARE_JUMP] = true
turretignorestates[WormState_FIRING_ROPE] = true
turretignorestates[WormState_TELEPORTING] = true

--stolen from PX
CollisionFlag_UNUSED0			= 1;
	CollisionFlag_TERRAIN			= 2;
	CollisionFlag_WORM_ON_TERRAIN	= 4;
	CollisionFlag_WORM_USING_WEAPON	= 8;
	CollisionFlag_WORM_IN_MIDAIR	= 16;
	CollisionFlag_WORM_ON_ROPE		= 32;
	CollisionFlag_WORM_FROZEN		= 64;
	CollisionFlag_UNUSED7			= 128;
	CollisionFlag_KAMIKAZE			= 256;
	CollisionFlag_GASCANISTER		= 512;
	CollisionFlag_MINE				= 1024;
	CollisionFlag_CRATE				= 2048;
	CollisionFlag_DONORCARD			= 4096;
	CollisionFlag_GRAVESTONE		= 8192;
	CollisionFlag_UNUSED14			= 16384;
	CollisionFlag_OTHERWEAPON		= 32768;
	CollisionFlag_ARROW				= 65536;
	CollisionFlag_OILDRUM			= 131072;
	CollisionFlag_UNUSED18			= 262144;
	CollisionFlag_UNUSED19			= 524288;
	CollisionFlag_UNUSED20			= 1048576;
	CollisionFlag_UNUSED21			= 2097152;
	CollisionFlag_SKIMMING			= 4194304;
	CollisionFlag_UNUSED23			= 8388608;
	CollisionFlag_UNUSED24			= 16777216;
	CollisionFlag_UNUSED25			= 33554432;
	CollisionFlag_UNUSED26			= 67108864;
	CollisionFlag_UNUSED27			= 134217728;
	CollisionFlag_UNUSED28			= 268435456;
	CollisionFlag_UNUSED29			= 536870912;
	CollisionFlag_UNUSED30			= 1073741824;
	CollisionFlag_DEFAULT =   CollisionFlag_TERRAIN
								| CollisionFlag_WORM_ON_TERRAIN
								| CollisionFlag_WORM_USING_WEAPON
								| CollisionFlag_WORM_IN_MIDAIR
								| CollisionFlag_WORM_ON_ROPE
								| CollisionFlag_WORM_FROZEN
								| CollisionFlag_CRATE
								| CollisionFlag_DONORCARD
								| CollisionFlag_OILDRUM
								| CollisionFlag_SKIMMING
	CollisionFlag_WORM = CollisionFlag_WORM_ON_TERRAIN
								| CollisionFlag_WORM_USING_WEAPON
								| CollisionFlag_WORM_IN_MIDAIR
								| CollisionFlag_WORM_ON_ROPE
								| CollisionFlag_WORM_FROZEN


	Layer_UNUSED0			= 0;
	Layer_TERRAIN			= 1;
	Layer_WORM_ON_TERRAIN	= 2;
	Layer_WORM_USING_WEAPON	= 3;
	Layer_WORM_IN_MIDAIR	= 4;
	Layer_WORM_ON_ROPE		= 5;
	Layer_WORM_FROZEN		= 6;
	Layer_UNUSED7			= 7;
	Layer_KAMIKAZE			= 8;
	Layer_GASCANISTER		= 9;
	Layer_MINE				= 10;
	Layer_CRATE				= 11;
	Layer_DONORCARD			= 12;
	Layer_GRAVESTONE		= 13;
	Layer_UNUSED14			= 14;
	Layer_OTHERWEAPON		= 15;
	Layer_ARROW				= 16;
	Layer_OILDRUM			= 17;
	Layer_UNUSED18			= 18;
	Layer_UNUSED19			= 19;
	Layer_UNUSED20			= 20;
	Layer_UNUSED21			= 21;
	Layer_SKIMMING			= 22;
	Layer_UNUSED23			= 23;
	Layer_UNUSED24			= 24;
	Layer_UNUSED25			= 25;
	Layer_UNUSED26			= 26;
	Layer_UNUSED27			= 27;
	Layer_UNUSED28			= 28;
	Layer_UNUSED29			= 29;
	Layer_UNUSED30			= 30;


local jumpdelayframes = 0

function handledoublejump(worm)
	--Jump Y F -255384 B -294912
	--io.write("state: " .. CGameTask_CastCTask(worm).state =  .. "\n")
	if djumpon and (worm.active == 1) then
      local wormstate = CGameTask_CastCTask(worm).state
		if ((wormstate == WormState_JUMP) or (wormstate ==WormState_JUMPDOWN)) then
			jumpdelayframes = jumpdelayframes +1
		else
			jumpdelayframes = 0
		end
	  
                   if (((getKeyState(13) & 0x8000) ~= 0) or ((getKeyState(8) & 0x8000) ~= 0)) and ((wormstate == WormState_JUMP) or (wormstate ==WormState_JUMPDOWN)) and (jumpdelayframes > 5) then
						CGameTask_CastCTask(worm).state = WormState_JUMPPREPARE
						worm.unknown164 = 0
						worm.speedY = -255384
						--addanim(CGameTask_CastCTask(worm).posX,CGameTask_CastCTask(worm).posY,Sprite_smkdrk20,160).Step = 1
						Doublejump = false
                   end
                   if	(wormstate == WormState_IDLE) then
						Doublejump = true
				   end
		--end
	end
end

local playindrill = 50
local drillframe = 0
local gavedrill = false
local jetuziframe = 30
local jetoff = 30
local jetfired = false

function attsearch ()
	local allclasses = {ClassType_None,
		ClassType_Task,
		ClassType_GameTask,
		ClassType_GameCollisionTask,
		ClassType_Task_Control,
		ClassType_Task_Game,
		ClassType_Task_TurnGame,
		ClassType_Task_Filter,
		ClassType_Task_Mine,
		ClassType_Task_Canister,
		ClassType_Task_Team,
		ClassType_Task_Missile,
		ClassType_Task_Arrow,
		ClassType_Task_Animation,
		ClassType_Task_Dirt,
		ClassType_Task_Crate,
		ClassType_Task_Flame,
		ClassType_Task_AirStrike,
		ClassType_Task_Worm,
		ClassType_Task_OldWorm,
		ClassType_Task_Drill,
		ClassType_Task_Cross,
		ClassType_Task_Smoke,
		ClassType_Task_Cloud,
		ClassType_Task_Fire,
		ClassType_Task_Gass,
		ClassType_Task_FireBall,
		ClassType_Task_SeaBubble,
		ClassType_Task_Land,
		ClassType_Task_ScoreBubble,
		ClassType_Task_OilDrum,
		ClassType_Task_CPU,
		ClassType_SpriteAnimation,
		ClassType_CollisionManager,
		ClassType_MAX}

	for x,e in pairs(allclasses) do
	 local num = getNumObjects(e)
					local targetworm 
					local mindist
					for i=1,num,1 do
						local tworm = CGameTask_CastCTask(getObject(e,i))	
						local did = false
						if CGameTask_CastCTask(tworm).unknown34 ~= 0 then
								io.write( "/" .. e ..":" .. CGameTask_CastCTask(tworm).unknown34 .. "\n")
								CGameTask_CastCTask(tworm).unknown34 = 0
								--This.ropeanchorX = This.ropeanchorX  + (1 * posmult) 
								did = true
						end
						if did then
							io.write( "////////////////////\n")
						end
					end
	end
end



function animation(This, sender, messagetype, psize, params)
		if messagetype == TaskMessage_CreateAnimation then
			--if params[8] == Sprite_shotcase then
				--PrintStuff(This)
		--		PrintStuff(getWeaponData(Weapon_Shotgun):GetExtraData())
		--		for i=1,100,1 do
		--			io.write("[" .. i .. "]" .. params[i] .. "\n")
		--		end
			--end
		end
		

end

function worm(This, sender, messagetype, psize, params)	
	
	
	
	
	
	--PrintStuff(This)
	--io.write("1aC:" .. This.unknown1AC .. " a4:" .. This.unknown1A4 .. "\n")
	--CGameTask_CastCTask(This).airspeedmult = 65536 * 1.5
	--unknownD4 unused?
	--attsearch ()
	--worm colflags = 4328646 -- all but no water = 137342
	--if CGameTask_CastCTask(This).state == WormState_JETPACK then
		--CGameTask_CastCTask(This).unknown34 = CollisionFlag_OILDRUM
	--end
	--if CGameTask_CastCTask(This).unknown34 ~= 0 then
		--						io.write(  CGameTask_CastCTask(This).unknown34 .. "\n")
								--CGameTask_CastCTask(This).unknown34 = 0
								--This.ropeanchorX = This.ropeanchorX  + (1 * posmult) 
			--			end
			
	local wormid = (This.unknownFC * 10) + This.wormnumber
	if pendsound then
		playSoundLocal(0x10000, 0x10000, This, pendsound, 8)
		pendsound = nil
	end
	
	--drawSpriteLocal(This.posY,1,This.posX,customsprite,2)
	--if not wormdata[wormid].cloud then
		--wormdata[wormid].cloud = true
		--addentanim(This,customsprite,100,false) --customsprite
	--end
	--if This.active == 1 then
		--io.write(This.facingdirection .. "\n")
	--end
	--This.showname = 65536 
	--This.unknown38C = 0 
	--This.unknown390 = 0 
	--This.unknown378 = 0 
	--This.unknown37C = 0 
	--This.hasnamearrow = 65536 
	--This.unknown384 = 65536 
	if (This.active == 1) then
		--io.write("ee:" .. This.facingdirection .. "," .. This.shootingangle .."\n")
		--io.write("rayland:" .. checkLandCollision(This.posX,This.posY,convertAngleX(This.shootingangle,This.facingdirection),convertAngleY(This.shootingangle),2000) .. "\n") --lowest closest
		--io.write("rayman:" .. checkObjectCollision(This,This.posX / posmult,This.posY/ posmult,convertAngleX(This.shootingangle,This.facingdirection),convertAngleY(This.shootingangle),2000,CollisionFlag_DEFAULT) .. "\n") --lowest closest
		
		--turretdebug
		--local targetangle = This.shootingangle
		--local targetdir = This.facingdirection
		--
		--local ax = convertAngleX(targetangle,targetdir)
		--local ay = convertAngleY(targetangle)
		--local rayland = checkLandCollision(This.posX,This.posY,ax,ay,2000)
		--local rayman = checkObjectCollision(This,This.posX / posmult,This.posY/ posmult,ax,ay,2000,CollisionFlag_DEFAULT | CollisionFlag_MINE)
		----io.write("rayland:" .. rayland .. "\n") --lowest closest
		----io.write("rayman:" .. rayman .. "\n") --lowest closest
		--if (rayland > 0) or (rayman > 0) then
		--	local hit = rayland
		--	if (rayman > 0) and (rayman < rayland) then 
		--		hit = rayman 
		--	end
		--	drawSpriteLocal(This.posY + (ay * (hit) - (posmult * 10)),1000,This.posX + (ax * (hit)),Sprite_cursorr,0)
		--	if targetdir < 0 then
		--		drawSpriteLocal(This.posY,1,This.posX,turretspr[1] ,(((((targetangle) * 180)) /(posmult * 9.5))) * 3300)
		--		if (getKeyState(0x5A) & 0x8000) ~= 0 then
		--			drawSpriteLocal(This.posY,2,This.posX,turretfire ,(((((targetangle) * 180)) /(posmult * 9.5))) * 3300)
		--		end
		--	else
		--		drawSpriteLocal(This.posY,1,This.posX,turretspr[1] | flipsprite,(((targetangle * 180) /(posmult * 9.5))) * 3300)
		--		if (getKeyState(0x5A) & 0x8000) ~= 0 then
		--			drawSpriteLocal(This.posY,2,This.posX,turretfire | flipsprite,(((targetangle * 180) /(posmult * 9.5))) * 3300)
		--		end
		--	end
		--	drawSpriteLocal(This.posY,3,This.posX,turretstand ,1)
		--	
		--	if (messagetype == TaskMessage_UpdateNonCritical) and (getKeyState(0x5A) & 0x8000) ~= 0 then
		--		--createExplosion(This,This.posX + (ax * (hit)) , This.posY + (ay * (hit)), 100, 5, 1, 1)
		--		--createSpecialImpact(This, posX, posY, radiusX, radiusY, power, pushX, pushY, type_a9, soundOnHit, spriteOnHit, collisionMask, a13)
		--		--SpecialImpact: posX: 516 posY: 142 radiusX: 16 radiusY: 16 power: 5 pushX: FFFDAAAB pushY: FFFFFE39 type_a9: 3 soundOnHit: 0 spriteOnHit: 0 collisionMask: 138316 a13: 0
		--		createSpecialImpact(This, This.posX + (ax * (hit)), This.posY + (ay * (hit)), 16 * posmult, 16* posmult, 5, ax, ay, 3, 0, 0, CollisionFlag_DEFAULT | CollisionFlag_MINE, 0) --fake uzi push
		--		writeLandRadius(5,(This.posX + (ax * (hit))) / 65536, (This.posY + (ay * (hit))) / 65536) --fake uzi hole
		--		createSmoke(This.posX + (ax * (hit)),This.posY + (ay * (hit)),5,2)				
		--		playSoundLocal(0x10000, 0x10000, This, Sound_UziFire, 8)
		--		if math.random(-10,10) == 0 then
		--			playSoundLocal(0x10000, 0x10000, This, Sound_Ricochet, 8)
		--		end
		--		--smoke 422524344 5 80767856 4115010 5
		--		--writeLandRadius: radius: 5 posx: 1544 posy: 498
		--	end
		--	--focusCamera(This.posX + (ax * (hit)),This.posY + (ay * (hit) - (posmult * 10))) 
		--	--setCameraTracker(This.posX + (ax * (hit)),This.posY + (ay * (hit) - (posmult * 10)),1) 
		--end
		--turretdebug end
		
		--FireWeapon(This,getWeaponData(Weapon_Parachute),dummylaunchparams)
		--changeTracker(This)
		if pendchute then
			if This.selectedweapon ~= Weapon_Parachute then
				selectWeapon(This,Weapon_Parachute,1)
				--pendchute = false
			end
			if CGameTask_CastCTask(This).state == WormState_PARACHUTE then
				pendchute = false
				pendchuteskip = true
			else
				This.speedY = posmult * 8
			end
		end
		if pendchuteskip and  CGameTask_CastCTask(This).state ~= WormState_PARACHUTE then
			pendskipgo = This.wormnumber
		end
		--if (messagetype == TaskMessage_UpdateNonCritical)  then
		--	if (getKeyState(0x5A) & 0x8000) ~= 0 then
		--		firebullet(This)
		--	end
		--end
		currworm = This
		--PrintStuff(This)
		--This.unknown35C = 0 --memdir suspect (sprite?)
		--This.unknown368 = 0 --memdir suspect
		--This.unknown364 = 0 --memdir suspect(no crash tho)
		--This.unknown358 = This.unknown368 --memdir suspect(jetpack sprite?!)
		--PrintStuff(This.unknownDC)
		if jetoff > 0 then
			jetoff = jetoff-1
		end
		if hookpack then
			hookpackworm = This
			if (messagetype == TaskMessage_FrameStart) then 
				if jethookblock then
					jethookblock = jethookblock- 1
					if jethookblock <= 0 then
						jethookblock = nil
					end
				end
				if (not jethooked) and (not jethookblock) then
					local num = getNumObjects(ClassType_Task_Worm)
					local targetworm 
					local mindist
					for i=1,num,1 do
						local tworm = CGameTask_CastCTask(getObject(ClassType_Task_Worm,i))
						--io.write("-"..jump_info.unknown18.."-"..jump_info.unknown1C.."-----"..tworm.posX.."-"..tworm.posY.."---("..distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY)..")\n")
						local dist = distance(This.posX,This.posY + (40 * posmult),tworm.posX,tworm.posY)
						if (not mindist) or ((dist < mindist) and (dist > 0)) then
							mindist = dist
							targetworm = tworm
						end
					end
					if mindist < (15 * posmult) then
						jethooked = targetworm
					end
				elseif jethooked and distance(This.posX,This.posY + (40 * posmult),jethooked.posX,jethooked.posY) > (15 * posmult) then
					jethooked = nil
				end
				if jethooked then
					jethooked.speedX = This.speedX
					jethooked.speedY = This.speedY
				end
			end
			hookpack = CGameTask_CastCTask(This).state == WormState_JETPACK
			hookpackstarted = hookpack
			if not hookpack then
				jethooked = nil
				jethookblock = nil
				hookpackworm = nil
			end
		end
		if uzipack then
			--if (messagetype == TaskMessage_RenderScene) then
			--167
				--if This.facingdirection > 0 then
					--drawSpriteLocal(This.posY,1,This.posX,wjetgun_sprite | flipsprite,1)
				--else
					--drawSpriteLocal(This.posY,1,This.posX,wjetgun_sprite,1)
				--end
				--return 1
			--end
			
			--if jetuziframe <= 0 then
				if (messagetype == TaskMessage_UpdateNonCritical) and (This.unknown230 > 0) then -- 230 is up jetpack?!
					local gtask = CGameTask_CastCTask(This)
					dummylaunchparams.unknown8= gtask.posX;
					dummylaunchparams.unknownC= gtask.posY;
					dummylaunchparams.unknown14 = posmult --anglex
					dummylaunchparams.unknown10 = -1376 * math.random(-20,20) --angley
					FireWeapon(This,getWeaponData(Weapon_Uzi),dummylaunchparams)
					dummylaunchparams.unknown10 = -1376
					jetfired = true
					if jetuziframe <= 0 then
						pendsound = Sound_MinigunFire
						jetuziframe = 30
					end
					jetuziframe = jetuziframe - 1
				elseif (This.unknown230 <= 0) then
					jetfired = false
				end
				if (This.unknown230 == 0) then
					jetuziframe = 0
				end
				--jetuziframe = 1
			--end
			uzipack = CGameTask_CastCTask(This).state == WormState_JETPACK
			if not uzipack then
				jetoff = 30
				pendskipgo = This.wormnumber
				--io.write("State:" .. CGameTask_CastCTask(This).state .. "\n")
			end
		end
		--changeTracker(This)
	end
	--if (messagetype == TaskMessage_SelectWeapon)  then --it gets sent from here
		--io.write(sender.classtype .. "\n")
		--This.selectedweapon = 6
		--worm.unknown170 = 6
		--return 1
	--end
	--io.write(tostring(This.__name) .. ": " .. tostring(messagetype) .. "/" .. cnt .. "\n", 2)
		--This.wormnumber = 1
		--This.unknown104 = 1 --active worm
		--This.unknown108 = 0 --suspended worm
		--if This.unknown104 == 1 then
			--io.write(CGameTask_CastCTask(This).state .. "(" .. This.unknown164 ..")" .. "\n")
		--end
		--PrintStuff(CGameTask_CastCTask(This))
		--CGameTask_CastCTask(This).state =  0x74 --fire nuke status, freezes the worm, could be handy
		--CGameTask_CastCTask(This).state =  0x7d  --parachuting
	
	

	if (messagetype == TaskMessage_StartTurn) and gavedrill == false then
		for x=0,6,1 do
			setTeamAmmo(x,customweapons[1],0,1)
			for i,e in pairs(customweapons) do
				setTeamAmmo(x,e,1,0)
			end
		end
		gavedrill = true
	end
	if (messagetype == TaskMessage_StartTurn) then
		pendchute = false
		pendchuteskip = false
		--if (This.active == 1) then
			distributecrates(This)
		--end
	
		pendskipgo = nil
		idletimer = 1
		--io.write(getTeamUtils(This.unknownFC) .. "\n")
		--setTeamUtils(This.unknownFC,32)
		--createWeaponProjectile(This, dummyprojparams, dummylaunchparams)
		--setWormState(This,120)--0x78) jetpack
		--CGameTask_CastCTask(This).state =  0x71  --blowtorching
		--CGameTask_CastCTask(This).state =  0x7f  --parachuting
		--CGameTask_CastCTask(This).speedX = 300
		djumpon = false
		currteam = This.unknownFC
		setTeamAmmo(This.unknownFC,Weapon_Armageddon,1,99)
		setTeamAmmo(This.unknownFC,Weapon_NuclearTest,1,99)
		if (not godblock) then
			local wormhp = getWormHp(This.unknownFC,This.wormnumber)
			if (wormhp == 1) or (wormhp == 1000) or (wormhp > 2000) then
				cleardelays(This.unknownFC)
				godworm = true
				playSoundLocal(0x10000, 0x10000, This, customsound, 8)
			else
				godworm = false
			end		
		end
	end
	
	if (messagetype == TaskMessage_UpdateNonCritical) then
		if pendonealert[This.unknownFC][This.wormnumber] then
			pendonealert[This.unknownFC][This.wormnumber] = pendonealert[This.unknownFC][This.wormnumber] -1
			if pendonealert[This.unknownFC][This.wormnumber] < 0 then
				pendonealert[This.unknownFC][This.wormnumber] = nil
				local hp = getWormHp(This.unknownFC,This.wormnumber)
				if (hp == 1) or (hp == 1000) or (hp > 2000) then
					playSoundLocal(0x10000, 0x10000, This, customsound, 8)
				end
			end
		end
		--io.write("state:" .. CGameTask_CastCTask(This).state .. "\n")
		if (pendskipgo == This.wormnumber) and (This.active == 1) and skipgostates[CGameTask_CastCTask(This).state] and (CGameTask_CastCTask(This).airborne == 0) then
			idletimer = idletimer-1
			if idletimer < 0 then
				triggerSkipGo()
				pendskipgo = nil	
				idletimer = 1
			end
		end
		--changeTracker(CGameTask_CastCTask(This))
	end
	
	if (messagetype == TaskMessage_CrateCollected) then
		if (getTeamAmmo(This.unknownFC,Weapon_CrateSpy,0) > 0) and (getTeamUtils(This.unknownFC) & Util_CrateSpy ~=0) then
			setTeamUtils(This.unknownFC,getTeamUtils(This.unknownFC) & ~Util_CrateSpy)
			setTeamAmmo(This.unknownFC,Weapon_CrateSpy,0,0)
		end
		if (getTeamAmmo(This.unknownFC,Weapon_LowGravity,0) > 0) then
			if (getTeamUtils(This.unknownFC) & Util_LowGravity ~=0) then
				pendsound = LGoff_sfx
				setTeamUtils(This.unknownFC,getTeamUtils(This.unknownFC) & ~Util_LowGravity)
			else
				pendsound = LG_sfx
				setTeamUtils(This.unknownFC,getTeamUtils(This.unknownFC) + Util_LowGravity)
			end
			setTeamAmmo(This.unknownFC,Weapon_LowGravity,0,0)
		end
		if (getTeamAmmo(This.unknownFC,Weapon_Kamikaze,0) > 1) then
			if getTeamAmmo(This.unknownFC,Weapon_Armageddon,0) > 0 then
				setTeamAmmo(This.unknownFC,Weapon_Kamikaze,0,0)
				--setTeamAmmo(This.unknownFC,Weapon_SuicideBomber,0,0)
				setTeamAmmo(This.unknownFC,Weapon_Armageddon,0,0)
				triggerArmageddon(100, 166)
			end
			if getTeamAmmo(This.unknownFC,Weapon_NuclearTest,0) > 0 then
				setTeamAmmo(This.unknownFC,Weapon_Kamikaze,0,0)
				--setTeamAmmo(This.unknownFC,Weapon_SuicideBomber,0,0)
				setTeamAmmo(This.unknownFC,Weapon_NuclearTest,0,0)
				triggerNuclearTest()
				playSoundLocal(0x10000, 0x10000, This, 7, 8)
			end
		end
	end
	
	
	--(This.speedY < 514288) no perder turno
	if drillup and (This.active == 1) then
		if (CGameTask_CastCTask(This).state == WormState_DRILLING) then
			if (messagetype == TaskMessage_RenderScene) then
				drawSpriteLocal(This.posY,1000,This.posX,wdrill_sprite,(drillframe * 7)*1000)
				drillframe = drillframe+1
				if drillframe > (4*25) then drillframe = 0 end
				
				playindrill = playindrill +1
				return 1
			end
			if This.speedY == 0 then
				if ((getKeyState(0x25) & 0x8000) ~= 0) and (This.speedX > -5000) then
					This.speedX  = This.speedX - 15000
				end
				if ((getKeyState(0x27) & 0x8000) ~= 0) and (This.speedX < 5000) then
					This.speedX  = This.speedX + 15000
				end
					if playindrill >= 50 then
						playindrill = 0
						playSoundLocal(0x10000, 0x10000, This, 84, 8)
					end
			else
					This.speedY  = -257644 
			end
			writeLandRadius(7,(This.posX + This.speedX) / 65536,((This.posY+ This.speedY) / 65536) + 3)
		else
			drillup = false
			playindrill = 50
		end
	end
	
	if (This.active == 1) and (This.unknown170 > 0) and (getWeaponData(This.unknown170).name1 == "Imaik") then
		if (((getKeyState(0x6B) & 0x8000) ~= 0) or ((getKeyState(0xBB) & 0x8000) ~= 0))then
			--io.write("Attract \n")
			attractmode[This.unknownFC] = true
			textboxReplace("Imaik (","Imaik - ATTRACT (")
			selectWeapon(This,This.unknown170,1)
		end
		if (((getKeyState(0x6D) & 0x8000) ~= 0) or ((getKeyState(0xBD) & 0x8000) ~= 0)) then
			--io.write("Repel \n")
			attractmode[This.unknownFC] = false
			textboxReplace("Imaik (","Imaik - REPEL (")
			selectWeapon(This,This.unknown170,1)
		end
	end
	
	if (messagetype == TaskMessage_ShowDamage)then
		local hp = getWormHp(This.unknownFC,This.wormnumber)
		local uniwid = (This.unknownFC*10) + This.wormnumber
	
			if (hp == 1) or (hp == 1000) or (hp > 2000) then
				--playSoundLocal(0x10000, 0x10000, This, customsound, 8)
				if (not wasgod[uniwid]) then
					pendonealert[This.unknownFC][This.wormnumber] = 100
					if  currteam and (currteam ~= This.unknownFC) then
						--triggerSkipGo()
					end
				end
				wasgod[uniwid] = true
			else
				wasgod[uniwid] = false
			end	
	end
	
	--if (messagetype == TaskMessage_CrateCollected) then
		--showChatMessage("Test" .. This.__name, 2)
		--PrintWorm(This)
	--end
	if (messagetype == TaskMessage_FrameStart) then
		handledoublejump(This)		
		HandleCowPortals(This.active ~= 1)
	end
	
	
	--if (messagetype == TaskMessage_FrameStart) then
		--io.write(tostring(This.__name) .. "\n", 2)
		--PrintWorm(This)
		--io.write("WormId:" .. This.wormnumber .. "\n")
		--io.write("TeamId:" .. This.unknownFC .. "\n")
		--io.write("-----\n")
		--noworms[This.unknownFC] = noworms[This.unknownFC]+1
	--end
	--if (messagetype == TaskMessage_RenderScene) then
		--io.write("TeamId:" .. This.unknownFC .. "(" .. noworms[This.unknownFC] .. ")" .. "\n")
		--if noworms[This.unknownFC] > 0 then
			--nowormsdef[This.unknownFC] = noworms[This.unknownFC]
			--if (noworms[This.unknownFC] == 1) and (not ultwarn[This.unknownFC]) then
				--ultwarn[This.unknownFC] = true
				--showChatMessage("ULTIMO GUSANO: " .. This.unknownFC, 2)
				--playSoundLocal(0x10000, 0x10000, This, 20, 8)
			--end
		--end
		--noworms[This.unknownFC] = 0
		
	--end
end

function cleardelays(x)
	for i,e in pairs(weapons)do
		setTeamAmmo(x,i,1,0)
	end
end

function isenemyultimo(teamid)
	for i,e in pairs(ultwarn)do
			if ultwarn[i] and (i ~=teamid) then
				return true
			end
		end
	return false
end

function ultimoblockage()
	if not godworm then
		local countwarn = 0
		for i,e in pairs(ultwarn)do
			if ultwarn[i] then
				countwarn = countwarn +1
			end
		end
		if (countwarn > 0) then
			for x,e in pairs(ultwarn)do
				if (countwarn > 1) or (not ultwarn[x]) then
					for i,e in pairs(ultimoblock) do
						if not customblockwhitelist[i] then
							setTeamAmmo(x,i,1,99)
						end
					end
				end
			end
		end
	end
end


function team(This, sender, messagetype, psize, params)


if (messagetype == TaskMessage_TurnStarted) then
	local num = getNumObjects(ClassType_Task_OilDrum) -- recharge sentrys
	for i=1,num,1 do
		local thing = CTaskOildrum_CastCTask(getObject(ClassType_Task_OilDrum,i))	
		setCompactedB(thing,"unknown10C",50)
	end
end
if (messagetype == TaskMessage_PauseTurn) and (not pendskipgo) then
		--return 1 --doesnt prevent timer freeze which can be exploited
	end

	if (messagetype == TaskMessage_UpdateNonCritical) and (This.team_number_dword38 == 1) then
		playanimations()
		if rerollframe > 0 then
			rerollframe = rerollframe -1
			ovejame = (rerollframe > 0)
		end
		if vacunastealframe > 0 then
			vacunastealframe = vacunastealframe -1
		end
	end
	renderanimations()
	---This.unknown4C= 1 --lock weapons	
	
	
	
	--if (messagetype == TaskMessage_SelectBounce) then --only fires if the thing actually has bounce :(
		--io.write("WormId:" .. This.wormnumber .. "\n")
	--end
	
	--if (messagetype == TaskMessage_SelectWeapon)  then --it gets sent from here
		--io.write(sender.classtype .. "\n")
		--This.selectedweapon = 6
		--return 1
	--end
	
	if (messagetype == TaskMessage_FinishTurn) then
		cleardelays(This.team_number_dword38)
	end
	if (messagetype == TaskMessage_StartTurn) then
		--PrintTeam(This)
		depleteMagnets()
		setTeamAmmo(This.team_number_dword38,Weapon_Skunk,0,1)
		--setTeamAmmo(This.team_number_dword38,Weapon_CrateSpy,0,1)
		--setTeamAmmo(This.team_number_dword38,Weapon_CrateShower,0,1)
		--setTeamAmmoCustom(This.team_number_dword38,Weapon_Jump,0,1)
		--setTeamAmmo(This.team_number_dword38,Weapon_DoubleTurnTime,0,1)
		ultimoblockage()
	end
	if (messagetype == TaskMessage_TurnFinished) then
		godblock = nil
	end
	
	if (messagetype == TaskMessage_WormDamaged)  and ((not currworm) or (params[1] ~= currworm.teamnumber) or (params[2] ~= currworm.wormnumber)) then
		allowWormDamage(true); --constant health updates (bool is mute)
		--allowWormDeath(true); --constant death updates
	end
	if (messagetype == TaskMessage_TurnFinished) then
		allowWormDeath(true); --instant death updates
	end
	
	
	if (messagetype == TaskMessage_FrameStart) then
		damagedspmaag = damagedspmaag + 1
		if damagedspmaag == 2147483647 then
		   damagedspmaag = -2147483647
		end
	
		setTeamAmmo(This.team_number_dword38,Weapon_DoubleTurnTime,0,0)
		setTeamAmmo(This.team_number_dword38,Weapon_DoubleTurnTime,1,99)
		setTeamAmmo(This.team_number_dword38,Weapon_DamageX2,0,0)
		setTeamAmmo(This.team_number_dword38,Weapon_DamageX2,1,99)
		--io.write(tostring(This.__name) .. "\n", 2)
		--io.write("WormId:" .. This.wormnumber .. "\n")
		local noworm = getNumberOfWorms(This.team_number_dword38)
		--io.write("TeamId:" .. This.team_number_dword38 .. "(" .. getNumberOfWorms(This.team_number_dword38) .. ")" .. "\n")
			if (noworm == 1) then
				if (not ultwarn[This.team_number_dword38]) then
					ultwarn[This.team_number_dword38] = true
					pendsound = customsound2
					ultimoblockage()
				end
				--showChatMessage("ULTIMO GUSANO: " .. This.team_number_dword38, 2)
			else
				ultwarn[This.team_number_dword38] = false
			end
		--io.write("-----\n")
	end
end

local horseid = 6969

function missile(This, sender, messagetype, psize, params)
	if messagetype == TaskMessage_UpdateNonCritical then
		--io.write(This.numberofropesegments .. "\n")
		if This.numberofropesegments == 0 then
			This.numberofropesegments = horseid
			horseid = horseid +1
		end
		if This.LauncherStructure:GetAction() and (This.LauncherStructure:GetAction().JumpVelocity == 6969) then
			local num = getNumObjects(ClassType_Task_Worm)
			for i=1,num,1 do
				local tworm = CTaskWorm_CastCTask(getObject(ClassType_Task_Worm,i))
				--io.write("-"..jump_info.unknown18.."-"..jump_info.unknown1C.."-----"..tworm.posX.."-"..tworm.posY.."---("..distance(jump_info.unknown18,jump_info.unknown1C,tworm.posX,tworm.posY)..")\n")
				if ((tworm.active ~= 1)) and ((tworm.numberofropesegments == This.numberofropesegments) or ((distance(This.posX,This.posY,tworm.posX,tworm.posY) < (15 * posmult)) or (distance(This.posX,This.posY - (17 * posmult),tworm.posX,tworm.posY) < (10 * posmult)) )) then
					tworm.posX = This.posX
					tworm.posY = This.posY - (math.random(16,17) * posmult)
					tworm.speedX = This.speedX + (10 * This.facingdirection)
					tworm.speedY = This.speedY
					tworm.airborne = 0
					tworm.numberofropesegments = This.numberofropesegments
					if This.speedX > 0 then
						tworm.facingdirection = This.facingdirection
					else
						tworm.facingdirection = This.facingdirection
					end
				end
				if (This.explosiontimer < 10)	then
					if tworm.numberofropesegments == This.numberofropesegments then
						tworm.numberofropesegments = 0
					end
				end
			end
				if (This.explosiontimer % 33 == 0) and (This.explosiontimer > 1000) then
					playSoundLocal(0x10000, 0x10000, This, equino_sfx, 8)
					--pendsound = equino_sfx
				end
		end
	end
	--PrintStuff(getWeaponData(Weapon_Bazooka):GetExtraData())
	----CGameTask_CastCTask(This).unknownA8 = 0
	----CGameTask_CastCTask(This).unknownCC = 0
	----CGameTask_CastCTask(This).unknown60 = 0
	----CGameTask_CastCTask(This).unknown5C = 0
	--CGameTask_CastCTask(This).unknown4C = 1
	
	
	
	
	--PrintStuff(This)
	--PrintStuff(This.LauncherStructure:GetExplosionTarget())
	--This.LauncherStructure:GetExplosionTarget().amount = 300

	
	--io.write("\n flags:" .. This.LauncherStructure.explosioncolflags)

	--io.write("\n sadasdada: " .. This.explosioncolflags)
	--if (messagetype == TaskMessage_FrameStart) then
		--This.speedX = 0
		--This.speedY = 0
	--end
end
local funnehexplode

function explodesp(This, posX, posY, radiusX, radiusY, power, pushX, pushY, type_a9, soundOnHit, spriteOnHit, collisionMask, a13)
	--if not damagedspmaag then
		--damagedspmaag = true
		damageMagnets(posX, posY, This, pushX, power, a13, collisionMask)
		--damageSentrys(posX, posY, This, pushX,pushY, power, a13, collisionMask)
	--end
end
function explode(posx, posy, sender, pushforce, power, a6, team)
	--if messagetype == TaskMessage_DetonateCrate then
		damageMagnets(posx, posy, sender, pushforce, power, a6, team)
		damageSentrys(posx, posy, sender, pushforce,0, power, a6, team)
		local potentialcrate = CTaskCrate_CastCTask(sender)
		if potentialcrate.unknown128 and (potentialcrate.unknown128 > 0) and (potentialcrate.unknown12C > 0) and (potentialcrate.unknown12C < customweapons[#customweapons]) then
			--PrintCrate(potentialcrate)
			--showChatMessage("CRATEEXPLODED: " .. getWeaponData(potentialcrate.unknown12C).name1 .. ")", 2)
			if defprojparams[potentialcrate.unknown12C] and funnehexplode then
				dummylaunchparams.unknown8= posx;
				dummylaunchparams.unknownC= posy;
				dummylaunchparams.unknown10= 0;
				dummylaunchparams.unknown14= -419040;
				dummylaunchparams.unknown18= 62914560;
				dummylaunchparams.unknown1C= 22806528;
				createWeaponProjectile(sender, defprojparams[potentialcrate.unknown12C], dummylaunchparams)
			end
		end
	--end
end
local count = 0
function crate(This, sender, messagetype, psize, params)
	--if messagetype == TaskMessage_StateChecksum then
		--PrintCrate(This)
		--if This.unknown10C == 0 then
			--This.unknown10C = 10000 --timer
		--end
		if This.unknown12C == Weapon_SuicideBomber then
			This.unknown12C = customweaponsbyname["Tang"]
		end
		--io.write("Timer: " ..  This.unknown10C) --unknown258 obj param timer
		local gtask = CGameTask_CastCTask(This)
		if (This.unknown128 > 0) and (rerollframe > 0) then --check if salud (a.k.a si tiene armas)
			--io.write(messagetype .. "\n")
			if messagetype == TaskMessage_UpdateNonCritical then
				pendsound = Sound_CratePop
				addanim(gtask.posX,gtask.posY,Sprite_circle25,60).Step = 5
				addanim(gtask.posX,gtask.posY,Sprite_qexhaust,70).Step = 1
			end
			if ovejame then
				setcrate(This, Weapon_Sheep)
			else
				setcrate(This, math.random(1,customweapons[#customweapons]))
			end
		end
		if (This.unknown128 <= 0) and (vacunastealframe > 0) and (gtask.posY < (8000 * posmult)) then --check if salud (a.k.a si no tiene armas)
			pendsound = Sound_Collect
			addanim(gtask.posX,gtask.posY,Sprite_circle25,60).Step = 10
			gtask.posY = 9000 * posmult -- send into obvlivion
			setTeamAmmo(currteam,customweaponsbyname["Inoculacion de Mike"],0,getTeamAmmo(currteam,customweaponsbyname["Inoculacion de Mike"],0)+1)
		end
		
		if (This.unknown4A0 == 0) and (This.unknown128 > 0) then --check if salud (a.k.a si tiene armas)
			This.unknown4A0 = 1
			if not utitilies[This.unknown12C] then
				count = count +1
				if (math.random(1,100) <= 5) or (count == 95) then
					--showChatMessage("ULTIMO GUSANO: " .. This.unknown12C .. "(" .. tostring(count) .. ")", 2)
					count = 0
					This.unknown12C = customweapons[math.random(1,#customweapons)]
					This.unknown128 = 1
				end
			end
		end
		if (This.gravityfactor < 0) then
			This.gravityfactor = 0
		end
		if (messagetype == TaskMessage_RenderScene) and (This.gravityfactor == 0) and (This.ropeanchorX < 69) then
			return 1
		end
	--end
end

function distributecrates(worm)
	local num = getNumObjects(ClassType_Task_OilDrum)
	for i=1,num,1 do
		local thing = CGameTask_CastCTask(getObject(ClassType_Task_OilDrum,i))	
		if getCompactedA(CTaskOildrum_CastCTask(thing).unknown10C) == worm.teamnumber then
			local num = getNumObjects(ClassType_Task_Crate)
				for i=1,num,1 do
					local thing2 = CGameTask_CastCTask(getObject(ClassType_Task_Crate,i))
					local dist = distance(thing2.posX,thing2.posY,thing.posX,thing.posY)
					if ((dist / 65536) < 150) and (thing2.ropeanchorX ~= 69) then
						pendsound = gotmail_sfx
						thing2.posX = worm.posX
						thing2.posY = worm.posY
						addanim(worm.posX,worm.posY,Sprite_circle25,60).Step = 5
						thing2.ropeanchorX = 69
					end
				end
		end
	end

end

function angleBetween(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    -- flip here (removed the minus)
    local angle = math.atan2(dx, dy)

    -- make it symmetric (ignore left/right)
    if angle < 0 then
        angle = -angle
    end

    -- scale to [0, 65536]
    return (angle / math.pi) * 65536
end

function shootfakebullet(This,posx,posy,targetangle,targetdir,range, radiusx, radiusy, impacttype, pushx, pushy, power, sfxhit, spritehit, collisionflags, unk )

	local ax = convertAngleX(targetangle,targetdir)
	local ay = convertAngleY(targetangle)

	local rayland = checkLandCollision(posx,posy,ax,ay,range)
	local rayman = checkObjectCollision(This,posx / posmult,(posy)/ posmult,ax,ay,range,collisionflags)
											
	local hit = rayland
	if (rayman > 0) and ((rayman < rayland) or (rayland <= 0)) then 
		hit = rayman 
	end
	local destx = posx + (ax * (hit))
	local desty = (posy) + (ay * (hit))
	if (rayman > 0) or (rayland > 0) then
		createSpecialImpact(This, destx, desty, radiusx, radiusy, impacttype, pushx, pushy, power, sfxhit, spritehit, collisionflags, unk) --fake uzi push
		writeLandRadius(power,destx / 65536, desty / 65536) --fake uzi hole
		createSmoke(destx,desty,5,2)
	end
end


function randomPointInCircle(cx, cy, radius)
    local angle = math.random() * 2 * math.pi
    local r = radius * math.sqrt(math.random())
    
    local x = cx + r * math.cos(angle)
    local y = cy + r * math.sin(angle)
    
    return x, y
end

local lastcurrwormtt = 0
local stafetaparticletimer = 0
function oildrum(This, sender, messagetype, psize, params)
	--if (messagetype == TaskMessage_SpecialImpact) then io.write("posx " .. params[1]  ..", posy " .. params[2]  ..", sender " .. params[3]  ..", pushx " .. params[4]  ..",pushy " .. params[5]  ..", power " .. params[6]  ..", a6 " .. params[7]  ..", team " .. params[8] .. " \n") return 1 end
	--if (messagetype == TaskMessage_Explosion) then io.write("posx " .. params[1]  ..", posy " .. params[2]  ..", sender " .. params[3]  ..", pushx " .. params[4]  ..",pushy " .. params[5]  ..", power " .. params[6]  ..", a6 " .. params[7]  ..", team " .. params[8] .. " \n") return 1 end
	--This.heat = 30
	--This.unknown108 = 1
		--PrintStuff(This)
		--io.write(getCompactedA(This.unknown10C) .. "\n")
		if This.underwater > 0 then --torreta drown
			if (messagetype == TaskMessage_RenderScene) then
				if (getCompactedC(This.ropeanchorX) > 0) then
					drawSpriteLocal(This.posY,1001,This.posX,turretspr[0] ,(((((0) * 180)) /(posmult * 9.5))) * 3300)
					drawSpriteLocal(This.posY,1003,This.posX,turretstand ,1)
					return 1
				end
			end
		elseif This.unknown10C > 0 then -- torreta sentry
			if (getCompactedA(This.unknown10C) > 60)  then
				local turretheight = 4.7 * posmult
				local trackspeed = 1000
				local ownerteam = getCompactedA(This.unknown10C) - 60
				if (messagetype == TaskMessage_SpecialImpact) then
							local power = params[6]
							if (power > 0) and ((power ~= 30) or(math.abs(This.ropeanchorY - damagedspmaag) > 55)) then 
							This.ropeanchorY = damagedspmaag
							This.numberofropesegments = This.numberofropesegments - power						
							if params[5] ~= 0 then
								This.speedX = params[4]
								This.speedY = params[5]
							end
							--io.write("SentryDamage: " .. (power) ..  "(hp: " .. This.numberofropesegments .. ")  \n")
						end
						return 1
				end
				if (messagetype == TaskMessage_FrameStart) then --TaskMessage_FrameStart --TaskMessage_RenderScene
					--changeTracker(CTaskTurnGame_CastCTask(sender))
					if This.unknownrope < 1000 then
						This.unknownrope = 1000
					elseif This.unknownrope > 1000 then
						This.unknownrope = This.unknownrope-50
					end
					if This.numberofropesegments <= 0 then
						createExplosion(This,This.posX , This.posY, 100, 50, 1, 1)
						This.posY = 9000 * posmult 
						return 1
					end
					
					if getCompactedD(This.unknown10C) > 0 then
								setCompactedD(This,"unknown10C",getCompactedD(This.unknown10C) - 1) 
					end
					
					if getCompactedB(This.ropeanchorX) > 0 then								
								setCompactedB(This,"ropeanchorX",getCompactedB(This.ropeanchorX) - 1) 
					end
					if (getCompactedB(This.unknown10C) < 5) and (getCompactedB(This.unknown10C) > 0)  then
								setCompactedB(This,"unknown10C", getCompactedB(This.unknown10C) -1)
					end
					
					local tworm  
					local turrettargets = {ClassType_Task_Worm,ClassType_Task_OldWorm}
					for _,clas in pairs(turrettargets) do
					
					local num = getNumObjects(clas)
					for i=1,num,1 do
						local aworm = CTaskWorm_CastCTask(getObject(clas,i))
						--io.write(getCompactedC(This.unknown10C) .. " " .. tostring(turretignorestates[aworm.state]) .. "\n")
						if ((clas ~= ClassType_Task_OldWorm) and (((aworm.teamnumber * 10) + aworm.wormnumber) == getCompactedC(This.unknown10C))) or ((getCompactedB(This.unknown10C) > 0) and ((clas == ClassType_Task_OldWorm) or (((((aworm.teamnumber * 10) + aworm.wormnumber) == getCompactedC(This.unknown10C))) or (((getCompactedC(This.unknown10C) == 0)) and (not turretignorestates[aworm.state]) and aworm.teamnumber ~= ownerteam)))) then
							--io.write("aaaaa")
							tworm = aworm
							local targetangle = angleBetween(This.posX,This.posY - turretheight,tworm.posX, tworm.posY)
							local targetdir = 1
							if This.posX > tworm.posX then
								targetdir = -1
							end
							
							if getCompactedD(This.unknown10C) > 0 then
								This.unknownF4 = targetangle
								This.unknownFC = targetdir
							end
							
							local ax = convertAngleX(targetangle,targetdir)
							local ay = convertAngleY(targetangle)

							local rayland = checkLandCollision(This.posX,This.posY - turretheight,ax,ay,500)
							local rayman = checkObjectCollision(This,This.posX / posmult,(This.posY - turretheight)/ posmult,ax,ay,500,CollisionFlag_DEFAULT | CollisionFlag_MINE)
							--io.write("rayland:" .. rayland .. "\n") --lowest closest
							--io.write("rayman:" .. rayman .. "\n") --lowest closest
											
								local hit = rayland
								if (rayman > -1) and ((rayman < rayland) or (rayland < 0)) then 
									hit = rayman 
								end
								
								
								
								local destx = This.posX + (ax * (hit))
								local desty = (This.posY - turretheight) + (ay * (hit))
								if  (getCompactedA(This.ropeanchorX) > 0) and (getCompactedD(This.unknown10C) == 0) then 
									if (getCompactedB(This.unknown10C) > 5) then
										if (rayland > -1) or (rayman > -1) then
											--shootfakebullet(This,This.posX,This.posY - turretheight,This.unknownF4,This.unknownFC,500, 18 * posmult, 20* posmult, 2, ax * 1.1, ay* 1.5, 3, 0, 0, CollisionFlag_DEFAULT | CollisionFlag_MINE, 0)		
											shootfakebullet(This,This.posX,This.posY - turretheight,This.unknownF4 + (math.random(-2000,2000)),This.unknownFC,500, 18 * posmult, 20* posmult, 2, ax * 1.1, ay* 1.5, 3, 0, 0, CollisionFlag_DEFAULT | CollisionFlag_MINE, 0)		
											setCompactedB(This,"ropeanchorX",100) --alert mode
										end										
										playSoundLocal(0x10000, 0x10000, This, sentryfire1_sfx, 8)
										if math.random(-10,10) == 0 then
											playSoundLocal(0x10000, 0x10000, This, Sound_Ricochet, 8)
										end
										setCompactedB(This,"unknown10C", getCompactedB(This.unknown10C)-1)
										setCompactedA(This,"ropeanchorX", getCompactedA(This.ropeanchorX)-1)
										setCompactedD(This,"unknown10C",4)
									elseif getCompactedB(This.unknown10C) > 0 then
										--if (clas ~= ClassType_Task_OldWorm) then
											--setCompactedC(This,"unknown10C",(tworm.teamnumber * 10) + tworm.wormnumber)
										--end
										if getCompactedB(This.ropeanchorX) == 0 then
											playSoundLocal(0x10000, 0x10000, This, sentrydactivate_sfx, 8)
											setCompactedC(This,"unknown10C",0)
										end
										--setCompactedB(This,"ropeanchorX",100) --alert mode
										setCompactedB(This,"unknown10C", getCompactedB(This.unknown10C)-1)
									end
								end
								
								
								--io.write("ammo:" .. getCompactedB(This.unknown10C) .. "rayman:" .. rayman .. "rayland:".. rayland .. " target:" .. targetangle .. " angle:" .. This.unknownF4 .. "\n" )
								drawSpriteLocal(This.posY + (ay * (hit) - (posmult * 10)),1000,This.posX + (ax * (hit)),Sprite_cursorr,0) --for debugging
								drawSpriteLocal(aworm.posY,1000,aworm.posX,Sprite_cursorb,0) --for debugging
							if (rayman > -1) and ((rayman < rayland) or (rayland < 0)) then
								if This.unknownrope < 2000 then
									This.unknownrope = This.unknownrope +200
								end
								if distance(tworm.posX,tworm.posY,destx,desty) < (10 * posmult) then
										if getCompactedC(This.unknown10C) == 0 then
											if (clas ~= ClassType_Task_OldWorm) then
												setCompactedC(This,"unknown10C",(tworm.teamnumber * 10) + tworm.wormnumber)
											end
											if getCompactedB(This.ropeanchorX) == 0 then
												playSoundLocal(0x10000, 0x10000, This, sentryactivate_sfx, 8)
											end
											setCompactedB(This,"ropeanchorX",100) --alert mode
											--setCompactedB(This,"unknown10C", getCompactedB(This.unknown10C)-1)
										end
										--io.write("ammo:" .. getCompactedB(This.unknown10C) .. " target:" .. targetangle .. " angle:" .. This.unknownF4 .. "\n" )
										local dif = math.abs(targetangle - This.unknownF4)
										if ((dif < (500)) and (targetdir == This.unknownFC)) then
											if (getCompactedB(This.unknown10C) <= 5) then
												playSoundLocal(0x10000, 0x10000, This, sentryfiredry1_sfx, 8)
												setCompactedC(This,"unknown10C",0)
												setCompactedB(This,"unknown10C", getCompactedB(This.unknown10C)-1)
												if (getCompactedB(This.unknown10C) <= 0) then
													playSoundLocal(0x10000, 0x10000, This, sentrydactivate_sfx, 8)
												end
											else
												if getCompactedD(This.unknown10C) == 0 then
													setCompactedA(This,"ropeanchorX",15)
												end
											end
										elseif (targetdir ~= This.unknownFC) then
											This.unknownF4 = This.unknownF4 + This.unknownrope
											if This.unknownF4 > posmult then
												This.unknownF4 = posmult
												This.unknownFC = targetdir
											end
										elseif (dif < (This.unknownrope)) and (targetdir == This.unknownFC) then
											This.unknownF4 = targetangle
										elseif (targetangle < This.unknownF4) and (targetdir == This.unknownFC) then
											This.unknownF4 = This.unknownF4 - This.unknownrope
										elseif (targetangle > This.unknownF4) and (targetdir == This.unknownFC) then
											This.unknownF4 = This.unknownF4 + This.unknownrope
										end
								--elseif ((((aworm.teamnumber * 10) + aworm.wormnumber) == getCompactedC(This.unknown10C))) then
									--	setCompactedC(This,"unknown10C",0)
								end
							elseif ((((aworm.teamnumber * 10) + aworm.wormnumber) == getCompactedC(This.unknown10C))) then
								setCompactedC(This,"unknown10C",0)
							end	
						end
						
						if (getCompactedB(This.unknown10C) <= 5) and This.unknownF4 > 0 then --when no ammo (<5)
							This.unknownF4 = This.unknownF4 - 300
							if This.unknownF4 < 0 then
								This.unknownF4 = 0
							end
						--elseif (getCompactedC(This.unknown10C) == 0) then
						--		if getCompactedB(This.ropeanchorX) == 0 then
						--		--idle position
						--		--io.write(This.unknownF4  .. " : " .. getCompactedD(This.ropeanchorX) .. "\n")
						--			if (getCompactedD(This.ropeanchorX) > 0) then
						--				setCompactedD(This,"ropeanchorX",getCompactedD(This.ropeanchorX) -1)
						--			end
						--			if (getCompactedD(This.ropeanchorX) == 0) then
						--				if This.unknownF4 < 20000 then
						--					if (getCompactedC(This.ropeanchorX) == 0) then
						--						setCompactedC(This,"ropeanchorX",2)
						--						setCompactedD(This,"ropeanchorX",200)
						--					end
						--				elseif This.unknownF4 > 45000 then 
						--					if (getCompactedC(This.ropeanchorX) == 2) then
						--						setCompactedC(This,"ropeanchorX",0)
						--						setCompactedD(This,"ropeanchorX",200)
						--					end
						--				end
						--				This.unknownF4 = This.unknownF4 + (100 * (getCompactedC(This.ropeanchorX) - 1))
						--			end
						--			--if This.unknownF4 > (posmult/2) then
						--				--This.unknownF4 = This.unknownF4 - 300
						--			--else
						--			--end
						--		end
						end
					end
					end
						if not tworm then
							--setCompactedC(This,"unknown10C",0)
						end
				end	

				if (messagetype == TaskMessage_RenderScene) then
					if getCompactedB(This.unknown10C) <= 5 then
						ownerteam = 0
					end
					if This.unknownFC < 0 then --dir
						drawSpriteLocal(This.posY,1001,This.posX,turretspr[ownerteam] ,(((((This.unknownF4) * 180)) /(posmult * 9.5))) * 3300) --this.unknownF4 actual angle
						if getCompactedD(This.unknown10C) == 4 then
							drawSpriteLocal(This.posY,1002,This.posX,turretfire ,(((((This.unknownF4) * 180)) /(posmult * 9.5))) * 3300)
						end
					else
						drawSpriteLocal(This.posY,1001,This.posX,turretspr[ownerteam] | flipsprite,(((This.unknownF4 * 180) /(posmult * 9.5))) * 3300)
						if getCompactedD(This.unknown10C) == 4 then
							drawSpriteLocal(This.posY,1002,This.posX,turretfire | flipsprite,(((This.unknownF4 * 180) /(posmult * 9.5))) * 3300)
						end
					end
					drawSpriteLocal(This.posY,1003,This.posX,turretstand ,1)
					return 1
				end

				
			elseif (getCompactedA(This.unknown10C) > 0) then --estafeta
				--if (messagetype == TaskMessage_UpdateNonCritical) then
				--	if stafetaparticletimer <= 0 then
				--		local rx,ry = randomPointInCircle(This.posX, This.posY, 130 * posmult)
				--		addanim(rx,ry,Sprite_qexhaust | translatentsprite ,70).Step = 1
				--		stafetaparticletimer = 2
				--	else
				--		stafetaparticletimer = stafetaparticletimer - 1
				--	end
				--end
				local gtask = CGameTask_CastCTask(This)
				if (messagetype == TaskMessage_FrameStart) then
					local repelstuff = {ClassType_Task_Crate}
					for _,clas in pairs(repelstuff) do
						local num = getNumObjects(clas)
						for i=1,num,1 do
							local thing = CGameTask_CastCTask(getObject(clas,i))	
							local dist = distance(This.posX,This.posY,thing.posX,thing.posY)
							--io.write((dist / 65536) .. "\n")
							if ((dist / 65536) < 150) and (thing.ropeanchorX < 20) then --150 imaik radius
								if dist <= 2 then
									--if currworm and currworm.active and currworm.teamnumber == CTaskMine_CastCTask(This).fusetime  then
									--	thing.posX = currworm.posX
									--	thing.posY = currworm.posY
									--end
								else
									if thing.ropeanchorX == 0 then
										pendsound = Sound_CratePop
										addanim(thing.posX,thing.posY,Sprite_circle25,60).Step = 5
										addanim(thing.posX,thing.posY,Sprite_qexhaust,70).Step = 1
									end
									thing.posX = This.posX
									thing.posY = This.posY
									thing.gravityfactor = 0
									thing.ropeanchorX = thing.ropeanchorX + 1
								end
							end
					end
					
					end
			end
			if (messagetype == TaskMessage_RenderScene) then
					if mailmike[getCompactedA(This.unknown10C)] then
						drawSpriteLocal(gtask.posY,1000,gtask.posX,mailmike[getCompactedA(This.unknown10C)],0)
						drawSpriteLocal(gtask.posY,1000,gtask.posX,wave_sprite | translatentsprite,0)
						--addentanim(This,wave_sprite | translatentsprite,60,true)
						return 1
					end
				end
			end
	end
	
	--if (messagetype == TaskMessage_SpecialImpact) then --SpecialImpact only triggers when the thing is actually damaged which is nice
		--This.speedY = -990000
		--return 1
	--end
	--if (messagetype == TaskMessage_Explosion) then -- cannot tell if it will hit or not :(
		--return 1
	--end
end

function addmessages()
		CTaskTurnGame_RegisterCallback_vtable8(Message)
		CTaskTeam_RegisterCallback_vtable0(Message)
		CTaskTeam_RegisterCallback_vtable4(Message)
		CTaskTeam_RegisterCallback_vtableC(Message)
		CTaskTeam_RegisterCallback_vtable10(Message)
		CTaskTeam_RegisterCallback_vtable14(Message)
		CTaskTeam_RegisterCallback_vtable18(Message)
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
		CTaskTeam_RegisterCallback_vtable8(Message)
		CTaskWorm_RegisterCallback_vtable8(Message)
end
function proj(This, dummyprojparams, launchparams)
	--PrintWeaponProjParams(dummyprojparams)
	--PrintWeaponLaunchParams(launchparams)
	--if nextismagnet then
		--nextismagnet= false
		--return 1
	--end
end
local waspaused = 300







local function calculateBitWidth(value)
    local width = 0
    while value > 0 do
        value = value >> 1
        width = width + 1
    end
    return width
end

local function updateInputValue(originalValue, newInputValue)
    local inputBitWidth = calculateBitWidth(newInputValue)
    local inputMask = (1 << inputBitWidth) - 1
	--io.write("Mask:" .. (originalValue  & ~inputMask) .. "\n")
    return (originalValue & ~inputMask) | (newInputValue & inputMask)
end

local magnetink = {}
magnetink[Sprite_wdynlnk] = magnetd_spritelnk -- 0
magnetink[Sprite_wdynlnku] = magnetd_spritelnku -- -1
magnetink[Sprite_wdynlnkd] = magnetd_spritelnkd -- 1
 
local hourseink = {}
 hourseink[0] = equinohold
 hourseink[1] = equinoholdd
 hourseink[-1] = equinoholdu
 
 local turretink = {}
 turretink[0] = {}
 turretink[1] = {}
 turretink[-1]= {}
 turretink[0][1] = turrethold
 turretink[1][1] = turretholdd
 turretink[-1][1] = turretholdu
 turretink[0][2] = turret1hold
 turretink[1][2] = turret1holdd
 turretink[-1][2] = turret1holdu

 local estafetaink = {}
 estafetaink[0] = {}
 estafetaink[1] = {}
 estafetaink[-1]= {}
 estafetaink[0][1] = estafetahold
 estafetaink[1][1] = estafetaholdd
 estafetaink[-1][1] = estafetaholdu
 estafetaink[0][2] = estafeta1hold
 estafetaink[1][2] = estafeta1holdd
 estafetaink[-1][2] = estafeta1holdu
 
local fakeframe = 0

function render( layer, posx,posy, sprite,  frame)
	if currworm  then
		if ( currworm.state == WormState_IDLE)  then
					if fakeframe < 50000 then
						fakeframe = fakeframe + 50
					end
				else
					fakeframe = 0
				end
		if (currworm.selectedweapon == customweaponsbyname["Maiktungo"])then
			local curr = (sprite & 0x3FF)
			if curr == 0 then
				drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, hourseink[currworm.tailposition]),fakeframe)
			end
		elseif (currworm.selectedweapon == customweaponsbyname["Centinela de Mike"])then
			local curr = (sprite & 0x3FF)
			if (curr == Sprite_wdynlnk) or (curr == Sprite_wdynlnku) or (curr == Sprite_wdynlnkd) then
				drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, turretink[currworm.tailposition][currworm.teamnumber]),fakeframe)
				return 1
			end
		elseif (currworm.selectedweapon == customweaponsbyname["Estafeta de Mike"])then
			local curr = (sprite & 0x3FF)
			if (curr == Sprite_wdynlnk) or (curr == Sprite_wdynlnku) or (curr == Sprite_wdynlnkd) then
				drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, estafetaink[currworm.tailposition][currworm.teamnumber]),fakeframe)
				return 1
			end
		else
			fakeframe = 0
		end
		--io.write("selected: " .. currworm.selectedweapon .. "/" .. customweaponsbyname["Inoculacion de Mike"] .. "\n" )
		if currworm.selectedweapon == customweaponsbyname["Imaik"] then
			local curr = (sprite & 0x3FF)
			if magnetink[curr] then
				local off = 0
				if attractmode[currworm.unknownFC] then off = 1 end
				drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, magnetink[curr] + off),frame)
				return 1
			end
		end
	end
	if hookpackworm then
		if ((sprite & 0x3FF) == Sprite_wjetfly1) or ((sprite & 0x3FF) == Sprite_wjetfly4) or ((sprite & 0x3FF) == Sprite_wjetfly2) or ((sprite & 0x3FF) == Sprite_wjetfly3) then
			drawSpriteLocal(hookpackworm.posY + (30 * posmult),1,hookpackworm.posX,updateInputValue(sprite,hook_sprite),1)
		end
	end
	if uzipack or (jetoff > 0) then
		if (sprite & 0x3FF) == Sprite_wjetflmd then
			return 1
		end
		if (sprite & 0x3FF) == Sprite_wjetfly1 then
			if jetfired and ((jetuziframe % 4) == 0) then
				drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, wjetgun_spriteShoot),frame)
			else
				drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, wjetgun_sprite),frame)
			end
			return 1
		end
		if (sprite & 0x3FF) == Sprite_wjetfly4 then
			drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, wjetgun_sprite4),frame)
			return 1
		end
		if (sprite & 0x3FF) == Sprite_wjetfly3 then
			drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, wjetgun_sprite3),frame)
			return 1
		end
		if (sprite & 0x3FF) == Sprite_wjetfly2 then
			drawSpriteLocal(posy,layer,posx,updateInputValue(sprite, wjetgun_sprite2),frame)
			return 1
		end
		--io.write("Render:" .. (sprite & 0x3FF) .. "\n")
		if ((sprite & 0x3FF) == Sprite_wjetlnk) or ((sprite & 0x3FF) == Sprite_wjetlnku) or ((sprite & 0x3FF) == Sprite_wjetlnkd)  then
			drawSpriteLocal(posy,layer,posx,updateInputValue(sprite,wjetgun_spriteinit) ,frame)
			return 1
		end
		
		
	end
end

function playsentryidle(This)
if (getCompactedC(This.unknown10C) == 0) then
								if getCompactedB(This.ropeanchorX) == 0 then
								--idle position
								--io.write(This.unknownF4  .. " : " .. getCompactedD(This.ropeanchorX) .. "\n")
									if (getCompactedD(This.ropeanchorX) >= 6) then
										setCompactedD(This,"ropeanchorX",(getCompactedD(This.ropeanchorX) -6))
									end
									if (getCompactedD(This.ropeanchorX) <= 6) then
										if This.unknownF4 < 20000 then
											if (getCompactedC(This.ropeanchorX) == 0) then
												setCompactedC(This,"ropeanchorX",2)
												setCompactedD(This,"ropeanchorX",200)
											end
										elseif This.unknownF4 > 45000 then 
											if (getCompactedC(This.ropeanchorX) == 2) then
												setCompactedC(This,"ropeanchorX",0)
												setCompactedD(This,"ropeanchorX",200)
											end
										end
										This.unknownF4 = This.unknownF4 + (600 * (getCompactedC(This.ropeanchorX) - 1))
									end
									--if This.unknownF4 > (posmult/2) then
										--This.unknownF4 = This.unknownF4 - 300
									--else
									--end
								end
						end
end

function turn(This, sender, messagetype, psize, params)

	
	--io.write(This.unknown38 .. "/" .. This.unknown34 .. "/" .. This.unknown30 .. "\n")
	if messagetype == TaskMessage_FrameStart then
		local num = getNumObjects(ClassType_Task_OilDrum)
		for i=1,num,1 do
			local thing = CTaskOildrum_CastCTask(getObject(ClassType_Task_OilDrum,i))	
			playsentryidle(thing)
		end
	end
	if messagetype == TaskMessage_ProcessInput then
		if hookpack then
			if ((getKeyState(32) & 0x8000) ~= 0) then
				if not jethookblock then
					if jethooked then
						jethooked.speedX = 0
						jethookblock = 10
					end
					jethooked = nil
				end
				if jethookblock then
					return 1
				end
			end
		end
	end	
		if (messagetype == TaskMessage_UpdateNonCritical) then
			--PrintStuff(This)
			--io.write(This.readyforadvance  .. "\n")
		end
		if (messagetype == TaskMessage_RenderScene) then
			RenderCowPortals()
	end
	
	--if messagetype == TaskMessage_GameText then
	--	io.write(psize .. "\n")
	--	io.write("-----TEXT SHIT----\n")
	--	for i=1,psize,1 do
	--		io.write("[" .. i .. "]" .. params[i] .. "\n")
	--	end
	--	io.write("-----TEXT SHIT END----\n")
	--end

	--if (messagetype == TaskMessage_PauseTimer) or (messagetype == TaskMessage_PauseTurn) then
		--return 1
	--end
	--changeTracker(This)
	--if waspaused <= 0 then
		--waspaused = 300
		--This.turnpaused = 0
	--end
	--if This.turnpaused == 1 then
		--waspaused = waspaused - 1
	--end
	--io.write(getWind() .. "\n")
	
	--if (messagetype == TaskMessage_WormDamaged) then
		--PrintStuff(params,psize/2)
		--local wormid = (params[1] * 10) + params[2]
		--if not wormdata[wormid].pasthp then wormdata[wormid].pasthp = params[3] + getWormHp(params[1],params[2])  end
		
		--io.write("Team: " .. params[1] .. "\n")
		--io.write("Worm: " .. params[2] .. "\n")
		--io.write("Damage: " .. params[3] .. "/" .. wormdata[wormid].pasthp .. "\n")
		--io.write("---------------------\n")
		--wormdata[wormid].pasthp = getWormHp(params[1],params[2])
	--end
	
end


function weaprel(This, sender, messagetype, psize, params)
	--if hookpackstarted then
		--return 1
	--end
end

--specialist mode

--specialist mode

local ogreg = registerCustomWeapon
local function registerCustomWeapon(JumpStruct, img, name2, name1)
	local ret = ogreg(JumpStruct, img, name2, name1)
	customweaponsbyname[name1] = ret
	return ret
end

function turntimetracker(This, sender, messagetype, psize, params)
	local exclude = {}
	exclude["turntimertwo"] = true
	exclude["roundtimer"] = true
	exclude["unknown184"] = true
	exclude["unknown188"] = true
	exclude["unknown18C"] = true
	exclude["unknown2D4"] = true
	exclude["turntimerone"] = true
	exclude["unknown38"] = true
	exclude["unknown198"] = true
	exclude["unknown70"] = true
	exclude["unknown28C"] = true
	exclude["lastsecondstimer"] = true
	exclude["unknown180"] = true
	changeTracker(This,exclude)
end

function tracker(This, sender, messagetype, psize, params)
	if This.active == 1 then
		local exclude = {}
		exclude["namearrowslide"] = true
		exclude["unknown380"] = true
		exclude["hasnamearrow"] = true
		exclude["unknown384"] = true
		exclude["showname"] = true
		exclude["unknown394"] = true
		exclude["statecounter"] = true
		exclude["unknown164"] = true
		changeTracker(This,exclude)
	end
end


function land(This, sender, messagetype, psize, params)
	--if (messagetype == TaskMessage_Explosion) then
		--return 1
	--end
end


function scream1() io.write("1 \n")  return 1 end
function scream2() io.write("2 \n")  return 1 end
function scream3() io.write("3 \n")  return 1 end
function scream4() io.write("4 \n")  return 1 end
function scream5() io.write("5 \n")  return 1 end
function scream6() io.write("6 \n")  return 1 end
function scream7() io.write("7 \n")  return 1 end
function scream8() io.write("8 \n")  return 1 end
function scream9() io.write("9 \n")  return 1 end
function scream10() io.write("10 \n")return 1 end
function scream11() io.write("11 \n")return 1 end


local callsset = false
function initialize()
	if not callsset then
		--CTaskWorm_RegisterCallback_vtable8(tracker)
		
		registerCallback_fireWeapon(weapcall)
		registerCallback_fireBulletProjectile(firebulletcall)
		CTaskTurnGame_RegisterCallback_vtable8(turn)
		getWeaponData(Weapon_Longbow).unknown14 = 1 --shots
		getWeaponData(Weapon_Longbow).unknown28 = 5 --cantpor caja
		getWeaponData(Weapon_Shotgun).unknown14 = 1 --shots
		getWeaponData(Weapon_Shotgun).unknown28 = 2 --cant por caja
		getWeaponData(Weapon_NinjaRope).unknown28 = 1 --cant por caja
		
		--getWeaponData(Weapon_Skunk).unknown7C = 100 --wind factor
		getWeaponData(Weapon_Skunk).unknown88 = 2000 --countdown
		getWeaponData(Weapon_Skunk).unknown8C = 2000 --duration phase 1
		getWeaponData(Weapon_Skunk).unknown118 = 0 --skunk phase 2 powa		
		getWeaponData(Weapon_Skunk).unknown150 = 4000 --countdown phase 2
		getWeaponData(Weapon_Skunk).unknown154 = 4000 --duration phase 2
		--getWeaponData(Weapon_Skunk).unknown90 = Sound_Freeze --release sound
		
		
		
		--getWeaponData(Weapon_ClusterBomb):GetExtraData():GetExplosionTarget().Gravity = -10
		
		getWeaponData(Weapon_Armageddon):GetExtraData().windfactor = 200
		
		
				
		--getWeaponData(Weapon_Sheep).unknown34 = 10 --herd
		--getWeaponData(Weapon_MadCow):GetExtraData():GetAction().TerrainTolerance = 10 --vaca 4x4
		--getWeaponData(Weapon_Sheep):GetExtraData():GetAction().TerrainTolerance = 0 --caffeine sheep
		
		
		
		--PrintWeapon(getWeaponData(Weapon_CrateSpy))
		
		--getWeaponData(Weapon_CrateSpy).unknown24 = 100 --chances de caja
		--getWeaponData(Weapon_CrateSpy).unknown3C = 5 --tipo de utilidad
		--getWeaponData(Weapon_CrateSpy).name2 = "a" 
		--getWeaponData(Weapon_CrateSpy).name1 = "a" 
		--CTaskAirStrike_RegisterCallback_vtable8(tracker)		
		--CTaskCrate_RegisterCallback_vtable8(Message)
		--CTaskSpriteAnimation_RegisterCallback_vtable8(animation)
		registerCallback_drawSpriteLocal(render)
		registerCallback_fireWeapon(jump)
		registerCallback_fireWeapon(cajasdemike)
		registerCallback_wormStartFiringWeapon(prefireweap)
		--registerCallback_fireWeapon(explosion_magic)
		--registerCallback_fireWeapon(spin_dash)

		CTaskTeam_RegisterCallback_vtable8(team)
		CTaskWorm_RegisterCallback_vtable8(worm)
		CTaskMine_RegisterCallback_vtable8(mine)
		--CTaskLand_RegisterCallback_vtable8(land)
		--addmessages()
		CTaskMissile_RegisterCallback_vtable8(missile)
		CTaskOildrum_RegisterCallback_vtable8(oildrum)
		CTaskCrate_RegisterCallback_vtable8(crate)
		registerCallback_handleCreateExplosion(explode)
		registerCallback_handleSpecialImpact(explodesp)
		
		registerCallback_createWeaponProjectile(proj)
		
		registerCallback_weaponRelease(weaprel)
		
		--CTaskWorm_RegisterCallback_vtable0(scream1)
		--CTaskWorm_RegisterCallback_vtable4(scream2)
		----CTaskWorm_RegisterCallback_vtable8(scream3) --message
		--CTaskWorm_RegisterCallback_vtableC(scream4)
		--CTaskWorm_RegisterCallback_vtable10(scream5)
		--CTaskWorm_RegisterCallback_vtable14(scream6)
		--CTaskWorm_RegisterCallback_vtable18(scream7) --fires constantly too, like message
		
		
	end
	ResetStuff()
	InitWormData()
	gavedrill = false
	--sounds must me in the same order as they are in the programm start
 customsound = registerCustomSound("DATA/User/Fanfare/Team17-Applauds.wav")
 customsound2 = registerCustomSound("DATA/Streams/new-win-bronze.wav")
 customsoundtele = registerCustomSound("DATA/Wav/Effects/TELEPORT.wav")
--local zxc = registerCustomSound("DATA/User/Fanfare/Gong.wav")
--local pokeball_release_sound = registerCustomSound("jelly/sounds/pokeball release sound.wav")
--local weapon_select_sound = registerCustomSound("jelly/sounds/weapon select sound.wav")
--local megumin_theme = registerCustomSound("jelly/sounds/megumin theme.wav")
 equino_sfx = registerCustomSound("jelly/sounds/equino.wav")
 LG_sfx = registerCustomSound("jelly/sounds/lowgravity.wav")
 LGoff_sfx = registerCustomSound("jelly/sounds/lowgravityoff.wav")
 equinoscream_sfx = registerCustomSound("jelly/sounds/equinoscream.wav")
 gotmail_sfx = registerCustomSound("jelly/sounds/gotmail.wav")
 afano_sfx = registerCustomSound("jelly/sounds/afano.wav")
 afanop_sfx = registerCustomSound("jelly/sounds/afanoplus.wav")
 sheepme_sfx = registerCustomSound("jelly/sounds/sheepme.wav")
 
 sentryplace_sfx = registerCustomSound("jelly/sounds/SentryPlace.wav")
 sentryfire1_sfx = registerCustomSound("jelly/sounds/SentryFireLoop_01.wav")
sentryfiredry1_sfx = registerCustomSound("jelly/sounds/SentryDryFire_05.wav")
sentryactivate_sfx = registerCustomSound("jelly/sounds/SentryActivate.wav")
sentrydactivate_sfx = registerCustomSound("jelly/sounds/SentryDeactivate.wav")


--textures

 customsprite = registerCustomSprite("jelly/sprites/teleport.spr")
 shapka = registerCustomSprite("jelly/sprites/shapka.spr")
 pokeball_sprite = registerCustomSprite("jelly/sprites/pokeball_sprite.spr")
 magnet_sprite = registerCustomSprite("jelly/sprites/magnet.spr")
 magnetr_sprite = registerCustomSprite("jelly/sprites/magnetr.spr")
 magnetd_sprite = registerCustomSprite("jelly/sprites/magnetd.spr")
 magnetd_spritelnk = registerCustomSprite("jelly/sprites/wmagnetink.spr")
 magnetd_spritelnkr = registerCustomSprite("jelly/sprites/wmagnetinkr.spr")
 magnetd_spritelnkd = registerCustomSprite("jelly/sprites/wmagnetinkd.spr")
--local magnetd_spritelnkrd = registerCustomSprite("jelly/sprites/wmagnetinkrd.spr")
 magnetd_spritelnku = registerCustomSprite("jelly/sprites/wmagnetinku.spr")
--local magnetd_spritelnkru = registerCustomSprite("jelly/sprites/wmagnetinkru.spr")
 wdrill_sprite = registerCustomSprite("jelly/sprites/wdrill.spr")
 wjetgun_spriteinit = registerCustomSprite("jelly/sprites/jetguninit.spr")
 wjetgun_sprite = registerCustomSprite("jelly/sprites/wjetgun.spr")
 wjetgun_sprite2 = registerCustomSprite("jelly/sprites/wjetgun2.spr")
 wjetgun_sprite3 = registerCustomSprite("jelly/sprites/wjetgun3.spr")
 wjetgun_sprite4 = registerCustomSprite("jelly/sprites/wjetgun4.spr")
 wjetgun_spriteShoot = registerCustomSprite("jelly/sprites/wjetgunshoot.spr") 
 wave_sprite = registerCustomSprite("jelly/sprites/magnetwave.spr")
 equino_sprite = registerCustomSprite("jelly/sprites/equino.spr")
 hook_sprite = registerCustomSprite("jelly/sprites/hook.spr")
 
 	equinohold = registerCustomSprite("jelly/sprites/equinohold.spr")
	equinoholdd = registerCustomSprite("jelly/sprites/equinoholdd.spr")
	equinoholdu = registerCustomSprite("jelly/sprites/equinoholdu.spr")
	
	turrethold = registerCustomSprite("jelly/sprites/turrethold.spr")
	turretholdd = registerCustomSprite("jelly/sprites/turretholdd.spr")
	turretholdu = registerCustomSprite("jelly/sprites/turretholdu.spr")
	
	turret1hold = registerCustomSprite("jelly/sprites/turret1hold.spr")
	turret1holdd = registerCustomSprite("jelly/sprites/turret1holdd.spr")
	turret1holdu = registerCustomSprite("jelly/sprites/turret1holdu.spr")
	
	estafetahold = registerCustomSprite("jelly/sprites/estafetahold.spr")
	estafetaholdd = registerCustomSprite("jelly/sprites/estafetaholdd.spr")
	estafetaholdu = registerCustomSprite("jelly/sprites/estafetaholdu.spr")
	
	estafeta1hold = registerCustomSprite("jelly/sprites/estafeta1hold.spr")
	estafeta1holdd = registerCustomSprite("jelly/sprites/estafeta1holdd.spr")
	estafeta1holdu = registerCustomSprite("jelly/sprites/estafeta1holdu.spr")
	
	mailmike[1] = registerCustomSprite("jelly/sprites/mailmike.spr")
    mailmike[2] = registerCustomSprite("jelly/sprites/mailmike1.spr")
	
	turretspr[0] = registerCustomSprite("jelly/sprites/turret0.spr")
	turretspr[1] = registerCustomSprite("jelly/sprites/turret.spr")
	turretspr[2] = registerCustomSprite("jelly/sprites/turret1.spr")
	
	turretstand = registerCustomSprite("jelly/sprites/turretstand.spr")
	turretfire = registerCustomSprite("jelly/sprites/turretfire.spr")
	
	
	worms = {}
	customweapons = {}
	animations = {}
	sprites = {}
	magnets = {}
    repeltimers = {}
	--PrintStuff(getWeaponData(Weapon_JetPack))
	textboxReplace("Imaik (","Imaik - REPEL (")
	--table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/feather.img", "Afanar", "Afanar")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DDrillStruct,getWeaponData(Weapon_PneumaticDrill)), "jelly/placeholders/drill.img", "Taladro Inverso", "Taladro Inverso")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/dado.img", "Dadodemike", "Dadodemike")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/sheepme.img", "Ovejame el Mike", "Ovejame el Mike")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/feather.img", "Doble Salto", "Doble Salto")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/vacunatorio.img", "Vacunatorio de Mike", "Vacunatorio de Mike")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/jetgun.img", "AmetraJetPack de Mike", "AmetraJetPack de Mike")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(MagnetStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/magnet.img", "Imaik", "Imaik")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(MagnetStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/mailmike.img", "Estafeta de Mike", "Estafeta de Mike")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/afano.img", "Afano de Mike", "Afano de Mike")) --Weapon_MikeWorm
	
	FillStruct(TeleparachuteStruct,getWeaponData(Weapon_Teleport))
	
	FillStruct(HorseStruct,getWeaponData(Weapon_Sheep))
	HorseStruct:GetExtraData().sprite.spriteid = equino_sprite
	HorseStruct:GetExtraData():GetAction().RoamFlags = HorseStruct:GetExtraData():GetAction().RoamFlags & (~CollisionFlag_WORM_IN_MIDAIR)
	HorseStruct:GetExtraData():GetAction().TerrainOffset = 0
	HorseStruct:GetExtraData():GetAction().JumpAngle = 0
	HorseStruct:GetExtraData():GetAction().JumpVelocity = 6969
	HorseStruct:GetExtraData().spacetriggered = 0
	HorseStruct:GetExtraData().explosioncountdown = 5000
	HorseStruct:GetExtraData().explosiontimer = 10000
	--HorseStruct:GetExtraData():GetAction().JumpEdgeVelocity = 0
	--HorseStruct:GetExtraData():GetAction().JumpEdgeAngle = 0
	HorseStruct:GetExtraData():GetAction().TerrainTolerance = 10
	HorseStruct:GetExtraData():GetAction().JumpSound = equinoscream_sfx
	HorseStruct:GetExtraData().sound.soundid = equinoscream_sfx
	table.insert(customweapons,registerCustomWeapon(HorseStruct, "jelly/placeholders/equino.img", "Maiktungo", "Maiktungo")) -- Weapon_Jump
	
	--table.insert(customweapons,registerCustomWeapon(FillStruct(WormUziStruct,getWeaponData(Weapon_Uzi)), "jelly/placeholders/worm.img", "Wormuzi de Mike", "Wormuzi de Mike")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(JumpStruct, "jelly/placeholders/Jump.img", "Salto", "Salto")) -- Weapon_Jump
	table.insert(customweapons,registerCustomWeapon(LaserGunStructure, "jelly/placeholders/maxi.img", "MaxiEshcopeta", "MaxiEshcopeta")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(SwapStruct, "jelly/placeholders/swap.img", "Telemikesporte", "Telemikesporte")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(TeleparachuteStruct, "jelly/placeholders/teleparachute.img", "Teletransparacaidas", "Teletransparacaidas")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(AlabacionStruct, "jelly/placeholders/corazon.img", "Ablacion de Mike", "Ablacion de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(MadCowStruct, "jelly/placeholders/cow.img", "Vaca de Mike", "Vaca de Mike")) --Weapon_MikeCow
	table.insert(customweapons,registerCustomWeapon(WormstrikeStruct, "jelly/placeholders/worm.img", "Worms de Mike", "Worms de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(ClusterBombStruct, "jelly/placeholders/cluster.img", "Cluster de Mike", "Cluster de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(DynamiteStruct, "jelly/placeholders/dinamite.img", "Dinamita de Mike", "Dinamita de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(HomingMissileStruct, "jelly/placeholders/homer.img", "Homer de Mike", "Homer de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(SheepStruct, "jelly/placeholders/sheep.img", "Oveja de Mike", "Oveja de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(MoleBombStruct, "jelly/placeholders/mole.img", "Topu de Mike", "Topu de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(PetrolBombStruct, "jelly/placeholders/petrol.img", "Gasolina de Mike", "Gasolina de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(OldWomanStruct, "jelly/placeholders/granny.img", "Anshiana de Mike", "Anshiana de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(GrenadeStruct, "jelly/placeholders/green.img", "Ataque de grenado", "Ataque de grenado")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(MortarStruct, "jelly/placeholders/mortar.img", "Mortero de Mike", "Mortero de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(CajasDeMikeStruct, "jelly/placeholders/caja.img", "Cajas de Mike", "Cajas de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(CajasDeMikeStruct, "jelly/placeholders/hp.img", "Salud de Mike", "Salud de Mike")) --Weapon_MikeWorm
	table.insert(customweapons,registerCustomWeapon(CajasDeMikeStruct, "jelly/placeholders/mike.img", "Mike", "Mike")) --Weapon_MikeWorm
	
	--table.insert(customweapons,registerCustomWeapon(CajasDeMikeStruct, "jelly/placeholders/hp.img", "Vacunos Interdimensionales de Mike", "Vacunos Interdimensionales de Mike")) --Weapon_MikeWorm
	
	
	
	
	table.insert(customweapons,registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/hook.img", "JetGancho de Mike", "JetGancho de Mike")) -- Weapon_Jump
	--table.insert(customweapons,registerCustomWeapon(FillStruct(WormUziStruct,getWeaponData(Weapon_Bazooka)), "jelly/placeholders/hook.img", "LanzaWorm de Mike", "LanzaWorm de Mike")) -- Weapon_Jump
	
	--table.insert(customweapons,registerCustomWeapon(FillStruct(MagnetStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/magnet.img", "PoxiMike", "PoxiMike")) -- Weapon_Jump
	
	table.insert(customweapons,registerCustomWeapon(FillStruct(MagnetStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/turret.img", "Centinela de Mike", "Centinela de Mike")) -- Weapon_Jump
	
	registerCustomWeapon(FillStruct(DJumpStruct,getWeaponData(Weapon_LaserSight)), "jelly/placeholders/vacuna.img", "Inoculacion de Mike", "Inoculacion de Mike") -- Weapon_Jump
	
	
	registerCustomWeapon(FillStruct(JumpStruct,getWeaponData(Weapon_ShotGun)), "jelly/placeholders/Weapon24.img", "Lazor", "Lazor") -- Weapon_Jump
	registerCustomWeapon(FillStruct(DDrillStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/Weapon1.img", "Test OBJCol", "Test OBJCol") -- Weapon_Jump
	registerCustomWeapon(FillStruct(DDrillStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/Weapon2.img", "Test OBJCol2", "Test OBJCol2") -- Weapon_Jump
	registerCustomWeapon(FillStruct(DDrillStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/Weapon3.img", "Test OBJCol3", "Test OBJCol3") -- Weapon_Jump
	registerCustomWeapon(FillStruct(DDrillStruct,getWeaponData(Weapon_Dynamite)), "jelly/placeholders/Weapon4.img", "Test TerrainCol", "Test TerrainCol") -- Weapon_Jump
	
	registerCustomWeapon(CajasDeMikeStruct, "jelly/placeholders/koolaid.img", "Tang", "Tang") -- Weapon_Jump
	
	customblockwhitelist[customweaponsbyname["Vacunatorio de Mike"]] = true
	customblockwhitelist[customweaponsbyname["Ablacion de Mike"]] = true
	customblockwhitelist[customweaponsbyname["Afano de Mike"]] = true
	--table.insert(customweapons,registerCustomWeapon(SuperSheepStruct, "jelly/placeholders/mortar.img", "Mortero de Mike", "Mortero de Mike")) --Weapon_MikeWorm
	--PrintWeapon(getWeaponData(Weapon_Skunk))
	
	
	setUtilityWeapon(customweaponsbyname["Doble Salto"],true)
	setSheepWeapon(customweaponsbyname["Oveja de Mike"],true)
	setSuperWeapon(customweaponsbyname["Ataque de grenado"],true)
	
	for i,e in pairs(customweapons) do
		weapons[e] = true
		ultimoblock[e] = true
		blockjetpack[e] = true
	--	for x=0,6,1 do
	--		setTeamAmmo(x,e,0,-1)
	--		setTeamAmmo(x,e,1,0)
	--	end
	end
	return 0
end


--setSuperWeapon(Weapon_Parachute,true)
--setSuperWeapon(Weapon_Donkey,false)
--setSuperWeapon(Weapon_Bazooka,true)
--handleOnChatInput(char *msg)
--playSoundLocal(0x10000, 0x10000, This, weapon_select_sound, 8)
--showChatMessage("message: " .. messagetype .. "/" .. cnt, 2)
--createExplosion(This, This.posX, This.posY, 100, 30, 1, 1)

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


--	ut["name1"] = sol::readonly(&WeaponStruct::name1);
--	ut["name2"] = sol::readonly(&WeaponStruct::name2);
--	ut["panelRow"] = &WeaponStruct::panelRow;
--	ut["unknownC"] = &WeaponStruct::remembered;
--	ut["unknown10"] = &WeaponStruct::usableincavern;
--	ut["unknown14"] = &WeaponStruct::numberofshots;
--	ut["unknown18"] = &WeaponStruct::endsturn;
--	ut["unknown1C"] = &WeaponStruct::retreattime;
--	ut["unknown20"] = &WeaponStruct::unknown20;
--	ut["unknown24"] = &WeaponStruct::cratechance;
--	ut["unknown28"] = &WeaponStruct::crateammo;
--	ut["unknown2C"] = &WeaponStruct::customdata;
--	ut["unknown30"] = &WeaponStruct::activationtype;
--	ut["unknown34"] = &WeaponStruct::activationparam;
--
--
--	ut["unknown38"] = &WeaponStruct::Param1;
--	ut["Param1"] = &WeaponStruct::Param1;
--	ut["suicidebomberpoison"] = &WeaponStruct::Param1;
--	ut["unknown3C"] = &WeaponStruct::Param2;
--	ut["Param2"] = &WeaponStruct::Param2;
--	ut["kamiexplosionpower"] = &WeaponStruct::Param2;
--	ut["suicidexplosionpower"] = &WeaponStruct::Param2;
--	ut["unknown40"] = &WeaponStruct::Param3;
--	ut["Param3"] = &WeaponStruct::Param3;
--	ut["unknown44"] = &WeaponStruct::Param4;
--	ut["Param4"] = &WeaponStruct::Param4;
--	ut["unknown48"] = &WeaponStruct::Param5;
--	ut["Param5"] = &WeaponStruct::Param5;
--	ut["unknown4C"] = &WeaponStruct::Param6;
--	ut["Param6"] = &WeaponStruct::Param6;
--	ut["unknown50"] = &WeaponStruct::Param7;
--	ut["Param7"] = &WeaponStruct::Param7;
--	ut["unknown54"] = &WeaponStruct::unknown54;
--	ut["unknown58"] = &WeaponStruct::unknown58;
--	ut["unknown5C"] = &WeaponStruct::unknown5C;
--	ut["unknown60"] = &WeaponStruct::unknown60;
--	ut["unknown64"] = &WeaponStruct::unknown64;
--	ut["unknown68"] = &WeaponStruct::unknown68;
--	ut["unknown6C"] = &WeaponStruct::unknown6C;
--	ut["unknown70"] = &WeaponStruct::unknown70;
--	ut["unknown74"] = &WeaponStruct::unknown74;
--	ut["unknown78"] = &WeaponStruct::unknown78;
--	ut["unknown7C"] = &WeaponStruct::unknown7C;
--	ut["unknown80"] = &WeaponStruct::unknown80;
--	ut["unknown84"] = &WeaponStruct::unknown84;
--	ut["unknown88"] = &WeaponStruct::unknown88;
--	ut["unknown8C"] = &WeaponStruct::unknown8C;
--	ut["unknown90"] = &WeaponStruct::unknown90;
--	ut["unknown94"] = &WeaponStruct::unknown94;
--	ut["unknown98"] = &WeaponStruct::unknown98;
--
--	ut["unknown9C"] = &WeaponStruct::unknown9C;
--	ut["unknownA0"] = &WeaponStruct::unknownA0;
--	ut["unknownA4"] = &WeaponStruct::unknownA4;
--	ut["unknownA8"] = &WeaponStruct::unknownA8;
--	ut["unknownAC"] = &WeaponStruct::unknownAC;
--	ut["unknownB0"] = &WeaponStruct::unknownB0;
--	ut["unknownB4"] = &WeaponStruct::unknownB4;
--	ut["unknownB8"] = &WeaponStruct::unknownB8;
--	ut["unknownBC"] = &WeaponStruct::unknownBC;
--	ut["unknownC0"] = &WeaponStruct::unknownC0;
--	ut["unknownC4"] = &WeaponStruct::unknownC4;
--	ut["unknownC8"] = &WeaponStruct::unknownC8;
--	ut["unknownCC"] = &WeaponStruct::unknownCC;
--	ut["unknownD0"] = &WeaponStruct::unknownD0;
--	ut["unknownD4"] = &WeaponStruct::unknownD4;
--	ut["unknownD8"] = &WeaponStruct::unknownD8;
--	ut["unknownDC"] = &WeaponStruct::unknownDC;
--	ut["unknownE0"] = &WeaponStruct::unknownE0;
--	ut["unknownE4"] = &WeaponStruct::unknownE4;
--	ut["unknownE8"] = &WeaponStruct::unknownE8;
--	ut["unknownEC"] = &WeaponStruct::unknownEC;
--	ut["unknownF0"] = &WeaponStruct::unknownF0;
--	ut["unknownF4"] = &WeaponStruct::unknownF4;
--	ut["unknownF8"] = &WeaponStruct::unknownF8;
--	ut["unknownFC"] = &WeaponStruct::unknownFC;
--	ut["unknown100"] = &WeaponStruct::unknown100;
--	ut["unknown104"] = &WeaponStruct::unknown104;
--	ut["unknown108"] = &WeaponStruct::unknown108;
--	ut["unknown10C"] = &WeaponStruct::unknown10C;
--	ut["unknown110"] = &WeaponStruct::unknown110;
--	ut["unknown114"] = &WeaponStruct::unknown114;
--	ut["unknown118"] = &WeaponStruct::unknown118;
--	ut["unknown11C"] = &WeaponStruct::unknown11C;
--	ut["unknown120"] = &WeaponStruct::unknown120;
--	ut["unknown124"] = &WeaponStruct::unknown124;
--	ut["unknown128"] = &WeaponStruct::unknown128;
--	ut["unknown12C"] = &WeaponStruct::unknown12C;
--	ut["unknown130"] = &WeaponStruct::unknown130;
--	ut["unknown134"] = &WeaponStruct::unknown134;
--	ut["unknown138"] = &WeaponStruct::unknown138;
--	ut["unknown13C"] = &WeaponStruct::unknown13C;
--	ut["unknown140"] = &WeaponStruct::unknown140;
--	ut["unknown144"] = &WeaponStruct::unknown144;
--	ut["unknown148"] = &WeaponStruct::unknown148;
--	ut["unknown14C"] = &WeaponStruct::unknown14C;
--	ut["unknown150"] = &WeaponStruct::unknown150;
--	ut["unknown154"] = &WeaponStruct::unknown154;
--	ut["unknown158"] = &WeaponStruct::unknown158;
--	ut["unknown15C"] = &WeaponStruct::unknown15C;
--	ut["unknown160"] = &WeaponStruct::unknown160;
--	ut["unknown164"] = &WeaponStruct::unknown164;
--	ut["unknown168"] = &WeaponStruct::unknown168;
--	ut["unknown16C"] = &WeaponStruct::unknown16C;
--	ut["unknown170"] = &WeaponStruct::unknown170;
--	ut["unknown174"] = &WeaponStruct::unknown174;
--	ut["unknown178"] = &WeaponStruct::unknown178;
--	ut["unknown17C"] = &WeaponStruct::unknown17C;
--	ut["unknown180"] = &WeaponStruct::unknown180;
--	ut["unknown184"] = &WeaponStruct::unknown184;
--	ut["unknown188"] = &WeaponStruct::unknown188;
--	ut["unknown18C"] = &WeaponStruct::unknown18C;
--	ut["unknown190"] = &WeaponStruct::unknown190;
--	ut["unknown194"] = &WeaponStruct::unknown194;
--	ut["unknown198"] = &WeaponStruct::unknown198;
--	ut["unknown19C"] = &WeaponStruct::unknown19C;
--	ut["unknown1A0"] = &WeaponStruct::unknown1A0;
--	ut["unknown1A4"] = &WeaponStruct::unknown1A4;
--	ut["unknown1A8"] = &WeaponStruct::unknown1A8;
--	ut["unknown1AC"] = &WeaponStruct::unknown1AC;
--	ut["unknown1B0"] = &WeaponStruct::unknown1B0;
--	ut["unknown1B4"] = &WeaponStruct::unknown1B4;
--	ut["unknown1B8"] = &WeaponStruct::unknown1B8;
--	ut["unknown1BC"] = &WeaponStruct::unknown1BC;
--	ut["unknown1C0"] = &WeaponStruct::unknown1C0;
--	ut["unknown1C4"] = &WeaponStruct::unknown1C4;
--	ut["unknown1C8"] = &WeaponStruct::unknown1C8;
--	ut["unknown1CC"] = &WeaponStruct::unknown1CC;
--
--
--
--	ut["remembered"] = &WeaponStruct::remembered;
--	ut["usableincavern"] = &WeaponStruct::usableincavern;
--	ut["numberofshots"] = &WeaponStruct::numberofshots;
--	ut["endsturn"] = &WeaponStruct::endsturn;
--	ut["retreattime"] = &WeaponStruct::retreattime;
--	ut["unknown20"] = &WeaponStruct::unknown20;
--	ut["cratechance"] = &WeaponStruct::cratechance;
--	ut["crateammo"] = &WeaponStruct::crateammo;
--	ut["customdata"] = &WeaponStruct::customdata;
--	ut["activationtype"] = &WeaponStruct::activationtype;
--	ut["activationparam"] = &WeaponStruct::activationparam;
--	ut["herdsize"] = &WeaponStruct::activationparam;
--	ut["airstrikesubtype"] = &WeaponStruct::activationparam;
--	ut["spaceaction"] = &WeaponStruct::activationparam;
--	ut["guntype"] = &WeaponStruct::Param1;
--	ut["crossairtype"] = &WeaponStruct::Param1;
--	ut["planesprite"] = &WeaponStruct::Param1;
--
--
--	ut["asbombscount"] = &WeaponStruct::Param2;
--	ut["asdistancebetweendrops"] = &WeaponStruct::Param3;
--	ut["ashorizontalspeed"] = &WeaponStruct::Param4;
--	ut["assound"] = &WeaponStruct::Param5;
--	ut["astype"] = &WeaponStruct::Param6;
--	ut["skunkpower"] = &WeaponStruct::unknown118;
--
--
--	ut["GetLauncherData"] = &CustomWeapons::GetLauncherData;
--	ut["GetGunData"] = &CustomWeapons::GetGunData;
--	ut["GetFlamethrowerData"] = &CustomWeapons::GetFlamethrowerData;
--	ut["GetExtraData"] = &CustomWeapons::GetExtraData;
--
--	
--	sol::usertype <Launcher> pt = lua->new_usertype<Launcher>("Launcher");
--	pt["spritesize"] = &Launcher::spritesize; // 0x3C
--	pt["fixedspeed"] = &Launcher::fixedspeed; // 0x40
--	pt["makesscream"] = &Launcher::makesscream; // 0x44
--	pt["explosioncolflags"] = &Launcher::explosioncolflags; // 0x48
--	pt["explosionbias"] = &Launcher::explosionbias; // 0x4C
--	pt["explosionpush"] = &Launcher::explosionpush; // 0x50
--	pt["explosiondmg"] = &Launcher::explosiondmg; // 0x54
--	pt["explosiondmgvariation"] = &Launcher::explosiondmgvariation; // 0x58
--	pt["unknown5C"] = &Launcher::unknown5C; // 0x5C
--	pt["animation"] = &Launcher::animation; // 0x60
--	pt["variablespeed"] = &Launcher::variablespeed; // 0x78
--	pt["windfactor"] = &Launcher::windfactor; // 0x7C
--	pt["motionrandomness"] = &Launcher::motionrandomness; // 0x80
--	pt["gravityfactor"] = &Launcher::gravityfactor; // 0x84
--	pt["explotioncountdown"] = &Launcher::explotioncountdown; // 0x88
--	pt["explosiontimer"] = &Launcher::explosiontimer; // 0x8C
--	pt["sound"] = &Launcher::sound; // 0x90
--	pt["spacetriggered"] = &Launcher::spacetriggered; // 0xA0
--	pt["explosionactiontype"] = &Launcher::explosionactiontype; // 0xA4
--	pt["explosionaction"] = &Launcher::explosionaction;
--	pt["explosiontarget"] = &Launcher::explosiontarget; // 0xF0
--	pt["GetAction"] = &CustomWeapons::GetActionDataL;
--	pt["GetExplosionTarget"] = &CustomWeapons::GetExplosionTargetL;
--
--
--
--
--	sol::usertype <Sound> st = lua->new_usertype<Sound>("Sound");
--	st["soundid"] = &Sound::soundid;
--	st["loop"] = &Sound::loop;
--	st["isexplosion"] = &Sound::isexplosion;
--	st["beforeexplosion"] = &Sound::beforeexplosion;
--	st["delay"] = &Sound::delay;
--
--	sol::usertype <Mine> Mt = lua->new_usertype<Mine>("Mine");
--	Mt["radius"] = &Mine::Radius;
--	Mt["delay"] = &Mine::Delay;
--	Mt["collisionflags"] = &Mine::DetectionFlags; //for detection
--	Mt["fusetime"] = &Mine::FuseTime;
--	Mt["bias"] = &Mine::ExplosionBias;
--	Mt["power"] = &Mine::Power;
--	Mt["damage"] = &Mine::Damage;
--
--	sol::usertype <Airstrike> aat = lua->new_usertype<Airstrike>("Airstrike");
--	aat["PlaneSprite"] = &Airstrike::PlaneSprite; // 0x3C
--	aat["BombsCount"] = &Airstrike::BombsCount; // 0x3C
--	aat["DropsSpacing"] = &Airstrike::DropsSpacing; // 0x3C
--	aat["PlaneSpeed"] = &Airstrike::PlaneSpeed; // 0x3C
--	aat["Sound"] = &Airstrike::Sound; // 0x3C
--	aat["Action"] = &Airstrike::Action; // 0x3C
--	aat["ActionData"] = &Airstrike::ActionData; // 0x3C
--	aat["GetAction"] = &CustomWeapons::GetActionDataAS;
--
--	sol::usertype <Canister> cat = lua->new_usertype<Canister>("Canister");
--	cat["SpriteInactive"] = &Canister::SpriteInactive; // 0x3C
--	cat["SpriteActive"] = &Canister::SpriteActive; // 0x40
--	cat["PoisonAmount"] = &Canister::PoisonAmount; // 0x44
--	cat["Damage"] = &Canister::Damage; // 0x48
--
--	sol::usertype <Gun> scat = lua->new_usertype<Gun>("Gun");
--	scat["bulletcount"] =&Gun::bulletcount; // 0x3C
--	scat["reloadtime"] =&Gun::reloadtime; // 0x40
--	scat["bulletspread"] =&Gun::bulletspread; // 0x44
--	scat["brust"] =&Gun::brust; // 0x48
--	scat["brustspread"] =&Gun::brustspread; // 0x4C
--	scat["collisionflags"] =&Gun::collisionflags; // 0x50
--	scat["bias"] =&Gun::bias; // 0x54
--	scat["power"] =&Gun::power; // 0x58
--	scat["maxdmg"] =&Gun::maxdmg; // 0x5C
--	scat["dmgspread"] =&Gun::dmgspread; // 0x60
--	scat["expeffect"] =&Gun::expeffect; // 0x64
--	scat["range1"] =&Gun::range1; // 0x68
--	scat["range2"] =&Gun::range2; // 0x6C
--	scat["range3"] =&Gun::range3; // 0x70
--
--	sol::usertype <BounceAction> cato = lua->new_usertype<BounceAction>("BounceAction");
--	cato["BounceFlags"] =&BounceAction::BounceFlags; // 0xA8
--	cato["Bounciness"] =&BounceAction::Bounciness; // 0xAC
--	cato["Acceleration"] =&BounceAction::Acceleration; // 0xB0
--	cato["Sound"] =&BounceAction::Sound; // 0xB4
--	cato["Unk1"] =&BounceAction::Unk1; // 0xB8
--	cato["Unk2"] =&BounceAction::Unk2; // 0xBC
--	cato["Explosionbias"] =&BounceAction::Explosionbias; // 0xC0
--	cato["Power"] =&BounceAction::Power; // 0xC4
--	cato["Damage"] =&BounceAction::Damage; // 0xC8
--	cato["RandomDamage"] =&BounceAction::RandomDamage; // 0xCC
--	cato["NumberOfBounces"] =&BounceAction::NumberOfBounces; // 0xD0
--
--	sol::usertype <RoamAction> cawt = lua->new_usertype<RoamAction>("RoamAction");
--		cawt["RoamFlags"] =&RoamAction::RoamFlags; // 0xA8
--		cawt["ExplodeFlags"] =&RoamAction::ExplodeFlags; // 0xAC
--		cawt["WalkSpeed"] =&RoamAction::WalkSpeed; // 0xB0
--		cawt["TerrainTolerance"] =&RoamAction::Unknown; // 0xB4
--		cawt["JumpEdgeAngle"] =&RoamAction::JumpEdgeAngle; // 0xB8
--		cawt["JumpEdgeVelocity"] =&RoamAction::JumpEdgeVelocity; // 0xBC
--		cawt["JumpEdgeSound"] =&RoamAction::JumpEdgeSound; // 0xC0
--		cawt["JumpAngle"] =&RoamAction::JumpAngle; // 0xC4
--		cawt["JumpVelocity"] =&RoamAction::JumpVelocity; // 0xC8
--		cawt["JumpSound"] =&RoamAction::JumpSound; // 0xCC
--		cawt["TerrainOffset"] =&RoamAction::TerrainOffset; // 0xD0
--		cawt["Fart"] =&RoamAction::Fart; // 0xD4
--		cawt["PoisonPower"] =&RoamAction::PoisonPower; // 0xD8
--		cawt["FartSprite"] =&RoamAction::FartSprite; // 0xDC
--		cawt["FlySprite"] =&RoamAction::FlySprite; // 0xE0
--		cawt["FlySprite2"] =&RoamAction::FlySprite2; // 0xE4
--		cawt["TakingOffSprite"] =&RoamAction::TakingOffSprite; // 0xE8
--		cawt["FlyingSprite"] =&RoamAction::FlyingSprite; // 0xEC
--
--		sol::usertype <HomingAction> dd = lua->new_usertype<HomingAction>("HomingAction");
--		dd["Unused"] =&HomingAction::Unused; // 0xA8
--		dd["Sprite"] =&HomingAction::Sprite; // 0xAC
--		dd["type"] =&HomingAction::type; // 0xB0
--		dd["delay"] =&HomingAction::delay; // 0xB4
--		dd["duration"] =&HomingAction::duration; // 0xB8
--
--		sol::usertype <DigAction> ddig = lua->new_usertype<DigAction>("DigAction");
--		ddig["Unk1"] =&DigAction::Unk1; // 0xA8
--		ddig["Unk2"] =&DigAction::Unk2; // 0xAC
--		ddig["Sound"] =&DigAction::Sound; // 0xB0
--		ddig["JumpingSprite"] =&DigAction::JumpingSprite; // 0xB4
--		ddig["Sprite1"] =&DigAction::Sprite1; // 0xB8
--		ddig["Sprite2"] =&DigAction::Sprite2; // 0xBC
--		ddig["Sprite3"] =&DigAction::Sprite3; // 0xC0
--
--		sol::usertype <Flamethrower> dds = lua->new_usertype<Flamethrower>("Flamethrower");
--		dds["fuel"] =&Flamethrower::fuel; // 0x3C
--		dds["fireintensity"] =&Flamethrower::fireintensity; // 0x40
--		dds["fireamount"] =&Flamethrower::fireamount; // 0x44
--		dds["burntime"] =&Flamethrower::burntime; // 0x48
--		dds["persistent"] =&Flamethrower::persistent; // 0x4C
--
--
--		sol::usertype <ClusterExplosion> ddas = lua->new_usertype<ClusterExplosion>("ClusterExplosion");
--		ddas["amount"] = &ClusterExplosion::amount;
--		ddas["dispersion"] = &ClusterExplosion::dispersion;
--		ddas["speed"] = &ClusterExplosion::speed;
--		ddas["EjectionAngle"] = &ClusterExplosion::EjectionAngle;
--		ddas["DispersionAngle"] = &ClusterExplosion::DispersionAngle;
--		ddas["CollisionFlags"] = &ClusterExplosion::CollisionFlags;
--		ddas["Bias"] = &ClusterExplosion::Bias;
--		ddas["PushPower"] = &ClusterExplosion::PushPower;
--		ddas["Damage"] = &ClusterExplosion::Damage;
--		ddas["DamageVariation"] = &ClusterExplosion::DamageVariation;
--		ddas["Unknown"] = &ClusterExplosion::Unknown;
--		ddas["Animation"] = &ClusterExplosion::Animation;
--		ddas["Acceleration"] = &ClusterExplosion::Acceleration;
--		ddas["WindFactor"] = &ClusterExplosion::WindFactor;
--		ddas["Randomness"] = &ClusterExplosion::Randomness;
--		ddas["Gravity"] = &ClusterExplosion::Gravity;
--		ddas["Unused"] = &ClusterExplosion::Unused;
--		ddas["Unused2"] = &ClusterExplosion::Unused2;
--		ddas["Sound"] = &ClusterExplosion::Sound;
--		ddas["Spacebar"] = &ClusterExplosion::Spacebar;
--		ddas["Action"] = &ClusterExplosion::Action;
--		ddas["ExplosionAction"] =&ClusterExplosion::ExplosionAction;
--		ddas["GetAction"] = &CustomWeapons::GetActionData;
--
--		sol::usertype <FireExplosion> ddss = lua->new_usertype<FireExplosion>("FireExplosion");
--		ddss["power"] =&FireExplosion::power; // 0x3C
--		ddss["spread"] =&FireExplosion::spread; // 0x40
--		ddss["duration"] =&FireExplosion::duration; // 0x44
--		ddss["persist"] =&FireExplosion::persist; // 0x48
--
--		sol::usertype <DragonBall> db = lua->new_usertype<DragonBall>("DragonBall");
--			db["Sound"] =&DragonBall::Sound; // 0x38
--			db["ImpactSound"] =&DragonBall::ImpactSound; // 0x3C
--			db["Sprite"] =&DragonBall::Sprite; // 0x40
--			db["Damage"] =&DragonBall::Damage; // 0x44
--			db["Angle"] =&DragonBall::Angle; // 0x48
--			db["Force"] =&DragonBall::Force; // 0x4C
--			db["FlyingTime"] =&DragonBall::FlyingTime; // 0x50
--
--		sol::usertype <Kamikaze> km = lua->new_usertype<Kamikaze>("Kamikaze");
--			km["FlyingTime"] =&Kamikaze::FlyingTime; // 0x38
--			km["ExplosionDamage"] =&Kamikaze::ExplosionDamage; // 0x3C
--			km["FireSound"] =&Kamikaze::FireSound; // 0x40
--			km["Damage"] =&Kamikaze::Damage; // 0x44
--			km["ImpactForce"] =&Kamikaze::ImpactForce; // 0x48
--			km["ImpactAngle"] =&Kamikaze::ImpactAngle; // 0x4C
--		
--		sol::usertype <FirePunch> pnch = lua->new_usertype<FirePunch>("FirePunch");
--			pnch["Damage"] =&FirePunch::Damage; // 0x38
--			pnch["Angle"] =&FirePunch::Angle; // 0x3C
--			pnch["Push"] =&FirePunch::Push; // 0x40
--			pnch["Height"] =&FirePunch::Height; // 0x44
--
--		sol::usertype <Drill> fp = lua->new_usertype<Drill>("Drill");
--			fp["Damage"] =&Drill::Damage; // 0x38
--			fp["PushPower"] =&Drill::PushPower; // 0x3C
--			fp["ImpactAngle"] =&Drill::ImpactAngle; // 0x40
--			fp["Duration"] =&Drill::Duration; // 0x44
--
--		sol::usertype <Blowtorch> blw = lua->new_usertype<Blowtorch>("Blowtorch");
--			blw["Damage"] =&Blowtorch::Damage; // 0x38
--			blw["PushPower"] =&Blowtorch::PushPower; // 0x3C
--			blw["ImpactAngle"] =&Blowtorch::ImpactAngle; // 0x40
--			blw["Duration"] =&Blowtorch::Duration; // 0x44
--
--
--			sol::usertype <Prod> prd = lua->new_usertype<Prod>("Prod");		
--			prd["Damage"] =&Prod::Damage; // 0x38
--			prd["PushPower"] =&Prod::PushPower; // 0x3C
--			prd["Angle"] =&Prod::Angle; // 0x40
--		
--
--			sol::usertype <NinjaRope> njr = lua->new_usertype<NinjaRope>("NinjaRope");
--			njr["Shots"] =&NinjaRope::Shots; // 0x38
--			njr["Length"] =&NinjaRope::Length; // 0x3C
--			njr["AngleRestriction"] =&NinjaRope::AngleRestriction; // 0x40
--		
--
--			sol::usertype <Bat> bbb = lua->new_usertype<Bat>("BaseballBat");
--			bbb["Damage"] = &Bat::Damage; // 0x38
--			bbb["PushPower"] = &Bat::PushPower; // 0x3C
--		
--
--			sol::usertype <Suicide> scb = lua->new_usertype<Suicide>("SuicideBomber");
--			scb["Poison"] = &Suicide::Poison; // 0x38
--			scb["Damage"] = &Suicide::Damage; // 0x3C
--
--		sol::usertype <NuclearTest> ntest = lua->new_usertype<NuclearTest>("NuclearTest");
--		ntest["WaterRise"] = &NuclearTest::WaterRise; // 0x38
--		ntest["Poison"] = &NuclearTest::Poison; // 0x3C
--
--		sol::usertype <JetPack> jpa = lua->new_usertype<JetPack>("JetPack");
--		jpa["Fuel"] = &JetPack::Fuel; // 0x38
--
--		sol::usertype <BattleAxe> axe = lua->new_usertype<BattleAxe>("BattleAxe");
--		axe["Percentage"] = &BattleAxe::Percentage; // 0x38
--
--		sol::usertype <Parachute> chute = lua->new_usertype<Parachute>("Parachute");		
--		chute["WindFactor"] = &Parachute::WindFactor; // 0x38
--
--