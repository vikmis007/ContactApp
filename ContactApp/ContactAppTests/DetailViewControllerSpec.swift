//
//  DetailViewControllerSpec.swift
//  ContactAppTests
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation

let testDetailControllerIdentifier = "DetailViewController"

import UIKit
import Quick
import Nimble

@testable import ContactApp

class DetailViewControllerSpec: QuickSpec {
    /// Detail controller instance
    private var systemUnderTest: DetailViewController!

    /// Success URL for mocking API
    private var successURL: URL?

    override func spec() {
        successURL = self.contactListApiURL()

        beforeEach {
            self.prepareForRetest()
        }

        describe("Load Contact Detail") {

            // Test loading of contact details
            context("loading", closure: {

                // Test for successful loading
                self.executeTestSuiteForContactDetailLoadingSuccess()
            })
        }
    }

    /// This mwthod will test success of contact detail loading
    private func executeTestSuiteForContactDetailLoadingSuccess() {

        it("success", closure: {
            guard let successJSONURL = Bundle(for: type(of: self))
                .url(forResource: "ContactDetailSuccessData", withExtension: "json") else {
                    fail("Bundle URL found nil.")
                    return
            }

            guard let data = try? Data(contentsOf: successJSONURL) else {
                fail("Stub data is empty.")
                return
            }

            guard let serverURL = self.successURL else {
                fail("Invalid URL")
                return
            }

            let urlResponse = HTTPURLResponse(
                url: serverURL,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )

            let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
            self.systemUnderTest.urlSesssion = sessionMock

            self.systemUnderTest.initialSetup()
            self.systemUnderTest.viewModel?.getContactDetail(userId: 12075)
            //expect(self.systemUnderTest.viewModel?.user!.firstName).toEventually(equal("Alexaaaaaa"))
        })
    }

    /// This method will reset all data & settings before running each test case
    private func prepareForRetest() {
        systemUnderTest = UIStoryboard(
            name: "Main",
            bundle: nil)
            .instantiateViewController(
                withIdentifier: testDetailControllerIdentifier)
            as? DetailViewController
        systemUnderTest.personId = 12075
        UIApplication.shared.keyWindow!.rootViewController = systemUnderTest
    }

    /// Method to return URL for contact list API.
    ///
    /// - Returns: URL .
    private func contactListApiURL() -> URL? {
        var urlComponents = URLComponents(string: APIConstants.BASE_URL)!
        urlComponents.path = APIConstants.DETAIL_CONTACT_URL
        return urlComponents.url
    }
}

