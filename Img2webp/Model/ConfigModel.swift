//
//  ConfigModel.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import Foundation
import Combine

final class ConfigModel: ObservableObject {
  @Published var showSetting: Bool = false
  @Published var quality = 75.0
  @Published var isLoading: Bool = false
}
