#!/bin/bash
set -euo pipefail
sdk_root="$(cd "$(dirname "$0")/.." && pwd)"
test_dir="$(mktemp -d /tmp/creek-prayer-contract.XXXXXX)"
trap 'rm -rf "$test_dir"' EXIT
mkdir -p "$test_dir/Sources/SwiftProtobuf" "$test_dir/Sources/PrayerContract" "$test_dir/Tests/PrayerContractTests"
cp "$sdk_root"/Example/Pods/SwiftProtobuf/Sources/SwiftProtobuf/*.swift "$test_dir/Sources/SwiftProtobuf/"
cp "$sdk_root/CreekSDK/Classes/model/CreekPrayerModels.swift" "$test_dir/Sources/PrayerContract/"
cp "$sdk_root/CreekSDK/Classes/proto/prayer.pb.swift" "$sdk_root/CreekSDK/Classes/proto/enums.pb.swift" "$test_dir/Sources/PrayerContract/"
cp "$sdk_root/Tests/PrayerModelsTests.swift" "$test_dir/Tests/PrayerContractTests/"
cp -R "$sdk_root/Tests/Fixtures" "$test_dir/Tests/PrayerContractTests/"
cat > "$test_dir/Package.swift" <<'PACKAGE'
// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "PrayerContract", targets: [
   .target(name: "SwiftProtobuf"),
   .target(name: "PrayerContract", dependencies: ["SwiftProtobuf"]),
   .testTarget(name: "PrayerContractTests", dependencies: ["PrayerContract"], resources: [.copy("Fixtures")])
])
PACKAGE
swift test --package-path "$test_dir" --jobs 4
