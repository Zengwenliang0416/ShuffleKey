import SwiftUI

// MARK: - Theme
struct Theme: Equatable {
    let primary: Color
    let secondary: Color
    let accent: Color
    let name: String
    let icon: String
    
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primary, primary.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var secondaryGradient: LinearGradient {
        LinearGradient(
            colors: [secondary, secondary.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var accentGradient: LinearGradient {
        LinearGradient(
            colors: [accent, accent.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var borderGradient: LinearGradient {
        LinearGradient(
            colors: [primary.opacity(0.3), secondary.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static let red = Theme(
        primary: Color(hex: "#FF4B4B"),
        secondary: Color(hex: "#FF8F1F"),
        accent: Color(hex: "#FFB74D"),
        name: "红色",
        icon: "flame.fill"
    )
    
    static let blue = Theme(
        primary: Color(hex: "#2196F3"),
        secondary: Color(hex: "#42A5F5"),
        accent: Color(hex: "#64B5F6"),
        name: "蓝色",
        icon: "water.waves"
    )
    
    static let purple = Theme(
        primary: Color(hex: "#9C27B0"),
        secondary: Color(hex: "#AB47BC"),
        accent: Color(hex: "#BA68C8"),
        name: "紫色",
        icon: "sparkles"
    )
    
    static let green = Theme(
        primary: Color(hex: "#4CAF50"),
        secondary: Color(hex: "#66BB6A"),
        accent: Color(hex: "#81C784"),
        name: "绿色",
        icon: "leaf.fill"
    )
    
    static let allThemes: [Theme] = [.red, .blue, .purple, .green]
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .red
    
    func nextTheme() {
        guard let currentIndex = Theme.allThemes.firstIndex(of: currentTheme) else { return }
        let nextIndex = (currentIndex + 1) % Theme.allThemes.count
        currentTheme = Theme.allThemes[nextIndex]
    }
}

// MARK: - Theme Environment Key
private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme.red
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - Gradient Constants
private struct GradientConstants {
    static let primary = LinearGradient(
        colors: [Color(hex: "#FF4B4B"), Color(hex: "#FF7676")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let danger = LinearGradient(
        colors: [Color(hex: "#FF8F1F"), Color(hex: "#FFA94D")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let neutral = LinearGradient(
        colors: [Color(hex: "#FFB74D"), Color(hex: "#FFD180")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let border = LinearGradient(
        colors: [Color(hex: "#FF4B4B").opacity(0.3), Color(hex: "#FFB74D").opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct KeyboardView: View {
    @StateObject private var viewModel: KeyboardViewModel
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var settings = KeyboardSettings.shared
    @Environment(\.colorScheme) var colorScheme
    
    init(config: KeyboardConfig = KeyboardConfig()) {
        _viewModel = StateObject(wrappedValue: KeyboardViewModel(config: config))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                VStack {
                    // 输入框和模式切换
                    VStack(spacing: 16) {
                        inputField
                        modeToggleButton
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    // 数字网格
                    LazyVStack(spacing: 24) {
                        ForEach(0..<4) { row in
                            numberRow(row: row)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // 功能按钮
                    functionButtons
                    
                    // 大小调节滑块
                    sizeSlider
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                }
                .padding()
            }
            .environment(\.theme, themeManager.currentTheme)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Background View
    @ViewBuilder
    private var backgroundView: some View {
        if colorScheme == .dark {
            Color.black.ignoresSafeArea()
        } else {
            Color(uiColor: .systemBackground)
                .overlay(themeManager.currentTheme.primary.opacity(0.03))
                .ignoresSafeArea()
        }
    }
    
    // MARK: - Mode Toggle Button
    private var modeToggleButton: some View {
        Button(action: viewModel.togglePasswordMode) {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isPasswordMode ? "eye.slash.fill" : "eye.fill")
                Text(viewModel.isPasswordMode ? "密码模式" : "普通模式")
                    .font(.system(.subheadline, design: .rounded))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(themeManager.currentTheme.primaryGradient)
                    .shadow(color: themeManager.currentTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    // MARK: - Number Row
    private func numberRow(row: Int) -> some View {
        HStack(spacing: 24) {
            ForEach(viewModel.keys[(row * 3)..<min((row * 3) + 3, viewModel.keys.count)]) { key in
                NumberButton(key: key) {
                    viewModel.appendCharacter(key.value)
                }
            }
        }
    }
    
    // MARK: - Function Buttons
    private var functionButtons: some View {
        HStack(spacing: 40) {
            FunctionButton(
                icon: "arrow.triangle.2.circlepath",
                gradient: themeManager.currentTheme.primaryGradient,
                action: viewModel.shuffleKeys,
                isDisabled: viewModel.isShuffling
            )
            
            FunctionButton(
                icon: "delete.left",
                gradient: themeManager.currentTheme.secondaryGradient,
                action: viewModel.deleteCharacter
            )
            
            FunctionButton(
                icon: "trash",
                gradient: themeManager.currentTheme.accentGradient,
                action: viewModel.clearText
            )
            
            // 主题切换按钮
            FunctionButton(
                icon: themeManager.currentTheme.icon,
                gradient: themeManager.currentTheme.primaryGradient,
                action: { themeManager.nextTheme() }
            )
        }
    }
    
    // MARK: - Input Field
    private var inputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !viewModel.displayText.isEmpty {
                Text(viewModel.isPasswordMode ? "密码" : "输入内容")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 2)
            }
            
            Text(viewModel.displayText)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(InputFieldBackground())
        }
        .padding(.horizontal)
    }
    
    // MARK: - Size Slider
    private var sizeSlider: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        settings.buttonTapAreaSize = max(settings.minTapAreaSize, settings.buttonTapAreaSize - 5)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(themeManager.currentTheme.primary.opacity(0.6))
                        .font(.system(size: 24))
                }
                
                Slider(
                    value: $settings.buttonTapAreaSize,
                    in: settings.minTapAreaSize...settings.maxTapAreaSize,
                    step: 1.0
                )
                .tint(themeManager.currentTheme.primary)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        settings.buttonTapAreaSize = min(settings.maxTapAreaSize, settings.buttonTapAreaSize + 5)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(themeManager.currentTheme.primary.opacity(0.6))
                        .font(.system(size: 24))
                }
            }
            
            Text("\(Int(settings.buttonTapAreaSize))")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(themeManager.currentTheme.primary)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Input Field Background
private struct InputFieldBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.theme) var theme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(colorScheme == .dark ? Color.black : Color.white)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 15,
                x: 0,
                y: 5
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(theme.borderGradient, lineWidth: 1)
            )
    }
}

// MARK: - Number Button
struct NumberButton: View {
    let key: Key
    let action: () -> Void
    @Environment(\.theme) var theme
    @StateObject private var settings = KeyboardSettings.shared
    
    var body: some View {
        Button(action: action) {
            Text(key.value)
                .font(.system(size: min(settings.buttonTapAreaSize * 0.4, 24), weight: .medium, design: .rounded))
                .frame(width: settings.buttonTapAreaSize, height: settings.buttonTapAreaSize)
                .foregroundColor(theme.primary)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: theme.primary.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(theme.borderGradient, lineWidth: 1)
                )
        }
        .buttonStyle(NumberButtonStyle())
    }
}

struct NumberButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Function Button
struct FunctionButton: View {
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    var isDisabled: Bool = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(gradient)
                        .shadow(
                            color: Color.black.opacity(0.2),
                            radius: 15,
                            x: 0,
                            y: 5
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.94 : 1.0)
                .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
}

#Preview {
    KeyboardView()
        .environment(\.theme, .purple)
        .preferredColorScheme(.light)
} 