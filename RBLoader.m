//
//  RBLoader.m
//
//  Created by mootoh on 6/4/08.
//  Copyright 2008 deadbeaf.org. All rights reserved.
//

#import "RBLoader.h"
#import <RubyCocoa/RubyCocoa.h>

@implementation RBLoader

+(void) load {
	if (RBBundleInit("qc_gainer.rb", self, nil)) {
      NSLog(@"RBLoader#load failed");
	}
}

@end
