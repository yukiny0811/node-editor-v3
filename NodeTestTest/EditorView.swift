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
//                        let tempModel = TestNodeModel()
                        manager.nodeModels[tempModel.id] = tempModel
                    }
                    ForEach(Array(manager.nodeModels.values)) { nm in
                        VStack(alignment: .leading, spacing: 0) {
                            Rectangle()
                                .frame(width: 20, height: 20)
                                
                            nm.content()
                                .fixedSize()
                                .background(
                                    GeometryReader { g -> AnyView in
                                        nm.frameSize = g.frame(in: .local).size
                                        print("size", g.frame(in: .local).size)
                                        return AnyView(Group{})
                                    }
                                )
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
                                    manager.objectWillChange.send()
                                }
                        )
                        ForEach(0..<Array(Mirror(reflecting: nm).children).count) { i in
                            VStack(alignment: .leading, spacing: 0) { () -> AnyView in
                                let elem = Array(Mirror(reflecting: nm).children)[i]
                                let rawString = String(describing: elem.value)
                                guard var rawLabel = elem.label else {
                                    return AnyView(
                                        Group{}
                                    )
                                }
                                if rawString.contains("Input<") {
                                    
                                }
                                if rawString.contains("Output<") {
                                    rawLabel.removeFirst()
                                    print(rawLabel)
                                    guard nm.outputConnection[rawLabel] != nil else {
                                        return AnyView(
                                            Group{}
                                        )
                                    }
                                    let destNodeId = nm.outputConnection[rawLabel]!.nodeid
                                    let destInputName = nm.outputConnection[rawLabel]!.inputname
                                    let n = manager.nodeModels[destNodeId]!
                                    
                                    let nElemArray = Array(Mirror(reflecting: n).children)
                                    print("nElemArrayCount", nElemArray.count)
                                    for ind in 0..<nElemArray.count {
                                        let nElem = nElemArray[ind]
                                        let nElemRawString = String(describing: nElem.value)
                                        print(nElemRawString)
                                        guard var nElemRawLabel = nElem.label else {
                                            return AnyView(
                                                Group{}
                                            )
                                        }
                                        if nElemRawString.contains("Input<") {
                                            nElemRawLabel.removeFirst()
                                            if nElemRawLabel == destInputName {
                                                let nPos = n.originalPosition
                                                print("move", nm.originalPosition + nm.movePosition + nm.frameSize.toCGPoint())
                                                print("addline", CGPoint(x: 0, y: 20 + 15 + ind * 30))
                                                print(nm.originalPosition)
//                                                print((nElemArray.count - ind - 1))
                                                return AnyView(
                                                    Path { path in
                                                        path.move(to: nm.originalPosition + nm.movePosition - CGPoint(x: 0, y: 15 + (Array(Mirror(reflecting: nm).children).count - i - 1) * 30) + CGPoint(x: 750, y: 750))
                                                        path.addLine(to: n.movePosition + nPos + CGPoint(x: 0, y: 15 + ind * 30) - nm.frameSize.toCGPoint() + CGPoint(x: 750, y: 750))
                                                    }
                                                        .stroke(.red, lineWidth: 3)
                                                )
                                            }
                                        }
                                    }
                                }
//                                let prot = class_copyProtocolList(NSClassFromString(elem.label), &c)
//                                let cname = protocol_getName(prot[0])
//                                print(cname)
                                return AnyView(
                                    Group{}
                                )
                            }
                            .frame(width: 1500, height: 1500, alignment: .trailing)
                            .fixedSize()
//                            .border(.blue, width: 5)
                            
                            
                        }
                    }
                    
                    
                }
                .frame(minWidth: 1500, minHeight: 1500, alignment: .center)
            }
            .frame(minWidth: 1500, minHeight: 1500, alignment: .leading)
        }
    }
}
