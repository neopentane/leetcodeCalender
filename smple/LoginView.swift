//
//  LoginView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI




struct LoginView: View {
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter text", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // You can choose a different style if you prefer
                    .autocapitalization(.none) // Optional: Set autocapitalization behavior
                    .disableAutocorrection(true) // Optional: Disable autocorrection
                    .padding(.horizontal)
                
                NavigationLink(destination: TabBarView()) {
                    Text("Submit")
                }
            }.onChange(of: name) { oldValue, newValue in
                UserData.shared.name = newValue
            }
        }
        
    }
}

#Preview {
    LoginView()
}
