#ifndef WKJELLYWORM_CUSTOMWEAPONS_H
#define WKJELLYWORM_CUSTOMWEAPONS_H

#include <sigscanner.h>
#include <array>
#include <map>
#include <vector>
#include "entities/tasks/CTaskTeam.h"
#include "Constants.h"
#include "entities/Entities.h"
#include "Lua.h"
#include "sol/sol.hpp"


#if !defined(ENUMS)
#define ENUMS 1

enum ActivationType
{
	NoneActType,
	Crosshair,
	Throw,
	Airstrike,
	Spacebar
};

enum Action
{
	Action_None,
	Action_Home,
	Action_Bounce,
	Action_Roam,
	Action_Dig
};

enum ExplosionTarget
{
	Target_None,
	Target_Clusters,
	Target_Fire
};

enum AirstrikeAction
{
	Airstrike_None,
	Airstrike_Mines,
	Airstrike_Worms,
	Airstrike_Launcher
};

enum SpaceWeap
{
	Space_None,
	Space_Firepunch,
	Space_Baseballbat,
	Space_Dragonball,
	Space_Kamikaze,
	Space_Suicidebomber,
	Space_Ninjarope,
	Space_Bungee,
	Space_Pneumaticdrill,
	Space_Prod,
	Space_Teleport,
	Space_Blowtorch,
	Space_Parachute,
	Space_Surrender,
	Space_Skipgo,
	Space_Selectworm,
	Space_Nucleartest,
	Space_Girder,
	Space_Battleaxe,
	Space_Utility,
	Space_Freeze,
	Space_Earthquake,
	Space_Scalesofjustice,
	Space_Jetpack,
	Space_Armageddon,
};

enum CrosshairType
{
	Crosshair_None,
	Crosshair_Flamethrower,
	Crosshair_Gun,
	Crosshair_Launcher,
	Crosshair_Bow
};

enum ThrowType
{
	Throw_None,
	Throw_Mine,
	Throw_Launcher,
	Throw_Canister
};

#endif

class CustomWeapons {
public:
	inline static int customWeaponsEnabled = 0;
	static const int maxCustomWeapons = 256;
	static const int maxStandardWeapons = 71;
	static inline int numAllWeapons = maxStandardWeapons;
	static const int standardNumColumns = 5;
	static const int customNumColumns = 40;
	static const int numTeams = 6;

