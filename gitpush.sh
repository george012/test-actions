#!/bin/bash
set -e

ProductName=test_upload_assets
VersionFile=./version.txt

aVersion=`cat $VersionFile | grep -n "VERSION=" | awk -F ":" '{print $2}'`
CurrentVersionString=`echo "${aVersion/'VERSION='/}" | sed 's/\"//g'`
echo "============================ ${ProductName} ============================"
echo "  1、发布 [-${ProductName}-]"
echo "  当前版本[-${CurrentVersionString}-]"
echo "======================================================================"
read -p "$(echo -e "请输入版本号[例如；v0.0.1]")" inputString
versionStr=""
if [[ "$inputString" =~ ^v.* ]]; then
    versionStr=${inputString}
else
    versionStr=v${inputString}
fi

fileVersionLineNo=`cat $VersionFile | grep -n "VERSION=" | awk -F ":" '{print $1}'`

oldfileVersionStr=`cat $VersionFile | grep -n "VERSION=" | awk -F ":" '{print $2}'`

newVersionStr='VERSION=''"'$versionStr'"'
sed -i "" -e "${fileVersionLineNo}s/${oldfileVersionStr}/${newVersionStr}/g" $VersionFile

ovs=${oldfileVersionStr#VERSION=\"}
APP_OLD_VERSION=${ovs%\"}
PRE_DEL_VERSION=${APP_OLD_VERSION%.*}.$((${APP_OLD_VERSION##*.}-1))

git add . && git commit -m "Update ${ProductName} ${versionStr}"  && git tag $versionStr && git push && git push --tags && git tag -f latest $versionStr && git push -f origin latest && git tag -d $PRE_DEL_VERSION
