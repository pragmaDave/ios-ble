ios-ble
=======

Bluetooth Low Energy (BLE) - Xcode/iPhone project

Note: I'm pretty new to Xcode/Objective C programming so I hope this project is helpful and makes sense.

Anyway, there is a very cool Bluetooth Low Energy (BLE) device from RedBearLab.com that can connect to a microprocessor, such as the Arduino and allow communication between the Arduino and an iPhone or other BLE capable device. RedBearLab also offers an Objective C library which offers a great head start for iPhone development.

However, I (and apparently others) found it challenging to create a connection to the BLE object that would "survive" between changing view controllers.

My solution was to create a subclass of UIViewController called BLEViewController that creates and maintains a persistent BLE object. The BLEViewController then serves as a base class for any number of view controllers an app might require to send or receive data over a Bluetooth LE connection.

I hope folks find it useful and welcome any constructive criticisms.
