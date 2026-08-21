#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PermissionHandlerPlugin.h"

FOUNDATION_EXPORT double permission_handler_appleVersionNumber;
FOUNDATION_EXPORT const unsigned char permission_handler_appleVersionString[];

