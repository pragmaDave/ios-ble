//
//  BLEViewController.m
//  DL_RemoteBLE_02
//
//  Created by Dave Lichtenstein on 3/16/14.
//  Copyright (c) 2014 Dave Lichtenstein. All rights reserved.
//

#import "BLEViewController.h"

static BLE* ble;
static UILabel *statusLabel;
static NSString* connectionStatus = @"Not connected!";


@interface BLEViewController ()

@end

@implementation BLEViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(ble==nil)
    {
        // Create our Bluetooth Low Energy object
        //
        ble = [[BLE alloc] init];
        [ble controlSetup];
        ble.delegate = self;
    }
    
    
        // Create a toolbar at the bottom of the screen to show status text, etc.
        //
    
        // get screen size
        //
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
    
        CGFloat toolbarHeight = 50.0;
        CGFloat labelHeight = 50.0;
    
    if(statusLabel==nil) // only create once
    {
        // create our status label object
        //
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, screenHeight-toolbarHeight-labelHeight, screenWidth, labelHeight)];
    
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = [UIColor blackColor];
        statusLabel.font = [UIFont boldSystemFontOfSize:15];
    
        statusLabel.text = @"Connection Status:";
    }
    
    
    // create a toolbar
    //
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight-toolbarHeight,screenWidth,toolbarHeight)];
    
    toolbar.tintColor = [UIColor blackColor];

    /*UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = @"Status:";
    UIBarButtonItem *labeltext = [[UIBarButtonItem alloc] initWithCustomView:label];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:statusLabel, nil];
    toolbar.items = items;
    */
    
    [self.view addSubview:statusLabel];
    [self.view addSubview:toolbar];
    
    
    // Update our status label
        statusLabel.text = connectionStatus;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------
// methods
/////////////////////////////////////////////////////////
+ (BLE*) theBLEObject
{
    return ble;
}

-(void) connectionTimer:(NSTimer *)timer
{
    
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    NSLog(@"connectionTimer"); // diag
}

// We call this when the view loads to try to connect to our bluetooth perepheral
//
- (void) scanForPeripherals
{
    if (ble.activePeripheral)
        if(ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            statusLabel.text = @"Disconnectng from peripheral...";
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    
    NSLog(@"scanning...");
    statusLabel.text = @"Scanning for peripherals...";
    
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    //[indConnecting startAnimating];
}


///////////////////////////////////////////////////////////
#pragma mark - BLE delegate
///////////////////////////////////////////////////////////

NSTimer *rssiTimer;

// When Connected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected");
    statusLabel.text = @"Connected!";
    connectionStatus = @"Connected!";
    
    
    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}


// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    // Append the rssi value to our status label
    //
    NSString *temp = [NSString stringWithFormat:@"%@ (%@)", connectionStatus, rssi];
    
    statusLabel.text = temp;
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [ble readRSSI];
}



// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSLog(@"Received data of Length: %d", length);
    
}

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");
    connectionStatus = @"Disconnected!";
    statusLabel.text = @"Disconnected!";
    
    
    
    
    
    [rssiTimer invalidate];
}

@end
