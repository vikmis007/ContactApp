//
//  ListViewControllerSpec.swift
//  ContactAppTests
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

let testControllerIdentifier = "ListViewControllerIdentifier"

import UIKit
import Quick
import Nimble

@testable import ContactApp

class ListViewControllerSpec: QuickSpec {

    /// ListTableView controller instance
    private var systemUnderTest: ListViewController!

    /// Success URL for mocking API
    private var successURL: URL?

    override func spec() {
        successURL = self.contactListApiURL()

        beforeEach {
            self.prepareForRetest()
        }

        describe("Load Contact list") {

            // Test loading of contact list items
            context("loading", closure: {

                // Test for successful loading
                self.executeTestSuiteForContactListLoadingSuccess()
            })
        }
    }

    /// This mwthod will test success of contact list loading
    private func executeTestSuiteForContactListLoadingSuccess() {

        it("success", closure: {
            guard let successJSONURL = Bundle(for: type(of: self))
                .url(forResource: "ContactListSuccessData", withExtension: "json") else {
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
            self.systemUnderTest.getContactList()
            let sectionsCount = self.systemUnderTest.fetchedResultsController.sections!.count
            expect(sectionsCount).toEventually(equal(28))
        })
    }


    /// This method will reset all data & settings before running each test case
    private func prepareForRetest() {
        systemUnderTest = UIStoryboard(
            name: "Main",
            bundle: nil)
            .instantiateViewController(
                withIdentifier: testControllerIdentifier)
            as? ListViewController
        UIApplication.shared.keyWindow!.rootViewController = systemUnderTest
    }

    /// Method to return URL for contact list API.
    ///
    /// - Returns: URL .
    private func contactListApiURL() -> URL? {
        var urlComponents = URLComponents(string: APIConstants.BASE_URL)!
        urlComponents.path = APIConstants.GET_CONTACTS
        return urlComponents.url
    }
}
