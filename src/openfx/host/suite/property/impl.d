module openfx.host.suite.property.impl;

import openfx.host.suite.property.propertyset;
import openfx.host.suite.property.property;

import openfx.c.core;
import openfx.c.propertysuite;

import std.exception;
import std.conv;
import std.stdio;
import std.range;
import std.string;

final class SuiteException : Exception {
	const OfxStatus status;
	this(OfxStatus status, string message){
		super(message~" - returning "~to!string(status));
		this.status = status;
	}
}

OfxStatus check(void delegate() f){
	try{
		f();
		return OfxStatus.kOfxStatOK;
	} catch(SuiteException e){
		writeln(e.msg);
		return e.status;
	} catch(Exception e){
		writeln(e);
		return OfxStatus.kOfxStatErrFatal;
	}
}

Property getRawProperty(OfxPropertySetHandle properties, const char* property){
	if(properties==null)
		throw new SuiteException(OfxStatus.kOfxStatErrBadHandle, "OfxPropertySetHandle must not be null");
	PropertySet* set = cast(PropertySet*)(properties);
	string name = to!string(property);
	if(name !in set.map)
		throw new SuiteException(OfxStatus.kOfxStatErrUnknown, "No property with name '"~name~"' in this propertySet");
	return set.map[name];
}

T getProperty(T)(OfxPropertySetHandle properties, const char* propertyName){
	auto property = getRawProperty(properties, propertyName);
	T typed = cast(T)property;
	if(typed is null)
		throw new SuiteException(OfxStatus.kOfxStatErrBadHandle, "The property '"~property.name~"' is of type "~to!string(property.type));
	return typed;
}

void checkBound(T)(in T property, int index){
	if(index >= property.size)
		throw new SuiteException(OfxStatus.kOfxStatErrBadIndex, "The property '"~property.name~"' has "~to!string(property.size)~" elements, cannot ask for index "~to!string(index));
}

void checkSize(T)(in T property, int size){
	if(size > property.size)
		throw new SuiteException(OfxStatus.kOfxStatErrBadIndex, "The property '"~property.name~"' has only "~to!string(property.size)~" elements");
}

TO adapt(TO, FROM)(FROM impl){
	static if(is(TO==char*)&&is(FROM==string)){
		// casting immutability away sucks but openfx can't express constness nor immutability
		return cast(char*)impl.toStringz;
	} else static if(is(TO==string)&&is(FROM==const(char*))){
		return to!string(impl);
	}else{
		return impl;
	}
}

OfxStatus getValue(PROP_TYPE, TYPE)(PROP_TYPE property, in int index, TYPE* value ){
	return check((){
		checkBound(property, index);
		*value = adapt!(TYPE,PROP_TYPE.TYPE)(property.value.front);
	});
}

OfxStatus getValues(PROP_TYPE, TYPE)(PROP_TYPE property, in int count, TYPE* value ){
	return check((){
		checkSize(property, count);
		foreach(i;0..count)
			value[i] = adapt!(TYPE,PROP_TYPE.TYPE)(property.value[i]);
	});
}

OfxStatus setValue(PROP_TYPE, TYPE)(PROP_TYPE property, in int index, TYPE value ){
	return check((){
		checkBound(property, index);
		property.value.front = adapt!(PROP_TYPE.TYPE, TYPE)(value);
	});
}

OfxStatus setValues(PROP_TYPE, TYPE)(PROP_TYPE property, in int count, TYPE* value ){
	return check((){
		checkSize(property, count);
		foreach(i;0..count)
			property.value[i] = adapt!(PROP_TYPE.TYPE, TYPE)(value[i]);
	});
}

OfxStatus propReset( OfxPropertySetHandle properties, const char* property ){
	return check((){
		getRawProperty(properties, property).reset();
	});
}

OfxStatus propGetDimension( OfxPropertySetHandle properties, const char* property, int* count ){
	return check((){
		*count = getRawProperty(properties, property).size();
	});
}

