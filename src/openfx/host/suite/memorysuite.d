module openfx.host.suite.memorysuite;

import openfx.c.memorysuite;
import openfx.c.plugincore;

import openfx.host.host;

extern(C){

	OfxStatus memoryAlloc( void*  handle, size_t nBytes, void** allocatedData ){
		return kOfxStatFailed;
	}
	
	OfxStatus memoryFree( void* allocatedData ){
		return kOfxStatFailed;
	}

}

class MemorySuite : Suite {
	private OfxMemorySuiteV1 suite;
	this(){
		suite.memoryAlloc = &memoryAlloc;
		suite.memoryFree  = &memoryFree;
	}

	@property string suiteName() const {
		return kOfxMemorySuite;
	}
	@property int suiteVersion() const {
		return 1;
	}
	void* getHandle() const {
		return cast(void*)&suite;
	}
}