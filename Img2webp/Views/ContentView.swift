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
import LoadingButton


struct ContentView: View {
  @EnvironmentObject var configModel: ConfigModel
  @State var results: [FileModel] = []
  @State var isLoading: Bool = false
  
  var style = LoadingButtonStyle(
    height: 20,
    cornerRadius: 10)
  
  
  var body: some View {
    VStack {
      Section(content: {
        List(results, id: \.self.file) {item in
          HStack {
            Text(item.file)
            if (item.state == 1) {
              Text("✅")
            } else if (item.state == -1) {
              Text("❗️")
            }
          }
        }
        
        
        HStack (alignment: .center, spacing: 20){
          Button("选择图片") {
            let panel = NSOpenPanel()
            panel.canChooseFiles = true
            panel.canChooseDirectories = false
            panel.allowsMultipleSelection = true
            panel.allowedContentTypes = [.jpeg, .png, .gif]
            
            if panel.runModal() == .OK {
              let fileList = panel.urls
              configModel.selectedImages = fileList
              results = []
              
              for file in fileList {
                results.append(FileModel(file: file.path, state: 0))
              }
            }
          }
          
          Spacer()
          LoadingButton(action: {
            saveImage()
          }, isLoading: $isLoading, style:style) {
            Text("Convert to WebP").foregroundColor(Color.white)
          }
        }
      })
      .sheet(isPresented: $configModel.showSetting, content: {
        ZStack(content: {
          SettingView()
        }).frame(width: 400, height: 300)
      })
      .navigationTitle("Image2webp")
      .navigationSubtitle("Convert images to webp format")
      .onChange(of: results) { newValue in
        
        if (isLoading) {
          let state  = newValue.contains(where: { $0.state == 0 })
          isLoading = state
        }
        
        print("Count changed to \(newValue)")
      }
    }
    
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: {
          configModel.showSetting.toggle()
        }, label: {
          Image(systemName: "gear")
        })
      }
    }
    .padding()
  }
  
  
  func saveImage() {
    let coder = SDImageWebPCoder.shared
    let queue = DispatchQueue(label: "com.givebest.webpqueue", qos: .userInitiated, attributes: .concurrent)
    
    isLoading = true
    
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
            //                results.append("✅ Successfully converted \(fileURL.path) to webp.")
            
            if let index = results.firstIndex(where: { $0.file == fileURL.path }) {
              results[index].state = 1
            }
          } else {
            print("❗️Failed to load image at \(fileURL.path).")
            if let index = results.firstIndex(where: { $0.file == fileURL.path }) {
              results[index].state = -1
            }
            //                results.append("❗️Failed to load image at \(fileURL.path).")
          }
        } catch {
          print("❗️Error converting \(fileURL.path) to webp: \(error.localizedDescription)")
          if let index = results.firstIndex(where: { $0.file == fileURL.path }) {
            results[index].state = -1
          }
          //              results.append("❗️Error converting \(fileURL.path) to webp: \(error.localizedDescription)")
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
