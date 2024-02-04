import Foundation

// MARK: - DataClass
public struct calenderModel: Codable {
    public let data: calenderDataClass

    public init(data: calenderDataClass) {
        self.data = data
    }
}


public struct calenderDataClass: Codable {
    public let matchedUser: calenderMatchedUser

    public init(matchedUser: calenderMatchedUser) {
        self.matchedUser = matchedUser
    }
}

// MARK: - MatchedUser
public struct calenderMatchedUser: Codable {
    public let userCalendar: UserCalendar

    public init(userCalendar: UserCalendar) {
        self.userCalendar = userCalendar
    }
}

// MARK: - UserCalendar
public struct UserCalendar: Codable {
    public let activeYears: [Int]
    public let streak, totalActiveDays: Int
    public let dccBadges: [JSONAny]
    public let submissionCalendar: String


    public init(activeYears: [Int], streak: Int, totalActiveDays: Int, dccBadges: [JSONAny], submissionCalendar: String) {
        self.activeYears = activeYears
        self.streak = streak
        self.totalActiveDays = totalActiveDays
        self.dccBadges = dccBadges
        self.submissionCalendar = submissionCalendar
        
        // Split the string into key-value pairs

        // Create a dictionary

    }
}
