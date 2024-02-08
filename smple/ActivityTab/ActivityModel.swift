//
//  ActivityModel.swift
//  smple
//
//  Created by Shreeram Kelkar on 04/02/24.
//

import Foundation

public struct ActivityModel: Codable {
    public let data: ActivityDataClass

    public init(data: ActivityDataClass) {
        self.data = data
    }
}

// MARK: - DataClass
public struct ActivityDataClass: Codable {
    public let recentACSubmissionList: [RecentACSubmissionList]

    enum CodingKeys: String, CodingKey {
        case recentACSubmissionList = "recentAcSubmissionList"
    }

    public init(recentACSubmissionList: [RecentACSubmissionList]) {
        self.recentACSubmissionList = recentACSubmissionList
    }
}

// MARK: - RecentACSubmissionList
public struct RecentACSubmissionList: Codable {
    public let id, title, titleSlug, timestamp: String

    public init(id: String, title: String, titleSlug: String, timestamp: String) {
        self.id = id
        self.title = title
        self.titleSlug = titleSlug
        self.timestamp = timestamp
    }
}
