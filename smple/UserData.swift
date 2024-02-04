//
//  UserData.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import Foundation

class UserData {
    // The static instance of the singleton
    static let shared = UserData()
    var name = ""

    // Private initializer to prevent multiple instances
    private init() {
        // Initialization code, if any
    }

    // Additional properties and methods can be added here

    func sayHello() {
        print("Hello from MySingleton!")
    }
}
