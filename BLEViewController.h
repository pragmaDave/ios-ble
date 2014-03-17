//
//  BLEViewController.h
//  DL_RemoteBLE_02
//
//  Created by Dave Lichtenstein on 3/16/14.
//  Copyright (c) 2014 Dave Lichtenstein. All rights reserved.
//
// Base class view controller that keeps a persistent bluetooth low energy (BLE) object.
// Provides methods for scanning for peripherals, connecting, reading and writing data, etc.
// Uses the BLE library from RedBearLab.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface BLEViewController : UIViewController <BLEDelegate>
{
     //IBOutlet UILabel *statusLabel;
}

+ (BLE*) theBLEObject;

- (void) scanForPeripherals;

@end
