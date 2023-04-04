//
//  Setting.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/4.
//

import SwiftUI

struct SettingView: View {
  @EnvironmentObject var configModel: ConfigModel
  
  var body: some View {
    VStack {
      Section("设置", content: {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      })
    }
    .navigationTitle("设置")
    .toolbar {
      ToolbarItem(placement: .navigation) {
        NavigationLink {
          ZStack(content: {
            ContentView()
          })
        } label: {
          Label {
            Text("返回")
          } icon: {
            Image(systemName: "chevron.left")
          }
        }
        
//        Button(action: {
//          ContentView()
//        }) {
//          Image(systemName: "chevron.left")
//            .frame(width: 16, height: 16)
//        }
//        .buttonStyle(BorderlessButtonStyle())
      }
    }
  }
}

struct Setting_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
      .environmentObject(ConfigModel())
  }
}
