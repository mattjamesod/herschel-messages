import Foundation
import AsyncAlgorithms

public struct Herschel {
    
    public protocol Messagable: Sendable { }
    
    /// Provides an interface for sending and receiving abstract messages asynchronously
    ///
    /// Support multiple subscribers who might only care about subset of events
    /// Events can be received in a SwiftUI callback, or through a Messenger class
    public actor MessageCenter<MessageType: Messagable> {
        private var messages: AsyncChannel<MessageType> = .init()
        private var subscribers: [Subscriber<MessageType>] = .init()
        
        private var listening: Task<Void, Never>? = nil
        
        private init() {}
        
        public static func begin() -> MessageCenter<MessageType> {
            let newMessageCenter = self.init()
            Task {
                await newMessageCenter.startListening()
            }
            return newMessageCenter
        }
        
        public func send(message: MessageType) async {
            await messages.send(message)
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
            subscribers.append(.init(predicate, instruction))
        }
        
        func startListening() {
            self.listening = Task { [unowned self] in
                for await message in self.messages {
                    for subscriber in self.subscribers {
                        subscriber.receive(message: message)
                    }
                }
            }
        }
        
        public func cancel() {
            unimplemented()
        }
    }
    
    class Subscriber<MessageType: Messagable> {
        private let predicate: (MessageType) -> Bool
        private let instruction: (MessageType) -> ()
        
        init(_ predicate: @escaping (MessageType) -> Bool, _ instruction: @escaping (MessageType) -> Void) {
            self.predicate = predicate
            self.instruction = instruction
        }
        
        func receive(message: MessageType) {
            guard predicate(message) else { return }
            instruction(message)
        }
    }
}

extension Herschel.MessageCenter where MessageType: Equatable {
    public func onReceive(
        event: MessageType,
        perform instruction: @escaping () -> ()
    ) {
        onReceive(when: { $0.self == event }, perform: { _ in instruction() })
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
