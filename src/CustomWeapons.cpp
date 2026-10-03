#include <MinHook.h>
#include "CustomWeapons.h"
#include "Game.h"
#include "Chat.h"
#include "Hooks.h"
#include "Lua.h"
#include "renderer/Bitmap.h"
#include <array>
#include "sol/sol.hpp"
#include <time.h>

// offsets refer to WA v.3.8.0



void CustomWeapons::setCustomWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype, int value) {
	if (tabletype == 0) {
		ammoTable[team_id-1][weapon_id] = value;
	}
	else {
		delayTable[team_id-1][weapon_id] = value;
	}
}

int CustomWeapons::getCustomWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype) {
	if (tabletype == 0) {
		return ammoTable[team_id-1][weapon_id];
	}
	else {
		return delayTable[team_id-1][weapon_id];
	}
}




void CustomWeapons::onConstructGlobalContext(int a1) {
	customWeaponsEnabled = weaponStructInjectionList.size() > 0;
	numAllWeapons = maxStandardWeapons + weaponStructInjectionList.size();

	DWORD origLoadImgFromVfs_sesi = *(DWORD*)(Game::getAddrDDGame() + 0x4C0);

	for(auto & inject : weaponImgInjectionList) {
		inject.second = (DWORD) Bitmap::callLoadImgFromFile(0,0, (char*)inject.first.c_str());
	}

//	DWORD addrGameGlobal = Game::getAddrGameGlobal();
//	*(Bitmap::BitmapImage**)(addrGameGlobal +0x538) = Bitmap::callLoadImgFromFile(0, 0, "jelly/fire-red.img");
//	*(Bitmap::BitmapImage**)(addrGameGlobal +0x53C) = Bitmap::callLoadImgFromFile(0, 0, "jelly/fire-blu.img");


	if(customWeaponsEnabled) {
		for(int team=0; team < numTeams; team++) {
			for(int weapon=0; weapon < numAllWeapons; weapon++) {
				ammoTable[team][weapon] = 0;
				delayTable[team][weapon] = 0;
			}
		}
		size_t i = 0;
		for(auto & it : weaponStructInjectionList) {
			auto wpnid = maxStandardWeapons + i;
			it.name1 = (char*)weaponNameStorage[i].first.c_str();
			it.name2 = (char*)weaponNameStorage[i].second.c_str();
			printf("CustomWeapons::onConstructGlobalContext: inject weapon: %s = %d\n", it.name1, i);
			memcpy((void*)&weaponTable[wpnid], (void*)&it, sizeof(WeaponStruct));
			i++;
		}
	}

}

DWORD originalWeaponTablePtr = 0;
int (__stdcall *origInitializeWeaponTable)(DWORD addrDDGame);
int __stdcall CustomWeapons::hookInitializeWeaponTable(DWORD addrDDGame) {
	printf("initialize weapon table\n");
	DWORD addrGameGlobal = *(DWORD*)(addrDDGame + 0x488);
	DWORD addrWeaponPanel = *(DWORD*)(addrGameGlobal + 0x548);

	originalWeaponTablePtr = *(DWORD*)(addrGameGlobal + 0x510);
 	*(DWORD*)(addrGameGlobal + 0x510) = (DWORD)&weaponTable;

	variablePanelColumns = standardNumColumns;
	variablePanelWidthAdd = 144;
	int ret = origInitializeWeaponTable(addrDDGame);
	return ret;
}

void CustomWeapons::onDestroyGlobalContext() {
	if(originalWeaponTablePtr) {
		DWORD addrGameGlobal = Game::getAddrGameGlobal();
		*(DWORD *) (addrGameGlobal + 0x510) = originalWeaponTablePtr;
		originalWeaponTablePtr = 0;
	}
}


DWORD addrPrepareWeaponPanelHookLoopEnd;
int __stdcall CustomWeapons::hookWeaponPanelLoop(int team, int counter, int row, int weapon_panel_obj) {
	int minWeaponId = 1;
	int maxWeaponId = numAllWeapons;
			//customWeaponsEnabled ? maxCustomWeapons : maxStandardWeapons;
	int weapon_added_count = 0;
	int counter_off = counter - 30;
	int addrGameGlobal = *(DWORD*)weapon_panel_obj;
	// calculate variable column count on first iteration, so it stays consistent throughout later iterations
	if(row == 0) {
		variablePanelColumns = standardNumColumns;
		variablePanelWidthAdd = 144;
		for(int lrow = 0; lrow < 13; lrow++) {
			int count_found = 0;
			for(int weapon_id = minWeaponId; weapon_id < maxWeaponId; weapon_id++) {
				WeaponStruct * wpn = &weaponTable[weapon_id];
				if(wpn->panelRow == lrow) {
					int ammo = *(int*) getAmmoAddr_v2(weapon_panel_obj, weapon_id, 0);
					int delay = *(int*) getAmmoAddr_v2(weapon_panel_obj, weapon_id, 1);
					int unk = *(DWORD *)(*(DWORD *)(addrGameGlobal + 36) + 55160) < 406;
					if((ammo && delay >= -1) || unk) {
						count_found += 1;
						variablePanelColumns = max(variablePanelColumns, count_found);
						variablePanelWidthAdd = 29 * variablePanelColumns;
					}
				}
			}
		}
	}
	for(int slot_id = counter_off; slot_id < counter_off + variablePanelColumns; slot_id++) {
		weaponPanelSlots[slot_id] = 0;
	}

	for(int weapon_id = minWeaponId; weapon_id < maxWeaponId; weapon_id++) {
		WeaponStruct * wpn = &weaponTable[weapon_id];
		if(wpn->panelRow == row) {
			int ammo = *(int*) getAmmoAddr_v2(weapon_panel_obj, weapon_id, 0);
			int delay = *(int*) getAmmoAddr_v2(weapon_panel_obj, weapon_id, 1);
			int unk = *(DWORD *)(*(DWORD *)(addrGameGlobal + 36) + 55160) < 406;
			if((ammo && delay >= -1) || unk) {
				weaponPanelSlots[weapon_added_count + counter_off] = weapon_id;
				weapon_added_count += 1;
			}
		}
	}
	return weapon_added_count;
}


DWORD* getAmmoTableAddr(int team_id, int weapon_id, int tabletype) { //tabletype 1=delay 0=ammo
	DWORD addrGameGlobal = Game::getAddrGameGlobal();
	DWORD weaponpanel = *(DWORD*)(addrGameGlobal + 1352);
	int offset = tabletype ? 26104 : 25820;
	return (DWORD*)((*(DWORD*)weaponpanel + 4 * (142 * team_id + weapon_id) + offset));
}

void CustomWeapons::setWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype, int value) {
	if (weapon_id > maxStandardWeapons) {return setCustomWeaponAmmoOrDelay(team_id, weapon_id, tabletype, value);}
	auto ammoptr = getAmmoTableAddr(team_id - 1, weapon_id, tabletype);
	*ammoptr = value;
}

int CustomWeapons::getWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype) {
	if (weapon_id > maxStandardWeapons) { return getCustomWeaponAmmoOrDelay(team_id, weapon_id, tabletype); }
	auto ammoptr = getAmmoTableAddr(team_id - 1, weapon_id, tabletype);
	return *ammoptr;
}

DWORD addrPrepareWeaponPanelHookLoopEndEarly;
void __declspec(naked) hookWeaponPanelLoop_wrapper() {
	//EBP is 0x0 right now
	_asm cmp [CustomWeapons::customWeaponsEnabled], 0
	_asm jnz callhook
	_asm xor edx,edx
	_asm LEA EAX,[EDX+1]
	_asm MOV EBX,0x1D0
	_asm CMP EDX,0x5
	_asm jmp addrPrepareWeaponPanelHookLoopEndEarly
//	00567EBD  |.  0F8D B9010000 JGE 0056807C

	_asm callhook:
	_asm push esi
	_asm mov eax, [esp+0x50 - 0x30] // row
	_asm push eax
	_asm mov eax, [esp+0x54 - 0x2c] // counter
	_asm push eax
	_asm mov eax, [esp+0x58 - 0x1c] // team
	_asm push eax
	_asm call CustomWeapons::hookWeaponPanelLoop
	_asm mov edx, eax // weapon added count
	_asm jmp addrPrepareWeaponPanelHookLoopEnd
}


int __stdcall CustomWeapons::hookWeaponPanelDrawTile_GetSlotAddr(int weapon_panel_obj, int column, int row) {
	if(customWeaponsEnabled)
		return (int)&weaponPanelSlots[row * variablePanelColumns + column];
	else {
		int offset = row + 6 + column + 4 * (row + 6);
		return weapon_panel_obj + 4 * offset;
	}
}

DWORD addrWeaponPanelDrawTile_GetSlot_patch1_ret;
void __declspec(naked) hookWeaponPanelDrawTile_GetSlot_patch1() {
	//00567826
//	_asm LEA EAX,[EBP+0x6]
//	_asm LEA EDX,[EAX*4+ECX]
//	_asm ADD EDX,EAX
//	_asm CMP DWORD PTR DS:[EDX*4+EDI],0
//	_asm LEA EAX,[EDX*4+EDI]

	_asm mov eax, [esp + 0x28 + 0x8] // row
	_asm push eax
	_asm mov eax, [esp + 0x2C + 0x4] // column
	_asm push eax
	_asm push edi // weapon panel
	_asm call CustomWeapons::hookWeaponPanelDrawTile_GetSlotAddr
	_asm cmp  dword ptr [eax], 0

	_asm jmp addrWeaponPanelDrawTile_GetSlot_patch1_ret
}


