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
import SDWebImageWebPCoder

struct Person: Identifiable {
    let givenName: String
    let familyName: String
    let emailAddress: String
    let id = UUID()

    var fullName: String { givenName + " " + familyName }
}

struct ContentView: View {
  @EnvironmentObject var configModel: ConfigModel
  @State var results: [FileModel] = []
  @State var isLoading: Bool = false
  @State private var isShowingAlert = false
  
  @State private var people = [
      Person(givenName: "Juan", familyName: "Chavez", emailAddress: "juanchavez@icloud.com"),
      Person(givenName: "Mei", familyName: "Chen", emailAddress: "meichen@icloud.com"),
      Person(givenName: "Tom", familyName: "Clark", emailAddress: "tomclark@icloud.com"),
      Person(givenName: "Gita", familyName: "Kumar", emailAddress: "gitakumar@icloud.com")
  ]
  
  var body: some View {
    VStack {
      Section(content: {
        Table(results) {
          TableColumn("File", value: \.file)
          TableColumn("Status") { item in
            let state = item.state
            if (state == 1) {
              Text("✅")
            } else if (item.state == -1) {
              Text("❌")
            } else if (isLoading){
              ProgressView()
                .scaleEffect(0.3)
                .progressViewStyle(CircularProgressViewStyle())
                .frame(height: 10)
            }
          }
          .width(100)
        }
        
        HStack (alignment: .center, spacing: 20){
          Button(action: {
            let panel = NSOpenPanel()
            panel.canChooseFiles = true
            panel.canCreateDirectories = true
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
          }) {
            HStack {
              Image(systemName: "rectangle.stack.fill.badge.plus")
              Text("Add images")
            }
          }
          
          
          Spacer()
          LoadingBtn(title: "Convert to WebP", icon: "play.circle.fill", isLoading: $isLoading) {
            saveImage()
          }
          .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("No Items"), message: Text("Please select images."), dismissButton: .default(Text("OK")))
          }
          
          .padding()
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
          Image(systemName: "gearshape.fill")
        })
      }
    }
    .padding()
  }
  
  
  func saveImage() {
    
    if configModel.selectedImages.isEmpty {
      isShowingAlert = true
      return
    }
    
    let coder = SDImageWebPCoder.shared
    let queue = DispatchQueue(label: "com.givebest.webpqueue", qos: .userInitiated, attributes: .concurrent)
    
    isLoading = true
    
    results = results.map { item in
      var newItem = item
      newItem.state = 0
      return newItem
    }
    
    for fileURL in configModel.selectedImages {
      queue.async {
        do {
          let quality = configModel.quality / 100.0
          let imageData = try Data(contentsOf: fileURL)
          
          if let image = NSImage(data: imageData) {
            //                        let imageName = fileURL.deletingPathExtension().lastPathComponent
            let webpData = coder.encodedData(with: image, format: .webP, options: [.encodeCompressionQuality: quality])
            let webpURL = fileURL.deletingPathExtension().appendingPathExtension("webp")
            try webpData?.write(to: webpURL, options: .atomic)
            if let index = results.firstIndex(where: { $0.file == fileURL.path }) {
              results[index].state = 1
            }
          } else {
            print("❌Failed to load image at \(fileURL.path).")
            if let index = results.firstIndex(where: { $0.file == fileURL.path }) {
              results[index].state = -1
            }
          }
        } catch {
          print("❌Error converting \(fileURL.path) to webp: \(error.localizedDescription)")
          if let index = results.firstIndex(where: { $0.file == fileURL.path }) {
            results[index].state = -1
          }
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
