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
    private var name: String
    public init (wrappedValue: Value, name: String) {
        value = wrappedValue
        self.name = name
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
            if (object as? NodeModelBase)?.outputConnection[object[keyPath: storageKeyPath].name] != nil {
                let connection = (object as? NodeModelBase)!.outputConnection[object[keyPath: storageKeyPath].name]!
                print(connection)
                for model in GlobalManager.shared.nodeModels {
                    if model.id == connection.0 {
                        model.setValue(newValue, forKey: connection.1)
                    }
                }
            }
        }
    }
}
