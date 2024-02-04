//
//  profileViewModel.swift
//  smple
//
//  Created by Shreeram Kelkar on 02/02/24.
//

import Foundation
import SwiftUI
import Combine

class PersonViewModel: ObservableObject {
    @Published var person: profilemodel?
    @Published var error: Error?
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        self.fetchUser()
    }
    
    func fetchUser() {
        let request = getRequestForProfile()
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: profilemodel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { obj in
                self.person = obj
            })
            .store(in: &cancellables)
    }
        
    func getRequestForProfile() -> URLRequest {
        let jsonData = [
            "query": "\n    query userPublicProfile($username: String!) {\n  matchedUser(username: $username) {\n    contestBadge {\n      name\n      expired\n      hoverText\n      icon\n    }\n    username\n    githubUrl\n    twitterUrl\n    linkedinUrl\n    profile {\n      ranking\n      userAvatar\n      realName\n      aboutMe\n      school\n      websites\n      countryName\n      company\n      jobTitle\n      skillTags\n      postViewCount\n      postViewCountDiff\n      reputation\n      reputationDiff\n      solutionCount\n      solutionCountDiff\n      categoryDiscussCount\n      categoryDiscussCountDiff\n    }\n  }\n}\n    ",
            "variables": [
                "username": "shreeramkelkar7"
            ],
            "operationName": "userPublicProfile"
        ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        let url = URL(string: "https://leetcode.com/graphql/")!
        let headers = [
            "authority": "leetcode.com",
            "accept": "*/*",
            "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
            "authorization": "",
            "baggage": "sentry-environment=production,sentry-release=7366c15b,sentry-transaction=%2Fu%2F%5Busername%5D,sentry-public_key=2a051f9838e2450fbdd5a77eb62cc83c,sentry-trace_id=d86fa574dd594e548128c51631c4a764,sentry-sample_rate=0.03",
            "content-type": "application/json",
            "origin": "https://leetcode.com",
            "random-uuid": "d27fdca5-5f86-94af-4fa1-2d96ace02839",
            "referer": "https://leetcode.com/shreeramkelkar7/",
            "sec-ch-ua": "\"Not_A Brand\";v=\"8\", \"Chromium\";v=\"120\", \"Google Chrome\";v=\"120\"",
            "sec-ch-ua-mobile": "?1",
            "sec-ch-ua-platform": "\"Android\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            "sentry-trace": "d86fa574dd594e548128c51631c4a764-b2cab819ddcdcf0e-0",
            "user-agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
            "x-newrelic-id": "UAQDVFVRGwIAUVhbAAMFXlQ="
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        return request
        
    }
}

