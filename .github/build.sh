cd ./Project
# curl -Ls https: install.tuist.io | bash
# tuist install 3.36.2

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install mise
mise install tuist@3.36.2
tuist fetch
tuist generate

xcodebuild clean -quiet
xcodebuild build-for-testing \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditor' \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'