
import Foundation

/**
    Async Await is a new concurrency feature introduced in Swift 5.5 (iOS 15) and later   
*/

struct GitHubUser: Codable {
    let avatar_url: String
    let bio: String
}

func fetchData() async throws -> GitHubUser {
    let url = URL(string: "https://api.github.com/users/karthikk9828")!
    let (data, response) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(GitHubUser.self, from: data)
}

do {
    let data = try await fetchData()
    print(data)
} catch {
    print(error)
}

// ------------------------- Serial API Calls ---------------------------------------

func fetchFirstData() async throws -> String { "data1" }

func fetchSecondData() async throws -> String { "data2" }

func performSerialApiCalls() async {
    do {
        let firstData = try await fetchFirstData()
        print("First data fetched: \(firstData)")
        
        let secondData = try await fetchSecondData()
        print("Second data fetched: \(secondData)")
    } catch {
        print("Error: \(error)")
    }
}

Task {
    await performSerialApiCalls()
}


// ------------------------- Parellel API Calls ---------------------------------------

func performConcurrentApiCalls() async {
    async let firstData = fetchFirstData()
    async let secondData = fetchSecondData()
    
    do {
        let results = try await [firstData, secondData]
        print("API call results: \(results)")
    } catch {
        print("Error: \(error)")
    }
}

Task {
    await performConcurrentApiCalls()
}