//
//  FileModel.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/4.
//

import Foundation

struct FileModel: Equatable, Identifiable {
  let id = UUID()
  var file: String
  var state: Int
}
