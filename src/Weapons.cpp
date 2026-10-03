#include "Weapons.h"
#include "entities/Entities.h"
#include "Game.h"
#include "Hooks.h"
#include "CustomWeapons.h"
#include <fstream>

#include "Lua.h"
#include <sol/sol.hpp>
#include "packages/PackageManager.h"
#include "entities/gametasks/CTaskMissile.h"



DWORD origWeaponRelease;
int __stdcall hookWeaponRelease(int posX, int posY, int angleX, int angleY) {
	int retv;
	CGameTask * This;
	_asm mov This, eax

//	float FangleX = (float)angleX / (float) 0xFFFF;
//	float FangleY = (float)angleY / (float) 0xFFFF;
//	printf("OnWeaponRelease: a1: %X posX: %d posY: %d angleX: %f angleY: %f\n", (int)This + 0x258, posX / 0xFFFF, posY / 0xFFFF, FangleX, FangleY);
	int ret = PackageManager::getInstance().handleWeaponRelease(This, posX, posY, angleX, angleY);
	if(ret) return ret;

	_asm mov eax, This
	_asm push angleY
	_asm push angleX
	_asm push posY
	_asm push posX
	_asm call origWeaponRelease
	_asm mov retv, eax

	return retv;
}


DWORD origWormStartFiringWeapon;
DWORD __stdcall hookWormStartFiringWeapon() {
	DWORD retv;
	CTaskWorm * worm;
	_asm mov worm, eax

	int ret = PackageManager::getInstance().handleWormStartFiringWeapon(worm);
	if(ret) return ret;

	_asm mov eax, worm
	_asm call origWormStartFiringWeapon
	_asm mov retv, eax

	return retv;
}


DWORD origFireWeapon;
int __stdcall Weapons::hookFireWeapon(CTaskWorm *worm) {
	CustomWeapons::WeaponStruct *weaponstruct;
	WeaponLaunchParams * launchparams;
	int retv;
	_asm mov weaponstruct, eax
	_asm mov launchparams, ecx

	int ret = PackageManager::getInstance().handleFireWeapon(worm, weaponstruct, launchparams);
	if(ret) return ret;

	_asm mov eax, weaponstruct
	_asm mov ecx, launchparams
	_asm push worm
	_asm call origFireWeapon
	_asm mov retv, eax

	return retv;
}

int __stdcall callFireWeapon(CTaskWorm* worm, CustomWeapons::WeaponStruct* weaponstruct, Weapons::WeaponLaunchParams* launchparams) {
	int retv;
	int ret = PackageManager::getInstance().handleFireWeapon(worm, weaponstruct, launchparams);
	if (ret) return ret;

	_asm mov eax, weaponstruct
	_asm mov ecx, launchparams
	_asm push worm
	_asm call origFireWeapon
	_asm mov retv, eax

	return retv;
}

#include <winuser.h>

CTaskMissile *(__fastcall *origCreateWeaponProjectile)(CGameTask *This, int EDX, Weapons::WeaponProjectileParams * projectileParams, Weapons::WeaponLaunchParams * weaponLaunchParams);
CTaskMissile *__fastcall Weapons::hookCreateWeaponProjectile(CGameTask *This, int EDX, WeaponProjectileParams * projectileParams, WeaponLaunchParams * launchParams) {
	int ret = PackageManager::getInstance().handleCreateWeaponProjectile(This, projectileParams, launchParams);
	if(ret) return 0;
	return origCreateWeaponProjectile(This, EDX, projectileParams, launchParams);
}

CTaskMissile *(__fastcall *origFireBulletProjectile)(CGameTask *This, int EDX, Weapons::WeaponProjectileParams * projectileParams, Weapons::WeaponLaunchParams *, CGameTask* This2);
CTaskMissile *__fastcall hookFireBulletProjectile(CGameTask *This, int EDX, Weapons::WeaponProjectileParams * projectileParams, Weapons::WeaponLaunchParams * launchParams, CGameTask* This2) {
	int ret = PackageManager::getInstance().handleFireBulletProjectile(This, projectileParams, launchParams);
	if(ret) return 0;
	//printf("bullat %d %d %d %d %d \n", This, EDX, projectileParams, launchParams, This2);
	return origFireBulletProjectile(This,  EDX, projectileParams, launchParams, This);
}

