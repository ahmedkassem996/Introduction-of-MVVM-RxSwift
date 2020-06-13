//
//  ViewController.swift
//  HelloMvvmAndRxSwift
//
//  Created by AHMED on 3/24/1399 AP.
//  Copyright © 1399 AHMED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var userNameTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var loginBtn: UIButton!
  
  private let loginViewModel = LoginViewModel()
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userNameTF.becomeFirstResponder()
    
    userNameTF.rx.text.map { $0 ?? "" } .bind(to: loginViewModel.userNameTextPublishSubject).disposed(by: disposeBag)
    passwordTF.rx.text.map { $0 ?? "" } .bind(to: loginViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
    
    loginViewModel.isValid().bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
    loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginBtn.rx.alpha).disposed(by: disposeBag)
  }


  @IBAction func tappedLoginBtn(_ sender: UIButton) {
    print("Tapped login button")
  }
}

class LoginViewModel {
  let userNameTextPublishSubject = PublishSubject<String>()
  let passwordTextPublishSubject = PublishSubject<String>()
  
  func isValid() -> Observable<Bool> {
    return Observable.combineLatest(userNameTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable().startWith("")).map { username, password in
      return username.count > 3 && password.count > 3
    }.startWith(false)
  }
}
