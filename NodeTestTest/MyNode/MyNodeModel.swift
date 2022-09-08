//
//  MyNodeModel.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI

struct InputNode: View {
    @State var isMouseOnCircle = false
    var body: some View {
        HStack {
            if isMouseOnCircle {
                Circle()
                    .fill(.yellow)
                    .frame(width: 20, height: 20, alignment: .leading)
                    .onHover { isHovering in
                        if isHovering == false {
                            self.isMouseOnCircle = false
                        }
                    }
            } else {
                Circle()
                    .fill(.gray)
                    .frame(width: 20, height: 20, alignment: .leading)
                    .onTapGesture {
                        self.isMouseOnCircle = true
                    }
            }
        }
        .frame(width: 300, height: 30)
        .background(.cyan)
    }
}

class MyNodeSubModel: ObservableObject{
    @Published var sliderValue: Double = 0.0
}

class MyNodeModel: NodeModelBase {
    @objc @Input var input1: Int = 3
    @Middle var count: Int = 0
    @Output var output1: Int = 0
    @ObservedObject var subModel = MyNodeSubModel()
    public override func processOnChange() {
        output1 = input1 * count
    }
    override init() {
        super.init()
        inputKeys = ["input1"]
    }
    override func content() -> AnyView {
        return AnyView(
            VStack {
                InputNode()
                Text(String(self.count))
                Button("test") {
                    self.count += 1
                }
                Slider(value: self.$subModel.sliderValue, in: 0...100) {
                    
                }
                Text(String(self.output1))
            }
            .frame(minWidth: 200, maxWidth: 200, minHeight: 200)
            .border(Color.gray, width: 2)
        )
    }
}
