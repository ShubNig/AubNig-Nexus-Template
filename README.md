[TOC]

# Env

Project Runtime:

|title|description|
|-----|-----------|
|jdk|1.8.+|
|gradle|2.14.1|
|Android Studio|2.2.3|
|com.android.tools.build:gradle|2.2.3|
|minSdkVersion|15|
|appcompat-v7|25.0.1|
|compile SDK version|25|
|build tools version|25.0.3|
|target SDK version|15|
|min SDK version|15|


# Last Version Info

- version 0.0.1
- repo at

provides :
- ~~Full method count 00~~

# Build

- module-all-uploadArchives

```sh
./z-module-all-uploadArchives
```

> windows just edit and run `z-module-all-uploadArchives.bat`

- APK for test

```
./gradlew installDebug
```

- change uploadArchives

edit root `gradle.properties`

|key|value|
|-----|--------|
|VERSION_NAME|version of project name|
|VERSION_CODE|version of code|
|NEXUS_USERNAME|nexus user name|
|NEXUS_PASSWORD|nexus pass word|
|RELEASE_REPOSITORY_URL|release url|
|SNAPSHOT_REPOSITORY_URL|snapshot url|

> VERSION_NAME has `SNAPSHOT` will upload to snapshot!

edit module `gradle.properties`

|key|value|
|-----|--------|
|POM_ARTIFACT_ID|artifact id|

# Dependency

at root project `build.gradle`

```gradle
...

allprojects {
    repositories {
        // do not use same URL with job module!
        if (isReleaseBuild()) {
            maven { url RELEASE_REPOSITORY_URL }
        } else {
            maven { url SNAPSHOT_REPOSITORY_URL }
        }
        jcenter()
    }
}
```

- RELEASE_REPOSITORY_URL set `Job module`at `${ProjectRoot}/gradle.properties`
- SNAPSHOT_REPOSITORY_URL set `Job module`at `${ProjectRoot}/gradle.properties`

you can set like `file:///Users/user/Downloads/mvn-repo/release/` when use local build

in module `build.gradle`

```gradle
dependencies {
    compile 'com.sinlov.android:plugin:0.0.1'
}
```

out `*.apk` in `app/build/outApk/`

# Usage

`just write use of lib`

###License

---
