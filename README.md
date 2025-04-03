# Template 工具保护方案

## 背景

当前 `template` 工具是一个 shell 脚本，通过 Homebrew 分发。我们希望保护核心代码不被轻易查看，同时保持工具的易用性和与 Homebrew 的兼容性。

## 问题

1. 当前作为 shell 脚本，源码对所有用户可见
2. 发布后版本号与安装版本号不一致的问题已修复
3. 需要一种方法来保护核心代码和知识产权

## 最佳方案：混合保护策略

### 1. 核心功能用 Swift 实现

- 将关键算法和敏感逻辑用 Swift 编写
- 编译为二进制可执行文件
- 使用编译优化和符号剥离增加逆向难度

```bash
swiftc -O -whole-module-optimization -strip-debug-symbols helper.swift -o helper
```

Swift 是苹果官方语言，在 macOS 上有最佳支持，适合开发 Homebrew 工具。虽然 Swift 二进制文件可以被反编译，但难度相对较高，特别是经过优化和符号剥离后。

### 2. 保持简单的 shell 脚本作为入口

- 主脚本 `template` 保持为 shell 脚本
- 该脚本仅包含基本逻辑和对 Swift 二进制的调用
- 这样可以保持与现有用户的兼容性

示例入口脚本：

```bash
#!/bin/sh

# 工具名称配置
TOOL_NAME="template"
VERSION="v1.0.60"

# 定位 Swift 二进制文件
HELPER_PATH="$(brew --prefix)/opt/template/libexec/helper"

# 检查二进制文件是否存在
if [ ! -f "$HELPER_PATH" ]; then
    echo "错误：找不到辅助程序，请重新安装 $TOOL_NAME"
    exit 1
fi

# 将所有参数传递给二进制程序
exec "$HELPER_PATH" "$@"
```

### 3. 修改 formula 安装方式

```ruby
class Template < Formula
  # GitHub repository information
  GITHUB_USER = "griffin928"
  GITHUB_REPO = "homebrew-template"
  VERSION = "v1.0.60"

  desc "My personal CLI tool for daily automation"
  homepage "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}"
  url "#{homepage}/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "..."
  license "MIT"

  def install
    bin.install "template"  # shell 脚本入口
    libexec.install "helper"  # Swift 编译的二进制
    # 确保权限正确
    chmod 0755, libexec/"helper"
  end

  test do
    system "#{bin}/template", "-v"
  end
end
```

### 4. Swift 程序实现

Swift 程序需要实现当前 shell 脚本的所有功能，包括：

- 版本管理
- Git 操作
- SSH 密钥管理
- 公式文件更新
- 等等

Swift 示例框架：

```swift
import Foundation

// 主程序入口
func main() {
    let arguments = CommandLine.arguments
    
    if arguments.count < 2 {
        showHelp()
        return
    }
    
    let command = arguments[1]
    
    switch command {
    case "dev":
        developmentCommand()
    case "publish":
        publishCommand()
    case "upgrade":
        upgradeCommand()
    case "-v":
        printVersion()
    case "-h":
        showHelp()
    case "storessh":
        storeSSHCommand()
    case "restoressh":
        restoreSSHCommand()
    default:
        print("未知命令: \(command)")
        showHelp()
    }
}

// 实现各个命令...
func developmentCommand() {
    // 实现 dev 命令的逻辑
}

func publishCommand() {
    // 实现 publish 命令的逻辑
}

// 启动主程序
main()
```

### 5. 发布流程

1. 开发和测试 Swift 程序
2. 编译 Swift 程序为二进制文件
3. 更新 shell 脚本入口和 formula 文件
4. 提交更改并创建新标签
5. 发布新版本

发布脚本示例：

```bash
#!/bin/sh

# 编译 Swift 程序
echo "编译 Swift 程序..."
swiftc -O -whole-module-optimization -strip-debug-symbols helper.swift -o helper

# 更新版本号
VERSION="v1.0.61"
echo "更新版本号到 $VERSION..."

# 更新 shell 脚本中的版本号
sed -i '' "s/VERSION=\"v[0-9]*\.[0-9]*\.[0-9]*\"/VERSION=\"$VERSION\"/" template

# 提交更改
git add .
git commit -m "更新版本号到 $VERSION"
git push

# 创建标签
git tag "$VERSION"
git push origin "$VERSION"

# 等待 GitHub 生成压缩包
echo "等待 GitHub 生成压缩包..."
sleep 10

# 计算 SHA256
SHA256=$(curl -sL "https://github.com/griffin928/homebrew-template/archive/refs/tags/$VERSION.tar.gz" | shasum -a 256 | cut -d ' ' -f1)

# 更新 formula 文件
sed -i '' "s/VERSION = \".*\"/VERSION = \"$VERSION\"/" template.rb
sed -i '' "s/sha256 \".*\"/sha256 \"$SHA256\"/" template.rb

# 提交 formula 更新
git add .
git commit -m "发布版本 $VERSION 并更新 SHA256"
git push

echo "版本 $VERSION 已完全发布"
```

### 6. 法律保护

- 为工具添加适当的许可证
- 明确禁止逆向工程和未授权使用
- 考虑在二进制文件中添加版权声明

## 实施步骤

1. **创建 Swift 项目**
   - 设置 Swift 开发环境
   - 创建基本项目结构
   - 实现核心功能

2. **修改现有 shell 脚本**
   - 简化为只调用 Swift 二进制的入口脚本
   - 保留版本号和基本配置

3. **更新 formula 文件**
   - 修改安装过程以包含 Swift 二进制
   - 更新测试方法

4. **调整发布流程**
   - 添加 Swift 编译步骤
   - 确保所有文件都正确更新

5. **测试**
   - 确保所有功能正常工作
   - 验证安装过程
   - 检查版本号一致性

## 优势

- 保护核心知识产权
- 保持与 Homebrew 生态系统的兼容性
- 用户体验不变
- 不需要完全重写现有功能

## 注意事项

- Swift 二进制文件虽然难以逆向，但并非不可能
- 需要为不同的 macOS 版本和架构（Intel/ARM）编译
- 可能需要调整发布流程以适应新的构建步骤