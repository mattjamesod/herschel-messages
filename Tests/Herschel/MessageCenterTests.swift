import Testing
@testable import HerschelMessages

struct MessageCenterTests {
    let messageCenter = Herschel.MessageCenter<TestMessage>.testInstance
    
    @Test func multipleCallbacksAreTriggered() async {
        var data = 0
        var string = "World"
        var bool = false
        
        await messageCenter.onReceive(event: .hello()) {
            data = 1
        }
        
        await messageCenter.onReceive(event: .hello()) {
            string = "Hello"
        }
        
        await messageCenter.onReceive(event: .hello()) {
            bool = true
        }
        
        await messageCenter.send(message: .hello())
        await confirmation()
        
        #expect(data == 1)
        #expect(string == "Hello")
        #expect(bool)
    }
    
    @Test func universalCallbacksTriggerForAnyEvent() async {
        var data = ""
        
        await messageCenter.onReceive { event in
            data += event.content
        }
        
        await messageCenter.send(message: .hello("greetings"))
        await messageCenter.send(message: .goodbye("farewells"))
        await confirmation()
        
        #expect(data == "greetingsfarewells")
    }
    
    @Test func predicatesAreRespected() async {
        var data = 0
        
        await messageCenter.onReceive(when: { $0.content == "privet" }) { event in
            data = 1
        }
        
        await messageCenter.send(message: .hello("greetings"))
        await confirmation()
        
        #expect(data == 0)
        
        await messageCenter.send(message: .hello("privet"))
        await confirmation()
        
        #expect(data == 1)
    }
    
    private func confirmation() async {
        // this is a bad hack, because the expecations are a race condition
        // trying to call messages.finish on the message center is a seg fault,
        // for no reason I can determine
        try? await Task.sleep(for: .milliseconds(1))
    }
}
