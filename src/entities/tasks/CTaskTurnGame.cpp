
#include "../../Config.h"
#include "../../Game.h"
#include "CTaskTurnGame.h"

#include "../../Hooks.h"
#include "../../Lua.h"
#include <sol/sol.hpp>

void CTaskTurnGame::triggerTaskMessage(Constants::TaskMessage type, size_t size, void * data) {
	CTaskTurnGame * turngame = (CTaskTurnGame*)Game::getAddrTurnGameObject();
	if (!turngame) return;
	turngame->vtable8_HandleMessage(turngame, type, size, data);
}

void calltriggerTaskMessage(int type, int size, int* data) {
	CTaskTurnGame* turngame = (CTaskTurnGame*)Game::getAddrTurnGameObject();
	turngame->vtable8_HandleMessage(turngame, (Constants::TaskMessage)type, size, data);
}

void CTaskTurnGame::triggerArmageddon(int amount, int delay) {
	int param[4] = {0};
	param[0] = amount;
	param[1] = delay;
	param[2] = 56;
	param[3] = 2;
	triggerTaskMessage(Constants::TaskMessage::TaskMessage_Armageddon, sizeof(param), &param);
}

void CTaskTurnGame::triggerQuake(int amount) {
	int param[4] = {0};
	param[0] = 8;
	param[1] = amount;
	triggerTaskMessage(Constants::TaskMessage::TaskMessage_Earthquake, sizeof(param), &param);
}

int (__fastcall *addrSpawnObject)(int This, int EDX, SpawnObjectParams * params);
void CTaskTurnGame::spawnObject(SpawnObjectParams * params) {
	DWORD addrCTurnGameObject = Game::getAddrTurnGameObject();
	if (!addrCTurnGameObject) return;
	addrSpawnObject(addrCTurnGameObject, 0, params);
	printf("object spawned: %d \n", params->type);
}

void spawnTextObject(std::string str) {
	DWORD addrCTurnGameObject = Game::getAddrTurnGameObject();
	if (!addrCTurnGameObject) return;
	SpawnObjectParams* params = new SpawnObjectParams();
	params->type = SpawnObjectParams::Type::UnknownTriggerGameText;//Object_TriggerGameText
	if (str.length() > 43) { //35
		str = str.substr(0, 43);
		str += '\0';
	}
	memcpy(&params->posX, str.c_str(), str.length());
	addrSpawnObject(addrCTurnGameObject, 0, params);
	printf("object spawned: %d \n", params->type);
}

void getObjects() {
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	turngame->traverse([&](CTask* obj, const int level) {
		for (int i = 0; i < level; i++) printf("\t");
	printf("Obj: Type: %d \n", obj->classtype);
		});
}
int getNumObjects(int objtype) {
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	std::unordered_map<int, bool> has;
	turngame->traverse([&](CTask* obj, const int level) {
		for (int i = 0; i < level; i++)
			if ((obj->classtype == objtype) && (has.find(obj->getAddr()) == has.end())) {
				has[obj->getAddr()] = true;				
			}
		});
	return has.size();
}

CTask* getObject(int objtype,int index) {
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	std::unordered_map<int, bool> has;
	CTask* ret = nullptr;
	turngame->traverse([&](CTask* obj, const int level) {
	for (int i = 0; i < level; i++)
		if ((obj->classtype == objtype) && (has.find(obj->getAddr()) == has.end())) {
			has[obj->getAddr()] = true;
		if (index == has.size()) {
			ret = obj;
		}
	}
		});
	return ret;
}

CTaskWorm* getWorm(int index) {
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	std::unordered_map<int, bool> has;
	CTaskWorm* ret = nullptr;
	turngame->traverse([&](CTask* obj, const int level) {
		for (int i = 0; i < level; i++)
		if ((obj->classtype == ClassType_Task_Worm) && (has.find(obj->getAddr()) == has.end())) {
			has[obj->getAddr()] = true;
			if (index == has.size()) {
				ret = (CTaskWorm*)obj;
			}
		}
		});
	return ret;
}


//int(__stdcall* origShouldPauseTurn)();
//int __stdcall CTaskTurnGame::hookShouldPauseTurn() {
//	CTaskTurnGame* This;
//	int retv;
//	_asm mov This, eax
//
//	_asm mov eax, This
//	_asm call origShouldPauseTurn
//	_asm mov retv, eax
//
//	return retv;
//}
//

