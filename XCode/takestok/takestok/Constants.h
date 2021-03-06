//
//  Constants.h
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

//
#define TAKESTOK_API_URL                @"http://takestock.com/api/v1/"
#define TAKESTOK_IMAGE_URL              @"http://takestock.com"
//#define TAKESTOK_API_URL                @"http://uat.takestock.com/api/v1/"
//#define TAKESTOK_IMAGE_URL              @"http://uat.takestock.com"
#define CONTACT_US_EMAIL                @"admin@wetakestock.com"

#define PUT_ON_HOLD_STATE 2

//FONTS
#define BrandonGrotesqueBold16  [UIFont fontWithName:@"BrandonGrotesque-Bold" size:16]
#define BrandonGrotesqueBold14  [UIFont fontWithName:@"BrandonGrotesque-Bold" size:14]
#define BrandonGrotesqueBold13  [UIFont fontWithName:@"BrandonGrotesque-Bold" size:13]
#define HelveticaNeue18         [UIFont fontWithName:@"HelveticaNeue" size:18]
#define HelveticaNeue16         [UIFont fontWithName:@"HelveticaNeue" size:16]
#define HelveticaNeue14         [UIFont fontWithName:@"HelveticaNeue" size:14]
#define Helvetica14             [UIFont fontWithName:@"Helvetica" size:14]
#define HelveticaLight18        [UIFont fontWithName:@"Helvetica-Light" size:18]
#define ArialBold14             [UIFont fontWithName:@"Arial-BoldMT" size:14]
#define ArialItalic14           [UIFont fontWithName:@"Arial-ItalicMT" size:14]

//COLORS
#define OliveMainColor      [UIColor colorWithRed:190./255. green:188./255. blue:50./255. alpha:1.]
#define OberginMainColor    [UIColor colorWithRed:127./255. green:17./255. blue:83./255. alpha:1.]
#define LightGrayColor      [UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1.]
#define GrayColor           [UIColor colorWithRed:147./255. green:149./255. blue:152./255. alpha:1.]

//HELPERS
#define ERROR_MESSAGE(er) er.localizedFailureReason.length > 0 ? er.localizedFailureReason : er.localizedDescription

//NOTIFICATIONS
#define NOTIFICATION_UPDATED_NOTIFICATION   @"NotificationUpdatedNotification"

//STORUBOARD IDS
#define MAIN_STORYBOARD             @"Main"
#define ADVERT_STORYBOARD           @"Advert"
#define LISTS_STORYBOARD            @"Lists"
#define USER_STORYBOARD             @"User"
#define SELLING_STORYBOARD          @"Selling"
#define BUYING_STORYBOARD           @"Buying"


//SEGUE IDS
#define CREATE_ADVERT_SEGUE         @"CreateEditAdvertSegue"
#define EDIT_ADVERT_SEGUE           @"EditAdvertSegue"
#define ADVERT_OFFERS_SEGUE         @"AdvertOffersSegue"
#define SEARCH_ADVERT_SEGUE         @"SearchAdvertSegue"
#define ADVERT_DETAIL_SEGUE         @"AdvertDetailSegue"
#define ADVERT_IMAGES_SEGUE         @"AdvertImagesSegue"
#define ADVERT_QUESTIONS_SEGUE      @"QuestionsSegue"
#define CATEGORIES_SEGUE            @"CategoriesSegue"
#define USER_DETAILS_SEGUE          @"UserDetailsSegue"
#define BUYER_OFFERS_SEQUE          @"BuyingOffersSegue"
#define OFFERS_SHIPPING_SEQUE       @"ShippingSegue"
#define OFFERS_DISPATCH_INFO_SEQUE  @"DispatchInfoSegue"
#define SIMILAR_ADVERTS_SEQUE       @"MoreAdvertsSegue"
#define PAY_BY_BACS_SEGUE           @"PayByBacsSegue"
#define PAY_BY_CARD_SEGUE           @"PayByCardSegue"

//CONTROLLER IDS
#define LOGIN_CONTROLLER            @"LoginViewController"
#define MENU_CONTROLLER             @"MenuViewController"
#define HOME_CONTROLLER             @"HomeViewController"
#define USER_PROFILE_CONTROLLER     @"UserProfileController"
#define SELLING_CONTROLLER          @"SellingController"
#define BUYING_CONTROLLER           @"BuyingController"
#define OVERVIEW_CONTROLLER         @"OverViewController"
#define ABOUT_US_CONTROLLER         @"AboutUsController"
#define CONTACT_US_CONTROLLER       @"ContactUsController"
#define LEGAL_INFO_CONTROLLER       @"LegalInformationController"
#define NOTIFICATION_CONTROLLER     @"NotificationsViewController"
#define OFFER_MANAGER_CONTROLLER    @"OfferManagerViewController"
#define QA_CONTROLLER               @"QAViewController"
#define BUYING_OFFER_CONTROLLER     @"BuyingOffersViewController"
#define ADVERT_DETAIL_CONTROLLER    @"AdvertDetailViewController"

typedef void (^resultBlock)(NSArray* result, NSDictionary* additionalData, NSError* error);
typedef void (^errorBlock)(NSError* error);



