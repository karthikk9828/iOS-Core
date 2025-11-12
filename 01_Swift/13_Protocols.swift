
/*
    we need to mentions get / set explicitly in protocol properties
    protocols cannot have stored properties or any type of implementation, this can be done using extensions

*/

protocol Shape {
    var edges: Int {get set}
    // var shape: String { return edges == 3 ? "Triangle" : "Quadrilateral"} // does not work
}

// extension can have computed properties, but cannot have stored properties

extension Shape {
    var shape: String { return edges == 3 ? "Triangle" : "Quadrilateral"} 
}

// How to allow only classes conform to protocol?

protocol ClassOnly : class {} // deprecated
// or
protocol ClassOnly : AnyObject {}

class MyClass : ClassOnly {} // works

struct MyStruct : ClassOnly {} // error
