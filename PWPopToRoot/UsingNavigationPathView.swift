//
//  UsingNavigationPathView.swift
//  PWPopToRoot
//
//  Created by Eliezer Rodrigo on 02/10/24.
//

import SwiftUI

enum MyPages: Hashable {
    case view1
    case view2(viewModel: View2Model)
    case view3
    case view4
}

struct UsingNavigationPathView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Button("View 1") {
                    path.append(MyPages.view1)
                }
                Button("View 2") {
                    path.append(MyPages.view2(viewModel: View2Model(value: "Teste Home")))
                }
                Button("View 3") {
                    path.append(MyPages.view3)
                }
                Button("View 4") {
                    path.append(MyPages.view4)
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: MyPages.self) { page in
                switch page {
                case .view1: Number1View(path: $path)
                case .view2(let viewModel): Number2View(path: $path, viewModel: viewModel)
                case .view3: Number3View(path: $path)
                case .view4: Number4View(path: $path)
                }
            }
        }
    }
}

struct Number1View: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Button {
                path.append(MyPages.view2(viewModel: View2Model(value: "Teste From 1")))
            } label: {
                Text("Push")
            }
            Button {
                path.removeLast()
            } label: {
                Text("Pop")
            }
            Button {
                path.removeLast(path.count)
            } label: {
                Text("Pop to root")
            }
        }
        .navigationTitle("Number 1")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct View2Model: Hashable {
    let value: String
}

struct Number2View: View {
    @Binding var path: NavigationPath
    var viewModel: View2Model
    
    var body: some View {
        VStack {
            
            Text(viewModel.value)
                .font(.title)
            
            Button {
                path.append(MyPages.view3)
            } label: {
                Text("Push")
            }
            Button {
                path.removeLast()
            } label: {
                Text("Pop")
            }
            Button {
                path.removeLast(path.count)
            } label: {
                Text("Pop to root")
            }
        }
        .navigationTitle("Number 2")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Number3View: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Button {
                path.append(MyPages.view4)
            } label: {
                Text("Push")
            }
            Button {
                path.removeLast()
            } label: {
                Text("Pop")
            }
            Button {
                path.removeLast(path.count)
            } label: {
                Text("Pop to root")
            }
        }
        .navigationTitle("Number 3")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Number4View: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Button {
                path.append(MyPages.view1)
            } label: {
                Text("Push")
            }
            Button {
                path.removeLast()
            } label: {
                Text("Pop")
            }
            Button {
                path.removeLast(path.count)
            } label: {
                Text("Pop to root")
            }
        }
        .navigationTitle("Number 4")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UsingNavigationPathView()
}
