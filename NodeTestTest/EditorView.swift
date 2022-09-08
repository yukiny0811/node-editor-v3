//
//  EditorView.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/07.
//

import SwiftUI

struct EditorView: View, Identifiable {
    let id: String = UUID.init().uuidString
    @StateObject var manager = GlobalManager.shared
    @State var selected: NodeModelBase?
    @GestureState var dragOffset = CGPoint.zero
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            GeometryReader {reader in
                ZStack {
                    Button("add") {
                        let tempModel = MyNodeModel()
                        manager.nodeModels.append(tempModel)
                    }
                    ForEach(manager.nodeModels) { nm in
                        VStack {
                            Rectangle()
                                .frame(width: 20, height: 20, alignment: .center)
                                .position(nm.originalPosition + nm.movePosition)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if nil == self.selected {
                                                self.selected = nm
                                            }
                                        }
                                        .updating(self.$dragOffset, body: { (value, state, transaction) in
                                            state = value.translation.toCGPoint()
                                            guard let selected = self.selected else {
                                                return
                                            }
                                            selected.movePosition = dragOffset
                                        })
                                        .onEnded { _ in
                                            guard let selected = self.selected else {
                                                return
                                            }
                                            selected.originalPosition += selected.movePosition
                                            selected.movePosition = CGPoint.zero
                                            self.selected = nil
                                        }
                                )
                            nm.content()
                                .frame(width: 100, height: 100, alignment: .center)
                                .position(nm.originalPosition + nm.movePosition)
                        }
                        .frame(width: 100, height: 200, alignment: .center)
                    }
                }
                .frame(minWidth: 1500, minHeight: 1500, alignment: .center)
            }
            .frame(minWidth: 1500, minHeight: 1500, alignment: .leading)
        }
    }
}
