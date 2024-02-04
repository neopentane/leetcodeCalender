//
//  ContentView.swift
//  smple
//
//  Created by Shreeram Kelkar on 30/01/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm : PersonViewModel = PersonViewModel()
    var body: some View {
        VStack {
            AsyncImage(
                url: URL(string: vm.person?.data.matchedUser.profile.userAvatar ?? ""),
                content: { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 100, maxHeight: 100)
                         .clipShape(.circle)
                },
                placeholder: {
                    ProgressView()
                }
            )
            
            Text("username : \(vm.person?.data.matchedUser.username ?? "" )")
            Text("githubURL : \(vm.person?.data.matchedUser.githubURL ?? "" )")
            Text("ranking : \(vm.person?.data.matchedUser.profile.ranking ?? 0 )")

            Text("Progress")
            ProfileProgressView()
            Text("Daily Activity")
            CalenderView()
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
