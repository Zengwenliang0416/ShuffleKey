import SwiftUI

struct KeyboardButton: View {
    let title: String
    let action: () -> Void
    
    @StateObject private var settings = KeyboardSettings.shared
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: min(settings.buttonTapAreaSize * 0.4, 24)))
                .fontWeight(.medium)
                .frame(width: settings.buttonTapAreaSize, height: settings.buttonTapAreaSize)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .contentShape(Rectangle()) // 确保整个区域都可点击
        }
        .buttonStyle(KeyboardButtonStyle())
    }
}

struct KeyboardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct KeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardButton(title: "1") {
            print("Button tapped")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 