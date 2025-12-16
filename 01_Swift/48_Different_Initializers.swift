import Foundation

/**
    1. Designated initializers
        - Are the primary initializers
        - structs have designated initializers by default, for classes we have to define them
        - we can have one or more designated initializers
*/

class Person {
    var name: String

    init(name: String) {
        self.name = name
    }
}

let person = Person(name: "Peter")

/**
    2. Convenience initializers
        - Are the secondary initializers
        - we can call a designated init from inside convenience init
        - If we want to pass only some values to the init and give default values for other properties, we can use this.
        - we can have one or more designated initializers
*/

class Employee {
    var name: String
    var country: String 

    init(name: String, country: String) {
        self.name = name
        self.country = country
    }

    convenience init(name: String) {
        self.init(name: name, country: "India")
    }
}

let emp1 = Employee(name: "John", country: "India")
let emp2 = Employee(name: "John") // using convenience initializer

/**
    3. Failable initializers
        - Used when the initialization can fail
        - used when we don't always want to return the object, return nil if some condition fails
        - use "?" after init keyword ("init?()")
*/

class Student {
    var name: String

    init?(name: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}

let stu1 = Student(name: "")
print(stu1)

/**
    4. Required initializers
        - is an initializer we must implement if we are subclassing
*/

class Animal {
    var name: String
    
    required init(name: String) {
        self.name = name
    }
}

class Dog: Animal {
    var breed: String
    
    required init(name: String) {
        self.breed = "Unknown"
        super.init(name: name)
    }
    
    init(name: String, breed: String) {
        self.breed = breed
        super.init(name: name)
    }
}

let dog = Dog(name: "Rover")
print(dog.name) 
print(dog.breed)
