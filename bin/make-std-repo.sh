#!/bin/sh
# Clones the boil

BOILERPLATE_REPO="git@bitbucket.org:ramsalt/d7-docroot-boilerplate.git"

print_error() {
  echo "\nERROR> $1\n" 1>&2
  exit -2
}

print_usage() {
  echo
  echo "USAGE: 2 parameters required:"
  echo "\t- the destination directory (should *not* exist already)"
  echo "\t- the final repo details to be used"
  echo
  echo "Usage: $0 /path/to/destination git@example.com:destination/repo.git"
  echo
}

# Destination directory
dst_dir="$1"
dst_repo="$2"

if [ $# -ne 2 ]; then
  print_usage
  exit -1
fi

if [ -d "$dst_dir" ]; then
  print_error "Destination dir exists, will not override: $dst_dir"
fi

echo "Cloning boilerplate repository..."
git clone --quiet --depth=1 "$BOILERPLATE_REPO" "$dst_dir"
if [ $? -ne 0 ]; then
  #something went wrong. stop
  print_error "Failed to clone the git repo for the boilerplate."
fi

cd "$dst_dir"
echo "Clone completed, removing boilerplate reference."
rm -rf ".git"

echo "Setting ou new repo."
git init
git remote add origin "$dst_repo"

echo "Do you want to create an initial commit? [y/n]"

read do_create

if [ "$do_create" == 'y' -o "$do_create" == 'Y' ]; then
  echo "Adding,"
  git add .
  echo "...committing,"
  git commit --quiet -m "Initial commit, repo setup"
  echo "...and pushing!"
  git push --quiet -u origin master
fi

echo
echo "Done!"
echo
