//
//  Helper.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/8.
//

import SwiftUI
import Foundation
import SDWebImage
import SDWebImageWebPCoder

struct Helper {
  static func fileSize(at url: URL) -> String {
      let fileAttributes = try! FileManager.default.attributesOfItem(atPath: url.path)
      let fileSize = fileAttributes[.size] as! UInt64
      let formatter = ByteCountFormatter()
      formatter.countStyle = .file
      return formatter.string(fromByteCount: Int64(fileSize))
  }
  
  static func openFinder(filePath: String) {
    let url = URL(fileURLWithPath: filePath)
    NSWorkspace.shared.activateFileViewerSelecting([url])
  }
  
  static func saveImage(isShowingAlert: Binding<Bool>, isLoading: Binding<Bool>, selectedImages:Binding<[ImageModel]>, quality: Double) {
    
    if selectedImages.isEmpty {
      isShowingAlert.wrappedValue = true
      return
    }
    
    let coder = SDImageWebPCoder.shared
    let queue = DispatchQueue(label: "com.givebest.webpqueue", qos: .userInitiated, attributes: .concurrent)
    
    isLoading.wrappedValue = true
    
      selectedImages.wrappedValue = selectedImages.wrappedValue.map { item in
      var newItem = item
      newItem.state = 0
      return newItem
    }
    
    for file in selectedImages {
        let fileURL = file.url.wrappedValue
        
      queue.async {
        do {
          let quality = quality / 100.0
            let imageData = try Data(contentsOf: fileURL)
          
          if let image = NSImage(data: imageData) {
            //                        let imageName = fileURL.deletingPathExtension().lastPathComponent
            let webpData = coder.encodedData(with: image, format: .webP, options: [.encodeCompressionQuality: quality])
            let webpURL = fileURL.deletingPathExtension().appendingPathExtension("webp")
            try webpData?.write(to: webpURL, options: .atomic)
            if let index = selectedImages.wrappedValue.firstIndex(where: { $0.path == fileURL.path }) {
                selectedImages.wrappedValue[index].state = 1
                selectedImages.wrappedValue[index].convertedPath = webpURL.path
            }
          } else {
            print("❌Failed to load image at \(fileURL.path).")
            if let index = selectedImages.wrappedValue.firstIndex(where: { $0.path == fileURL.path }) {
                selectedImages.wrappedValue[index].state = -1
            }
          }
        } catch {
          print("❌Error converting \(fileURL.path) to webp: \(error.localizedDescription)")
          if let index = selectedImages.wrappedValue.firstIndex(where: { $0.path == fileURL.path }) {
              selectedImages.wrappedValue[index].state = -1
          }
        }
      }
    }
  }
}
