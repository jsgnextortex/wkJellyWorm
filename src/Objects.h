#include <vector>

#ifndef WKTESTSTUFF_OBJECTS_H
#define WKTESTSTUFF_OBJECTS_H

class Objects {
public:
	virtual std::string help();
	virtual int handle(std::string & message, std::vector<std::string> & parts);
};


#endif //WKTESTSTUFF_OBJECTS_H
