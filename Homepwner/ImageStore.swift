//
//  ImageStore.swift
//  Homepwner
//
//  Created by Justin Weiss on 4/2/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class ImageStore {
    //MARK: - Archive
    let cache = NSCache<NSString, UIImage>()
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    //MARK: - ImageStore Actions
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        //Create full url for image
        let url = imageURL(forKey: key)
        
        //Turn image inot JPEF data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            //Write it to full URL
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        //return cache.object(forKey: key as NSString)
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
}
