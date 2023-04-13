//
//  List.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/8.
//

import SwiftUI

struct ListView: View {
  let results: [FileModel]
  let isLoading: Bool
  
  var body: some View {
    Table(results) {
      TableColumn("File") { item in
        let url = URL(fileURLWithPath: item.file)
        let fileSizeString = Helper.fileSize(at: url)
      
        HStack (){
          Text(item.name)
          Spacer()
          Text(fileSizeString)
        }
      }
      TableColumn("Folder") {item in
        Button(action: {
          Helper.openFinder(filePath: item.fileWebp != "" ? item.fileWebp : item.file)
        }) {
          Image(systemName: "folder.fill")
        }
      }
      .width(40)
      TableColumn("Status") { item in
        let state = item.state
        let url = URL(fileURLWithPath: item.fileWebp)
        let fileSizeString = Helper.fileSize(at: url)
        
        if (state == 1) {
          HStack (){
            Text("✅")
            Spacer()
            Text(fileSizeString)
          }
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
  }
}
