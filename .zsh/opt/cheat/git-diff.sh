# ignore tab, space
diff -BbwE old new

# ignore indent
git diff -b
# ignore whitespace
git diff -w
# add -p
git diff -w --no-color | git apply --cached