//CTaskMissile* (__fastcall* origFireBullet)(int angle, CTaskWorm* worm, Weapons::WeaponLaunchParams* params);
//CTaskMissile* __fastcall hookFireBullet( int angle, CTaskWorm* worm, Weapons::WeaponLaunchParams* params) {
	//printf("fire bullat %d %d %d \n",  angle,worm->wormnumber_dword100, params->unknown10);
//	return origFireBullet( angle,worm,params);
//}


CTaskMissile* callFireBulletProjectile(CGameTask* This, Weapons::WeaponProjectileParams* projectileParams, Weapons::WeaponLaunchParams* launchParams) {
	return hookFireBulletProjectile(This,0,  projectileParams, launchParams, This);
}


CTaskMissile* Weapons::callCreateWeaponProjectile(CGameTask * This, WeaponProjectileParams * projectileParams, WeaponLaunchParams * launchParams) {
	return hookCreateWeaponProjectile(This, 0, projectileParams, launchParams);
}


_HookDefLazy(FireBullet, void, __stdcall, (CTaskWorm* worm, Weapons::WeaponLaunchParams* params)) {
		//printf("%d %d %d \n", worm, params);
			return origFireBullet(worm,params);
}




int (__stdcall* origBullet2Object)(CGameTask* worm, int xpos, int ypos, int angleX, int angleY, int range, int collissionflags);
int __stdcall  hookBullet2Object(CGameTask* worm, int xpos, int ypos, int angleX
	, int angleY, int range, int collissionflags) {


	//Weapons::WeaponLaunchParams* ebparams;
	//_asm mov ebparams, ebp
	//int retv;
	//
	//__asm {
	//	push collissionflags
	//	push range
	//	push angleY
	//	push angleX
	//	push ypos
	//	push xpos
	//	push worm
	//
	//	call origBullet2Object
	//	mov retv, eax
	//}


	//return retv;

	return origBullet2Object(worm, xpos, ypos, angleX
		, angleY, range, collissionflags);
}



/*
_HookDefLazy(Bullet2Object, int, __stdcall, (CGameTask* worm, int xpos, int ypos, int angleX
	, int angleY,int range,int collissionflags)) {
	return origBullet2Object(worm, xpos, ypos, angleX, angleY, range, collissionflags);
}
*/
//returns the distance the bullet needs to stop at, which means that it hit something along the way, otherwise it returns -1. This doesnt account for terrain tho, thats handled separately.
DWORD addrBullet2Object;
int calltestcol() {
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	std::unordered_map<int, bool> has;
	CTask* ret = nullptr;
	turngame->traverse([&](CTask* obj, const int level) {
		for (int i = 0; i < level; i++)
		if ((obj->classtype == ClassType::ClassType_Task_Worm) && (has.find(obj->getAddr()) == has.end())) {
			has[obj->getAddr()] = true;
				ret = obj;
				break;
		}
		});
	CGameTask* worm = (CGameTask*)ret;

	using Fn = int(__stdcall*)(CGameTask*, int, int, int, int, int, int);
	Fn real = (Fn)addrBullet2Object;
	return real(worm,worm->posX , worm->posY, 100, 100, 1000, 2);
}

typedef int(__stdcall CGameTask::* OrigFn)(int, int, int, int, int, int);
int __stdcall calltestcol2(CGameTask* worm, int xpos, int ypos, int angleX
	, int angleY, int range, int collissionflags) {


	union Cast {
		void* raw;
		OrigFn method;
	} bridge;

	bridge.raw = origBullet2Object;

	// The compiler handles the calling convention perfectly under the hood
	return (worm->*(bridge.method))(xpos, ypos, angleX, angleY, range, collissionflags);
}

void dumpBytesToFile(const char* name, void* addr, int len = 64) {
	std::ofstream file("byte_dump.txt", std::ios::app);

	file << name << " (" << addr << ")\n";

	auto p = reinterpret_cast<unsigned char*>(addr);

	for (int i = 0; i < len; i++) {
		file << std::hex
			<< std::setw(2)
			<< std::setfill('0')
			<< (int)p[i]
			<< " ";
	}

	file << "\n\n";
}

int __stdcall calltestcol3() {

	dumpBytesToFile("real", (void*)addrBullet2Object);
	dumpBytesToFile("trampoline", (void*)origBullet2Object);
	return 1;
}


