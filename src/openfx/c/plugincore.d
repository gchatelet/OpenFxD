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

// status
enum OfxStatus : int {
	kOfxStatOK						=0,
	kOfxStatFailed					=1,
	kOfxStatErrFatal				=2,
	kOfxStatErrUnknown				=3,
	kOfxStatErrMissingHostFeature	=4,
	kOfxStatErrUnsupported			=5,
	kOfxStatErrExists				=6,
	kOfxStatErrFormat				=7,
	kOfxStatErrMemory				=8,
	kOfxStatErrBadHandle			=9,
	kOfxStatErrBadIndex				=10,
	kOfxStatErrValue				=11,
	kOfxStatReplyYes				=12,
	kOfxStatReplyNo					=13,
	kOfxStatReplyDefault			=14
}

extern(C){
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

import std.conv;
OfxStatus throwOnSuiteStatusException(in OfxStatus status){
	switch(status) {
		case OfxStatus.kOfxStatOK:
		case OfxStatus.kOfxStatReplyYes:
		case OfxStatus.kOfxStatReplyNo:
		case OfxStatus.kOfxStatReplyDefault:
			break;
		default:
		    throw new OpenfxException("throwing on invalid Status "~to!string(status));
	}
	return status;
}
