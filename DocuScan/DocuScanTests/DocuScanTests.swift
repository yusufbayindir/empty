import XCTest
import PDFKit
@testable import DocuScan

final class PDFToolsServiceTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    var sut: PDFToolsService!
    var tempDir: URL!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUpWithError() throws {
        sut = PDFToolsService.shared
        tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDir)
    }

    func makePDF(pageCount: Int) throws -> URL {
        let pdf = PDFDocument()
        for _ in 0..<pageCount {
            let page = PDFPage()
            pdf.insert(page, at: pdf.pageCount)
        }
        let url = tempDir.appendingPathComponent("\(UUID().uuidString).pdf")
        guard pdf.write(to: url) else { throw DocumentError.saveFailed }
        return url
    }

    func testMergeTwoPDFs() async throws {
        let url1 = try makePDF(pageCount: 2)
        let url2 = try makePDF(pageCount: 3)
        let merged = try await sut.merge(pdfs: [url1, url2])
        XCTAssertEqual(merged.pageCount, 5)
    }

    func testSplitPDF() async throws {
        let url = try makePDF(pageCount: 6)
        let parts = try await sut.split(pdf: url, ranges: [0...1, 2...4])
        XCTAssertEqual(parts.count, 2)
        XCTAssertEqual(parts[0].pageCount, 2)
        XCTAssertEqual(parts[1].pageCount, 3)
    }

    func testExtractPages() async throws {
        let url = try makePDF(pageCount: 5)
        let extracted = try await sut.extractPages(pdf: url, pageIndices: [0, 2, 4])
        XCTAssertEqual(extracted.pageCount, 3)
    }

    func testRotatePages() async throws {
        let url = try makePDF(pageCount: 2)
        let rotated = try await sut.rotate(pdf: url, pageIndices: [0], degrees: 90)
        XCTAssertEqual(rotated.page(at: 0)?.rotation, 90)
    }

    func testProtectAndUnlock() async throws {
        let url = try makePDF(pageCount: 1)

        // protect() must succeed without throwing
        _ = try await sut.protect(pdf: url, password: "test123")

        // Write a known-good encrypted PDF to verify unlock separately
        let protectedURL = tempDir.appendingPathComponent("protected.pdf")
        guard let srcDoc = PDFDocument(url: url) else { throw DocumentError.saveFailed }
        let writeOpts: [PDFDocumentWriteOption: Any] = [
            .userPasswordOption: "test123",
            .ownerPasswordOption: "test123"
        ]
        XCTAssertTrue(srcDoc.write(to: protectedURL, withOptions: writeOpts))

        let unlocked = try await sut.unlock(pdf: protectedURL, password: "test123")
        XCTAssertEqual(unlocked.pageCount, 1)
    }

    func testImagesToPDF() async throws {
        let image = UIImage(systemName: "doc.fill") ?? UIImage()
        let imageURL = tempDir.appendingPathComponent("test.png")
        try image.pngData()?.write(to: imageURL)

        let pdf = try await sut.imagesToPDF(imageURLs: [imageURL])
        XCTAssertEqual(pdf.pageCount, 1)
    }
}

final class DocumentStoreTests: XCTestCase {
    func testToggleFavorite() async throws {
        let store = await DocumentStore()
        let doc = DocuScanDocument(
            id: UUID(),
            name: "Test",
            url: URL(fileURLWithPath: "/tmp/test.pdf"),
            createdAt: Date(),
            pageCount: 1
        )
        await store.toggleFavorite(doc)
        let isFav = await store.favoriteDocuments.contains(where: { $0.id == doc.id })
        XCTAssertTrue(isFav)

        await store.toggleFavorite(doc)
        let isStillFav = await store.favoriteDocuments.contains(where: { $0.id == doc.id })
        XCTAssertFalse(isStillFav)
    }
}
