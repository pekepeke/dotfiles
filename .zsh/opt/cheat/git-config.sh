# locally gitignore
vim .git/info/exclude

# minimum config
git config --global push.default upstream
git config --global pull.rebase true
git config --global alias.st status
git config --global alias.stt status -uno
git config --global alias.ss status -sb
git config --global alias.co checkout
git config --global alias.ls ls-files
git config --global alias.ci commit
git config --global alias.ca commit --amend
git config --global alias.br branch

## msg : SSL certificate problem,  verify that the CA cert is OK. Details
got config --local http.sslVerify false
GIT_SSL_NO_VERIFY=true git clone https://xxx.com/repo

