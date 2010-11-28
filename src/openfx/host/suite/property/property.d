module openfx.host.suite.property.property;

enum PropertyType {
	eNone = -1, eInt = 0, eDouble = 1, eString = 2, ePointer = 3
}

abstract class Property {
	@property string name() const;
	@property PropertyType type() const;
	@property uint size() const;
	void reset();
	Property clone();
	string toString() const;
}

PropertyType GetType(T)(){
	static if(is(T==int)) {
		return PropertyType.eInt;
	} else static if(is(T==double)) {
		return PropertyType.eDouble;
	} else static if(is(T==string)) {
		return PropertyType.eString;
	} else static if(is(T==void*)) {
		return PropertyType.ePointer;
	} else {
		return PropertyType.eNone;
	}
}

import std.exception;
import std.conv;
import std.string;

final class TProperty(T) : Property {
	alias T TYPE;
	private const string m_Name;
	T[] defaultValue;
	T[] value;

	this(string name, T oneValue){
		this(name, oneValue, T.init);
	}
	this(string name, T oneValue, T oneDefaultValue){
		this(name, [oneValue], [oneDefaultValue]);
	}
	this(string name, T[] values){
		this(name, values, new T[values.length]);
	}
	this(string name, T[] values, T[] defaultValues){
		enforce(name && name.length>0, new Exception("Property name must not be null nor empty"));
		m_Name = name;
		defaultValue = defaultValues;
		value = values;
	}
	
	@property string name() const {
		return m_Name;
	}
	
	@property PropertyType type() const {
		return GetType!T();
	}

	void reset(){
		value = defaultValue.dup;
	}
	
	uint size() const{
		return value.length;
	}
	
	Property clone() {
		return new TProperty!T(m_Name, value, defaultValue);
	}
	
	override bool opEquals(Object rhs){
		auto that = cast(TProperty!T)rhs;
		if(!that)
			return false;
		return 	name == that.name &&
				value == that.value &&
				defaultValue == that.defaultValue;
	}
	
	string toString() const {
		return format("%-10s '%s'\n values  %s\n default %s", to!string(type), name, value, defaultValue);
	}
}

alias TProperty!(int)		IntProperty;
alias TProperty!(string)	StringProperty;
alias TProperty!(double)	DoubleProperty;
alias TProperty!(void*)		PointerProperty;

import std.range;
import std.stdio;
// empty name
unittest {
	try{
		new IntProperty(null,0);
		assert(false);
	}catch(Exception ex){
	}
	try{
		new IntProperty("",0);
		assert(false);
	}catch(Exception ex){
	}
}
// basic initialization
unittest {
	auto p = new IntProperty("name",3);
	assert(p.size == 1);
	assert(p.value.back == 3);
	assert(p.name == "name");
}

// types
unittest {
	void check(const Property property, PropertyType type){
		assert(property.type == type);
	}
	check( new IntProperty("_",0), PropertyType.eInt);
	check( new DoubleProperty("_",0), PropertyType.eDouble);
	check( new PointerProperty("_",cast(void*)null), PropertyType.ePointer);
	check( new StringProperty("_",""), PropertyType.eString);
}
// size && reset
unittest {
	auto p = new IntProperty("name",3,2);
	assert( p.size == 1 );
	p.value~=3;
	assert( p.size == 2 );
	p.reset();
	assert( p.size == 1 );
	assert( p.value.back == 2 );
}
// reset with default values
unittest {
	auto p = new IntProperty("name",[1,2], [2,3,4]);
	assert( p.size == 2 );
	p.reset();
	assert( p.size == 3 );
}
// value equality
unittest {
	auto p1 = new IntProperty("name",[1,2], [2,3,4]);
	auto p2 = new IntProperty("name",[1,2], [2,3,4]);
	auto p3 = new IntProperty("name",[1], [2,3,4]);
	assert( p1 == p2 );
	assert( p1 != p3 );
}
// type equality
unittest {
	assert(new IntProperty("_",1) != new DoubleProperty("_",1));
}
// clone equality
unittest {
	Property p1 = new IntProperty("name",1);
	auto clone = p1.clone();
	assert( p1 == clone );
	clone.reset();
	assert( p1 != clone );
}