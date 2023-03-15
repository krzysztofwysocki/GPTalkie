//
//  ContentView.swift
//  GPTalkie
//
//
//  Copyright (c) 2023 Krzysztof Wysocki. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
