//
//  DevRantView.swift
//  SwiftUIRant
//
//  Created by Wilhelm Oks on 29.08.22.
//

import SwiftUI
import SwiftRant

struct DevRantView: View {
    @ObservedObject private var dataStore = DataStore.shared
    @StateObject private var viewModel = DevRantViewModel()
    
    var body: some View {
        content()
            .toolbar {
                Button {
                    DispatchQueue.main.async {
                        Networking.shared.logOut()
                    }
                } label: {
                    Text("Log out")
                }
            }
            .navigationTitle("devRant")
            .navigationBarTitleDisplayMode(.inline)
            .alert($viewModel.alertMessage)
    }
    
    @ViewBuilder func content() -> some View {
        ZStack {
            if let rantFeed = DataStore.shared.rantFeed {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(rantFeed.rants, id: \.id) { rant in
                            row(rant: rant)
                        }
                    }
                }
            } else {
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
        }
    }
    
    @ViewBuilder func row(rant: RantInFeed) -> some View {
        VStack(spacing: 0) {
            RantSummaryView(rant: rant)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
            
            Divider()
        }
    }
}

struct DevRantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DevRantView()
        }
    }
}