
#ifndef WKJELLYWORM_SPRITES_H
#define WKJELLYWORM_SPRITES_H


#include <sigscanner.h>
#include <vector>
#include <string>
#include "renderer/Bitmap.h"
class Sprites {
public:
	class SpriteFrame {
	public:
		DWORD bitmapoffset;
		WORD startx;
		WORD starty;
		WORD endx;
		WORD endy;
	};


public:
	DWORD dword0;
	DWORD dword4;
	WORD word8;
	WORD fps_wordA;
	WORD width_wordC;
	WORD height_wordE;
	WORD flags_word10;
	WORD max_frames_copy_word12;
	WORD word14;
	WORD max_frames_word16;
	WORD word18;
	WORD word1A;
	DWORD dword1C;
	DWORD dword20;
	DWORD dword24;
	SpriteFrame * frame_meta_ptr_dword28;
	DWORD dword2C;
	WORD word30;
	WORD word32;


	DWORD bitmap_dword34;

	DWORD dword38;
	DWORD dword3C;
	DWORD dword40;
	DWORD dword44;
	DWORD dword48;
	DWORD dword4C;
	DWORD dword50;
	DWORD dword54;
	DWORD dword58;
	DWORD dword5C;

//	Bitmap::BitmapImage bitmap;
	DWORD dword60;
	DWORD probably_sprite_bitmap_data_dword64;
	DWORD maybe_palette_data_dword68;
	DWORD dword6C;

private:
	static inline std::vector<std::string> customSprites;
	static inline bool hookingVfs = false;
	static inline std::string hookingFilename;

	static DWORD __stdcall hookLoadSprite_OpenVfsReader(int a3, int a4);
	static int __fastcall hookLoadSprite(DWORD DD_Display, int EDX, int palette, int id, int a4, int a5, const char *filename);
public:

	static const int customSpriteStartingId = 700;

	static void onConstructGlobalContext(int a1);
	static int install(SignatureScanner &, module);
	static int registerCustomSprite(std::string filename);
	static void resetConfig();
	static void callDrawSpriteLocal(int posy, int layer, int posx, int sprite, int frame);
	static void callDrawSpriteGlobal(int posy, int layer, int posx, int sprite, int frame);
};


class BoiledDownSprite {
public:
	int dword0;
	int dword4;
	int word8;
	int fps_wordA;
	int width_wordC;
	int height_wordE;
	int flags_word10;
	int max_frames_copy_word12;
	int word14;
	int max_frames_word16;
	int word18;
	int word1A;
	int dword1C;
	int dword20;
	int dword24;
	Sprites::SpriteFrame* frame_meta_ptr_dword28;
	int dword2C;
	int word30;
	int word32;


	int bitmap_dword34;

	int dword38;
	int dword3C;
	int dword40;
	int dword44;
	int dword48;
	int dword4C;
	int dword50;
	int dword54;
	int dword58;
	int dword5C;

	//	Bitmap::BitmapImage bitmap;
	int dword60;
	int probably_sprite_bitmap_data_dword64;
	int maybe_palette_data_dword68;
	int dword6C;

};


#endif //WKJELLYWORM_SPRITES_H
