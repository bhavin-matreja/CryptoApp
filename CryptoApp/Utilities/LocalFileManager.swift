//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 11/05/25.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init () {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData(),
            let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        // save image to path
        do {
            try data.write(to: url )
        } catch let error {
            print ("Error saving image \(imageName) \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            // get the image path
            let url = getUrlForImage(imageName: imageName, folderName: folderName),
            // check if file exists at this path
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    // create a folder (if not already created) so to save all images in one folder only
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getUrlForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print ("Error creating directory \(folderName) \(error)")
            }
        }
    }
    
    // get the folder path and return new path with imageName + extension
    private func getUrlForImage(imageName:String, folderName: String) -> URL? {
        guard let folderURL = getUrlForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    // returns path for the folder where to save image
    // THIS IS NOT NSCACHE
    private func getUrlForFolder(folderName: String) -> URL? {
        guard
            // downloading to cache directory, if it ever gets full and deleted, we can always redownload the image
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
}
