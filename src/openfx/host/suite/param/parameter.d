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
	static if(is(T:int[]))
		alias int[] ReturnType;
	else static if (is(T:double[]))
		alias double[] ReturnType;
	else
		alias T ReturnType;
		
	private ReturnType[double] keyToValueMap;
	
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
	
	const(ReturnType) getValue(double atTime) const {
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
	
	protected const(ReturnType) interpolate(double at, double before, double after) const {
		return keyToValueMap[before];
	}
	
	void setValue(double atTime, ReturnType value) {
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

	protected pure const(ReturnType) interpolate(double at, double timeBefore, double timeAfter) const {
		auto ratio = (at-timeBefore)/(timeAfter-timeBefore);
		const ReturnType leftValue = keyToValueMap[timeBefore];
		const ReturnType rightValue = keyToValueMap[timeAfter]; 
		return .interpolate(ratio, leftValue, rightValue);
	}
	 
}

private pure final const(T) interpolate(T)(in double ratio, in T left, in T right) {
	static if (is(T:const double)) {
		return cast(T)(left*(1-ratio)+right*ratio);
	} else {
		static if(is(T == const(int[])))
			alias int[] TYPE;
		static if(is(T == const(double[])))
			alias double[] TYPE;
		TYPE value;
		for(int i=0;i<left.length;++i)
			value~=interpolate(ratio,left[i],right[i]);
		return value;
	} 
}

ParameterType GetType(T)(){
	static if(is(T==string))
		return ParameterType.eStringParam;
	else static if(is(T==int))
		return ParameterType.eIntParam;
	else static if(is(T==int2))
		return ParameterType.eInt2DParam;
	else static if(is(T==int3))
		return ParameterType.eInt3DParam;
	else static if(is(T==double))
		return ParameterType.eDoubleParam;
	else static if(is(T==double2))
		return ParameterType.eDouble2DParam;
	else static if(is(T==double3))
		return ParameterType.eDouble3DParam;
	else static if(is(T==rgb))
		return ParameterType.eRGBParam;
	else static if(is(T==rgba))
		return ParameterType.eRGBAParam;
	else static if(is(T==bool))
		return ParameterType.eBooleanParam;
}

private size_t GetCount(ParameterType type){
	switch(type){
		case ParameterType.eBooleanParam:
		case ParameterType.eIntParam:
		case ParameterType.eDoubleParam:
		return 1;
		case ParameterType.eInt2DParam:
		case ParameterType.eDouble2DParam:
		return 2;
		case ParameterType.eInt3DParam:
		case ParameterType.eDouble3DParam:
		case ParameterType.eRGBParam:
		return 3;
		case ParameterType.eRGBAParam:
		return 4;
	}
}

alias int[2]						int2;
alias int[3]						int3;
alias double[2]						double2;
alias double[3]						double3;
alias double[3]						rgb;
alias double[4]						rgba;

alias KeyframableParameter!bool		BooleanParameter;
alias KeyframableParameter!string	StringParameter;
alias InterpolableParameter!int 	IntParameter;
alias InterpolableParameter!int2 	Int2DParameter;
alias InterpolableParameter!int3 	Int3DParameter;
alias InterpolableParameter!double 	DoubleParameter;
alias InterpolableParameter!double2 Double2DParameter;
alias InterpolableParameter!double3 Double3DParameter;
alias InterpolableParameter!rgb		RgbParameter;
alias InterpolableParameter!rgba	RgbaParameter;

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
	
	p.setValue(0, "zero");
	assert( p.getValue(0) == "zero" );
	assert( p.getValue(-1) == "zero" );
	assert( p.getValue(1) == "zero" );
	
	p.setValue(2, "two");
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
	
	{	
		auto p = new RgbaParameter("name");
		p.setValue(0,[0,1,2,3]);
		p.setValue(2,[1,2,4,6]);
		writeln(p.getValue(1));
		assert( p.getValue(1) == [0.5,1.5,3,4.5] );
	}
}