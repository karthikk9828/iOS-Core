

class SomeClass {
    var completionHandler: (() -> Void)?

    func doSomething(completion: @escaping () -> Void) {
        // Store the closure for later execution
        completionHandler = completion

        // Perform some asynchronous operation
        // ...
    }

    func finishOperation() {
        print("finishOperation")
        completionHandler!()
    }

    // non-escaping, all closures are by default non-escaping, it will be executed when the function body is executed
    func doSomething2(completion: () -> Void) {
        completion()

        // Perform some asynchronous operation
        // ...
    }

    // No need to mark optional closures as @escaping
    func doSomething3(completion: (() -> Void)?) {
        // Store the closure for later execution
        completionHandler = completion

        // Perform some asynchronous operation
        // ...
    }
}

let instance = SomeClass()
instance.doSomething {
    print("Completed")
}

// The closure is called later, after the asynchronous operation is finished
instance.finishOperation()

instance.doSomething2 {
    print("doSomething2")
}

instance.doSomething3 {
    print("doSomething3")
}

instance.finishOperation()