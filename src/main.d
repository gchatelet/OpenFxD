import openfx.c.core;
import openfx.host.host;
import openfx.host.imageeffecthost;

import openfx.host.suite.memorysuite;
import openfx.host.suite.propertysuite;
import openfx.host.suite.paramsuite;
import openfx.host.suite.imageeffectsuite;
import openfx.host.suite.multithreadsuite;
import openfx.host.suite.messagesuite;

import std.stdio;
import std.string;
import std.conv;

static string rootPlugin = "/home/clitte/workspace/TuttleOFX/TuttleOFX/dist/plugins";


class MyHost : ImageEffectHost {
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
	Suite imageEffectSuite = new ImageEffectSuite;
	Suite memorySuite = new MemorySuite;
	Suite multithreadSuite = new MultithreadSuite;
	Suite messageSuite = new MessageSuiteV1;
	BasicHost host = new MyHost([propertySuite, paramSuite, imageEffectSuite, memorySuite, multithreadSuite, messageSuite]);
	host.loadPlugins(rootPlugin);
}