.PHONY: dist test build

test_module_name := test
test_run_package_name = com.sinlov.android.demo.temp
test_run_am_name := $(test_run_package_name)/$(test_run_package_name).MainActivity

# ifeq ($(FILE), $(wildcard $(FILE)))
# 	@ echo target file not found
# endif

checkEnvAndroidHome:
ifndef ANDROID_HOME
	@ echo Environment variable ANDROID_HOME is not set
	exit 1
endif

# init this project
init: checkEnvAndroidHome
	./gradlew clean buildEnvironment

# find out module test CompileClasspath
testDependDebug: checkEnvAndroidHome
	./gradlew :$(test_module_name):dependencies --configuration debugCompileClasspath

# module test install debug apk
testInstallDebug: checkEnvAndroidHome
	./gradlew :$(test_module_name):installDebug

# module test uninstall debug apk
testUninstallDebug: checkEnvAndroidHome
	./gradlew :$(test_module_name):uninstallDebug

# module test install debug apk and start it
testDebug: testInstallDebug
	adb shell am start -n $(test_run_am_name) -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

help:
	@echo "make clean -> remove build files"
	@echo "make init -> init this project"
	@echo "make testDependDebug -> module $(test_module_name) find out jar CompileClasspath"
	@echo "make testInstallDebug -> module $(test_module_name) install debug apk"
	@echo "make testUninstallDebug -> module $(test_module_name) uninstall debug apk"
	@echo "make testDebug -> module $(test_module_name) install debug apk and start it"