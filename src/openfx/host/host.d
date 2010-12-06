module openfx.host.host;

import openfx.plugin.plugin;
public import openfx.plugin.plugin : PluginDescription;

import std.conv;
import std.file;
import std.string;
import std.range;

extern(C) void* fetchSuite( OfxPropertySetHandle hostHandle, const char* suiteName, int suiteVersion ){
	if(hostHandle) {
		BasicHost host = *(cast(BasicHost*)hostHandle);
		return host.fetchSuite(to!string(suiteName), suiteVersion);
	} else {
		writeln("Host : plugin is asking for a Suite but host is null");
		return null;
	}
}

interface Suite {
	@property string suiteName() const;
	@property int suiteVersion() const;
	void* getHandle() const;
}

import openfx.host.suite.property.propertyset;

abstract class BasicHost : PropertySet {
private:
	Binary.Plugin[] m_Plugins;
	Suite[] m_Suites;
	OfxHost m_ofxHost;
public:
	this(Suite[] suites){
		m_Suites = suites;
	}
	
	@property Binary.Plugin[] plugins() {
		return m_Plugins;
	}
	
	void loadPlugins(string rootPath) {
		BasicHost pBase = this; // getting base
		m_ofxHost.host = &pBase;
		m_ofxHost.fetchSuite = &.fetchSuite;
		enforce(isdir(rootPath));
		foreach(string entry; dirEntries(rootPath, SpanMode.depth))
			if(isfile(entry) && entry.endsWith(".ofx")){
				Binary binary = new Binary(entry);
				foreach( plugin ; binary.m_Plugins )
					if(support(plugin))
						plugin.setHost(this);
			}
	}
	
	final void* fetchSuite(in string suiteName, in int suiteVersion) const{
		foreach(suite;m_Suites)
			if( suite.suiteVersion == suiteVersion && suite.suiteName == suiteName )
				return suite.getHandle();
		writeln("Host : plugin asked for unavailable "~suiteName~":"~to!string(suiteVersion));
		return null;
	}
	
	abstract bool support(in PluginDescription) const;
}

import std.loader;
import std.stdio;
import std.exception;

private final class Binary{
private:
	static const string m_sGetNumberOfPluginsSymbol = "OfxGetNumberOfPlugins"; 
	static const string m_sGetPluginSymbol = "OfxGetPlugin"; 
	HXModule library;
	OfxGetPlugin getPluginFunction;
	Plugin[] m_Plugins;
public:
	const {
		uint numberOfPlugin;
		string filename;
		string toString(){ return filename~" contains "~to!string(numberOfPlugin)~" plugins"; }
	}
	
	this(string filename){
		this.filename = filename;
		library = ExeModule_Load(filename);
		enforce(library, new OpenfxException(ExeModule_Error()));
		OfxGetNumberOfPlugins f = cast(OfxGetNumberOfPlugins)ExeModule_GetSymbol(library,m_sGetNumberOfPluginsSymbol);
		enforce(f, new OpenfxException(ExeModule_Error()));
		numberOfPlugin = f();
		getPluginFunction = cast(OfxGetPlugin)ExeModule_GetSymbol(library,m_sGetPluginSymbol);
		enforce(getPluginFunction, new OpenfxException(ExeModule_Error()));
		foreach(i; 0..numberOfPlugin)
			m_Plugins~=new Plugin(getPluginFunction(i));
	}
	
	~this(){
		if(library)
			ExeModule_Release(library);
	}
	
private:
	final class Plugin : openfx.host.host.Plugin {
	public:
		const {
			string m_Api;
			int m_ApiVersion;
			string m_Identifier;
			uint m_VersionMajor;
			uint m_VersionMinor;
		}
	
		const {
			string filename() {return this.outer.filename;}
			string api() {return m_Api;}
			int apiVersion() {return m_ApiVersion;}
			string identifier() {return m_Identifier;}
			uint versionMajor() {return m_VersionMajor;}
			uint versionMinor() {return m_VersionMinor;}
			string toString() {
				return "["~api~":"~to!string(apiVersion)~"]\t"
				~identifier~":"
				~to!string(versionMajor)~"."~to!string(versionMinor)
				;
			}
		}
		OfxStatus perform( string action, const void* handle, OfxPropertySetHandle inArgs, OfxPropertySetHandle outArgs ){
			const OfxStatus status = m_pPlugin.mainEntry(action.toStringz, handle, inArgs, outArgs);
			return status;
		}
	private:
		OfxPlugin *m_pPlugin;
		bool m_HostSet;
		
		this(OfxPlugin *pPlugin){
			enforce(pPlugin);
			m_HostSet = false;
			m_pPlugin = pPlugin;
			m_Api = to!string(m_pPlugin.pluginApi);
			m_Identifier = to!string(m_pPlugin.pluginIdentifier);
			m_ApiVersion = m_pPlugin.apiVersion;
			m_VersionMinor = m_pPlugin.pluginVersionMinor;
			m_VersionMajor = m_pPlugin.pluginVersionMajor;
		}
		~this(){
			if(m_HostSet)
				tearDown();
		}
		
		// host can be set only once
		void setHost(ref BasicHost host){
			enforce(host);
			enforce(!m_HostSet);
			m_pPlugin.setHost( &(host.m_ofxHost) );
			host.m_Plugins~=this;
			setUp();
			m_HostSet = true;
		}
		
		void setUp(){
			perform(kOfxActionLoad,null,null,null);
		}
		
		void tearDown(){
			perform(kOfxActionUnload,null,null,null);
		} 
	}
}