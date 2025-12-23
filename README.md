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

#### 🚀 Turbo Framesの応用機能

このアプリケーションでは、Turbo Framesの5つの応用的な使い方を実装しています：

##### 1. **Lazy Loading（遅延読み込み）**
統計情報をページロード後に自動で読み込みます。

**実装箇所**: `app/views/todos/index.html.erb:18-22`
```erb
<%= turbo_frame_tag "statistics", src: statistics_todos_path, loading: :lazy do %>
  <div class="statistics-loading">Loading...</div>
<% end %>
```

**ポイント**:
- `src`属性でコンテンツのURLを指定
- `loading: :lazy`で画面に表示されたタイミングで自動読み込み
- 初期表示を高速化し、必要な時だけデータを取得

##### 2. **Filter Tabs（タブナビゲーション）**
All/Pending/Completedのフィルターをタブで切り替えます。

**実装箇所**:
- `app/views/todos/index.html.erb:33-45` - タブUI
- `app/controllers/todos_controller.rb:84-99` - filterアクション
- `app/views/todos/filter.turbo_stream.erb` - Turbo Streamレスポンス

**ポイント**:
- ページリロードなしでフィルタリング
- Turbo Streamsで複数のフレームを同時更新（リストとタブの両方）

##### 3. **Modal（モーダルダイアログ）**
TODOの詳細をモーダルで表示します。

**実装箇所**:
- `app/views/todos/_todo.html.erb:23-25` - Viewボタン
- `app/views/todos/show.html.erb` - モーダルコンテンツ
- `app/views/todos/index.html.erb:58` - モーダルフレームの配置

**ポイント**:
- `data: { turbo_frame: "modal" }`で別のフレームをターゲット指定
- 親ページはそのまま、モーダル部分だけ更新
- URLも変わるのでブックマーク可能

##### 4. **Nested Frames（ネストされたフレーム）**
モーダル内にコメント機能を実装（フレームの中にフレーム）。

**実装箇所**:
- `app/views/todos/show.html.erb:24-30` - モーダル内のコメントフレーム
- `app/views/comments/_comment.html.erb` - 各コメントもフレーム
- `app/views/comments/_form.html.erb` - コメント投稿フォーム

**ポイント**:
- モーダルフレームの中にコメントセクションのフレーム
- 各コメントも個別のフレームで囲む（削除時に該当コメントだけ削除）
- 多層構造のUI更新を細かく制御可能

##### 5. **Inline Editing（インライン編集）**
既存のTODOを直接編集フォームに変換します。

**実装箇所**:
- `app/views/todos/_todo.html.erb:1` - TODOアイテムのフレーム
- `app/views/todos/edit.html.erb` - 編集フォーム

**ポイント**:
- 同じフレームID内でコンテンツを置き換え
- 編集中も他のTODOは通常表示
- キャンセル時は元のTODO表示に戻る

### 3. Turbo Streams
- 複数の DOM 操作を同時に実行
- リアルタイム更新が可能
- 作成、更新、削除の操作が即座にUIに反映

**実装箇所**:
- `app/models/todo.rb:10` - `broadcasts_to`で自動ブロードキャスト
- `app/views/todos/create.turbo_stream.erb` - TODO作成時の処理（TODOリスト、フォームクリア、統計、フィルタータブの4箇所を同時更新）
- `app/views/todos/update.turbo_stream.erb` - TODO更新時の処理
- `app/views/todos/destroy.turbo_stream.erb` - TODO削除時の処理（TODO削除、統計、フィルタータブの3箇所を同時更新）
- `app/views/todos/toggle.turbo_stream.erb` - 完了状態トグル時の処理（TODO更新、統計、フィルタータブの3箇所を同時更新）

