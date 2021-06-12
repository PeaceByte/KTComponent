//
//  AdmobIntersectAd.swift
//  blur
//
//  Created by C on 2021/5/23.
//  Copyright © 2021 magician. All rights reserved.
//

import Foundation
import GoogleMobileAds
import KTFoundationKit

class AdmobIntersectAd:NSObject{
    var adRequesting:Bool = false
    var interstitial:GADInterstitialAd?
  
    private override init() {
        super.init()
      
    }
    
    static let sharedInstance: AdmobIntersectAd = {
        AdmobIntersectAd()
       
    }()
    
    func createAndLoadInterstitial()  {
        guard let interstitialAdId = AdmobSDK.sharedInstance.config?.interstitialAdId else {
            return;
        }
        self.adRequesting  = true;
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:interstitialAdId,
                               request: request,
                               completionHandler: { (ad, error) in
                                self.adRequesting  = false
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                self.interstitial = ad
                                self.interstitial?.fullScreenContentDelegate = self
                               }
        )
    }
    
    func showInterstitial(in viewController:UIViewController) -> Bool{
        var res = true
        
        var canPresent = false;
        if let interstitial = self.interstitial{
            do {
                try interstitial.canPresent(fromRootViewController: viewController);
                canPresent = true;
                
                LogManager.debug("present")
                interstitial.present(fromRootViewController: viewController)
                
            }catch {
                LogManager.debug("error = \(error.localizedDescription)");
            }
        }
        
        if(!canPresent){
            LogManager.debug("interstitialCreate")
            self.createAndLoadInterstitial()
            res = false
        }

        return res
    }
    
}



extension AdmobIntersectAd:GADFullScreenContentDelegate{
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad failed to present full screen content with error \(error.localizedDescription).")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
      createAndLoadInterstitial()
    }
}
