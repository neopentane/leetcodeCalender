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
    @Published var epoches : [TimeInterval] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        self.fetchUser()
        self.fetchCalender()
        self.epoches = getEpochsForDaysInCurrentMonth() ?? []
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
    
    func getEpochsForDaysInCurrentMonth() -> [TimeInterval]? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let currentDate = Date()
        
        guard let currentMonthRange = calendar.range(of: .day, in: .month, for: currentDate) else {
            return nil
        }
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        var epochTimestamps: [TimeInterval] = []
        
        for day in currentMonthRange.lowerBound..<currentMonthRange.upperBound {
            var components = DateComponents()
            components.year = currentYear
            components.month = currentMonth
            components.day = day
            
            if let date = calendar.date(from: components) {
                let epochTimestamp = date.timeIntervalSince1970
                epochTimestamps.append(epochTimestamp)
            }
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
            "cookie": "__stripe_mid=503dc20e-3d6a-4294-9832-c41ac06966cf7d93a9; gr_user_id=a96d8320-7ef1-47b2-a79e-60dcb217c3b8; csrftoken=cPEvTxre1F2oOZpEYmUENkZhlqKL1FdgNl6JGf794lYoo3xWLZtqXQna2l4G4lWC; 87b5a3c3f1a55520_gr_last_sent_cs1=shreeramkelkar7; _gcl_au=1.1.2144249051.1702284572; cf_clearance=FNYYszZiZp6qpWeluVEkVVFMlJldd135Tqi.F0U7Hi4-1705766046-1-AW+/IFSs5uqaYOS0m4WshSUZJvivsRo3L87N9Z8/m69QNIiPVaBw/+23Tg+p5hnQbTFO9sSEkWN4aAz2CjVo4co=; _gid=GA1.2.636800982.1706587459; _ga_DKXQ03QCVK=GS1.1.1706590337.3.1.1706590343.54.0.0; LEETCODE_SESSION=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfYXV0aF91c2VyX2lkIjoiOTA5MzYwMCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6Ijg2MDZkYmY1MmE1ZmM0ZDVjMTAxYzI5MjgwYjc5YzkxM2ZmYjRlMjVkYjBmMDVhZWY3MDM5NGYyNTE0M2QwOTUiLCJpZCI6OTA5MzYwMCwiZW1haWwiOiJzaHJlZXJhbWtlbGthcjdAZ21haWwuY29tIiwidXNlcm5hbWUiOiJzaHJlZXJhbWtlbGthcjciLCJ1c2VyX3NsdWciOiJzaHJlZXJhbWtlbGthcjciLCJhdmF0YXIiOiJodHRwczovL2Fzc2V0cy5sZWV0Y29kZS5jb20vdXNlcnMvYXZhdGFycy9hdmF0YXJfMTY3OTUwMDgxMC5wbmciLCJyZWZyZXNoZWRfYXQiOjE3MDY4NDY5NTgsImlwIjoiMTE2LjUwLjg0LjExNiIsImlkZW50aXR5IjoiZWVkZTg1ZGI0YjQzZTA5NTg1OGNjNjEzZDljNDhlMTEiLCJzZXNzaW9uX2lkIjo1MTA1NDA0Mn0.uCGiUx8h_RszkJaibLa3ygJ-zXFyh_8ayxrfQOrMqbc; 87b5a3c3f1a55520_gr_session_id=66584ead-3554-4a08-84e8-d4119761cdd6; 87b5a3c3f1a55520_gr_last_sent_sid_with_cs1=66584ead-3554-4a08-84e8-d4119761cdd6; 87b5a3c3f1a55520_gr_session_id_sent_vst=66584ead-3554-4a08-84e8-d4119761cdd6; 87b5a3c3f1a55520_gr_cs1=shreeramkelkar7; _ga_CDRWKZTDEX=GS1.1.1706868048.157.1.1706869928.29.0.0; _ga=GA1.1.533211856.1701684855",
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
            "x-csrftoken": "cPEvTxre1F2oOZpEYmUENkZhlqKL1FdgNl6JGf794lYoo3xWLZtqXQna2l4G4lWC",
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
            "cookie": "__stripe_mid=503dc20e-3d6a-4294-9832-c41ac06966cf7d93a9; gr_user_id=a96d8320-7ef1-47b2-a79e-60dcb217c3b8; csrftoken=cPEvTxre1F2oOZpEYmUENkZhlqKL1FdgNl6JGf794lYoo3xWLZtqXQna2l4G4lWC; 87b5a3c3f1a55520_gr_last_sent_cs1=shreeramkelkar7; _gcl_au=1.1.2144249051.1702284572; cf_clearance=FNYYszZiZp6qpWeluVEkVVFMlJldd135Tqi.F0U7Hi4-1705766046-1-AW+/IFSs5uqaYOS0m4WshSUZJvivsRo3L87N9Z8/m69QNIiPVaBw/+23Tg+p5hnQbTFO9sSEkWN4aAz2CjVo4co=; _gid=GA1.2.636800982.1706587459; _ga_DKXQ03QCVK=GS1.1.1706590337.3.1.1706590343.54.0.0; LEETCODE_SESSION=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfYXV0aF91c2VyX2lkIjoiOTA5MzYwMCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6Ijg2MDZkYmY1MmE1ZmM0ZDVjMTAxYzI5MjgwYjc5YzkxM2ZmYjRlMjVkYjBmMDVhZWY3MDM5NGYyNTE0M2QwOTUiLCJpZCI6OTA5MzYwMCwiZW1haWwiOiJzaHJlZXJhbWtlbGthcjdAZ21haWwuY29tIiwidXNlcm5hbWUiOiJzaHJlZXJhbWtlbGthcjciLCJ1c2VyX3NsdWciOiJzaHJlZXJhbWtlbGthcjciLCJhdmF0YXIiOiJodHRwczovL2Fzc2V0cy5sZWV0Y29kZS5jb20vdXNlcnMvYXZhdGFycy9hdmF0YXJfMTY3OTUwMDgxMC5wbmciLCJyZWZyZXNoZWRfYXQiOjE3MDY4NDY5NTgsImlwIjoiMTE2LjUwLjg0LjExNiIsImlkZW50aXR5IjoiZWVkZTg1ZGI0YjQzZTA5NTg1OGNjNjEzZDljNDhlMTEiLCJzZXNzaW9uX2lkIjo1MTA1NDA0Mn0.uCGiUx8h_RszkJaibLa3ygJ-zXFyh_8ayxrfQOrMqbc; 87b5a3c3f1a55520_gr_session_id=bf98b0ad-8db1-465a-abcd-6649d1d26253; 87b5a3c3f1a55520_gr_last_sent_sid_with_cs1=bf98b0ad-8db1-465a-abcd-6649d1d26253; 87b5a3c3f1a55520_gr_session_id_sent_vst=bf98b0ad-8db1-465a-abcd-6649d1d26253; _gat=1; _dd_s=rum=0&expire=1706861428179; 87b5a3c3f1a55520_gr_cs1=shreeramkelkar7; _ga=GA1.1.533211856.1701684855; _ga_CDRWKZTDEX=GS1.1.1706859132.156.1.1706860551.33.0.0",
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
            "x-csrftoken": "cPEvTxre1F2oOZpEYmUENkZhlqKL1FdgNl6JGf794lYoo3xWLZtqXQna2l4G4lWC",
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
                let str = String(data: data, encoding: .utf8)
                do {
                    let welcome = try JSONDecoder().decode(profilemodel.self, from: data)
                    self.person = welcome
                } catch let error {
                    print(error)
                    //                print(str ?? "")
                }
            }
        }
        
        task.resume()
        
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
