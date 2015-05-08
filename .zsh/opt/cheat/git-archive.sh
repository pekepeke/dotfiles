# archive
git archive --format=zip --prefix=dir/ HEAD -o repo.zip
git archive --format=zip --prefix=projectname/ HEAD `git diff --name-only <commit>` -o archive.zip

# ファイルのみ取得
git archive --remote=url master | tar x

