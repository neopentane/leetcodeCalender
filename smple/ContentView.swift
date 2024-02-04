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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("username : \(vm.person?.data.matchedUser.username ?? "" )")
            Text("githubURL : \(vm.person?.data.matchedUser.githubURL ?? "" )")
            Text("ranking : \(vm.person?.data.matchedUser.profile.ranking ?? 0 )")
            
            HStack {
                ForEach(1..<5) { i in
                    VStack {
                        ForEach(1..<8) { j in
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 30,height: 30)
                        }
                    }
                }
            }
            Spacer()
            
            HStack(alignment: .top) {
                ForEach(vm.epoches.chunked(into: 7) ,id: \.self) { index in
                    VStack() {
                        ForEach(index , id: \.self) { j in
                            if let val = vm.resultDictionary[String(Int(j) - 66600)] {
                                Rectangle()
                                    .fill(vm.getColor(val))
                                    .frame(width: 30,height: 30)

                            }  else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 30,height: 30)
                            }
                        }
                    }
                }
            }
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
