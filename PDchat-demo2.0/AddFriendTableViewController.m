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
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "pinyin.h"
#import "ChineseString.h"
@interface AddFriendTableViewController ()<UISearchBarDelegate>{
    // 保存搜索结果数据的NSArray对象。
    NSMutableArray* searchData;
    // 是否搜索变量
    bool isSearch;
    NSArray *searchType;
}

//搜索栏
@property (weak, nonatomic) IBOutlet UISearchBar *searcrBar;
@property NSMutableArray *sortedDoctor;
//数据字典
@property (nonatomic, strong)NSMutableDictionary *dic;

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong)NSMutableArray *doctors;
@property (nonatomic, strong)NSMutableArray *fiends;
@end

@implementation AddFriendTableViewController

- (NSMutableArray *)fiends{
    if (!_fiends) {
        _fiends=[NSMutableArray array];
    }
    return _fiends;
}
- (NSMutableArray *)doctors{
    if (!_doctors) {
        _doctors=[NSMutableArray array];
    }
    return _doctors;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.searcrBar.delegate=self;
    self.searcrBar.showsCancelButton=YES;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addDoctorFromServer)];
    
    [self.tableView.mj_header beginRefreshing];
 
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

- (void)sortdoctor:(NSMutableArray *)doc{
    //step1：初始化 读入数组
    //step2: 获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for (int i=0; i<doc.count; i++) {
        ChineseString*chineseString=[[ChineseString alloc]init];
        doctor *d=[doc objectAtIndex:i];
        chineseString.string=[NSString stringWithString:d.username];
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    //Step3输出
    NSLog(@"\n\n\n按照拼音首字母后的NSString数组");
    for(int i=0;i<[chineseStringsArray count];i++){
        ChineseString *chineseString=[chineseStringsArray objectAtIndex:i];
        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    }
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
    }
    
    //Step4输出
    NSLog(@"\n\n\n最终结果:");
    for(int i=0;i<[result count];i++){
        NSLog(@"%@",[result objectAtIndex:i]);
    }
    
    //程序结束
    self.sortedDoctor=[NSMutableArray array];
    for (NSString *sortedname in result) {
        for (doctor *d in doc) {
            if (d.username==sortedname) {
                [self.sortedDoctor addObject:d];
            }
        }
    }
    
    
    
}



- (void)addDoctorFromServer{
    //网络请求获取用户名 patient_getInfo.php get请求
    [self.doctors removeAllObjects];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/doctor/getAllInfo.php"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //如果不是好友，就加入到显示列表中
        
        NSLog(@"线程=%@",[NSThread currentThread]);
        self.dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (id obj in self.dic) {
            
            doctor *d=[[doctor alloc]initWithUsername:obj[@"username"]
                                               andAge:obj[@"age"]
                                              andType:obj[@"type"]
                                            andGender:obj[@"gender"]
                                       andPhonenumber:obj[@"phonenumber"]
                                            andDetail:obj[@"detail"]
                                          andImageurl:obj[@"imageurl"]
                                          andHospital:obj[@"hospital"]
                       ];
            
            [self.doctors addObject:d];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addnameFromLoacl];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            
        });
    }];
    
    [task resume];
    
}


- (void)addnameFromLoacl{
    for (doctor *already in self.DoctorList) {
        NSString *username=already.username;
        NSLog(@"username=%@",username);
        for (doctor *d in self.doctors) {
            NSString *name=d.username;
            NSLog(@"name=%@",name);
            if ([name isEqualToString:username]) {
                [self.fiends addObject:d];
            }
        }
    }
    
    for (doctor *d in self.fiends) {
        NSLog(@"self.friends=%@",self.fiends);
        if ([self.doctors containsObject:d]) {
            [self.doctors removeObject:d];
        }
    }
    [self sortdoctor:self.doctors];
    
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
        return self.doctors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *id=@"addID";
    static const int imgTag = 111;
    static const int labelTag = 222;
    static const int messageTag = 333;
    UIImageView *imageView = nil;
    UILabel *textLabel = nil;
    UILabel *messageLabel=nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    
    
    for (UIView *v in cell.contentView.subviews) {
        
        if (v.tag == imgTag) {
            imageView = v;
        }
        
        if (v.tag == labelTag) {
            textLabel = v;
        }
        if (v.tag==messageTag) {
            messageLabel=v;
        }
    }
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        imageView.image=[UIImage imageNamed:@"chatListCellHead"];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds  = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = imgTag;
        [cell.contentView addSubview:imageView];
    }
    
    if (textLabel == nil) {
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 30)];
        [textLabel setFont:[UIFont systemFontOfSize:22]];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = labelTag;
        [cell.contentView addSubview:textLabel];
    }
    
    if (messageLabel == nil) {
        CGFloat messageWidth = [UIScreen mainScreen].bounds.size.width - 130;
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, messageWidth, 20)];
        [messageLabel  setFont:[UIFont systemFontOfSize:16]];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.text = @"作为医生我觉得你没必要抢救了";
        messageLabel.tag = messageTag;
        [cell.contentView addSubview:messageLabel];
    }

    
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds  = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];
    
    [textLabel setFont:[UIFont systemFontOfSize:16]];
    textLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:textLabel];
    if(isSearch)
    {
        // 使用searchData作为表格显示的数据
        doctor *p=searchData[indexPath.row];
        textLabel.text = p.username;
        cell.detailTextLabel.text=p.type;
        NSString *imageurl=p.imageurl;
        NSURL *url=[NSURL URLWithString:imageurl];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        messageLabel.text=p.hospital;
    }else if(self.doctors.count>0){
        doctor *p=self.sortedDoctor[indexPath.row];
        textLabel.text=p.username;
        cell.detailTextLabel.text=p.type;
        NSString *imageurl=p.imageurl;
        NSURL *url=[NSURL URLWithString:imageurl];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        messageLabel.text=p.hospital;
    }
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_doctors.count == 0) {
        return;
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DoctorDetailViewController *docVC=(DoctorDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addDetail"];
    doctor *d=self.doctors[indexPath.row];
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
    [self.sortedDoctor enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        doctor *p=obj;
        if ([p.username.uppercaseString containsString:keyWord.uppercaseString]||[p.type containsString:keyWord]) {
            [searchData addObject:p];
        }
    }];
//    [self sortdoctor:searchData];
    //刷新表格
    [self.tableView reloadData];
}

@end
