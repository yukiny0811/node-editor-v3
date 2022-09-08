//
//  Output.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI
import Combine

@propertyWrapper
public struct Output<Value> {
    private var value: Value
    public init (wrappedValue: Value) {
        value = wrappedValue
    }
    public var wrappedValue: Value {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            return object[keyPath: storageKeyPath].value
        }
        set {
            object[keyPath: storageKeyPath].value = newValue
            print(storageKeyPath)
//            let tempModel = NodeModelManager.shared.nodeModels[(object as! NodeModelBase).id]!
//            if tempModel != (object as! NodeModelBase) {
//                tempModel.setValue(newValue, forKey: "input1")
//            }
        }
    }
}
