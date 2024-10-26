//
//  SettingsTableVC.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 8/13/21.
//  Copyright © 2021 Emily Mittleman. All rights reserved.
//

import UIKit

class SettingsTableVC: UITableViewController {

  /*var pumpSite: PumpSite = PumpSiteManager.shared.pumpSite
   var reminderNotifications: [ReminderNotification] = ReminderNotificationsManager.shared.reminderNotifications

   override func viewDidLoad() {
   super.viewDidLoad()
   }

   // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
   // return the number of sections
   return 2
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   // return the number of rows
   if (section == 0) {
   return 2
   }
   return 5
   }


   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   if section == 0 {
   return "Settings"
   }
   return "Reminder Settings"
   }


   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   if indexPath[0] == 0 {
   if (indexPath[1] == 0) {
   let cell = tableView.dequeueReusableCell(withIdentifier: "startDateCell", for: indexPath) as! StartDateCell
   let dateFormatter = DateFormatter()
   dateFormatter.dateStyle = DateFormatter.Style.short
   dateFormatter.timeStyle = DateFormatter.Style.short
   let strDate = dateFormatter.string(from: self.pumpSite.getStartDate())
   cell.startDate.text = strDate
   return cell
   }
   else {
   let cell = tableView.dequeueReusableCell(withIdentifier: "daysBtwnCell", for: indexPath) as! DaysBtwnCell
   cell.daysBtwn.text = String(pumpSite.getDaysBtwn())
   return cell
   }
   }
   else {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderCell
   cell.occurrenceLabel.text = reminderNotifications[indexPath[1]].frequency.rawValue
   switch indexPath[1] {
   case 0:
   cell.timingLabel.text = "1 day before change is due"
   case 1:
   cell.timingLabel.text = "The day of"
   case 2:
   cell.timingLabel.text = "1 day after"
   case 3:
   cell.timingLabel.text = "2 days after"
   default:
   cell.timingLabel.text = ">3 days after"
   }
   return cell
   }
   }
   */

  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */

  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */

  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

   }
   */

  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  


  /*
   enum SettingsSection: Int {
   case General, Reminders, Count

   static var count = {
   return SettingsSection.Count.rawValue
   }

   static let sectionTitles = [General: "",
   Reminders: "Reminder Notifications"]

   func sectionTitle() -> String {
   if let sectionTitle = SettingsSection.sectionTitles[self] {
   return sectionTitle
   } else {
   return ""
   }
   }
   }*/

}