int __stdcall callBullet2Object(CGameTask* worm, int xpos, int ypos, int angleX
	, int angleY, int range, int collissionflags) {
	
	//int rets;
	//__asm {	
	//	mov edx, worm
	//	mov eax, xpos
	//	mov ecx, ypos
	//
	//	push collissionflags
	//	push range
	//	push angleY
	//	push angleX
	//	push ypos
	//	push xpos
	//	push worm
	//
	//	mov ebx, origBullet2Object
	//	call ebx
	//	mov rets, eax
	//}
	//
	//return rets;
	


	return origBullet2Object(worm, xpos, ypos, angleX, angleY, range, collissionflags);
}



DWORD(__stdcall* origAddAmmo)(DWORD team_info_obj, int weapon_id);
DWORD __stdcall CustomWeapons::hookAddAmmo(DWORD team_info_obj, int weapon_id) {
	int seax, sedx, retv;
	_asm mov seax, eax //team
	_asm mov sedx, edx //amount


	int ret = PackageManager::getInstance().handleAddAmmo(seax, weapon_id, sedx);
	if (ret) sedx = 0;

	if (weapon_id < maxStandardWeapons) {
		_asm mov eax, seax
		_asm mov edx, sedx
		_asm push weapon_id
		_asm push team_info_obj
		_asm call origAddAmmo
		_asm mov retv, eax
		return retv;
	}
	int alliance_id = *(DWORD*)(1308 * seax + team_info_obj + 4);
	auto& entry = ammoTable[alliance_id][weapon_id];
	if (entry >= 0) {
		if (sedx >= 0)
			entry += sedx;
		else
			entry = -1;
	}
	return (DWORD)&ammoTable[alliance_id][weapon_id];
}

void callFireBullet(CTaskWorm* worm, Weapons::WeaponLaunchParams* params) {
	//pepe->unknown0 = 1;
	//pepe->unknown4 = 1;
	//pepe->unknown8 = 89915392;
	//pepe->unknownC = 89915392;
	//pepe->unknown10 = -65536;
	//pepe->unknown14 = 0;
	//pepe->unknown18 = 62914560;
	//pepe->unknown1C = 22806528;
	//pepe->unknown20 = 0;
	//pepe->unknown24 = 30;
	//pepe->unknown24 = 3000;
	// 
	//_asm mov edi, params
	//printf("doodoo1");
	return origFireBullet(worm, params);
}

