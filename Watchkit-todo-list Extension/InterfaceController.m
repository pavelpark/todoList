//
//  InterfaceController.m
//  Watchkit-todo-list Extension
//
//  Created by Pavel Parkhomey on 5/9/17.
//  Copyright © 2017 Pavel Parkhomey. All rights reserved.
//

#import "InterfaceController.h"

#import "TodoRowController.h"

#import "toDo.h"

@import WatchConnectivity;

@interface InterfaceController () <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;

@property(strong, nonatomic) NSArray<toDo *> *allTodos;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

-(void)setupTable{
    [self.table setNumberOfRows:self.allTodos.count withRowType:@"TodoRowController"];
    
    for (NSInteger i = 0; i < self.allTodos.count; i++) {
        
        TodoRowController *rowController = [self.table rowControllerAtIndex:i];
        
        [rowController.titleLabel setText:self.allTodos[i].title];
        [rowController.contentLabel setText:self.allTodos[i].content];
    }
}

//-(NSArray<toDo *> *)allTodos{
//    toDo *firstTodo = [[toDo alloc]init];
//    firstTodo.title = @"First Todo";
//    firstTodo.content = @"This is a todo.";
//    
//    toDo *secondTodo = [[toDo alloc]init];
//    secondTodo.title = @"Second Todo";
//    secondTodo.content = @"This is another amazing todo.";
//    
//    toDo *thirdTodo = [[toDo alloc]init];
//    thirdTodo.title = @"Third Todo";
//    thirdTodo.content = @"This is another another todo.";
//    
//    return @[firstTodo, secondTodo, thirdTodo];
//}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
    //message parameter is where you want to handle the iOS app new toDo data to save to Firebase.
    [[WCSession defaultSession] sendMessage:@{} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
    
        NSArray *todosDictionaries = replyMessage[@"todos"];
        
        
        NSMutableArray *allTodos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *todoObject in todosDictionaries) {
            
            toDo *newTodo = [[toDo alloc]init];
            newTodo.title = todoObject[@"title"];
            newTodo.content = todoObject[@"content"];
            
            [allTodos addObject:newTodo];
        }
        
        self.allTodos = allTodos.copy;
        [self setupTable];
        
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}







@end



