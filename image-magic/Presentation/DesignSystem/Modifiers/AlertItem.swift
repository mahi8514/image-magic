//
//  Untitled.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    struct Action: Identifiable {
        public let id = UUID()
        public let text: String
        public let role: ButtonRole?
        public let action: () -> ()
        
        public init(text: String, role: ButtonRole? = nil, action: @escaping () -> () = { }) {
            self.text = text
            self.role = role
            self.action = action
        }
    }
    
    let id = UUID()
    let title: String
    let message: String?
    let actions: [Action]?
    
    init(title: String, message: String?, actions: [Action]?) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

struct AlertModifier: ViewModifier {
    
    @Binding var isPresenting: Bool
    @Binding var item: AlertItem?
    
    func body(content: Content) -> some View {
        content
            .alert((item?.title ?? ""), isPresented: $isPresenting, presenting: item, actions: { item in
                if let alertActions = item.actions {
                    ForEach(alertActions, id: \.id) { action in
                        Button(action.text, role: action.role, action: action.action)
                    }
                }
            }, message: { item in
                if let message = item.message {
                    Text(message)
                }
            })
    }
    
}

extension View {
    func alert(isPresenting: Binding<Bool>, item: Binding<AlertItem?>) -> some View {
        modifier(AlertModifier(isPresenting: isPresenting, item: item))
    }
}
