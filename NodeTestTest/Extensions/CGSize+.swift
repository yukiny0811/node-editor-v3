//
//  CGSize+.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation

extension CGSize {
    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}
