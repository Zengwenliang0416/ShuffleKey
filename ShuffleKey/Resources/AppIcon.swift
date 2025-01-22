import SwiftUI

// MARK: - 背景渐变
private struct IconGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.2, blue: 0.2),  // 亮红色
                Color(red: 0.8, green: 0.0, blue: 0.0)   // 深红色
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - 装饰圆形
private struct DecorativeCircle: View {
    let offset: CGPoint
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.15))
            .frame(width: 300, height: 300)
            .blur(radius: 40)
            .offset(x: offset.x, y: offset.y)
    }
}

// MARK: - 背景组件
private struct IconBackground: View {
    var body: some View {
        ZStack {
            IconGradient()
            DecorativeCircle(offset: CGPoint(x: -80, y: -80))
            DecorativeCircle(offset: CGPoint(x: 80, y: 80))
        }
    }
}

// MARK: - 数字按钮
private struct IconButton: View {
    let number: Int
    
    private var buttonGradient: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(0.3),
                .white.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var textGradient: LinearGradient {
        LinearGradient(
            colors: [.white, .white.opacity(0.95)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(buttonGradient)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.4), lineWidth: 1.5)
                )
            
            Text("\(number)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(textGradient)
        }
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}

// MARK: - 数字网格
private struct NumberGrid: View {
    var body: some View {
        let numbers = Array(1...9)
        VStack(spacing: 14) {
            ForEach(0..<3) { row in
                HStack(spacing: 14) {
                    ForEach(0..<3) { col in
                        let number = numbers[row * 3 + col]
                        IconButton(number: number)
                    }
                }
            }
        }
        .padding(40)
        .scaleEffect(0.95)
    }
}

// MARK: - 打乱图标
private struct ShuffleIcon: View {
    private var iconGradient: LinearGradient {
        LinearGradient(
            colors: [.white, .white.opacity(0.9)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        Image(systemName: "arrow.triangle.2.circlepath")
            .font(.system(size: 65, weight: .regular))
            .foregroundStyle(iconGradient)
            .rotationEffect(.degrees(-15))
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 6)
    }
}

// MARK: - 主图标视图
struct AppIcon: View {
    var body: some View {
        ZStack {
            IconBackground()
            
            Circle()
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 2)
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(45))
            
            NumberGrid()
            ShuffleIcon()
        }
        .clipShape(RoundedRectangle(cornerRadius: 90))
    }
}

// MARK: - 图标导出
extension AppIcon {
    private static let iconImages: [(filename: String, idiom: String, size: String, scale: String)] = [
        ("Icon-20@2x.png", "iphone", "20x20", "2x"),
        ("Icon-20@3x.png", "iphone", "20x20", "3x"),
        ("Icon-29@2x.png", "iphone", "29x29", "2x"),
        ("Icon-29@3x.png", "iphone", "29x29", "3x"),
        ("Icon-40@2x.png", "iphone", "40x40", "2x"),
        ("Icon-40@3x.png", "iphone", "40x40", "3x"),
        ("Icon-60@2x.png", "iphone", "60x60", "2x"),
        ("Icon-60@3x.png", "iphone", "60x60", "3x"),
        ("Icon-1024.png", "ios-marketing", "1024x1024", "1x")
    ]
    
    private static func createContentsJson() -> [String: Any] {
        let images: [[String: Any]] = [
            [
                "size": "20x20",
                "idiom": "iphone",
                "filename": "Icon-20@2x.png",
                "scale": "2x"
            ],
            [
                "size": "20x20",
                "idiom": "iphone",
                "filename": "Icon-20@3x.png",
                "scale": "3x"
            ],
            [
                "size": "29x29",
                "idiom": "iphone",
                "filename": "Icon-29@2x.png",
                "scale": "2x"
            ],
            [
                "size": "29x29",
                "idiom": "iphone",
                "filename": "Icon-29@3x.png",
                "scale": "3x"
            ],
            [
                "size": "40x40",
                "idiom": "iphone",
                "filename": "Icon-40@2x.png",
                "scale": "2x"
            ],
            [
                "size": "40x40",
                "idiom": "iphone",
                "filename": "Icon-40@3x.png",
                "scale": "3x"
            ],
            [
                "size": "60x60",
                "idiom": "iphone",
                "filename": "Icon-60@2x.png",
                "scale": "2x"
            ],
            [
                "size": "60x60",
                "idiom": "iphone",
                "filename": "Icon-60@3x.png",
                "scale": "3x"
            ],
            [
                "size": "1024x1024",
                "idiom": "ios-marketing",
                "filename": "Icon-1024.png",
                "scale": "1x"
            ]
        ]
        
        return [
            "images": images,
            "info": [
                "version": 1,
                "author": "xcode"
            ]
        ]
    }
    
