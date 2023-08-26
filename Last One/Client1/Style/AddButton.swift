//
//  AddButton.swift
//  Client1
//
//  Created by ii on 18.06.23.
//

import Foundation
import SwiftUI

struct AddButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)

            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .foregroundStyle(.black)
            .clipShape(Capsule()
            )
            
    }
}
