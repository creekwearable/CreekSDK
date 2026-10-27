//
//  CreekGnssAlgorithm.h
//  CreekGnssAlgorithm
//
//  Created by bean on 2026/6/4.
//

#import <Foundation/Foundation.h>

#if __has_include("alg_gnss.h")
#import "alg_gnss.h"
#elif __has_include(<CreekGnssAlgorithm/alg_gnss.h>)
#import <CreekGnssAlgorithm/alg_gnss.h>
#else
#error "alg_gnss.h not found"
#endif

#if __has_include("CreekGnssAlgorithmManager.h")
#import "CreekGnssAlgorithmManager.h"
#elif __has_include(<CreekGnssAlgorithm/CreekGnssAlgorithmManager.h>)
#import <CreekGnssAlgorithm/CreekGnssAlgorithmManager.h>
#else
#error "CreekGnssAlgorithmManager.h not found"
#endif
