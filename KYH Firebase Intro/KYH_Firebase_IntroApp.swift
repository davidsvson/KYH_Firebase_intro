//
//  KYH_Firebase_IntroApp.swift
//  KYH Firebase Intro
//
//  Created by David Svensson on 2022-03-11.
//

import SwiftUI
import Firebase

@main
struct KYH_Firebase_IntroApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
