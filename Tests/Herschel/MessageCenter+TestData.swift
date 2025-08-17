import HerschelMessages

extension Herschel.MessageCenter<TestMessage> {
    static var testInstance: Herschel.MessageCenter<TestMessage> {
        Herschel.MessageCenter<TestMessage>.begin()
    }
}
