module openfx.host.suite.paramsuite;

import openfx.host.suite.exception;

import openfx.c.plugincore;
import openfx.c.core;
import openfx.c.parametersuite;

extern(C){
	
	OfxStatus paramDefine(OfxParamSetHandle paramSet, const char *paramType, const char *name, OfxPropertySetHandle *propertySet){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetHandle(OfxParamSetHandle paramSet, const char *name, OfxParamHandle *param, OfxPropertySetHandle *propertySet){
		return kOfxStatFailed;
	}
	
	OfxStatus paramSetGetPropertySet(OfxParamSetHandle paramSet, OfxPropertySetHandle *propHandle){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetPropertySet(OfxParamHandle param, OfxPropertySetHandle *propHandle){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetValue(OfxParamHandle  paramHandle, ...){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetValueAtTime(OfxParamHandle  paramHandle, OfxTime time, ...){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetDerivative(OfxParamHandle  paramHandle, OfxTime time, ...){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetIntegral(OfxParamHandle  paramHandle, OfxTime time1, OfxTime time2, ...){
		return kOfxStatFailed;
	}
	
	OfxStatus paramSetValue(OfxParamHandle  paramHandle, ...){
		return kOfxStatFailed;
	}
	
	OfxStatus paramSetValueAtTime(OfxParamHandle  paramHandle, OfxTime time, /*time in frames*/ ...){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetNumKeys(OfxParamHandle  paramHandle,uint *numberOfKeys){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetKeyTime(OfxParamHandle  paramHandle, uint nthKey, OfxTime *time){
		return kOfxStatFailed;
	}
	
	OfxStatus paramGetKeyIndex(OfxParamHandle paramHandle, OfxTime time, int direction, int *index){
		return kOfxStatFailed;
	}
	
	OfxStatus paramDeleteKey(OfxParamHandle paramHandle, OfxTime time){
		return kOfxStatFailed;
	}
	
	OfxStatus paramDeleteAllKeys(OfxParamHandle paramHandle){
		return kOfxStatFailed;
	}
	
	OfxStatus paramCopy(OfxParamHandle  paramTo, OfxParamHandle  paramFrom, OfxTime dstOffset, OfxRangeD *frameRange){
		return kOfxStatFailed;
	}
	
	OfxStatus paramEditBegin(OfxParamSetHandle paramSet, const char *name){
		return kOfxStatFailed;
	}
	 
	OfxStatus paramEditEnd(OfxParamSetHandle paramSet){
		return kOfxStatFailed;
	}

}

import openfx.host.host;

class ParameterSuite : Suite {
	private OfxParameterSuiteV1 suite;
	
	this(){
		suite.paramDefine               = &paramDefine;
		suite.paramGetHandle            = &paramGetHandle;
		suite.paramSetGetPropertySet    = &paramSetGetPropertySet;
		suite.paramGetPropertySet       = &paramGetPropertySet;
		suite.paramGetValue             = &paramGetValue;
		suite.paramGetValueAtTime       = &paramGetValueAtTime;
		suite.paramGetDerivative        = &paramGetDerivative;
		suite.paramGetIntegral          = &paramGetIntegral;
		suite.paramSetValue             = &paramSetValue;
		suite.paramSetValueAtTime       = &paramSetValueAtTime;
		suite.paramGetNumKeys           = &paramGetNumKeys;
		suite.paramGetKeyTime           = &paramGetKeyTime;
		suite.paramGetKeyIndex          = &paramGetKeyIndex;
		suite.paramDeleteKey            = &paramDeleteKey;
		suite.paramDeleteAllKeys        = &paramDeleteAllKeys;
		suite.paramCopy                 = &paramCopy;
		suite.paramEditBegin            = &paramEditBegin;
		suite.paramEditEnd              = &paramEditEnd;
	}
	
	string suiteName() const {
		return kOfxParameterSuite;
	}
	
	int suiteVersion() const {
		return 1;
	}
	
	void* getHandle() const {
		return cast(void*)&suite;
	}
}