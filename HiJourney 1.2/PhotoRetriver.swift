//
//  PhotoRetriver.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage

struct PhotoRetriever {
    static func retrievePhoto(url: String, completion: @escaping (UIImage?) -> Void) {
        Storage.storage().reference().child(url).downloadURL { (url, error) in
            DispatchQueue.main.async {
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }

                URLSession.shared.dataTask(with: downloadURL) { data, response, error in
                    guard let data = data else {
                        completion(nil)
                        return
                    }
                    if let image = UIImage(data: data) {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }.resume()
            }
        }
    }
}
