//
//  ThreadsView.swift
//  ThreadsChat
//
//  Created by Andrii Stetsenko on 02.11.2023.
//

import SwiftUI

struct ThreadsView: View {
    @StateObject private var viewModel = ThreadsViewModel()

    var body: some View {

        List(viewModel.activities) { item in
            ThreadActivityRowView(model: item)
        }
        .listStyle(PlainListStyle())
    }
}

struct ThreadsView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadsView()
    }
}
