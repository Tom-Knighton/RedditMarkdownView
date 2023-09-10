//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI
import Highlightr

struct SnudownCodeView: View {
    
    @Environment(\.colorScheme) private var scheme
    
    let code: SnuCodeBlock
    private let highlightr = Highlightr()
    
    @State private var attributedCode: NSAttributedString? = nil
    @State private var copied: Bool = false
        
    var body: some View {
        ZStack(alignment: .top) {
            Group {
                if let attributedCode {
                    Text(AttributedString(attributedCode))
                } else {
                    Text(code.insideText)
                }
            }
            .lineSpacing(5)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
                
            HStack(alignment: .top) {
                Spacer()
                Button(action: { self.copyCode() }) {
                    HStack {
                        Image(systemName: "doc.on.clipboard")
                            .frame(width: 18, height: 18)
                            .padding(8)
                            .contentShape(.rect())
                        if copied {
                            Image(systemName: "checkmark")
                                .frame(width: 18, height: 18)
                                .padding(8)
                                .contentShape(.rect())
                                .transition(.push(from: .trailing))
                        }
                    }
                }
                .foregroundStyle(.primary)
                .background(
                    .quaternary.opacity(0.2),
                    in: RoundedRectangle(cornerRadius: 5, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                }
                .buttonStyle(.borderless)
                Spacer().frame(width: 6)
            }
            .padding(6)
        }
        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
        .task(priority: .background) {
            let lines = self.code.insideText.split(separator: "\n").prefix(2)
            var languageToCheck = ""
            if self.code.insideText.hasPrefix("\n") {
                languageToCheck = lines[1].lowercased()
            } else {
                languageToCheck = lines[0].lowercased()
            }
            
            let language = highlightr?.supportedLanguages().first(where: { $0 == languageToCheck })
            var text = self.code.insideText
            if language != nil {
                text = self.code.insideText.split(separator: "\n").dropFirst().joined(separator: "\n")
            }
            
            highlightr?.setTheme(to: self.scheme == .dark ? "dark" : "s")
            attributedCode = highlightr?.highlight(text, as: language)
        }
        .onChange(of: self.scheme) { newValue in
            self.highlightr?.setTheme(to: newValue == .dark ? "dark" : "xcode")
        }
    }
    
    private func copyCode() {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self.code.insideText, forType: .string)
        #else
        UIPasteboard.general.string = self.code.insideText
        #endif
        
        Task {
            withAnimation(.spring(duration: 0.3)) {
                self.copied = true
            }
            
            try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.spring(duration: 0.3)) {
                self.copied = false
            }
        }
    }
}
