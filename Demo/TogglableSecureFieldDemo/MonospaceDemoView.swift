//
//  MonospaceDemoView.swift
//  TogglableSecureFieldDemo
//
//  Created by pfaramaz on 14.12.21.
//

import SwiftUI
import TogglableSecureField

struct MonospaceDemoView: View {
    @State var password = ""
    @State var useMonospacedFont = false
    
    var body: some View {
        VStack {
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
                .useMonospacedFont($useMonospacedFont.wrappedValue)
                .padding(12)
                .background(Color.primary.opacity(0.05).cornerRadius(10))
                .padding()
            
            Button("Toggle monospaced font") {
                useMonospacedFont.toggle()
            }
            .buttonStyle(.plain)
            .foregroundColor(.blue)
        }
    }
}

struct MonospaceDemoView_Previews: PreviewProvider {
    static var previews: some View {
        MonospaceDemoView()
    }
}
