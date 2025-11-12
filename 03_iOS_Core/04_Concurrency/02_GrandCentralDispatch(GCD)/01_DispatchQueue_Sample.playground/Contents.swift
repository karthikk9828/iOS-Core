import Foundation

var counter = 1

// this task is submitted to the main (serial queue) first asynchronously, it will not block the execution
DispatchQueue.main.async {
    for i in 0 ... 3 {
        counter = i
        print(counter)
    }
}

// this is not in any queue, will be executed first
for i in 4 ... 6 {
    counter = i
    print(counter)
}

// this task is submitted to the main (serial queue) second asynchronously, it will not block the execution
DispatchQueue.main.async {
    counter = 9
    print(counter)
}

// Output: 4 5 6 0 1 2 3 9