**使い方**:
- TODOを作成すると、リストの先頭に自動的に追加される
- チェックボックスをクリックすると、即座に完了状態が更新される
- 削除ボタンをクリックすると、アニメーション付きで削除される
- **TODO作成・削除・完了トグル時に統計情報とフィルタータブの件数も自動更新される**（複数のDOM要素を同時更新）

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
- `app/models/comment.rb` - Commentモデル、ネストされたフレームのデモ用

### コントローラー
- `app/controllers/todos_controller.rb` - CRUD操作、統計、フィルター機能
- `app/controllers/comments_controller.rb` - コメントのCRUD操作

### ビュー（基本）
- `app/views/todos/index.html.erb` - TODOリスト表示、全機能のデモ
- `app/views/todos/_todo.html.erb` - TODOアイテムのパーシャル（Turbo Frame）
- `app/views/todos/_form.html.erb` - TODOフォームのパーシャル
- `app/views/todos/edit.html.erb` - 編集ビュー（Turbo Frame）
- `app/views/todos/*.turbo_stream.erb` - Turbo Streamsのレスポンステンプレート

### ビュー（応用機能）
- `app/views/todos/show.html.erb` - モーダルビュー（Turbo Frame）
- `app/views/todos/statistics.html.erb` - 統計情報（Lazy Loading）
- `app/views/todos/filter.turbo_stream.erb` - フィルター機能（Turbo Stream）
- `app/views/comments/_comment.html.erb` - コメントパーシャル（Nested Frame）
- `app/views/comments/_form.html.erb` - コメントフォーム
- `app/views/comments/*.turbo_stream.erb` - コメント用Turbo Streams

## 学習のポイント

### 基本機能の学習

1. **Turbo Driveの体験**
   - ページ間を移動してみて、ページリロードが発生しないことを確認
   - ブラウザの開発者ツールのNetworkタブで、フルページリロードが発生していないことを確認

2. **Turbo Framesの理解**
   - 「Edit」ボタンをクリックして、該当のTODOだけが編集フォームに変わることを確認
   - `turbo_frame_tag`で囲まれた部分だけが更新されることを確認

3. **Turbo Streamsの活用**
   - TODOを作成・更新・削除して、リアルタイムに更新されることを確認
   - TODOを作成すると、**TODOリスト・統計情報・フィルタータブの3箇所が同時に更新**される
   - チェックボックスをトグルすると、**TODO・統計情報・フィルタータブが同時に更新**される
   - ブラウザの開発者ツールで、Turbo Streamのレスポンスを確認
   - ネットワークタブで`text/vnd.turbo-stream.html`のレスポンスを見ると、複数の`<turbo-stream>`タグが含まれていることを確認

### 応用機能の学習

4. **Lazy Loadingの体験**
   - ページを開いた瞬間は「Loading statistics...」と表示される
   - 1秒後に統計情報が自動的に読み込まれる
   - 開発者ツールのNetworkタブで`/todos/statistics`へのリクエストを確認
   - HTMLレスポンスの`Content-Type: text/vnd.turbo-stream.html`を確認

5. **Filter Tabsの動作確認**
   - 「All」「Pending」「Completed」タブをクリック
   - ページリロードなしでTODOリストが切り替わる
   - URLは変わらず、タブのアクティブ状態も更新される
   - 複数のフレームが同時に更新されることを確認

6. **Modalの理解**
   - 「View」ボタンをクリックしてモーダルを表示
   - URLが変わることを確認（ブックマーク可能）
   - モーダルを開いたままブラウザの戻るボタンを押すとモーダルが閉じる
   - `data-turbo-frame`属性でターゲットフレームを指定していることを確認

7. **Nested Framesとコメント機能**
   - モーダル内でコメントを追加
   - ページリロードなしでコメントがリストに追加される
   - コメント削除時も該当コメントだけが消える
   - フレームの入れ子構造（モーダル > コメントセクション > 個別コメント）を理解

