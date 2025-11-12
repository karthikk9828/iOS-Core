
// Difference between Variable, Optional, Implicitly unwrapped optional

var a: String = "hello" // Variable, cannot contain nil
var b: String? // Optional, can contain nil
var c: String! // Implicitly unwrapped Optional, can contain nil

print(a)
print(b!) // error
print(c) // prints nil

a = "hello updated"
b = nil
c = nil

c = "hey"

// Use var c: String! when we are sure that at some point we will assign a value to 'c' before accessing it,
// we are certain that 'c' will not contain nil when we access it
// Used in IB outlets -> because when the viewcontroller is initialized, the outlets may not have been set
// will be set later by xcode 

class Hello {
    func printHello() {
        print("hello")
    }
}

var hello: Hello! // implicitly unwrapped
hello.printHello() // hello is not initialized, so this will cause fatal error