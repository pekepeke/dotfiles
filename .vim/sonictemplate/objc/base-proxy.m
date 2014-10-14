#import "{{_name_}}.h"

@interface {{_name_}} ()
@end

@implementation {{_name_}}

- (instancetype)initWithTarget:(NSObject *)target
{
    _target = target;
    return target ? self : nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if (_target) {
        invocation.target = _target;
        [invocation invoke];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    // NSLog(@"%@", NSStringFromSelector(sel));
    return _target ? [_target methodSignatureForSelector:sel] : [super methodSignatureForSelector:sel];
}

@end
