//
//  ContentView.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers


struct ContentView: View {
  @EnvironmentObject var configModel: ConfigModel
  @State private var results: [FileModel] = []
  @State var isLoading: Bool = false
  @State private var isShowingAlert = false
  
  @State private var fileItems: [FileItem] = []
  
  var body: some View {
    VStack {
      Section(content: {
//        if (results.isEmpty) {
//          Text("Drag and drop images")
//            .font(.headline)
//            .padding()
//
//          List(fileItems) { fileItem in
//            Text(fileItem.url.path)
//          }
//          .onDrop(of: [UTType.fileURL], delegate: FileDropDelegate(fileItems: $fileItems))
//          .frame(minWidth: 400, minHeight: 300)
//        } else {
//          ListView(results: results,isLoading:isLoading)
//        }
        
        ListView(results: results,isLoading:isLoading)
//          .onDrop(of: [UTType.fileURL], delegate: FileDropDelegate(fileItems: $fileItems))
          .onDrop(of: [UTType.fileURL], delegate: FileDropDelegate(fileItems: $fileItems))
          .frame(minWidth: 400, minHeight: 300)
          .onChange(of: fileItems) { item in
            print("ListView", fileItems)

            
            for file in fileItems {
              results.append(FileModel(file: file.url.path, fileWebp: "", state: 0, name: file.url.lastPathComponent))
            }
          }
        
        FooterView(selectedImages: $configModel.selectedImages, results: $results, isLoading: $isLoading, isShowingAlert: $isShowingAlert, configModel: configModel)
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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(ConfigModel())
  }
}
