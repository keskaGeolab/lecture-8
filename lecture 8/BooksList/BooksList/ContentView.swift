import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Book.title) private var books: [Book]
    @State private var title = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    TextField("წიგნის სათაური", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(addBook)

                    Button(action: addBook) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)

                if books.isEmpty {
                    Spacer()
                    Image(systemName: "books.vertical")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("წიგნები ჯერ არ არის")
                        .font(.headline)
                    Text("დაამატე პირველი წიგნი")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(books) { book in
                            Button {
                                book.isRead.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: book.isRead ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundStyle(book.isRead ? .green : .secondary)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(book.title)
                                            .foregroundStyle(.primary)
                                        Text(book.isRead ? "წაკითხულია" : "წასაკითხია")
                                            .font(.caption)
                                            .foregroundStyle(book.isRead ? .green : .secondary)
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteBooks)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .padding(.top, 12)
            .navigationTitle("წიგნების სია")
            .toolbar {
                EditButton()
            }
        }
    }

    private func addBook() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTitle.isEmpty else { return }
        modelContext.insert(Book(title: cleanedTitle))
        title = ""
    }

    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(books[index])
        }
    }
}
