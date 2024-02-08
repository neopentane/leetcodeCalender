//
//  ProfileView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm : PersonViewModel = PersonViewModel()
    var body: some View {
        AsyncImage(
            url: URL(string: vm.person?.data.matchedUser.profile.userAvatar ?? ""),
            content: { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(maxWidth: 100, maxHeight: 100)
                     .clipShape(.circle)
            },
            placeholder: {
                ProfileProgressView()
            }
        )
        
        Text("username : \(vm.person?.data.matchedUser.username ?? "" )")
        Text("githubURL : \(vm.person?.data.matchedUser.githubURL ?? "" )")
        Text("ranking : \(vm.person?.data.matchedUser.profile.ranking ?? 0 )")
    }
}

#Preview {
    ProfileView()
}
