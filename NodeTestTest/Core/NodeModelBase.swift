//
//  NodeModelBase.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI

class NodeModelBase: NSObject, Identifiable, ObservableObject {
    let id: String = UUID.init().uuidString
    var inputKeys: [String] = []
    var originalPosition: CGPoint = CGPoint(x: 100, y: 100)
    var movePosition = CGPoint.zero
    override init() {
    }
    public func processOnChange() {
    }
    func content() -> AnyView {
        AnyView(Group{})
    }
}
