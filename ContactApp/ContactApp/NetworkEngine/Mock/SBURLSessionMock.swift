//
// CAURLSessionMock.swift
//  ContactApp
//
//  Created by Vikasmishra on 20/10/19.
//  Copyright © 2019 Exercise. All rights reserved.
//

import Foundation

/// Protocol to provide data task delegate method, to be used while mocking
public protocol CAURLSession {

    /// Mocked datatask delegate method, to be used while testing
    ///
    /// - Parameters:
    ///   - url: mock url
    ///   - completionHandler: completion handler
    /// - Returns: URLSessionDataTask mocked object
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

    /// Mocked datatask delegate method, to be used while testing post request
    ///
    /// - Parameters:
    ///   - url: mock url request
    ///   - completionHandler: completion handler
    /// - Returns: URLSessionDataTask mocked object
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

/// Extension to mock URLSession
extension URLSession: CAURLSession { }

/// Class to create mock URLSession
public final class URLSessionMock: CAURLSession {

    /// Mocked url
    var url: URL?

    /// URLRequest to be framed
    var request: URLRequest?

    /// Mocked datatask reference
    private let dataTaskMock: URLSessionDataTaskMock

    /// Initializer for the class
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskData = data
        dataTaskMock.taskResponse = response
        dataTaskMock.taskError = error
    }

    /// Mocked datatask method
    ///
    /// - Parameters:
    ///   - url: mocking url
    ///   - completionHandler: completionHandler
    /// - Returns: datatask object
    public func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    /// Mocked datatask method for post request
    ///
    /// - Parameters:
    ///   - urlRequest: mocking url request
    ///   - completionHandler: completionHandler
    /// - Returns: datatask object
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

}

/// URLSessionDataTask mock class
final private class URLSessionDataTaskMock: URLSessionDataTask {

    /// Typealias for completion handler
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    /// Reference to the completion handler
    var completionHandler: CompletionHandler?

    /// Recieved data
    var taskData: Data?

    /// Recieved URLResponse
    var taskResponse: URLResponse?

    /// Recieved error
    var taskError: Error?

    /// Overriding resume function from datatask request
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler?(self.taskData, self.taskResponse, self.taskError)
        }
    }
}
