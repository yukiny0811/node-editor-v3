//
//  ContentView.swift
//  NodeTestTest
//
//  Created by クワシマ・ユウキ on 2022/09/07.
//

import SwiftUI

struct ContentView: View {
    var model = MyNodeModel()
    var body: some View {
        MyNode()
        Button("wow") {
            print(model[keyPath: \.output1])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
