module openfx.host.suite.exception;

import openfx.c.plugincore;
import std.exception;
import std.conv;
import std.stdio;

final class SuiteException : Exception {
	const OfxStatus status;
	this(OfxStatus status, string message){
		super(message~" - returning "~.toString(status));
		this.status = status;
	}
}

OfxStatus check(void delegate() f){
	try{
		f();
		return kOfxStatOK;
	} catch(SuiteException e){
		writeln(e.msg);
		return e.status;
	} catch(Exception e){
		writeln(e);
		return kOfxStatErrFatal;
	}
}