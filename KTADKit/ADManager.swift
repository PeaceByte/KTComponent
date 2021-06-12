//
//  ADBannerViewManager.swift
//  DrawingBoard
//
//  Created by C on 2021/5/19.
//  Copyright © 2021 C. All rights reserved.
//

import UIKit
import KTFoundationKit

public let IntersectAdReceivedNotification = "IntersectAdReceivedNotification";



@objc public enum ADProvider: Int {
    case admob
    #if FB_ENABLE
    case facebook
    #endif
    #if MOPUB_ENABLE
    case mopub
    #endif
}

@objc public protocol IADBannerView{
    @objc func getBannerView() -> UIView?;
    @objc func loadAD(_ view:UIView?);
    @objc func getAdaptiveSize(_ view:UIView?) -> CGSize;
}

@objc public class ADConfig:NSObject{
    @objc public var provider:ADProvider = .admob;
    @objc public var interstitialInterval:TimeInterval = 90;//单位秒
    @objc public var testDeviceIdentifiers:[String]?
    @objc public var bannerAdId:String?;
    @objc public var interstitialAdId:String?;
    @objc public var appOpenAdId:String?;
}

@objc public class ADManager: NSObject {
    public var adEnable = true;
    private let adProviderKey = "adProvider"
    private var config:ADConfig?
    private override init() {
        super.init()
    }
    
    @objc public static let sharedInstance: ADManager = {
        ADManager()
    }()
    
    @objc public func start(config:ADConfig, completed:@escaping ()->Void){
       
        self.config = config;
        var adType:ADProvider = .admob
        if let adProvider = AdvancedSettingManager.sharedInstance.intVauleSetting(for:adProviderKey){
            adType = ADProvider(rawValue: adProvider) ?? .admob
        }
        
        switch (adType) {
        case .admob:
            LogManager.debug("start admob")
            AdmobSDK.sharedInstance.start(config: self.config!) {
                completed();
            }
            
        #if FB_ENABLE
        case .facebook:
            
            LogManager.debug("start facebook")
        // [[FBInterstitialAdHelper sharedInstance] showInterstitial:viewController];
        #endif
        #if MOPUB_ENABLE
        case .mopub:
            
            LogManager.debug("start mopub")
        //    [[MopubInterstitialAdHelper sharedInstance] showInterstitial:viewController];
        
        #endif
        
        }
    }
    
    @objc public func createBannerView(rootViewController:UIViewController, provider:ADProvider = .admob) -> IADBannerView?{
        guard self.adEnable else {
            return nil
        }
        
        var provider:ADProvider = .admob
        if let adProvider = AdvancedSettingManager.sharedInstance.intVauleSetting(for:adProviderKey){
            provider = ADProvider(rawValue: adProvider) ?? .admob
        }
        
        var bannerView:IADBannerView?
       
    
        
        switch(provider){
        case .admob:
            bannerView = AdmobBannerView.createBannerView(rootViewController: rootViewController);
            break;
        }
        return bannerView;
    }
    
    
    // MARK: IntersectAd

    private var frequency:TimeInterval = 90//Second

    private let largeAdsFrequencyKey = "largeAdsFrequency"
    private var lastRequestDate:Date? = nil
    
    private func requestInterstitialEnable() -> Bool
    {
        var res = true
        let now = Date()
        
        if let configIntervale = self.config?.interstitialInterval{
            self.frequency = configIntervale;
        }
        if let frequency = AdvancedSettingManager.sharedInstance.doubleVauleSetting(for: largeAdsFrequencyKey) {
            self.frequency = frequency
            LogManager.debug("frequency = \(frequency)")
        }
        
        if let lastRequestDate = self.lastRequestDate{
            let passedTime = now.timeIntervalSince(lastRequestDate)
            LogManager.debug("passedTime = \(passedTime)")
            if(passedTime < self.frequency){
                res = false;
            }
        }
        
        return res
    }
    
    private func resetLastRequestTime(){
        self.lastRequestDate = Date()
    }
    
    private func configureAdSDK() -> Bool{
        return true
    }
    
    
    
    
    @objc public func showInterstitial(in viewController:UIViewController) -> Bool{
        var bRes = false
        
        LogManager.debug("started")
        if(!self.adEnable){
            LogManager.debug("IntersectAdHelper NotShow");
            return bRes
        }
        
        if(true){//![[IAPManager sharedInstance] isProductPurchased:kProductIDRemoveAds]
            var adType:ADProvider = .admob
            if let adProvider = AdvancedSettingManager.sharedInstance.intVauleSetting(for:adProviderKey){
                adType = ADProvider(rawValue: adProvider) ?? .admob
            }
            let isRequestEnable = self.requestInterstitialEnable()
            if isRequestEnable{
                bRes = self.showInterstitial(viewController: viewController, of: adType)
                if(bRes)
                {
                    self.resetLastRequestTime()
                }
            }
            
        }
        LogManager.debug("finish")
        return bRes
    }
    
   private func showInterstitial(viewController:UIViewController, of adProviderType:ADProvider) -> Bool {
        var bRes = true
        switch (adProviderType) {
        case .admob:
            LogManager.debug("Show AD_PROVIDER_TYPE_ADMOB ")
            bRes = AdmobIntersectAd.sharedInstance.showInterstitial(in: viewController);
            
        #if FB_ENABLE
        case .facebook:
            
            LogManager.debug("Show AD_PROVIDER_TYPE_FACEBOOK ")
        // [[FBInterstitialAdHelper sharedInstance] showInterstitial:viewController];
        #endif
        #if MOPUB_ENABLE
        case .mopub:
            
            LogManager.debug("Show AD_PROVIDER_TYPE_MOPUB")
        //    [[MopubInterstitialAdHelper sharedInstance] showInterstitial:viewController];
        
        #endif
        
        }
        return bRes;
        
    }
    
   @objc public func tryToPresentAd(in viewController:UIViewController?) -> Bool{
        var bRes = false
        
        LogManager.debug("started")
        if(!self.adEnable){
            LogManager.debug("IntersectAdHelper NotShow");
            return bRes
        }
        
        if(true){//![[IAPManager sharedInstance] isProductPurchased:kProductIDRemoveAds]
            var adType:ADProvider = .admob
            if let adProvider = AdvancedSettingManager.sharedInstance.intVauleSetting(for:adProviderKey){
                adType = ADProvider(rawValue: adProvider) ?? .admob
            }
            let isRequestEnable = true;//self.requestInterstitialEnable()
            if isRequestEnable{
                bRes = self.tryToPresentAd(viewController: viewController, of: adType)
                if(bRes)
                {
                   // self.resetLastRequestTime()
                }
            }
            
        }
        LogManager.debug("finish")
        return bRes
    }
    
    
    
    private func tryToPresentAd(viewController:UIViewController?, of adProviderType:ADProvider) -> Bool{
        var bRes = true
        switch (adProviderType) {
        case .admob:
            LogManager.debug("Show AD_PROVIDER_TYPE_ADMOB ")
            bRes = AdmobOpenAppAd.sharedInstance.tryToPresentAd(viewController: viewController);
            
        #if FB_ENABLE
        case .facebook:
            
            LogManager.debug("Show AD_PROVIDER_TYPE_FACEBOOK ")
        // [[FBInterstitialAdHelper sharedInstance] showInterstitial:viewController];
        #endif
        #if MOPUB_ENABLE
        case .mopub:
            
            LogManager.debug("Show AD_PROVIDER_TYPE_MOPUB")
        //    [[MopubInterstitialAdHelper sharedInstance] showInterstitial:viewController];
        
        #endif
        
        }
        return bRes;
        
    }
}



