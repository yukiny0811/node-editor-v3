//
//  EditorView.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/07.
//

import SwiftUI

struct EditorView: View, Identifiable {
    let id: String = UUID.init().uuidString
    @ObservedObject var manager = NodeModelManager.shared
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            HStack {
//                Button("add") {
//                    manager.nodeModels.append(MyNodeModel())
//                }
                ForEach(manager.nodeModels) { nm in
                    nm.content()
                }
            }
            .frame(minWidth: 1500, minHeight: 1500)
        }
    }
}

class NodeModelManager: ObservableObject {
    static let shared = NodeModelManager()
    @Published var nodeModels: [NodeModelBase] = [
        MyNodeModel(),
        MyNodeModel()
    ]
}
