# iOS 電卓アプリ 開発ガイド

## ビルド・テストコマンド
- ビルド: `xcodebuild -project "iOS Calculator App.xcodeproj" -scheme "iOS Calculator App" build`
- 実行: `xcodebuild -project "iOS Calculator App.xcodeproj" -scheme "iOS Calculator App" run`
- 全テスト実行: `xcodebuild -project "iOS Calculator App.xcodeproj" -scheme "iOS Calculator App" test`
- 単一テスト実行: `xcodebuild -project "iOS Calculator App.xcodeproj" -scheme "iOS Calculator App" test -only-testing:iOS_Calculator_AppTests/iOS_Calculator_AppTests/テスト名`
- SwiftLint: `brew install swiftlint`でインストール後、プロジェクトディレクトリで`swiftlint`を実行

## コードスタイルガイドライン
- **インポート**: 標準ライブラリを最初に、次にサードパーティフレームワークをグループ化
- **命名規則**: 変数/関数はcamelCase、型/プロトコルはPascalCase、定数はSCREAMING_SNAKE_CASE
- **フォーマット**: インデントは4スペース、1行の長さは100文字まで
- **コメント**: 単行コメントは`//`、ドキュメントコメントは`///`を使用
- **エラー処理**: Swiftのtry-catchと、LocalizedErrorに準拠したカスタムエラー列挙型を使用
- **列挙型**: 列挙型の値にはPascalCaseを使用
- **アクセス制御**: 可能な限り最も制限的なアクセス制御(private, fileprivateなど)を使用
- **型安全性**: Swiftの強い型付けを活用し、オプショナルの強制アンラップを避ける