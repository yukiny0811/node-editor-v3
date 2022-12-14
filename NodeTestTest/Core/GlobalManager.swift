//
//  GlobalManager.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI

class GlobalManager: ObservableObject {
    static let shared = GlobalManager()
    @Published var nodeModels: [String: NodeModelBase] = [:]
    @Published var selectedOutputID: (String, String)?
    @Published var selectedInputID: (String, String)?
}