OfxStatus propGetPointer( OfxPropertySetHandle properties, const char* property, int index, void** value ){
	return getValue(getProperty!PointerProperty(properties, property), index, value);
}
OfxStatus propGetPointerN( OfxPropertySetHandle properties, const char* property, int count, void** value ){
	return getValues(getProperty!PointerProperty(properties, property), count, value);
}
OfxStatus propSetPointer( OfxPropertySetHandle properties, const char* property, int index, void* value ){
	return setValue(getProperty!PointerProperty(properties, property), index, value);
}
OfxStatus propSetPointerN( OfxPropertySetHandle properties, const char* property, int count, void** value ){
	return setValues(getProperty!PointerProperty(properties, property), count, value);
}
OfxStatus propGetString( OfxPropertySetHandle properties, const char* property, int index, char** value ){
	return getValue(getProperty!StringProperty(properties, property), index, value);
}
OfxStatus propGetStringN( OfxPropertySetHandle properties, const char* property, int count, char** value ){
	return getValues(getProperty!StringProperty(properties, property), count, value);
}
OfxStatus propSetString( OfxPropertySetHandle properties, const char* property, int index, const char* value ){
	return setValue(getProperty!StringProperty(properties, property), index, value);
}
OfxStatus propSetStringN( OfxPropertySetHandle properties, const char* property, int count, const char** value ){
	return setValues(getProperty!StringProperty(properties, property), count, value);
}
OfxStatus propGetDouble( OfxPropertySetHandle properties, const char* property, int index, double* value ){
	return getValue(getProperty!DoubleProperty(properties, property), index, value);
}
OfxStatus propGetDoubleN( OfxPropertySetHandle properties, const char* property, int count, double* value ){
	return getValues(getProperty!DoubleProperty(properties, property), count, value);
}
OfxStatus propSetDouble( OfxPropertySetHandle properties, const char* property, int index, double value ){
	return setValue(getProperty!DoubleProperty(properties, property), index, value);
}
OfxStatus propSetDoubleN( OfxPropertySetHandle properties, const char* property, int count, double* value ){
	return setValues(getProperty!DoubleProperty(properties, property), count, value);
}
OfxStatus propGetInt( OfxPropertySetHandle properties, const char* property, int index, int* value ){
	return getValue(getProperty!IntProperty(properties, property), index, value);
}
OfxStatus propGetIntN( OfxPropertySetHandle properties, const char* property, int count, int* value ){
	return getValues(getProperty!IntProperty(properties, property), count, value);
}
OfxStatus propSetInt( OfxPropertySetHandle properties, const char* property, int index, int value ){
	return setValue(getProperty!IntProperty(properties, property), index, value);
}
OfxStatus propSetIntN( OfxPropertySetHandle properties, const char* property, int count, int* value ){
	return setValues(getProperty!IntProperty(properties, property), count, value);
}

import openfx.host.host;

class PropertySuite : PropertySet, Suite {
	private OfxPropertySuiteV1 suite;
	this(){
		suite.propSetPointer   =&propSetPointer  ;
		suite.propSetString    =&propSetString   ;
		suite.propSetDouble    =&propSetDouble   ;
		suite.propSetInt       =&propSetInt      ;
		suite.propSetPointerN  =&propSetPointerN ;
		suite.propSetStringN   =&propSetStringN  ;
		suite.propSetDoubleN   =&propSetDoubleN  ;
		suite.propSetIntN      =&propSetIntN     ;
		suite.propGetPointer   =&propGetPointer  ;
		suite.propGetString    =&propGetString   ;
		suite.propGetDouble    =&propGetDouble   ;
		suite.propGetInt       =&propGetInt      ;
		suite.propGetPointerN  =&propGetPointerN ;
		suite.propGetStringN   =&propGetStringN  ;
		suite.propGetDoubleN   =&propGetDoubleN  ;
		suite.propGetIntN      =&propGetIntN     ;
		suite.propReset        =&propReset       ;
		suite.propGetDimension =&propGetDimension;
	}
	
	string suiteName() const {
		return kOfxPropertySuite;
	}
	
	int suiteVersion() const {
		return 1;
	}
	
	void* getHandle() const {
		return cast(void*)&suite;
	}
}

// testing null handle
unittest {
	assert ( propReset(null, "") == OfxStatus.kOfxStatErrBadHandle );
}

// testing bad name
unittest {
	auto p = new PropertySuite;
	assert ( propReset(&p, null) == OfxStatus.kOfxStatErrUnknown );
}

private static const string name="name";

// testing reset
unittest {
	auto s = new PropertySuite;
	auto p = new IntProperty(name,1);
	s.put(p);
	assert ( propReset(&s, name) == OfxStatus.kOfxStatOK );
	assert ( p.value.front == 0 );
}

// accessing value
unittest {
	auto s = new PropertySuite;
	auto p = new IntProperty(name,1);
	s.put(p);
	int value;
	assert ( propGetInt(&s, name, 0, &value) == OfxStatus.kOfxStatOK );
	assert ( value == 1 );
	assert ( propGetInt(&s, name, 1, &value) == OfxStatus.kOfxStatErrBadIndex );
}

// setting value
unittest {
	auto s = new PropertySuite;
	auto p = new IntProperty(name,1);
	s.put(p);
	assert ( propSetInt(&s, name, 0, 12) == OfxStatus.kOfxStatOK );
	assert ( p.value.front == 12 );
}

// setting bad index
unittest {
	auto s = new PropertySuite;
	auto p = new IntProperty(name,1);
	s.put(p);
	assert ( propSetInt(&s, name, 5, 12) == OfxStatus.kOfxStatErrBadIndex );
}
