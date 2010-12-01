module openfx.c.core;

import openfx.c.plugincore;

extern (C) {

const {
/** @brief Action called to have a plug-in purge any temporary caches it may have allocated \ref ArchitectureMainFunction and \ref ActionsGeneralPurgeCaches */
string kOfxActionPurgeCaches                ="OfxActionPurgeCaches";

/** @brief Action called to have a plug-in sync any internal data structures into custom parameters */
string kOfxActionSyncPrivateData                ="OfxActionSyncPrivateData";

/** @brief Action indicating something in the instance has been changed, see \ref ActionsGeneralInstanceChanged */
string kOfxActionInstanceChanged="OfxActionInstanceChanged";

/** @brief Action called before the start of a set of kOfxActionEndInstanceChanged actions, used with ::kOfxActionEndInstanceChanged to bracket a grouped set of changes, see \ref ActionsGeneralInstanceChangedBeginEnd */
string kOfxActionBeginInstanceChanged="OfxActionBeginInstanceChanged";

/** @brief Action called after the end of a set of kOfxActionEndInstanceChanged actions, used with ::kOfxActionBeginInstanceChanged to bracket a grouped set of changes,  see \ref ActionsGeneralInstanceChangedBeginEnd*/
string kOfxActionEndInstanceChanged="OfxActionEndInstanceChanged";

/** @brief Action called when an instance has the first editor opened for it */
string kOfxActionBeginInstanceEdit="OfxActionBeginInstanceEdit";

/** @brief Action called when an instance has the last editor closed */
string kOfxActionEndInstanceEdit="OfxActionEndInstanceEdit";

/** @brief General property used to get/set the time of something.
 *
 *  - Type - double X 1
 *  - Default - 0, if a setable property
 *  - Property Set - commonly used as an argument to actions, input and output.
 */
string kOfxPropTime="OfxPropTime";

/** @brief Indicates if a host is actively editing the effect with some GUI.
 *
 *  - Type - int X 1
 *  - Property Set - effect instance (read only)
 *  - Valid Values - 0 or 1
 *
 * If false the effect currently has no interface, however this may be because the effect is loaded in a background render host, or it may be loaded on an interactive host that has not yet opened an editor for the effect.
 *
 * The output of an effect should only ever depend on the state of it's parameters, not on the interactive flag. The interactive flag is more a courtesy flag to let a plugin know that it has an interace. If a plugin want's to have its behaviour dependant on the interactive flag, it can always make a secret parameter which shadows the state if the flag.
 */
string kOfxPropIsInteractive="OfxPropIsInteractive";

/** @brief The file path to the plugin.
 *
 *  - Type - C string X 1
 *  - Property Set - effect descriptor (read only)
 *
 * This is a string that indicates the file path where the plug-in was found by the host. The path is in the native
 * path format for the host OS (eg:  UNIX directory separators are forward slashes, Windows ones are backslashes).
 *
 * The path is to the bundle location, see \ref InstallationLocation.
 * eg:  '/usr/OFX/Plugins/AcmePlugins/AcmeFantasticPlugin.ofx.bundle'
 */
string kOfxPluginPropFilePath="OfxPluginPropFilePath";

/** @brief  A private data pointer that the plug-in can store it's own data behind.
 *
 *  - Type - pointer X 1
 *  - Property Set - plugin instance (read/write),
 *  - Default - NULL
 *
 * This data pointer is unique to each plug-in instance, so two instances of the same plug-in do not share the same data pointer. Use it to hang any needed private data structures.
 */
string kOfxPropInstanceData="OfxPropInstanceData";

/** @brief General property, used to identify the kind of an object behind a handle
 *
 *  - Type - ASCII C string X 1
 *  - Property Set - any object handle (read only)
 *  - Valid Values - currently this can be...
 *     - ::kOfxTypeImageEffectHost
 *     - ::kOfxTypeImageEffect
 *     - ::kOfxTypeImageEffectInstance
 *     - ::kOfxTypeParameter
 *     - ::kOfxTypeParameterInstance
 *     - ::kOfxTypeClip
 *     - ::kOfxTypeImage
 */
string kOfxPropType="OfxPropType";

/** @brief Unique name of an object.
 *
 *  - Type - ASCII C string X 1
 *  - Property Set - on many objects (descriptors and instances), see \ref PropertiesByObject (read only)
 *
 * This property is used to label objects uniquely amoung objects of that type. It is typically set when a plugin creates a new object with a function that takes a name.
 */
string kOfxPropName="OfxPropName";

/** @brief User visible name of an object.
 *
 *  - Type - UTF8 C string X 1
 *  - Property Set - on many objects (descriptors and instances), see \ref PropertiesByObject. Typically readable and writable in most cases.
 *  - Default - the ::kOfxPropName the object was created with.
 *
 * The label is what a user sees on any interface in place of the object's name.
 *
 * Note that resetting this will also reset ::kOfxPropShortLabel and ::kOfxPropLongLabel.
 */
string kOfxPropLabel="OfxPropLabel";

/** @brief Short user visible name of an object.
 *
 *  - Type - UTF8 C string X 1
 *  - Property Set - on many objects (descriptors and instances), see \ref PropertiesByObject. Typically readable and writable in most cases.
 *  - Default - initially ::kOfxPropName, but will be reset if ::kOfxPropLabel is changed.
 *
 * This is a shorter version of the label, typically 13 character glyphs or less. Hosts should use this if they have limitted display space for their object labels.
 */
string kOfxPropShortLabel="OfxPropShortLabel";

/** @brief Long user visible name of an object.
 *
 *  - Type - UTF8 C string X 1
 *  - Property Set - on many objects (descriptors and instances), see \ref PropertiesByObject. Typically readable and writable in most cases.
 *  - Default - initially ::kOfxPropName, but will be reset if ::kOfxPropLabel is changed.
 *
 * This is a longer version of the label, typically 32 character glyphs or so. Hosts should use this if they have mucg display space for their object labels.
 */
string kOfxPropLongLabel="OfxPropLongLabel";

/** @brief Indicates why a plug-in changed.
 *
 *  - Type - ASCII C string X 1
 *  - Property Set - the inArgs parameter on the ::kOfxActionInstanceChanged action.
 *  - Valid Values - this can be...
 *     - ::kOfxChangeUserEdited - the user directly edited the instance somehow and caused a change to something, this includes undo/redos and resets
 *     - ::kOfxChangePluginEdited - the plug-in itself has changed the value of the object in some action
 *     - ::kOfxChangeTime - the time has changed and this has affected the value of the object because it varies over time
 *
 * Argument property for the ::kOfxActionInstanceChanged action.
 */
string kOfxPropChangeReason="OfxPropChangeReason";

/** @brief A pointer to an effect instance.
 *
 *  - Type - pointer X 1
 *  - Property Set - on an interact instance (read only)
 *
 * This property is used to link an object to the effect. For example if the plug-in supplies an openGL overlay for an image effect,
 * the interact instance will have one of these so that the plug-in can connect back to the effect the GUI links to.
 */
string kOfxPropEffectInstance="OfxPropEffectInstance";

/** @brief String used as a value to ::kOfxPropChangeReason to indicate a user has changed something */
string kOfxChangeUserEdited="OfxChangeUserEdited";

/** @brief String used as a value to ::kOfxPropChangeReason to indicate the plug-in itself has changed something */
string kOfxChangePluginEdited="OfxChangePluginEdited";

/** @brief String used as a value to ::kOfxPropChangeReason to a time varying object has changed due to a time change */
string kOfxChangeTime="OfxChangeTime";

}

/** @brief How time is specified within the OFX API */
alias double OfxTime;

/** @brief Defines one dimensional integer bounds */
struct OfxRangeI
{
	int min, max;
};

/** @brief Defines one dimensional double bounds */
struct OfxRangeD
{
	double min, max;
};

/** @brief Defines two dimensional integer point */
struct OfxPointI
{
	int x, y;
};

/** @brief Defines two dimensional double point */
struct OfxPointD
{
	double x, y;
};

/** @brief Used to flag infinite rects. Set minimums to this to indicate infinite
 *
 */
int kOfxFlagInfiniteMax=int.max;

/** @brief Used to flag infinite rects. Set minimums to this to indicate infinite.
 *
 */
int kOfxFlagInfiniteMin=int.min;

/** @brief Defines two dimensional integer region
 *
 * Regions are x1 <= x < x2
 *
 * Infinite regions are flagged by setting
 * - x1 = kOfxFlagInfiniteMin
 * - y1 = kOfxFlagInfiniteMin
 * - x2 = kOfxFlagInfiniteMax
 * - y2 = kOfxFlagInfiniteMax
 *
 */
struct OfxRectI
{
	int x1, y1, x2, y2;
};

/** @brief Defines two dimensional double region
 *
 * Regions are x1 <= x < x2
 *
 * Infinite regions are flagged by setting
 * - x1 = kOfxFlagInfiniteMin
 * - y1 = kOfxFlagInfiniteMin
 * - x2 = kOfxFlagInfiniteMax
 * - y2 = kOfxFlagInfiniteMax
 *
 */
struct OfxRectD
{
	double x1, y1, x2, y2;
};

/** @brief Defines an 8 bit per component RGBA pixel */
struct OfxRGBAColourB
{
	ubyte r, g, b, a;
};

/** @brief Defines a 16 bit per component RGBA pixel */
struct OfxRGBAColourS
{
	ushort r, g, b, a;
};

/** @brief Defines a floating point component RGBA pixel */
struct OfxRGBAColourF
{
	float r, g, b, a;
};

/** @brief Defines a double precision floating point component RGBA pixel */
struct OfxRGBAColourD
{
	double r, g, b, a;
};

/** @brief Defines an 8 bit per component RGB pixel
 *
 * Should migrate this to the ofxCore.h in a v1.1
 */
struct OfxRGBColourB
{
	ubyte r, g, b;
};

/** @brief Defines a 16 bit per component RGB pixel
 *
 * Should migrate this to the ofxCore.h in a v1.1
 */
struct OfxRGBColourS
{
	ushort r, g, b;
};

/** @brief Defines a floating point component RGB pixel
 *
 * Should migrate this to the ofxCore.h in a v1.1
 */
struct OfxRGBColourF
{
	float r, g, b;
};

/** @brief Defines a double precision floating point component RGB pixel
 *
 * Should migrate this to the ofxCore.h in a v1.1
 */
struct OfxRGBColourD
{
	double r, g, b;
};

/** @brief Defines an integer 3D point
 *
 * Should migrate this to the ofxCore.h in a v1.1
 */
struct Ofx3DPointI
{
	int x, y, z;
};

/** @brief Defines a double precision 3D point
 *
 * Should migrate this to the ofxCore.h in a v1.1
 */
struct Ofx3DPointD
{
	double x, y, z;
};

/** @brief Defines an 8 bit per component YUVA pixel */
struct OfxYUVAColourB
{
	ubyte y, u, v, a;
};

/** @brief Defines an 16 bit per component YUVA pixel */
struct OfxYUVAColourS
{
	ushort y, u, v, a;
};

/** @brief Defines an floating point component YUVA pixel */
struct OfxYUVAColourF
{
	float y, u, v, a;
};

/** @brief String used to label unset bitdepths */
string kOfxBitDepthNone="OfxBitDepthNone";

/** @brief String used to label unsigned 8 bit integer samples */
string kOfxBitDepthByte="OfxBitDepthByte";

/** @brief String used to label unsigned 16 bit integer samples */
string kOfxBitDepthShort="OfxBitDepthShort";

/** @brief String used to label signed 32 bit floating point samples */
string kOfxBitDepthFloat="OfxBitDepthFloat";

}