//
//  Constants.h
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//


#define TAKESTOK_API_URL                @"http://uat.takestock.com/api/v1/"
#define TAKESTOK_IMAGE_URL              @"http://uat.takestock.com"


//FONTS
#define BrandonGrotesqueBold16  [UIFont fontWithName:@"BrandonGrotesque-Bold" size:16]
#define BrandonGrotesqueBold14  [UIFont fontWithName:@"BrandonGrotesque-Bold" size:14]
#define BrandonGrotesqueBold13  [UIFont fontWithName:@"BrandonGrotesque-Bold" size:13]
#define HelveticaNeue18         [UIFont fontWithName:@"HelveticaNeue" size:18]
#define HelveticaNeue14         [UIFont fontWithName:@"HelveticaNeue" size:14]
#define Helvetica14         [UIFont fontWithName:@"Helvetica" size:14]
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
#define OFFERS_UPDATED_NOTIFICATION         @"OfferUpdatedNotification"
#define ADVERTS_UPDATED_NOTIFICATION        @"AdvertUpdatedNotification"
#define QUESTIONS_UPDATED_NOTIFICATION      @"QuestionsUpdatedNotification"

//SEGUE IDS
#define CREATE_ADVERT_SEGUE         @"CreateAdvertSegue"
#define EDIT_ADVERT_SEGUE           @"EditAdvertSegue"
#define ADVERT_OFFERS_SEGUE         @"AdvertOffersSegue"
#define SEARCH_ADVERT_SEGUE         @"SearchAdvertSegue"
#define ADVERT_DETAIL_SEGUE         @"AdvertDetailSegue"
#define ADVERT_IMAGES_SEGUE         @"AdvertImagesSegue"
#define ADVERT_QUESTIONS_SEGUE      @"QuestionsSegue"
#define CATEGORIES_SEGUE            @"CategoriesSegue"
#define USER_DETAILS_SEGUE          @"UserDetailsSegue"

//CONTROLLER IDS
#define LOGIN_CONTROLLER            @"LoginViewController"
#define MENU_CONTROLLER             @"MenuViewController"
#define HOME_CONTROLLER             @"HomeViewController"
#define USER_PROFILE_CONTROLLER     @"UserProfileController"
#define SELLING_CONTROLLER          @"SellingController"
#define BUYING_CONTROLLER           @"BuyingController"
#define WATCH_LIST_CONTROLLER       @"WatchListController"
#define ABOUT_US_CONTROLLER         @"AboutUsController"
#define CONTACT_US_CONTROLLER       @"ContactUsController"
#define LEGAL_INFO_CONTROLLER       @"LegalInformationController"



