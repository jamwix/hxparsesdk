#import <Parse.h>

@interface HXParse : NSObject
    + (HXParse *)instance;
@end

@implementation HXParse

+ (HXParse*) instance
{
    static HXParse* instance;

    @synchronized(self)
    {
        if (!instance)
            instance = [[HXParse alloc] init];

        return instance;
    }
}		
    
- (id) init
{
    self = [super init];
    return self;
}

- (void) connect:(NSString*)appId withCK:(NSString*) clientKey
{
    [Parse setApplicationId: appId clientKey: clientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
} 

@end

namespace hxparse
{
    void connect(const char *sAppId, const char *sClientKey)
    {
        [[HXParse instance] connect: [[NSString alloc] initWithUTF8String: sAppId]
                             withCK: [[NSString alloc] initWithUTF8String: sClientKey]];
    }
}
