//
//  ConnectionViewModelTests.swift
//  TestTest
//
//  Created by Ivayla  Panayotova on 19.05.24.
//

import XCTest
@testable import HiJourney_1_2

final class ConnectionViewModelTests: XCTestCase {

    var mockConnection: MockConnection!

    override func setUp() {
        super.setUp()
        mockConnection = MockConnection()
    }

    override func tearDown() {
        mockConnection = nil
        super.tearDown()
    }

    func testFetchWishlistData() {
        // Call the fetchWishlistData method
        mockConnection.fetchWishlistData()

        // Verify the wishlist is populated correctly
        XCTAssertEqual(mockConnection.wishlist.count, 2, "The wishlist should contain 2 items")

        let firstItem = mockConnection.wishlist[0]
        XCTAssertEqual(firstItem.id, 4, "The first item's id should be 4")
        XCTAssertEqual(firstItem.name, "Hiking", "The first item's name should be 'Hiking'")
        XCTAssertEqual(firstItem.description, ":)", "The first item's description should be ':)'")
        XCTAssertEqual(firstItem.photoURL, "HikingEB897123-A5EC-4952-8622-4724EB955E19", "The first item's photoURL should be 'HikingEB897123-A5EC-4952-8622-4724EB955E19'")

        let secondItem = mockConnection.wishlist[1]
        XCTAssertEqual(secondItem.id, 6, "The second item's id should be 6")
        XCTAssertEqual(secondItem.name, "Walk", "The second item's name should be 'Walk'")
        XCTAssertEqual(secondItem.description, "Walking", "The second item's description should be 'Walking'")
        XCTAssertEqual(secondItem.photoURL, "Walk2D80C427-B8DB-419B-8B6E-1739C108ACF0", "The second item's photoURL should be 'Walk2D80C427-B8DB-419B-8B6E-1739C108ACF0'")
    }
}

