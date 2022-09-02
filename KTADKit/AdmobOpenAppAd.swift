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


class AdmobOpenAppAd:NSObject{
    var appOpenAd:GADAppOpenAd?;
    var loadTime = Date()
    
    private override init() {
        super.init()
       
    }
    
    static let sharedInstance: AdmobOpenAppAd = {
        AdmobOpenAppAd()
       
    }()
    
    
    func requestAppOpenAd(){
        LogManager.debug("started")
        guard let appOpenAdId = AdmobSDK.sharedInstance.config?.appOpenAdId else {
            LogManager.debug("appOpenADId = nil")
            return;
        }
        LogManager.debug("appOpenADId = \(appOpenAdId)");
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: appOpenAdId,
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
                            self.appOpenAd = appOpenAdIn
                            self.appOpenAd?.fullScreenContentDelegate = self
                            self.loadTime = Date()
                            LogManager.debug("Ad is ready")
                          })
        LogManager.debug("finished")
    }
    
    func tryToPresentAd(viewController:UIViewController?) -> Bool {
        var res = false;
     
   
        
        if let gOpenAd = self.appOpenAd, let rwc = viewController {
            LogManager.debug("present");
            gOpenAd.present(fromRootViewController: rwc)
            res = true;
        } else {
            LogManager.debug("request");
            self.requestAppOpenAd()
        }
        return res;
    }

    /*
    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }*/
}

extension AdmobOpenAppAd:GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        LogManager.debug("started \(error.localizedDescription)");
        self.requestAppOpenAd();
        LogManager.debug("finished");
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LogManager.debug("started");
        self.requestAppOpenAd();
        LogManager.debug("finished");
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LogManager.debug("started");
        LogManager.debug("finished");
    }
}
