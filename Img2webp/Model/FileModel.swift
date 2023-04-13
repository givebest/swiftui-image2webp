//
//  FileModel.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/4.
//

import Foundation
import UniformTypeIdentifiers

struct FileModel: Equatable, Identifiable {
  let id = UUID()
  var file: String
  var fileWebp: String
  var state: Int
  var name: String
}

struct FileItem: Identifiable, Equatable {
    let id = UUID()
    let url: URL
}
