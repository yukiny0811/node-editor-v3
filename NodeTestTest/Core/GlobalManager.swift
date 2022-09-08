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
    @Published var nodeModels: [NodeModelBase] = []
}
