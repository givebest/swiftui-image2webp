//
//  DragView.swift
//  Img2webp
//
//  Created by pei wang on 2023/4/13.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct FileDropDelegate: DropDelegate {
    @Binding var fileItems: [FileItem]

    func performDrop(info: DropInfo) -> Bool {
        let itemProviders = info.itemProviders(for: [UTType.fileURL])

        for itemProvider in itemProviders {
            itemProvider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (item, error) in
                DispatchQueue.main.async {
                    guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                    fileItems.append(FileItem(url: url))
                }
            }
        }
        return true
    }
}
