git checkout -b someFeature
git push origin someFeature
git remote add upstream git://github.com/xxx/xxx.git
git stash
git checkout master
git pull upstream master
git checkout someFeature
git rebase master someFeature
git push origin master
git push origin someFeature
