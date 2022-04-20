//
//  AdmobOpenAppAd.swift
//  blur
//
//  Created by C on 2021/5/23.
//  Copyright © 2021 magician. All rights reserved.
//

import Foundation
import GoogleMobileAds
import KTFoundationKit


class AdmobrewardedInterstitialAd:NSObject{
    var ad:GADRewardedInterstitialAd?;
    var loadTime = Date()
    
    private override init() {
        super.init()
       
    }
    
    static let sharedInstance: AdmobrewardedInterstitialAd = {
        AdmobrewardedInterstitialAd()
       
    }()
    
    
    func requestAd(){
        LogManager.debug("started")
        guard let adId = AdmobSDK.sharedInstance.config?.rewardedInterstitialAdId else {
            LogManager.debug("rewardedInterstitialAdId = nil")
            return;
        }
        LogManager.debug("rewardedInterstitialAdId = \(adId)");
        let request = GADRequest();
        GADRewardedInterstitialAd.load(withAdUnitID: adId, request: request) {
            (adIn, error) in
            if (error == nil){
                self.ad = adIn;
                self.ad?.fullScreenContentDelegate = self;
                self.loadTime = Date()
            }
           
            LogManager.debug("Ad is ready")
        }
       /* GADAppOpenAd.load(withAdUnitID: appOpenAdId,
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
                            self.appOpenAd = appOpenAdIn
                            self.appOpenAd?.fullScreenContentDelegate = self
                            self.loadTime = Date()
                            LogManager.debug("Ad is ready")
                          })*/
        LogManager.debug("finished")
    }
    
    func tryToPresentAd(viewController:UIViewController?, userDidEarnRewardHandler:@escaping UserDidEarnRewardBlock) -> Bool {
        var res = false;
     
   
        
        if let ad = self.ad, let rwc = viewController, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            LogManager.debug("present");
            ad.present(fromRootViewController: rwc) {
                LogManager.debug("started");
                if let reward = self.ad?.adReward{
                    // TODO: Reward the user!
                    let adReward = ADReward()
                    adReward.amount = reward.amount;
                    userDidEarnRewardHandler(adReward);
                    
                }else{
                    LogManager.debug("error");
                }
                LogManager.debug("finished");
            }
            
            res = true;
        } else {
            LogManager.debug("request");
            self.requestAd();
        }
        return res;
    }

    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
}



extension AdmobrewardedInterstitialAd:GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        LogManager.debug("started \(error.localizedDescription)");
        self.requestAd();
        LogManager.debug("finished");
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LogManager.debug("started");
        self.requestAd();
        LogManager.debug("finished");
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LogManager.debug("started");
        LogManager.debug("finished");
    }
}
