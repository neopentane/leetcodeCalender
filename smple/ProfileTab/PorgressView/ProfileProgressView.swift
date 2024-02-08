//
//  ProgressView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI

struct ProfileProgressView: View {
    @ObservedObject var vm : ProgressViewModel = ProgressViewModel()
    
    var body: some View {
        ForEach (vm.progress?.data.matchedUser.problemsSolvedBeatsStats ?? [] ,id: \.difficulty) { cate in
            Text("\(cate.difficulty) : Beats \(String(format: "%.2f", cate.percentage ?? 0))")
        }
    }
}

#Preview {
    ProfileProgressView()
}
