//
//  MyNodeModel.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI

struct InputNode: View {
    let idString: (String, String)
    var body: some View {
        HStack {
            Circle()
                .fill(.yellow)
                .frame(width: 20, height: 20, alignment: .leading)
                .onHover{ hovering in
                    print("test")
                    GlobalManager.shared.selectedInputID = self.idString
                }
        }
        .frame(width: 200, height: 30)
        .background(.cyan)
    }
}

struct OutputNode: View {
    let idString: (String, String)
    var body: some View {
        HStack {
            Circle()
                .fill(.yellow)
                .frame(width: 20, height: 20, alignment: .leading)
                .gesture(DragGesture()
                    .onChanged(){ _ in
                        print("down")
                        if GlobalManager.shared.selectedOutputID == nil {
                            GlobalManager.shared.selectedOutputID = self.idString
                        } else {
                            if GlobalManager.shared.selectedOutputID! != self.idString {
                                GlobalManager.shared.selectedOutputID = self.idString
                            }
                        }
                    }
                    .onEnded() { _ in
                        guard let oID = GlobalManager.shared.selectedOutputID else {
                            GlobalManager.shared.selectedOutputID = nil
                            GlobalManager.shared.selectedInputID = nil
                            return
                        }
                        guard let iID = GlobalManager.shared.selectedInputID else {
                            GlobalManager.shared.selectedOutputID = nil
                            GlobalManager.shared.selectedInputID = nil
                            return
                        }
                        if oID != self.idString {
                            GlobalManager.shared.selectedOutputID = nil
                            GlobalManager.shared.selectedInputID = nil
                            return
                        }
                        if oID.0 == iID.0 {
                            GlobalManager.shared.selectedOutputID = nil
                            GlobalManager.shared.selectedInputID = nil
                            return
                        }
                        print("idtest", oID, iID)
                        
                        
                        guard GlobalManager.shared.nodeModels[oID.0] != nil else {
                            return
                        }
//                        for model in GlobalManager.shared.nodeModels {
//                            if model.id == oID.0 {
                        GlobalManager.shared.nodeModels[oID.0]!.outputConnection[oID.1] = iID
                        print(GlobalManager.shared.nodeModels[oID.0]!.outputConnection)
                        let tempValue = GlobalManager.shared.nodeModels[oID.0]!.value(forKey: oID.1)
                        print(tempValue)
                        GlobalManager.shared.nodeModels[oID.0]!.setValue(tempValue, forKey: oID.1)
    
                        GlobalManager.shared.selectedOutputID = nil
                        GlobalManager.shared.selectedInputID = nil
                        return
//                            }
//                        }
                    }
                )

        }
        .frame(width: 200, height: 30)
        .background(.cyan)
    }
}

class MyNodeSubModel: SubModelBase {
    @Published var sliderValue: Double = 0.0
}

class MyNodeModel: NodeModelBase {
    @objc @Input var input1: Int = 3
    @objc @Middle var count: Int = 0
    @objc @Output var output1: Int = 0
    @ObservedObject var subModel = MyNodeSubModel()
    public override func processOnChange() {
        output1 = input1 * count
    }
    override init() {
        super.init()
    }
    override func content() -> AnyView {
        return AnyView(
            VStack {
                InputNode(idString: (self.id, "input1"))
                Text(String(self.count))
                Button("test") {
                    self.count += 1
                }
                Slider(value: self.$subModel.sliderValue, in: 0...100, onEditingChanged: { changed in
                    self.count = Int(self.subModel.sliderValue)
                })
                Text(String(self.output1))
                OutputNode(idString: (self.id, "output1"))
            }
            .frame(minWidth: 200, maxWidth: 200)
            .border(Color.gray, width: 2)
            .fixedSize()
        )
    }
}
