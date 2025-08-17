import SwiftUI

extension View {
    func onReceive<MessageType: Herschel.Messagable>(
        on messageCenter: Herschel.MessageCenter<MessageType>,
        perform instruction: @escaping (MessageType) -> ()
    ) -> some View {
        Task { await messageCenter.onReceive(perform: instruction) }
        return self
    }
    
    func onReceive<MessageType: Herschel.Messagable>(
        when predicate: @escaping (MessageType) -> Bool,
        on messageCenter: Herschel.MessageCenter<MessageType>,
        perform instruction: @escaping  (MessageType) -> ()
    ) -> some View {
        Task { await messageCenter.onReceive(when: predicate, perform: instruction) }
        return self
    }
}
