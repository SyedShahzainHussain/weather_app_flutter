on:
pull_request:
branches:
- main
- master
push:
branches:
- main
- master
- shahzain
name: "Build & Release"
jobs:
build:
name: Build & Release
runs-on: windows-latest
steps:
- uses: actions/checkout@v3
- uses: actions/setup-java@v3
with:
distribution: "zulu"
java-version: "18"
- uses: subosito/flutter-action@v2
with:
channel: "stable"
architecture: x64

- run: flutter build apk --release --split-per-abi
- name: Push to Releases
uses: ncipollo/release-action@v1
with:
artifacts: "build/app/outputs/apk/release/*"
tag: v1.0.${{ github.run_number }}
token: ${{ secrets.WEATHER }}
# push to master, main, develop
# pull request on main master
