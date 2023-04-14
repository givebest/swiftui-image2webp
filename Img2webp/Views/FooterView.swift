//
//  FooterView.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/8.
//

import SwiftUI

struct FooterView: View {
  @Binding var selectedImages: [ImageModel]
  @Binding var isLoading: Bool
  @Binding var isShowingAlert: Bool
  var configModel: ConfigModel
  
    var body: some View {
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

            
            for file in fileList {
                
                selectedImages.append(ImageModel(url: file, path: file.path, convertedPath: "", state: 0, name: file.lastPathComponent))
                

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
            Helper.saveImage(isShowingAlert: $isShowingAlert, isLoading: $isLoading, selectedImages: $selectedImages, quality: configModel.quality)
        }
        .alert(isPresented: $isShowingAlert) {
          Alert(title: Text("No Items"), message: Text("Please select images."), dismissButton: .default(Text("OK")))
        }
        .padding()
      }
    }
}
