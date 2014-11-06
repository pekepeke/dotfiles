gem rdoc --all --ri              # rdoc を一括インストール

# create gem project
bundle gem [gem name]

# build gem into the pkg directory
rake build

# build and install gem into system gems
rake install

# create tag & build and push gem to rubygems
rake release
