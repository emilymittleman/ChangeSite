//
//  StartDatePickerBottomSheet.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/26/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import UIKit

class StartDatePickerBottomSheet: UIView {

  private let datePicker = UIDatePicker()
  private let cancelButton = UIButton(type: .custom)
  private let saveButton = UIButton(type: .custom)
  private let titleLabel = UILabel()
  private let headerRowView = UIStackView()
  private let headerContainerView = UIView()

  var onCancel: (() -> Void)?
  var onSave: ((Date) -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    // Configure the view
    backgroundColor = UIColor.custom.background
    clipsToBounds = true

    // Configure the title label
    titleLabel.text = "Choose your start date"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "Rubik-Medium", size: 19)
    titleLabel.textColor = UIColor.custom.background

    // Configure the cancel button
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.titleLabel?.text = "Cancel"
    cancelButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17)
    cancelButton.titleLabel?.textColor = UIColor.custom.background
    cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

    // Configure the save button
    saveButton.setTitle("Save", for: .normal)
    saveButton.titleLabel?.text = "Save"
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17)
    saveButton.titleLabel?.textColor = UIColor.custom.background
    saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

    // Configure the date picker
    datePicker.datePickerMode = .dateAndTime
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.minuteInterval = 30

    // Configure the stack view
    headerRowView.axis = .horizontal
    headerRowView.distribution = .equalCentering
    headerRowView.alignment = .center
    headerRowView.spacing = 10
    headerRowView.addArrangedSubview(cancelButton)
    headerRowView.addArrangedSubview(titleLabel)
    headerRowView.addArrangedSubview(saveButton)

    headerContainerView.addSubview(headerRowView)
    headerContainerView.backgroundColor = UIColor.custom.lightBlue

    // Add subviews
    addSubview(headerContainerView)
    addSubview(datePicker)

    // Add constraints
    headerContainerView.translatesAutoresizingMaskIntoConstraints = false
    headerRowView.translatesAutoresizingMaskIntoConstraints = false
    datePicker.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      // Container view constraints
      headerContainerView.heightAnchor.constraint(equalToConstant: 40),
      headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      headerContainerView.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: 10),

      // Button stack view constraints
      headerRowView.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor),
      headerRowView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 10),
      headerRowView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -10),

      // Date picker constraints
      datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
      datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
      datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
    ])
  }

  @objc private func cancelButtonTapped() {
    onCancel?()
  }

  @objc private func saveButtonTapped() {
    onSave?(datePicker.date)
  }

  func showInView(_ view: UIView) {
    let pickerDate = UserDefaults.standard.object(forKey: UserDefaults.Keys.defaultChangeTime.rawValue) as? Date ?? .now
    datePicker.setDate(formatDate(pickerDate), animated: true)
    // TODO: Commented out for testing
    //datePicker.minimumDate = formatDate(viewModel.pumpSiteStartDate())

    frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 300)
    view.addSubview(self)

    UIView.animate(withDuration: 0.3) {
      self.frame = CGRect(x: 0, y: view.bounds.height - 300 - AppConstants.tabBarHeight, width: view.bounds.width, height: 300)
    }
  }

  func dismiss() {
    UIView.animate(withDuration: 0.3, animations: {
      self.frame = CGRect(x: 0, y: self.superview?.bounds.height ?? 852, width: self.bounds.width, height: 300)
    }) { _ in
      self.removeFromSuperview()
    }
  }
}
