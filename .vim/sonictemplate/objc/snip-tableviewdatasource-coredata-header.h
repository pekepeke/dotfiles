#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface {{_name_}} : NSObject <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) UITableView *tableView;

@end

