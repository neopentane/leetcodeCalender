import Foundation
import Apollo
import Combine
import ApolloAPI


let apiPoint = "https://leetcode.com/graphql/"

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: apiPoint)!)
    
//    func fetchGraphQLData<Query: GraphQLQuery>(query: Query) -> AnyPublisher<Data, Error> {
//        let val = apollo.fetch(query: query)
//
//    }

}

enum GraphQLError: Error {
    case fetchError
    case createError
    case editError
    case deleteError
}
