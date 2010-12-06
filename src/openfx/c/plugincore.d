module openfx.c.plugincore;

alias void* OfxPropertySetHandle;

// actions
static const {
	string kOfxActionLoad="OfxActionLoad";
	string kOfxActionDescribe="OfxActionDescribe";
	string kOfxActionUnload="OfxActionUnload";
	string kOfxActionCreateInstance="OfxActionCreateInstance";
	string kOfxActionDestroyInstance="OfxActionDestroyInstance";
}

extern(C){
	// status
	alias int OfxStatus;
	
	const {
		OfxStatus kOfxStatOK					=0;
		OfxStatus kOfxStatFailed				=1;
		OfxStatus kOfxStatErrFatal				=2;
		OfxStatus kOfxStatErrUnknown			=3;
		OfxStatus kOfxStatErrMissingHostFeature	=4;
		OfxStatus kOfxStatErrUnsupported		=5;
		OfxStatus kOfxStatErrExists				=6;
		OfxStatus kOfxStatErrFormat				=7;
		OfxStatus kOfxStatErrMemory				=8;
		OfxStatus kOfxStatErrBadHandle			=9;
		OfxStatus kOfxStatErrBadIndex			=10;
		OfxStatus kOfxStatErrValue				=11;
		OfxStatus kOfxStatReplyYes				=12;
		OfxStatus kOfxStatReplyNo				=13;
		OfxStatus kOfxStatReplyDefault			=14;
	}

	alias OfxStatus function( const char* action, const void* handle, OfxPropertySetHandle inArgs, OfxPropertySetHandle outArgs ) OfxPluginEntryPoint;

	struct OfxHost
	{
		OfxPropertySetHandle host;
		void* function( OfxPropertySetHandle host, const char* suiteName, int suiteVersion ) fetchSuite;
	};
	
	struct OfxPlugin
	{
		const char* pluginApi;
		int apiVersion;
		const char* pluginIdentifier;
		uint pluginVersionMajor;
		uint pluginVersionMinor;
		void function( OfxHost* host ) setHost;
		OfxPluginEntryPoint mainEntry;
	};
	
	alias OfxPlugin* function( int nth ) OfxGetPlugin;
	alias int function() OfxGetNumberOfPlugins;
}

import std.exception;
class OpenfxException : Exception {
	this(string what){
		super(what);
	}
}

string[OfxStatus] ofxStatusToString;
static this(){
	ofxStatusToString[kOfxStatOK]					="kOfxStatOK";					
	ofxStatusToString[kOfxStatFailed]				="kOfxStatFailed";				
	ofxStatusToString[kOfxStatErrFatal]				="kOfxStatErrFatal";				
	ofxStatusToString[kOfxStatErrUnknown]			="kOfxStatErrUnknown";			
	ofxStatusToString[kOfxStatErrMissingHostFeature]="kOfxStatErrMissingHostFeature";
	ofxStatusToString[kOfxStatErrUnsupported]		="kOfxStatErrUnsupported";		
	ofxStatusToString[kOfxStatErrExists]			="kOfxStatErrExists";			
	ofxStatusToString[kOfxStatErrFormat]			="kOfxStatErrFormat";
	ofxStatusToString[kOfxStatErrMemory]			="kOfxStatErrMemory";			
	ofxStatusToString[kOfxStatErrBadHandle]			="kOfxStatErrBadHandle";			
	ofxStatusToString[kOfxStatErrBadIndex]			="kOfxStatErrBadIndex";			
	ofxStatusToString[kOfxStatErrValue]				="kOfxStatErrValue";				
	ofxStatusToString[kOfxStatReplyYes]				="kOfxStatReplyYes";				
	ofxStatusToString[kOfxStatReplyNo]				="kOfxStatReplyNo";				
	ofxStatusToString[kOfxStatReplyDefault]			="kOfxStatReplyDefault";			
}

import std.conv;
string toString(OfxStatus status){
	return ofxStatusToString.get(status, "unknown ofxStatus("~to!string(status)~")");
}

OfxStatus throwOnSuiteStatusException(in OfxStatus status){
	switch(status) {
		case kOfxStatOK:
		case kOfxStatReplyYes:
		case kOfxStatReplyNo:
		case kOfxStatReplyDefault:
			break;
		default:
		    throw new OpenfxException("throwing on invalid Status "~toString(status));
	}
	return status;
}