	struct WeaponStruct {
		char* name1; // 0x0
		char* name2; // 0x4
		int panelRow; // 0x8
		int remembered; // 0xC
		int usableincavern; // 0x10
		int numberofshots; // 0x14
		int endsturn; // 0x18
		int retreattime; // 0x1C
		int unknown20; // 0x20
		int cratechance; // 0x24
		int crateammo; // 0x28
		int customdata; // 0x2C
		int activationtype; // 0x30
		int activationparam; // 0x34
		int Param1; // 0x38
		int Param2; // 0x3C
		int Param3; // 0x40
		int Param4; // 0x44
		int Param5; // 0x48
		int Param6; // 0x4C
		int Param7; // 0x50
		int unknown54; // 0x54
		int unknown58; // 0x58
		int unknown5C; // 0x5C
		int unknown60; // 0x60
		int unknown64; // 0x64
		int unknown68; // 0x68
		int unknown6C; // 0x6C
		int unknown70; // 0x70
		int unknown74; // 0x74
		int unknown78; // 0x78
		int unknown7C; // 0x7C
		int unknown80; // 0x80
		int unknown84; // 0x84
		int unknown88; // 0x88
		int unknown8C; // 0x8C
		int unknown90; // 0x90
		int unknown94; // 0x94
		int unknown98; // 0x98
		int unknown9C; // 0x9C
		int unknownA0; // 0xA0
		int unknownA4; // 0xA4
		int unknownA8; // 0xA8
		int unknownAC; // 0xAC
		int unknownB0; // 0xB0
		int unknownB4; // 0xB4
		int unknownB8; // 0xB8
		int unknownBC; // 0xBC
		int unknownC0; // 0xC0
		int unknownC4; // 0xC4
		int unknownC8; // 0xC8
		int unknownCC; // 0xCC
		int unknownD0; // 0xD0
		int unknownD4; // 0xD4
		int unknownD8; // 0xD8
		int unknownDC; // 0xDC
		int unknownE0; // 0xE0
		int unknownE4; // 0xE4
		int unknownE8; // 0xE8
		int unknownEC; // 0xEC
		int unknownF0; // 0xF0
		int unknownF4; // 0xF4
		int unknownF8; // 0xF8
		int unknownFC; // 0xFC
		int unknown100; // 0x100
		int unknown104; // 0x104
		int unknown108; // 0x108
		int unknown10C; // 0x10C
		int unknown110; // 0x110
		int unknown114; // 0x114
		int unknown118; // 0x118
		int unknown11C; // 0x11C
		int unknown120; // 0x120
		int unknown124; // 0x124
		int unknown128; // 0x128
		int unknown12C; // 0x12C
		int unknown130; // 0x130
		int unknown134; // 0x134
		int unknown138; // 0x138
		int unknown13C; // 0x13C
		int unknown140; // 0x140
		int unknown144; // 0x144
		int unknown148; // 0x148
		int unknown14C; // 0x14C
		int unknown150; // 0x150
		int unknown154; // 0x154
		int unknown158; // 0x158
		int unknown15C; // 0x15C
		int unknown160; // 0x160
		int unknown164; // 0x164
		int unknown168; // 0x168
		int unknown16C; // 0x16C
		int unknown170; // 0x170
		int unknown174; // 0x174
		int unknown178; // 0x178
		int unknown17C; // 0x17C
		int unknown180; // 0x180
		int unknown184; // 0x184
		int unknown188; // 0x188
		int unknown18C; // 0x18C
		int unknown190; // 0x190
		int unknown194; // 0x194
		int unknown198; // 0x198
		int unknown19C; // 0x19C
		int unknown1A0; // 0x1A0
		int unknown1A4; // 0x1A4
		int unknown1A8; // 0x1A8
		int unknown1AC; // 0x1AC
		int unknown1B0; // 0x1B0
		int unknown1B4; // 0x1B4
		int unknown1B8; // 0x1B8
		int unknown1BC; // 0x1BC
		int unknown1C0; // 0x1C0
		int unknown1C4; // 0x1C4
		int unknown1C8; // 0x1C8
		int unknown1CC; // 0x1CC
	};


	struct Explosion {
		int collisionflags;
		int bias;
		int push;
		int damage;
		int damagevariation;

	};

	struct DragonBall {
		int Sound; // 0x38
		int ImpactSound; // 0x3C
		int Sprite; // 0x40
		int Damage; // 0x44
		int Angle; // 0x48
		int Force; // 0x4C
		int FlyingTime; // 0x50
	};

	struct Kamikaze {
		int FlyingTime; // 0x38
		int ExplosionDamage; // 0x3C
		int FireSound; // 0x40
		int Damage; // 0x44
		int ImpactForce; // 0x48
		int ImpactAngle; // 0x4C
	};

	struct FirePunch {
		int Damage; // 0x38
		int Angle; // 0x3C
		int Push; // 0x40
		int Height; // 0x44
	};

	struct Drill {
		int Damage; // 0x38
		int PushPower; // 0x3C
		int ImpactAngle; // 0x40
		int Duration; // 0x44
	};

	struct Blowtorch {
		int Damage; // 0x38
		int PushPower; // 0x3C
		int ImpactAngle; // 0x40
		int Duration; // 0x44
	};
	
	struct Prod {
		int Damage; // 0x38
		int PushPower; // 0x3C
		int Angle; // 0x40
	};
	
	struct NinjaRope {
		int Shots; // 0x38
		int Length; // 0x3C
		int AngleRestriction; // 0x40
	};
	
	struct Bat {
		int Damage; // 0x38
		int PushPower; // 0x3C
	};
	
	struct Suicide {
		int Poison; // 0x38
		int Damage; // 0x3C
	};
	
	struct NuclearTest {
		int WaterRise; // 0x38
		int Poison; // 0x3C
	};
	
	struct JetPack {
		int Fuel; // 0x38
	};
	
	struct BattleAxe {
		int Percentage; // 0x38
	};
	
	struct Parachute {
		int WindFactor; // 0x38
	};




	struct Sprite {
		int spriteid;
		int animationtype;
		int trailsprite;
		int trailamount;
		int trailvanishspeed;
		int unknown;

	};

