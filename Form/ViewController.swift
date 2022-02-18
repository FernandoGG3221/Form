//
//  ViewController.swift
//  Form
//
//  Created by Fernando González González on 17/02/22.
//

import UIKit
import Lottie
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var edtName: UITextField!
    @IBOutlet weak var edtLastName1: UITextField!
    @IBOutlet weak var edtLastName2: UITextField!
    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtPhone: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    //MARK: - Properties
    weak var animationView: AnimationView?
    
    //MARK: - Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurations()
        loadAnimation(name: "email")
    }
    
    //MARK: - Configurations
    func configurations(){
        configurationButton()
        configureEditText()
    }
    
    func configureEditText(){
        
        edtName.delegate = self
        edtLastName1.delegate = self
        edtLastName2.delegate = self
        edtEmail.delegate = self
        edtPhone.delegate = self
        
        //name
        edtName.background = UIImage(named: "area_texto")
        //last name 1
        edtLastName1.keyboardType = .alphabet
        //last name 2
        edtLastName2.keyboardType = .alphabet
        //email
        edtEmail.keyboardType = .emailAddress
        //phone
        edtPhone.keyboardType = .phonePad
        edtPhone.placeholder = "Diez números de teléfono"
        
        generateGesture()
    }
    
    func generateGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //Observers
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func changeKeyboard(notification: Notification){
        let infoKeyboard = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let dimension = infoKeyboard!.cgRectValue
        let heigth = dimension.height
        let name = notification.name.rawValue
        
        let originY = view.frame.origin.y
        
        switch name{
        case "UIKeyboardWillHideNotification": originY
        case "UIKeyboardWillShowNotification":
            
            let heigthKeyB = heigth / 5
            
            if edtLastName2.isFirstResponder{
                view.frame.origin.y = (-1 * heigthKeyB) * 1.4
            }
            if edtEmail.isFirstResponder{
                view.frame.origin.y = (-1 * heigthKeyB) * 2.8
            }
            if edtPhone.isFirstResponder{
                view.frame.origin.y = (-1 * heigthKeyB) * 4
            }
        default: view.frame.origin.y = originY / 4
        }
    }
    
    @objc func hideKeyBoard(_ sender: UITapGestureRecognizer){
        edtName.resignFirstResponder()
        edtLastName1.resignFirstResponder()
        edtLastName2.resignFirstResponder()
        edtEmail.resignFirstResponder()
        edtPhone.resignFirstResponder()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case edtName: edtLastName1.becomeFirstResponder()
        case edtLastName1: edtLastName2.becomeFirstResponder()
        case edtLastName2: edtEmail.becomeFirstResponder()
        case edtEmail: edtPhone.becomeFirstResponder()
        default: textField.becomeFirstResponder()
        }
        return true
    }
    
    func configurationButton(){
        btnSend.backgroundColor = .orange
        btnSend.layer.cornerRadius = 10
        btnSend.tintColor = .white
        btnSend.setTitle("Enviar", for: .normal)
    }
    
    func clearEDT(){
        edtName.text = ""
        edtLastName1.text = ""
        edtLastName2.text = ""
        edtEmail.text = ""
        edtPhone.text = ""
    }
    
    //MARK: - Animation
    func loadAnimation(name:String){
        
        animationView = .init(name: name)
        animationView?.frame = imgEmail.bounds
        
        name == "complete" ? (animationView?.loopMode = .playOnce) : (animationView?.loopMode = .loop)
        
        
        if let animationView = animationView {
            imgEmail.addSubview(animationView)
            animationView.play()
        }else{
            print("Error al cargar animación")
        }
        
    }
    
    func removeAnimation(){
        animationView?.stop()
        animationView?.removeFromSuperview()
    }
    
    @objc func closeAnim(){
        animationView?.stop()
        animationView?.removeFromSuperview()
    }
    
    func closeAnimation(){
        let selector = #selector(closeAnim)
        
        _ = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: selector, userInfo: nil, repeats: false)
        
        loadAnimation(name: "email")
    }
    //MARK: - Actions
    @IBAction func edtEm(_ sender: UITextField) {
        
        let text = sender.text!
        
        if text.isEmpty{
            print("El campo está vacio")
        }else{
            if validateEmail(email: sender.text!){
                print("El email tiene formato correcto")
                
            }else{
                showAlert(title: "¡ADVERTENCIA!", message: "Formato de correo electrónico incorrecto")
                edtEmail.text = ""
            }
        }
    }
    
    @IBAction func edtPhone(_ sender: UITextField) {
        
        let text = sender.text!
        
        switch text.count{
        case 0:
            print("El Campo está vacio")
        case 1...9:
            showAlert(title: "¡ADVERTENCIA!", message: "Verifica el número")
            if !validateNumber(number: text){
                edtPhone.text = ""
            }
        case 10:
            if validateNumber(number: text){
                print("Contiene numeros")
                //Almacenar los datos en la bd
            }else{
                showAlert(title: "¡ADVERTENCIA!", message: "Sólo números")
                edtPhone.text = ""
            }
        default:
            showAlert(title: "¡ADVERTENCIA!", message: "Exceso de números")
        }
    }
    
    @IBAction func edtNames(_ sender: UITextField) {
        
        let text = sender.text!
        
        if text.isEmpty{
            print("El campo está vacio")
        }else{
            validateString(text: text) ? print("Contiene solo letras") : showAlert(title: "¡ADVERTENCIA!", message: "Verificar su escritura")
        }
        
    }
    
    func showAnimationSend(){
        removeAnimation()
        clearEDT()
        loadAnimation(name: "complete")
    }
    
    func sendEmail(){
        let name = edtName.text
        let lastName1 = edtLastName1.text
        let lastName2 = edtLastName2.text
        let email = edtEmail.text
        let phone = edtPhone.text
        
        do{
            let ctx = getContextCoreData()
            let newObj = NSEntityDescription.insertNewObject(forEntityName: "ModelContact", into: ctx )
            newObj.setValue(name, forKey: "name")
            newObj.setValue(lastName1, forKey: "lastName1")
            newObj.setValue(lastName2, forKey: "lastName2")
            newObj.setValue(email, forKey: "email")
            newObj.setValue(phone, forKey: "phone")
            try ctx.save()
            showAlert(title: "ENVIADO", message: "Correo enviado correctamente")
            showAnimationSend()
        }catch let err{
            print(err.localizedDescription)
            showAlert(title: "ERROR", message: "Error al enviar el email")
        }
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        edtName.text!.isEmpty && edtLastName1.text!.isEmpty && edtLastName2.text!.isEmpty && edtPhone.text!.isEmpty && edtEmail.text!.isEmpty ? showAlert(title: "CAMPOS VACIOS", message: "Favor de llenar todos los campos") : sendEmail()
    }
    
    //MARK: - Protocols
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.contains(" ") ? false : true
    }
}

