//
//  ViewController.m
//  获取验证码
//
//  Created by apple on 15/2/10.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "ViewController.h"
#import "HttpDownLoadBlock.h"
#import "ZCControl.h"
#import "MyMD5.h"

//宏定义屏幕的宽度和高度
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
//Color配色
//#define ThemeColor kUIColorFromRGB(0xc10808)//主题颜色
#define VCBg kUIColorFromRGB(0xeeeeee)//页面背景颜色
#define mLightGrey kUIColorFromRGB(0xa0a0a0)//登录注册
#define mDarkGrey kUIColorFromRGB(0x535353)//欢迎
#define mBorderGrey kUIColorFromRGB(0xc9c9c9)//边框灰色
#define mBorderRed kUIColorFromRGB(0xc10808)//边框红色
//Color配色
#define VCBg kUIColorFromRGB(0xeeeeee)//页面背景颜色
#define mLightGrey kUIColorFromRGB(0xa0a0a0)//登录注册
#define mDarkGrey kUIColorFromRGB(0x535353)//欢迎
#define mBorderGrey kUIColorFromRGB(0xc9c9c9)//边框灰色
#define mBorderRed kUIColorFromRGB(0xc10808)//边框红色

//短信接口
#define SMS @"http://test.9cmall.com/index.php/Home/Sms"
//接口
#define API_URL @"http://test.9cmall.com/Public/Upload/123/api_9capp.php"

@interface ViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    
    UITextField *txtfPhone;
    UITextField *txtfCode;
    UITextField *txtfPwd;
    UITextField *txtfAgainPwd;
    
    UIButton *btnReqCode;
    UIButton *btnReg;
    
    NSTimer *timer;
    NSInteger flag;
    
    NSString *strCode;
    NSString *codePhone;
    NSString *Action;
    NSString *Code;
    
    NSString *uuid;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 初始化界面
