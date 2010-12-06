module openfx.c.memorysuite;

import openfx.c.plugincore;

extern(C) {
	
	const string kOfxMemorySuite="OfxMemorySuite";
	
	/** @brief The OFX suite that implements general purpose memory management.
	 *
	 * Use this suite for ordinary memory management functions, where you would normally use malloc/free or new/delete on ordinary objects.
	 *
	 * For images, you should use the memory allocation functions in the image effect suite, as many hosts have specific image memory pools.
	 *
	 * \note C++ plugin developers will need to redefine new and delete as skins ontop of this suite.
	 */
	struct OfxMemorySuiteV1
	{
		/** @brief Allocate memory.
		 *
		 * \arg handle	- effect instance to assosciate with this memory allocation, or NULL.
		 * \arg nBytes        - the number of bytes to allocate
		 * \arg allocatedData - a pointer to the return value. Allocated memory will be alligned for any use.
		 *
		 * This function has the host allocate memory using it's own memory resources
		 * and returns that to the plugin.
		 *
		 * @returns
		 * - ::kOfxStatOK the memory was sucessfully allocated
		 * - ::kOfxStatErrMemory the request could not be met and no memory was allocated
		 *
		 */
		OfxStatus function( void*  handle,
		                            size_t nBytes,
		                            void** allocatedData )memoryAlloc;
	
		/** @brief Frees memory.
		 *
		 * \arg allocatedData - pointer to memory previously returned by OfxMemorySuiteV1::memoryAlloc
		 *
		 * This function frees any memory that was previously allocated via OfxMemorySuiteV1::memoryAlloc.
		 *
		 * @returns
		 * - ::kOfxStatOK the memory was sucessfully freed
		 * - ::kOfxStatErrBadHandle \e allocatedData was not a valid pointer returned by OfxMemorySuiteV1::memoryAlloc
		 *
		 */
		OfxStatus function( void* allocatedData )memoryFree;
	};
}