DWORD addrWeaponPanelDrawTile_GetSlot_patch3_ret;
void __declspec(naked) hookWeaponPanelDrawTile_GetSlot_patch3() {
	//0056774A
//	_asm LEA ECX,[EAX*4+ECX]
//	_asm ADD ECX,EAX
//	_asm MOV ESI,DWORD PTR DS:[ECX*4+EDI]
//	_asm TEST ESI,ESI

	_asm mov eax, [esp + 0x28 + 0x8] // row
	_asm push eax
	_asm mov eax, [esp + 0x2C + 0x4] // column
	_asm push eax
	_asm push edi // weapon panel
	_asm call CustomWeapons::hookWeaponPanelDrawTile_GetSlotAddr
	_asm mov esi,[eax]
	_asm test esi, esi

	_asm jmp addrWeaponPanelDrawTile_GetSlot_patch3_ret
}

DWORD addrWeaponPanelDescription_GetSlot_patch1_ret;
void __declspec(naked) hookWeaponPanelDescription_GetSlot_patch1() {
	//00567C11
//	_asm ADD EAX,6
//	_asm LEA ECX,[EAX*4+ECX]
//	_asm ADD ECX,EAX
//	_asm MOV EAX,DWORD PTR DS:[ECX*4+ESI]
//	_asm TEST EAX,EAX

	_asm mov eax, [esp + 0x1C + 0x8] // row
	_asm push eax
	_asm mov eax, [esp + 0x20 + 0x4] // column
	_asm push eax
	_asm push esi // weapon panel
	_asm call CustomWeapons::hookWeaponPanelDrawTile_GetSlotAddr
	_asm mov eax, [eax]
	_asm test eax, eax

	_asm jmp addrWeaponPanelDescription_GetSlot_patch1_ret
}


void __stdcall CustomWeapons::hookWeaponPanelCheckClick_patch1_c(int v5, int a1, int weapon_panel_obj, int a3, int column, int row) {
	int addr = hookWeaponPanelDrawTile_GetSlotAddr(weapon_panel_obj, column, row);
	*(DWORD*)a1 = column;
	*(DWORD*)a3 = *(DWORD*)addr;
	*(DWORD*)v5 = *(DWORD *)(weapon_panel_obj + 4 * row + 380);
}

DWORD addrWeaponPanelCheckClick_patch1_ret;
void __declspec(naked) hookWeaponPanelCheckClick_patch1() {
	//00568C98
//	_asm MOV EDX,DWORD PTR SS:[ESP+4]
//	_asm LEA EAX,[ECX+6]
//	_asm PUSH EBP
//	_asm LEA EBP,[EAX*4+EDX]
//	_asm ADD EBP,EAX
//	_asm MOV EAX,DWORD PTR DS:[EBP*4+ESI]
//	_asm MOV EBP,DWORD PTR SS:[ESP+0x10]
//	_asm MOV DWORD PTR SS:[EBP],EAX
//	_asm MOV ECX,DWORD PTR DS:[ECX*4+ESI+0x17C]
//	_asm MOV DWORD PTR DS:[EBX],ECX

	_asm mov eax, [esp + 0x8 + 0x8] // row
	_asm push eax
	_asm mov eax, [esp + 0xC - 0x4] // column
	_asm push eax
	_asm mov eax, [esp + 0x10 + 0x4] // y
	_asm push eax
	_asm push esi // weapon panel
	_asm push edi // a1
	_asm push ebx
	_asm call CustomWeapons::hookWeaponPanelCheckClick_patch1_c

	_asm jmp addrWeaponPanelCheckClick_patch1_ret
}

//void * (__cdecl *waNew)(size_t Size) = 0;
//FILE * (__cdecl *waFopen)(const char *Filename, const char *Mode) = 0;
//	waNew = (void *(__cdecl *)(size_t)) 0x005C034C;
//	waFopen = (FILE *(__cdecl *)(const char *, const char *)) 0x005D3082;

//bool grabLoadImgFromVfsParams = false;
//int (__stdcall *origVfsCreateGfxDirReader)(char *x) = 0;
//int __stdcall hookVfsCreateGfxDirReader(char *x) {
//	int sesi, retv;
//	_asm mov sesi, esi
//
//	if(!strcmp(x, "hi\\gravity.img")) {
//		grabLoadImgFromVfsParams = true;
//	}
//
//	_asm mov esi, sesi
//	_asm push x
//	_asm call origVfsCreateGfxDirReader
//	_asm mov retv, eax
//
//	return retv;
//}


DWORD getStandardImgPtr(int weapon_panel_obj, int weapon_id, int a4) {
	return *(DWORD*)(*(DWORD *)weapon_panel_obj + 4 * (a4 + 2 * weapon_id) + 324);
}

DWORD __stdcall CustomWeapons::getImgPtr(int weapon_panel_obj, int weapon_id, int a4) {
	if(weapon_id == 69 || weapon_id == 70) {
		return getStandardImgPtr(weapon_panel_obj, 1, a4);
	}
	if(weapon_id < maxStandardWeapons) {
		return getStandardImgPtr(weapon_panel_obj, weapon_id, a4);
	}
	int custom_weapon_id = weapon_id - maxStandardWeapons;
	if(custom_weapon_id >= weaponImgInjectionList.size()
	|| custom_weapon_id < 0
	|| weaponImgInjectionList[custom_weapon_id].second == 0) {
		return getStandardImgPtr(weapon_panel_obj, 1, a4);
	}
	return weaponImgInjectionList[custom_weapon_id].second;
}

DWORD addrWeaponPanelDrawTile_GetImgPtr_patch1_ret;
void __declspec(naked) CustomWeapons::hookWeaponPanelDrawTile_GetImgPtr_patch1() {
	//00567A00
//	_asm mov     edx, [esp + 0x28 - 0x4]
//	_asm mov     ebx, [edx]
//	_asm mov     eax, [esp + 0x28 + 0x8]
//	_asm mov     esi, [edi]
//	_asm lea     ecx, [eax+ebx*2]
//	_asm xor     ebp, ebp
//	_asm cmp     [esi+ecx*4+0x144], ebp

	_asm mov     edx, [esp + 0x28 - 0x4] //weapon_id_ptr
	_asm mov     ebx, [edx] // ebx = weapon id,
	_asm mov     eax, [esp + 0x28 + 0x8] // a4

	_asm push ebx // save
	_asm push edi

	_asm push eax
	_asm push ebx
	_asm push edi
	_asm call getImgPtr
	_asm xor ebp, ebp
	_asm cmp [eax], ebp

	_asm pop edi
	_asm mov esi, [edi]
	_asm pop ebx

	_asm jmp addrWeaponPanelDrawTile_GetImgPtr_patch1_ret
}

DWORD addrWeaponPanelDrawTile_GetImgPtr_patch2_ret;
void __declspec(naked) CustomWeapons::hookWeaponPanelDrawTile_GetImgPtr_patch2() {
	//00567A38
	_asm push edx
	_asm push ebx
	_asm push edi
	_asm call getImgPtr
	_asm mov ecx, eax

	_asm MOV EDX,DWORD PTR SS:[ESP+0x20]
	_asm MOV EAX,DWORD PTR SS:[ESP+0x24]
	_asm MOV ESI,DWORD PTR DS:[ESI+0x138]
	_asm jmp addrWeaponPanelDrawTile_GetImgPtr_patch2_ret
}

DWORD addrWormSwitchingWeapon_GetImgPtr_patch1_ret;
void __declspec(naked) CustomWeapons::hookWormSwitchingWeapon_GetImgPtr_patch1() {
	//00515844
//	_asm mov     edx, [ebp+0x2C]
//	_asm mov     ecx, [edx+ecx*0x8+0x144]
//	_asm shl     eax, 0x10
//	_asm cmp     [ebp+0x374], ecx

	_asm push eax

	_asm lea edx, [ebp+0x2C]
	_asm push 0
	_asm push ecx
	_asm push edx
	_asm call getImgPtr
	_asm mov ecx, eax

	_asm mov edx, [ebp+0x2C]
	_asm pop eax
	_asm shl     eax, 0x10
	_asm cmp     [ebp+0x374], ecx

	_asm jmp addrWormSwitchingWeapon_GetImgPtr_patch1_ret
}



DWORD addrWeaponPanel_incrementCounter_patch1_ret;
void __declspec(naked) CustomWeapons::hookWeaponPanel_incrementCounter_patch1() {
	// 005680A2
	_asm push eax
	_asm mov eax, variablePanelColumns
	_asm add     [esp + 0x50 - 0x2C], eax
	_asm pop eax
	_asm mov     [esp + 0x4C - 0x34], ebp
	_asm mov     [esp + 0x4C - 0x20], eax
	_asm jmp addrWeaponPanel_incrementCounter_patch1_ret
}

DWORD addrWeaponPanel_incrementCounter_patch2_ret;
void __declspec(naked) CustomWeapons::hookWeaponPanel_incrementCounter_patch2() {
	//005680D5

	_asm add eax, [variablePanelWidthAdd]
	_asm push eax

	_asm 	cmp     byte ptr [esi + 0x1C4], 0
//	_asm   mov     dword ptr [esi +0x1B0], 5
	_asm mov eax, variablePanelColumns
	_asm   mov     dword ptr [esi +0x1B0], eax
	_asm pop eax
	_asm   lea     edx, [ecx+ebp+0x6]
	_asm jmp addrWeaponPanel_incrementCounter_patch2_ret
}

