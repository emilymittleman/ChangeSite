//
//  ThirtyMinuteDatePicker.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  UIViewRepresentable wrapping UIDatePicker in dateAndTime / wheels mode
//  with a 30-minute interval, matching the UIKit StartDatePickerBottomSheet.
//

import SwiftUI
import UIKit

struct ThirtyMinuteDatePicker: UIViewRepresentable {

  @Binding var selection: Date

  func makeUIView(context: Context) -> UIDatePicker {
    let picker = UIDatePicker()
    picker.datePickerMode = .dateAndTime
    picker.preferredDatePickerStyle = .wheels
    picker.minuteInterval = 30
    picker.addTarget(
      context.coordinator,
      action: #selector(Coordinator.valueChanged(_:)),
      for: .valueChanged
    )
    return picker
  }

  func updateUIView(_ uiView: UIDatePicker, context: Context) {
    // Avoid feedback loops: only update the picker when the date differs
    // by more than 1 second (UIDatePicker fires valueChanged during scroll).
    if abs(uiView.date.timeIntervalSince(selection)) > 1 {
      uiView.setDate(selection, animated: false)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(selection: $selection)
  }

  // MARK: - Coordinator

  final class Coordinator: NSObject {
    var selection: Binding<Date>

    init(selection: Binding<Date>) {
      self.selection = selection
    }

    @objc func valueChanged(_ sender: UIDatePicker) {
      selection.wrappedValue = sender.date
    }
  }
}

// MARK: - Preview

#Preview {
  @Previewable @State var date = Date()
  VStack {
    ThirtyMinuteDatePicker(selection: $date)
    Text(date.formatted(date: .abbreviated, time: .shortened))
      .padding()
  }
}
