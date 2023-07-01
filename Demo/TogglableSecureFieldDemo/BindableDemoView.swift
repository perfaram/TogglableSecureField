//
//  BindableDemoView.swift
//  TogglableSecureFieldDemo
//
//  Created by pfaramaz on 14.12.21.
//

import SwiftUI
import TogglableSecureField

struct BindableDemoView: View {
    @State var password = ""
    @State var passwordShown = false
    
    var body: some View {
        VStack {
            BindableSecureField("Password",
                                secureContent: $password,
                                showContent: $passwordShown,
                                onCommit: {
                guard !password.isEmpty else { return }
                print("User gave \(password) as password")
            })
                .padding()
            
            Button((passwordShown ? "Hide" : "Show") + " password") {
                passwordShown.toggle()
            }
            .buttonStyle(.plain)
            .foregroundColor(.blue)

        }
    }
}

struct BindableDemoView_Previews: PreviewProvider {
    static var previews: some View {
        BindableDemoView()
    }
}
