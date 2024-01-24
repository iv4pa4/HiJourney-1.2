import SwiftUI

func makePostRequest(){
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        return
    }
    
    var request = URLRequest(url: url)
    //method, body, headers
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable] = [
        "userId" : 1,
        "title" : "hello",
        "body" : "hhhhhhhh"
    ]
    request.httpBody  = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    //make the request
    let task = URLSession.shared.dataTask(with: request){data, _, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("Success: \(response)")
        }
        catch {
            print (error)
        }
    }
    task.resume()
     
}

makePostRequest()
