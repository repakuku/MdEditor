cd ./Project
curl https://mise.jdx.dev/install.sh | sh
mise install tuist
tuist fetch
tuist generate

xcodebuild clean -quiet
xcodebuild build-for-testing \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditor' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max'
