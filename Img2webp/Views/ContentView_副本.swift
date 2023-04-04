//
//  ContentView.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import SwiftUI
import Foundation
import SDWebImage
import SDWebImageWebPCoder

struct ContentView: View {
  @EnvironmentObject var configModel: ConfigModel
  @State private var results: [String] = []
  //  @State private var showSetting = false
  
  var body: some View {
    VStack {
        Section(content: {
          Button("选择图片") {
            let panel = NSOpenPanel()
            panel.canChooseFiles = true
            panel.canChooseDirectories = false
            panel.allowsMultipleSelection = true
            panel.allowedContentTypes = [.jpeg, .png, .gif]
            
            if panel.runModal() == .OK {
              configModel.selectedImages = panel.urls
              
              if let url = panel.url {
                let selectedFilePath = url.path
                print("Selected file path: \(selectedFilePath)")
              }
            }
          }
        })
      Section(content: {
        List(configModel.selectedImages, id: \.self) {url in
          Text(url.path)
        }
        
  
        
        List(results, id: \.self) {result in
          Text(result)
        }
        
        Button("Convert to WebP") {
          saveImage()
          print("Convert")
        }
      })
      .sheet(isPresented: $configModel.showSetting, content: {
        ZStack(content: {
          SettingView()
        }).frame(width: 400, height: 300)
        
      })
      .navigationTitle("Image2webp")
      .navigationSubtitle("Convert images to webp format")
    }
    .padding()
  }
  
  func saveImage() {
    let coder = SDImageWebPCoder.shared
    let queue = DispatchQueue(label: "com.givebest.webpqueue", qos: .userInitiated, attributes: .concurrent)
    for fileURL in configModel.selectedImages {
      queue.async {
        do {
          let imageData = try Data(contentsOf: fileURL)
          if let image = NSImage(data: imageData) {
            //                        let imageName = fileURL.deletingPathExtension().lastPathComponent
            let webpData = coder.encodedData(with: image, format: .webP, options: nil)
            let webpURL = fileURL.deletingPathExtension().appendingPathExtension("webp")
            try webpData?.write(to: webpURL, options: .atomic)
            print("✅ Successfully converted \(fileURL.path) to webp.")
            results.append("✅ Successfully converted \(fileURL.path) to webp.")
          } else {
            print("❗️Failed to load image at \(fileURL.path).")
            results.append("❗️Failed to load image at \(fileURL.path).")
          }
        } catch {
          print("❗️Error converting \(fileURL.path) to webp: \(error.localizedDescription)")
          results.append("❗️Error converting \(fileURL.path) to webp: \(error.localizedDescription)")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(ConfigModel())
  }
}
