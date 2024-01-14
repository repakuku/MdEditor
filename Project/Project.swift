import ProjectDescription

// MARK: - Project

enum ProjectSettings {
	public static var organizationName: String { "repakuku" }
	public static var projectName: String { "MdEditor" }
	public static var appVersionName: String { "1.0.0" }
	public static var appVersionBuild: Int { 1 }
	public static var developmentTeam: String { "repakuku@icloud.com" }
	public static var targetVersion: String { "15.0" }
	public static var bundleId: String { "\(organizationName).\(projectName)" }
}

private var swiftLintTargetScript: TargetScript {
	let swiftLintScriptString = """
		export PATH="$PATH:/opt/homebrew/bin"
		if which swiftlint > /dev/null; then
		  swiftlint
		else
		  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
		  exit 1
		fi
		"""

	return TargetScript.pre(
		script: swiftLintScriptString,
		name: "Run SwiftLint",
		basedOnDependencyAnalysis: false
	)
}

private var swiftgenTargetScript: TargetScript {
	let swiftgenScriptSctirng = """
		export PATH="$PATH:/opt/homebrew/bin"
		OUTPUT_FILES=()
		COUNTER=0
		while [ $COUNTER -lt ${SCRIPT_OUTPUT_FILE_COUNT} ];
		do
		 tmp="SCRIPT_OUTPUT_FILE_$COUNTER"
		 OUTPUT_FILES+=("${!tmp}")
		 COUNTER=$[$COUNTER+1]
		done
		for file in "${OUTPUT_FILES[@]}"
		do
		 if [ -f "$file" ]
		 then
		  chmod a=rw "$file"
		 fi
		done

		if which swiftgen > /dev/null; then
		 swiftgen config run --config swiftgen.yml
		else
		 echo "warning: SwiftGen not installed, download from https://github.com/SwiftGen/SwiftGen"
		 exit 1
		fi

		for file in "${OUTPUT_FILES[@]}"
		do
		 chmod a=r "$file"
		done
		"""

	return TargetScript.pre(
		script: swiftgenScriptSctirng,
		name: "Run Swiftgen",
		basedOnDependencyAnalysis: false
	)
}

private let scripts: [TargetScript] = [
	swiftLintTargetScript,
	swiftgenTargetScript
]

private let infoPlistExtension: [String: Plist.Value] = [
	"UIApplicationSceneManifest": [
		"UIApplicationSupportsMultipleScenes": false,
		"UISceneConfigurations": [
			"UIWindowSceneSessionRoleApplication": [
				[
					"UISceneConfigurationName": "Default Configuration",
					"UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
				]
			]
		]
	],
	"UILaunchStoryboardName": "LaunchScreen"
]

let project = Project(
	name: ProjectSettings.projectName,
	organizationName: ProjectSettings.organizationName,
	packages: [
		.local(path: .relativeToManifest("../Packages/TaskManagerPackage")),
		.local(path: .relativeToManifest("../Packages/DataStructuresPackage"))
	],
	settings: .settings(
		base: [
			"DEVELOPMENT_TEAM": "\(ProjectSettings.developmentTeam)",
			"MARKETING_VERSION": "\(ProjectSettings.appVersionName)",
			"CURRENT_PROJECT_VERSION": "\(ProjectSettings.appVersionBuild)",
			"DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
		],
		defaultSettings: .recommended()
	),
	targets: [
		Target(
			name: ProjectSettings.projectName,
			destinations: .iOS,
			product: .app,
			bundleId: ProjectSettings.bundleId,
			deploymentTargets: .iOS(ProjectSettings.targetVersion),
			infoPlist: .extendingDefault(with: infoPlistExtension),
			sources: ["Sources/**"],
			resources: ["Resources/**"],
			scripts: scripts,
			dependencies: [
				.package(product: "TaskManagerPackage"),
				.package(product: "DataStructuresPackage")
			]
		),
		Target(
			name: "\(ProjectSettings.projectName)Tests",
			destinations: .iOS,
			product: .unitTests,
			bundleId: "\(ProjectSettings.bundleId)Tests",
			deploymentTargets: .iOS(ProjectSettings.targetVersion),
			infoPlist: .none,
			sources: ["Tests/**"],
			dependencies: [
				.target(name: "\(ProjectSettings.projectName)")
			],
			settings: .settings(base: ["GENERATE_INFOPLIST_FILE": "YES"])
		)
	]
)