-(void)initView
{
    flag = 60;
    
    self.scroll= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scroll.delegate = self;
    [self.view addSubview:self.scroll];
    
    
    UIImageView *imgLogoBg = [ZCControl createImageViewWithFrame:CGRectMake(0,0, WIDTH, 115) ImageName:@"c_w"];
    [self.scroll addSubview:imgLogoBg];
    
    UIImageView *imgLogo = [ZCControl createImageViewWithFrame:CGRectMake((WIDTH-60)/2,15, 60, 60) ImageName:@"m_reglogo"];
    [self.scroll addSubview:imgLogo];
    
    UIImageView *imgLine = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imgLine];
    
    //欢迎语
    UILabel *labTxt =[ZCControl createLabelWithFrame:CGRectMake((WIDTH-80)/2, 60+15+10, 88, 24) Font:14 Text:@"欢迎来到9橙商城"];
    labTxt.textColor = [UIColor redColor];
    [self.scroll addSubview:labTxt];
    
    //logo背景底线
    UIImageView *imglogoLine = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imglogoLine];
    
    //输入框上线
    UIImageView *imgLineU = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imgLineU];
    
    //手机号背景
    UIImageView *imgTxtfbgU = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5,WIDTH, 40) ImageName:@"c_w"];
    [self.scroll addSubview:imgTxtfbgU];
    
    //手机号logo
    UIImageView *imgPhologo = [ZCControl createImageViewWithFrame:CGRectMake(20,115+0.5+20+0.5+5,30, 30) ImageName:@"m_phone"];
    [self.scroll addSubview:imgPhologo];
    
    //手机输入框
    txtfPhone =[ZCControl createTextFieldWithFrame:CGRectMake(20+30+5,115+0.5+20+0.5+5,WIDTH-20, 30) placeholder:@"请输入手机号" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    txtfPhone.delegate = self;
    txtfPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.scroll addSubview:txtfPhone];
    
    //输入框中线
    UIImageView *imgLineC = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imgLineC];
    
    //验证码背景
    UIImageView *imgTxtfbgC = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40+0.5,WIDTH, 40) ImageName:@"c_w"];
    [self.scroll addSubview:imgTxtfbgC];
    
    //验证码logo
    UIImageView *imgCodelogo = [ZCControl createImageViewWithFrame:CGRectMake(20,115+0.5+20+0.5+40+0.5+5,30, 30) ImageName:@"m_code"];
    [self.scroll addSubview:imgCodelogo];
    
    //验证码入框
    txtfCode =[ZCControl createTextFieldWithFrame:CGRectMake(20+30+5,115+0.5+20+0.5+40+0.5+5,WIDTH-20-40, 30) placeholder:@"请输入验证码" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    txtfCode.delegate = self;
    txtfCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfCode.keyboardType = UIKeyboardTypeNumberPad;
    [self.scroll addSubview:txtfCode];
    
    btnReqCode =[ZCControl createButtonWithFrame:CGRectMake(WIDTH-20-100,115+0.5+20+0.5+40+0.5+8,100, 24) ImageName:nil Target:0 Action:@selector(btnGetCode) Title:@"获取验证码"];
    btnReqCode.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    btnReqCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //设置字体颜色
    [btnReqCode setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.scroll addSubview:btnReqCode];
    
    //输入框中线
    UIImageView *imgLineCC = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40+0.5+40,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imgLineCC];
    
    //密码背景
    UIImageView *imgTxtfbgP = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40+0.5+40+0.5,WIDTH, 40) ImageName:@"c_w"];
    [self.scroll addSubview:imgTxtfbgP];
    
    //密码logo
    UIImageView *imgPwdlogo = [ZCControl createImageViewWithFrame:CGRectMake(20,115+0.5+20+0.5+40+0.5+40+0.5+5,30, 30) ImageName:@"m_pwd"];
    [self.scroll addSubview:imgPwdlogo];
    
    //密码输入框
    txtfPwd =[ZCControl createTextFieldWithFrame:CGRectMake(20+30+5,115+0.5+20+0.5+40+0.5+40+0.5+5,WIDTH-20, 30) placeholder:@"请输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:14];
    txtfPwd.delegate = self;
    txtfPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.scroll addSubview:txtfPwd];
    
    //输入框下线
    UIImageView *imgLineP = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40+0.5+40+0.5+40,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imgLineP];
    
    //二次密码背景
    UIImageView *imgTxtfbgAP = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40+0.5+40+0.5+40+0.5,WIDTH, 40) ImageName:@"c_w"];
    [self.scroll addSubview:imgTxtfbgAP];
    
    //二次密码logo
    UIImageView *imgAgainPwdlogo = [ZCControl createImageViewWithFrame:CGRectMake(20,115+0.5+20+0.5+40+0.5+40+0.5+40+0.5+5,30, 30) ImageName:@"m_pwd"];
    [self.scroll addSubview:imgAgainPwdlogo];
    
    //密码输入框
    txtfAgainPwd =[ZCControl createTextFieldWithFrame:CGRectMake(20+30+5,115+0.5+20+0.5+40+0.5+40+0.5+40+0.5+5,WIDTH-20, 30) placeholder:@"请再次输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:14];
    txtfAgainPwd.delegate = self;
    txtfAgainPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.scroll addSubview:txtfAgainPwd];
    
    //输入框下线
    UIImageView *imgLineD = [ZCControl createImageViewWithFrame:CGRectMake(0,115+0.5+20+0.5+40+0.5+40+0.5+40+0.5+40,WIDTH, 0.5) ImageName:@"c_g"];
    [self.scroll addSubview:imgLineD];
    
    //注册
    btnReg =[ZCControl createButtonWithFrame:CGRectMake((WIDTH-280)/2, 115+0.5+20+0.5+40+0.5+40+0.5+40+0.5+40+35, 280, 35) ImageName:@"m_login_n" Target:0 Action:@selector(RegApp) Title:@"注  册"];
    btnReg.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    //设置字体颜色
    [btnReg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scroll addSubview:btnReg];
    
}

#pragma mark - 获取当前时间
-(NSString*) getDate
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    return [dateformatter stringFromDate:senddate];
}


