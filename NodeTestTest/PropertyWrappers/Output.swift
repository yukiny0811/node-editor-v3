//
//  Output.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI
import Combine

protocol OutputProtocol {}

@propertyWrapper
public struct Output<Value> : OutputProtocol{
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
            
            let selfName = NSExpression(forKeyPath: wrappedKeyPath).keyPath
            let tempOutputConnection = (object as? NodeModelBase)?.outputConnection[selfName]
            
            guard let outputConnection = tempOutputConnection else {
                return
            }
            GlobalManager.shared.nodeModels[outputConnection.0]!.setValue(newValue, forKey: outputConnection.1)
        }
    }
}
