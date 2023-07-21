//
//  ContentView.swift
//  TodoYandexAppModern
//
//  Created by Илья Колесников on 17.07.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            AssetsColors.backPrimary
                .ignoresSafeArea()
                .overlay(
                    TodoListView()
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
