# AtCoder C++ 開発環境

AtCoderコンテスト用のC++開発環境です。Dev Container を使用してセットアップされています。

## 🐳 Docker環境

### ベースイメージ
- Ubuntu 24.04

### インストール済みツール
| ツール | 説明 |
|--------|------|
| g++ | C++23対応コンパイラ |
| Python3 | スクリプト実行用 |
| Node.js / npm | atcoder-cli用 |
| lldb | デバッガー |
| [online-judge-tools (oj)](https://github.com/online-judge-tools/oj) | テストケース実行・提出ツール |
| [atcoder-cli (acc)](https://github.com/Tatamo/atcoder-cli) | AtCoder用CLIツール |
| [AC Library](https://github.com/atcoder/ac-library) | AtCoder公式ライブラリ (`/usr/local/include/atcoder/`) |

### VS Code拡張機能
- `ms-vscode.cpptools` - C/C++サポート
- `vadimcn.vscode-lldb` - LLDBデバッガー
- `oderwat.indent-rainbow` - インデント可視化
- `shardulm94.trailing-spaces` - 末尾スペース表示
- `shd101wyy.markdown-preview-enhanced` - Markdownプレビュー

### メモリ制限
- コンテナは1GBのメモリ制限で実行されます

---

## 🔐 初回セットアップ（ログイン設定）
`docker build`する前に以下を行ってください
1. ブラウザでAtCoderにログインする
2. 開発者ツール → Application → Cookies から `REVEL_SESSION` の値をコピー
3. `.devcontainer/.env_exmple`を`.devcontainer/.env`にリネームし、以下の部分を変更：

```
ATCODER_REVEL_SESSION=your_session_value_here
```

4. VS Codeで「開発コンテナー:コンテナのリビルド(Rebuild Container)」を実行

> ⚠️ `.env` ファイルは `.gitignore` に含まれているため、Gitにコミットされません。

---

## 🛠️ カスタムコマンド

### `new [contest_id]`
新しいコンテストのディレクトリを作成します。

```bash
new abc300
```

実行すると：
- `/atcoder/src/abc300/` ディレクトリが作成される
- 各問題のテンプレート（`main.cpp`）と `tests/` ディレクトリが生成される
- その後`/atcoder/src/abc300/`に移動する

### `ojt`
現在のディレクトリで `main.cpp` をコンパイルし、`tests/` 内のテストケースを実行します。

```bash
cd /atcoder/src/abc300/a
ojt
```

実際に使用する際の流れ
- `new abc300`を実行
- `cd a`を実行
- 提出コードを書いた後に`ojt`を実行
- すべてACしたら`acc submit`を実行する # TODO: `submit`でojt→acc submitを自動化 # TODO: 提出のたびに`abca`と打つのが面倒

> [!WARNING]
AtCoderがコードの提出時にも認証を求めるようになったため、`acc submit`は実施中のコンテストでのみ使用可能

---

## ⚙️ VS Codeタスク

### ビルド（`build c++ for AtCoder`）
- コマンド: `g++`
- オプション: `-std=c++23 -g -O0 -Wall -Wextra`
- 現在開いているファイルをコンパイルし、`${OUTPUT_PATH}` に出力

---

## 🐞 デバッグ

LLDBを使用したデバッグが可能です。

1. ブレークポイントを設定
2. `F5` または「Run and Debug」からデバッグを開始
3. 標準入力は `.in` ファイルから読み込まれる

---

## 📁 ディレクトリ構成

```
/atcoder/
├── .devcontainer/
│   ├── Dockerfile          # Docker設定
│   ├── devcontainer.json   # Dev Container設定
│   ├── setup.sh            # 初期セットアップスクリプト
│   ├── template.cpp        # C++テンプレート
│   ├── .bashrc             # カスタムコマンド定義
│   └── .env                # 認証情報（gitignore対象）
├── .vscode/
│   ├── tasks.json          # ビルド・実行タスク
│   └── launch.json         # デバッグ設定
├── src/
│   └── [contest_id]/       # 各コンテストのディレクトリ
│       ├── a/
│       │   ├── main.cpp
│       │   └── tests/
│       ├── b/
│       └── ...
├── .in                     # 標準入力用ファイル
└── .out                    # 標準出力ファイル
```

---

## 📝 テンプレート（template.cpp）

新しい問題を作成すると、以下のテンプレートが自動で使用されます：

```cpp
#include <bits/stdc++.h>
#include <atcoder/all>
using namespace std;

using ll = long long;
using ull = unsigned long long;
using ld = long double;
using pll = pair<ll, ll>;

#define INF ll(1e18)
#define el '\n'
#define rep(i, a) for(ll i=0;i<a;i++)
#define nrep(i, a, b) for(ll i=a;i<b;i++)
#define all(v) v.begin(), v.end()
#define rall(v) v.rbegin(), v.rend()
// ... その他マクロ

void solve() {
    // ここに解答を書く
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout<<setprecision(15);

    solve();
    return 0;
}
```

### 利用可能なマクロ・関数
| マクロ/関数 | 説明 |
|-------------|------|
| `rep(i, a)` | `for(ll i=0; i<a; i++)` |
| `nrep(i, a, b)` | `for(ll i=a; i<b; i++)` |
| `all(v)` | `v.begin(), v.end()` |
| `rall(v)` | `v.rbegin(), v.rend()` |
| `LEN(s)` | `(ll)s.size()` |
| `SUM(v)` | `accumulate(all(v), 0LL)` |
| `MIN(v)` / `MAX(v)` | 最小値/最大値 |
| `LB(v, x)` / `UB(v, x)` | lower_bound/upper_bound のインデックス |
| `chmax(a, b)` / `chmin(a, b)` | 最大値/最小値で更新 |
| `YesNo(ok)` | `"Yes"` または `"No"` を出力 |
| `is_out(x, y, H, W)` | 範囲外判定 |
| `DIRECTIONS` | 4方向/8方向の移動ベクトル |
