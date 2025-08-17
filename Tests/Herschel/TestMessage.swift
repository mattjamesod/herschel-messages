import HerschelMessages

enum TestMessage: Herschel.Messagable, Equatable {
    case hello(String = "")
    case goodbye(String = "")
    
    var content: String {
        switch self {
        case .hello(let string): string
        case .goodbye(let string): string
        }
    }
}
