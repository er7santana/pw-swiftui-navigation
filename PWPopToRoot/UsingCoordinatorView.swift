//
//  UsingCoordinatorView.swift
//  PWPopToRoot
//
//  Created by Eliezer Rodrigo on 02/10/24.
//

import SwiftUI

class Router: ObservableObject {
    // Contains the possible destinations in our Router
    enum Route: Hashable {
        case viewA
        case viewB(viewModel: ViewBModel)
        case viewC
        case viewD
    }
    
    // Used to programatically control our navigation stack
    @Published var path: NavigationPath = NavigationPath()
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .viewA:
            ViewA()
        case .viewB(let viewModel):
            ViewB(viewModel: viewModel)
        case .viewC:
            ViewC()
        case .viewD:
            ViewD()
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack() {
        path.removeLast()
    }
    
    // Pop to the root screen in our hierarchy
    func popToRoot() {
        path.removeLast(path.count)
    }
}

/// View containing the necessary SwiftUI code to utilize a NavigationStack
/// for navigation accross our views.
struct RouterView<Content: View>: View {
    @StateObject var router: Router = Router()
    
    //our root view content
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
    }
}


struct UsingCoordinatorView: View {
    var body: some View {
        RouterView {
            NewHomeView()
        }
    }
}

struct NewHomeView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Go to View A") {
                router.navigateTo(.viewA)
            }
            Button("Go to View B") {
                router.navigateTo(.viewB(viewModel: ViewBModel(value: "Got here from Home")))
            }
            Button("Go to View C") {
                router.navigateTo(.viewC)
            }
            Button("Go to View D") {
                router.navigateTo(.viewD)
            }
        }
        .navigationTitle("Home")
    }
}

struct ViewA: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 50) {
            Button("Go to View B") {
                router.navigateTo(.viewB(viewModel: ViewBModel(value: "Got here from A")))
            }
            Button("Go to View C") {
                router.navigateTo(.viewC)
            }
            Button("Pop") {
                router.navigateBack()
            }
            Button("Pop to root") {
                router.popToRoot()
            }
        }
        .navigationTitle("View A")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewBModel: Hashable {
    let value: String
}

struct ViewB: View {
    @EnvironmentObject var router: Router
    
    var viewModel: ViewBModel
    var body: some View {
        VStack(spacing: 40) {
            Text("B")
            Text(viewModel.value)
            
            Button("Go to View C") {
                router.navigateTo(.viewC)
            }
            Button("Go to View D") {
                router.navigateTo(.viewD)
            }
            Button("Pop") {
                router.navigateBack()
            }
            Button("Pop to root") {
                router.popToRoot()
            }
        }
        .navigationTitle("View B")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewC: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 50) {
            Button("Go to View A") {
                router.navigateTo(.viewA)
            }
            Button("Go to View B") {
                router.navigateTo(.viewB(viewModel: ViewBModel(value: "Got here from C")))
            }
            Button("Pop") {
                router.navigateBack()
            }
            Button("Pop to root") {
                router.popToRoot()
            }
        }
        .navigationTitle("View C")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewD: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 50) {
            Button("Go to View A") {
                router.navigateTo(.viewA)
            }
            Button("Go to View C") {
                router.navigateTo(.viewC)
            }
            Button("Pop") {
                router.navigateBack()
            }
            Button("Pop to root") {
                router.popToRoot()
            }
        }
        .navigationTitle("View D")
        .navigationBarTitleDisplayMode(.inline)    }
}

#Preview {
    UsingCoordinatorView()
}
