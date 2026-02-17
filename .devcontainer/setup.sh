#!/bin/bash

# 1. ディレクトリの作成
ACC_CONFIG_DIR="/root/.config/atcoder-cli-nodejs/"
OJ_CONFIG_DIR="/root/.local/share/online-judge-tools/"
mkdir -p "$ACC_CONFIG_DIR"
mkdir -p "$OJ_CONFIG_DIR"

# 2. 認証情報 (REVEL_SESSION) の注入
if [ -n "$ATCODER_REVEL_SESSION" ]; then
	# acc用のセッションファイル作成
	cat <<EOF > "$ACC_CONFIG_DIR/session.json"
{
	"cookies": [
		"REVEL_FLASH=",
		"REVEL_SESSION=${ATCODER_REVEL_SESSION}"
	]
}
EOF

	# oj用のcookie.jar作成 (LWP形式)
	cat <<EOF > "${OJ_CONFIG_DIR}/cookie.jar"
#LWP-Cookies-2.0
Set-Cookie3: REVEL_FLASH="%00error%3APlease+sign+in+first.%00"; path="/"; domain="atcoder.jp"; path_spec; secure; discard; HttpOnly=None; version=0
Set-Cookie3: REVEL_SESSION="${ATCODER_REVEL_SESSION}"; path="/"; domain="atcoder.jp"; path_spec; secure; expires="2026-07-30 08:42:53Z"; HttpOnly=None; version=0
EOF
	echo "✅ Cookies have been injected into acc and oj."

	# ログイン確認
	login_check=$(timeout 5s acc session 2>&1)
	if echo "$login_check" | grep -q "OK"; then
		echo "✅ Success: logged in to AtCoder."
	else
		echo "❌ Login failed or REVEL_SESSION is missing/expired."
		echo "Please obtain your REVEL_SESSION cookie from your browser,"
		echo "   and paste it into .devcontainer/.env like this:"
		echo ""
		echo "   $ATCODER_REVEL_SESSION=your_atcoder_session_here$"
		echo ""
		echo "Then rebuild the container using 'Rebuild Container' in VSCode."
		exit 1
	fi
else
	echo "❌ Error: ATCODER_REVEL_SESSION environment variable is not set."
	exit 1
fi

# 3. acc の基本設定 (config.json)
cat <<EOF > "$ACC_CONFIG_DIR/config.json"
{
	"oj-path": "/usr/local/bin/oj",
	"default-contest-dirname-format": "{ContestID}",
	"default-task-dirname-format": "{tasklabel}",
	"default-test-dirname-format": "tests",
	"default-task-choice": "all",
	"default-template": "cpp"
}
EOF
echo "✅ Success: acc config.json has been created."

# 4. C++ テンプレートの作成
TEMPLATE_CPP_DIR="$ACC_CONFIG_DIR/cpp"
mkdir -p "$TEMPLATE_CPP_DIR"

# .devcontainer/template.cpp を acc のテンプレートディレクトリにコピー
if [ -f "./.devcontainer/template.cpp" ]; then
	cp "./.devcontainer/template.cpp" "$TEMPLATE_CPP_DIR/main.cpp"
	echo "✅ Success: template.cpp has been copied from .devcontainer."
else
	echo "❌ Error: .devcontainer/template.cpp not found."
fi

# acc用テンプレート定義ファイル (template.json)
cat <<EOF > "$TEMPLATE_CPP_DIR/template.json"
{
	"task":{
		"program": ["main.cpp"],
		"submit": "main.cpp"
	}
}
EOF
echo "✅ Success: C++ template and template.json have been created."

# atcoder.jpのHTLM仕様変更に伴うojの更新(python3.12の場合)
TARGET_FILE="/usr/local/lib/python3.12/dist-packages/onlinejudge/service/atcoder.py"
if [ -f "$TARGET_FILE" ]; then
    # 1. 単位文字列の置換
    sed -i "s/KB/KiB/g" "$TARGET_FILE"
    sed -i "s/MB/MiB/g" "$TARGET_FILE"
	
    # メモリ制限の計算行の 1000 だけを 1024 に変える
    sed -i "/memory_limit_byte/s/1000/1024/g" "$TARGET_FILE"

    echo "✅ Success: Patched memory limits (1024) while keeping time limits (1000) intact."
fi

# --- .bashrc の連携設定 ---
# 読み込みたいファイルのパス
PROJECT_BASHRC="/atcoder/.devcontainer/.bashrc"

# ~/.bashrc にまだ書き込まれていない場合のみ追記する
if [ -f "$PROJECT_BASHRC" ]; then
    # 2. まだリンクされていないかチェック (grep -q は見つかると0=真を返すので ! で反転)
    if ! grep -q "source $PROJECT_BASHRC" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Load project specific settings" >> ~/.bashrc
        echo "source $PROJECT_BASHRC" >> ~/.bashrc
        echo "✅ Success: Linked .devcontainer/.bashrc to ~/.bashrc"
    else
        # 既にリンク済みの場合
        echo "ℹ️  Info: .devcontainer/.bashrc is already linked."
    fi
else
    # ファイルが見つからない場合
    echo "⚠️  Warning: $PROJECT_BASHRC not found. Skipping link."
fi

echo "--- All setup processes completed! ---"