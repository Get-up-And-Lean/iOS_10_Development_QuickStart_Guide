//
//  SignUpViewController.swift
//  Instagram
//
//  Created by coderdream on 2018/12/3.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit
import LeanCloud

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // ImageView 用于显示用户头像
    @IBOutlet weak var avaImg: UIImageView!
    
    // 用户名、密码、重复密码、电子邮件的Outlet关联
    @IBOutlet weak var usernameTxt: UITextField!    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    // 姓名、简介、网站的Outlet关联
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    // 注册和取消按钮的Outlet关联
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // 滚动视图的Outlet关联
    @IBOutlet weak var scrollView: UIScrollView!
    
    // 根据需要，设置滚动视图的高度
    var scrollViewHeight: CGFloat = 0
    
    // 获取虚拟键盘的大小
    var keyboard: CGRect = CGRect()
    
    // 注册按钮单击事件
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        print("注册按钮被单击")
        // 隐藏 keyboard
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
            // 弹出提示对话框
            let alert = UIAlertController(title: "请注意", message: "请填好所有的字段", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 如果两次输入的密码不同
        if passwordTxt.text != repeatPasswordTxt.text {
            // 弹出提示对话框
            let alert = UIAlertController(title: "请注意", message: "两次输入的密码不同", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 发送注册数据到服务器相关的列
        
        //        let user = LCUser()
        //        user.username = usernameTxt.text!.lowercased()
        //        user.email = emailTxt.text!.lowercased()
        //        user.password = passwordTxt.text!
        //        user["fullname"] = fullnameTxt.text!.lowercased()
        //        user["bio"] = bioTxt.text!
        //        user["web"] = webTxt.text!.lowercased()
        //        user["gender"] =""
        //        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        //        let avaFile = AVFile(name: "iPhone.jpg", data: avaData!)
        //        user["ava"] = avaFile as? LCValue
        //        user.signUpInBackground{
        //            (success: Bool, error: Error?) in
        //              if success {
        //                  print("用户注册成功！")
        //                                                        }else {
        //                                              print(error!.localizedDescription)
        //            }
        //                                                  }
        
        
        
        // https://www.jianshu.com/p/c6ccd9880694 关于LeanCloud SDK 使用中数据提交的问题
        //提交到云平台
        let user = LCUser()
        user.username = LCString(usernameTxt.text!.lowercased())
        user.email = LCString(emailTxt.text!.lowercased())
        user.password = LCString(passwordTxt.text!)
        user["fullname"] = LCString(fullnameTxt.text!.lowercased())
        user["bio"] = LCString(bioTxt.text!)
        user["web"] = LCString(webTxt.text!.lowercased())
        user["gender"] = LCString("")
        
        //let number     : LCNumber     = 42
        //let bool       : LCBool       = true
        //let string     : LCString     = "ava.jpg"
        //let object     : LCObject     = LCObject()
        
        // 'UIImageJPEGRepresentation' has been replaced by instance method 'UIImage.jpegData(compressionQuality:)'
        let avatarImageData = UIImage.jpegData(avaImg.image!)(compressionQuality: 0.5)!
        //let dictionary : LCDictionary = LCDictionary(["name": string, "Data": avatarImageData])
        // Incorrect argument labels in call (have 'name:data:', expected 'className:objectId:')
        // let avaFile = LCFile(url: "https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01000.png") //AVFile(name: "iPhone.jpg", data: avaData!) //  LCFile(url: "") //
        //let avaFile = LCFile()
        //avaFile.name = "ava.jpg"
        //avaFile.metaData = dictionary
        //user["ava"] = avaFile as LCValue
        //        let queue = DispatchQueue(label:"llll",qos: .background)
        //        print("### Done ###")
        //        queue.async {
        //            user.signUp()
        //        }
        
        // let user = LCUser()
        
        //let username = "user" + LeanCloud.Utility.uuid()
        // let password = "qwerty"
        
        //user.username = LCString(username)
        //user.password = LCString(password)

        
        
        let avatarFile = LCFile(payload: .data(data: avatarImageData))
        avatarFile.name = "ava.jpg"
        
        _ = avatarFile.save { result in
            switch result {
            case .success:
                user.avatarFile = avatarFile
                print("result: \(user)")
                let result = user.signUp()
                
                if result.isSuccess {
                    print("用户注册成功")
                    
                    // 记住登录的用户
                    UserDefaults.standard.set(user.username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    // 从 AppDelegate 类中调用 login 方法
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.login()
                } else {
                    print("")
                }
                print("result: \(result)")
                
            case .failure(let error):
                print(error.localizedDescription)
                //XCTFail(error.localizedDescription)
            }
            
            //expectation.fulfill()
        }
        
//        user.signUpInBackground { (success: Bool, error: Error?) in
//            if success {
//
//            } else {
//
//            }
//
//        }  //:(completionInBackground: <#T##(LCBooleanResult) -> Void#>)
        
    }
    
    // 取消按钮单击事件
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        print("取消按钮被单击")
        
        // 以动画的方式去除通过modally方式添加进来的控制器
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // 滚动视图的窗口尺寸
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        // 定义滚动视图的内容视图尺寸与窗口尺寸一样
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height
        
        
        // 检测键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 声明隐藏虚拟键盘的操作
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // 为ImageView添加单击手势识别
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        imageTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imageTap)
        
        // 改变avaImg的外观为圆形
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        
        //通过date获得组件
        let date2 = Date()
        
        //date -> string
        let myFormatter = DateFormatter()
        //这里有很多默认的日期格式
        myFormatter.dateStyle = .long
        //默认的时间格式
        myFormatter.timeStyle = .long
        myFormatter.string(from: date2)
        
        //也可以使用自定义的格式
        myFormatter.dateFormat = "yyyyMMddhhmmss"
        let datestr = myFormatter.string(from: date2)
        
        usernameTxt.text = "CD_" + datestr;
        passwordTxt.text = "123";
        repeatPasswordTxt.text = "123";
        emailTxt.text = "CD_" + datestr + "@qq.com";
        fullnameTxt.text = "许林";
        bioTxt.text = "iOS程序猿";
        webTxt.text = "http://coderdream.github.io";
    }
    
    // 检测键盘出现或消失时调用的方法
    @objc func showKeyboard(notification: Notification) {
        // 定义 keyboard 大小
        let rect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        
        // 当虚拟键盘出现以后，将滚动视图的实际高度缩小为屏幕高度减去键盘的高度
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
        }
    }
    
    @objc func hideKeyboard(notification: Notification) {
        // 当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight
        }
    }
    
    // 隐藏视图中的虚拟键盘
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 为ImageView添加单击手势识别
    @objc func loadImage(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // 关联选择好的照片图像到ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        avaImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // 用户取消获取器操作时调用的方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
