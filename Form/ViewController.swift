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
    var animationView: AnimationView?
    
    //MARK: - Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        edtName.text = "Fernando"
        edtLastName1.text = "Gonzalez"
        edtLastName2.text = "Gonzalez"
        edtEmail.text = "fer_gg@outlook.es"
        edtPhone.text = "2222222222"
        
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
        
        moveKeyboard()
    }
    
    func moveKeyboard(){
        
        //Observers
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func changeKeyboard(notification: Notification){
        let infoKeyboard = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let dimension = infoKeyboard!.cgRectValue
        let heigth = dimension.height
        let name = notification.name.rawValue
            
        let originY = view.frame.origin.y
        let heigthKeyB = heigth / 5
        switch name{
        case "UIKeyboardWillHideNotification": originY
        case "UIKeyboardWillShowNotification":
            
            if edtLastName2.isFirstResponder{
                view.frame.origin.y = (-1 * heigthKeyB) * 1.4
            }
            if edtEmail.isFirstResponder{
                view.frame.origin.y = (-1 * heigthKeyB) * 2.8
            }
            if edtPhone.isFirstResponder{
                view.frame.origin.y = (-1 * heigthKeyB) * 4
            }
            
        default: view.frame.origin.y = originY / heigthKeyB
            print("Default")
        }
    }
    
    
    deinit{
        print("quitando el centro de notificaciones")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        animationView?.autoresizesSubviews = true
        
        print(animationView!.frame)
        animationView?.contentMode = .scaleAspectFit
        let size = imgEmail.frame.maxY
        animationView!.frame = CGRect(x: 0, y: 0, width: size, height: size)
        //animationView!.frame = imgEmail.frame.maxX
        //animationView?.bounds = imgEmail.frame
        
        print(animationView!.frame)
        print(imgEmail.bounds)
        //print(imgEmail.frame.maxX)
        print(imgEmail.frame.maxY)
        
        
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
        
        Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false, block: {_ in
            self.closeAnimation()
        })
        
        
    }
    
    @objc func closeAnim(){
        
        animationView?.stop()
        animationView?.removeFromSuperview()
        animationView = nil
        loadAnimation(name: "email")
    }
    
    func closeAnimation(){
        //let selector = #selector(closeAnim)
        
        closeAnim()
        //_ = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: selector, userInfo: nil,  repeats: false)
        
        
    }
    //MARK: - Actions
    @IBAction func edtEm(_ sender: UITextField) {
        
        let text = sender.text!
        
        if !text.isEmpty{
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
            if !validateNumber(number: text){
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
        //clearEDT()
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

