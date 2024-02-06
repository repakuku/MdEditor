cd ./Project

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install mise
mise install tuist@3.36.2
mise exec -- tuist fetch
tuist generate

xcodebuild clean -quiet
xcodebuild build-for-testing \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditor' \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'