# 🧩 Stack vs Heap in Swift (and iOS)

Both **Stack** and **Heap** are regions of memory managed by your app’s process —  
but they differ in **lifetime, ownership, access speed, and memory management**.

---

## 🧱 1️⃣ Stack Memory

### ✅ Used for:
- Storing *value types* (`Int`, `Struct`, `Enum`, `Bool`)
- Function calls, local variables, and parameters
- Temporary storage that disappears when a function returns

### ✅ Managed by:
- The system (automatically, very fast — LIFO order)

### ✅ Allocation / Deallocation:
- Automatic  
- Happens when entering/exiting a function or scope

### ✅ Access speed:
- Very fast (directly managed by CPU)

### ✅ Example:
```swift
struct Point {
    var x: Int
    var y: Int
}

func draw() {
    var p1 = Point(x: 10, y: 20)  // stored on Stack
    print(p1.x)
} // p1 is automatically destroyed here

💾 2️⃣ Heap Memory
✅ Used for:

Reference types — classes, closures, actors, etc.

Objects that need to live beyond the current function’s scope

Data shared between multiple owners

✅ Managed by:

ARC (Automatic Reference Counting) in Swift

✅ Allocation / Deallocation:

Manual (ARC keeps track of retain counts)

Freed when reference count drops to 0

✅ Access speed:

Slower (involves pointer dereferencing)

✅ Example:

class Person {
    var name: String
    init(name: String) { self.name = name }
}

func test() {
    let p = Person(name: "Karthik")  // stored on Heap
    print(p.name)
} // p’s reference goes out of scope -> ARC decrements count -> object may be freed

Here:
    - p (the reference) lives on the stack
    - The actual Person instance lives on the heap

⚙️ ARC Example

class Car { }

var car1: Car? = Car()
var car2 = car1
car1 = nil
car2 = nil // only now Car is deallocated (retain count 0)

ARC increments/decrements reference counts to manage heap memory automatically.


🧠 Key Differences

| Feature           | **Stack**                                   | **Heap**                           |
| ----------------- | ------------------------------------------- | ---------------------------------- |
| **Stores**        | Value types, local variables                | Reference types, class instances   |
| **Managed by**    | System automatically                        | ARC (Automatic Reference Counting) |
| **Lifetime**      | Until function/scope ends                   | Until no strong references remain  |
| **Access speed**  | Very fast                                   | Slower                             |
| **Memory size**   | Smaller                                     | Larger                             |
| **Thread safety** | Thread-safe (each thread has its own stack) | Must be synchronized manually      |
| **Example Types** | `Int`, `Struct`, `Enum`, `Tuple`            | `Class`, `Closure`, `Actor`        |


⚡️ Example Combining Both

struct Point { var x: Int; var y: Int }   // Value type
class Shape { var point = Point(x: 0, y: 0) }  // Reference type

let rect = Shape()  // rect lives on stack, Shape instance on heap
rect.point.x = 5     // Point struct copied on stack inside heap object

Here:
    - rect (reference) is on stack
    - Shape instance is on heap

Inside that heap object, the value type (Point) is stored inline

🚀 Optimization Tip

Swift may optimize small value types (like structs) to avoid copying via compiler optimizations (Copy-on-Write, etc.), but conceptually:

Value types → stack

Reference types → heap

