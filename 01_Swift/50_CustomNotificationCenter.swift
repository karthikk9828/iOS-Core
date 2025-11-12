
protocol NotificationCenterProtocol { 
	func subscribe(on notificationName: String, observer: AnyObject, block: () -> Void)
	func unsubscribe(observer: AnyObject, notificationName: String)
	
	func postNotification(_ notificationName: String) // Invokes all blocks subscribed to this notification
}

class Observer {
    var observer: AnyObject
    var block: () -> Void

    init(_ observer: AnyObject, _ block: () -> Void) {
        self.observer = observer
        self.block = block
    }
}

class NotificationCenter: NotificationCenterProtocol {

    private var subscribers: [String: [Observer]] = []

    private var semaphore = DispatchSemaphore(value: 1)

    func subscribe(on notificationName: String, observer: AnyObject, block: @escaping () -> Void) {
        semaphore.wait()

        defer {
            semaphore.signal()
        }

        if var currentSubscribers = subscribers[notificationName] {
            let observer = Observer(observer, block)
            currentSubscribers.append(observer)
            subscribers[notificationName] = currentSubscribers
        } else {
            let observer = Observer(observer, block)
            subscribers[notificationName] = [observer]
        }
    }

    func unsubscribe(observer: AnyObject, notificationName: String) {
        semaphore.wait()

        defer {
            semaphore.signal()
        }
        
        if var currentSubscribers = subscribers[notificationName] { 
            currentSubscribers = currentSubscribers.filter { $0.observer !== observer }
            subscribers[notificationName] = currentSubscribers
        }
    }

    func postNotification(_ notificationName: String) {
        if let currentSubscribers = subscribers[notificationName] { 
            for sub in currentSubscribers {
                sub.block()
            }
        }
    }
}