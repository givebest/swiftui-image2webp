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
      TableColumn("File", value: \.file)
      TableColumn("Folder") {item in
        Button(action: {
          Helper.openFinder(filePath:item.file)
        }) {
          Image(systemName: "folder.fill")
        }
      }
      .width(40)
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
  }
}
