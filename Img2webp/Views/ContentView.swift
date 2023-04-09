//
//  ContentView.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import SwiftUI
import Foundation

struct ContentView: View {
  @EnvironmentObject var configModel: ConfigModel
  @State var results: [FileModel] = []
  @State var isLoading: Bool = false
  @State private var isShowingAlert = false
  
  var body: some View {
    VStack {
      Section(content: {        
        ListView(results: results,isLoading:isLoading)
        
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
