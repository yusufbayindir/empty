import Foundation
import PDFKit
import Combine

@MainActor
final class DocumentStore: ObservableObject {
    @Published private(set) var recentDocuments: [DocuScanDocument] = []
    @Published private(set) var favoriteDocuments: [DocuScanDocument] = []

    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("DocuScan", isDirectory: true)
    }

    init() {
        createDirectoryIfNeeded()
        loadDocuments()
    }

    func save(pdfDocument: PDFDocument, name: String) throws -> DocuScanDocument {
        let fileName = "\(name)_\(Date().timeIntervalSince1970).pdf"
        let url = documentsDirectory.appendingPathComponent(fileName)

        guard let data = pdfDocument.dataRepresentation() else {
            throw DocumentError.saveFailed
        }

        try data.write(to: url)
        let doc = DocuScanDocument(
            id: UUID(), name: name, url: url, createdAt: Date(), pageCount: pdfDocument.pageCount
        )
        recentDocuments.insert(doc, at: 0)
        persistMetadata()
        return doc
    }

    func delete(_ document: DocuScanDocument) throws {
        try fileManager.removeItem(at: document.url)
        recentDocuments.removeAll { $0.id == document.id }
        favoriteDocuments.removeAll { $0.id == document.id }
        persistMetadata()
    }

    func toggleFavorite(_ document: DocuScanDocument) {
        if favoriteDocuments.contains(where: { $0.id == document.id }) {
            favoriteDocuments.removeAll { $0.id == document.id }
        } else {
            favoriteDocuments.append(document)
        }
        persistMetadata()
    }

    private func createDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: documentsDirectory.path) {
            try? fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        }
    }

    private func loadDocuments() {
        let key = "docuscan.documents"
        guard let data = UserDefaults.standard.data(forKey: key),
              let docs = try? JSONDecoder().decode([DocuScanDocument].self, from: data) else { return }
        recentDocuments = docs.filter { fileManager.fileExists(atPath: $0.url.path) }
        favoriteDocuments = recentDocuments.filter { doc in
            let favIds = (UserDefaults.standard.array(forKey: "docuscan.favorites") as? [String]) ?? []
            return favIds.contains(doc.id.uuidString)
        }
    }

    private func persistMetadata() {
        if let data = try? JSONEncoder().encode(recentDocuments) {
            UserDefaults.standard.set(data, forKey: "docuscan.documents")
        }
        let favIds = favoriteDocuments.map { $0.id.uuidString }
        UserDefaults.standard.set(favIds, forKey: "docuscan.favorites")
    }
}

struct DocuScanDocument: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    let url: URL
    let createdAt: Date
    let pageCount: Int

    var fileSizeString: String {
        guard let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize else { return "—" }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
}

enum DocumentError: LocalizedError {
    case saveFailed
    case conversionFailed
    case passwordRequired

    var errorDescription: String? {
        switch self {
        case .saveFailed: return String(localized: "error.save_failed")
        case .conversionFailed: return String(localized: "error.conversion_failed")
        case .passwordRequired: return String(localized: "error.password_required")
        }
    }
}
