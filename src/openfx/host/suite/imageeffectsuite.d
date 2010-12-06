module openfx.host.suite.imageeffectsuite;

import openfx.c.plugincore;
import openfx.c.core;
import openfx.c.parametersuite;
import openfx.c.imageeffectsuite;

import openfx.host.host;

import openfx.host.suite.exception;

ImageEffectSuite getSuite(OfxImageEffectHandle imageEffect){
	if(imageEffect==null)
		throw new SuiteException(kOfxStatErrBadHandle, "OfxImageEffectHandle must not be null");
	ImageEffectSuite* suite = cast(ImageEffectSuite*)(imageEffect);
	return *suite;
}
extern(C){
	OfxStatus getPropertySet( OfxImageEffectHandle imageEffect, OfxPropertySetHandle* propHandle ){
		return check((){ 
			PropertySet propertySet = getSuite(imageEffect).propertySet; 
			*propHandle = &propertySet;
		});
	}
	
	OfxStatus getParamSet( OfxImageEffectHandle imageEffect, OfxParamSetHandle*   paramSet ){
		return kOfxStatFailed;
	}
	
	OfxStatus clipDefine( OfxImageEffectHandle imageEffect, const char* name, OfxPropertySetHandle* propertySet ){
		return kOfxStatFailed;
	}
	
	OfxStatus clipGetHandle( OfxImageEffectHandle imageEffect, const char* name, OfxImageClipHandle*   clip, OfxPropertySetHandle* propertySet ){
		return kOfxStatFailed;
	}
	
	OfxStatus clipGetPropertySet( OfxImageClipHandle clip, OfxPropertySetHandle* propHandle ){
		return kOfxStatFailed;
	}
	
	OfxStatus clipGetImage( OfxImageClipHandle clip, OfxTime time, OfxRectD* region, OfxPropertySetHandle* imageHandle ){
		return kOfxStatFailed;
	}
	
	OfxStatus clipReleaseImage( OfxPropertySetHandle imageHandle ){
		return kOfxStatFailed;
	}
	
	OfxStatus clipGetRegionOfDefinition( OfxImageClipHandle clip, OfxTime time, OfxRectD* bounds ){
		return kOfxStatFailed;
	}
	
	int abort( OfxImageEffectHandle imageEffect ){
		return kOfxStatFailed;
	}
	
	OfxStatus imageMemoryAlloc( OfxImageEffectHandle  instanceHandle, size_t nBytes, OfxImageMemoryHandle* memoryHandle ){
		return kOfxStatFailed;
	}
	
	OfxStatus imageMemoryFree( OfxImageMemoryHandle memoryHandle ){
		return kOfxStatFailed;
	}
	
	OfxStatus imageMemoryLock( OfxImageMemoryHandle memoryHandle, void** returnedPtr ){
		return kOfxStatFailed;
	}
	
	OfxStatus imageMemoryUnlock( OfxImageMemoryHandle memoryHandle ){
		return kOfxStatFailed;
	}
}

import openfx.host.suite.property.propertyset;

class ImageEffectSuite : Suite {
	private OfxImageEffectSuiteV1 suite;
	private PropertySet propertySet;
	
	this(){
		propertySet = new PropertySet;
		suite.getPropertySet             =&getPropertySet;
		suite.getParamSet                =&getParamSet;
		suite.clipDefine                 =&clipDefine;
		suite.clipGetHandle              =&clipGetHandle;
		suite.clipGetPropertySet         =&clipGetPropertySet;
		suite.clipGetImage               =&clipGetImage;
		suite.clipReleaseImage           =&clipReleaseImage;
		suite.clipGetRegionOfDefinition  =&clipGetRegionOfDefinition;
		suite.abort                      =&abort;
		suite.imageMemoryAlloc           =&imageMemoryAlloc;
		suite.imageMemoryFree            =&imageMemoryFree;
		suite.imageMemoryLock            =&imageMemoryLock;
		suite.imageMemoryUnlock          =&imageMemoryUnlock;
	}
	
	@property string suiteName() const {
		return kOfxImageEffectSuite;
	}
	@property int suiteVersion() const {
		return 1;
	}
	void* getHandle() const {
		return cast(void*)&suite;
	}
}