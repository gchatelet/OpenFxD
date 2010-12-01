import openfx.c.core;
import openfx.host.host;
import std.stdio;

import std.string;
import std.conv;

static string rootPlugin = "/home/clitte/workspace/TuttleOFX/TuttleOFX/dist/plugins";

void main(){
	class MyHost : Host {
		bool support(in PluginDescription plugin) const {
			const auto pluginFilename = plugin.filename; 
			const auto isSupporting = pluginFilename.indexOf("bundle")!=-1;
			if(!isSupporting)
				writeln("Host : Discarding plugin "~pluginFilename);
			return isSupporting;
		}
		
		this() {
			super([]);
		}
	}
	
	Host host = new MyHost();
	host.loadPlugins(rootPlugin);
}