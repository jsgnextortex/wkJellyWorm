#ifndef WKJELLYWORM_CTASKMINE_H
#define WKJELLYWORM_CTASKMINE_H


#include "../CGameTask.h"
#include <src/CustomWeapons.h>

class CTaskMine : public CGameTask {
public:
	int waterskiprelated; // 0xF0
	int unknownF4; // 0xF4 //unused?
	int unknownF8; // 0xF8 //some pointer to something
	int unknownFC; // 0xFC
	int unknown100; // 0x100 //Identifier (can be recycled tho, so its not that useful)
	int active; // 0x104
	int unknown108; // 0x108 // Unused?
	int unknown10C; // 0x10C // Unused?
	int unknown110; // 0x110 //is this some sort of id a position in an array maybe?
	int collisionflags; // 0x114
	int fusetime; // 0x118
	int delay; // 0x11C
	int radius; // 0x120
	int damage; // 0x124
	int triggered; // 0x128
	int beepsfxtimer; // 0x12C
	int unknown130; // 0x130 //unused?
	int unknown134; // 0x134 //unused?
	int unknown138; // 0x138 //unused?
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
	CustomWeapons::Mine minestruct; // 0x170
	//int unknown174; // 0x174
	//int unknown178; // 0x178
	//int unknown17C; // 0x17C
	//int unknown180; // 0x180
	//int unknown184; // 0x184
	//int unknown188; // 0x188
	int unknown18C; // 0x18C
	int unknown190; // 0x190
	int unknown194; // 0x194

	static int install(SignatureScanner & signatureScanner, module mod);
};



#endif //WKJELLYWORM_CTASKMINE_H
