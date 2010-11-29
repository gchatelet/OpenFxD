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
	private T[double] keyToValueMap;
	
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
	
	T getValue(double atTime) const {
		const size_t mapSize = keyToValueMap.length;
		if(mapSize==0)
		    throw new Exception("Parameter '"~name~"' has no keys and therefore no value");
		if(mapSize==1)
			return keyToValueMap.front;
		if(atTime in keyToValueMap)
			return keyToValueMap[atTime]; 
		auto keys = keyToValueMap.keys;
		sort(keys);
		if(atTime < keys.front)
		    return keyToValueMap[keys.front];
		if(atTime > keys.back)
			return keyToValueMap[keys.back];
		auto keysAfterAtTime = find!("a<b")(keys, atTime);
		return interpolate(atTime, keysAfterAtTime[0], keysAfterAtTime[1]);
	}
	
	protected T interpolate(double at, double before, double after) const {
		return keyToValueMap[before];
	} 
	
	void setValue(T value, double atTime) {
		keyToValueMap[atTime] = value;
	}
	
	void deleteKey(double atTime){
		keyToValueMap.remove(atTime);
	}
	
	void deleteAllKey(){
		keyToValueMap.clear();
	}
	
	string toString() const {
		double[] keys = keyToValueMap.keys;
		sort(keys);
		string map;
		foreach(i, key;keys){
			if(i!=0) map~=", ";
			map~=to!string(key)~':'~to!string(keyToValueMap[key]);
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
		
	this(string name){
		super(name);
	}

	protected T interpolate(double at, double before, double after) const {
		auto ratio = (at-before)/(after-before);
		auto leftValue = keyToValueMap[before]; 
		auto rightValue = keyToValueMap[after]; 
		return cast(T)doubleInterpolate(leftValue, rightValue, ratio);
	}
	 
	private final double doubleInterpolate(double left, double right, double ratio) const {
		return left*(1-ratio)+right*ratio;
	}
}

ParameterType GetType(T)(){
	static if(is(T==string))
		return ParameterType.eStringParam;
	else static if(is(T==int))
		return ParameterType.eIntParam;
	else static if(is(T==double))
		return ParameterType.eDoubleParam;
}

alias KeyframableParameter!string StringParameter;
alias InterpolableParameter!int IntParameter;
alias InterpolableParameter!double DoubleParameter;

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

// basic getValue no interpolation
unittest {
	auto p = new StringParameter("name");
	try{ p.getValue(0); assert(false); } catch(Exception e){}
	
	p.setValue("zero", 0);
	assert( p.getValue(0) == "zero" );
	assert( p.getValue(-1) == "zero" );
	assert( p.getValue(1) == "zero" );
	
	p.setValue("two", 2);
	assert( p.getValue(0) == "zero" );
	assert( p.getValue(-1) == "zero" );
	assert( p.getValue(1) == "zero" );
	assert( p.getValue(2) == "two" );
	assert( p.getValue(3) == "two" );
}

// basic getValue interpolation
unittest {
	{
		auto p = new IntParameter("name");
		try{ p.getValue(0); assert(false); } catch(Exception e){}
		
		p.setValue(0, 0);
		assert( p.getValue(0) == 0 );
		assert( p.getValue(-1) == 0 );
		assert( p.getValue(1) == 0 );
		
		p.setValue(2, 2);
		assert( p.getValue(0) == 0 );
		assert( p.getValue(-1) == 0 );
		assert( p.getValue(1) == 1 );
		assert( p.getValue(2) == 2 );
		assert( p.getValue(3) == 2 );
	}

	{	
		auto p = new DoubleParameter("name");
		p.setValue(0,0);
		p.setValue(2,2);
		assert( p.getValue(1.11) == 1.11 );
	}
}