//
//  Middle.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/09.
//

import Foundation
import SwiftUI
import Combine

@propertyWrapper
public struct Middle<Value> {
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
            (object as? NodeModelBase)?.processOnChange()
            (object.objectWillChange as? ObservableObjectPublisher)?.send()
            GlobalManager.shared.objectWillChange.send()
        }
    }
}
