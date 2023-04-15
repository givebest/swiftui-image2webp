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
    @State var isLoading: Bool = false
    @State private var isShowingAlert = false
    @State private var fileItems: [FileItem] = []
    @State private var selectedImages: [ImageModel] = []
    
    var body: some View {
        VStack {
            Section(content: {
                ListView(selectedImages: selectedImages, isLoading:isLoading)
                    .onDrop(of: [UTType.image], delegate: FileDropDelegate(fileItems: $fileItems))
                    .frame(minWidth: 400, minHeight: 300)
                    .onChange(of: fileItems) { item in
                        for file in fileItems {
                            let fileItem = file.url
                            
                            let exists = selectedImages.contains { $0.path == fileItem.path }
                            if !exists {
                                selectedImages.append(ImageModel(url: fileItem, path: fileItem.path, convertedPath: "", state: 0, name: fileItem.lastPathComponent))
                            }
                            
                        }
                    }
                
                FooterView(selectedImages: $selectedImages, fileItems: $fileItems, isLoading: $isLoading, isShowingAlert: $isShowingAlert, configModel: configModel)
            })
            .sheet(isPresented: $configModel.showSetting, content: {
                ZStack(content: {
                    SettingView()
                }).frame(width: 400, height: 300)
            })
            .navigationTitle("Image2webp")
            .navigationSubtitle("Convert images to webp format")
            .onChange(of: selectedImages) { newValue in
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
