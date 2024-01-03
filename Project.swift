import ProjectDescription

public var scripts: [TargetScript] {

	var scripts = [TargetScript]()

	let swiftLintScriptString = """
	export PATH="$PATH:/opt/homebrew/bin"
	if which swiftlint > /dev/null; then
	  swiftlint
	else
	  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
	  exit 1
	fi
	"""

	let swiftLintScript = TargetScript.post(
		script: swiftLintScriptString,
		name: "SwiftLint",
		basedOnDependencyAnalysis: false
	)

	scripts.append(swiftLintScript)
	return scripts
}

let project = Project(
	name: "MdEditor",
	targets: [
		Target(
			name: "App",
			destinations: .iOS,
			product: .app,
			bundleId: "com.repakuku.MdEditor",
			infoPlist: "Resources/Info.plist",
			sources: ["Sources/**"],
			resources: ["Resources/**"],
			scripts: scripts
		)
	]
)
