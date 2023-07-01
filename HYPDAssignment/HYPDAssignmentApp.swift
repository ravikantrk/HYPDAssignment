//
//  HYPDAssignmentApp.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 29/06/23.
//

import SwiftUI

@main
struct HYPDAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            ProductStoreView(viewModel: ProductStoreViewModel())
        }
    }
}