    private static func getIconSpecs() -> [(size: CGFloat, name: String)] {
        [
            (40, "Icon-20@2x.png"),    // 20pt @2x
            (60, "Icon-20@3x.png"),    // 20pt @3x
            (58, "Icon-29@2x.png"),    // 29pt @2x
            (87, "Icon-29@3x.png"),    // 29pt @3x
            (80, "Icon-40@2x.png"),    // 40pt @2x
            (120, "Icon-40@3x.png"),   // 40pt @3x
            (120, "Icon-60@2x.png"),   // 60pt @2x
            (180, "Icon-60@3x.png"),   // 60pt @3x
            (1024, "Icon-1024.png")    // 1024pt @1x
        ]
    }
    
    static func exportAllIcons() {
        let icon = AppIcon()
        
        // 获取项目目录
        let projectPath = "/Users/wenliang_zeng/workspace/open_sources/ShuffleKey/ShuffleKey"
        let assetsPath = "\(projectPath)/Assets.xcassets"
        let assetPath = "\(assetsPath)/AppIcon.appiconset"
        
        let fileManager = FileManager.default
        
        print("📁 开始导出图标...")
        print("📂 项目目录：\(projectPath)")
        print("📂 资源目录：\(assetsPath)")
        print("📂 图标目录：\(assetPath)")
        
        do {
            // 删除现有的 AppIcon.appiconset（如果存在）
            if fileManager.fileExists(atPath: assetPath) {
                try fileManager.removeItem(atPath: assetPath)
                print("✅ 删除旧的 AppIcon.appiconset 成功")
            }
            
            // 创建新的 AppIcon.appiconset
            try fileManager.createDirectory(atPath: assetPath, withIntermediateDirectories: true)
            print("✅ 创建新的 AppIcon.appiconset 目录成功")
            
            // 写入 Contents.json
            let contents = createContentsJson()
            let jsonData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
            try jsonData.write(to: URL(fileURLWithPath: "\(assetPath)/Contents.json"))
            print("✅ 创建 Contents.json 成功")
            
            // 首先生成预览大小的图标（512x512）
            let previewRenderer = ImageRenderer(content: 
                icon.frame(width: 512, height: 512)
            )
            previewRenderer.scale = 2.0
            
            guard let previewImage = previewRenderer.uiImage else {
                print("❌ 无法渲染预览图标")
                return
            }
            
            // 导出每个尺寸的图标
            for (size, filename) in getIconSpecs() {
                let targetSize = CGSize(width: size, height: size)
                
                UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
                defer { UIGraphicsEndImageContext() }
                
                if let context = UIGraphicsGetCurrentContext() {
                    context.interpolationQuality = .high
                    context.setShouldAntialias(true)
                    
                    // 绘制图像
                    previewImage.draw(in: CGRect(origin: .zero, size: targetSize))
                    
                    if let resizedImage = UIGraphicsGetImageFromCurrentImageContext(),
                       let data = resizedImage.pngData() {
                        let filePath = "\(assetPath)/\(filename)"
                        try data.write(to: URL(fileURLWithPath: filePath))
                        print("✅ 导出成功：\(filename) (\(Int(size))x\(Int(size)))")
                    }
                }
            }
            
            print("\n✅ 图标导出完成")
            print("📂 图标位置：\(assetPath)")
            print("⚠️ 请在 Xcode 中刷新 Assets.xcassets")
            
        } catch {
            print("❌ 错误：\(error.localizedDescription)")
        }
    }
}

// MARK: - 预览
#Preview("App Icon", traits: .sizeThatFitsLayout) {
    VStack {
        AppIcon()
            .frame(width: 512, height: 512)
            .padding()
        
        Button("Generate App Icons") {
            AppIcon.exportAllIcons()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    .padding()
    .background(Color(.systemBackground))
} 