	struct Sound {
		short soundid;
		bool loop;
		int isexplosion;
		int beforeexplosion;
		int delay;
	};

	struct Mine {
		int Radius; // 0x3C
		int Delay; // 0x40
		int DetectionFlags; // 0x44
		int FuseTime; // 0x48
		int ExplosionBias; // 0x4C
		int Power; // 0x4C
		int Damage; // 0x4C
	};

	struct Airstrike {
		int PlaneSprite; // 0x3C
		int BombsCount; // 0x3C
		int DropsSpacing; // 0x3C
		int PlaneSpeed; // 0x3C
		int Sound; // 0x3C
		int Action; // 0x3C
		int ActionData; // 0x3C
	};

	struct Canister {
		int SpriteInactive; // 0x3C
		int SpriteActive; // 0x40
		int PoisonAmount; // 0x44
		int Damage; // 0x48
	};

	struct Gun {
		int bulletcount; // 0x3C
		int reloadtime; // 0x40
		int bulletspread; // 0x44
		int brust; // 0x48
		int brustspread; // 0x4C
		Explosion explosion; // 0x50
		int expeffect; // 0x64
		int range1; // 0x68
		int range2; // 0x6C
		int range3; // 0x70
	};

	struct Flamethrower {
		int fuel; // 0x3C
		int fireintensity; // 0x40
		int fireamount; // 0x44
		int burntime; // 0x48
		int persistent; // 0x4C
	};




	struct ExplosionAction {
		int unknownA8; // 0xA8
		int unknownAC; // 0xAC
		int unknownB0; // 0xB0
		int unknownB4; // 0xB4
		int unknownB8; // 0xB8
		int unknownBC; // 0xBC
		int unknownC0; // 0xC0
		int unknownC4; // 0xC4
		int unknownC8; // 0xC8
		int unknownCC; // 0xCC
		int unknownD0; // 0xD0
		int unknownD4; // 0xD4
		int unknownD8; // 0xD8
		int unknownDC; // 0xDC
		int unknownE0; // 0xE0
		int unknownE4; // 0xE4
		int unknownE8; // 0xE8
		int unknownEC; // 0xEC
	};

	struct FireExplosion {
		int power; // 0x3C
		int spread; // 0x40
		int duration; // 0x44
		int persist; // 0x48
	};

	struct ClusterExplosion {
		int amount; // 0x3C
		int dispersion; // 0x40
		int speed; // 0x44
		int EjectionAngle; // 0x48
		int DispersionAngle; // 0x48
		Explosion explosion; // 0x48
		int Unknown; // 0x48
		Sprite Animation; // 0x48 //6
		int Acceleration; // 0x48
		int WindFactor; // 0x48
		int Randomness; // 0x48
		int Gravity; // 0x48
		int Unused; // 0x48
		int Unused2; // 0x48
		Sound Sound; // 0x48 //4
		int Spacebar; // 0x48
		int Action; // 0x48
		ExplosionAction ExplosionAction; // 0x48 //18
	};

	struct BounceAction {
		int BounceFlags; // 0xA8
		int Bounciness; // 0xAC
		int Acceleration; // 0xB0
		int Sound; // 0xB4
		int Unk1; // 0xB8
		int Unk2; // 0xBC
		int Explosionbias; // 0xC0
		int Power; // 0xC4
		int Damage; // 0xC8
		int RandomDamage; // 0xCC
		int NumberOfBounces; // 0xD0
		int unknownD4; // 0xD4
		int unknownD8; // 0xD8
		int unknownDC; // 0xDC
		int unknownE0; // 0xE0
		int unknownE4; // 0xE4
		int unknownE8; // 0xE8
		int unknownEC; // 0xEC
	};

	struct RoamAction {
		int RoamFlags; // 0xA8
		int ExplodeFlags; // 0xAC
		int WalkSpeed; // 0xB0
		int Unknown; // 0xB4
		int JumpEdgeAngle; // 0xB8
		int JumpEdgeVelocity; // 0xBC
		int JumpEdgeSound; // 0xC0
		int JumpAngle; // 0xC4
		int JumpVelocity; // 0xC8
		int JumpSound; // 0xCC
		int TerrainOffset; // 0xD0
		int Fart; // 0xD4
		int PoisonPower; // 0xD8
		int FartSprite; // 0xDC
		int FlySprite; // 0xE0
		int FlySprite2; // 0xE4
		int TakingOffSprite; // 0xE8
		int FlyingSprite; // 0xEC
	};

