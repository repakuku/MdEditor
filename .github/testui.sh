cd ./Project

xcodebuild clean -quiet
xcodebuild test-without-building \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditorUITests' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max'
