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
        .frame(width: 300, height: 30)
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
                            return
                        }
                        guard let iID = GlobalManager.shared.selectedInputID else {
                            return
                        }
                        for model in GlobalManager.shared.nodeModels {
                            if model.id == oID.0 {
                                model.outputConnection[oID.1] = iID
                                print(model.outputConnection)
                                GlobalManager.shared.objectWillChange.send()
                            }
                        }
                    }
                )

        }
        .frame(width: 300, height: 30)
        .background(.cyan)
    }
}

class MyNodeSubModel: SubModelBase {
    @Published var sliderValue: Double = 0.0
}

class MyNodeModel: NodeModelBase {
    @objc @Input var input1: Int = 3
    @Middle var count: Int = 0
    @Output(name: "output1") var output1: Int = 0
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
            .frame(minWidth: 200, maxWidth: 200, minHeight: 200)
            .border(Color.gray, width: 2)
        )
    }
}
