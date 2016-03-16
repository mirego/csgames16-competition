#!/bin/sh
# Application Bundle Indentifier (see your applications's Info.plist)
OPTION_FORCE_APP_BUNDLE_IDENTIFIER="YES"

# Put the location of your project's Info.plist file.
APP_INFO_PLIST="RebelChat/Supporting Files/Info.plist"

# The name and relative path to the workspace file. Should be in the
# root of your repo so only the file name will do.
BUILD_WORKSPACE="RebelChat.xcworkspace"

BUILD_WORKSPACE_NAME="RebelChat"

# Prevent issues with pod install
BUILD_REMOVE_PODS_FOLDER="YES"

# The name of the build scheme that's marked as shared in XCode and to
# use to build the application.
BUILD_SCHEME="RebelChat"

#!/bin/sh
# Application Bundle Indentifier (see your applications's Info.plist)
APP_BUNDLE_IDENTIFIER="com.mirego.RebelChat"

# The name the application will have. It's your chance to add
# information to the name. For dev builds it's suggested to use
# Like "AppName [dev]"
# (default: use value from plist)
APP_BUNDLE_NAME="RebelChat"

# Specify the PRODUCT_NAME (use when XCode generates the binary)
# (default: $BUILD_SCHEME)
# APP_PRODUCT_NAME="Product name"

# Uncomment the following lines if you want to use a different
# provisioning profile than Mirego's Team Provisioning Profile.
# The directory containing the provisioning profile relative to your
# repository root.
# PROVISIONING_DIR="Releases"

# The name of the provisioning profile file in your repository. Having
# the provisioning profile in your repo allows you to update it easily.
# PROVISIONING_FILE="SuperCompany_AdHoc_Profile.mobileprovision"

# The name of the private key to use to sign the build. This must be
# installed by an admin of the jenkins server. Email jenkins@mirego.com
# to let them know that you need this. Make sure you have the private
# key on hands.
PROVISIONING_NAME="iPhone Distribution: Mirego"

#<EXPERIMENTAL>
#
# You can install the provisioning certificate straight from your build
# You need to provide the p12 and the password to that p12 file.
# It must be located in PROVISIONING_DIR.
# PROVISIONING_CERTIFICATE_FILE="ios_distribution.p12"
#
# The password for the provisioning certificate.
# Needed to import it.
#PROVISIONING_CERTIFICATE_PASSWORD="SuperPassword:1234567"
#
#</EXPERIMENTAL>

# The Jenkins will increment the build number after a succesfull build
# (default:"NO")
BUILD_UPDATE_VERSION_NUMBER="NO"

# Send build to TestFlight after build?
# (default:"YES")
TESTFLIGHT_UPLOAD="NO"

# Upload the build to HockeyApp
# (default:"NO")
HOCKEYAPP_UPLOAD="YES"

# Specify HockeyApp App ID for uploads
# (default:<not defined>)
HOCKEYAPP_APP_ID="2ea5af987d3e4355a35dfe850aebb679"

# When your build completes Jenkins can push the changes to your git
# repo. This is great if you're doing automatic build numbers and
# Continuous Integration (CI).
# (default:"NO")
#PUSH_CHANGES="YES"

# When your build completes Jenkins can tag the current git version
# This is great for client builds. The tag will follow the following
# format: $TAG_PREFIX/$VERSION
# (default:"NO")
#TAG_VERSION="YES"

# Prefix used when tagging.
# (default:"$BUILD_CONFIGURATION")
#TAG_PREFIX="SuperClientBuild"

# Should more detailed be shown in the script output
# (default:NO)
VERBOSE="YES"

# Enable running unit tests after build. At the moment it will not prevent
# Testflight upload or push to github. It's the very last step in the build
# process. Don't forget to set UNIT_TEST_BUILD_SCHEME if you set it to "YES"
# (default:NO)
#UNIT_TEST="YES"

# The name of the build scheme that's marked as shared in XCode and to
# use to build the application with the unit tests. Usually end with "Tests".
#UNIT_TEST_BUILD_SCHEME="SuperAppTests"

# You can choose which build configuration to use. (Release, Debug, # etc.)
# for your unit test build (different from the first build)
# (default:"Test")
#UNIT_TEST_BUILD_CONFIGURATION="Debug"


# You can choose which version of Xcode to use to build. Only usefull if
# you need an old Xcode of a DP version of Xcode. Most of the time you
# don't need to change this.
# (default:"/Applications/Xcode.app/Contents/Developer")
