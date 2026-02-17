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
#define LEN(s) (ll)s.size()
#define SUM(v) accumulate(all(v), 0LL)
#define MIN(v) *min_element(all(v))
#define MAX(v) *max_element(all(v))
#define LB(v, x) distance((v).begin(), lower_bound(all(v), (x)))
#define UB(v, x) distance((v).begin(), upper_bound(all(v), (x)))

template <typename T> using vec = vector<T>;
template <typename T> using vv = vector<vec<T>>;
template <typename T> using vvv = vector<vv<T>>;
template <typename T> using vvvv = vector<vvv<T>>;

const pll DIRECTIONS[] = {
	{-1, 0},{0, 1},{1,0},{0,-1},
	{-1, -1},{-1, 1},{1, 1},{1, -1}
};

template <class T, class U> bool
chmax(T &a, U b) {if(a<b) {a=b;return true;}return false;}
template <class T, class U> bool
chmin(T &a, U b) {if(a>b) {a=b;return true;}return false;}

void YesNo(bool ok) {
	if(ok) cout << "Yes" << el;
	else cout << "No" << el;
}

bool is_out(ll x, ll y, ll H, ll W) {
	if(x<0||x>=H||y<0||y>=W) return true;
	return false;
}

//---

void solve() {
	
}

int main() {
	ios::sync_with_stdio(false);
	cin.tie(nullptr);
	cout<<setprecision(15);

	solve();
	return 0;
}