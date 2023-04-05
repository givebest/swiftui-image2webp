//
//  Setting.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/4.
//

import SwiftUI

struct SettingView: View {
  @EnvironmentObject var configModel: ConfigModel
  @State private var isEditing = false
  
  var body: some View {
    VStack {
      Section("Settings", content: {
        Slider(
          value: $configModel.quality,
             in: 10...100,
             step: 5
         ) {
             Text("Quality")
         } minimumValueLabel: {
             Text("10")
         } maximumValueLabel: {
             Text("100")
         } onEditingChanged: { editing in
             isEditing = editing
         }
        Text("\(Int(configModel.quality))")
             .foregroundColor(isEditing ? .red : .blue)
      })
      
      
      Spacer()
      
      Button( action: {
        configModel.showSetting = false
      }, label: {
        HStack {
          Image(systemName: "xmark.circle.fill")
          Text("Close")
        }
       
      })
    }
    .padding()
    .navigationTitle("Settings")
  }
}

struct Setting_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
      .environmentObject(ConfigModel())
  }
}