int Weapons::install(SignatureScanner &, module) {
	DWORD addrWeaponRelease = Hooks::scanPattern("WeaponRelease", "\x81\xEC\x00\x00\x00\x00\x53\x8B\x9C\x24\x00\x00\x00\x00\x55\x8B\xAC\x24\x00\x00\x00\x00\x56\x57\x6A\x2C\x8B\xF8\x33\xF6\x8D\x44\x24\x18\x56\x50\xE8\x00\x00\x00\x00\x8B\x8F\x00\x00\x00\x00\x83\xC4\x0C", "??????xxxx????xxxx????xxxxxxxxxxxxxxx????xx????xxx", 0x51C3D0);
	DWORD addrWormStartFiringWeapon = Hooks::scanPattern("WormStartFiringWeapon", "\x81\xEC\x00\x00\x00\x00\x53\x55\x56\x8B\xF0\x8B\x46\x44\x57\x8B\xBE\x00\x00\x00\x00\x33\xDB\x83\xE8\x6E", "??????xxxxxxxxxxx????xxxxx", 0x51B7F0);
	DWORD addrFireWeapon = Hooks::scanPattern("FireWeapon", "\x56\x8B\x74\x24\x08\xC7\x46\x00\x00\x00\x00\x00\x8B\x50\x30\x83\xC2\xFF\x83\xFA\x03\x57\x0F\x87\x00\x00\x00\x00\xFF\x24\x95\x00\x00\x00\x00\x8B\x50\x38\x83\xC2\xFF\x83\xFA\x03", "??????x?????xxxxxxxxxxxx????xxx????xxxxxxxxx", 0x51EE60);
	DWORD addrCreateWeaponProjectile = Hooks::scanPattern("CreateWeaponProjectile", "\x6A\xFF\x68\x00\x00\x00\x00\x64\xA1\x00\x00\x00\x00\x50\x64\x89\x25\x00\x00\x00\x00\x51\x56\x8B\xF1\x8B\x46\x2C\x8B\x88\x00\x00\x00\x00\x83\xC1\x07\x81\xF9\x00\x00\x00\x00\x57\x7E\x3C", "???????xx????xxxx????xxxxxxxxx????xxxxx????xxx", 0x51E0F0);
	DWORD addrFireBulletProjectile = Hooks::scanPattern("FireBulletProjectile", "\x83\xEC\x30\x53\x8B\x5C\x24\x00\x83\x7B\x00\x00", "xxxxxxx?xx??", 0);
	
	//DWORD addrFireBullet = Hooks::scanPattern("FireBullet", "\x81\xEC\x20\x04\x00\x00\x53", "xxxx??x", 0x51E0F0);
	//_ScanLazy(FireBullet, "83ec30538b5c24??837b??00"); //firegunbullet
	//_HookDefault(FireBullet);
	
	//_ScanLazy(Bullet2Object, "83ec148b5424??8b42");
	//_HookDefault(Bullet2Object);

	addrBullet2Object = Hooks::scanPattern("Bullet2Object", "\x83\xec\x14\x8b\x54\x24\x18\x8b\x42", "xxxxxxxxx", 0);
	dumpBytesToFile("pre-hook", (void*)addrBullet2Object);
	Hooks::polyhook("Bullet2Object", addrBullet2Object, (DWORD*)&hookBullet2Object, (DWORD*)&origBullet2Object);

	Hooks::polyhook("WeaponRelease", addrWeaponRelease, (DWORD *) &hookWeaponRelease, (DWORD *) &origWeaponRelease);
	Hooks::polyhook("WormStartFiring", addrWormStartFiringWeapon, (DWORD *) &hookWormStartFiringWeapon, (DWORD *) &origWormStartFiringWeapon);
	Hooks::polyhook("FireWeapon", addrFireWeapon, (DWORD *) &hookFireWeapon, (DWORD *) &origFireWeapon);
	Hooks::polyhook("CreateWeaponProjectile", addrCreateWeaponProjectile, (DWORD *) &hookCreateWeaponProjectile, (DWORD *) &origCreateWeaponProjectile);
	Hooks::polyhook("FireBulletProjectile", addrFireBulletProjectile, (DWORD *) &hookFireBulletProjectile, (DWORD *) &origFireBulletProjectile);
	


	DWORD addrAddAmmo = Hooks::scanPattern("AddAmmo", "\x8B\x4C\x24\x04\x69\xC0\x00\x00\x00\x00\x8B\x44\x08\x04\x69\xC0\x00\x00\x00\x00\x03\x44\x24\x08\x8D\x84\x81\x00\x00\x00\x00\x8B\x08\x85\xC9\x7C\x11\x85\xD2", "??????????xxxxxx????xxxxxxx????xxxxxxxx", 0x522640);
	Hooks::polyhook("addAmmo", addrAddAmmo, (DWORD*)&CustomWeapons::hookAddAmmo, (DWORD*)&origAddAmmo);


	auto * lua = Lua::getInstance().getState();
	lua->set_function("FireWeapon", &callFireWeapon);
	lua->set_function("FireBulletProjectile", &callFireBulletProjectile);
	//lua->set_function("FireBullet", &callFireBullet);
	lua->set_function("createWeaponProjectile", &callCreateWeaponProjectile);
	lua->set_function("getKeyState", &GetKeyState);

	lua->set_function("testcolthree", &calltestcol3);
	lua->set_function("testcoltwo", &calltestcol2);
	lua->set_function("testcol", &calltestcol);

	//Bullet2ObjectFn Bullet2Object =
    //(Bullet2ObjectFn)addrBullet2Object;


	using BulletFn = int(__stdcall*)(
		CGameTask*,
		int,
		int,
		int,
		int,
		int,
		int
		);

	lua->set_function("checkObjectCollision", static_cast<BulletFn>(&callBullet2Object));


	sol::usertype <WeaponLaunchParams> ut = lua->new_usertype <WeaponLaunchParams> ("WeaponLaunchParams");
	ut["unknown0"] = &WeaponLaunchParams::unknown0;
	ut["unknown4"] = &WeaponLaunchParams::unknown4;
	ut["posx"] = &WeaponLaunchParams::unknown8;
	ut["unknown8"] = &WeaponLaunchParams::unknown8;
	ut["posy"] = &WeaponLaunchParams::unknownC;
	ut["unknownC"] = &WeaponLaunchParams::unknownC;
	ut["unknown10"] = &WeaponLaunchParams::unknown10;
	ut["offsetx"] = &WeaponLaunchParams::unknown10;
	ut["unknown14"] = &WeaponLaunchParams::unknown14;
	ut["offsety"] = &WeaponLaunchParams::unknown14;
	ut["unknown18"] = &WeaponLaunchParams::unknown18;
	ut["unknown1C"] = &WeaponLaunchParams::unknown1C;
	ut["range"] = &WeaponLaunchParams::unknown1C;
	ut["unknown20"] = &WeaponLaunchParams::unknown20;
	ut["collisionflag"] = &WeaponLaunchParams::unknown20;
	ut["unknown24"] = &WeaponLaunchParams::unknown24;
	ut["offsetx2"] = &WeaponLaunchParams::unknown24;
	ut["unknown28"] = &WeaponLaunchParams::unknown28;
	ut["offsety2"] = &WeaponLaunchParams::unknown28;


	sol::usertype <WeaponProjectileParams> ut2 = lua->new_usertype <WeaponProjectileParams> ("WeaponProjectileParams");
	ut2["unknown0"] = &WeaponProjectileParams::unknown0;
	ut2["unknown4"] = &WeaponProjectileParams::unknown4;
	ut2["unknown8"] = &WeaponProjectileParams::unknown8;
	ut2["unknownC"] = &WeaponProjectileParams::unknownC;
	ut2["unknown10"] = &WeaponProjectileParams::unknown10;
	ut2["unknown14"] = &WeaponProjectileParams::unknown14;
	ut2["unknown18"] = &WeaponProjectileParams::unknown18;
	ut2["unknown1C"] = &WeaponProjectileParams::unknown1C;
	ut2["unknown20"] = &WeaponProjectileParams::unknown20;
	ut2["unknown24"] = &WeaponProjectileParams::unknown24;
	ut2["unknown28"] = &WeaponProjectileParams::unknown28;
	ut2["unknown2C"] = &WeaponProjectileParams::unknown2C;
	ut2["unknown30"] = &WeaponProjectileParams::unknown30;
	ut2["unknown34"] = &WeaponProjectileParams::unknown34;
	ut2["unknown38"] = &WeaponProjectileParams::unknown38;
	ut2["unknown3C"] = &WeaponProjectileParams::unknown3C;
	ut2["unknown40"] = &WeaponProjectileParams::unknown40;
	ut2["unknown44"] = &WeaponProjectileParams::unknown44;
	ut2["unknown48"] = &WeaponProjectileParams::unknown48;
	ut2["unknown4C"] = &WeaponProjectileParams::unknown4C;
	ut2["unknown50"] = &WeaponProjectileParams::unknown50;
	ut2["unknown54"] = &WeaponProjectileParams::unknown54;
	ut2["unknown58"] = &WeaponProjectileParams::unknown58;
	ut2["unknown5C"] = &WeaponProjectileParams::unknown5C;
	ut2["unknown60"] = &WeaponProjectileParams::unknown60;
	ut2["unknown64"] = &WeaponProjectileParams::unknown64;
	ut2["unknown68"] = &WeaponProjectileParams::unknown68;
	ut2["unknown6C"] = &WeaponProjectileParams::unknown6C;
	ut2["unknown70"] = &WeaponProjectileParams::unknown70;
	ut2["unknown74"] = &WeaponProjectileParams::unknown74;
	ut2["unknown78"] = &WeaponProjectileParams::unknown78;
	ut2["unknown7C"] = &WeaponProjectileParams::unknown7C;
	ut2["unknown80"] = &WeaponProjectileParams::unknown80;
	ut2["unknown84"] = &WeaponProjectileParams::unknown84;
	ut2["unknown88"] = &WeaponProjectileParams::unknown88;
	ut2["unknown8C"] = &WeaponProjectileParams::unknown8C;
	ut2["unknown90"] = &WeaponProjectileParams::unknown90;
	ut2["unknown94"] = &WeaponProjectileParams::unknown94;
	ut2["unknown98"] = &WeaponProjectileParams::unknown98;
	ut2["unknown9C"] = &WeaponProjectileParams::unknown9C;
	ut2["unknownA0"] = &WeaponProjectileParams::unknownA0;
	ut2["unknownA4"] = &WeaponProjectileParams::unknownA4;
	ut2["unknownA8"] = &WeaponProjectileParams::unknownA8;
	ut2["unknownAC"] = &WeaponProjectileParams::unknownAC;
	ut2["unknownB0"] = &WeaponProjectileParams::unknownB0;
	ut2["unknownB4"] = &WeaponProjectileParams::unknownB4;
	ut2["unknownB8"] = &WeaponProjectileParams::unknownB8;
	ut2["unknownBC"] = &WeaponProjectileParams::unknownBC;
	ut2["unknownC0"] = &WeaponProjectileParams::unknownC0;
	ut2["unknownC4"] = &WeaponProjectileParams::unknownC4;
	ut2["unknownC8"] = &WeaponProjectileParams::unknownC8;
	ut2["unknownCC"] = &WeaponProjectileParams::unknownCC;
	ut2["unknownD0"] = &WeaponProjectileParams::unknownD0;
	ut2["unknownD4"] = &WeaponProjectileParams::unknownD4;
	ut2["unknownD8"] = &WeaponProjectileParams::unknownD8;
	ut2["unknownDC"] = &WeaponProjectileParams::unknownDC;
	ut2["unknownE0"] = &WeaponProjectileParams::unknownE0;
	ut2["unknownE4"] = &WeaponProjectileParams::unknownE4;
	ut2["unknownE8"] = &WeaponProjectileParams::unknownE8;
	ut2["unknownEC"] = &WeaponProjectileParams::unknownEC;
	ut2["unknownF0"] = &WeaponProjectileParams::unknownF0;
	ut2["unknownF4"] = &WeaponProjectileParams::unknownF4;
	ut2["unknownF8"] = &WeaponProjectileParams::unknownF8;
	ut2["unknownFC"] = &WeaponProjectileParams::unknownFC;
	ut2["unknown100"] = &WeaponProjectileParams::unknown100;
	ut2["unknown104"] = &WeaponProjectileParams::unknown104;
	ut2["unknown108"] = &WeaponProjectileParams::unknown108;
	ut2["unknown10C"] = &WeaponProjectileParams::unknown10C;
	ut2["unknown110"] = &WeaponProjectileParams::unknown110;
	ut2["unknown114"] = &WeaponProjectileParams::unknown114;
	ut2["unknown118"] = &WeaponProjectileParams::unknown118;
	ut2["unknown11C"] = &WeaponProjectileParams::unknown11C;
	ut2["unknown120"] = &WeaponProjectileParams::unknown120;
	ut2["unknown124"] = &WeaponProjectileParams::unknown124;
	ut2["unknown128"] = &WeaponProjectileParams::unknown128;
	ut2["unknown12C"] = &WeaponProjectileParams::unknown12C;
	ut2["unknown130"] = &WeaponProjectileParams::unknown130;
	ut2["unknown134"] = &WeaponProjectileParams::unknown134;
	ut2["unknown138"] = &WeaponProjectileParams::unknown138;
	ut2["unknown13C"] = &WeaponProjectileParams::unknown13C;
	ut2["unknown140"] = &WeaponProjectileParams::unknown140;
	ut2["unknown144"] = &WeaponProjectileParams::unknown144;
	ut2["unknown148"] = &WeaponProjectileParams::unknown148;
	ut2["unknown14C"] = &WeaponProjectileParams::unknown14C;
	ut2["unknown150"] = &WeaponProjectileParams::unknown150;
	ut2["unknown154"] = &WeaponProjectileParams::unknown154;
	ut2["unknown158"] = &WeaponProjectileParams::unknown158;
	ut2["unknown15C"] = &WeaponProjectileParams::unknown15C;
	ut2["unknown160"] = &WeaponProjectileParams::unknown160;
	ut2["unknown164"] = &WeaponProjectileParams::unknown164;
	ut2["unknown168"] = &WeaponProjectileParams::unknown168;
	ut2["unknown16C"] = &WeaponProjectileParams::unknown16C;
	ut2["unknown170"] = &WeaponProjectileParams::unknown170;
	ut2["unknown174"] = &WeaponProjectileParams::unknown174;

	return 0;
}
