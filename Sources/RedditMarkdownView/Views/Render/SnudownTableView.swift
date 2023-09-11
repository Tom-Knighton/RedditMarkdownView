//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI


struct SnudownTableView: View {
    
    @Environment(\.snuTableColumnAvgWidth) private var tableAvgWidth: CGFloat
    
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
            .frame(width: tableAvgWidth * CGFloat(table.headers.count))
        }
    }
    
    @ViewBuilder
    func tableBody() -> some View {
        let rows = table.children.compactMap { $0 as? SnuTableRowNode }
        ForEach(rows, id: \.id) { row in
            Divider()
            GridRow {
                let cells = row.children.compactMap { $0 as? SnuTableCell }
                ForEach(Array(cells.enumerated()), id: \.element.id) { i, cell in
                    SnudownRenderSwitch(node: cell.children.first ?? cell)
                        .gridColumnAlignment(self.table.alignmentForCol(i))
                        .multilineTextAlignment(self.table.alignmentForCol(i).textAlignment)
                }
            }
        }
    }
}

extension SnuTableNode {
    
    func alignmentForCol(_ col: Int) -> HorizontalAlignment {
        guard  self.headers.count > col else {
            return .leading
        }
        
        let header = self.headers[col] as? SnuTableHeaderNode
        
        switch header?.alignment {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        case .none:
            return .leading
        }
    }
}


extension HorizontalAlignment {
    
    var textAlignment: TextAlignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            return .leading
        }
    }
}
