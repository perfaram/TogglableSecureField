//
//  ContentView.swift
//  TogglableSecureFieldDemo
//
//  Created by pfaramaz on 09.12.21.
//

import SwiftUI
import TogglableSecureField

struct ContentView: View {
    @State var password = ""
    @State var useMonospacedFont = false
    
    var body: some View {
        if (ProcessInfo.processInfo.environment["UITEST_SHOW_PASSWORD"] == "YES") {
            // These views only serve testing purposes
            // Specifically, the currentPassword TextField allows to check that
            // the TogglableSecureField content binding works
            Text("Your password is:").padding([.top, .horizontal])
            TextField("currentPassword", text: $password)
                .disabled(true)
                .padding([.bottom, .horizontal])
        }
        SecureField("test", text: $password).padding()
        
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
            print(password)
        })
            .useMonospacedFont($useMonospacedFont.wrappedValue)
            .padding(12)
            .background(Color.primary.opacity(0.05).cornerRadius(10))
            .padding()
        
        Button("Toggle monospaced font") {
            useMonospacedFont.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
