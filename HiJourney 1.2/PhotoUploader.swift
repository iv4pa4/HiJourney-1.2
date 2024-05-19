//
//  PhotoUploader.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//

import SwiftUI
import FirebaseStorage

struct PhotoUploader {
    static func uploadPhoto(image: UIImage, adventureName: String, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference()
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let path = "\(adventureName)\(UUID().uuidString)"
        let fileRef = storageRef.child(path)
        
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(path)
            }
        }
    }
}
