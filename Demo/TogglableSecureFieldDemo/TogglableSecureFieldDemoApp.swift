//
//  TogglableSecureFieldDemoApp.swift
//  TogglableSecureFieldDemo
//
//  Created by pfaramaz on 09.12.21.
//

import SwiftUI

@main
struct TogglableSecureFieldDemoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TogglableDemoView()
                    .tabItem {
                        Label("Togglable", systemImage: "eye.fill")
                    }

                MonospaceDemoView()
                    .tabItem {
                        Label("Monospaced", systemImage: "a.square.fill")
                    }
                
                BindableDemoView()
                    .tabItem {
                        Label("Bindable", systemImage: "powerplug.fill")
                    }

                TogglableInListDemoView()
                    .tabItem {
                        Label("List", systemImage: "list.bullet")
                    }
            }
        }
    }
}
