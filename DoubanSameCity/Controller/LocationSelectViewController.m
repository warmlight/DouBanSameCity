//
//  LocationSelectViewController.m
//  DoubanSameCity
//
//  Created by yiban on 15/9/24.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import "LocationSelectViewController.h"
#import "MJRefresh.h"
#import "CityList.h"
#import "API.h"
#import "SameCityUtils.h"
#import "Toast.h"

#define LocationCount 20
@interface LocationSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UIGestureRecognizerDelegate>
{
    id tempdelegate;
}
@property (assign, nonatomic) BOOL hasNext;
@property (assign, nonatomic) BOOL searchCityhasNext;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (assign, nonatomic) int pageNum;
@property (assign, nonatomic) int searchCityPageNum;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchCityArray;

@end

@implementation LocationSelectViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __block __weak typeof(self) weakSelf = self;
    self.locationTable.header.state = MJRefreshHeaderStateRefreshing;
    dispatch_queue_t queueToDown =  dispatch_queue_create("UploadQueue", NULL);
    dispatch_async(queueToDown, ^{
        [weakSelf getCityList];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf afterRefresh];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchCityArray = [[NSMutableArray alloc] init];
    CGRect locationTableRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.locationTable = [[UITableView alloc] initWithFrame:locationTableRect];
    [self.locationTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.locationTable.dataSource = self;
    self.locationTable.delegate = self;
    [self.view addSubview:self.locationTable];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.delegate = self;
    self.locationTable.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;

    
    
    //table下拉刷新
    //    [self.locationTable addLegendHeaderWithRefreshingBlock:^{
    //        dispatch_queue_t queueToDown =  dispatch_queue_create("UploadQueue", NULL);
    //        dispatch_async(queueToDown, ^{
    //            [weakSelf getCityList];
    //            dispatch_sync(dispatch_get_main_queue(), ^{
    //                [weakSelf afterRefresh];
    //            });
    //        });
    //    }];
    __block __weak typeof(self) weakSelf = self;
    
    
    //table上拉刷新
    [self.locationTable addLegendFooterWithRefreshingBlock:^{
        if (weakSelf.searchController.active) {
            if (weakSelf.searchCityhasNext) {
                [weakSelf getMoreSearchCity];
            } else {
                [weakSelf afterRefresh];
            }
            return;
        } else {
            dispatch_queue_t queueToUp =  dispatch_queue_create("UploadMoreQueue", NULL);
            dispatch_async(queueToUp, ^{
                [weakSelf getMoreCity];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf afterRefresh];
                });
            });
            
        }
    }];
}

#pragma mark -citylist
- (void)getCityList {
    self.pageNum = 0;
    CityList *cityList = [API get_cityList:[NSNumber numberWithInt:20] start:[NSNumber numberWithInt:0]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:cityList.locs];
    if (self.cityArray.count == 10) {
        [self.cityArray removeAllObjects];
    }
    self.cityArray = [SameCityUtils get_cityArray:array];
    if (array.count == LocationCount) {
        self.hasNext = YES;
    } else {
        self.hasNext = NO;
    }
    self.pageNum ++;
}

- (void)getMoreCity {
    int starPage = self.pageNum *LocationCount;
    CityList *cityList = [API get_cityList:[NSNumber numberWithInt:20] start:[NSNumber numberWithInt:LocationCount *self.pageNum]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[cityList.locs mutableCopy]];
    NSMutableArray *tempArray = [SameCityUtils get_cityArray:array];
    if (tempArray.count == LocationCount) {
        self.hasNext = YES;
        [self.cityArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(starPage, tempArray.count)]];
        self.pageNum ++;
    } else {
        self.hasNext = NO;
    }
}

- (void)afterRefresh{
    [self.locationTable reloadData];
    if ([self.locationTable.header isRefreshing]) {
        [self.locationTable.header endRefreshing];
    }else if ([self.locationTable.footer isRefreshing]){
        [self.locationTable.footer endRefreshing];
    }
}

#pragma mark -tableview delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchCityArray.count;
    } else {
        return  self.cityArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [self.locationTable dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if (self.searchController.active) {
        City *city = self.searchCityArray[indexPath.row];
        cell.textLabel.text = city.name;
    }else{
        City *city = self.cityArray[indexPath.row];
        cell.textLabel.text = city.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *locName = @"";
    if (self.searchController.active) {
        City *city = self.searchCityArray[indexPath.row];
        locName = city.name;
    }else {
        City *city = self.cityArray[indexPath.row];
        locName = city.name;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectLocation" object:locName];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -UISearchControllerDelegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.searchCityPageNum = 0;
    [self.searchCityArray removeAllObjects];
    [self getMoreSearchCity];
    [self.locationTable reloadData];
}

- (void)getMoreSearchCity {
    int start = LocationCount *_searchCityPageNum;
    CityList *citylist = [API getSearchCity:[self.searchController.searchBar text] cout:[NSNumber numberWithInt:LocationCount] start:[NSNumber numberWithInt:0]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[citylist.locs mutableCopy]];
    NSMutableArray *tempArray = [SameCityUtils get_cityArray:array];
    [self.searchCityArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start, tempArray.count)]];
    
    if (tempArray.count == LocationCount) {
        self.searchCityhasNext = YES;
        self.searchCityPageNum ++;
    } else {
        self.searchCityhasNext = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
