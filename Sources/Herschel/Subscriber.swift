
extension Herschel {
    class Subscriber<MessageType: Messagable> {
        let id: SubscriberID
        private let predicate: (MessageType) -> Bool
        private let instruction: (MessageType) -> ()
        
        init(_ predicate: @escaping (MessageType) -> Bool, _ instruction: @escaping (MessageType) -> Void) {
            self.id = SubscriberID()
            self.predicate = predicate
            self.instruction = instruction
        }
        
        func receive(message: MessageType) {
            guard predicate(message) else { return }
            instruction(message)
        }
    }
}
