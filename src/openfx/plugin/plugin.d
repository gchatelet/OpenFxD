module openfx.plugin.plugin;

public import openfx.c.core;

interface PluginDescription {
	@property const {
		string filename();
		string api();
		int apiVersion();
		string identifier();
		uint versionMajor();
		uint versionMinor();
	}
}

interface Plugin : PluginDescription {
	OfxStatus perform( string action, const void* handle, OfxPropertySetHandle inArgs, OfxPropertySetHandle outArgs );
}