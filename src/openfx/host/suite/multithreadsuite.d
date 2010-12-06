module openfx.host.suite.multithreadsuite;

import openfx.c.plugincore;
import openfx.c.multithreadsuite;

import openfx.host.host;

extern(C){
	
	OfxStatus multiThread( OfxThreadFunctionV1 func, const uint  nThreads, void* customArg ){
		return kOfxStatFailed;
	}
	OfxStatus multiThreadNumCPUs( const uint* nCPUs ){
		return kOfxStatFailed;
	}
	OfxStatus multiThreadIndex( const uint* threadIndex ){
		return kOfxStatFailed;
	}
	int multiThreadIsSpawnedThread(){
		return 0;
	}
	OfxStatus mutexCreate( OfxMutexHandle* mutex, const int lockCount ){ ///@todo; ofxtuttle fix: no const on mutex
		return kOfxStatFailed;
	}
	OfxStatus mutexDestroy( OfxMutexHandle mutex ){ ///@todo; ofxtuttle fix: no const on mutex
		return kOfxStatFailed;
	}
	OfxStatus mutexLock( OfxMutexHandle mutex ){ ///@todo; ofxtuttle fix: no const on mutex
		return kOfxStatFailed;
	}
	OfxStatus mutexUnLock( OfxMutexHandle mutex ){ ///@todo; ofxtuttle fix: no const on mutex
		return kOfxStatFailed;
	}
	OfxStatus mutexTryLock( OfxMutexHandle mutex ){ ///@todo; ofxtuttle fix: no const on mutex
		return kOfxStatFailed;
	}

}

class MultithreadSuite : Suite {
	private OfxMultiThreadSuiteV1 suite;
	this(){
		suite.multiThread               	  = &multiThread;
		suite.multiThreadNumCPUs        	  = &multiThreadNumCPUs;
		suite.multiThreadIsSpawnedThread      = &multiThreadIsSpawnedThread;   
		suite.mutexCreate                     = &mutexCreate;                  
		suite.mutexDestroy                    = &mutexDestroy;                 
		suite.mutexLock                       = &mutexLock;                    
		suite.mutexUnLock                     = &mutexUnLock;                  
		suite.mutexTryLock                    = &mutexTryLock;
	}
	
	string suiteName() const {
		return kOfxMultiThreadSuite;
	}
	
	int suiteVersion() const {
		return 1;
	}
	
	void* getHandle() const {
		return cast(void*)&suite;
	}
}