8. **開発者ツールでの確認方法**
   - Elements タブで`<turbo-frame>`要素の構造を確認
   - Network タブでTurbo FrameとTurbo Streamのリクエストを区別
   - Turbo Frame: HTMLレスポンス（部分的なHTML）
   - Turbo Stream: `text/vnd.turbo-stream.html`レスポンス（DOM操作命令）

## Turbo Framesの重要な概念

### Frame IDとターゲット指定

Turbo Framesは**同じID**を持つフレーム同士で内容を置き換えます：

```erb
<!-- ページ1: TODOの表示 -->
<%= turbo_frame_tag dom_id(todo) do %>
  <!-- dom_id(todo) は "todo_1" のようなIDを生成 -->
  <div>TODO表示...</div>
<% end %>

<!-- ページ2: TODOの編集フォーム -->
<%= turbo_frame_tag dom_id(@todo) do %>
  <!-- 同じIDなので、このフレームで上記を置き換える -->
  <form>編集フォーム...</form>
<% end %>
```

### data-turbo-frameでターゲット変更

デフォルトでは、リンクは**最も近い親フレーム**を更新しますが、`data-turbo-frame`で別のフレームをターゲットにできます：

```erb
<!-- モーダルを開くボタン（別のフレームをターゲット指定） -->
<%= link_to "View", todo_path(todo), data: { turbo_frame: "modal" } %>

<!-- ターゲットフレーム（ページの別の場所） -->
<%= turbo_frame_tag "modal" %>
```

### Lazy Loadingの仕組み

`src`属性と`loading: :lazy`を組み合わせて遅延読み込み：

```erb
<%= turbo_frame_tag "statistics", src: statistics_path, loading: :lazy do %>
  <!-- 初期表示コンテンツ -->
  <p>Loading...</p>
<% end %>
```

1. 初期表示: 「Loading...」が表示される
2. フレームが画面に表示されたタイミングで自動的に`src`のURLにリクエスト
3. レスポンスの`<turbo-frame id="statistics">`部分で置き換え

### Turbo FramesとTurbo Streamsの使い分け

| 機能 | Turbo Frames | Turbo Streams |
|------|-------------|---------------|
| 更新範囲 | 1つのフレーム | 複数のDOM要素 |
| 用途 | ページの一部を別ページのコンテンツで置き換え | 複数の操作を同時実行 |
| レスポンス | HTML | Turbo Stream形式 |
| 例 | モーダル、インライン編集 | リスト追加、複数箇所の更新 |

このアプリでは両方を併用しています：
- **Turbo Frames**: モーダル表示、編集フォーム、タブ切り替え、統計情報のLazy Loading
- **Turbo Streams**: TODO作成時のリスト更新とフォームクリア・統計情報更新・フィルタータブ更新（4つの操作を同時実行）

**複数DOM更新の実例**:

TODO作成時の`create.turbo_stream.erb`では、4つの異なる場所を同時に更新：

```erb
<%= turbo_stream.prepend "todos", @todo %>          <!-- 1. TODOリストに追加 -->
<%= turbo_stream.update "new_todo" do %>            <!-- 2. フォームをクリア -->
  <%= render "form", todo: Todo.new %>
<% end %>
<%= turbo_stream.update "statistics" do %>          <!-- 3. 統計情報を更新 -->
  <%= render "statistics" %>
<% end %>
<%= turbo_stream.update "filter_tabs" do %>         <!-- 4. フィルタータブの件数を更新 -->
  <%= render "filter_tabs" %>
<% end %>
```

これにより、1回のリクエストで複数の画面要素が同期して更新されます。

## 参考リンク

- [Turbo Documentation](https://turbo.hotwired.dev/)
- [Turbo Frames Reference](https://turbo.hotwired.dev/reference/frames)
- [Turbo Streams Reference](https://turbo.hotwired.dev/reference/streams)
- [Hotwire](https://hotwired.dev/)
- [Rails Guides - Turbo](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#turbo)

## Ruby/Rails バージョン

- Ruby: 3.x
- Rails: 8.0.2
