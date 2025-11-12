import Foundation

/**
    Static variables are lazily initialized in swift
*/

class MyClass1 {
    static var count = 10
}

class MyClass2: MyClass1 {
    // static var count = 20

    func update() {
        MyClass1.count = 100
    }
}

MyClass2().update()

print(MyClass1.count) // count is initialized when accessed here
// print(MyClass2.count)

// static properties and methods cannot be overridden, use class properties or methods

class MyClass1 {
    class var count: Int { 10 }
}

class MyClass2: MyClass1 {
    override class var count: Int { 20 }
}

print(MyClass1.count) // count is initialized when accessed here
print(MyClass2.count)

// ----------------------- Static functions cannot be overridden, use class functions instead ------------------------------------------

class MyClass3 {
    static func myFunc() {
        print("MyClass3 myFunc")
    }
}

class MyClass4: MyClass3 {
    // override class var count: Int { 20 }

    // error: cannot override static method
    override static func myFunc() {
        print("MyClass4 myFunc")
    }
}

MyClass1.myFunc()