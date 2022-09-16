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
                        let tempModel = TestNodeModel()
                        manager.nodeModels[tempModel.id] = tempModel
                    }
                    ForEach(Array(manager.nodeModels.values)) { nm in
//                        ForEach(0..<Array(Mirror(reflecting: nm).children).count) { i in
//                            Group {
//                                let elem = Array(Mirror(reflecting: nm).children)[i]
//                                var c = 0
//                                let prot = class_copyProtocolList(elem.Self, &c)
//                                let cname = protocol_getName(prot[0])
//                                print(cname)
////                                if arr[i].conforms(to: OutputProtocol) {
////                                    Text("name: \(arr[i].label!) type: \(String(describing: arr[i].value))")
////                                } else {
////                                    EmptyView()
////                                }
//                            }
//                        }
                        ForEach(0..<Array(Mirror(reflecting: nm).children).count) { i in
                            Group { () -> TupleView<(Text, Text)> in
                                let elem = Array(Mirror(reflecting: nm).children)[i]
                                var c: UInt32 = 0
                                let rawString = String(describing: elem.value)
                                if rawString.contains("Input<") {
                                    
                                }
                                if rawString.contains("Output<") {
                                    
                                }
//                                let prot = class_copyProtocolList(NSClassFromString(elem.label), &c)
//                                let cname = protocol_getName(prot[0])
//                                print(cname)
                                return ViewBuilder.buildBlock(
                                    Text(""),
                                    Text("")
                                )
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Rectangle()
                                .frame(width: 20, height: 20)
                                
                            nm.content()
                                .fixedSize()
//                                .position(nm.originalPosition + nm.movePosition)
                        }
                        .border(.gray, width: 3)
                        .position(nm.originalPosition + nm.movePosition)
                        .fixedSize()
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if nil == self.selected {
                                        self.selected = nm
                                    }
                                    self.selected?.movePosition = value.translation.toCGPoint()
                                    print(self.selected?.movePosition)
                                    print("started")
                                    manager.objectWillChange.send()
                                }
//                                .updating(self.$dragOffset, body: { (value, state, transaction) in
//                                    state = value.translation.toCGPoint()
//                                    print("updating")
//                                    guard let selected = self.selected else {
//                                        return
//                                    }
//                                    selected.movePosition = dragOffset
//                                })
                                .onEnded { _ in
                                    guard let selected = self.selected else {
                                        return
                                    }
                                    print("ended")
                                    selected.originalPosition += selected.movePosition
                                    selected.movePosition = CGPoint.zero
                                    self.selected = nil
                                }
                        )
                    }
                    
                }
                .frame(minWidth: 1500, minHeight: 1500, alignment: .center)
            }
            .frame(minWidth: 1500, minHeight: 1500, alignment: .leading)
        }
    }
}
