#! /bin/awk

BEGIN {
	dir = ""
}
(dir != "") && ($0 != dir) && (index($0, dir) == 1) {
	dir = ""
}
(dir != "") && ($0 != dir) && (index($0, dir) == 0) {
	print dir
dir = ""
}
(dir == "") && /\/$/ {
	dir = $0
}
END {
	if (dir != "")
		print dir
}
