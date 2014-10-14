#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface {{_name_}} : NSProxy
@property (strong, nonatomic) NSObject *target;
- (instancetype)initWithTarget:(NSObject *)target;
@end

