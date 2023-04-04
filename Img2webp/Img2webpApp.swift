//
//  Img2webpApp.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import SwiftUI

@main
struct Img2webpApp: App {
  @StateObject private var configModel = ConfigModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(configModel)
        }
    }
}
