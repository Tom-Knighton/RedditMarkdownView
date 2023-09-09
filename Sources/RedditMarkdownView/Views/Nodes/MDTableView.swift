////
////  File.swift
////  
////
////  Created by Tom Knighton on 08/09/2023.
////
//
//import Foundation
//import SwiftUI
//
//struct MDTableView: View {
//    
//    let table: MarkdownTable
//    
//    var body: some View {
//        ScrollView(.horizontal) {
//            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
//                let headers = table.headers
//                GridRow {
//                    ForEach(headers, id: \.self) { header in
//                        Text(AttributedString(header))
//                            .bold()
//                    }
//                }
//                tableBody()
//            }
//            .modifier(_TableViewModifier())
//            .fixedSize(horizontal: false, vertical: true)
//            .frame(width: 250 * CGFloat(table.headers.count))
//        }
//    }
//    
//    @ViewBuilder
//    func tableBody() -> some View {
//        ForEach(self.table.rows, id: \.self) { row in
//            Divider()
//            GridRow {
//                ForEach(row, id: \.self) { cell in
//                    Text(AttributedString(cell))
//                        .gridColumnAlignment(.leading)
//                        .frame(maxHeight: .infinity, alignment: .topLeading)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Table Style
//
//fileprivate struct _TableViewModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .scenePadding()
//            .overlay {
//                RoundedRectangle(cornerRadius: 8, style: .continuous)
//                    .stroke(.quaternary, lineWidth: 2)
//            }
//    }
//}
