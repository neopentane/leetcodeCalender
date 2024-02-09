//
//  CalenderView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI

struct CalenderView: View {
    
    @ObservedObject var vm : CalenderViewModel = CalenderViewModel()
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top) {
                ForEach(vm.epoches ,id: \.self) { month in
                    Divider()
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
}

#Preview {
    CalenderView()
}
