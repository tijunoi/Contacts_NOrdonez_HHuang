//
//  NewContactViewController.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 17/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController, UITextFieldDelegate{

    //@IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var lastNameTextField: UITextField!
    //@IBOutlet weak var num1TextField: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var num1TextField: UITextField!
    @IBOutlet weak var num2TextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    //Para controlar que el teclado sobrepone la view  Se guarda para modificar el tamaño de la scrollView
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    var activeTextField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameTextField.delegate = self
        //lastNameTextField.delegate = self
        //num1TextField.delegate = self
        
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        num1TextField.delegate = self
        num2TextField.delegate = self
        emailTextField.delegate = self

        NotificationCenter.default.addObserver(self,selector: #selector(NewContactViewController.keyboardWillShow(_:)),name: NSNotification.Name.UIKeyboardWillShow, object: view.window)
        NotificationCenter.default.addObserver(self,selector: #selector(NewContactViewController.keyboardWillHide(_:)),name: NSNotification.Name.UIKeyboardWillHide, object: view.window)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SaveSegue" {
            if (!nameTextField.text!.isEmpty || !lastNameTextField.text!.isEmpty || !num1TextField.text!.isEmpty || !num2TextField.text!.isEmpty){
                return true
            } else {
                return false
            }
        }
        return true
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveSegue" {
            if let dest = segue.destination as? AllContactsTableViewController{
                //Le pasamos 0 como id ya que id no es un optional, pero ese id no sirve de nada ya que al insertarlo, genrra SQLite su id
                //isFav false porque por defecto nunca se añadirá a favoritos
                let contactToCreate = Contact(id: 0, name: nameTextField.text, lastName: lastNameTextField.text, num1: num1TextField.text, num2: num2TextField.text, email: emailTextField.text, isFav: false)
                dest.newContact = contactToCreate
            }
        }
    }

    
    //Gestionar la desaparición de el teclado. TODO: hacer que el teclado siga avanzando por los campos
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
        return true
    }

    @objc func keyboardWillShow(_ sender: Notification){
        if keyboardHeight != nil {
            return
        }

        //Suponemos que esto está desactualizado pero es la manera que hemos encontrado de coger el valor del tamaño del teclado
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // Cambiar tamaño de la view tanto como la altura del teclado
            UIView.animate(withDuration: 0.3, animations: {
                self.contentHeightConstraint.constant += self.keyboardHeight
            })

            //Mover el textfield si lo tapa
            let distanceToBottom = self.scrollView.frame.size.height - (activeTextField?.frame.origin.y)! - (activeTextField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom

            if collapseSpace < 0 {
                //no modificar, ya que la view no lo tapa
                return
            }

            //cambiar el offset de la scrollview. Eso se hace porque no basta con modificar el contentView, ya que la scrollview seguiria estando por debajo del teclado
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }

    @objc func keyboardWillHide(_ sender: Notification){
        UIView.animate(withDuration: 0.3, animations: {
            if let constant = self.keyboardHeight {
                self.contentHeightConstraint.constant -= self.keyboardHeight
                self.scrollView.contentOffset = self.lastOffset
            }
        })
        keyboardHeight = nil

    }



}
