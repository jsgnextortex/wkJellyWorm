#include <Windows.h>
#include <sigscanner.h>
#include "DevConsole.h"
#include "entities/tasks/CTaskFire.h"
#include "entities/tasks/CTaskFlame.h"
#include "entities/tasks/CTaskFilter.h"
#include "entities/tasks/CTaskAirStrike.h"
#include "entities/tasks/CTaskSpriteAnimation.h"
#include "entities/tasks/CTaskSmoke.h"
#include "entities/tasks/CTaskGass.h"
#include "entities/tasks/CTaskCPU.h"
#include "entities/tasks/CTaskCloud.h"
#include "entities/tasks/CTaskDirt.h"
#include "entities/tasks/CTaskFireBall.h"
#include "entities/tasks/CTaskScoreBubble.h"
#include "entities/tasks/CTaskSeaBubble.h"
#include "entities/gametasks/CTaskArrow.h"
#include "entities/gametasks/CTaskCanister.h"
#include "entities/gametasks/CTaskCrate.h"
#include "entities/gametasks/CTaskCross.h"
#include "entities/gametasks/CTaskLand.h"
#include "entities/gametasks/CTaskMine.h"
#include "entities/gametasks/CTaskMissile.h"
#include "entities/gametasks/CTaskOildrum.h"
#include "entities/gametasks/CTaskOldWorm.h"
#include "packages/PackageManager.h"

#include "WaLibc.h"
#include "Game.h"
#include "Lobby.h"
#include "Config.h"
#include "Chat.h"
#include "Landscape.h"
#include "Sounds.h"
#include "Sprites.h"
#include "Explosions.h"
#include "Weapons.h"
#include "renderer/Bitmap.h"
#include "renderer/Renderer.h"
#include "renderer/Drawing.h"

#include "CustomWeapons.h"
#include "Packets.h"
#include "Lua.h"
#include "Hooks.h"
#include <chrono>
#include <MinHook.h>
#include <regex>



std::string scriptname(const std::string& path) {
	size_t lastSlash = path.find_last_of("/\\");
	std::string filename = (lastSlash == std::string::npos) ? path : path.substr(lastSlash + 1);
	std::regex bracketPattern(R"(\[([^\]]+)\])");
	std::smatch match;

	if (std::regex_search(filename, match, bracketPattern)) {
		return match[1]; 
	}
	return "";
}

static inline int(__stdcall* origSetBuiltinScheme)(DWORD a1, int schemeid);
int __stdcall hookSetBuiltinScheme(DWORD schemestruct, int id) {
	return origSetBuiltinScheme(schemestruct, id);
}

static inline int(__stdcall* origSetWscScheme)(DWORD schemestruct, char* path, char flag, bool* out);
int __stdcall hookSetWscScheme(DWORD schemestruct, char* path, char flag, bool* out) {
	printf("hookSetWscScheme struct: 0x%X path: %s flag: %d out: 0x%X\n", schemestruct, path, flag, out);
	std::string script = scriptname(path);
	if ((script.length() <= 0) && (schememodule != "default")) {
		schememodule = "default";
		script = schememodule;
	}
	if (script.length() > 0) {
		schememodule = script;
		Config::resetConfig();
		PackageManager::getInstance().enablePackage(script, "latest", true);
		PackageManager::getInstance().checkDependenciesAdd();
	}
	return origSetWscScheme(schemestruct, path, flag, out);
}

