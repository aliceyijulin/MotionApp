//
//  ViewController.swift
//  Motion
//
//  Created by Alice on 6/24/21.
//

import UIKit
import Charts
import Foundation
import CoreBluetooth


struct CBUUIDs{

    static let kBLEService_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    static let kBLE_Characteristic_uuid_Tx = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    static let kBLE_Characteristic_uuid_Rx = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)

}

class ViewController: UIViewController  {

    var centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    
    @IBOutlet weak var lineChartBox: LineChartView!
    @IBOutlet weak var barChartBox: BarChartView!
    @IBOutlet weak var pieChartBox: PieChartView!
    
    
    var receivedData = [Int]()
    var showGraphIsOn = true

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)

        // Do any additional setup after loading the view.
        lineChartBox.isHidden = true
        barChartBox.isHidden = true
        pieChartBox.isHidden = true

    }
        
    func graphLineChart(dataArray: [Int])
    {
        // Make lineChartBox size have width and height both equal to width of screen
        lineChartBox.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width / 2)
        
        // Make lineChartBox center to be horizontally centered, but offset towards the top of the screen
        lineChartBox.center.x = self.view.center.x
        lineChartBox.center.y = self.view.center.y
        
        // Settings when chart has no data
        lineChartBox.noDataText = "No data available."
        lineChartBox.noDataTextColor = UIColor.black
        
        // Initialize Array that will eventually be displayed on the graph.
        var entries = [ChartDataEntry]()
        
        // For every element in given dataset
        // Set the X and Y coordinates in a data chart entry and add to the entries list
        for i in 0..<dataArray.count {
            let value = ChartDataEntry(x: Double(i), y: Double(dataArray[i]))
            entries.append(value)
        }
        
        // Use the entries object and a label string to make a LineChartDataSet object
        let dataSet = LineChartDataSet(entries: entries, label: "Line Chart")
        
        // Customize graph settings to your liking
        dataSet.colors = ChartColorTemplates.joyful()
        
        // Make object that will be added to the chart and set it to the variable in the Storyboard
        let data = LineChartData(dataSet: dataSet)
        lineChartBox.data = data
        
        // Add settings for the chartBox
        lineChartBox.chartDescription?.text = "Line Values"
        
    }

    func graphPieChart(dataArray: [Int]) {
        // Make lineChartBox size have width and height both equal to width of screen
        pieChartBox.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width / 2)
        
        // Make lineChartBox center to be horizontally centered, but offset towards the top of the screen
        pieChartBox.center.x = self.view.center.x
        pieChartBox.center.y = self.view.center.y
        
        // Settings when chart has no data
        pieChartBox.noDataText = "No data available."
        pieChartBox.noDataTextColor = UIColor.black
        
        // Initialize Array that will eventually be displayed on the graph.
        var entries = [ChartDataEntry]()
        
        // For every element in given dataset
        // Set the X and Y coordinates in a data chart entry and add to the entries list
            for i in 0..<dataArray.count {
            let value = ChartDataEntry(x: Double(i), y: Double(dataArray[i]))
            entries.append(value)
            }
        
        // Use the entries object and a label string to make a LineChartDataSet object
        let dataSet = PieChartDataSet(entries: entries, label: "Pie Chart")
        
        // Customize graph settings to your liking
        dataSet.colors = ChartColorTemplates.joyful()
        
        // Make object that will be added to the chart and set it to the variable in the Storyboard
        let data = PieChartData(dataSet: dataSet)
        pieChartBox.data = data
        
        // Add settings for the chartBox
        pieChartBox.chartDescription?.text = "Pi Values"
        
        // Animations
        pieChartBox.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
    }
    
    func graphBarChart(dataArray: [Int]) {
        // Make lineChartBox size have width and height both equal to width of screen
        barChartBox.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width / 2)
        
        // Make lineChartBox center to be horizontally centered, but offset towards the top of the screen
        barChartBox.center.x = self.view.center.x
        barChartBox.center.y = self.view.center.y
        
        // Settings when chart has no data
        barChartBox.noDataText = "No data available."
        barChartBox.noDataTextColor = UIColor.black
        
        // Initialize Array that will eventually be displayed on the graph.
        var entries = [BarChartDataEntry]()
        
        // For every element in given dataset
        // Set the X and Y coordinates in a data chart entry and add to the entries list
        for i in 0..<dataArray.count {
            let value = BarChartDataEntry(x: Double(i), y: Double(dataArray[i]))
            entries.append(value)
        }
        
        // Use the entries object and a label string to make a LineChartDataSet object
        let dataSet = BarChartDataSet(entries: entries, label: "Bar Chart")
        
        // Customize graph settings to your liking
        dataSet.colors = ChartColorTemplates.joyful()
        
        // Make object that will be added to the chart and set it to the variable in the Storyboard
        let data = BarChartData(dataSet: dataSet)
        barChartBox.data = data
        
        // Add settings for the chartBox
        barChartBox.chartDescription?.text = "Bar Values"
        
        // Animations
        barChartBox.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
    }
    
    @IBAction func Monitor(_ sender: Any) {
        lineChartBox.isHidden = false
        barChartBox.isHidden = true
        pieChartBox.isHidden = true
        }
        
    @IBAction func Steps(_ sender: Any) {
        lineChartBox.isHidden = true
        barChartBox.isHidden = false
        pieChartBox.isHidden = true
        }
    
    @IBAction func Report(_ sender: Any) {
        lineChartBox.isHidden = true
        barChartBox.isHidden = true
        pieChartBox.isHidden = false
        }
    
    func startScanning() -> Void {
      // Start Scanning
      centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {

            bluefruitPeripheral = peripheral
            bluefruitPeripheral.delegate = self

            print("Peripheral Discovered: \(peripheral)")
            print("Peripheral name: \(peripheral.name)")
            print ("Advertisement Data : \(advertisementData)")
            
            centralManager?.connect(bluefruitPeripheral!, options: nil)

        }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
       bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            print("*******************************************************")

            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }
            guard let services = peripheral.services else {
                return
            }
            //We need to discover the all characteristic
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            print("Discovered Services: \(services)")
        }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
           
               guard let characteristics = service.characteristics else {
              return
          }

          print("Found \(characteristics.count) characteristics.")

          for characteristic in characteristics {

            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Rx)  {

              rxCharacteristic = characteristic

              peripheral.setNotifyValue(true, for: rxCharacteristic!)
              peripheral.readValue(for: characteristic)

              print("RX Characteristic: \(rxCharacteristic.uuid)")
            }

            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Tx){
              
              txCharacteristic = characteristic
              
              print("TX Characteristic: \(txCharacteristic.uuid)")
            }
          }
    }
    
    func disconnectFromDevice () {
        if bluefruitPeripheral != nil {
        centralManager?.cancelPeripheralConnection(bluefruitPeripheral!)
        }
     }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                        error: Error?) {
            
            // If characteristic is correct, read its value and save it to a string.
            // Else, return
            guard characteristic == rxCharacteristic,
            let characteristicValue = characteristic.value,
            let receivedString = NSString(data: characteristicValue,
                                          encoding: String.Encoding.utf8.rawValue)
            else { return }
            
            for i in 0..<receivedString.length {
                // Print for debugging purposes
                print(receivedString.character(at: i))
                let number:Int = Int(receivedString.character(at: i))
                receivedData.append(number)
            }
            
            if (receivedData.count > 100) {
                receivedData.removeFirst(receivedData.count-100)
            }
        
            if (showGraphIsOn && receivedData.count > 0) {
                print(receivedData)
                graphLineChart(dataArray: receivedData)
            }
            if (showGraphIsOn && receivedData.count > 0) {
                graphBarChart(dataArray: receivedData)
            }
            if (showGraphIsOn && receivedData.count > 0) {
                graphPieChart(dataArray: receivedData)
            }
        
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
        }
    
    
