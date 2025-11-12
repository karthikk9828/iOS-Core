
import Foundation

/**
    Swift actors are a new concurrency feature introduced in Swift 5.5 (iOS 15) and later
    that provide a safe and efficient way to manage shared mutable state. 
    Actors are a type of object that can be accessed concurrently from multiple threads, 
    but ensure that access to their mutable state is serialized and thread-safe. 

    Note:
        * Actors do not support inheritence.
        * Properties and methods of actor can be accessed using `await` keyword.
*/

actor Logger {
    let id = UUID()

    func log(_ message: String) {
        print("(\(id)) \(message)")
    }

    nonisolated func info(_ message: String) {
        print("INFO: \(message)")
    }
}

let logger = Logger()

Task {
    await logger.log("Actor-isolated function")  // ✅ needs await
}

logger.info("Non-isolated function")  // ✅ no await needed


actor User {
    var score = 10

    func printScore() {
        print("My score is \(score)")
    }

    func copyScore(from other: User) async {
        score = await other.score
    }
}

let actor1 = User()
let actor2 = User()

print(await actor1.score)
// await actor1.copyScore(from: actor2)

struct Person {
    var name: String
    var age: Int
}

let john = Person(name: "John", age: 30)

// Define a key path to the 'name' property of the Person struct
let nameKeyPath = \Person.name
