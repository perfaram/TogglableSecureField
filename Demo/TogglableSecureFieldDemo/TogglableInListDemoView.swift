//
//  TogglableInListDemoView.swift
//  
//
//  Created by Koliush Dmytro on 10.06.2023.
//

import SwiftUI
import TogglableSecureField

struct TogglableInListDemoView: View {
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
            List {
                Section {
                    TogglableDemoView()
                }

                Section {
                    MonospaceDemoView()
                }

                Section {
                    BindableDemoView()
                }
            }
        }
    }
}

struct TogglableInListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        TogglableInListDemoView()
    }
}

