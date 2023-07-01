//
//  ContentView.swift
//  TogglableSecureFieldDemo
//
//  Created by pfaramaz on 09.12.21.
//

import SwiftUI
import TogglableSecureField

struct TogglableDemoView: View {
    @State var password = ""
    
    // These views are only showed during automated UI tests.
    @ViewBuilder var uiTestsAdditions: some View {
        if (ProcessInfo.processInfo.environment["UITEST_SHOW_PASSWORD"] == "YES") {
            Text("Your password is:").padding([.top, .horizontal])
            
            // This "currentPassword" TextField allows to check that
            // the TogglableSecureField content binding works
            TextField("currentPassword", text: $password)
                .disabled(true)
                .padding([.bottom, .horizontal])
        }
    }
    
    var body: some View {
        VStack {
            uiTestsAdditions
            
            TogglableSecureField("MyTogglablePasswordField",
                                 secureContent: $password,
                                 leftView: {
                Image(systemName: "lock.fill")
                    .foregroundColor($password.wrappedValue.isEmpty ? .secondary : .primary)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .frame(width: 18, height: 18, alignment: .center)
                    .accessibilityHidden(true)
            },
                                 onCommit: {
                guard !password.isEmpty else { return }
                print("User gave \(password) as password")
            })
                .padding(12)
                .background(Color.primary.opacity(0.05).cornerRadius(10))
                .padding()
                .buttonStyle(.plain)
        }
    }
}

struct TogglableDemoView_Previews: PreviewProvider {
    static var previews: some View {
        TogglableDemoView()
    }
}
