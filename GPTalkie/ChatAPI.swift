import Foundation

struct OpenAIRequest: Codable {
    let model: String
    struct Message: Codable {
        let role: String
        let content: String
    }

    let messages: [Message]
}


struct OpenAIResponse: Codable {
    struct Choice: Codable {
        let message: OpenAIRequest.Message
    }

    let id: String
    let object: String
    let created: Int
    // Remove the model field
    let usage: Usage
    let choices: [Choice]

    struct Usage: Codable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
}



class ChatAPI {
    static let shared = ChatAPI()
    private let apiKey: String
    
    public init() {
            guard let filePath = Bundle.main.path(forResource: "Configs", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: filePath),
                  let apiKey = plist["API_KEY"] as? String else {
                fatalError("Couldn't load API key from Configs.plist")
            }

            self.apiKey = apiKey
    }

    func getGPTResponse(prompt: String, completion: @escaping (Result<OpenAIResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a helpful assistant."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ] as [String: Any]



        do {
            let jsonBody = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                 print("JSON Response: \(jsonString)")
             }

            do {
                let apiResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
