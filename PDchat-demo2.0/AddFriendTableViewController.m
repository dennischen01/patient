//
//  AddFriendTableViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/9.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "DoctorDetailViewController.h"
#import "doctor.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

#define imgTag 100
#define labelTag 101

@interface AddFriendTableViewController ()<UISearchBarDelegate>{
    // 保存搜索结果数据的NSArray对象。
    NSMutableArray* searchData;
    // 是否搜索变量
    bool isSearch;
    NSArray *searchType;
}
//图片地址5
@property (nonatomic, strong)NSMutableArray *images;
//手机号码6
@property (nonatomic, strong)NSMutableArray *phonenumbers;
//搜索栏
@property (weak, nonatomic) IBOutlet UISearchBar *searcrBar;
//用户名3
@property (nonatomic, strong)NSMutableArray *username;
//数据字典
@property (nonatomic, strong)NSMutableDictionary *dic;
//所属科室1
@property (nonatomic, strong)NSMutableArray *types;
//所有医生2
@property (nonatomic, strong)NSMutableArray *allName;
//对象数组5
@property (nonatomic, strong)NSMutableArray *datasourse;
//医院7
@property (nonatomic, strong)NSMutableArray *hospitals;
//详情8
@property (nonatomic, strong)NSMutableArray *details;
//年龄9
@property (nonatomic, strong)NSMutableArray *ages;
//性别10
@property (nonatomic, strong)NSMutableArray *genders;
@end

@implementation AddFriendTableViewController

- (NSMutableArray *)types{
    if (!_types) {
        _types=[NSMutableArray array];
    }
    return _types;
}

- (NSMutableArray *)allName{
    if (!_allName) {
        _allName=[NSMutableArray array];
    }
    return _allName;
}

- (NSMutableArray *)username{
    if (!_username) {
        _username=[NSMutableArray array];
        
    }
    return _username;
}

- (NSMutableArray *)DoctorList{
    if (!_DoctorList) {
        _DoctorList=[NSMutableArray array];
        
    }
    return _DoctorList;
}

- (NSMutableArray *)datasourse{
    if (!_datasourse) {
        _datasourse=[NSMutableArray array];
    }
    return _datasourse;
}

- (NSMutableArray *)images{
    if (!_images) {
        _images=[NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)phonenumbers{
    if (!_phonenumbers) {
        _phonenumbers=[NSMutableArray array];
    }
    return _phonenumbers;
}

- (NSMutableArray *)hospitals{
    if (!_hospitals) {
        _hospitals=[NSMutableArray array];
    }
    return _hospitals;
}

- (NSMutableArray *)details{
    if (!_details) {
        _details=[NSMutableArray array];
    }
    return _details;
}

- (NSMutableArray *)ages{
    if (!_ages) {
        _ages=[NSMutableArray array];
    }
    return _ages;
}

- (NSMutableArray *)genders{
    if (!_genders) {
        _genders=[NSMutableArray array];
    }
    return _genders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searcrBar.delegate=self;
    self.searcrBar.showsCancelButton=YES;
    NSLog(@"doctor list=%@",self.DoctorList);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self addname];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setTableFooterView:self.tableView];
}
- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

- (void)addname{
    //网络请求获取用户名 doctor_getInfo.php get请求
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/doctor/getAllInfo.php"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"%@",self.username);
        
        //如果不是好友，就加入到显示列表中
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (id obj in self.dic) {

                doctor *d=[[doctor alloc]initWithUsername:obj[@"username"]
                                                   andAge:obj[@"age"]
                                                  andType:obj[@"type"]
                                                andGender:obj[@"gender"]
                                           andPhonenumber:obj[@"phonenumber"]
                                                andDetail:obj[@"detail"]
                                              andImageurl:obj[@"imageurl"]
                                              andHospital:obj[@"hospital"]];
                [self.datasourse addObject:d];
            }
            
            
            for (doctor *d in self.datasourse) {
                if (![self.DoctorList containsObject:d.username]) {
                    [self.username addObject:d];
                }
            }
            
            [self.tableView reloadData];
            
        });
        
        
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 如果处于搜索状态
    if(isSearch)
    {
        // 使用searchData作为表格显示的数据
        return searchData.count;
    }else
        return self.username.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *id=@"addID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    UIImageView *imageView;
    UILabel *textLabel;
    
    for (UIView *v in cell.contentView.subviews) {
        if (v.tag == imgTag) {
            imageView = v;
        }
        
        if (v.tag == labelTag) {
            textLabel = v;
        }
    }
    
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds  = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }

    if (!textLabel) {
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 60)];
        [textLabel setFont:[UIFont systemFontOfSize:16]];
        textLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textLabel];
    }
    
    if(isSearch)
    {
        // 使用searchData作为表格显示的数据
         doctor *d=searchData[indexPath.row];
        textLabel.text = d.username;
        cell.detailTextLabel.text=d.type;
        NSString *imageurl=d.imageurl;
        NSURL *url=[NSURL URLWithString:imageurl];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    }else if(self.datasourse.count>0){
        doctor *d=self.username[indexPath.row];
        textLabel.text=d.username;
        cell.detailTextLabel.text=d.type;
        NSString *imageurl=d.imageurl;
        NSURL *url=[NSURL URLWithString:imageurl];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    }
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_username.count == 0) {
        return;
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DoctorDetailViewController *docVC=(DoctorDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addDetail"];
    doctor *d=self.username[indexPath.row];
    docVC.doc=d;
    [self.navigationController pushViewController:docVC animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - UISearchBarDelegate 

// UISearchBarDelegate定义的方法，用户单击取消按钮时激发该方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    isSearch = NO;
    [self.tableView reloadData];
}

// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
    if(searchText.length>0){
        [self searchDataWithKeyWord:searchText];
    }else{
        isSearch=NO;
        [self.tableView reloadData];
    }
}

// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    [self searchDataWithKeyWord:searchBar.text];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}

//- (void) filterBySubstring:(NSString*) subStr
//{
//    NSLog(@"----filterBySubstring------");
//    // 设置为搜索状态
//    isSearch = YES;
//    // 定义搜索谓词
//    NSPredicate* pred = [NSPredicate predicateWithFormat:
//                         @"SELF CONTAINS[c] %@" , subStr];
//    // 使用谓词过滤NSArray
////    searchData = [self.username filteredArrayUsingPredicate:pred];
//    searchType=[self.type filteredArrayUsingPredicate:pred];
//    // 让表格控件重新加载数据
//    [self.tableView reloadData];
//}

#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord{
    isSearch=YES;
    searchData=[NSMutableArray array];
    [self.username enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        doctor *d=obj;
        if ([d.username.uppercaseString containsString:keyWord.uppercaseString]||[d.type containsString:keyWord]) {
            [searchData addObject:d];
        }
    }];
    //刷新表格
    [self.tableView reloadData];
}

@end
