//
//  Common.h
//  ringtone maker
//
//  Created by C on 2021/6/10.
//

#ifndef Common_h
#define Common_h

#if DEBUG
#define LOG_DEBUG(msg, ...) NSLog(@"%s %d > %@ \n", __FUNCTION__, __LINE__,[NSString stringWithFormat:(msg),##__VA_ARGS__]);
#else
#define LOG_DEBUG(...)
#endif


static const float iosToolBarHeight = 44;

#endif /* Common_h */