	struct HomingAction {
		int Unused; // 0xA8
		Sprite Sprite; // 0xAC
		int type; // 0xB0
		int delay; // 0xB4
		int duration; // 0xB8
		int unknownD4; // 0xD4
		int unknownD8; // 0xD8
		int unknownDC; // 0xDC
		int unknownE0; // 0xE0
		int unknownE4; // 0xE4
		int unknownE8; // 0xE8
		int unknownEC; // 0xEC
	};

	struct DigAction {
		int Unk1; // 0xA8
		int Unk2; // 0xAC
		int Sound; // 0xB0
		int JumpingSprite; // 0xB4
		int Sprite1; // 0xB8
		int Sprite2; // 0xBC
		int Sprite3; // 0xC0
		int unknownC4; // 0xC4
		int unknownC8; // 0xC8
		int unknownCC; // 0xCC
		int unknownD0; // 0xD0
		int unknownD4; // 0xD4
		int unknownD8; // 0xD8
		int unknownDC; // 0xDC
		int unknownE0; // 0xE0
		int unknownE4; // 0xE4
		int unknownE8; // 0xE8
		int unknownEC; // 0xEC
	};


	struct Launcher {
		int spritesize; // 0x3C
		int fixedspeed; // 0x40
		int makesscream; // 0x44
		Explosion explosion; // 0x48
		int unknown5C; // 0x5C
		Sprite sprite; // 0x60 //6
		int variablespeed; // 0x78
		int windfactor; // 0x7C
		int motionrandomness; // 0x80
		int gravityfactor; // 0x84
		int explotioncountdown; // 0x88
		int explosiontimer; // 0x8C
		Sound sound; // 0x90 //4
		int spacetriggered; // 0xA0
		int explosionactiontype; // 0xA4
		ExplosionAction explosionaction; //18
		int explosiontarget; // 0xF0
		int unused; // 0xF0
		ClusterExplosion explosiontargetdata; // 0xF0 //47
	};

	static Launcher* GetLauncherData(WeaponStruct* weap) {
		//if ((weap.activationtype == ActivationType::Crosshair) && (weap.Param1 == CrosshairType::Launcher) ) {
		return (Launcher*)&weap->Param2;
		//}
		//{
			//return new CustomWeapons::Launcher();
		//}
	}

	static Gun* GetGunData(WeaponStruct weap) {
		//if ((weap.activationtype == ActivationType::Crosshair) && (weap.Param1 == CrosshairType::Gun)) {
		return (Gun*)&weap.Param2;
		//}
		//{
			//return new CustomWeapons::Gun();
		//}
	}

	static Flamethrower* GetFlamethrowerData(CustomWeapons::WeaponStruct weap) {
		//if ((weap.activationtype == ActivationType::Crosshair) && (weap.Param1 == CrosshairType::Flamethrower)) {
		return (Flamethrower*)&weap.Param2;
		//}
		//{
			//return new CustomWeapons::Flamethrower();
		//}
	}

	static sol::object GetActionDataAS(Airstrike* weap) {
		auto* lua = Lua::getInstance().getState()->lua_state();
			switch (weap->Action) {
			case AirstrikeAction::Airstrike_Mines:
				return sol::make_object(lua, (Mine*)(&weap->ActionData));
			case AirstrikeAction::Airstrike_Launcher:
				return sol::make_object(lua, (Launcher*)(&weap->ActionData));
			default:
				return sol::make_object(lua, nullptr); // or sol::nil if needed
			}
	}


	static sol::object GetActionData(ClusterExplosion* weap) {
		auto* lua = Lua::getInstance().getState()->lua_state();
		switch (weap->Action) {
		case Action::Action_Roam:
			return sol::make_object(lua, (RoamAction*)(&weap->ExplosionAction));
		case Action::Action_Bounce:
			return sol::make_object(lua, (BounceAction*)(&weap->ExplosionAction));
		case Action::Action_Dig:
			return sol::make_object(lua, (DigAction*)(&weap->ExplosionAction));
		case Action::Action_Home:
			return sol::make_object(lua, (HomingAction*)(&weap->ExplosionAction));
		default:
			return sol::make_object(lua, nullptr); // or sol::nil if needed
		}
	}