#pragma optimize( "", off )
int (__stdcall *origGetAmmo)();
int __stdcall CustomWeapons::hookGetAmmo() {
	int team_a1, weapon_a2, team_info_obj, retv;
	_asm mov team_a1, eax
	_asm mov weapon_a2, edx
	_asm mov team_info_obj, esi

	if(weapon_a2 < maxStandardWeapons) {
		_asm mov eax, team_a1
		_asm mov edx, weapon_a2
		_asm mov esi, team_info_obj
		_asm call origGetAmmo
		_asm mov retv, eax
		return retv;
	} else {
		if(team_a1 < 0 || team_a1 > numTeams || weapon_a2 < 0 || weapon_a2 > maxCustomWeapons) return 0;
		int alliance_id = *(DWORD *)(1308 * team_a1 + team_info_obj + 4);
		//hex-rays intensifies
		if(delayTable[alliance_id][weapon_a2] != 0
			|| (*(DWORD *)(team_info_obj + 11276) && *(DWORD *)(team_info_obj + 11304) < 484 && *(DWORD *)(team_info_obj + 11304) < -2)
//			|| (LOBYTE(v5) = sub_522480(alliance_id, team_info_obj), v5))
			)
			return 0;
		else
			return ammoTable[alliance_id][weapon_a2];
	}
}


//_DWORD *__userpurge subtract_ammo_sub_522560@<eax>(int a1@<eax>, int x@<ecx>, int y)
DWORD *(__stdcall * origSubtractAmmo)(int weapon_id);
DWORD *__stdcall CustomWeapons::hookSubtractAmmo(int weapon_id) {
	int seax, secx, retv;
	_asm mov seax, eax //team_id
	_asm mov secx, ecx //teaminfo obj
	if(weapon_id < maxStandardWeapons) {
		_asm mov eax, seax
		_asm mov ecx, secx
		_asm push weapon_id
		_asm call origSubtractAmmo
		_asm mov retv, eax
		return (DWORD*)retv;
	}
	int alliance_id = *(DWORD *)(1308 * seax + secx + 4);
	auto & entry = ammoTable[alliance_id][weapon_id];
	if(entry > 0)
		entry--;
	return (DWORD*)&ammoTable[alliance_id][weapon_id];
}
#pragma optimize( "", on )


//_DWORD *__fastcall subtract_ammo_missile_sub_5589A0(int a1, CTeam *x)
DWORD *(__fastcall *origSubtractAmmo_v2)(int a1, CTaskTeam *a2);
DWORD *__fastcall CustomWeapons::hookSubtractAmmo_v2(int a1, CTaskTeam *a2) {
	if(a2->lastLaunchedWeapon_dword60 < maxStandardWeapons) {
		return origSubtractAmmo_v2(a1, a2);
	} else {
		int alliance_id = *(int*)(1308 * a2->team_number_dword38 + a2->unknown2C + 17964);
		int weapon = a2->lastLaunchedWeapon_dword60;
		auto & entry = ammoTable[alliance_id][weapon];
		if(entry > 0)
			entry--;
		a2->unknown4C = 0;
		a2->lastLaunchedWeapon_dword60 = 0;
		DWORD v2 = a2->unknown2C;
		DWORD v3 = *(DWORD *)(v2 + 1352); //weapon panel
		if (v3)
			*(DWORD *)(v3 + 460) = 1; // redraw weapon panel
		return (DWORD*)&ammoTable[alliance_id][weapon];
	}
}

//weapon panel variant
DWORD __stdcall CustomWeapons::getAmmoAddr_v2(int weapon_panel_obj, int weapon_id, int tabletype) {
	int team_id = *(DWORD *)(weapon_panel_obj + 4 * *(DWORD *)(weapon_panel_obj + 4) + 32);
	if(weapon_id < maxStandardWeapons) {
		int offset = tabletype ? 26104 : 25820;
		return (*(DWORD *)weapon_panel_obj + 4 * (142 * team_id + weapon_id) + offset);
	}
	if(!tabletype)
		return (DWORD)&ammoTable[team_id][weapon_id];
	else
		return (DWORD)&delayTable[team_id][weapon_id];
}

// shadows delayed weapon tiles
DWORD addrWeaponPanelUnknown1_patch1_ret;
void __declspec(naked) CustomWeapons::hookWeaponPanelUnknown1_patch1() {
	//00567550
	_asm push ebx
	_asm mov ebx, [esp+0x8]
	_asm cmp ebx, maxStandardWeapons
	_asm pop ebx
	_asm jge hookWeaponPanelUnknown1_patch1_hook
	// use normal logic for < maxStandardWeapons
	_asm MOV ECX,DWORD PTR DS:[EAX+0x4]
	_asm MOV EDX,DWORD PTR DS:[ECX*4+EAX+0x20]
	_asm IMUL EDX,EDX,0x8E
	_asm PUSH EBX
	_asm MOV EBX,DWORD PTR SS:[ESP+0x8]
	_asm push    esi
	_asm mov     esi, [eax]
	_asm add     edx, ebx
	_asm cmp     dword ptr [esi+edx*4 + 0x65F8], 0

	_asm jmp addrWeaponPanelUnknown1_patch1_ret

_asm hookWeaponPanelUnknown1_patch1_hook:
	_asm push ebx
	_asm mov ebx, [esp + 0x8] //weapon id
	_asm push    esi
	_asm mov     esi, [eax] // *weapon_panel_obj

	_asm push eax //save eax
	_asm push 1
	_asm push ebx //weapon id
	_asm push eax //weapon panel obj
	_asm call getAmmoAddr_v2
	_asm cmp [eax], 0
	_asm pop eax
	_asm jmp addrWeaponPanelUnknown1_patch1_ret
}


DWORD addrWeaponPanelDescription_getAmmoDelay_patch1_ret;
void __declspec(naked) CustomWeapons::hookWeaponPanelDescription_getAmmoDelay_patch1() {
	//00567C24
//	_asm mov     edx, [esi+0x4]
//	_asm mov     ecx, [esi + edx*0x4 + 0x20]
//	_asm mov     edx, [esi]
//	_asm imul    ecx, 0x8E
//	_asm add     ecx, eax
//	_asm mov     edi, [edx + ecx*0x4 + 0x64DC]
//	_asm mov     ecx, [edx + ecx*0x4 + 0x65F8]
//	_asm test    ecx, ecx
//
	// eax = weapon number
	_asm mov     edx, [esi+0x4]
	_asm mov     ecx, [esi + edx*0x4 + 0x20]
	_asm mov     edx, [esi]

	_asm cmp eax, maxStandardWeapons
	_asm jge hookWeaponPanelDescription_getAmmoDelay_hook

	_asm imul    ecx, 0x8E
	_asm add     ecx, eax
	_asm mov     edi, [edx + ecx*0x4 + 0x64DC]
	_asm mov     ecx, [edx + ecx*0x4 + 0x65F8]
	_asm test ecx, ecx
	_asm jmp addrWeaponPanelDescription_getAmmoDelay_patch1_ret
_asm hookWeaponPanelDescription_getAmmoDelay_hook:
	_asm push edx // save edx
	_asm push eax // save eax
	_asm push eax // save eax

	//get ammo
	_asm push 0
	_asm push eax
	_asm push esi
	_asm call getAmmoAddr_v2
	_asm mov edi, [eax]
	_asm pop eax
	//get delay
	_asm push 1
	_asm push eax
	_asm push esi
	_asm call getAmmoAddr_v2
	_asm mov ecx, [eax]
	//restore eax,edx
	_asm pop eax
	_asm pop edx

	_asm test    ecx, ecx
	//ammo = edi
	//delay = ecx
	_asm jmp addrWeaponPanelDescription_getAmmoDelay_patch1_ret
}


int (__stdcall *origReduceDelayOnTurnStart)();
int __stdcall CustomWeapons::hookReduceDelayOnTurnStart() {
	DWORD sesi, retv;
	_asm mov sesi, esi

	_asm mov esi, sesi
	_asm call origReduceDelayOnTurnStart
	_asm mov retv,eax

	if(customWeaponsEnabled) {
		CTaskTeam * team = (CTaskTeam*) sesi;
		DWORD addrGameGlobal = team->unknown2C;
		DWORD v2 = 0;
		DWORD found = 0;
		if(*(DWORD *)(*(DWORD *)(addrGameGlobal + 36) + 55160) < 301 )
			v2 = team->unknown5C;
		else
			v2 = *(DWORD *)(addrGameGlobal + 4 * *(DWORD *)(1308 * team->team_number_dword38 + addrGameGlobal + 17964) + 29240);
		if(v2 > 1) {
			int alliance = *(DWORD *)(1308 * team->team_number_dword38 + addrGameGlobal + 17964);
			for(int weapon=maxStandardWeapons; weapon < maxCustomWeapons; weapon++) {
				auto & delay = delayTable[alliance][weapon];
				if(delay > 0) {
					delay--;
					found = 1;
					if(delay == 0) {
						if (*(DWORD *)(*(DWORD *)(addrGameGlobal + 36) + 55160) < 413 || ammoTable[alliance][weapon]) {
							DWORD weapon_panel = *(DWORD *)(addrGameGlobal + 1352);
							if (weapon_panel)
								*(DWORD *)(weapon_panel + 460) = 1; // redraw
						}
					}
				}
			}
		}
		retv |= found;
	}
	return retv;
}

