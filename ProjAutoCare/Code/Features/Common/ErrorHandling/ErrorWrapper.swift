//
//  ErrorWrapper.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import Foundation
import SwiftUI

struct ErrorWrapper: Identifiable
{
    let id: UUID
    let error: Error
    let guidance: String

    init(id: UUID = UUID(), error: Error, guidance: String)
    {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}

struct ErrorAlert: Identifiable
{
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}
