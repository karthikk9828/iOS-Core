
import Foundation

/*
 Difference between structs and classes as mentioned above
    1. class will not have a default initializer with its member variables, struct will have one
    2. classes are reference types, if both objects are equal, modifying one object will modify others as well. 
       structs are value types, structs modifying one will not change the other.
    3. Class will have access deinit{} method which will be called when the object is destoyed, structs do not have access to deinit {}.
    4. Classes let us change properties of the instance even if the instance is a constant, struct will not allow this
    5. Objective-C code can be written in classes but not in structs.
    6. Each thread will have its own stack, therefore structs are threadsafe. Classes types are not thread-safe
    7. Classes support inheritence, structs don't support inheritence.
 */

class Car {
    var year: Int 
    var make: String 
    var color: String 

    init(year: Int, make: String, color: String) {
        self.year = year
        self.make = make
        self.color = color
    }
}

var myCar = Car(year: 2024, make: "Porsche", color: "Grey")
var stolenCar = myCar

stolenCar.color = "Yellow" 
print(myCar.color) // Yellow

struct Bike {
    var year: Int 
    var make: String 
    var color: String 
}

var myBike = Bike(year: 2024, make: "Yamaha", color: "Black")
var stolenBike = myBike

stolenBike.color = "Yellow" 
print(myBike.color) // Black