//
//  NotificationsView.swift
//  SwiftUIRant
//
//  Created by Wilhelm Oks on 09.10.22.
//

import SwiftUI
import SwiftRant

struct NotificationsView: View {
    var navigationBar = true
    
    @StateObject private var viewModel: NotificationsViewModel = .init()
    @ObservedObject private var appState = AppState.shared
    @ObservedObject private var dataStore = DataStore.shared
    
    var body: some View {
        content()
            .if(navigationBar) {
                $0
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        toolbarReloadButton()
                    }
                    
                    //TODO: button to clear all unread notifications
                }
                .navigationTitle("Notifications")
            }
            .alert($viewModel.alertMessage)
            .onReceive(broadcastEvent: .shouldRefreshNotifications) { _ in
                Task {
                    await viewModel.refresh()
                }
            }
            /*.onAppear {
                /*Task {
                    await viewModel.load()
                }*/
                dlog("### NotificationsView onAppear")
            }*/
    }
    
    @ViewBuilder private func content() -> some View {
        VStack {
            Picker(selection: $viewModel.categoryTab, label: EmptyView()) {
                ForEach(viewModel.tabs) { tab in
                    //TODO: The * is temporary just to see if it works
                    let tabTitle = (dataStore.unreadNotifications[tab.category] ?? 0 > 0 ? "* " : "") + tab.displayName
                    Text(tabTitle).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .disabled(viewModel.isLoading)
            .padding(10)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.notificationItems) { item in
                        VStack(spacing: 0) {
                            NavigationLink {
                                RantDetailsView(viewModel: .init(rantId: item.rantId)) //TODO: pass commentId to scroll to
                            } label: {
                                NotificationRowView(item: item)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                            }
                            
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func toolbarReloadButton() -> some View {
        ZStack {
            ProgressView()
                .opacity(viewModel.isLoading ? 1 : 0)
                
            Button {
                Task {
                    await viewModel.load()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .frame(width: 26, height: 26)
            }
            .disabled(viewModel.isLoading)
            .opacity(!viewModel.isLoading ? 1 : 0)
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}