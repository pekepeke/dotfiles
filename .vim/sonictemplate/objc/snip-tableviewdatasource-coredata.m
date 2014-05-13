#import "{{_name_}}"

@interface {{_name_}}()
@end

@implementation {{_name_}}

- (instancetype) initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
		self.tableView = tableView;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
  // TODO
}

- (void)dealloc
{
	_fetchedResultsController = nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // static NSString *CellIdentifier = @"Cell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    static NSString *kCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}


#pragma mark - Table view delegate

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    // <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];

    // Pass the selected object to the new view controller.

    // Push the view controller.
    // [self.navigationController pushViewController:detailViewController animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// TODO
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//     if (editingStyle == UITableViewCellEditingStyleDelete) {
//         // The correct way to save (http://samwize.com/2014/03/29/how-to-save-using-magicalrecord/)
//         Poo *poo = [_fetchedResultsController objectAtIndexPath:indexPath];
//         [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//             Poo *localPoo = [poo inContext:localContext];
//             [localPoo deleteEntity];
//         }];
//     }
//     else if (editingStyle == UITableViewCellEditingStyleInsert) {
//         // Create a new entity and save
//     }
// }

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = _tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_tableView endUpdates];
}

#pragma mark - public methods
- (BOOL)performFetch:(NSError *)error
{
    [NSFetchedResultsController deleteCacheWithName:_cacheKey];

    [self.fetchedResultsController performFetch:&error];
    if (error) {
        return NO;
    }
    return YES;
}

- (BOOL)performFetch
{
    NSError *error = nil;
    [self performFetch:error];
    if (error) {
		// TODO
        return NO;
    }
    return YES;
}

#pragma mark - private methods
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

	// TODO
	// _cacheKey = @"PooCache";
    // NSFetchRequest *fetchRequest = [Poo requestAllSortedBy:@"pooedOn" ascending:NO];
    // [fetchRequest setFetchLimit:100];         // Let's say limit fetch to 100
    // [fetchRequest setFetchBatchSize:20];      // After 20 are faulted

    // NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext defaultContext] sectionNameKeyPath:nil cacheName:@"PooCache"];
    // _fetchedResultsController = theFetchedResultsController;
    // _fetchedResultsController.delegate = self;
    // return _fetchedResultsController;
    // return [Poo fetchAllSortedBy:@"pooedOn" ascending:NO withPredicate:nil groupBy:nil delegate:self];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
	// TODO
  // Poo *poo = [_fetchedResultsController objectAtIndexPath:indexPath];
  // Update cell with poo details
  // cell.textLabel.text = poo.title;
}
@end


