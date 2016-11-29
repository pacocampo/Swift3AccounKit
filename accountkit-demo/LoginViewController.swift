//
//  LoginViewController.swift
//  accountkit-demo
//
//  Created by Francisco Ocampo Romero on 28/11/16.
//  Copyright © 2016 facebook. All rights reserved.
//

import UIKit
import AccountKit

class LoginViewController: UIViewController {
  
  var accountKit : AKFAccountKit!
  var pendingLoginViewController : AKFViewController?
  var authorizationCode : String?
  var advancedUIManager : AKFAdvancedUIManager?
  var userLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
      if accountKit == nil {
        accountKit = AKFAccountKit(responseType: .accessToken)
      }
      pendingLoginViewController = accountKit!.viewControllerForLoginResume() as? AKFViewController
      pendingLoginViewController?.delegate = self
      
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if userLoggedIn {
      // Go to main view controller
      print("User is already logged")
    }
    if pendingLoginViewController != nil {
      self.prepareViewController(loginViewController: pendingLoginViewController!)
      self.present(pendingLoginViewController as! UIViewController, animated: true, completion: nil)
      self.pendingLoginViewController = nil
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func prepareViewController(loginViewController : AKFViewController) {
    loginViewController.delegate = self
  }

  //Login con correo electrónico
  @IBAction func signupWithMail() {
    let inputState = NSUUID().uuidString
    let vc: AKFViewController = accountKit!.viewControllerForEmailLogin(withEmail: nil, state: inputState) as! AKFViewController
    self.prepareViewController(loginViewController: vc)
    self.present(vc as! UIViewController, animated: true, completion: nil)
  }
  
  
  //Login con SMS
  @IBAction func signupWithSms() {
    let inputState = NSUUID().uuidString
    let vc  = accountKit!.viewControllerForPhoneLogin(with: nil, state: inputState) as! AKFViewController
    self.prepareViewController(loginViewController: vc)
    self.present(vc as! UIViewController, animated: true, completion: nil)
  }
  
  //Acceder a la infomación del usuario
  @IBAction func requestAccount() {
    self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
    self.accountKit!.requestAccount({ (account, error) -> Void in
      if account?.emailAddress != nil {
        print("Email : \(account!.emailAddress!)")
      }
      else if account?.phoneNumber != nil {
        print("Teléfono : \(account!.phoneNumber!)")
      }
    })
  }
  
  //Logout
  @IBAction func logout() {
    self.accountKit.logOut()
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController : AKFViewControllerDelegate {
  //En caso de que nuestra aplicación tenga una respuesta de tipo token
  func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
    self.userLoggedIn = true
    print("token : \(accessToken) state : \(state)")
  }
  
  //En caso de que nuestra aplicación tenga una respuesta de tipo auth-code
  func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
    self.userLoggedIn = true
    print("Authcode :  \(code) state : \(state)")
  }
  
  //En caso de tener algún error lo cachamos con está función
  func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
    print("error \(error)")
  }
  
  
}
