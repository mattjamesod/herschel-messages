import Foundation
import AsyncAlgorithms

extension Herschel {
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
        
        @discardableResult
        public func onReceive(
            perform instruction: @escaping (MessageType) -> ()
        ) -> SubscriberID {
            onReceive(when: { _ in true }, perform: instruction)
        }
        
        @discardableResult
        public func onReceive(
            when predicate: @escaping (MessageType) -> Bool,
            perform instruction: @escaping (MessageType) -> ()
        ) -> SubscriberID {
            let subscriber = Subscriber(predicate, instruction)
            subscribers.append(subscriber)
            return subscriber.id
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
}

func unimplemented(message: String = "", file: StaticString = #file, line: UInt = #line) {
    fatalError("unimplemented: \(message)", file: file, line: line)
}
