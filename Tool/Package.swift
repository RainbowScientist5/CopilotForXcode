// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tool",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "XPCShared", targets: ["XPCShared"]),
        .library(name: "Terminal", targets: ["Terminal"]),
        .library(name: "Preferences", targets: ["Preferences", "Configs"]),
        .library(name: "Logger", targets: ["Logger"]),
        .library(name: "ChatAPIService", targets: ["ChatAPIService"]),
        .library(name: "ChatTab", targets: ["ChatTab"]),
        .library(name: "FileSystem", targets: ["FileSystem"]),
        .library(name: "SuggestionBasic", targets: ["SuggestionBasic"]),
        .library(name: "Toast", targets: ["Toast"]),
        .library(name: "SharedUIComponents", targets: ["SharedUIComponents"]),
        .library(name: "UserDefaultsObserver", targets: ["UserDefaultsObserver"]),
        .library(name: "Workspace", targets: ["Workspace", "WorkspaceSuggestionService"]),
        .library(
            name: "SuggestionProvider",
            targets: ["SuggestionProvider"]
        ),
        .library(
            name: "ConversationServiceProvider",
            targets: ["ConversationServiceProvider"]
        ),
        .library(
            name: "GitHubCopilotService",
            targets: ["GitHubCopilotService"]
        ),
        .library(
            name: "BuiltinExtension",
            targets: ["BuiltinExtension"]
        ),
        .library(
            name: "AppMonitoring",
            targets: [
                "XcodeInspector",
                "ActiveApplicationMonitor",
                "AXExtension",
                "AXNotificationStream",
                "AppActivator",
            ]
        ),
        .library(name: "DebounceFunction", targets: ["DebounceFunction"]),
        .library(name: "AsyncPassthroughSubject", targets: ["AsyncPassthroughSubject"]),
        .library(name: "CustomAsyncAlgorithms", targets: ["CustomAsyncAlgorithms"]),
    ],
    dependencies: [
        // TODO: Update LanguageClient some day.
        .package(url: "https://github.com/ChimeHQ/LanguageClient", exact: "0.3.1"),
        .package(url: "https://github.com/ChimeHQ/LanguageServerProtocol", exact: "0.8.0"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.12.1"),
        .package(url: "https://github.com/ChimeHQ/JSONRPC", exact: "0.6.0"),
        .package(url: "https://github.com/devm33/Highlightr", branch: "master"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.10.4"
        ),
        .package(url: "https://github.com/GottaGetSwifty/CodableWrappers", from: "2.0.7"),
        // TODO: remove CopilotForXcodeKit dependency once extension provider logic is removed.
        .package(url: "https://github.com/devm33/CopilotForXcodeKit", branch: "main")
    ],
    targets: [
        // MARK: - Helpers

        .target(name: "XPCShared", dependencies: ["SuggestionBasic", "Logger"]),

        .target(name: "Configs"),

        .target(name: "Preferences", dependencies: ["Configs"]),

        .target(name: "Terminal"),

        .target(name: "Logger"),

        .target(name: "FileSystem"),

        .target(
            name: "CustomAsyncAlgorithms",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),

        .target(
            name: "Toast",
            dependencies: [.product(
                name: "ComposableArchitecture",
                package: "swift-composable-architecture"
            )]
        ),

        .target(name: "DebounceFunction"),

        .target(
            name: "AppActivator",
            dependencies: [
                "XcodeInspector",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),

        .target(name: "ActiveApplicationMonitor"),

        .target(
            name: "SuggestionBasic",
            dependencies: [
                "LanguageClient",
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "CodableWrappers", package: "CodableWrappers"),
            ]
        ),

        .testTarget(
            name: "SuggestionBasicTests",
            dependencies: ["SuggestionBasic"]
        ),

        .target(name: "AXExtension"),

        .target(
            name: "AXNotificationStream",
            dependencies: [
                "Preferences",
                "Logger",
            ]
        ),

        .target(
            name: "XcodeInspector",
            dependencies: [
                "AXExtension",
                "SuggestionBasic",
                "AXNotificationStream",
                "Logger",
                "Toast",
                "Preferences",
                "AsyncPassthroughSubject",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),

        .testTarget(name: "XcodeInspectorTests", dependencies: ["XcodeInspector"]),

        .target(name: "UserDefaultsObserver"),

        .target(name: "AsyncPassthroughSubject"),

        .target(
            name: "BuiltinExtension",
            dependencies: [
                "SuggestionBasic",
                "SuggestionProvider",
                "Workspace",
                .product(name: "CopilotForXcodeKit", package: "CopilotForXcodeKit"),
            ]
        ),

        .target(
            name: "SharedUIComponents",
            dependencies: [
                "Highlightr",
                "Preferences",
                "SuggestionBasic",
                "DebounceFunction",
                "ConversationServiceProvider",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "SharedUIComponentsTests", dependencies: ["SharedUIComponents"]),

        .target(
            name: "Workspace",
            dependencies: [
                "UserDefaultsObserver",
                "SuggestionBasic",
                "Logger",
                "Preferences",
                "XcodeInspector",
            ]
        ),

        .target(
            name: "WorkspaceSuggestionService",
            dependencies: [
                "Workspace",
                "SuggestionProvider",
                "XPCShared",
                "BuiltinExtension",
                "GitHubCopilotService",
            ]
        ),

        .testTarget(
            name: "WorkspaceSuggestionServiceTests",
            dependencies: [
                "ConversationServiceProvider",
                "WorkspaceSuggestionService"
            ]
        ),

        // MARK: - Services

        .target(name: "SuggestionProvider", dependencies: [
            "SuggestionBasic",
            "UserDefaultsObserver",
            "Preferences",
            "Logger",
            .product(name: "CopilotForXcodeKit", package: "CopilotForXcodeKit"),
        ]),
        .testTarget(name: "SuggestionProviderTests", dependencies: ["SuggestionProvider"]),
        
        .target(name: "ConversationServiceProvider", dependencies: [
            .product(name: "CopilotForXcodeKit", package: "CopilotForXcodeKit"),
        ]),


        // MARK: - GitHub Copilot

        .target(
            name: "GitHubCopilotService",
            dependencies: [
                "LanguageClient",
                "SuggestionBasic",
                "Logger",
                "Preferences",
                "Terminal",
                "BuiltinExtension",
                "ConversationServiceProvider",
                .product(name: "LanguageServerProtocol", package: "LanguageServerProtocol"),
                .product(name: "CopilotForXcodeKit", package: "CopilotForXcodeKit"),
            ]
        ),
        .testTarget(
            name: "GitHubCopilotServiceTests",
            dependencies: ["GitHubCopilotService",
                           "ConversationServiceProvider"]
        ),

        // MARK: - ChatAPI

        .target(
            name: "ChatAPIService",
            dependencies: [
                "Logger",
                "Preferences",
                .product(name: "JSONRPC", package: "JSONRPC"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),

        // MARK: - UI

        .target(
            name: "ChatTab",
            dependencies: [.product(
                name: "ComposableArchitecture",
                package: "swift-composable-architecture"
            )]
        ),
    ]
)