void CustomWeapons::printDebugAddrs() {
	char buff[1024];
	DWORD addrGameGlobal = Game::getAddrGameGlobal();
	DWORD addrWeaponPanel = *(DWORD*)(addrGameGlobal + 0x548);
	DWORD addrWeaponTable = *(DWORD*)(addrGameGlobal + 0x510);
	sprintf_s(buff, "weaponPanel: %X weaponTable(current): %X weaponTable(original): %X", addrWeaponPanel, addrWeaponTable, originalWeaponTablePtr);
	Chat::callShowChatMessage(buff, 6);
}

CustomWeapons::WeaponStruct* CustomWeapons::getWeaponData(int weaponid) {
	return &CustomWeapons::weaponTable[weaponid];
}
int CustomWeapons::registerCustomWeapon(CustomWeapons::WeaponStruct weaponStruct, std::string img, std::string name1, std::string name2) {
	if (weaponStructInjectionList.size() == 0) {
		weaponImgInjectionList.emplace_back(img, 0);
		weaponNameStorage.emplace_back("INVALID WEAPON", "INVALID WEAPON");
		weaponStructInjectionList.push_back(weaponStruct);
	}//dummy weapon to fill in the fucked up vanilla ghost weapon
	weaponImgInjectionList.emplace_back(img, 0);
	weaponNameStorage.emplace_back(name1, name2);
	weaponStructInjectionList.push_back(weaponStruct);
	int id = maxStandardWeapons + weaponStructInjectionList.size() -1;
	printf("registerCustomWeapon: registered weapon %s:%s id: %d\n", name1.c_str(), name2.c_str(), id);
	return id;
}

void CustomWeapons::resetConfig() {
//	for(int i=maxStandardWeapons; i < weaponStructInjectionList.size(); i++)
//		memset(&weaponTable[i], 0, sizeof(WeaponStruct));
	weaponNameStorage.clear();
	weaponImgInjectionList.clear();
	weaponStructInjectionList.clear();
	customWeaponsEnabled = 0;
	numAllWeapons = maxStandardWeapons;
}


void triggerSkipGo() {
	int param[4] = { 0 };
	param[0] = 1;
	CTaskTurnGame* turngame = (CTaskTurnGame*)Game::getAddrTurnGameObject();
	if (!turngame) return;
	turngame->vtable8_HandleMessage(turngame, Constants::TaskMessage::TaskMessage_SkipGo, sizeof(param), &param);
}

void triggerNuclearTest() {
	int param[4] = { 0 };
	param[0] = 7;
	param[1] = 10;

	CTaskTurnGame* turngame = (CTaskTurnGame*)Game::getAddrTurnGameObject();
	if (!turngame) return;
	turngame->vtable8_HandleMessage(turngame, Constants::TaskMessage::TaskMessage_NukeBlast, sizeof(param), &param);
	param[0] = 110; //water rise
	param[1] = 7;
	turngame->vtable8_HandleMessage(turngame, Constants::TaskMessage::TaskMessage_RaiseWater, sizeof(param), &param);
	param[0] = 5; //poison amount
	param[1] = 0;
	turngame->vtable8_HandleMessage(turngame, Constants::TaskMessage::TaskMessage_PoisonWorm, sizeof(param), &param);
}



int gettime()
{
	return time(NULL);
}

int getNumWeapons() {
	return CustomWeapons::numAllWeapons;
}

int issecretoverride[900] = {0};

void setIsSuper(int weaptype, bool value) {
	issecretoverride[weaptype] = value;
}

void setupIsSecretOverride() {
	issecretoverride[10] = 1;
	issecretoverride[0x13] = 1;
	issecretoverride[0x1d] = 1;
	issecretoverride[0x1e] = 1;
	issecretoverride[0x1f] = 1;
	issecretoverride[0x24] = 1;
	issecretoverride[0x29] = 1;
	issecretoverride[0x2a] = 1;
	issecretoverride[0x2d] = 1;
	issecretoverride[0x2e] = 1;
	issecretoverride[0x31] = 1;
	issecretoverride[0x32] = 1;
	issecretoverride[0x33] = 1;
	issecretoverride[0x36] = 1;
	issecretoverride[0x37] = 1;
	issecretoverride[0x38] = 1;
	issecretoverride[0x3c] = 1;
	issecretoverride[0x3d] = 1;
}

_HookDefLazy(IsSecretWeap, bool, __stdcall, (int param_1)) { //tired of getting this shit to hook, so its copypaste from decomp time!!
	int weaptype = 0;
	__asm mov weaptype, eax
	if (issecretoverride[weaptype]) {
		return issecretoverride[weaptype];
	}
	switch (weaptype) {
	default:
		return 0;
	case 0x3b:
		return param_1;
	}
}

bool callIsSecret(int weapid) {
	__asm push eax
	__asm mov eax, weapid
	bool ret = hookIsSecretWeap(weapid);
	__asm pop eax
	return ret;
}

int isutilityoverride[900] = {0};

void setIsUtility(int weaptype, bool value) {
	isutilityoverride[weaptype] = value;
}

void setupIsUtilityOverride() {
	isutilityoverride[62] = 1;
	isutilityoverride[63] = 1;
	isutilityoverride[64] = 1;
	isutilityoverride[65] = 1;
	isutilityoverride[66] = 1;
	isutilityoverride[67] = 1;
	isutilityoverride[68] = 1;
	isutilityoverride[69] = 1;
	isutilityoverride[70] = 1;
}

_HookDefLazy(IsUtility, bool, __stdcall, ()) { //tired of getting this shit to hook, so its copypaste from decomp time!!
	int weaptype = 0;
	__asm mov weaptype, eax
	//if (isutilityoverride[weaptype]) {
		__asm mov eax, isutilityoverride[weaptype]
		return isutilityoverride[weaptype] == 1;
	//}
}

bool callIsUtility(int weapid) {
	__asm push eax
	__asm mov eax, weapid
	bool ret = hookIsUtility();
	__asm pop eax
	return ret;
}

int issheepoverride[900] = {0};

void setIsSheep(int weaptype, bool value) {
	issheepoverride[weaptype] = value;
}

void setupIsSheepOverride() {
	issheepoverride[0x17] = 1;
	issheepoverride[0x18] = 1;
	issheepoverride[0x19] = 1;
	issheepoverride[0x32] = 1;
	issheepoverride[5] = 1;
}

_HookDefLazy(IsSheep, bool, __stdcall, (int param_1)) { //tired of getting this shit to hook, so its copypaste from decomp time!!
	int weaptype = 0;
	__asm mov weaptype, eax
	//if (issheepoverride[weaptype]) {
	if ((weaptype == 5) && (issheepoverride[weaptype])) {
		return 0x1e9 < param_1;
	}
		__asm mov eax, issheepoverride[weaptype]
		return issheepoverride[weaptype] == 1;
	//}
}

bool callIsSheep(int weapid) {
	__asm push eax
	__asm mov eax, weapid
	bool ret = hookIsSheep(0);
	__asm pop eax
	return ret;
}