	static sol::object GetActionDataL(Launcher* weap) {
		auto* lua = Lua::getInstance().getState()->lua_state();
		switch (weap->explosionactiontype) {
		case Action::Action_Roam:
			return sol::make_object(lua, (RoamAction*)(&weap->explosionaction));
		case Action::Action_Bounce:
			return sol::make_object(lua, (BounceAction*)(&weap->explosionaction));
		case Action::Action_Dig:
			return sol::make_object(lua, (DigAction*)(&weap->explosionaction));
		case Action::Action_Home:
			return sol::make_object(lua, (HomingAction*)(&weap->explosionaction));
		default:
			return sol::make_object(lua, nullptr); // or sol::nil if needed
		}
	}

	static sol::object GetExplosionTargetL(Launcher* weap) {
		auto* lua = Lua::getInstance().getState()->lua_state();
		printf("TARGET: %d", weap->explosiontarget);
		switch (weap->explosiontarget) {
		case ExplosionTarget::Target_Clusters:
			return sol::make_object(lua, (ClusterExplosion*)(&weap->explosiontargetdata));
		case ExplosionTarget::Target_Fire:
			return sol::make_object(lua, (FireExplosion*)(&weap->explosiontargetdata));
		default:
			return sol::make_object(lua, nullptr); // or sol::nil if needed
		}
	}

	

	static sol::object GetExtraData(WeaponStruct* weap) {
		auto* lua = Lua::getInstance().getState()->lua_state();
		
		if (weap->activationtype == ActivationType::Throw) {
			switch (weap->Param1) {
			case ThrowType::Throw_Mine:
				return sol::make_object(lua, (Mine*)(&weap->Param2));
			case ThrowType::Throw_Launcher:
				return sol::make_object(lua, (Launcher*) (&weap->Param2));
			case ThrowType::Throw_Canister:
				return sol::make_object(lua, (Canister*) (&weap->Param2));
			default:
				return sol::make_object(lua, nullptr); // or sol::nil if needed
			}
		}
		else if (weap->activationtype == ActivationType::Crosshair) {
			switch (weap->Param1) {
			case CrosshairType::Crosshair_Flamethrower:
				return sol::make_object(lua, (Flamethrower*)(&weap->Param2));
			case CrosshairType::Crosshair_Launcher:
				return sol::make_object(lua, (Launcher*)(&weap->Param2));
			case CrosshairType::Crosshair_Gun:
				return sol::make_object(lua, (Gun*)(&weap->Param2));
			default:
				return sol::make_object(lua, nullptr); // or sol::nil if needed
			}
		}
		else if (weap->activationtype == ActivationType::Airstrike) {
			return sol::make_object(lua, (Airstrike*)(&weap->Param1));
		}
		else if (weap->activationtype == ActivationType::Spacebar) {
			switch (weap->activationparam) {
			case SpaceWeap::Space_Firepunch:
				return sol::make_object(lua, (FirePunch*)(&weap->Param1));
			case SpaceWeap::Space_Baseballbat:
				return sol::make_object(lua, (Bat*)(&weap->Param1));
			case SpaceWeap::Space_Dragonball:
				return sol::make_object(lua, (DragonBall*)(&weap->Param1));
			case SpaceWeap::Space_Kamikaze:
				return sol::make_object(lua, (Kamikaze*)(&weap->Param1));
			case SpaceWeap::Space_Suicidebomber:
				return sol::make_object(lua, (Suicide*)(&weap->Param1));
			case SpaceWeap::Space_Ninjarope:
				return sol::make_object(lua, (NinjaRope*)(&weap->Param1));
			case SpaceWeap::Space_Pneumaticdrill:
				return sol::make_object(lua, (Drill*)(&weap->Param1));
			case SpaceWeap::Space_Prod:
				return sol::make_object(lua, (Prod*)(&weap->Param1));
			case SpaceWeap::Space_Blowtorch:
				return sol::make_object(lua, (Blowtorch*)(&weap->Param1));
			case SpaceWeap::Space_Parachute:
				return sol::make_object(lua, (Parachute*)(&weap->Param1));
			case SpaceWeap::Space_Nucleartest:
				return sol::make_object(lua, (NuclearTest*)(&weap->Param1));
			case SpaceWeap::Space_Battleaxe:
				return sol::make_object(lua, (BattleAxe*)(&weap->Param1));
			case SpaceWeap::Space_Jetpack:
				return sol::make_object(lua, (JetPack*)(&weap->Param1));
			case SpaceWeap::Space_Armageddon:
				return sol::make_object(lua, (Launcher*)(&weap->Param1));
			default:
				return sol::make_object(lua, nullptr); // or sol::nil if needed
			}
		}
		return sol::make_object(lua, nullptr); // or sol::nil if needed
	}

private:
	inline static int currentWeaponTable;

