//
//  JKDetailViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/25/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDetailViewController.h"
#import "JKDeal.h"
#import "UIView+AutoLayout.h"

@interface JKDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
// 活动监控器属性
@property (nonatomic,weak) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *soldNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *anytimeRefuntableBtn;
@property (weak, nonatomic) IBOutlet UIButton *expiresRefuntableBtn;

@end

@implementation JKDetailViewController

- (UIActivityIndicatorView *)loadingView {
    if (_loadingView == nil) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.webView addSubview:loadingView];
        // 添加约束
        [loadingView autoCenterInSuperview];
        // 记录属性
        self.loadingView = loadingView;
    }
    return _loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 webView 的偏移量
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    // 开始转圈圈
    [self.loadingView startAnimating];
    // 隐藏
    self.webView.scrollView.hidden = YES;
    
    self.webView.backgroundColor = JKColor(100, 100, 100);
    
    // 视图加载完成后webView 加载的网页页面请求 URL 地址
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 设置当前控制器支持那些方向
- (NSUInteger)supportedInterfaceOrientations {
    // 只支持横屏方向
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 打印输出查看请求的URL地址
//    JKLog(@"%@ %@",self.deal.deal_id,request.URL);
    
    /**
     2-6390770 http://lite.m.dianping.com/rdodiINlO6 第一个加载的页面
     2-6390770 http://lite.m.dianping.com/group/deal/moreinfo/6390770 第二个加载的团购详情页面
     */
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    /**
     JS 执行的三句代码，在浏览器中已经测试
     document.getElementsByTagName('header')[0].remove();
     document.getElementsByClassName('cost-box')[0].remove();
     document.getElementsByClassName('buy-now')[0].remove();
     */
    
    // 截取 id
    NSString *ID = [self.deal.deal_id substringFromIndex:2];
    NSString *lastURL = webView.request.URL.absoluteString;
    if ([lastURL hasSuffix:ID]) {
        
        // 执行 JS 删除掉不需要的节点
        NSString *js = @"document.getElementsByTagName('header')[0].remove();"
        "document.getElementsByClassName('cost-box')[0].remove();"
        "document.getElementsByClassName('buy-now')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        // 停止动画
        [self.loadingView stopAnimating];
        // 显示 webView
        webView.scrollView.hidden = NO;
    } else { // 加载详情
        NSString *url = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@",ID];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}


@end
