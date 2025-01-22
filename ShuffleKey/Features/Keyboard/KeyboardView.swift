import SwiftUI

struct KeyboardView: View {
    @StateObject private var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(config: KeyboardConfig = KeyboardConfig()) {
        _viewModel = StateObject(wrappedValue: KeyboardViewModel(config: config))
    }
    
    var body: some View {
        VStack {
            // 输入框和模式切换
            VStack(spacing: 12) {
                inputField
                
                // 密码模式切换按钮
                Button(action: viewModel.togglePasswordMode) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isPasswordMode ? "eye.slash" : "eye")
                        Text(viewModel.isPasswordMode ? "密码模式" : "普通模式")
                            .font(.subheadline)
                    }
                    .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // 数字网格
            VStack(spacing: 24) {
                // 7-8-9
                HStack(spacing: 24) {
                    ForEach(viewModel.keys.prefix(3)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
                
                // 4-5-6
                HStack(spacing: 24) {
                    ForEach(viewModel.keys.dropFirst(3).prefix(3)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
                
                // 1-2-3
                HStack(spacing: 24) {
                    ForEach(viewModel.keys.dropFirst(6).prefix(3)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
                
                // 0 和 .
                HStack(spacing: 24) {
                    ForEach(viewModel.keys.dropFirst(9)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // 功能按钮
            HStack(spacing: 40) {
                FunctionButton(
                    icon: "arrow.triangle.2.circlepath",
                    color: .blue,
                    action: viewModel.shuffleKeys,
                    isDisabled: viewModel.isShuffling
                )
                
                FunctionButton(
                    icon: "delete.left",
                    color: .red,
                    action: viewModel.deleteCharacter
                )
                
                FunctionButton(
                    icon: "trash",
                    color: .gray,
                    action: viewModel.clearText
                )
            }
            .padding(.bottom, 30)
        }
        .background(colorScheme == .dark ? Color.black : Color(uiColor: .systemBackground))
    }
    
    private var inputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !viewModel.displayText.isEmpty {
                Text(viewModel.isPasswordMode ? "密码" : "输入内容")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(viewModel.displayText)
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
        }
        .padding(.horizontal)
    }
}

// MARK: - NumberButton
struct NumberButton: View {
    let key: Key
    let action: () -> Void
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
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
            Text(key.value)
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 110, height: 110)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - FunctionButton
struct FunctionButton: View {
    let icon: String
    let color: Color
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
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(color)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 2, x: 0, y: 2)
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
}

#Preview {
    KeyboardView()
        .preferredColorScheme(.light)
} 