int getWind()
{
	DWORD collisionmanager = *(DWORD*)(Game::getAddrGameGlobal() + 0x528);
	return *(DWORD*)(collisionmanager + 0x230);
}
void setWind(int val)
{
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	DWORD collisionmanager = *(DWORD*)(Game::getAddrGameGlobal() + 0x528);
	*(DWORD*)(collisionmanager + 0x230) = val;
	turngame->vtable8_HandleMessage(turngame, Constants::TaskMessage::TaskMessage_SetWind, sizeof(*(DWORD*)(collisionmanager + 0x230)), &*(DWORD*)(collisionmanager + 0x230)); // just to update UI
}

void setGravity(int val)
{
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	DWORD collisionmanager = *(DWORD*)(Game::getAddrGameGlobal() + 0x528);
	*(DWORD*)(collisionmanager + 0x22E) = val;
}



_HookDefLazy(CanTurnEnd, int, __stdcall, ()) { //not qwhat I expected, it just tells you if the turn is ongoing enough and should be ended
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	int retv;
	_asm mov eax, turngame 
	return origCanTurnEnd();
}
int callCanTurnEnd() {
	int ret = hookCanTurnEnd();	
	return ret;
}


_HookDefLazy(AllowWormDamage, int, __stdcall, ()) {
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	int retv;
	_asm mov esi, turngame //I dunno wtf the callconvention here is so lets just shove this in, lol
	return origAllowWormDamage();
}
bool mutespeech = false;
int callAllowWormDamage(bool mute) {
	if (mute) { mutespeech = true; }
	int ret = hookAllowWormDamage();
	mutespeech = false;
	return ret;
}


_HookDefLazy(AllowWormDeath, int, __stdcall, ()) { 
	auto ddgame = Game::getAddrDDGame();
	CTask* turngame = *(CTask**)(ddgame + 0x8);
	int retv;
	_asm mov edi, turngame //I dunno wtf the callconvention here is so lets just shove this in, lol
	return origAllowWormDeath();
}
/*
_HookDefLazy(UpdateDamageDisplay, int, __fastcall, (CTaskWorm* worm)) {
	return origUpdateDamageDisplay(worm);
}

_HookDefLazy(WormSound, int, __fastcall, (CTaskWorm* worm)) { //this is actually for worm walking/jumping and shit like that
	//_asm mov [ESP+4], 0 //2nd stack thing, its volume
	return origWormSound(worm);
}
int callUpdateDamageDisplay(CTaskWorm* worm) { //this doesnt really update anything, its a render update thing...
	_asm mov ecx, worm //I dunno wtf the callconvention here is so lets just shove this in, lol
	return origUpdateDamageDisplay(worm);
}

*/
_HookDefLazy(EmitSpeech, int, __fastcall, (CTaskWorm* worm)) { //this is for phrases other than yes sir (revenge and shit)
	//_asm mov [ESP+4], 0 //2nd stack thing, its volume
	if (mutespeech) { return 0; }
	return origEmitSpeech(worm);
}

//8b4424??8b40??83b8????????00
_HookDefLazy(SetCameraTrackTarget, void, __fastcall, (int x, int y, CGameTask* a2, int priority)) {
	//printf("x: %d, y: %d, p11: %d, p22: %d, \n", x,y, a2, priority);
	return origSetCameraTrackTarget(x, y, a2, priority);
}
void callSetCameraTrackTarget(int x, int y, int priority) {
	auto ddgame = Game::getAddrDDGame();
	CGameTask* turngame = *(CGameTask**)(ddgame + 0x8);
	return hookSetCameraTrackTarget(x, y, turngame, priority);
}
_HookDefLazy(FocusCamera, void, __fastcall, (int x, int y, CGameTask* focusobj)) {
	//printf("CTASK: %d, X: %d , %d \n", focusobj, x, y);
	return origFocusCamera(x, y, focusobj);
}
void callFocusCamera(int x, int y) {
	auto ddgame = Game::getAddrDDGame();
	CGameTask* turngame = *(CGameTask**)(ddgame + 0x8);
	return hookFocusCamera(x, y, turngame);
}

