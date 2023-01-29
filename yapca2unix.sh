find ./test -type f -name "*.bash" -exec dos2unix '{}' \;
find ./test -type f -name "*.bash" -exec chmod 0750 '{}' \;
find ./test -type f -name "bats*" -exec dos2unix '{}' \;
find ./test -type f -name "bats*" -exec chmod 0750 '{}' \;
find ./src -type f -name "*.sh" -exec dos2unix '{}' \;
find ./src -type f -name "*.sh" -exec chmod 0750 '{}' \;
find ./src -type f -name "*.ini" -exec dos2unix '{}' \;