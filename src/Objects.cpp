
#include <string>
#include "Objects.h"
#include "Game.h"

//#include "../Debugf.h"
#include "Constants.h"

std::string Objects::help() {
	return "Lists global and ctask objects";
}

int Objects::handle(std::string &message, std::vector<std::string> &parts) {
	auto ddgame = Game::getAddrDDGame();
	CTask * turngame = *(CTask**)(ddgame + 0x8);

	//debugf("DDGame: 0x%X DDMain: 0x%X GameGlobal: 0x%X DDDisplay: 0x%X W2Wrapper: 0x%X\n", ddgame, W2App::getAddrDDMain(), W2App::getAddrGameGlobal(), W2App::getAddrDdDisplay(), W2App::getAddrW2Wrapper());

	turngame->traverse([&](CTask * obj, const int level) {
		for(int i=0; i < level; i++) printf("\t");
		printf("Obj: Type: %d \n", obj->classtype);
	});
	return 1;
}
