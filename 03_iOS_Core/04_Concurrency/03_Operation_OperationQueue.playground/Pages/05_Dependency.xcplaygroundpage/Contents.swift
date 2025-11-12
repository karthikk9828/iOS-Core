import Foundation

/*
    Operations can depend on other operations
    this feature is not available in GCD, only in Operations
*/

func testOperations() {
    let operationQueue: OperationQueue = OperationQueue()
    // even though we allow multiple concurrent ops, since we have dependency, it waits for that op to finish
    operationQueue.maxConcurrentOperationCount = 2
    
    let operation1: BlockOperation = BlockOperation()
    operation1.addExecutionBlock {
        for i in 1 ... 10 {
            print("operation1 print \(i)")
        }
    }
    operation1.completionBlock = {
        print("operation1 finished executed")
    }
    
    let operation2: BlockOperation = BlockOperation()
    operation2.addExecutionBlock {
        // this is synchronous code, the dependency will work, for async code check 06_DependecyAsync
        for i in 11 ... 20 {
            print("operation2 print \(i)")
        }
    }
    operation2.completionBlock = {
        print("operation2 finished executed")
    }
    
    // add dependency
    // operation2 should wait till the time operation1 is finished executing
    operation2.addDependency(operation1)
    
    operationQueue.addOperation(operation1)
    operationQueue.addOperation(operation2)
}

testOperations()
print("executed all operation")
