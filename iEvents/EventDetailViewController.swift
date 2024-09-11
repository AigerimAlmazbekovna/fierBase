

import UIKit
import FirebaseAuth

class EventDetailViewController: UIViewController {

    
    private var event: Event?
    
    private var storeManager = StoreManager()
    
    private lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.textColor = .black
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.textColor = .black
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .dateAndTime
        view.preferredDatePickerStyle = .automatic
        return view
    }()
    
    init(event: Event? = nil) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        if let event {
            nameTextField.text = event.title
            descriptionTextField.text = event.description
            datePicker.date = event.date
            
            if Auth.auth().currentUser?.email == event.author {
                setupSaveButton(isActive: true)
            } else {
                nameTextField.isEnabled = false
                descriptionTextField.isEnabled = false
                setupSaveButton(isActive: false)
            }
 
        } else {
            setupSaveButton(isActive: true)
        }
    }
    
    private func setupUI() {
        view.addSubviews(nameTextField, descriptionTextField, datePicker)
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
    }
    
    private func setupSaveButton(isActive: Bool) {
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton))
        rightButton.isEnabled = isActive
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func didTapSaveButton() {
        if event != nil {
            event?.title = nameTextField.text!
            event?.description = descriptionTextField.text!
            event?.date = datePicker.date
            
            storeManager.updateEvent(event: event!) { [weak self] errorString in
                if let errorString {
                    print(errorString)
                }
                
                self?.navigationController?.popToRootViewController(animated: true)
                
            }
            
        } else {
            let newEvent = Event(
                title: nameTextField.text!,
                description: descriptionTextField.text!,
                author: (Auth.auth().currentUser?.email)!,
                date: datePicker.date
            )
            
            storeManager.addEvent(event: newEvent) { [weak self] errorString in
                if let errorString {
                    print(errorString)
                }
                
                self?.navigationController?.popToRootViewController(animated: true)
                
            }
        }
    }
    

}
