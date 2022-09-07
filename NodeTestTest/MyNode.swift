//
//  MyNode.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/07.
//

import SwiftUI
import Combine

class MyNodeModel: ObservableObject {
    @InputModel var input1: Int = 3
    @MiddleModel var count: Int = 0
    @OutputModel var output1: Int = 0
    public func processOnChange() {
        output1 = input1 * count
    }
    init() {
    }
    let inputPath: [String : ReferenceWritableKeyPath<MyNodeModel, Int>] = [
        "input1": \.input1
    ]
}

struct InputNode: View {
    let path: String
    @State var isMouseOnCircle = false
    var body: some View {
        HStack {
            if isMouseOnCircle {
                Circle()
                    .fill(.yellow)
                    .frame(width: 20, height: 20, alignment: .leading)
                    .onHover { isHovering in
                        if isHovering == false {
                            self.isMouseOnCircle = false
                        }
                    }
            } else {
                Circle()
                    .fill(.gray)
                    .frame(width: 20, height: 20, alignment: .leading)
                    .onTapGesture {
                        self.isMouseOnCircle = true
                    }
            }
            Text(path)
        }
        .frame(width: 300, height: 30)
        .background(.cyan)
    }
}

struct MyNode: View {
    @ObservedObject var model: MyNodeModel = MyNodeModel()
    var body: some View {
        InputNode(path: "input1")
        Text(String(model.count))
        Button("test") {
            model.count += 1
        }
        Text(String(model.output1))
    }
}

@propertyWrapper
public struct InputModel<Value> {
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
            (object as? MyNodeModel)?.processOnChange()
            (object.objectWillChange as? ObservableObjectPublisher)?.send()
        }
    }
}

@propertyWrapper
public struct MiddleModel<Value> {
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
            (object as? MyNodeModel)?.processOnChange()
            (object.objectWillChange as? ObservableObjectPublisher)?.send()
        }
    }
}

@propertyWrapper
public struct OutputModel<Value> {
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
//            (object as? MyNodeModel)?.updateConnectedInput()
        }
    }
}
