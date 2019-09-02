#if canImport(Combine)

import Foundation
import Combine

#if !COCOAPODS
    import Moya
#endif

#if canImport(UIKit)
    import UIKit.UIImage
#elseif canImport(AppKit)
    import AppKit.NSImage
#endif

/// Extension for processing raw NSData generated by network access.
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnyPublisher where Output == Response, Failure == MoyaError {

    /// Filters out responses that don't fall within the given range, generating errors when others are encountered.
    public func filter<R: RangeExpression>(statusCodes: R) -> AnyPublisher<Response, MoyaError> where R.Bound == Int {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.filter(statusCodes: statusCodes) })
        }
        .eraseToAnyPublisher()
    }

    /// Filters out responses that has the specified `statusCode`.
    public func filter(statusCode: Int) -> AnyPublisher<Response, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.filter(statusCode: statusCode) })
        }
        .eraseToAnyPublisher()
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 299.
    public func filterSuccessfulStatusCodes() -> AnyPublisher<Response, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.filterSuccessfulStatusCodes() })
        }
        .eraseToAnyPublisher()
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 399
    public func filterSuccessfulStatusAndRedirectCodes() -> AnyPublisher<Response, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.filterSuccessfulStatusAndRedirectCodes() })
        }
        .eraseToAnyPublisher()
    }

    /// Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    public func mapImage() -> AnyPublisher<Image, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.mapImage() })
        }
        .eraseToAnyPublisher()
    }

    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapJSON(failsOnEmptyData: Bool = true) -> AnyPublisher<Any, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.mapJSON(failsOnEmptyData: failsOnEmptyData) })
        }
        .eraseToAnyPublisher()
    }

    /// Maps received data at key path into a String. If the conversion fails, the signal errors.
    public func mapString(atKeyPath keyPath: String? = nil) -> AnyPublisher<String, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.mapString(atKeyPath: keyPath) })
        }
        .eraseToAnyPublisher()
    }

    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    public func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, MoyaError> {
        return self.flatMap { response in
            MoyaPublisher(just: { try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData) })
        }
        .eraseToAnyPublisher()
    }
}
//
//extension ObservableType where Element == ProgressResponse {
//
//    /**
//     Filter completed progress response and maps to actual response
//
//     - returns: response associated with ProgressResponse object
//     */
//    public func filterCompleted() -> Observable<Response> {
//        return self
//            .filter { $0.completed }
//            .flatMap { progress -> Observable<Response> in
//                // Just a formatlity to satisfy the compiler (completed progresses have responses).
//                switch progress.response {
//                case .some(let response): return .just(response)
//                case .none: return .empty()
//                }
//            }
//    }
//
//    /**
//     Filter progress events of current ProgressResponse
//
//     - returns: observable of progress events
//     */
//    public func filterProgress() -> Observable<Double> {
//        return self.filter { !$0.completed }.map { $0.progress }
//    }
//}

#endif