//    func clearGraph() {
//          let nullGraph = [Int]()
//          displayLineGraph(dataDisplaying: nullGraph)
//      }
    
    func writeOutgoingValue(data: String){
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let bluefruitPeripheral = bluefruitPeripheral {
              
          if let txCharacteristic = txCharacteristic {
                  
            bluefruitPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
              }
          }
      }
}

extension ViewController: CBCentralManagerDelegate {
    
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    
     switch central.state {
          case .poweredOff:
              print("Is Powered Off.")
          case .poweredOn:
              print("Is Powered On.")
              startScanning()
          case .unsupported:
              print("Is Unsupported.")
          case .unauthorized:
          print("Is Unauthorized.")
          case .unknown:
              print("Unknown")
          case .resetting:
              print("Resetting")
          @unknown default:
            print("Error")
          }
   }
}

extension ViewController: CBPeripheralManagerDelegate {

  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    switch peripheral.state {
    case .poweredOn:
        print("Peripheral Is Powered On.")
    case .unsupported:
        print("Peripheral Is Unsupported.")
    case .unauthorized:
    print("Peripheral Is Unauthorized.")
    case .unknown:
        print("Peripheral Unknown")
    case .resetting:
        print("Peripheral Resetting")
    case .poweredOff:
      print("Peripheral Is Powered Off.")
    @unknown default:
      print("Error")
    }
  }
}

extension ViewController: CBPeripheralDelegate {
}

