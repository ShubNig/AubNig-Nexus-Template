#!/usr/bin/env bash

# this script need gradle android hone

# change this for module
android_build_modules=
android_build_modules[0]=plugin
#android_build_modules[1]=module

product_flavors=""
product_flavors_list="dev test prod"
build_mode="Release"
hint_build_mode="release"

# change this for middle or last build job
android_build_task_middle="generate${product_flavors}${build_mode}Sources"
android_build_task_last="jacoco${product_flavors}${build_mode}Report"

shell_run_path=$(cd `dirname $0`; pwd)

checkFuncBack(){
  if [ $? -eq 0 ]; then
    echo "$1 success"
  else
    echo "$1 error stop build"
    exit 1
  fi
}

checkEnv(){
    evn_checker=`which $1`
  if [ ! -n "evn_checker" ]; then
    echo "check event [ $1 ] error exit"
    exit 1
  else
    echo -e "Cli [ $1 ] event check success\n-> $1 at Path: ${evn_checker}"
  fi
}

checkGradleModule(){
    module_len=${#android_build_modules[@]}
    if [ ${module_len} -le 0 ]; then
        echo "you set [ android_build_modules ] is empty"
        exit 1
    fi

    setting_gradle_path="${shell_run_path}/settings.gradle"
    if [ -f "${setting_gradle_path}" ]; then
        echo "Find settings gradle at: ${setting_gradle_path}"
    else
        echo "can not find settings gradle at ${shell_run_path} exit"
        exit 1
    fi
    for module in ${android_build_modules[@]};
    do
        find_module_set=`cat ${setting_gradle_path} | grep "$module"`
        if [ ! -n "$find_module_set" ]; then
            echo -e "check gradle module [ ${module} ] error\nYou are not setting $module at ${setting_gradle_path}"
            exit 1
        else
            echo -e "check gradle module [ ${module} ] success\nAt Path: ${setting_gradle_path}\n-> setting is: ${find_module_set}"
        fi
        module_path="${shell_run_path}/${module}"
        if [ ! -d "${module_path}" ]; then
            echo -e "check gradle module [ ${module} ] error\nCode path not find\n->Set at: ${module}\n-> Want Path: ${module_path}"
            exit 1
        fi
    done
}

if [ ! -n "$ANDROID_HOME" ]; then
    echo "You are not setting ANDROID_HOME stop build"
    exit 1
else
    echo -e "You are setting ANDROID_HOME\nAt Path: ${ANDROID_HOME}"
fi

checkEnv git
checkEnv java
checkEnv android
checkEnv gradle
checkGradleModule

if [ ! -x "gradlew" ]; then
    echo "this path gradlew not exec just try to fix!"
    chmod +x gradlew
else
    echo "=> local gradlew can use"
fi

git status
git pull
git branch -v

if [ -n "$1" ];then
    echo "you are not set product_flavors, like ${product_flavors_list}, use default"
else
    product_flavors=$1
    android_build_task_middle="generate${product_flavors}${build_mode}Sources"
    android_build_task_last="jacoco${product_flavors}${build_mode}Report"
fi

# if want clean unlock this
#echo "-> gradle task clean"
#./gradlew clean

for module in ${android_build_modules[@]};
do
    echo "-> gradle task ${module}:dependencies"
    ./gradlew -q ${module}:dependencies
#    echo "-> gradle task ${module}:dependencies --refresh-dependencies"
#    ./gradlew -q ${module}:dependencies --refresh-dependencies
    echo "-> gradle task ${module}:${android_build_task_middle}"
    ./gradlew ${module}:${android_build_task_middle}
    echo "-> gradle task ${module}:${android_build_task_last}"
    ./gradlew ${module}:${android_build_task_last}
    done

# jenkins config JUnit first Invoke Gradle script
echo -e "\nJenkins config \033[;36mInvoke Gradle script\033[0m"
echo -e "\033[;34mTasks\033[0m"
echo -e "clean --refresh-dependencies
generateReleaseSources
compileReleaseJavaWithJavac"

# jenkins config JUnit test Invoke Gradle script
echo -e "\nJenkins config \033[;36mInvoke Gradle script\033[0m"
echo -e "\033[;34mTasks\033[0m"
for module in ${android_build_modules[@]};
do
    echo -e ":${module}:jacoco${build_mode}Report"
    done

# jenkins config JUnit test result report
echo -e "\nJenkins config \033[;36mPublish JUnit test result report\033[0m"
echo -e "\033[;34mTest Report XML\033[0m"
for module in ${android_build_modules[@]};
do
    echo -e "${module}/build/test-results/test${build_mode}UnitTest/${hint_build_mode}/*.xml,"
    done

# jenkins config Record JaCoco coverage report
echo -e "\nJenkins config \033[;36mRecord JaCoco coverage report\033[0m"

echo -e "\033[;34mPath to exec files\033[0m"
for module in ${android_build_modules[@]};
do
    echo -e "${module}/build/jacoco/**.exec,"
    done
echo -e "\033[;34mPath to class directories\033[0m"
for module in ${android_build_modules[@]};
do
    echo -e "${module}/build/intermediates/classes/${hint_build_mode},"
    done
echo -e "\033[;34mPath to source directories\033[0m"
for module in ${android_build_modules[@]};
do
    echo -e "${module}/src/main/java,"
    done

echo -e "\033[;33mExclusions\033[0m"
echo -e "**/*Test.class,**/R.class,**/R\$*.class,**/Manifest*.*,android/**/*.*,**/BuildConfig.*,**/*\$ViewBinder*.*,**/*\$ViewInjector*.*,**/Lambda\$*.class,**/Lambda.class,**/*Lambda.class,**/*Lambda*.class,**/\$*.class,**/db/*.class,**/http/*.class,**/net/*.class,**/widget/*.class,**/sync/*.class,**/log/*.class"

