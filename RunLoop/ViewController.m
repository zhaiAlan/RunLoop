//
//  ViewController.m
//  RunLoop
//
//  Created by Alan on 2019/3/7.
//  Copyright © 2019 zhaixingzhi. All rights reserved.
//

#import "ViewController.h"
#import "ZXThread.h"

@interface ViewController ()
@property (nonatomic, assign) BOOL finish;
@property (nonatomic, copy) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _finish = NO;
//    [self demo1];
//    [self demo2];
//    [self demoSource];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)demoSource{
     _timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    dispatch_resume(_timer);
}
- (void)run{
    NSLog(@"run方法跑在这个线程:%@--",[NSThread currentThread]);
}
/**
 说打印那些文字，考虑是否能够一直循环执行run方法，如果能，怎么停止；
 */
- (void)demo1{
    
    ZXThread *thread = [[ZXThread alloc]initWithBlock:^{
        NSLog(@"进入线程");
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        NSLog(@"离开线程");
    }];
    
    [thread start];
}
- (void)demo2{
    
    ZXThread *thread = [[ZXThread alloc]initWithBlock:^{
        NSLog(@"进入线程");
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop]run];
        NSLog(@"离开线程");
    }];
    [thread start];
}

/**
 打印那些，线程通讯
 */
- (void)demo4{
    
    ZXThread *thread = [[ZXThread alloc]initWithBlock:^{
        NSLog(@"进入线程");
    }];
    [thread start];
    [self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:NO];
}
- (void)demo5{
    
    ZXThread *thread = [[ZXThread alloc]initWithBlock:^{
        NSLog(@"进入线程");
    }];
    [self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:NO];
    [thread start];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.finish = YES;
}

- (void)demo3{
    typeof(self) __weak weakSelf = self;
    
    ZXThread *thread = [[ZXThread alloc]initWithBlock:^{
        NSLog(@"进入线程");
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        if (!weakSelf.finish) {
            [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.0001]];
        }
        NSLog(@"离开线程");
    }];
    [thread start];
}

- (void)demo6{
    typeof(self) __weak weakSelf = self;
    ZXThread *thread = [[ZXThread alloc]initWithBlock:^{
        NSLog(@"进入线程");
        if (!weakSelf.finish) {
            [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.0001]];
        }
    }];
    [self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:NO];
    [thread start];
}


@end