	static int __stdcall hookInitializeWeaponTable(DWORD addrDDGame);
	static int __stdcall hookWeaponPanelLoop(int team, int counter, int row, int weapon_panel_obj);
	static int __stdcall hookGetAmmo();

	inline static std::array<WeaponStruct, maxCustomWeapons> weaponTable;
	inline static std::array<DWORD, maxCustomWeapons> weaponPanelSlots;
	inline static std::array<std::array<int, maxCustomWeapons>, numTeams> ammoTable;
	inline static std::array<std::array<int, maxCustomWeapons>, numTeams> delayTable;

	inline static std::vector<WeaponStruct> weaponStructInjectionList;
	inline static std::vector<std::pair<std::string, DWORD>> weaponImgInjectionList;
	inline static std::vector<std::pair<std::string, std::string>> weaponNameStorage;

	inline static int variablePanelColumns = standardNumColumns;
	inline static int variablePanelWidthAdd = 144;

	static int __stdcall hookWeaponPanelDrawTile_GetSlotAddr(int weapon_panel_obj, int column, int row);
	static void __stdcall hookWeaponPanelCheckClick_patch1_c(int v5, int a1, int weapon_panel_obj, int a3, int column, int row);

//	static DWORD __stdcall hookLoadImgFromVfs(int x, int y, int a4);
//	static int __fastcall hookLoadWeaponPanelImgs(int This, int EDX, int x, int y);

	static DWORD __stdcall getImgPtr(int weapon_panel_obj, int weapon_id, int a4);
	static void hookWeaponPanelDrawTile_GetImgPtr_patch1();
	static void hookWeaponPanelDrawTile_GetImgPtr_patch2();
	static void hookWormSwitchingWeapon_GetImgPtr_patch1();
	static void hookWeaponPanel_incrementCounter_patch1();
	static void hookWeaponPanel_incrementCounter_patch2();
	static void hookWeaponPanelUnknown1_patch1();
	static void hookWeaponPanelDescription_getAmmoDelay_patch1();

	static void setCustomWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype, int value);
	static int getCustomWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype);
	static void setWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype, int value);
	static int getWeaponAmmoOrDelay(int team_id, int weapon_id, int tabletype);

//	static DWORD __stdcall getAmmoAddr_v1(int team_id, int weapon_id, int teaminfo_obj, int tabletype);
	static DWORD __stdcall getAmmoAddr_v2(int weapon_panel_obj, int weapon_id, int tabletypw);

	
	static DWORD *__stdcall hookSubtractAmmo(int weapon_id);
	static DWORD *__fastcall hookSubtractAmmo_v2(int a1, CTaskTeam *a2);
	static int hookGetAmmo_wrapped(int team_id, int weapon_id, DWORD teaminfo_obj);
	static DWORD __stdcall getWeaponDelayAddr(DWORD weapon_panel_obj, int weapon_id);
	static int __stdcall hookReduceDelayOnTurnStart();

	static void test(int team, int alliance, int weapon);
	static void test2(int team, int weapon);
public:
//	static int onConstructGlobalContext(int a1);
	static int install(SignatureScanner &, module);
//	static int onSendGamePacketWrapped(int a1, int x, Constants::TaskMessage y, void *data);
	static void printDebugAddrs();
//	static void switchWeaponTable();
	static void onDestroyGlobalContext();

	static void onConstructGlobalContext(int a1);

	static int registerCustomWeapon(WeaponStruct weaponStruct, std::string img, std::string name1, std::string name2);
	static WeaponStruct* getWeaponData(int weapid);
	static void resetConfig();
	static DWORD __stdcall hookAddAmmo(DWORD team_info_obj, int weapon_id);
};

#endif //WKJELLYWORM_CUSTOMWEAPONS_H