int install() {
	if(Config::devConsoleEnabled) DevConsole::install();
	SignatureScanner SigScanner;
	module mod = {0, 0};
	if (MH_Initialize() != MH_OK)
		throw std::runtime_error("Failed to initialize Minhook");

	WaLibc::install(SigScanner, mod);
	CTask::install(SigScanner, mod);
	CGameTask::install(SigScanner, mod);

	CTaskTurnGame::install(SigScanner, mod);
	CTaskTeam::install(SigScanner, mod);
	CTaskFire::install(SigScanner, mod);
	CTaskFlame::install(SigScanner, mod);
	CTaskFilter::install(SigScanner, mod);
	CTaskAirStrike::install(SigScanner, mod);
	CTaskSpriteAnimation::install(SigScanner, mod);
	CTaskSmoke::install(SigScanner, mod);
	CTaskGass::install(SigScanner, mod);
	CTaskCPU::install(SigScanner, mod);
	CTaskCloud::install(SigScanner, mod);
	CTaskDirt::install(SigScanner, mod);
	CTaskFireBall::install(SigScanner, mod);
	CTaskScoreBubble::install(SigScanner, mod);
	CTaskSeaBubble::install(SigScanner, mod);

	CTaskArrow::install(SigScanner, mod);
	CTaskCanister::install(SigScanner, mod);
	CTaskCrate::install(SigScanner, mod);
	CTaskCross::install(SigScanner, mod);
	CTaskLand::install(SigScanner, mod);
	CTaskMine::install(SigScanner, mod);
	CTaskMissile::install(SigScanner, mod);
	CTaskOildrum::install(SigScanner, mod);
	CTaskOldWorm::install(SigScanner, mod);
	CTaskWorm::install(SigScanner, mod);

	Game::install(SigScanner, mod);
	Lobby::install(SigScanner, mod);
	Config::install(SigScanner, mod);
	Chat::install(SigScanner, mod);
	Sounds::install(SigScanner, mod);
	Sprites::install(SigScanner, mod);
	Landscape::install(SigScanner, mod);
	Explosions::install(SigScanner, mod);
	Weapons::install(SigScanner, mod);
	CustomWeapons::install(SigScanner, mod);
	Packets::install(SigScanner, mod);
	Bitmap::install(SigScanner, mod);
	Renderer::install(SigScanner, mod);
	Drawing::install(SigScanner, mod);

	Lua::getInstance();

	PackageManager::getInstance().scanPackages();



	DWORD addrSetWscScheme = _ScanPattern("SetWscScheme", "\x6A\xFF\x68\x00\x00\x00\x00\x64\xA1\x00\x00\x00\x00\x50\x64\x89\x25\x00\x00\x00\x00\x81\xEC\x00\x00\x00\x00\x53\x55\x8B\xAC\x24\x00\x00\x00\x00\x56\x8B\xB4\x24\x00\x00\x00\x00\x57\x8D\x4C\x24\x20", "???????xx????xxxx????xx????xxxxx????xxxx????xxxxx");
	_HookDefault(SetWscScheme);
	//DWORD addrGetSchemeSettingsFromWam = _ScanPattern("GetSchemeSettingsFromWam", "\x57\x6A\x04\x68\x00\x00\x00\x00\x8B\xF8\xE8\x00\x00\x00\x00\x83\xF8\xFF\x75\x04\x0B\xC0\x5F\xC3\x8B\x47\x0C\x56\x8B\x35\x00\x00\x00\x00\x50\x6A\x00\x68\x00\x00\x00\x00\x68\x00\x00\x00\x00\xFF\xD6", "????????xxx????xxxxxxxxxxxxxxx????xxxx????x????xx");
	//DWORD addrSetBuiltinScheme = (addrGetSchemeSettingsFromWam + 0xF + *(DWORD*)(addrGetSchemeSettingsFromWam + 0xB));
	//_HookDefault(SetBuiltinScheme);

	return 0;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
	switch(ul_reason_for_call) {
		case DLL_PROCESS_ATTACH:
		{
			auto start = std::chrono::high_resolution_clock::now();
			decltype(start) finish;
			try {
				Config::readPrivateProfile();
				if (!Config::moduleEnabled) return TRUE;
				Config::createJellyDirs();
				if(Config::useOffsetCache) Hooks::loadOffsets(Config::offsetsFile);
				install();
				finish = std::chrono::high_resolution_clock::now();
				Hooks::saveOffsets(Config::offsetsFile);
			} catch (std::exception &e) {
				finish = std::chrono::high_resolution_clock::now();
				MessageBoxA(0, e.what(), "wkJellyWorm - initialization failed", MB_ICONERROR);
			}
			std::chrono::duration<double> elapsed = finish - start;
			printf("wkJellyWorm startup took %lf seconds\n", elapsed.count());
		}
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
		default:
			break;
	}
	return TRUE;
}
