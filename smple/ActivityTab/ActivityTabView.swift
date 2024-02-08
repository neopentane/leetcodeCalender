//
//  ActivityTabView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI

struct ActivityTabView: View {
    @ObservedObject var vm : ActivityViewModel = ActivityViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.activityModel?.data.recentACSubmissionList ?? [], id: \.id) { value in
                    Text("Q: \(value.title)")
                }
            }
        }
    }
}

#Preview {
    ActivityTabView()
}
