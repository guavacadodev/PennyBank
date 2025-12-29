import Foundation

struct Transaction: Identifiable, Equatable {
    enum Direction: Equatable {
        case incoming
        case outgoing
    }

    let id: UUID
    let title: String
    let timestamp: Date
    let category: String
    let direction: Direction
    let amount: MoneyAmount
}

