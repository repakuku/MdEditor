cd ./Project
curl -Ls https: install.tuist.io | bash
tuist install 3.36.2
tuist fetch
tuist generate

xcodebuild clean -quiet
xcodebuild test-without-building \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditorUITests' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max'