int CustomWeapons::install(SignatureScanner & signatureScanner, module mod) {
	DWORD addrInitializeWeaponTable = Hooks::scanPattern("InitializeWeaponTable", "\x53\x55\x8B\x6C\x24\x0C\x8B\x85\x00\x00\x00\x00\x8B\x88\x00\x00\x00\x00\x56\x57\x68\x00\x00\x00\x00\x33\xDB\x53\x51\xE8\x00\x00\x00\x00\x83\xC4\x0C", "??????xx????xx????xxx????xxxxx????xxx", 0x53CAB0);
	DWORD addrPrepareWeaponPanel = Hooks::scanPattern("PrepareWeaponPanel", "\x83\xEC\x3C\x53\x55\x56\x57\x8B\xF0\x8D\x44\x24\x38\x50\x8D\x4C\x24\x38\x51\x8D\x7C\x24\x50\xE8\x00\x00\x00\x00\xE8\x00\x00\x00\x00", "??????xxxxxxxxxxxxxxxxxx????x????", 0x568220);

	DWORD addrPrepareWeaponPanelHookLoop = addrPrepareWeaponPanel + 0x100;
	addrPrepareWeaponPanelHookLoopEndEarly = addrPrepareWeaponPanel + 0x10D;
	addrPrepareWeaponPanelHookLoopEnd = addrPrepareWeaponPanel + 0x2CC;

	DWORD addrWeaponPanelDrawTile = Hooks::scanPattern("WeaponPanelDrawTile", "\x8B\x44\x24\x08\x83\xEC\x1C\x80\xBF\x00\x00\x00\x00\x00\x53\x55\x56\x0F\x84\x00\x00\x00\x00\x83\xF8\x10\x0F\x85\x00\x00\x00\x00\x8B\x44\x24\x2C\x83\xF8\x05\x0F\x87\x00\x00\x00\x00", "??????xxx?????xxxxx????xxxxx????xxxxxxxxx????", 0x567AA0);
	DWORD addrWeaponPanelDrawTile_GetSlot_patch1 = addrWeaponPanelDrawTile + 0x1F6; //00567826
	addrWeaponPanelDrawTile_GetSlot_patch1_ret = addrWeaponPanelDrawTile + 0x202; //00567832

	DWORD addrWeaponPanelDrawTile_GetSlot_patch3 = addrWeaponPanelDrawTile + 0x11A; // 0056774A
	addrWeaponPanelDrawTile_GetSlot_patch3_ret = addrWeaponPanelDrawTile + 0x124; // 00567754

	DWORD addrWeaponPanelDescription= Hooks::scanPattern("WeaponPanelDescription", "\x8B\x46\x74\x83\xEC\x10\x53\x8B\x5E\x50\x2B\xD8\x55\x83\xEB\x03\x80\xBE\x00\x00\x00\x00\x00\x57", "??????xxxxxxxxxxxx?????x", 0x567F80);
	DWORD addrWeaponPanelDescription_GetSlot_patch1 = addrWeaponPanelDescription + 0x101; // 00567C11
	addrWeaponPanelDescription_GetSlot_patch1_ret = addrWeaponPanelDescription + 0x10E; // 00567C1E

	DWORD addrWeaponPanelCheckClick= Hooks::scanPattern("WeaponPanelCheckClick", "\x51\x8B\x44\x24\x08\x53\x8B\x5C\x24\x10\xC7\x00\x00\x00\x00\x00\x83\xBE\x00\x00\x00\x00\x00\xC7\x03\x00\x00\x00\x00", "??????xxxxxx????xx?????xx????", 0x5690B0);
	DWORD addrWeaponPanelCheckClick_patch1 = addrWeaponPanelCheckClick + 0x58; // 00568C98
	addrWeaponPanelCheckClick_patch1_ret = addrWeaponPanelCheckClick + 0x7B; // 00568CBB

	DWORD addrWeaponPanelUnknown1= Hooks::scanPattern("WeaponPanelUnknown1", "\x8B\x48\x04\x8B\x54\x88\x20\x69\xD2\x00\x00\x00\x00\x53\x8B\x5C\x24\x08\x56\x8B\x30\x03\xD3\x83\xBC\x96\x00\x00\x00\x00\x00\x74\x0A", "??????xxx????xxxxxxxxxxxxx?????xx", 0x5679C0);
	addrWeaponPanelUnknown1_patch1_ret = addrWeaponPanelUnknown1 + 0x1F; 	//0056756F

	Hooks::hookAsm(addrPrepareWeaponPanelHookLoop, (DWORD)&hookWeaponPanelLoop_wrapper);
	Hooks::hookAsm(addrWeaponPanelDrawTile_GetSlot_patch1, (DWORD)&hookWeaponPanelDrawTile_GetSlot_patch1);
	Hooks::hookAsm(addrWeaponPanelDrawTile_GetSlot_patch3, (DWORD)&hookWeaponPanelDrawTile_GetSlot_patch3);
	Hooks::hookAsm(addrWeaponPanelDescription_GetSlot_patch1, (DWORD)&hookWeaponPanelDescription_GetSlot_patch1);
	Hooks::hookAsm(addrWeaponPanelCheckClick_patch1, (DWORD)&hookWeaponPanelCheckClick_patch1);
	Hooks::hookAsm(addrWeaponPanelUnknown1, (DWORD)&hookWeaponPanelUnknown1_patch1);

	//// weapon imgs
	DWORD addrLoadWeaponPanelImgs = Hooks::scanPattern("LoadWeaponPanelImgs","\x6A\xFF\x68\x00\x00\x00\x00\x64\xA1\x00\x00\x00\x00\x50\x64\x89\x25\x00\x00\x00\x00\x81\xEC\x00\x00\x00\x00\x53\x55\x56\x57\x8B\xBC\x24\x00\x00\x00\x00\x8B\xF1", "???????xx????xxxx????xx????xxxxxxx????xx", 0x53D0E0);
	DWORD addrWormSwitchingWeapon = Hooks::scanPattern("WormSwitchingWeapon", "\x81\xEC\x00\x00\x00\x00\x53\x55\x8B\xAC\x24\x00\x00\x00\x00\x8B\x85\x00\x00\x00\x00\x8B\x9D\x00\x00\x00\x00\x56\x57\x8B\xBD\x00\x00\x00\x00\x8B\xCD\x89\x7C\x24\x10", "??????xxxxx????xx????xx????xxxx????xxxxxx", 0x515650);

	DWORD addrWeaponPanelDrawTile_GetImgPtr_patch1 = addrWeaponPanelDrawTile + 0x3D0; // 00567A00
	addrWeaponPanelDrawTile_GetImgPtr_patch1_ret = addrWeaponPanelDrawTile + 0x3E8; // 00567A18
	Hooks::hookAsm(addrWeaponPanelDrawTile_GetImgPtr_patch1, (DWORD)&hookWeaponPanelDrawTile_GetImgPtr_patch1);

	DWORD addrWeaponPanelDrawTile_GetImgPtr_patch2 = addrWeaponPanelDrawTile + 0x408; // 00567A38
	addrWeaponPanelDrawTile_GetImgPtr_patch2_ret = addrWeaponPanelDrawTile + 0x420; //  00567A50
	Hooks::hookAsm(addrWeaponPanelDrawTile_GetImgPtr_patch2, (DWORD)&hookWeaponPanelDrawTile_GetImgPtr_patch2);

	DWORD addrWormSwitchingWeapon_GetImgPtr_patch1 = addrWormSwitchingWeapon + 0x324; //00515844
	addrWormSwitchingWeapon_GetImgPtr_patch1_ret = addrWormSwitchingWeapon + 0x337; //00515857
	Hooks::hookAsm(addrWormSwitchingWeapon_GetImgPtr_patch1, (DWORD)&hookWormSwitchingWeapon_GetImgPtr_patch1);

	// weapon panel width & iteration
	DWORD addrConstructDDGame = Hooks::scanPattern("ConstructDDGame", "\x6A\xFF\x68\x00\x00\x00\x00\x64\xA1\x00\x00\x00\x00\x50\xB8\x00\x00\x00\x00\x64\x89\x25\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x53\x55\x8B\xAC\x24\x00\x00\x00\x00\x56\x57", "???????xx????xx????xxx????x????xxxxx????xx", 0x56E220);
	DWORD addConstrucDDGame_WeaponPanelWidth_patch = addrConstructDDGame + 0xCF5; //0056E865

	unsigned char weapon_panel_box_width_op[] = {0x68, 0x00, 0x08, 0x00, 0x00};
	Hooks::patchAsm(addConstrucDDGame_WeaponPanelWidth_patch, weapon_panel_box_width_op, sizeof(weapon_panel_box_width_op));


	DWORD addrWeaponPanel_incrementCounter_patch1 = addrPrepareWeaponPanel + 0x2F2; //005680A2
	addrWeaponPanel_incrementCounter_patch1_ret = addrPrepareWeaponPanel + 0x2FF; //05680AF
	Hooks::hookAsm(addrWeaponPanel_incrementCounter_patch1, (DWORD)&hookWeaponPanel_incrementCounter_patch1);

	DWORD addrWeaponPanel_incrementCounter_patch2 = addrPrepareWeaponPanel + 0x325; //005680D5
	addrWeaponPanel_incrementCounter_patch2_ret = addrPrepareWeaponPanel + 0x33F; //005680EF
	Hooks::hookAsm(addrWeaponPanel_incrementCounter_patch2, (DWORD)&hookWeaponPanel_incrementCounter_patch2);


	// ammo/delay inline patches
	DWORD addrWeaponPanelDescription_getAmmoDelay_patch1 = addrWeaponPanelDescription + 0x114; // 00567C24
	addrWeaponPanelDescription_getAmmoDelay_patch1_ret = addrWeaponPanelDescription + 0x135; // 0567C45
	Hooks::hookAsm(addrWeaponPanelDescription_getAmmoDelay_patch1, (DWORD)&hookWeaponPanelDescription_getAmmoDelay_patch1);

	DWORD addrGetAmmo = Hooks::scanPattern("GetAmmo", "\x8B\xC8\x69\xC9\x00\x00\x00\x00\x8B\x4C\x31\x04\x69\xC9\x00\x00\x00\x00\x57\x8D\x3C\x11\x83\xBC\xBE\x00\x00\x00\x00\x00\x74\x1E\x83\xBE\x00\x00\x00\x00\x00", "????????xxxxxx????xxxxxxx?????xxxx?????", 0x5225E0);
	DWORD addrSubtractAmmo = Hooks::scanPattern("SubtractAmmo", "\x69\xC0\x00\x00\x00\x00\x8B\x44\x08\x04\x69\xC0\x00\x00\x00\x00\x03\x44\x24\x04\x8D\x84\x81\x00\x00\x00\x00\x8B\x08\x85\xC9\x7E\x05\x83\xC1\xFF\x89\x08", "??????xxxxxx????xxxxxxx????xxxxxxxxxxx", 0x522680);
	DWORD addrSubtractAmmo_v2 = Hooks::scanPattern("SubtractAmmo_v2", "\x8B\x42\x2C\xC7\x42\x00\x00\x00\x00\x00\x8B\x80\x00\x00\x00\x00\x85\xC0\x74\x0A\xC7\x80\x00\x00\x00\x00\x00\x00\x00\x00\x8B\x4A\x38", "??????????xx????xxxxxx????????xxx", 0x558E80);
	DWORD addrReduceDelayOnTurnStart = Hooks::scanPattern("ReduceDelayOnTurnStart", "\x8B\x46\x2C\x8B\x48\x24\x81\xB9\x00\x00\x00\x00\x00\x00\x00\x00\x53\x55\x57\x7C\x19\x8B\x56\x38\x69\xD2\x00\x00\x00\x00\x8B\x8C\x02\x00\x00\x00\x00", "??????xx????????xxxxxxxxxx????xxx????", 0x556E90);
	DWORD addrGetAmmoFkeys = Hooks::scanPattern("GetAmmoFkeys", "\x51\x8B\x44\x24\x10\xC7\x00\x00\x00\x00\x00\x8B\x41\x38\x69\xC0\x00\x00\x00\x00\x53\x55\x56\x8B\x71\x2C", "??????x????xxxxx????xxxxxx", 0x55AAC0);

	Hooks::polyhook("initializeWeaponTable", addrInitializeWeaponTable, (DWORD *) &hookInitializeWeaponTable, (DWORD *) &origInitializeWeaponTable);
	Hooks::polyhook("getAmmo", addrGetAmmo, (DWORD *) &hookGetAmmo, (DWORD *) &origGetAmmo);
	Hooks::polyhook("subtractAmmo_v1", addrSubtractAmmo, (DWORD *) &hookSubtractAmmo, (DWORD *) &origSubtractAmmo);
	Hooks::polyhook("subtractAmmo_v2", addrSubtractAmmo_v2, (DWORD *) &hookSubtractAmmo_v2, (DWORD *) &origSubtractAmmo_v2);
//	Hooks::minhook("loadWeaponPanelImgs", addrLoadWeaponPanelImgs, (DWORD*)&hookLoadWeaponPanelImgs, (DWORD*)&origLoadWeaponPanelImgs);
//	Hooks::minhook("vfsCreateGfxDirReader", addrVfsCreateGfxDirReader, (DWORD*)&hookVfsCreateGfxDirReader, (DWORD*)&origVfsCreateGfxDirReader);
//	Hooks::minhook("loadImgFromVfs", addrLoadImgFromVfs, (DWORD*) &hookLoadImgFromVfs, (DWORD*)&origLoadImgFromVfs);
	Hooks::polyhook("reduceDelayOnTurnStart", addrReduceDelayOnTurnStart, (DWORD *) &hookReduceDelayOnTurnStart, (DWORD *) &origReduceDelayOnTurnStart);


	setupIsSecretOverride();
	_ScanLazy(IsSecretWeap, "83c0f683f833");
	_HookDefault(IsSecretWeap);
	
	setupIsUtilityOverride();
	_ScanLazy(IsUtility, "83f83e7c??83f8467f??b801??????c3");
	_HookDefault(IsUtility);
	
	setupIsSheepOverride();
	_ScanLazy(IsSheep, "83c0fb83f82d");
	_HookDefault(IsSheep);
	
	

	auto * lua = Lua::getInstance().getState();
	sol::usertype <WeaponStruct> ut = lua->new_usertype<WeaponStruct> ("WeaponStruct");
	lua->set_function("registerCustomWeapon", &registerCustomWeapon);

	lua->set_function("isSuperWeapon", &callIsSecret);
	lua->set_function("setSuperWeapon", &setIsSuper);
	lua->set_function("isUtilityWeapon", &callIsUtility);
	lua->set_function("setUtilityWeapon", &setIsUtility);
	lua->set_function("isSheepWeapon", &callIsSheep);
	lua->set_function("setSheepWeapon", &setIsSheep);

	lua->set_function("getNumWeapons", &getNumWeapons);

	lua->set_function("getWeaponData", &getWeaponData); //needs to happen after weaps init
	lua->set_function("triggerNuclearTest", &triggerNuclearTest);
	lua->set_function("triggerSkipGo", &triggerSkipGo);

	lua->set_function("setTeamAmmoCustom", &setCustomWeaponAmmoOrDelay);
	lua->set_function("getTeamAmmoCustom", &getCustomWeaponAmmoOrDelay);

	lua->set_function("setTeamAmmo", &setWeaponAmmoOrDelay);
	lua->set_function("getTeamAmmo", &getWeaponAmmoOrDelay);

	lua->set_function("getTime", &gettime);

	ut["name1"] = sol::readonly(&WeaponStruct::name1);
	ut["name2"] = sol::readonly(&WeaponStruct::name2);
	ut["panelRow"] = &WeaponStruct::panelRow;
	ut["unknownC"] = &WeaponStruct::remembered;
	ut["unknown10"] = &WeaponStruct::usableincavern;
	ut["unknown14"] = &WeaponStruct::numberofshots;
	ut["unknown18"] = &WeaponStruct::endsturn;
	ut["unknown1C"] = &WeaponStruct::retreattime;
	ut["unknown20"] = &WeaponStruct::unknown20;
	ut["unknown24"] = &WeaponStruct::cratechance;
	ut["unknown28"] = &WeaponStruct::crateammo;
	ut["unknown2C"] = &WeaponStruct::customdata;
	ut["unknown30"] = &WeaponStruct::activationtype;
	ut["unknown34"] = &WeaponStruct::activationparam;


	ut["unknown38"] = &WeaponStruct::Param1;
	ut["Param1"] = &WeaponStruct::Param1;
	ut["suicidebomberpoison"] = &WeaponStruct::Param1;
	ut["unknown3C"] = &WeaponStruct::Param2;
	ut["Param2"] = &WeaponStruct::Param2;
	ut["kamiexplosionpower"] = &WeaponStruct::Param2;
	ut["suicidexplosionpower"] = &WeaponStruct::Param2;
	ut["unknown40"] = &WeaponStruct::Param3;
	ut["Param3"] = &WeaponStruct::Param3;
	ut["unknown44"] = &WeaponStruct::Param4;
	ut["Param4"] = &WeaponStruct::Param4;
	ut["unknown48"] = &WeaponStruct::Param5;
	ut["Param5"] = &WeaponStruct::Param5;
	ut["unknown4C"] = &WeaponStruct::Param6;
	ut["Param6"] = &WeaponStruct::Param6;
	ut["unknown50"] = &WeaponStruct::Param7;
	ut["Param7"] = &WeaponStruct::Param7;
	ut["unknown54"] = &WeaponStruct::unknown54;
	ut["unknown58"] = &WeaponStruct::unknown58;
	ut["unknown5C"] = &WeaponStruct::unknown5C;
	ut["unknown60"] = &WeaponStruct::unknown60;
	ut["unknown64"] = &WeaponStruct::unknown64;
	ut["unknown68"] = &WeaponStruct::unknown68;
	ut["unknown6C"] = &WeaponStruct::unknown6C;
	ut["unknown70"] = &WeaponStruct::unknown70;
	ut["unknown74"] = &WeaponStruct::unknown74;
	ut["unknown78"] = &WeaponStruct::unknown78;
	ut["unknown7C"] = &WeaponStruct::unknown7C;
	ut["unknown80"] = &WeaponStruct::unknown80;
	ut["unknown84"] = &WeaponStruct::unknown84;
	ut["unknown88"] = &WeaponStruct::unknown88;
	ut["unknown8C"] = &WeaponStruct::unknown8C;
	ut["unknown90"] = &WeaponStruct::unknown90;
	ut["unknown94"] = &WeaponStruct::unknown94;
	ut["unknown98"] = &WeaponStruct::unknown98;

	ut["unknown9C"] = &WeaponStruct::unknown9C;
	ut["unknownA0"] = &WeaponStruct::unknownA0;
	ut["unknownA4"] = &WeaponStruct::unknownA4;
	ut["unknownA8"] = &WeaponStruct::unknownA8;
	ut["unknownAC"] = &WeaponStruct::unknownAC;
	ut["unknownB0"] = &WeaponStruct::unknownB0;
	ut["unknownB4"] = &WeaponStruct::unknownB4;
	ut["unknownB8"] = &WeaponStruct::unknownB8;
	ut["unknownBC"] = &WeaponStruct::unknownBC;
	ut["unknownC0"] = &WeaponStruct::unknownC0;
	ut["unknownC4"] = &WeaponStruct::unknownC4;
	ut["unknownC8"] = &WeaponStruct::unknownC8;
	ut["unknownCC"] = &WeaponStruct::unknownCC;
	ut["unknownD0"] = &WeaponStruct::unknownD0;
	ut["unknownD4"] = &WeaponStruct::unknownD4;
	ut["unknownD8"] = &WeaponStruct::unknownD8;
	ut["unknownDC"] = &WeaponStruct::unknownDC;
	ut["unknownE0"] = &WeaponStruct::unknownE0;
	ut["unknownE4"] = &WeaponStruct::unknownE4;
	ut["unknownE8"] = &WeaponStruct::unknownE8;
	ut["unknownEC"] = &WeaponStruct::unknownEC;
	ut["unknownF0"] = &WeaponStruct::unknownF0;
	ut["unknownF4"] = &WeaponStruct::unknownF4;
	ut["unknownF8"] = &WeaponStruct::unknownF8;
	ut["unknownFC"] = &WeaponStruct::unknownFC;
	ut["unknown100"] = &WeaponStruct::unknown100;
	ut["unknown104"] = &WeaponStruct::unknown104;
	ut["unknown108"] = &WeaponStruct::unknown108;
	ut["unknown10C"] = &WeaponStruct::unknown10C;
	ut["unknown110"] = &WeaponStruct::unknown110;
	ut["unknown114"] = &WeaponStruct::unknown114;
	ut["unknown118"] = &WeaponStruct::unknown118;
	ut["unknown11C"] = &WeaponStruct::unknown11C;
	ut["unknown120"] = &WeaponStruct::unknown120;
	ut["unknown124"] = &WeaponStruct::unknown124;
	ut["unknown128"] = &WeaponStruct::unknown128;
	ut["unknown12C"] = &WeaponStruct::unknown12C;
	ut["unknown130"] = &WeaponStruct::unknown130;
	ut["unknown134"] = &WeaponStruct::unknown134;
	ut["unknown138"] = &WeaponStruct::unknown138;
	ut["unknown13C"] = &WeaponStruct::unknown13C;
	ut["unknown140"] = &WeaponStruct::unknown140;
	ut["unknown144"] = &WeaponStruct::unknown144;
	ut["unknown148"] = &WeaponStruct::unknown148;
	ut["unknown14C"] = &WeaponStruct::unknown14C;
	ut["unknown150"] = &WeaponStruct::unknown150;
	ut["unknown154"] = &WeaponStruct::unknown154;
	ut["unknown158"] = &WeaponStruct::unknown158;
	ut["unknown15C"] = &WeaponStruct::unknown15C;
	ut["unknown160"] = &WeaponStruct::unknown160;
	ut["unknown164"] = &WeaponStruct::unknown164;
	ut["unknown168"] = &WeaponStruct::unknown168;
	ut["unknown16C"] = &WeaponStruct::unknown16C;
	ut["unknown170"] = &WeaponStruct::unknown170;
	ut["unknown174"] = &WeaponStruct::unknown174;
	ut["unknown178"] = &WeaponStruct::unknown178;
	ut["unknown17C"] = &WeaponStruct::unknown17C;
	ut["unknown180"] = &WeaponStruct::unknown180;
	ut["unknown184"] = &WeaponStruct::unknown184;
	ut["unknown188"] = &WeaponStruct::unknown188;
	ut["unknown18C"] = &WeaponStruct::unknown18C;
	ut["unknown190"] = &WeaponStruct::unknown190;
	ut["unknown194"] = &WeaponStruct::unknown194;
	ut["unknown198"] = &WeaponStruct::unknown198;
	ut["unknown19C"] = &WeaponStruct::unknown19C;
	ut["unknown1A0"] = &WeaponStruct::unknown1A0;
	ut["unknown1A4"] = &WeaponStruct::unknown1A4;
	ut["unknown1A8"] = &WeaponStruct::unknown1A8;
	ut["unknown1AC"] = &WeaponStruct::unknown1AC;
	ut["unknown1B0"] = &WeaponStruct::unknown1B0;
	ut["unknown1B4"] = &WeaponStruct::unknown1B4;
	ut["unknown1B8"] = &WeaponStruct::unknown1B8;
	ut["unknown1BC"] = &WeaponStruct::unknown1BC;
	ut["unknown1C0"] = &WeaponStruct::unknown1C0;
	ut["unknown1C4"] = &WeaponStruct::unknown1C4;
	ut["unknown1C8"] = &WeaponStruct::unknown1C8;
	ut["unknown1CC"] = &WeaponStruct::unknown1CC;



	ut["remembered"] = &WeaponStruct::remembered;
	ut["usableincavern"] = &WeaponStruct::usableincavern;
	ut["numberofshots"] = &WeaponStruct::numberofshots;
	ut["endsturn"] = &WeaponStruct::endsturn;
	ut["retreattime"] = &WeaponStruct::retreattime;
	ut["unknown20"] = &WeaponStruct::unknown20;
	ut["cratechance"] = &WeaponStruct::cratechance;
	ut["crateammo"] = &WeaponStruct::crateammo;
	ut["customdata"] = &WeaponStruct::customdata;
	ut["activationtype"] = &WeaponStruct::activationtype;
	ut["activationparam"] = &WeaponStruct::activationparam;
	ut["herdsize"] = &WeaponStruct::activationparam;
	ut["airstrikesubtype"] = &WeaponStruct::activationparam;
	ut["spaceaction"] = &WeaponStruct::activationparam;
	ut["guntype"] = &WeaponStruct::Param1;
	ut["crossairtype"] = &WeaponStruct::Param1;
	ut["planesprite"] = &WeaponStruct::Param1;


	ut["asbombscount"] = &WeaponStruct::Param2;
	ut["asdistancebetweendrops"] = &WeaponStruct::Param3;
	ut["ashorizontalspeed"] = &WeaponStruct::Param4;
	ut["assound"] = &WeaponStruct::Param5;
	ut["astype"] = &WeaponStruct::Param6;
	ut["skunkpower"] = &WeaponStruct::unknown118;


	ut["GetLauncherData"] = &CustomWeapons::GetLauncherData;
	ut["GetGunData"] = &CustomWeapons::GetGunData;
	ut["GetFlamethrowerData"] = &CustomWeapons::GetFlamethrowerData;
	ut["GetExtraData"] = &CustomWeapons::GetExtraData;

	
	sol::usertype <Launcher> pt = lua->new_usertype<Launcher>("Launcher");
	pt["spritesize"] = &Launcher::spritesize; // 0x3C
	pt["fixedspeed"] = &Launcher::fixedspeed; // 0x40
	pt["makesscream"] = &Launcher::makesscream; // 0x44
	pt["explosion"] = &Launcher::explosion; // 0x48
	pt["unknown5C"] = &Launcher::unknown5C; // 0x5C
	pt["sprite"] = &Launcher::sprite; // 0x60
	pt["variablespeed"] = &Launcher::variablespeed; // 0x78
	pt["windfactor"] = &Launcher::windfactor; // 0x7C
	pt["motionrandomness"] = &Launcher::motionrandomness; // 0x80
	pt["gravityfactor"] = &Launcher::gravityfactor; // 0x84
	pt["explosioncountdown"] = &Launcher::explotioncountdown; // 0x88
	pt["explosiontimer"] = &Launcher::explosiontimer; // 0x8C
	pt["sound"] = &Launcher::sound; // 0x90
	pt["spacetriggered"] = &Launcher::spacetriggered; // 0xA0
	pt["explosionactiontype"] = &Launcher::explosionactiontype; // 0xA4
	pt["explosionaction"] = &Launcher::explosionaction;
	pt["explosiontarget"] = &Launcher::explosiontarget; // 0xF0
	pt["GetAction"] = &CustomWeapons::GetActionDataL;
	pt["GetExplosionTarget"] = &CustomWeapons::GetExplosionTargetL;


	sol::usertype <Sprite> spr = lua->new_usertype<Sprite>("Sprite");
	spr["spriteid"] = &Sprite::spriteid;
	spr["animationtype"] = &Sprite::animationtype;
	spr["trailsprite"] = &Sprite::trailsprite;
	spr["trailamount"] = &Sprite::trailamount;
	spr["trailvanishspeed"] = &Sprite::trailvanishspeed;
	spr["unknown"] = &Sprite::unknown;


	sol::usertype <Sound> st = lua->new_usertype<Sound>("Sound");
	st["soundid"] = &Sound::soundid;
	st["loop"] = &Sound::loop;
	st["isexplosion"] = &Sound::isexplosion;
	st["beforeexplosion"] = &Sound::beforeexplosion;
	st["delay"] = &Sound::delay;

	sol::usertype <Mine> Mt = lua->new_usertype<Mine>("Mine");
	Mt["radius"] = &Mine::Radius;
	Mt["delay"] = &Mine::Delay;
	Mt["collisionflags"] = &Mine::DetectionFlags; //for detection
	Mt["fusetime"] = &Mine::FuseTime;
	Mt["bias"] = &Mine::ExplosionBias;
	Mt["power"] = &Mine::Power;
	Mt["damage"] = &Mine::Damage;

	sol::usertype <Airstrike> aat = lua->new_usertype<Airstrike>("Airstrike");
	aat["PlaneSprite"] = &Airstrike::PlaneSprite; // 0x3C
	aat["BombsCount"] = &Airstrike::BombsCount; // 0x3C
	aat["DropsSpacing"] = &Airstrike::DropsSpacing; // 0x3C
	aat["PlaneSpeed"] = &Airstrike::PlaneSpeed; // 0x3C
	aat["Sound"] = &Airstrike::Sound; // 0x3C
	aat["Action"] = &Airstrike::Action; // 0x3C
	aat["ActionData"] = &Airstrike::ActionData; // 0x3C
	aat["GetAction"] = &CustomWeapons::GetActionDataAS;

	sol::usertype <Canister> cat = lua->new_usertype<Canister>("Canister");
	cat["SpriteInactive"] = &Canister::SpriteInactive; // 0x3C
	cat["SpriteActive"] = &Canister::SpriteActive; // 0x40
	cat["PoisonAmount"] = &Canister::PoisonAmount; // 0x44
	cat["Damage"] = &Canister::Damage; // 0x48

	sol::usertype <Gun> scat = lua->new_usertype<Gun>("Gun");
	scat["bulletcount"] =&Gun::bulletcount; // 0x3C
	scat["reloadtime"] =&Gun::reloadtime; // 0x40
	scat["bulletspread"] =&Gun::bulletspread; // 0x44
	scat["brust"] =&Gun::brust; // 0x48
	scat["brustspread"] =&Gun::brustspread; // 0x4C
	scat["explosion"] =&Gun::explosion; // 0x50
	scat["expeffect"] =&Gun::expeffect; // 0x64
	scat["range1"] =&Gun::range1; // 0x68
	scat["range2"] =&Gun::range2; // 0x6C
	scat["range3"] =&Gun::range3; // 0x70

	sol::usertype <BounceAction> cato = lua->new_usertype<BounceAction>("BounceAction");
	cato["BounceFlags"] =&BounceAction::BounceFlags; // 0xA8
	cato["Bounciness"] =&BounceAction::Bounciness; // 0xAC
	cato["Acceleration"] =&BounceAction::Acceleration; // 0xB0
	cato["Sound"] =&BounceAction::Sound; // 0xB4
	cato["Unk1"] =&BounceAction::Unk1; // 0xB8
	cato["Unk2"] =&BounceAction::Unk2; // 0xBC
	cato["Explosionbias"] =&BounceAction::Explosionbias; // 0xC0
	cato["Power"] =&BounceAction::Power; // 0xC4
	cato["Damage"] =&BounceAction::Damage; // 0xC8
	cato["RandomDamage"] =&BounceAction::RandomDamage; // 0xCC
	cato["NumberOfBounces"] =&BounceAction::NumberOfBounces; // 0xD0

	sol::usertype <RoamAction> cawt = lua->new_usertype<RoamAction>("RoamAction");
		cawt["RoamFlags"] =&RoamAction::RoamFlags; // 0xA8
		cawt["ExplodeFlags"] =&RoamAction::ExplodeFlags; // 0xAC
		cawt["WalkSpeed"] =&RoamAction::WalkSpeed; // 0xB0
		cawt["TerrainTolerance"] =&RoamAction::Unknown; // 0xB4
		cawt["JumpEdgeAngle"] =&RoamAction::JumpEdgeAngle; // 0xB8
		cawt["JumpEdgeVelocity"] =&RoamAction::JumpEdgeVelocity; // 0xBC
		cawt["JumpEdgeSound"] =&RoamAction::JumpEdgeSound; // 0xC0
		cawt["JumpAngle"] =&RoamAction::JumpAngle; // 0xC4
		cawt["JumpVelocity"] =&RoamAction::JumpVelocity; // 0xC8
		cawt["JumpSound"] =&RoamAction::JumpSound; // 0xCC
		cawt["TerrainOffset"] =&RoamAction::TerrainOffset; // 0xD0
		cawt["Fart"] =&RoamAction::Fart; // 0xD4
		cawt["PoisonPower"] =&RoamAction::PoisonPower; // 0xD8
		cawt["FartSprite"] =&RoamAction::FartSprite; // 0xDC
		cawt["FlySprite"] =&RoamAction::FlySprite; // 0xE0
		cawt["FlySprite2"] =&RoamAction::FlySprite2; // 0xE4
		cawt["TakingOffSprite"] =&RoamAction::TakingOffSprite; // 0xE8
		cawt["FlyingSprite"] =&RoamAction::FlyingSprite; // 0xEC

		sol::usertype <HomingAction> dd = lua->new_usertype<HomingAction>("HomingAction");
		dd["Unused"] =&HomingAction::Unused; // 0xA8
		dd["Sprite"] =&HomingAction::Sprite; // 0xAC
		dd["type"] =&HomingAction::type; // 0xB0
		dd["delay"] =&HomingAction::delay; // 0xB4
		dd["duration"] =&HomingAction::duration; // 0xB8

		sol::usertype <DigAction> ddig = lua->new_usertype<DigAction>("DigAction");
		ddig["Unk1"] =&DigAction::Unk1; // 0xA8
		ddig["Unk2"] =&DigAction::Unk2; // 0xAC
		ddig["Sound"] =&DigAction::Sound; // 0xB0
		ddig["JumpingSprite"] =&DigAction::JumpingSprite; // 0xB4
		ddig["Sprite1"] =&DigAction::Sprite1; // 0xB8
		ddig["Sprite2"] =&DigAction::Sprite2; // 0xBC
		ddig["Sprite3"] =&DigAction::Sprite3; // 0xC0

		sol::usertype <Flamethrower> dds = lua->new_usertype<Flamethrower>("Flamethrower");
		dds["fuel"] =&Flamethrower::fuel; // 0x3C
		dds["fireintensity"] =&Flamethrower::fireintensity; // 0x40
		dds["fireamount"] =&Flamethrower::fireamount; // 0x44
		dds["burntime"] =&Flamethrower::burntime; // 0x48
		dds["persistent"] =&Flamethrower::persistent; // 0x4C


		sol::usertype <ClusterExplosion> ddas = lua->new_usertype<ClusterExplosion>("ClusterExplosion");
		ddas["amount"] = &ClusterExplosion::amount;
		ddas["dispersion"] = &ClusterExplosion::dispersion;
		ddas["speed"] = &ClusterExplosion::speed;
		ddas["EjectionAngle"] = &ClusterExplosion::EjectionAngle;
		ddas["DispersionAngle"] = &ClusterExplosion::DispersionAngle;
		ddas["explosion"] = &ClusterExplosion::explosion;
		ddas["Unknown"] = &ClusterExplosion::Unknown;
		ddas["Animation"] = &ClusterExplosion::Animation;
		ddas["Acceleration"] = &ClusterExplosion::Acceleration;
		ddas["WindFactor"] = &ClusterExplosion::WindFactor;
		ddas["Randomness"] = &ClusterExplosion::Randomness;
		ddas["Gravity"] = &ClusterExplosion::Gravity;
		ddas["Unused"] = &ClusterExplosion::Unused;
		ddas["Unused2"] = &ClusterExplosion::Unused2;
		ddas["Sound"] = &ClusterExplosion::Sound;
		ddas["Spacebar"] = &ClusterExplosion::Spacebar;
		ddas["Action"] = &ClusterExplosion::Action;
		ddas["ExplosionAction"] =&ClusterExplosion::ExplosionAction;
		ddas["GetAction"] = &CustomWeapons::GetActionData;

		sol::usertype <FireExplosion> ddss = lua->new_usertype<FireExplosion>("FireExplosion");
		ddss["power"] =&FireExplosion::power; // 0x3C
		ddss["spread"] =&FireExplosion::spread; // 0x40
		ddss["duration"] =&FireExplosion::duration; // 0x44
		ddss["persist"] =&FireExplosion::persist; // 0x48

		sol::usertype <DragonBall> db = lua->new_usertype<DragonBall>("DragonBall");
			db["Sound"] =&DragonBall::Sound; // 0x38
			db["ImpactSound"] =&DragonBall::ImpactSound; // 0x3C
			db["Sprite"] =&DragonBall::Sprite; // 0x40
			db["Damage"] =&DragonBall::Damage; // 0x44
			db["Angle"] =&DragonBall::Angle; // 0x48
			db["Force"] =&DragonBall::Force; // 0x4C
			db["FlyingTime"] =&DragonBall::FlyingTime; // 0x50

		sol::usertype <Kamikaze> km = lua->new_usertype<Kamikaze>("Kamikaze");
			km["FlyingTime"] =&Kamikaze::FlyingTime; // 0x38
			km["ExplosionDamage"] =&Kamikaze::ExplosionDamage; // 0x3C
			km["FireSound"] =&Kamikaze::FireSound; // 0x40
			km["Damage"] =&Kamikaze::Damage; // 0x44
			km["ImpactForce"] =&Kamikaze::ImpactForce; // 0x48
			km["ImpactAngle"] =&Kamikaze::ImpactAngle; // 0x4C
		
		sol::usertype <FirePunch> pnch = lua->new_usertype<FirePunch>("FirePunch");
			pnch["Damage"] =&FirePunch::Damage; // 0x38
			pnch["Angle"] =&FirePunch::Angle; // 0x3C
			pnch["Push"] =&FirePunch::Push; // 0x40
			pnch["Height"] =&FirePunch::Height; // 0x44

		sol::usertype <Drill> fp = lua->new_usertype<Drill>("Drill");
			fp["Damage"] =&Drill::Damage; // 0x38
			fp["PushPower"] =&Drill::PushPower; // 0x3C
			fp["ImpactAngle"] =&Drill::ImpactAngle; // 0x40
			fp["Duration"] =&Drill::Duration; // 0x44

		sol::usertype <Blowtorch> blw = lua->new_usertype<Blowtorch>("Blowtorch");
			blw["Damage"] =&Blowtorch::Damage; // 0x38
			blw["PushPower"] =&Blowtorch::PushPower; // 0x3C
			blw["ImpactAngle"] =&Blowtorch::ImpactAngle; // 0x40
			blw["Duration"] =&Blowtorch::Duration; // 0x44


			sol::usertype <Prod> prd = lua->new_usertype<Prod>("Prod");		
			prd["Damage"] =&Prod::Damage; // 0x38
			prd["PushPower"] =&Prod::PushPower; // 0x3C
			prd["Angle"] =&Prod::Angle; // 0x40
		

			sol::usertype <NinjaRope> njr = lua->new_usertype<NinjaRope>("NinjaRope");
			njr["Shots"] =&NinjaRope::Shots; // 0x38
			njr["Length"] =&NinjaRope::Length; // 0x3C
			njr["AngleRestriction"] =&NinjaRope::AngleRestriction; // 0x40
		

			sol::usertype <Bat> bbb = lua->new_usertype<Bat>("BaseballBat");
			bbb["Damage"] = &Bat::Damage; // 0x38
			bbb["PushPower"] = &Bat::PushPower; // 0x3C
		

			sol::usertype <Suicide> scb = lua->new_usertype<Suicide>("SuicideBomber");
			scb["Poison"] = &Suicide::Poison; // 0x38
			scb["Damage"] = &Suicide::Damage; // 0x3C

		sol::usertype <NuclearTest> ntest = lua->new_usertype<NuclearTest>("NuclearTest");
		ntest["WaterRise"] = &NuclearTest::WaterRise; // 0x38
		ntest["Poison"] = &NuclearTest::Poison; // 0x3C

		sol::usertype <JetPack> jpa = lua->new_usertype<JetPack>("JetPack");
		jpa["Fuel"] = &JetPack::Fuel; // 0x38

		sol::usertype <BattleAxe> axe = lua->new_usertype<BattleAxe>("BattleAxe");
		axe["Percentage"] = &BattleAxe::Percentage; // 0x38

		sol::usertype <Parachute> chute = lua->new_usertype<Parachute>("Parachute");		
		chute["WindFactor"] = &Parachute::WindFactor; // 0x38




	return 0;
}

//void CustomWeapons::switchWeaponTable() {
//	DWORD addrDDGame = Game::getAddrGameGlobal();
//	DWORD addrWeaponPanel = *(DWORD*)(addrDDGame + 0x548);
//	*(DWORD*)(addrWeaponPanel + 0x1CC) = 1;
//}
