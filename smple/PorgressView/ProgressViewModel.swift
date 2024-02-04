//
//  ProfileViewModel.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import Foundation
import SwiftUI
import Combine

class ProgressViewModel: ObservableObject {
    @Published var error: Error?
    @Published var progress : progressmodel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        self.fetchProgress()
    }
    
    func fetchProgress() {
        let request = getRequestForProgress()
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: progressmodel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { obj in
                self.progress = obj
            })
            .store(in: &cancellables)

    }
        
        
    func getRequestForProgress() -> URLRequest {
        let jsonData = [
            "query": "\n    query userProblemsSolved($username: String!) {\n  allQuestionsCount {\n    difficulty\n    count\n  }\n  matchedUser(username: $username) {\n    problemsSolvedBeatsStats {\n      difficulty\n      percentage\n    }\n    submitStatsGlobal {\n      acSubmissionNum {\n        difficulty\n        count\n      }\n    }\n  }\n}\n    ",
            "variables": [
                "username": "shreeramkelkar7"
            ],
            "operationName": "userProblemsSolved"
        ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])

        let url = URL(string: "https://leetcode.com/graphql/")!
        let headers = [
            "authority": "leetcode.com",
            "accept": "*/*",
            "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
            "authorization": "",
            "baggage": "sentry-environment=production,sentry-release=7366c15b,sentry-transaction=%2Fu%2F%5Busername%5D,sentry-public_key=2a051f9838e2450fbdd5a77eb62cc83c,sentry-trace_id=2420309d2b9047ccb158518285f1107c,sentry-sample_rate=0.03",
            "content-type": "application/json",
            "origin": "https://leetcode.com",
            "random-uuid": "d27fdca5-5f86-94af-4fa1-2d96ace02839",
            "referer": "https://leetcode.com/shreeramkelkar7/",
            "sec-ch-ua": "\"Not A(Brand\";v=\"99\", \"Google Chrome\";v=\"121\", \"Chromium\";v=\"121\"",
            "sec-ch-ua-mobile": "?1",
            "sec-ch-ua-platform": "\"Android\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            "sentry-trace": "2420309d2b9047ccb158518285f1107c-8bc8eeb424a0101b-0",
            "user-agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Mobile Safari/537.36",
            "x-newrelic-id": "UAQDVFVRGwIAUVhbAAMFXlQ="
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        return request
    }
}
