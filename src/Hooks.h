#ifndef WKJELLYWORM_HOOKS_H
#define WKJELLYWORM_HOOKS_H

#ifndef __CALLPOSITION__
#define STRINGIZE_DETAIL(x) #x
#define STRINGIZE(x) STRINGIZE_DETAIL(x)
#define __CALLPOSITION__  __FUNCTION__ ":" STRINGIZE(__LINE__)
#endif

#include <map>
#include <string>
#include <polyhook2/Detour/x86Detour.hpp>

class Hooks {
private:
	static inline std::map<std::string, DWORD> hookNameToAddr;
	static inline std::map<DWORD, std::string> hookAddrToName;

	static inline std::map<std::string, DWORD> scanNameToAddr;
	static inline std::map<DWORD, std::string> scanAddrToName;
	static inline bool scanFoundNew = false;
	static inline std::vector<std::unique_ptr<PLH::x86Detour>> detours;

	//Worms development tools by StepS
	template<typename VT>
	static BOOL __stdcall PatchMemVal(PVOID pAddr, VT newValue) { return PatchMemData(pAddr, sizeof(VT), &newValue, sizeof(VT)); }
	template<typename VT>
	static BOOL __stdcall PatchMemVal(ULONG_PTR pAddr, VT newValue) { return PatchMemData((PVOID) pAddr, sizeof(VT), &newValue, sizeof(VT)); }

	static BOOL PatchMemData(PVOID pAddr, size_t buf_len, PVOID pNewData, size_t data_len);
	static BOOL InsertJump(PVOID pDest, size_t dwPatchSize, PVOID pCallee, DWORD dwJumpType);
public:
	static void polyhook(std::string name, DWORD pTarget, DWORD *pDetour, DWORD *ppOriginal);
	static void minhook(std::string name, DWORD pTarget, DWORD *pDetour, DWORD *ppOriginal);
	static void hook(std::string name, DWORD pTarget, DWORD* pDetour, DWORD* ppOriginal, const char* line = nullptr);
	static void hookAsm(DWORD startAddr, DWORD hookAddr);
	static void hookVtable(const char * classname, int offset, DWORD addr, DWORD hookAddr, DWORD * original);
	static void patchAsm(DWORD addr, unsigned char *op, size_t opsize);

	static DWORD scanPattern(const char* name, const char* pattern, const char* mask, DWORD expected = 0);

	static void saveOffsets(std::string filename);
	static void loadOffsets(std::string filename);


};

inline const char* GenerateMask(const char* hexString) {
	static std::string mask;
	mask.clear();

	// Iterate through the input string
	std::string le = std::string(hexString);
	size_t length = le.length();
	for (size_t i = 0; i < length; ++i) {
			// Valid hex byte, check if it's "00"
		printf("%d ", hexString[i]);
			if (hexString[i] == 0) {
				mask += '?';
			}
			else {
				mask += 'x';
			}
			// Skip past the current \xNN sequence
			i += 1;
	}
	printf("test: (%s) ", mask.c_str());
	return mask.c_str();
}



inline const char* hexStringToBytes(const std::string& hex) {
	size_t outLength;
	size_t len = hex.size();
	if (len % 2 != 0) {
		throw std::invalid_argument("Hex string must have an even length.");
	}

	// Calculate the output length
	outLength = len / 2;

	// Allocate memory for the output bytes
	char* bytes = new char[outLength];

	for (size_t i = 0; i < len; i += 2) {
		std::string byteStr = hex.substr(i, 2);
		if (byteStr == "??") {
			// Handle wildcard bytes as 0x00
			bytes[i / 2] = 0x00;
		}
		else {
			// Check if the substring is valid hex
			try {
				bytes[i / 2] = static_cast<char>(std::stoul(byteStr, nullptr, 16));
			}
			catch (const std::invalid_argument&) {
				delete[] bytes;
				throw std::invalid_argument("Invalid hex characters in input: " + byteStr);
			}
			catch (const std::out_of_range&) {
				delete[] bytes;
				throw std::out_of_range("Hex value out of range: " + byteStr);
			}
		}
	}

	return bytes;
}

// Function to generate a mask from a hex string (returns a char*)
inline const char* hexStringToMask(const std::string& hex) {
	size_t len = hex.size();
	if (len % 2 != 0) {
		throw std::invalid_argument("Hex string must have an even length.");
	}

	// Allocate memory for the mask
	char* mask = new char[len / 2]; // +1 for null terminator

	for (size_t i = 0; i < len; i += 2) {
		if (hex[i] == '?' && hex[i + 1] == '?') {
			mask[i / 2] = '?';
		}
		else {
			mask[i / 2] = 'x';
		}
	}

	mask[len / 2] = '\0'; // Null terminate the mask
	printf("test: %s \n", mask);
	return mask;
}

#define _ScanPattern(name, pattern, mask) Hooks::scanPattern(name, pattern, mask, 0)
#define _HookDefault(name) Hooks::hook(#name, addr##name, (DWORD *) &hook##name, (DWORD *) &orig##name, __CALLPOSITION__)


#define _ScanLazy(name, pattern)std::string straddr##name = pattern; DWORD addr##name = Hooks::scanPattern(#name, hexStringToBytes(straddr##name), hexStringToMask(straddr##name), 0)
#define _HookDefLazy(name, rettype,callconv, params) std::string dummy##name = "stinko"; rettype (callconv* orig##name) params; rettype callconv hook##name params

#endif //WKJELLYWORM_HOOKS_H
