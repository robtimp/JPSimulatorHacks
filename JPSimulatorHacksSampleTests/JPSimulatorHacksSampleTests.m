//
//  JPSimulatorHacksSampleTests.m
//  JPSimulatorHacksSampleTests
//
//  Created by Johannes Plunien on 04/06/14.
//  Copyright (C) 2014 Johannes Plunien
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <JPSimulatorHacks/JPSimulatorHacks.h>
#import <XCTest/XCTest.h>

#define ASYNC_TIMEOUT 2.0f

@interface JPSimulatorHacksSampleTests : XCTestCase

@end

@implementation JPSimulatorHacksSampleTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToAddressBook];
    [JPSimulatorHacks grantAccessToPhotos];
}

- (void)testAddressBookAccess
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        XCTAssertTrue(granted);
        CFRunLoopStop(CFRunLoopGetMain());
    });
    XCTAssertEqual(kCFRunLoopRunStopped, CFRunLoopRunInMode(kCFRunLoopDefaultMode, ASYNC_TIMEOUT, NO));
}

- (void)testPhotosAccess
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        CFRunLoopStop(CFRunLoopGetMain());
    } failureBlock:^(NSError *error) {
        XCTFail();
    }];
    XCTAssertEqual(kCFRunLoopRunStopped, CFRunLoopRunInMode(kCFRunLoopDefaultMode, ASYNC_TIMEOUT, NO));
}

@end