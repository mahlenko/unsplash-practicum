//
//  ContentView.swift
//  UnsplashPracticum
//
//  Created by Сергей Махленко on 02.01.2023.
//  Copyright © 2023 ru.app-demo.unsplash. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
