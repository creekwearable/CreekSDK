#import <Flutter/Flutter.h>

@interface JsonParser : NSObject

+(NSString *) parseIatResult: (NSString *)json;

@end
