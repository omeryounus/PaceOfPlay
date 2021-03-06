//
//  Home.swift
//  Pace of Play
//
//  Created by Ethan Schoen on 7/1/16.
//  Copyright © 2016 Ethan Schoen. All rights reserved.
//

import UIKit
import CoreData

class Home: UIViewController {
    
    var viewItems = [String]()
    var viewObj = [NSManagedObject]()
    @IBOutlet weak var picker: UIPickerView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toRun" && viewObj.count != 0) {
            let run = (segue.destination as! Run)
            run.startTime = Date()
            for obj in viewObj {
                let selName = viewItems[picker.selectedRow(inComponent: 0)]
                if(obj.value(forKey: "name") as! String == selName){
                    run.selectedCourse = obj
                }
            }
        }
    }
    
    @IBAction func deleteButton(_ button: UIButton) {
        if(viewItems.count == 0){return}
        let currentVal = picker.selectedRow(inComponent: 0)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.delete(viewObj[currentVal])
        viewItems.remove(at: currentVal)
        viewObj.remove(at: currentVal)
        picker.reloadAllComponents()
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //viewItems.removeAll()
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Courses")
        
        //3
        do {
            let results = try managedContext.fetch(fetchRequest)
            viewObj = results as! [NSManagedObject]
            if(viewObj.count == 0){return}
            for i in 0...viewObj.count-1{
                viewItems.append(viewObj[i].value(forKey: "name") as! String)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return viewItems[row]
    }
    
    @IBAction func clearKeyboard(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
