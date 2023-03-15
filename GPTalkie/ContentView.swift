import SwiftUI

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var response: String = ""
    let chatAPI = ChatAPI.shared
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter prompt", text: $prompt)
                Button("Send") {
                    sendPrompt(prompt: prompt)
                }
            }
            Text(response)
        }
        .frame(width: 200, height: 100)
        .padding()
    }
    
    func sendPrompt(prompt: String) {
        chatAPI.getGPTResponse(prompt: prompt) { result in
            switch result {
            case .success(let openAIResponse):
                if let choice = openAIResponse.choices.first {
                    DispatchQueue.main.async {
                        self.response = choice.message.content
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
