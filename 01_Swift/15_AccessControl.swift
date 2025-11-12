
/**

Swift provides five access control levels:

    1. Open: Entities marked as open can be subclassed or overridden outside the module where they're defined. 
             This access level is typically used for public APIs that need to be subclassed or overridden by clients.

    2. Public: Entities marked as public can be accessed from any source file in their defining module, 
               and they can also be accessed from other modules that import the defining module. 
               However, they cannot be subclassed or overridden outside the module.

    3. Internal: Entities marked as internal can be accessed from any source file within the same module. 
                 This is the default access level if you don't specify an access level explicitly.

    4. File-private: Entities marked as fileprivate can only be accessed from within the same source file where they're defined.

    5. Private: Entities marked as private can only be accessed from within the same declaration context. 
                This means they're accessible only from within the same enclosing scope, such as a type declaration or an extension.

*/

open class SomeOpenClass {}
public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

open var someOpenVariable = 0
public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}

class Test {
    fileprivate let val = 10
}

print(Test().val)

class Another {
    func test() {
        print(Test().val)
    }
}

// Extensions can access private methods and properties if the extension are in the same file

class ViewController {
    private var value: Int = 10

    private func myPrivateFunction() {

    }
}

extension ViewController {
    func setData() {
        print(value)
        myPrivateFunction()
    }
}