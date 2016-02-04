# SocialLogin
This project will serve as a login to iOS apps. At present you can login with Facebook, Twitter, LinkedIn and Google.


1. Drag drop the lib file to your project.

2. Drag drop include folder to your project. 

	2.1 #import "SocialIntegration.h"

	2.2 Subclass a view controller with SocialIntegration

	2.3 Add social login buttons as below:

		- (void) loginToService:(SISocialType) eType withSignInButtonImage:(UIImage *) buttonImage atCoordinateSpace:(CGRect) aRect withCompletionHandler:(CompletionHandler)inCompletionHandler;

Note: For SignIn with Google, add GoogleService-Info.plist to your bundle also add REVERSED_CLIENT_ID (found in GoogleService-Info.plist)
 to URL Schemes in Target->URL Types.

3. Add the below keys to your main plist file in your project.

(You can add all or only those keys required for respective social n/w used in your project)

FacebookAppID
FacebookDisplayName
TwitterConsumerKey
TwitterSecretKey
LinkedInApiKey
LinkedInSecretKey
GoogleClientId
 
4. Add the following frameworks to your project.

(You can add all or only those frameworks required for respective social n/w used in your project)

AssetsLibrary.framework
CoreLocation.framework
MediaPlayer.framework
CoreText.framework
CoreGraphics.framework
CoreFoundation.framework
Foundation.framework
Security.framework
SystemConfiguration.framework
MessageUI.framework
MobileCoreServices.framework
CoreMotion.framework
QuartzCore.framework
FacebookSDK.framework
