#!/bin/sh

DIR="$1"
COMMIT="$2"
if [ -z "$COMMIT" ]; then
    COMMIT=HEAD
fi

# Taken from git-susmcee (Copyright (C) 2009 Avery Pennarun <apenwarr@gmail.com>)
find_latest_squash()
{
	dir="$1"
	sq=
	main=
	sub=
	git log --grep="^git-susmcee-dir: $dir/*\$" \
		--pretty=format:'START %H%n%s%n%n%b%nEND%n' "$COMMIT" |
	while read a b junk; do
		case "$a" in
			START) sq="$b" ;;
			git-susmcee-mainline:) main="$b" ;;
			git-susmcee-split:) sub="$b" ;;
			END)
				if [ -n "$sub" ]; then
					if [ -n "$main" ]; then
						# a rejoin commit?
						# Pretend its sub was a squash.
						sq="$sub"
					fi
					echo "$sq" "$sub"
					break
				fi
				sq=
				main=
				sub=
				;;
		esac
	done
}

latest_squash="$(find_latest_squash "$DIR")"
if [ -z "$latest_squash" ]; then
    echo "ERROR: $DIR is not a susmcee" >&2
    exit 2
fi

set $latest_squash
old=$1
rev=$2
if [ "d$(git cat-file -t $rev 2>/dev/null)" != dcommit ]; then
    echo "ERROR: susmcee commit $rev unavailable. Fetch/update the susmcee repository" >&2
    exit 2
fi
tree_susmcee=$(git show -s --format="%T" $rev)
echo "$DIR in $COMMIT was last updated to upstream commit $rev (tree $tree_susmcee)"
tree_actual=$(git ls-tree -d "$COMMIT" "$DIR" | head -n 1)
if [ -z "$tree_actual" ]; then
    echo "FAIL: susmcee directory $DIR not found in $COMMIT" >&2
    exit 1
fi
set $tree_actual
tree_actual_type=$2
tree_actual_tree=$3
echo "$DIR in $COMMIT currently refers to $tree_actual_type $tree_actual_tree"
if [ "d$tree_actual_type" != "dtree" ]; then
    echo "FAIL: susmcee directory $DIR is not a tree in $COMMIT" >&2
    exit 1
fi
if [ "$tree_actual_tree" != "$tree_susmcee" ]; then
    git diff-tree $tree_actual_tree $tree_susmcee >&2
    echo "FAIL: susmcee directory tree doesn't match susmcee commit tree" >&2
    exit 1
fi
echo "GOOD"
