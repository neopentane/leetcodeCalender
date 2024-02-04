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
            ForEach (vm.progress?.data.matchedUser.problemsSolvedBeatsStats ?? [] ,id: \.difficulty) { cate in
                Text("\(cate.difficulty) : Progress \(String(format: "%.2f", cate.percentage ?? 0))")
            }

            Text("Daily Activity")
            
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(vm.epoches ,id: \.self) { month in
                        ForEach(month.getSlice(into: 7) ,id: \.self) { index in
                            VStack() {
                                ForEach(index , id: \.self) { j in
                                    if let val = vm.resultDictionary[String(Int(j) + 19800)] {
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
            }
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
