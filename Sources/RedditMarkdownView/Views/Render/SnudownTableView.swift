//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI


struct SnudownTableView: View {
    
    let table: SnuTableNode
    
    var body: some View {
        ScrollView(.horizontal) {
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                let headers = table.headers.compactMap { $0 as? SnuTableHeaderNode }
                GridRow {
                    ForEach(headers, id: \.id) { header in
                        SnudownRenderSwitch(node: header.children.first ?? header)
                            .bold()
                    }
                }
                
                self.tableBody()
            }
            .scenePadding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.quaternary, lineWidth: 2)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 250 * CGFloat(table.headers.count))
        }
    }
    
    @ViewBuilder
    func tableBody() -> some View {
        let rows = table.children.compactMap { $0 as? SnuTableRowNode }
        ForEach(rows, id: \.id) { row in
            Divider()
            GridRow {
                let cells = row.children.compactMap { $0 as? SnuTableCell }
                ForEach(cells, id: \.id) { cell in
                    SnudownRenderSwitch(node: cell.children.first ?? cell)
                }
            }
        }
    }
}
