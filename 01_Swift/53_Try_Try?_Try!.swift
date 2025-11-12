import Foundation

/**
1. try? 
    - Ignore the errors thrown
    - Don't need to handle errors thrown
    - Use it when we are not inside a do/catch block
*/

func test() throws -> String {
    let throwError = false
    if throwError {
        throw URLError(.badURL)
    }

    return "hello"
}

let res = try? test() // res is optional, will be nil if error is thrown
print(res)

/**
1. try
    - Need to handle errors thrown
    - Use it when we are inside a do/catch block
*/

do {
    let res = try test() // res is not optional
    print(res)
} catch {
    print(error)
}

/**
1. try!
    - Assumes no errors will be thrown
    - Can crash if error is thrown
*/

let res1 = try! test() // res1 is not optional, crashes if error is thrown
print(res1)