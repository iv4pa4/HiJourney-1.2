//
//  Mockable.swift
//
//  Created by Ivayla  Panayotova on 19.05.24.
//

import Foundation
protocol Mockable {
    var bundle: Bundle {get}
    func loadJSON<T:Decodable>(filename: String, type: T.Type) -> [T]
}

extension Mockable{
    var bundle: Bundle{
        return Bundle(for: type(of: self) as! AnyClass)
    }
    func loadJSON<T:Decodable>(filename: String, type: T.Type) -> [T]{
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to oad the JSON file")
        }
        do{
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode([T].self, from: data)
            return decodedObject
        }
        catch{
            fatalError("Failed to decode the JSON")
            
        }
    }
}


