//
//  ProfileTabView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI

struct ProfileTabView: View {
    var body: some View {
        VStack {
            ProfileView()
            Text("Progress")
            ProfileProgressView()
            Text("Daily Activity")
            CalenderView()
        }
    }
}

#Preview {
    ProfileTabView()
}
