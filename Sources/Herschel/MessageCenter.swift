import Foundation
import AsyncAlgorithms

public struct Herschel {
    
    public protocol Messagable: Sendable {
        
    }
    
    /// Provides an interface for sending and receiving abstract messages asynchronously
    ///
    /// Support multiple subscribers who might only care about subset of events
    /// Events can be received in a SwiftUI callback, or through a Messenger class
    public actor MessageCenter<MessageType: Messagable> {
        public func send(event: MessageType) {
            unimplemented()
        }
        
        public func onReceive(
            perform instruction: @escaping (MessageType) -> ()
        ) {
            onReceive(when: { _ in true }, perform: instruction)
        }
        
        public func onReceive(
            when predicate: @escaping (MessageType) -> Bool,
            perform instruction: @escaping (MessageType) -> ()
        ) {
            unimplemented()
        }
    }
}

extension Herschel.MessageCenter where MessageType: Equatable {
    public func onReceive(
        event: MessageType,
        perform instruction: @escaping (MessageType) -> ()
    ) {
        onReceive(when: { $0.self == event }, perform: instruction)
    }
}

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

func unimplemented(message: String = "", file: StaticString = #file, line: UInt = #line) {
    fatalError("unimplemented: \(message)", file: file, line: line)
}
