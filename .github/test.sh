cd ./Project

xcodebuild test-without-building \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditorTests' \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'
