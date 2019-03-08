//
//  main.m
//  RunLoop
//
//  Created by Alan on 2019/3/7.
//  Copyright © 2019 zhaixingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"来了");
        //UIApplicationMain 死循环
        int a = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"come here");
        return a;
    
    }
}
