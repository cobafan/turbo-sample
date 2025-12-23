# Turbo Sample TODO App

HotwireのTurbo機能を体系的に学習できるRails TODO アプリケーションです。

## 学べる機能

このアプリケーションでは、Hotwireの3つの主要な機能を実際に体験できます：

### 1. Turbo Drive
- ページ遷移が自動的に高速化される
- フルページリロードなしでナビゲーション
- ブラウザの履歴管理が自動的に処理される

**実装箇所**: デフォルトで有効。特別な設定は不要です。

### 2. Turbo Frames
- ページの一部分だけを更新できる
- インライン編集が可能
- フォームの送信後、ページリロードなしで該当部分のみ更新

**実装箇所**:
- `app/views/todos/index.html.erb:13-16` - 新規TODO作成フォーム
- `app/views/todos/_todo.html.erb:1` - 各TODOアイテムをturbo_frameで囲む
- `app/views/todos/edit.html.erb:1-6` - 編集フォームがturbo_frame内で動作

**使い方**: TODOの「Edit」ボタンをクリックすると、ページリロードなしでインライン編集フォームが表示されます。

### 3. Turbo Streams
- 複数の DOM 操作を同時に実行
- リアルタイム更新が可能
- 作成、更新、削除の操作が即座にUIに反映

**実装箇所**:
- `app/models/todo.rb:8` - `broadcasts_to`で自動ブロードキャスト
- `app/views/todos/create.turbo_stream.erb` - TODO作成時の処理
- `app/views/todos/update.turbo_stream.erb` - TODO更新時の処理
- `app/views/todos/destroy.turbo_stream.erb` - TODO削除時の処理
- `app/views/todos/toggle.turbo_stream.erb` - 完了状態トグル時の処理

**使い方**:
- TODOを作成すると、リストの先頭に自動的に追加される
- チェックボックスをクリックすると、即座に完了状態が更新される
- 削除ボタンをクリックすると、アニメーション付きで削除される

## セットアップ

```bash
# 依存関係のインストール
bundle install

# データベースの作成とマイグレーション
bin/rails db:create db:migrate

# サーバーの起動
bin/rails server
```

ブラウザで http://localhost:3000 にアクセスしてください。

## 主要ファイル

### モデル
- `app/models/todo.rb` - Todoモデル、broadcasts_toでTurbo Streams対応

### コントローラー
- `app/controllers/todos_controller.rb` - CRUD操作、Turbo対応のレスポンス

### ビュー
- `app/views/todos/index.html.erb` - TODOリスト表示、Turbo Frames/Streams使用
- `app/views/todos/_todo.html.erb` - TODOアイテムのパーシャル（Turbo Frame）
- `app/views/todos/_form.html.erb` - TODOフォームのパーシャル
- `app/views/todos/edit.html.erb` - 編集ビュー（Turbo Frame）
- `app/views/todos/*.turbo_stream.erb` - Turbo Streamsのレスポンステンプレート

## 学習のポイント

1. **Turbo Driveの体験**
   - ページ間を移動してみて、ページリロードが発生しないことを確認
   - ブラウザの開発者ツールのNetworkタブで、フルページリロードが発生していないことを確認

2. **Turbo Framesの理解**
   - 「Edit」ボタンをクリックして、該当のTODOだけが編集フォームに変わることを確認
   - `turbo_frame_tag`で囲まれた部分だけが更新されることを確認

3. **Turbo Streamsの活用**
   - TODOを作成・更新・削除して、リアルタイムに更新されることを確認
   - ブラウザの開発者ツールで、Turbo Streamのレスポンスを確認

## 参考リンク

- [Turbo Documentation](https://turbo.hotwired.dev/)
- [Hotwire](https://hotwired.dev/)
- [Rails Guides - Turbo](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#turbo)

## Ruby/Rails バージョン

- Ruby: 3.x
- Rails: 8.0.2
