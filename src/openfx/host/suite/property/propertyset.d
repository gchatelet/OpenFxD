module openfx.host.suite.property.propertyset;

import openfx.host.suite.property.property;
import std.exception;
import std.algorithm;

class PropertySet {
	Property[string] map;
	
	void put(Property property){
		enforce(property);
		const auto propertyName = property.name;
		enforce(propertyName !in map, new Exception("PropertySet : cannot put twice the property \""~propertyName~'"'));
		map[propertyName] = property;
	}
	
	string toString() const{
		auto keys = map.keys;
		sort(keys);
		string tostring;
		foreach(key;keys)
		tostring~=map[key].toString().dup~'\n';
		return tostring;
	}
}

import std.stdio;
unittest {
	auto p1 = new IntProperty("int",1);
	auto pSet = new PropertySet();
	pSet.put(p1);
	try{
		pSet.put(p1);
		assert(false);
	}catch(Exception){
	}
	pSet.put(new DoubleProperty("double",0));
}