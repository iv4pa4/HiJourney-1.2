//
//  ConnectionViewModelTests.swift
//  TestTest
//
//  Created by Ivayla Panayotova on 19.05.24.
//

import XCTest
@testable import HiJourney_1_2

final class ConnectionViewModelTests: XCTestCase {

    var creatorModel: CreatorModel!
    var userSession: UserSessionMock!

    override func setUp() {
        super.setUp()
        creatorModel = CreatorModel()
        userSession = UserSessionMock()
        creatorModel.userSession = userSession
    }

    override func tearDown() {
        creatorModel = nil
        userSession = nil
        super.tearDown()
    }

    func testSignInCreatorSuccess() {
        let expectation = self.expectation(description: "SignInCreator")

        creatorModel.signInCreator(email: "test@example.com", password: "password") { result in
            switch result {
            case .success:
                XCTAssertTrue(self.userSession.saveJWTTokenToKeychainCalled)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got \(error) instead")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSignInCreatorFailure() {
        let expectation = self.expectation(description: "SignInCreator")

        creatorModel.signInCreator(email: "invalid@example.com", password: "wrongpassword") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success instead")
            case .failure:
                XCTAssertFalse(self.userSession.saveJWTTokenToKeychainCalled)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCreateUserCreatorSuccess() {
        let expectation = self.expectation(description: "CreateUserCreator")

        creatorModel.createUserCreator(username: "testuser", email: "test@example.com", password: "password", validateUserCreator: { _, _, completion in
            completion(.success("mockToken"))
        }) { result in
            switch result {
            case .success(let creator):
                XCTAssertEqual(creator.username, "testuser")
                XCTAssertTrue(self.userSession.saveJWTTokenToKeychainCalled)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got \(error) instead")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCreateUserCreatorFailure() {
        let expectation = self.expectation(description: "CreateUserCreator")

        creatorModel.createUserCreator(username: "testuser", email: "test@example.com", password: "password", validateUserCreator: { _, _, completion in
            completion(.failure(NSError(domain: "test", code: 1, userInfo: nil)))
        }) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success instead")
            case .failure:
                XCTAssertFalse(self.userSession.saveJWTTokenToKeychainCalled)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}

class UserSessionMock: UserSession {
    var saveJWTTokenToKeychainCalled = false

    override func saveJWTTokenToKeychain(token: String) -> Bool {
        saveJWTTokenToKeychainCalled = true
        return true
    }
}
