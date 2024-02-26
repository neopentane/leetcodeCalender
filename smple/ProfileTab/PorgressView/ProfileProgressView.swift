//
//  ProgressView.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import SwiftUI
import Charts

struct ProfileProgressView: View {
    @ObservedObject var vm : ProgressViewModel = ProgressViewModel()
    
    let data = [
        (name: "Cachapa", sales: 9631),
        (name: "Crêpe", sales: 6959),
        (name: "Injera", sales: 4891),
        (name: "Jian Bing", sales: 2506),
        (name: "American", sales: 1777),
        (name: "Dosa", sales: 625),
    ]
    
    
    var body: some View {
        ForEach (vm.progress?.data.matchedUser.problemsSolvedBeatsStats ?? [] ,id: \.difficulty) { cate in
            Text("\(cate.difficulty) : Beats \(String(format: "%.2f", cate.percentage ?? 0))")
        }
        
        
//        Chart(vm.progress?.data.matchedUser.problemsSolvedBeatsStats ?? [], id: \.difficulty) { val in
//            SectorMark(angle: .value("Value", val.percentage ?? 0 ))
//                .foregroundStyle(by: .value("Product category", val.difficulty))
//        }
        
        Chart(vm.progress?.data.matchedUser.problemsSolvedBeatsStats ?? [], id: \.difficulty) { val in
            BarMark(x: .value("Population", val.percentage ?? 0),
                    y: .value("Type", val.difficulty))
            .foregroundStyle(by: .value("Type", val.difficulty))
            .annotation(position: .trailing) {
                Text(String(val.percentage ?? 0))
                    .foregroundColor(.gray)
            }
        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
            }
        }

        
        
        
    }
}

#Preview {
    ProfileProgressView()
}
