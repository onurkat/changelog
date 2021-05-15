#!/bin/bash

# Author : Onur Kat
# Contact info : github.com/onurkat

JIRA_PREFIX="HP"

echo "***** Changelog Generator *****"
echo "Checking Git status..."

if ! git ls-files >& /dev/null; then
echo "Error! Couldn't find the git repository. Are you in the correct directory?"
return
else
echo "OK."
fi
echo "Executing Git fetch to get latest tags from remote..."
git fetch --prune origin +refs/tags/*:refs/tags/* > /dev/null 2>&1
echo "OK."

LATEST_TAG=$(git tag --sort=-version:refname | head -n 1)

echo "Use latest tag for deployment or change?"
echo " 1) Use latest $LATEST_TAG"
echo " 2) Change"
while : 
do
read selection
  case $selection in
	1)	TAG_SEL_FLAG=1
		break
		;;
	2)	TAG_SEL_FLAG=2
		break			
		;;
	*)
		echo "[Select 1 or 2 only]"		
		;;
  esac
done

if [ "2" = "$TAG_SEL_FLAG" ]; then
echo "Listing last 10 tags. Please select a deployment tag..."
TAGS=$(git tag --sort=-version:refname | head -n 10)
select LATEST_TAG in $TAGS
do
echo "Selected deployment tag: "$LATEST_TAG
break
done
fi

echo "Listing last 10 tags. Please select a base tag to list changes from -> to "$LATEST_TAG
TAGS=$(git tag --sort=-version:refname | head -n 11 | grep -v $LATEST_TAG)
select OLD_TAG in $TAGS
do
echo "Selected base tag: "$OLD_TAG
break
done
echo "Please select the environment..."
select ENV in "DEV" "STAGE" "PROD"
do
echo "Selected environment: "$ENV
break
done

echo ""
echo "Generating changelog... $OLD_TAG -> $LATEST_TAG"
echo "OK."
echo ""
echo ""

echo "*$LATEST_TAG $ENV Deployment*"
echo ""
echo "*Changelog (from $OLD_TAG)*"

git log --date=format:"%d %b %H:%M" --pretty="- %s (%aN - %ad)" $LATEST_TAG...$OLD_TAG | grep -i $JIRA_PREFIX | grep -v "Merge pull request" | grep -v "Merge branch "

echo ""
echo ""
