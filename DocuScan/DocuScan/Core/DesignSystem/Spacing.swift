import CoreFoundation

enum Spacing {
    // swiftlint:disable identifier_name
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    // swiftlint:enable identifier_name
    static let xxl: CGFloat = 48

    enum CornerRadius {
        static let card: CGFloat = 12
        static let button: CGFloat = 10
        static let small: CGFloat = 6
        static let large: CGFloat = 20
    }

    enum AdBanner {
        static let height: CGFloat = 50
    }
}
