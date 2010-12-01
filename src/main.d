import openfx.c.core;
import openfx.host.host;

import openfx.host.suite.param.impl;
import openfx.host.suite.property.impl;

import std.stdio;
import std.string;
import std.conv;

static string rootPlugin = "/home/clitte/workspace/TuttleOFX/TuttleOFX/dist/plugins";


class MyHost : Host {
	bool support(in PluginDescription plugin) const {
		const auto pluginFilename = plugin.filename; 
		const auto isSupporting = pluginFilename.indexOf("bundle")!=-1;
		if(!isSupporting)
			writeln("Host : Discarding plugin "~pluginFilename);
		return isSupporting;
	}
	
	this(Suite[] suites) {
		super(suites);
	}
}

void main(){
	Suite propertySuite = new PropertySuite;
	Suite paramSuite = new ParameterSuite;
	Host host = new MyHost([propertySuite, paramSuite]);
	host.loadPlugins(rootPlugin);
}