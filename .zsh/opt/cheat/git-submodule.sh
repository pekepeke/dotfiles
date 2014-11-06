git submodule update --init --recursive
git submodule foreach 'git checkout master; git pull'
git submodule foreach 'git submodule update --init'

# remove
git submodule deinit path/to/submodule
git rm path/to/submodule
# git config -f .gitmodules --remove-section submodule.path/to/submodule

