//
//  CreekGnssAlgorithmManager.h
//  CreekGnssAlgorithm
//
//  Created by Codex on 2026/6/4.
//

#import <Foundation/Foundation.h>

#if __has_include("alg_gnss.h")
#import "alg_gnss.h"
#elif __has_include(<CreekGnssAlgorithm/alg_gnss.h>)
#import <CreekGnssAlgorithm/alg_gnss.h>
#else
#error "alg_gnss.h not found"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CreekGnssLocation : NSObject <NSCopying>

@property (nonatomic, assign) uint32_t utcTime;
@property (nonatomic, assign) uint8_t rmcLocationStatus;
@property (nonatomic, assign) int32_t rmcLatitude;
@property (nonatomic, assign) int32_t rmcLongitude;
@property (nonatomic, assign) uint8_t rmcNorthOrSouth;
@property (nonatomic, assign) uint8_t rmcEastOrWest;
@property (nonatomic, assign) float gsaPdop;
@property (nonatomic, assign) float hacc;
@property (nonatomic, assign) float rmcSpeed;
@property (nonatomic, assign) float rmcCog;

- (instancetype)initWithCStruct:(gnss_location_t)location;
- (gnss_location_t)toCStruct;

@end

@interface CreekGnssResult : NSObject <NSCopying>

@property (nonatomic, assign) int32_t latitude;
@property (nonatomic, assign) int32_t longitude;
@property (nonatomic, assign) uint32_t distanceCm;
@property (nonatomic, assign) uint32_t speedKmh;
@property (nonatomic, assign) uint32_t speedPerKm;
@property (nonatomic, assign) uint8_t gnssEnable;
@property (nonatomic, assign) uint8_t saveFlag;
@property (nonatomic, assign) uint8_t remainTime;
@property (nonatomic, assign) uint8_t locationRssi;

- (instancetype)initWithCStruct:(alg_gnss_result_t)result;
+ (instancetype)resultWithCStruct:(alg_gnss_result_t)result;

@end

@interface CreekGnssAlgorithmManager : NSObject

+ (void)initializeAlgorithmWithHaccLimit:(float)haccLimit;
+ (gnss_alg_version_t)algorithmVersion;
+ (alg_gnss_result_t)processLocationStruct:(gnss_location_t)location sportType:(uint8_t)sportType;
+ (CreekGnssResult *)processLocation:(CreekGnssLocation *)location sportType:(uint8_t)sportType;

@end

NS_ASSUME_NONNULL_END
