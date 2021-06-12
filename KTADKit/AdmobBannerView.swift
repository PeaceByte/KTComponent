//
//  AdmobBannerView.swift
//  DrawingBoard
//
//  Created by C on 2021/5/19.
//  Copyright © 2021 C. All rights reserved.
//

import Foundation
import GoogleMobileAds
import KTFoundationKit

class AdmobSDK:NSObject{
    var isStarted = false;
    var config:ADConfig?
    private override init() {
        super.init()
    }
    
    static let sharedInstance: AdmobSDK = {
        AdmobSDK()
    }()
    
    func start(config:ADConfig, completed:@escaping () -> Void){
        LogManager.debug("started");
        if(!isStarted){
            self.config = config;
            #if DEBUG
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = self.config?.testDeviceIdentifiers;
            #endif
            
            GADMobileAds.sharedInstance().start {[weak self] (status:GADInitializationStatus) in
                self?.isStarted = true;
                completed();
                LogManager.debug("completed");
            }
        }else{
            LogManager.debug("is started");
        }
        LogManager.debug("finished");
    }
  
    
}

class AdmobBannerView: NSObject,IADBannerView{
    private override init() {
        super.init()
    }
    
    private var bannerView:GADBannerView?
    static func createBannerView(rootViewController:UIViewController)-> IADBannerView{
        
       
        let bannerView = AdmobBannerView();
        let admobBannerView = GADBannerView()
        admobBannerView.rootViewController = rootViewController
        admobBannerView.adUnitID = AdmobSDK.sharedInstance.config?.bannerAdId;
        admobBannerView.delegate = bannerView;
        bannerView.bannerView = admobBannerView;
        return bannerView;
    }
    
    func getBannerView() -> UIView?{
        return bannerView;
    }
    func loadAD(_ view: UIView?) {
        guard let bannerView = bannerView,
            let view = view else {
            return;
        }
        let adaptiveSize = self.getAdaptiveSize(view);
        bannerView.adSize = GADAdSizeFromCGSize(adaptiveSize);

        // Step 4 - Create an ad request and load the adaptive banner ad.
        bannerView.load(GADRequest())
    }
    
    func getAdaptiveSize(_ view: UIView?) -> CGSize {
        var resSize:CGSize = .zero;
        guard let view = view else {
            return resSize;
        }
        
        let frame = { () -> CGRect in
          // Here safe area is taken into account, hence the view frame is used
          // after the view has been laid out.
          if #available(iOS 11.0, *) {
            return view.frame.inset(by: view.safeAreaInsets)
          } else {
            return view.frame
          }
        }()
        let viewWidth = frame.size.width

        
        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        resSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth).size;
        return resSize;
    }
}

extension AdmobBannerView:GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        LogManager.debug("started");
        LogManager.debug("finished");
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        LogManager.debug("started error = \(error.localizedDescription)");
        LogManager.debug("finished");
    }
    
}

