function new() {
	if [ -z "$1" ]; then
		echo "Usage: new [contest_id]"
		return 1
	fi

	BASE_DIR="/atcoder/src"

	if [ ! -d "$BASE_DIR" ]; then
		mkdir -p "$BASE_DIR"
	fi
	cd "$BASE_DIR" || return 1

	acc new $1
	cd $1 || return 1
}

function ojt() {
	if [ ! -f "main.cpp" ]; then
		echo "[ERROR] 'main.cpp' not found in current directory."
		return 1
	fi

	if [ ! -d "tests" ]; then
		echo "[ERROR] 'tests/' directory not found in current directory."
		return 1
	fi

	g++ main.cpp -o "$OUTPUT_PATH" -std=c++23 -g -O0 -Wall -Wextra && oj t -c "$OUTPUT_PATH" -d "tests"
}