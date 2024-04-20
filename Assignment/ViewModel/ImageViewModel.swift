//
//  ImageViewModel.swift
//  Assignment
//
//  Created by Abhishek Kumar Singh on 20/04/24.
//

import Foundation
import UIKit

protocol ImageViewModelDelegate {
    func didReceive(viewmodel: ImageList?)
}

class ImageViewModel {
    var delegate: ImageViewModelDelegate?
    var resource = Resource()
    let imageCache = NSCache<NSURL, UIImage>()
    
    func getImagesList() {
        resource.getImages() { response in
            self.delegate?.didReceive(viewmodel: response)
        }
    }
    
    func loadImage(at imageUrl: URL, id: String, completion: @escaping((UIImage?) -> (Void))) {
        if let cachedImage = imageCache.object(forKey: imageUrl as NSURL) {
            completion(cachedImage)
        }
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            completion(nil)
            return
        }
        
        if url.hasDirectoryPath, let diskImage = loadImageFromDisk(url: imageUrl, fileName: id) {
            imageCache.setObject(diskImage, forKey: imageUrl as NSURL)
            completion(diskImage)
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                debugPrint("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
             
            self.imageCache.setObject(image, forKey: imageUrl as NSURL)
            self.saveImageToDisk(data: data, withUrl: imageUrl, fileName: id)
            completion(image)
            
        }.resume()
    }
    
    private func saveImageToDisk(data: Data, withUrl url: URL, fileName: String) {
        guard let diskCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let filePath = diskCacheURL.appendingPathComponent("\(fileName)\(url.lastPathComponent)")
        
        do {
            try data.write(to: filePath)
        } catch {
            debugPrint("Error saving image to disk: \(error.localizedDescription)")
        }
    }

    private func loadImageFromDisk(url: URL, fileName: String) -> UIImage? {
        guard let diskCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let filePath = diskCacheURL.appendingPathComponent("\(fileName)\(url.lastPathComponent)")
        
        do {
            let imageData = try Data(contentsOf: filePath)
            return UIImage(data: imageData)
        } catch {
            debugPrint("Error loading image from disk: \(error.localizedDescription)")
            return nil
        }
    }
}
