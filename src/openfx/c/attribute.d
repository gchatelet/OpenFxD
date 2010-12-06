module openfx.c.attribute;

extern(C){

/**
 * @brief Blind declaration of an OFX param
 */
alias void* OfxAttributeHandle;

/**
 * @brief Blind declaration of an OFX parameter set
 */
alias void* OfxAttributeSetHandle;

/**
 * @defgroup ParamTypeDefines Parameter Type definitions
 * These strings are used to identify the type of the attribute.
 */
///@{
const{
/** @brief String to identify an attribute as a parameter */
	string kOfxAttributeTypeParam="OfxAttributeTypeParam";
/** @brief String to identify an attribute as a clip */
	string kOfxAttributeTypeClip="OfxAttributeTypeClip";

/** @brief String that is the name of the standard OFX output attribute */
	string kOfxOutputAttributeName="Output";

/** @brief String that is the name of the standard OFX single source input attribute */
	string kOfxSimpleSourceAttributeName="Source";
}

}