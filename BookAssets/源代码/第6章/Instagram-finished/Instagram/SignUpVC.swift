//
//  SignUpVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
//import AVOSCloud
import LeanCloud

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var avaImg: UIImageView!
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var repeatPasswordTxt: UITextField!
  @IBOutlet weak var emailTxt: UITextField!
  
  @IBOutlet weak var fullnameTxt: UITextField!
  @IBOutlet weak var bioTxt: UITextField!
  @IBOutlet weak var webTxt: UITextField!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  
  
  // 根据需要，设置滚动视图的高度
  var scrollViewHeight: CGFloat = 0
  
  // 获取虚拟键盘的大小
  var keyboard: CGRect = CGRect()
		
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 滚动视图的frame size
    scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    scrollView.contentSize.height = self.view.frame.height
    scrollViewHeight = self.view.frame.height
    
    // 检测键盘出现或消失的状态
    NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
    
    // 改变avaImg的外观为圆形
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
    
    let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
    imgTap.numberOfTapsRequired = 1
    avaImg.isUserInteractionEnabled = true
    avaImg.addGestureRecognizer(imgTap)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // 调出照片获取器选择照片
    @objc
  func loadImg(recognizer: UITapGestureRecognizer) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  // 关联选择好的照片图像到image view
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    avaImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
  }
  
  // 用户取消获取器操作时调用的方法
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // 隐藏视图中的虚拟键盘
    @objc
  func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
    @objc
  func showKeyboard(notification: Notification) {
    
    // 定义keyboard大小
    let rect = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]!)!) as! NSValue
    keyboard = rect.cgRectValue
    
    // 当虚拟键盘出现以后，将滚动视图的实际高度缩小为屏幕高度减去键盘的高度。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
    }
  }

    @objc
  func hideKeyboard(notification: Notification) {
    // 当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.frame.size.height = self.view.frame.height
    }
  }
  
  // 注册按钮被点击
  @IBAction func signUpBtn_click(_ sender: AnyObject) {
    print("注册按钮被按下！")
    
    // 隐藏keyboard
    self.view.endEditing(true)
    
    if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
      let alert = UIAlertController(title: "请注意", message: "请填写好所有的字段", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
    }
    
    // 如果两次输入的密码不同
    if passwordTxt.text != repeatPasswordTxt.text {
      let alert = UIAlertController(title: "请注意", message: "两次输入的密码不一致", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
    }
    
    let user = LCUser() //AVUser()
    user.username = LCString(usernameTxt.text!.lowercased())
    user.email = LCString(emailTxt.text!.lowercased())
    user.password = LCString(passwordTxt.text!)
    user["fullname"] = LCString(fullnameTxt.text!.lowercased())
    user["bio"] = LCString(bioTxt.text!)
    user["web"] = LCString(webTxt.text!.lowercased())
    user["gender"] = LCString("")
    
    // 转换头像数据并发送到服务器
//    let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
//    let avaFile = AVFile(name: "ava.jpg", data: avaData)
//    user["ava"] = avaFile
    
    let avatarImageData = UIImage.jpegData(avaImg.image!)(compressionQuality: 0.5)!
    let avatarFile = LCFile(payload: .data(data: avatarImageData))
    avatarFile.name = "ava.jpg"
    
//    // 保存信息到服务器
//    user.signUpInBackground { (success:Bool, error:NSError?) in
//      if success {
//        print("用户注册成功！")
//      }else {
//        print(error?.localizedDescription)
//      }
//    }
    _ = avatarFile.save { result in
        switch result {
        case .success:
            user.avatarFile = avatarFile
            print("result: \(user)")
            let result = user.signUp()

            if result.isSuccess {
                print("用户注册成功")
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
}
  
  // 取消按钮被点击
  @IBAction func cancelBtn_click(_ sender: AnyObject) {
    print("取消按钮被按下！")
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
