import XCTest
@testable import HiJourney_1_2

class CreatorModelTests: XCTestCase {
    
    var creatorModel: CreatorModel!
    
    override func setUp() {
        super.setUp()
        creatorModel = CreatorModel()
    }
    
    override func tearDown() {
        creatorModel = nil
        super.tearDown()
    }
    
    func testSignInCreatorSuccess() {
        let expectation = self.expectation(description: "SignInCreator")
        
        creatorModel.signInCreator(email: "test@example.com", password: "password") { result in
            switch result {
            case .success:
                // Assert whatever conditions indicate a successful sign-in
                XCTAssertTrue(true)
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
                XCTAssertTrue(true)
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
                // Assert that the creator is created successfully
                XCTAssertEqual(creator.username, "testuser")
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
                // Assert that the creation fails
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetCreatorByEmailSuccess() {
        let expectation = self.expectation(description: "GetCreatorByEmail")
        
        creatorModel.getCreatorByEmail(email: "test@example.com", token: "mockToken") { result in
            switch result {
            case .success(let creator):
                // Assert that the creator is fetched successfully
                XCTAssertEqual(creator.email, "test@example.com")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got \(error) instead")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetCreatorByEmailFailure() {
        let expectation = self.expectation(description: "GetCreatorByEmail")
        
        creatorModel.getCreatorByEmail(email: "nonexistent@example.com", token: "mockToken") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success instead")
            case .failure:
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

}
