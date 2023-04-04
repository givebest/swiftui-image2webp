//
//  ConfigModel.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import Foundation
import Combine

final class ConfigModel: ObservableObject {
  var xx = true;
  var name = "test name"
  @Published var showSetting: Bool = false
  
  @Published var selectedImages: [URL] = []
  @Published var results: [String] = []
}
