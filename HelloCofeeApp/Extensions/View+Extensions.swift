//
//  View+Extensions.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import Foundation
import SwiftUI

extension View {
    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    @ViewBuilder
    func visible(_ value: Bool) -> some View{
        if value {
            self
        } else {
            EmptyView()
        }
    }
}
