module openfx.host.suite.parameter.paramter;

enum ParameterType {
	eStringParam,
	eIntParam,
	eInt2DParam,
	eInt3DParam,
	eDoubleParam,
	eDouble2DParam,
	eDouble3DParam,
	eRGBParam,
	eRGBAParam,
	eBooleanParam,
	eChoiceParam,
	eCustomParam,
	eGroupParam,
	ePageParam,
	ePushButtonParam
}

// defining here as an abstract class so we
// can benefit from Object.opEquals 
abstract class Parameter {
	private const string m_Name;
	private const ParameterType m_Type;
	this(string name, ParameterType type){ m_Name = name; m_Type = type; }
	@property string name() const { return m_Name; }
	@property ParameterType type() const { return m_Type; }

	@property bool isKeyframable() const { return false; }
	@property bool isKeyframed() const{ return false; }
	@property bool isInterpolable() const{ return false; }
	
	Parameter clone();
	string toString() const;
	override bool opEquals(Object rhs){
		auto that = cast(Parameter)rhs;
		if(!that) return false;
		return m_Name == that.m_Name && m_Type == that.m_Type;
	}
}

import std.string;
import std.conv;
import std.range;
import std.algorithm;

class KeyframableParameter(T) : Parameter {
	T[double] keyToValueMap;
	@property override bool isKeyframable() const { return true; }
	@property bool isKeyframed() const{ return keyToValueMap.length>1; }
	this(string name){
		super(name, GetType!T());
	}
	
	KeyframableParameter!T clone(){
		auto other = new KeyframableParameter!T(name);
		// copying the map would result in shallow
		// copy with sheer reference, we want a brand
		// new copy of the map
		foreach(key, value; keyToValueMap)
			other.keyToValueMap[key] = value;
		return other;
	}
	
	T getValue() const {
		if(!keyToValueMap.length)
			return T.init;
		double[] keys = keyToValueMap.keys;
		sort(keys);
		return keyToValueMap[keys.front];
	}
		
	string toString() const {
		double[] keys = keyToValueMap.keys;
		sort(keys);
		string map;
		foreach(i, key;keys){
			if(i!=0) map~=", ";
			map~=to!string(key)~':'~keyToValueMap[key];
		}
		return format("%-18s '%s'\t[%s]", to!string(type), name, map);
	}
	
	override bool opEquals(Object rhs){
		auto that = cast(KeyframableParameter!T)rhs;
		if(!that)
			return false;
		return 	super.opEquals(that) &&
				keyToValueMap == that.keyToValueMap;
	}
}

class InterpolableParameter(T) : KeyframableParameter!T {
	@property bool isInterpolable() const{ return true; }
}

pure ParameterType GetType(T)(){
	static if(is(T==string))
		return ParameterType.eStringParam;
}

alias KeyframableParameter!string StringParameter;

version (unittest){
	import std.stdio;
}
// basic string isKeyframable, isKeyframed, isInterpolated
unittest {
	auto p = new StringParameter("name");
	assert( !p.isKeyframed );
	p.keyToValueMap[0]="zero";
	assert( !p.isKeyframed );
	p.keyToValueMap[2]="two";
	assert( p.isKeyframable );
	assert( p.isKeyframed );
	assert( !p.isInterpolable );
}

// string clone
unittest {
	auto p = new StringParameter("name");
	p.keyToValueMap[0]="zero";
	p.keyToValueMap[2]="two";
	auto clone = p.clone();
	assert( p == clone );
	clone.keyToValueMap[2]="three";
	assert( p != clone );
}

// basic getValue
unittest {
	auto p = new StringParameter("name");
	assert( p.getValue() == "" );
	p.keyToValueMap[0]="zero";
	assert( p.getValue() == "zero" );
	p.keyToValueMap[2]="two";
	assert( p.getValue() == "zero" );
	p.keyToValueMap[-1]="minusone";
	assert( p.getValue() == "minusone" );
	writeln(p);
}