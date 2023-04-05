//
//  LoadingButton.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/5.
//

import SwiftUI

struct LoadingBtn: View {
  let title: String
  @Binding var isLoading: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: {
      action()
    }) {
      LabeledContent(title, content: {
        if isLoading {
          ProgressView()
            .scaleEffect(0.3)
            .progressViewStyle(CircularProgressViewStyle())
        }
      })
    }
    .disabled(isLoading)
  }
}
