//
//  RantViewModel.swift
//  SwiftUIRant
//
//  Created by Wilhelm Oks on 22.09.22.
//

import Foundation
import SwiftRant

@MainActor final class RantViewModel: ObservableObject {
    @Published var rant: Rant
    
    @Published var alertMessage: AlertMessage = .none()
    
    @Published var voteController: VoteController!
    
    init(rant: Rant) {
        self.rant = rant
        
        voteController = .init(
            voteState: { [weak self] in
                self?.rant.voteState ?? .unvoted
            },
            score: { [weak self] in
                self?.rant.score ?? 0
            },
            voteAction: { [weak self] voteState in
                let changedRant = try await Networking.shared.vote(rantID: rant.id, voteState: voteState)
                self?.applyChangedData(changedRant: changedRant)
            },
            handleError: { [weak self] error in
                self?.alertMessage = .presentedError(error)
            }
        )
    }
    
    private func applyChangedData(changedRant: Rant) {
        rant = changedRant
        DataStore.shared.update(rantInFeed: rant)
    }
    
    func editRant() {
        //TODO: ...
        alertMessage = .presentedError(message: "Edit rant is not implemented yet.")
    }
}