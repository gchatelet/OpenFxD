module openfx.host.suite.messagesuite;

import openfx.c.plugincore;
import openfx.c.messagesuite;

import openfx.host.host;

extern(C){

	OfxStatus message( void* handle, const char* messageType, const char* messageId, const char* format, ... ){
		return kOfxStatFailed;

	}
}

class MessageSuiteV1 : Suite {
	private OfxMessageSuiteV1 suite;
	this(){
		suite.message = &message;
	}

	@property string suiteName() const {
		return kOfxMessageSuite;
	}
	@property int suiteVersion() const {
		return 1;
	}
	void* getHandle() const {
		return cast(void*)&suite;
	}
}

class MessageSuiteV2 : Suite {
	private OfxMessageSuiteV2 suite;
	this(){
		suite.message = &message;
		suite.setPersistentMessage=null;
		suite.clearPersistentMessage=null;
	}

	@property string suiteName() const {
		return kOfxMessageSuite;
	}
	@property int suiteVersion() const {
		return 2;
	}
	void* getHandle() const {
		return cast(void*)&suite;
	}
}