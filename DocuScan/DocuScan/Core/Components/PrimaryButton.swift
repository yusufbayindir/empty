import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isDestructive: Bool = false

    init(_ title: String, icon: String? = nil, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isDestructive ? Color.dsError : Color.dsPrimary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
        }
        .buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.dsSurface)
            .foregroundStyle(Color.dsPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.button)
                    .stroke(Color.dsPrimary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
