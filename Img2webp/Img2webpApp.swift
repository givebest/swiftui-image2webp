//
//  Img2webpApp.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/3.
//

import SwiftUI
import Cocoa

@main
struct Img2webpApp: App {
  @StateObject private var configModel = ConfigModel()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: 300, minHeight: 200) // 设置窗口的最小尺寸
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 设置窗口的最大尺寸
        .environmentObject(configModel)
        .onAppear {
          NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            if event.modifierFlags.contains(.command) && event.characters == "," {
              configModel.showSetting.toggle()
            }
          }
        }
        .onDisappear {
          NSEvent.removeMonitor(NSEvent.EventTypeMask.flagsChanged)
        }
    }
  }
}
