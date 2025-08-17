
extension Herschel.MessageCenter where MessageType: Equatable {
    public func onReceive(
        event: MessageType,
        perform instruction: @escaping () -> ()
    ) {
        onReceive(when: { $0.self == event }, perform: { _ in instruction() })
    }
}
