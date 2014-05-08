
#ifndef __{{_name_}}_H__
#define __{{_name_}}_H__

#import <Foundation/Foundation.h>

@interface {{_name_}} : NSObject <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) UITableView *tableView;

@end

#endif

