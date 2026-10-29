import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var isRead: Bool

    init(title: String, isRead: Bool = false) {
        self.title = title
        self.isRead = isRead
    }
}
