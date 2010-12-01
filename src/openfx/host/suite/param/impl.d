module openfx.host.suite.param.impl;

import openfx.host.suite.exception;

import openfx.c.plugincore;
import openfx.c.core;
import openfx.c.paramsuite;

OfxStatus paramDefine(OfxParamSetHandle paramSet, const char *paramType, const char *name, OfxPropertySetHandle *propertySet){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetHandle(OfxParamSetHandle paramSet, const char *name, OfxParamHandle *param, OfxPropertySetHandle *propertySet){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramSetGetPropertySet(OfxParamSetHandle paramSet, OfxPropertySetHandle *propHandle){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetPropertySet(OfxParamHandle param, OfxPropertySetHandle *propHandle){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetValue(OfxParamHandle  paramHandle, ...){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetValueAtTime(OfxParamHandle  paramHandle, OfxTime time, ...){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetDerivative(OfxParamHandle  paramHandle, OfxTime time, ...){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetIntegral(OfxParamHandle  paramHandle, OfxTime time1, OfxTime time2, ...){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramSetValue(OfxParamHandle  paramHandle, ...){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramSetValueAtTime(OfxParamHandle  paramHandle, OfxTime time, /*time in frames*/ ...){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetNumKeys(OfxParamHandle  paramHandle,uint *numberOfKeys){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetKeyTime(OfxParamHandle  paramHandle, uint nthKey, OfxTime *time){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramGetKeyIndex(OfxParamHandle paramHandle, OfxTime time, int direction, int *index){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramDeleteKey(OfxParamHandle paramHandle, OfxTime time){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramDeleteAllKeys(OfxParamHandle paramHandle){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramCopy(OfxParamHandle  paramTo, OfxParamHandle  paramFrom, OfxTime dstOffset, OfxRangeD *frameRange){
	return OfxStatus.kOfxStatFailed;
}

OfxStatus paramEditBegin(OfxParamSetHandle paramSet, const char *name){
	return OfxStatus.kOfxStatFailed;
}
 
OfxStatus paramEditEnd(OfxParamSetHandle paramSet){
	return OfxStatus.kOfxStatFailed;
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