[TOC]

# Env

Project Runtime:

|title|description|
|-----|-----------|
|jdk|1.8.+|
|gradle|2.14.1|
|Android Studio|2.2.3|
|com.android.tools.build:gradle|2.2.3|
|appcompat-v7|25.0.1|
|compile SDK version|25|
|build tools version|25.0.3|
|target SDK version|15|
|min SDK version|15|

## Less Runtime

- Android API 23
- Android Studio 2.2.3
- appcompat-v7:23.4.0
- Gradle 2.14.1
- com.android.tools.build:gradle:2.2.3
- minSdkVersion 15

test Runtime

```gradle
    testCompile 'junit:junit:4.12'
    testCompile 'org.mockito:mockito-core:2.7.22'
    testCompile "org.robolectric:robolectric:3.3.2"
    testCompile "org.robolectric:shadows-support-v4:3.3.2"
```


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

---

License

<pre>
Copyright sinlovgmppt@gmail.com 2017

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>
