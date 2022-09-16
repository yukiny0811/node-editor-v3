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
    var originalPosition: CGPoint = CGPoint(x: 0, y: 0)
    var movePosition = CGPoint.zero
    var outputConnection: [String: (nodeid: String, inputname: String)] = [:]
    @Published var frameSize: CGSize = CGSize.zero
    override init() {
        super.init()
    }
    public func processOnChange() {
    }
    func content() -> AnyView {
        AnyView(Group{})
    }
}
