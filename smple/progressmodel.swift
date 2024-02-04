// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
public struct progressmodel: Codable {
    public let data: progressmodelDataClass

    public init(data: progressmodelDataClass) {
        self.data = data
    }
}

// MARK: - DataClass
public struct progressmodelDataClass: Codable {
    public let allQuestionsCount: [AllQuestionsCount]
    public let matchedUser: progressmodelMatchedUser

    public init(allQuestionsCount: [AllQuestionsCount], matchedUser: progressmodelMatchedUser) {
        self.allQuestionsCount = allQuestionsCount
        self.matchedUser = matchedUser
    }
}

// MARK: - AllQuestionsCount
public struct AllQuestionsCount: Codable {
    public let difficulty: String
    public let count: Int

    public init(difficulty: String, count: Int) {
        self.difficulty = difficulty
        self.count = count
    }
}

// MARK: - MatchedUser
public struct progressmodelMatchedUser: Codable {
    public let problemsSolvedBeatsStats: [ProblemsSolvedBeatsStat]
    public let submitStatsGlobal: SubmitStatsGlobal

    public init(problemsSolvedBeatsStats: [ProblemsSolvedBeatsStat], submitStatsGlobal: SubmitStatsGlobal) {
        self.problemsSolvedBeatsStats = problemsSolvedBeatsStats
        self.submitStatsGlobal = submitStatsGlobal
    }
}

// MARK: - ProblemsSolvedBeatsStat
public struct ProblemsSolvedBeatsStat: Codable {
    public let difficulty: String
    public let percentage: Double?

    public init(difficulty: String, percentage: Double?) {
        self.difficulty = difficulty
        self.percentage = percentage
    }
}

// MARK: - SubmitStatsGlobal
public struct SubmitStatsGlobal: Codable {
    public let acSubmissionNum: [AllQuestionsCount]

    public init(acSubmissionNum: [AllQuestionsCount]) {
        self.acSubmissionNum = acSubmissionNum
    }
}
