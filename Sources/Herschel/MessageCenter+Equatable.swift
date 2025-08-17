
extension Herschel.MessageCenter where MessageType: Equatable {
    @discardableResult
    public func onReceive(
        event: MessageType,
        perform instruction: @escaping () -> ()
    ) -> Herschel.SubscriberID {
        onReceive(when: { $0.self == event }, perform: { _ in instruction() })
    }
}