_HookDefLazy(CreateSmoke, void, __stdcall, (CGameTask* param_1, int smoketype, int x, int y, int smokeamount)) {
	auto ddgame = Game::getAddrDDGame();
	CGameTask* turngame = *(CGameTask**)(ddgame + 0x8);
		origCreateSmoke(param_1, smoketype, x, y, smokeamount); 
}
void callCreateSmoke(int x, int y, int smoketype, int smokeamount) {
	auto ddgame = Game::getAddrDDGame();
	CGameTask* turngame = *(CGameTask**)(ddgame + 0x8);
	return hookCreateSmoke(turngame, smoketype, x, y, smokeamount);
}

int CTaskTurnGame::install(SignatureScanner &signatureScanner, module mod) {
	DWORD addrConstructCTaskTurnGame =   Hooks::scanPattern("ConstructCTaskTurnGame", "\x6A\xFF\x68\x00\x00\x00\x00\x64\xA1\x00\x00\x00\x00\x50\x64\x89\x25\x00\x00\x00\x00\x53\x55\x8B\x6C\x24\x1C\x56\x8B\x74\x24\x1C\x57\x55\x8B\xF9\x57\x56\xE8\x00\x00\x00\x00\x33\xDB\x89\x5C\x24\x18\xC7\x06\x00\x00\x00\x00\xC7\x46\x00\x00\x00\x00\x00\xC7\x46\x00\x00\x00\x00\x00", "???????xx????xxxx????xxxxxxxxxxxxxxxxxx????xxxxxxxx????xx?????xx?????", 0x55B280);

	//DWORD addrShouldPauseTurn = Hooks::scanPattern("ShouldPauseTurn", "\x53\x8B\x58\x7C\x56\x57\xBF\x00\x00\x00\x00\x3B\xDF\x7C\x41\x8B\x70\x2C\x81\xC6\x00\x00\x00\x00\xEB\x06\x8D\x9B\x00\x00\x00\x00\x8B\x96\x00\x00\x00\x00\xB8\x00\x00\x00\x00\x3B\xD0\x7C\x14\x8B\xCE", "??????x????xxxxxxxxx????xxxxxxxxxx????x????xxxxxx");
	//Hooks::minhook("CTaskTurnGameShouldPause", addrShouldPauseTurn, (DWORD*)&hookShouldPauseTurn, (DWORD*)&origShouldPauseTurn);

	DWORD* addrCTaskTurnGameVTable = *(DWORD**)(addrConstructCTaskTurnGame + 0x33);
//	addrCTaskTurnGameHandleMessage = *(DWORD*)(addrCTaskTurnGameVTable + 8);

	addrSpawnObject =
		(int (__fastcall *)(int,int,SpawnObjectParams*))
				Hooks::scanPattern("SpawnObject","\x6A\xFF\x68\x00\x00\x00\x00\x64\xA1\x00\x00\x00\x00\x50\x64\x89\x25\x00\x00\x00\x00\x81\xEC\x00\x00\x00\x00\x53\x55\x8B\xAC\x24\x00\x00\x00\x00\x56\x8B\xF1\x57\x33\xC9\x56\x8D\x51\x19\xE8\x00\x00\x00\x00\x89\x44\x24\x18\x33\xC0\x6A\x2C\x33\xDB", "???????xx????xxxx????xx????xxxxx????xxxxxxxxxxx????xxxxxxxxxx", 0x561CF0);

	CTaskAddVTHooks(CTaskTurnGame, addrCTaskTurnGameVTable)

	_ScanLazy(AllowWormDamage, "8b068b50??5355");
	_HookDefault(AllowWormDamage);
	
	_ScanLazy(AllowWormDeath, "81ecc0070000");
	_HookDefault(AllowWormDeath);
	
	_ScanLazy(CanTurnEnd, "8b48??8b51??80ba????????00");
	_HookDefault(CanTurnEnd);
	
	_ScanLazy(CreateSmoke, "558bec83e4f86aff68????????64a1????????50648925????????81ec50080000");
	_HookDefault(CreateSmoke);
	/*
	_ScanLazy(UpdateDamageDisplay, "83b9????????00535657");
	_HookDefault(UpdateDamageDisplay);
	
	_ScanLazy(WormSound, "518b97????????85d253");
	_HookDefault(WormSound);
	*/
	_ScanLazy(EmitSpeech, "8b86????????85c05357");
	_HookDefault(EmitSpeech);

	auto * lua = Lua::getInstance().getState();

	sol::usertype <SpawnObjectParams> ux = lua->new_usertype<SpawnObjectParams>("SpawnObjectParams");
	lua->set_function("spawnObject", &spawnObject);
	lua->set_function("displayTransmissionText", &spawnTextObject);
	ux["type"] =  &SpawnObjectParams::type;
	ux["posX"] =  &SpawnObjectParams::posX;
	ux["posY"] = &SpawnObjectParams::posY;
	ux["unkC"] = &SpawnObjectParams::unkC;
	ux["unk10"] = &SpawnObjectParams::unk10;
	ux["unk14"] = &SpawnObjectParams::unk14;
	ux["unk18"] = &SpawnObjectParams::unk18;
	ux["unk1C"] = &SpawnObjectParams::unk1C;
	ux["unk20"] = &SpawnObjectParams::unk20;
	ux["unk24"] = &SpawnObjectParams::unk24;

	sol::usertype <CTaskTurnGame> ut = lua->new_usertype <CTaskTurnGame> ("CTaskTurnGame", sol::base_classes, sol::bases<CTask>());
	CTaskAddLuaVTHooks(CTaskTurnGame)



	_ScanLazy(FocusCamera, "8b4424??568b70");
	_HookDefault(FocusCamera);

	_ScanLazy(SetCameraTrackTarget, "8b4424??8b40??83b8????????00");
	_HookDefault(SetCameraTrackTarget);

	lua->set_function("focusCamera", &callFocusCamera);
	lua->set_function("setCameraTracker", &callSetCameraTrackTarget);
	lua->set_function("createSmoke", &callCreateSmoke);


		lua->set_function("triggerArmageddon", &triggerArmageddon);
		lua->set_function("triggerQuake", &triggerQuake);
		lua->set_function("getObjects", &getObjects);
		lua->set_function("getNumObjects", &getNumObjects);
		lua->set_function("getObject", &getObject);
		lua->set_function("getWorm", &getWorm);
		lua->set_function("getWind", &getWind);
		lua->set_function("setWind", &setWind);

		lua->set_function("CTaskTurnGame_SendMessage", &calltriggerTaskMessage);

		lua->set_function("allowWormDamage", &callAllowWormDamage);
		lua->set_function("canTurnEnd", &callCanTurnEnd);
		lua->set_function("allowWormDeath", &hookAllowWormDeath);
		//lua->set_function("updateDamageDisplay", &callUpdateDamageDisplay);
		//lua->set_function("setGravity", &setGravity); //does work but you have to do it eah frame which makes it sort of useless, lol

	//ut["wind"] = (DWORD*)(collisionmanager + 0x230); //this is a fucking lie, its not part of turngame, but it fits here so whatever
	ut["unknown30"] = &CTaskTurnGame::unknown30;
	ut["unknown34"] = &CTaskTurnGame::unknown34;
	ut["unknown38"] = &CTaskTurnGame::unknown38;
	ut["unknown3C"] = &CTaskTurnGame::unknown3C;
	ut["unknown40"] = &CTaskTurnGame::unknown40;
	ut["unknown44"] = &CTaskTurnGame::unknown44;
	ut["unknown48"] = &CTaskTurnGame::unknown48;
	ut["unknown4C"] = &CTaskTurnGame::unknown4C;
	ut["unknown50"] = &CTaskTurnGame::unknown50;
	ut["unknown54"] = &CTaskTurnGame::unknown54;
	ut["unknown58"] = &CTaskTurnGame::unknown58;
	ut["unknown5C"] = &CTaskTurnGame::unknown5C;
	ut["unknown60"] = &CTaskTurnGame::unknown60;
	ut["unknown64"] = &CTaskTurnGame::unknown64;
	ut["unknown68"] = &CTaskTurnGame::unknown68;
	ut["unknown6C"] = &CTaskTurnGame::unknown6C;
	ut["unknown70"] = &CTaskTurnGame::unknown70;
	ut["readyforadvance"] = &CTaskTurnGame::unknown74; //28
	ut["unknown78"] = &CTaskTurnGame::unknown78;
	ut["unknown7C"] = &CTaskTurnGame::unknown7C;
	ut["numberofteams"] = &CTaskTurnGame::unknown7C;
	ut["unknown80"] = &CTaskTurnGame::unknown80;
	ut["unknown84"] = &CTaskTurnGame::unknown84;
	ut["unknown88"] = &CTaskTurnGame::unknown88;
	ut["unknown8C"] = &CTaskTurnGame::unknown8C;
	ut["unknown90"] = &CTaskTurnGame::unknown90;
	ut["unknown94"] = &CTaskTurnGame::unknown94;
	ut["unknown98"] = &CTaskTurnGame::unknown98;
	ut["unknown9C"] = &CTaskTurnGame::unknown9C;
	ut["unknownA0"] = &CTaskTurnGame::unknownA0;
	ut["unknownA4"] = &CTaskTurnGame::unknownA4;
	ut["unknownA8"] = &CTaskTurnGame::unknownA8;
	ut["unknownAC"] = &CTaskTurnGame::unknownAC;
	ut["unknownB0"] = &CTaskTurnGame::unknownB0;
	ut["unknownB4"] = &CTaskTurnGame::unknownB4;
	ut["unknownB8"] = &CTaskTurnGame::unknownB8;
	ut["unknownBC"] = &CTaskTurnGame::unknownBC;
	ut["unknownC0"] = &CTaskTurnGame::unknownC0;
	ut["unknownC4"] = &CTaskTurnGame::unknownC4;
	ut["unknownC8"] = &CTaskTurnGame::unknownC8;
	ut["unknownCC"] = &CTaskTurnGame::unknownCC;
	ut["unknownD0"] = &CTaskTurnGame::unknownD0;
	ut["unknownD4"] = &CTaskTurnGame::unknownD4;
	ut["unknownD8"] = &CTaskTurnGame::unknownD8;
	ut["unknownDC"] = &CTaskTurnGame::unknownDC;
	ut["unknownE0"] = &CTaskTurnGame::unknownE0;
	ut["unknownE4"] = &CTaskTurnGame::unknownE4;
	ut["unknownE8"] = &CTaskTurnGame::unknownE8;
	ut["unknownEC"] = &CTaskTurnGame::unknownEC;
	ut["unknownF0"] = &CTaskTurnGame::unknownF0;
	ut["unknownF4"] = &CTaskTurnGame::unknownF4;
	ut["unknownF8"] = &CTaskTurnGame::unknownF8;
	ut["unknownFC"] = &CTaskTurnGame::unknownFC;
	ut["unknown100"] = &CTaskTurnGame::unknown100;
	ut["unknown104"] = &CTaskTurnGame::unknown104;
	ut["unknown108"] = &CTaskTurnGame::unknown108;
	ut["unknown10C"] = &CTaskTurnGame::unknown10C;
	ut["unknown110"] = &CTaskTurnGame::unknown110;
	ut["unknown114"] = &CTaskTurnGame::unknown114;
	ut["unknown118"] = &CTaskTurnGame::unknown118;
	ut["unknown11C"] = &CTaskTurnGame::unknown11C;
	ut["unknown120"] = &CTaskTurnGame::unknown120;
	ut["unknown124"] = &CTaskTurnGame::unknown124;
	ut["unknown128"] = &CTaskTurnGame::unknown128;
	ut["currteamone"] = &CTaskTurnGame::unknown12C;
	ut["unknown12C"] = &CTaskTurnGame::unknown12C;
	ut["unknown130"] = &CTaskTurnGame::unknown130;
	ut["unknown134"] = &CTaskTurnGame::unknown134;
	ut["currteamtwo"] = &CTaskTurnGame::unknown134;
	ut["unknown138"] = &CTaskTurnGame::unknown138;
	ut["unknown13C"] = &CTaskTurnGame::unknown13C;
	ut["unknown140"] = &CTaskTurnGame::unknown140;
	ut["roundnotstarted"] = &CTaskTurnGame::unknown140;
	ut["unknown144"] = &CTaskTurnGame::unknown144;
	ut["unknown148"] = &CTaskTurnGame::unknown148;
	ut["unknown14C"] = &CTaskTurnGame::unknown14C;
	ut["unknown150"] = &CTaskTurnGame::unknown150;
	ut["turnpaused"] = &CTaskTurnGame::unknown150;
	ut["unknown154"] = &CTaskTurnGame::unknown154;
	ut["unknown158"] = &CTaskTurnGame::unknown158;
	ut["unknown15C"] = &CTaskTurnGame::unknown15C;
	ut["unknown160"] = &CTaskTurnGame::unknown160;
	ut["unknown164"] = &CTaskTurnGame::unknown164;
	ut["unknown168"] = &CTaskTurnGame::unknown168;
	ut["unknown16C"] = &CTaskTurnGame::unknown16C;
	ut["unknown170"] = &CTaskTurnGame::unknown170;
	ut["unknown174"] = &CTaskTurnGame::unknown174;
	ut["unknown178"] = &CTaskTurnGame::unknown178;
	ut["retreattimer"] = &CTaskTurnGame::unknown178;
	ut["unknown17C"] = &CTaskTurnGame::unknown17C;
	ut["unknown180"] = &CTaskTurnGame::unknown180;
	ut["lastsecondstimer"] = &CTaskTurnGame::unknown180;
	ut["unknown184"] = &CTaskTurnGame::unknown184;
	ut["roundtimer"] = &CTaskTurnGame::unknown184;
	ut["unknown188"] = &CTaskTurnGame::unknown188;
	ut["turntimerone"] = &CTaskTurnGame::unknown188;
	ut["unknown18C"] = &CTaskTurnGame::unknown18C;
	ut["turntimertwo"] = &CTaskTurnGame::unknown18C;
	ut["unknown190"] = &CTaskTurnGame::unknown190;
	ut["unknown194"] = &CTaskTurnGame::unknown194;
	ut["unknown198"] = &CTaskTurnGame::unknown198;
	ut["unknown19C"] = &CTaskTurnGame::unknown19C;
	ut["unknown1A0"] = &CTaskTurnGame::unknown1A0;
	ut["unknown1A4"] = &CTaskTurnGame::unknown1A4;
	ut["unknown1A8"] = &CTaskTurnGame::unknown1A8;
	ut["unknown1AC"] = &CTaskTurnGame::unknown1AC;
	ut["unknown1B0"] = &CTaskTurnGame::unknown1B0;
	ut["unknown1B4"] = &CTaskTurnGame::unknown1B4;
	ut["unknown1B8"] = &CTaskTurnGame::unknown1B8;
	ut["unknown1BC"] = &CTaskTurnGame::unknown1BC;
	ut["unknown1C0"] = &CTaskTurnGame::unknown1C0;
	ut["unknown1C4"] = &CTaskTurnGame::unknown1C4;
	ut["unknown1C8"] = &CTaskTurnGame::unknown1C8;
	ut["unknown1CC"] = &CTaskTurnGame::unknown1CC;
	ut["unknown1D0"] = &CTaskTurnGame::unknown1D0;
	ut["unknown1D4"] = &CTaskTurnGame::unknown1D4;
	ut["unknown1D8"] = &CTaskTurnGame::unknown1D8;
	ut["unknown1DC"] = &CTaskTurnGame::unknown1DC;
	ut["unknown1E0"] = &CTaskTurnGame::unknown1E0;
	ut["unknown1E4"] = &CTaskTurnGame::unknown1E4;
	ut["unknown1E8"] = &CTaskTurnGame::unknown1E8;
	ut["unknown1EC"] = &CTaskTurnGame::unknown1EC;
	ut["unknown1F0"] = &CTaskTurnGame::unknown1F0;
	ut["unknown1F4"] = &CTaskTurnGame::unknown1F4;
	ut["unknown1F8"] = &CTaskTurnGame::unknown1F8;
	ut["unknown1FC"] = &CTaskTurnGame::unknown1FC;
	ut["unknown200"] = &CTaskTurnGame::unknown200;
	ut["unknown204"] = &CTaskTurnGame::unknown204;
	ut["unknown208"] = &CTaskTurnGame::unknown208;
	ut["unknown20C"] = &CTaskTurnGame::unknown20C;
	ut["unknown210"] = &CTaskTurnGame::unknown210;
	ut["unknown214"] = &CTaskTurnGame::unknown214;
	ut["unknown218"] = &CTaskTurnGame::unknown218;
	ut["unknown21C"] = &CTaskTurnGame::unknown21C;
	ut["unknown220"] = &CTaskTurnGame::unknown220;
	ut["unknown224"] = &CTaskTurnGame::unknown224;
	ut["unknown228"] = &CTaskTurnGame::unknown228;
	ut["unknown22C"] = &CTaskTurnGame::unknown22C;
	ut["unknown230"] = &CTaskTurnGame::unknown230;
	ut["unknown234"] = &CTaskTurnGame::unknown234;
	ut["unknown238"] = &CTaskTurnGame::unknown238;
	ut["unknown23C"] = &CTaskTurnGame::unknown23C;
	ut["unknown240"] = &CTaskTurnGame::unknown240;
	ut["unknown244"] = &CTaskTurnGame::unknown244;
	ut["unknown248"] = &CTaskTurnGame::unknown248;
	ut["unknown24C"] = &CTaskTurnGame::unknown24C;
	ut["unknown250"] = &CTaskTurnGame::unknown250;
	ut["unknown254"] = &CTaskTurnGame::unknown254;
	ut["unknown258"] = &CTaskTurnGame::unknown258;
	ut["unknown25C"] = &CTaskTurnGame::unknown25C;
	ut["unknown260"] = &CTaskTurnGame::unknown260;
	ut["unknown264"] = &CTaskTurnGame::unknown264;
	ut["unknown268"] = &CTaskTurnGame::unknown268;
	ut["unknown26C"] = &CTaskTurnGame::unknown26C;
	ut["unknown270"] = &CTaskTurnGame::unknown270;
	ut["unknown274"] = &CTaskTurnGame::unknown274;
	ut["unknown278"] = &CTaskTurnGame::unknown278;
	ut["unknown27C"] = &CTaskTurnGame::unknown27C;
	ut["unknown280"] = &CTaskTurnGame::unknown280;
	ut["unknown284"] = &CTaskTurnGame::unknown284;
	ut["unknown288"] = &CTaskTurnGame::unknown288;
	ut["unknown28C"] = &CTaskTurnGame::unknown28C;
	ut["unknown290"] = &CTaskTurnGame::unknown290;
	ut["unknown294"] = &CTaskTurnGame::unknown294;
	ut["unknown298"] = &CTaskTurnGame::unknown298;
	ut["unknown29C"] = &CTaskTurnGame::unknown29C;
	ut["unknown2A0"] = &CTaskTurnGame::unknown2A0;
	ut["unknown2A4"] = &CTaskTurnGame::unknown2A4;
	ut["unknown2A8"] = &CTaskTurnGame::unknown2A8;
	ut["unknown2AC"] = &CTaskTurnGame::unknown2AC;
	ut["unknown2B0"] = &CTaskTurnGame::unknown2B0;
	ut["unknown2B4"] = &CTaskTurnGame::unknown2B4;
	ut["unknown2B8"] = &CTaskTurnGame::unknown2B8;
	ut["unknown2BC"] = &CTaskTurnGame::unknown2BC;
	ut["unknown2C0"] = &CTaskTurnGame::unknown2C0;
	ut["unknown2C4"] = &CTaskTurnGame::unknown2C4;
	ut["unknown2C8"] = &CTaskTurnGame::unknown2C8;
	ut["unknown2CC"] = &CTaskTurnGame::unknown2CC;
	ut["unknown2D0"] = &CTaskTurnGame::unknown2D0;
	ut["framespassed"] = &CTaskTurnGame::unknown2D4;
	ut["unknown2D4"] = &CTaskTurnGame::unknown2D4;
	ut["unknown2D8"] = &CTaskTurnGame::unknown2D8;
	ut["unknown2DC"] = &CTaskTurnGame::unknown2DC;


	return 0;
}

void CTaskTurnGame::registerBuiltinCallbackVt8(std::function<int(CTaskTurnGame*, CTask *, Constants::TaskMessage, size_t, void *)> cb) {
	CTask::CTask_vtableHooks<CTaskTurnGame>::registerBuiltinCallbackVt8(std::move(cb));
}
