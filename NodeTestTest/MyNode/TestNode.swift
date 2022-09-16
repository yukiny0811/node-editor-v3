//
//  TestNode.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI

//Plus Node
class TestNodeModel: NodeModelBase {
    
    @objc @Input var input1: Int = 0
    @objc @Middle var count: Int = 0
    @objc @Output var output1: Int = 0
    
    public override func processOnChange() {
        output1 = input1 + count
    }
    
    override func content() -> AnyView {
        return AnyView(
            VStack {
                InputNode(idString: (self.id, "input1"))
                Button("+\(self.count)") {
                    self.count += 1
                }
                Text("Output↓")
                Text(String(self.output1))
                OutputNode(idString: (self.id, "output1"))
            }
        )
    }
}