#pragma mark - 注册
-(void)RegApp
{
    if([[self isTrue] isEqualToString:@""]){
        
        
        
        NSString *phone = txtfPhone.text;
        NSString * pwd = [MyMD5 md5:txtfPwd.text];
        NSString *createTime = [self getDate];
        
        NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
        [myParams setObject:uuid forKey:@"id"];
        [myParams setObject:phone forKey:@"phone"];
        [myParams setObject:pwd forKey:@"passwd"];
        [myParams setObject:createTime forKey:@"create_time"];
        
        NSString *strJson = [self toJSONData:myParams];
        NSString *strMyJson = [NSString stringWithFormat:@"{\"tag\":\"registerUser\",\"data\":\"%@\"}",strJson];
        
        NSString * str = [NSString stringWithFormat:@"%@?json=%@",API_URL,strMyJson];
        NSLog(@"注册:%@",str);
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        HttpDownLoadBlock * request = [[HttpDownLoadBlock alloc]initWithStrUrl:str Time:0 Block:^(BOOL isFinish, HttpDownLoadBlock * http) {
            if (isFinish) {
                
                
                if(http.dataStr!=nil)
                {
                    if([http.dataStr isEqualToString:@"0"])
                    {
                        [self showAlert:@"成功"];
                    }
                    else if([http.dataStr isEqualToString:@"1"])
                    {
                        [self showAlert:@"输入有误哦~不要灰心，重新试一下吧！"];
                    }
                    else if([http.dataStr isEqualToString:@"2"])
                    {
                        [self showAlert:@"您输入的手机号已经存在了呢，可以直接登录或者选择其他的手机号另行注册~"];
                    }
                    else
                    {
                        [self showAlert:@"咦~系统出了点小问题，您等下再试试吧！"];
                    }
                }
            }
        }];
        request = nil;
    }
    else{
        [self showAlert:[self isTrue]];
    }
    
}
#pragma mark - 将字典或者数组转化为JSON串
-(NSString *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return nil;
    }
}

#pragma mark - 获取验证码
- (void)btnGetCode{
    
    if([self checkTel:txtfPhone.text]==NO){
        [self showAlert:@"请检验手机号"];
    }
    else{
        if(flag == 60 || flag==0){
            [self setParams];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
            [timer setFireDate:[NSDate distantPast]];}
    }
}

#pragma mark - 提示框
- (void)showAlert : (NSString *) msg
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

int flag = 0;
#pragma mark - 倒计时事件
-(void)timerFired{
    flag--;
    btnReqCode.titleLabel.text=[NSString stringWithFormat:@"%ld",(long)flag];
    //设置字体颜色
    [btnReqCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if(flag == 0){
        //取消定时器
        [timer invalidate];
        timer = nil;
        //设置字体颜色
        [btnReqCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btnReqCode.titleLabel.text=[NSString stringWithFormat:@"%@",@"重新获取"];
        flag = 60;
    }
    
}

#pragma mark - 手机号判断
- (BOOL)checkTel:(NSString *)str
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:str];
}
#pragma mark - post设置
-(void)setParams{
    int a = arc4random() % 10;
    int b = arc4random() % 10;
    int c = arc4random() % 10;
    int d = arc4random() % 10;
    int x = arc4random() % 10;
    int y = arc4random() % 10;
    
    strCode=[NSString stringWithFormat:@"%d%d%d%d%d%d",a,b,c,d,x,y];
    codePhone = txtfPhone.text;
    Action = @"send";
    Code = @"ytweheart";
    
    NSLog(@"show the strCode:%@",strCode);
    NSString *strMyPost =[NSString stringWithFormat:@"message=%@&phone=%@&action=send&code=ytweheart",strCode,codePhone];
    NSString * str = [NSString stringWithFormat:@"%@?%@",SMS,strMyPost];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    HttpDownLoadBlock * request = [[HttpDownLoadBlock alloc]initWithStrUrl:str Time:0 Block:^(BOOL isFinish, HttpDownLoadBlock * http) {
        if (isFinish) {
            if(http.dataStr!=nil)
            {
                if([http.dataStr isEqualToString:@"0"])
                {
                    [self showAlert:@"验证码发送到您的手机失败啦，请重试~"];
                }
                else if([http.dataStr isEqualToString:@"1"])
                {
                    [self showAlert:@"验证码已经成功发送到您的手机啦，请注意查收~"];
                }
            }
        }
    }];
    request = nil;
}

#pragma mark - 信息判断
-(NSString *)isTrue{
    NSString *str = @"";
    if([self checkTel:txtfPhone.text]==NO){
        str=@"请检验手机号!";
    }
    else if([txtfCode.text isEqualToString:strCode]==NO){
        str=@"请检验验证码!";
    }
    else if(!txtfPwd.text.length<6&&txtfPwd.text.length>12){
        str=@"请输入6~12位密码";
    }
    else if([txtfAgainPwd.text isEqual:txtfAgainPwd.text]==NO){
        str=@"两次的输入不同";
    }
    return str;
}

#pragma mark - 结束编辑
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



#pragma mark - 点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.scroll.contentSize = CGSizeMake(WIDTH,HEIGHT);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtfPhone resignFirstResponder];
    [txtfCode resignFirstResponder];
    [txtfPwd resignFirstResponder];
    [txtfAgainPwd resignFirstResponder];
}

#pragma mark - 开始编辑前
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.scroll.contentSize = CGSizeMake(WIDTH,630.0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
