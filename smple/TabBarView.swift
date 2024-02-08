//
//  TabBarView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ProfileTabView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            ActivityTabView()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
        .padding()
    }
}

#Preview {
    TabBarView()
}
