module openfx.c.propertysuite;

import openfx.c.plugincore;
import openfx.c.core;

const string kOfxPropertySuite="OfxPropertySuite";

extern (C) struct OfxPropertySuiteV1
{
	/** @brief Set a single value in a pointer property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index is for multidimenstional properties and is dimension of the one we are setting
	 *  @param value is the value of the property we are setting
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 */
	OfxStatus function ( OfxPropertySetHandle properties, const char* property, int index, void* value ) propSetPointer;

	/** @brief Set a single value in a string property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index is for multidimenstional properties and is dimension of the one we are setting
	 *  @param value is the value of the property we are setting
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 */
	OfxStatus function ( OfxPropertySetHandle properties, const char* property, int index, const char* value ) propSetString;

	/** @brief Set a single value in a double property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index is for multidimenstional properties and is dimension of the one we are setting
	 *  @param value is the value of the property we are setting
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int index, double value ) propSetDouble;

	/** @brief Set a single value in  an int property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index is for multidimenstional properties and is dimension of the one we are setting
	 *  @param value is the value of the property we are setting
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int index, int value ) propSetInt;

	/** @brief Set multiple values of the pointer property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are setting in that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, void** value ) propSetPointerN;

	/** @brief Set multiple values of a string property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are setting in that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, const char** value ) propSetStringN;

	/** @brief Set multiple values of  a double property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are setting in that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 *
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, double* value ) propSetDoubleN;

	/** @brief Set multiple values of an int property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are setting in that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 *    - ::kOfxStatErrValue
	 *
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, int* value ) propSetIntN;

	/** @brief Get a single value from a pointer property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index refers to the index of a multi-dimensional property
	 *  @param value is a pointer the return location
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int index, void** value ) propGetPointer;

	/** @brief Get a single value of a string property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index refers to the index of a multi-dimensional property
	 *  @param value is a pointer the return location
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int index, char** value ) propGetString;

	/** @brief Get a single value of a double property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index refers to the index of a multi-dimensional property
	 *  @param value is a pointer the return location
	 *
	 *  See the note \ref ArchitectureStrings for how to deal with strings.
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int index, double* value ) propGetDouble;

	/** @brief Get a single value of an int property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param index refers to the index of a multi-dimensional property
	 *  @param value is a pointer the return location
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int index, int* value ) propGetInt;

	/** @brief Get multiple values of a pointer property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are getting of that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of where we will return the property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, void** value ) propGetPointerN;

	/** @brief Get multiple values of a string property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are getting of that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of where we will return the property values
	 *
	 *  See the note \ref ArchitectureStrings for how to deal with strings.
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, char** value ) propGetStringN;

	/** @brief Get multiple values of a double property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are getting of that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of where we will return the property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, double* value ) propGetDoubleN;

	/** @brief Get multiple values of an int property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property
	 *  @param count is the number of values we are getting of that property (ie: indicies 0..count-1)
	 *  @param value is a pointer to an array of where we will return the property values
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 *    - ::kOfxStatErrBadIndex
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int count, int* value ) propGetIntN;

	/** @brief Resets all dimensions of a property to it's default value
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property we are resetting
	 *
	 *  @returns
	 *    - ::kOfxStatOK
	 *    - ::kOfxStatErrBadHandle
	 *    - ::kOfxStatErrUnknown
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property ) propReset;

	/** @brief Gets the dimension of the property
	 *
	 *  @param properties is the handle of the thing holding the property
	 *  @param property is the string labelling the property we are resetting
	 *  @param count is a pointer to an integer where the value is returned
	 *
	 * @returns
	 *  - ::kOfxStatOK
	 *  - ::kOfxStatErrBadHandle
	 *  - ::kOfxStatErrUnknown
	 */
	OfxStatus function( OfxPropertySetHandle properties, const char* property, int* count ) propGetDimension;
};
