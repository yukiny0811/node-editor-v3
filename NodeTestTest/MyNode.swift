//
//  MyNode.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/07.
//

import SwiftUI
import Combine

class NodeModelBase: NSObject, Identifiable, ObservableObject  {
    let id: String = UUID.init().uuidString
    var inputKeys: [String] = []
    override init() {
    }
    public func processOnChange() {
    }
    func content() -> AnyView {
        AnyView(Group{})
    }
}

class MyNodeModel: NodeModelBase {
    @objc @InputModel var input1: Int = 3
    @MiddleModel var count: Int = 0
    @OutputModel var output1: Int = 0
    public override func processOnChange() {
        output1 = input1 * count
    }
    override init() {
        super.init()
        inputKeys = ["input1"]
    }
    override func content() -> AnyView {
        return AnyView(
            Group {
                InputNode()
                Text(String(self.count))
                Button("test") {
                    self.count += 1
                }
                Text(String(self.output1))
            }
        )
    }
}

struct InputNode: View {
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
        }
        .frame(width: 300, height: 30)
        .background(.cyan)
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
            NodeModelManager.shared.objectWillChange.send()
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
            let tempModel = NodeModelManager.shared.nodeModels[1]
            if tempModel != (object as! NodeModelBase) {
                tempModel.setValue(newValue, forKey: "input1")
            }
        }
    }
}
