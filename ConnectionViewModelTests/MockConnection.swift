//
//  MockConnection.swift
//  TestTest
//
//  Created by Ivayla  Panayotova on 19.05.24.
//

import Foundation
@testable import HiJourney_1_2
final class MockConnection : ConnectionProtocol, Mockable{
    var wishlist: [WishlistItem] = []
    func fetchWishlistData() {
        wishlist = loadJSON(filename: "FetchWishlistResponse", type: WishlistItem.self)
    }
    
    
}
