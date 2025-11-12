
import Foundation

struct User: Codable {
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

let jsonData = """
{
    "first_name": "John",
    "last_name": "Wick"
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let user = try! decoder.decode(User.self, from: jsonData)
print(user)
