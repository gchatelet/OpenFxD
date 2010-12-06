module openfx.host.imageeffecthost;

import openfx.host.host;
import openfx.c.core;
import openfx.c.parametersuite;
import openfx.c.imageeffectsuite;
import openfx.host.suite.property.property;

abstract class ImageEffectHost : BasicHost {
	this(Suite[] suites){
		super(suites);
		putString(kOfxPropName, "Image Effect Host");
		putInt(kOfxImageEffectHostPropIsBackground, 0);
		putInt(kOfxImageEffectPropSupportsOverlays, 0);
		putInt(kOfxImageEffectPropSupportsMultiResolution, 0);
		putInt(kOfxImageEffectPropSupportsTiles, 0);
		putInt(kOfxImageEffectPropTemporalClipAccess, 0);
		putInt(kOfxImageEffectPropSupportsMultipleClipDepths, 0);
		putInt(kOfxImageEffectPropSupportsMultipleClipPARs, 0);
		putInt(kOfxImageEffectPropSetableFrameRate, 0);
		putInt(kOfxImageEffectPropSetableFielding, 0);
		putInt(kOfxParamHostPropSupportsStringAnimation, 1);
		putInt(kOfxParamHostPropSupportsCustomInteract, 0);
		putInt(kOfxParamHostPropSupportsChoiceAnimation, 0);
		putInt(kOfxParamHostPropSupportsBooleanAnimation, 1);
		putInt(kOfxParamHostPropSupportsCustomAnimation, 0);
		putInt(kOfxParamHostPropMaxParameters, 0);
		putInt(kOfxParamHostPropMaxPages, 0);
		put(new IntProperty( kOfxParamHostPropPageRowColumnCount, [0,0]));
		// adding the supported components type
		put(new StringProperty(kOfxImageEffectPropSupportedComponents,
			[ 	kOfxImageComponentNone,  kOfxImageComponentRGBA,
		    	kOfxImageComponentRGB, kOfxImageComponentAlpha ]));
		// the plugin should set this one
		putString(kOfxImageEffectPropSupportedContexts, "");
	}
}