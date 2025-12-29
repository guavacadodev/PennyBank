import Foundation

struct MoneyAmount: Equatable {
    let value: Decimal
    let currencyCode: String

    init(value: Decimal, currencyCode: String = "USD") {
        self.value = value
        self.currencyCode = currencyCode
    }
}

