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
    @Published var calender: calenderModel?
    @Published var resultDictionary = [String: Int]()
    @Published var epoches : [[TimeInterval]] = []
    @Published var progress : progressmodel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        self.fetchUser()
        self.fetchCalender()
        self.epoches = getEpochsForDaysInCurrentMonth() ?? []
        self.fetchProgress()
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
    
    func fetchCalender() {
        let request = getRequestForCalender()
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: calenderModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { obj in
                self.calender = obj
                let jsonString = obj.data.matchedUser.userCalendar.submissionCalendar
                // Convert the string to Data
                guard let jsonData = jsonString.data(using: .utf8) else {
                    fatalError("Failed to convert JSON string to data.")
                }
                
                do {
                    // Parse JSON data into a dictionary
                    if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Int] {
                        self.resultDictionary = dictionary
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
                
            })
            .store(in: &cancellables)
        
    }
    
    func daysInMonth(_ month: Int, year: Int) -> Int? {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: calendar.date(from: DateComponents(year: year, month: month)) ?? Date()) else {
            return nil
        }
        return range.count
    }
    
    func getColor(_ value: Int) -> Color {
        if value == 0 {
            return Color.gray
        } else {
            var val = Double(value)
            if value > 10 {
                val = 10.0
            }
            return Color.green.opacity(val/10)
        }
        
    }
    
    func getEpochsForDaysInCurrentMonth() -> [[TimeInterval]]? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let currentDate = Date()
        
        guard let currentMonthRange = calendar.range(of: .day, in: .month, for: currentDate) else {
            return nil
        }
        
        var epochTimestamps: [[TimeInterval]] = []
        var arr : [TimeInterval] = []
        
        
        for i in stride(from: 1, to: -1, by: -1) {
            arr = []
            let currentMonth = calendar.component(.month, from: currentDate) - i
            let currentYear = calendar.component(.year, from: currentDate)
            
            for day in currentMonthRange.lowerBound..<currentMonthRange.upperBound {
                var components = DateComponents()
                components.year = currentYear
                components.month = currentMonth
                components.day = day
                
                if let date = calendar.date(from: components) {
                    let epochTimestamp = date.timeIntervalSince1970
                    arr.append(epochTimestamp)
                }
            }
            epochTimestamps.append(arr)
        }
        
        return epochTimestamps
    }
    
    
    func convertEpochToDay(epoch: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: epoch)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"  // "EEEE" represents the full name of the day (e.g., Monday, Tuesday)
        
        let day = dateFormatter.string(from: date)
        return day
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
    
    func getRequestForCalender() -> URLRequest {
        let jsonData = [
            "query": "\n    query userProfileCalendar($username: String!, $year: Int) {\n  matchedUser(username: $username) {\n    userCalendar(year: $year) {\n      activeYears\n      streak\n      totalActiveDays\n      dccBadges {\n        timestamp\n        badge {\n          name\n          icon\n        }\n      }\n      submissionCalendar\n    }\n  }\n}\n    ",
            "variables": [
                "username": "shreeramkelkar7"
            ],
            "operationName": "userProfileCalendar"
        ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        let url = URL(string: "https://leetcode.com/graphql/")!
        let headers = [
            "authority": "leetcode.com",
            "accept": "*/*",
            "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
            "authorization": "",
            "baggage": "sentry-environment=production,sentry-release=7366c15b,sentry-transaction=%2Fu%2F%5Busername%5D,sentry-public_key=2a051f9838e2450fbdd5a77eb62cc83c,sentry-trace_id=2cbf1777d71244d2a8652d6377f57b9b,sentry-sample_rate=0.03",
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
            "sentry-trace": "2cbf1777d71244d2a8652d6377f57b9b-a31bdc2ad18a65f3-0",
            "user-agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
            "x-newrelic-id": "UAQDVFVRGwIAUVhbAAMFXlQ="
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        return request
        
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
    
    func fetchData() {
        let request = getRequestForProfile()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let welcome = try JSONDecoder().decode(profilemodel.self, from: data)
                    self.person = welcome
                } catch let error {
                    print(error)
                }
            }
        }
        
        task.resume()
        
    }
    
}

extension Array {
    func getSlice(into size: Int) -> [[Element]] {
        var result : [[Element]] = []
        var arr : [Element] = []
        var  i : Int = 0
        for element in self {
            arr.append(element)
            i += 1
            if i % size == 0 {
                result.append(arr)
                arr = []
            }
        }
        if i %  size != 0 {
            result.append(arr)
        }
        return result
    }
}
