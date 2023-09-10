//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownQuoteView: View {
    
    let quote: SnuQuoteBlockNode
    
    var body: some View {
        VStack {
            ForEach(quote.children, id: \.id) { child in
                SnudownRenderSwitch(node: child)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .background {
            Color.accentColor
                .opacity(0.1)
        }
        .overlay(alignment: .leading) {
            Color.accentColor
                .frame(width: 4)
        }
        .cornerRadius(3)
    }
}
