//
//  ViewController.swift
//  Covid19CA
//
//  Created by Arturo on 11/12/21.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblRecovered: UILabel!
    @IBOutlet weak var lblDeaths: UILabel!
    @IBOutlet weak var lblQC: UILabel!
    @IBOutlet weak var lblQCCA: UILabel!
    @IBOutlet weak var chart: BarChartView!
    
    let url = "https://api.opencovid.ca"
    let urlM = "https://api.opencovid.ca/summary?loc=QC"
    var ctotal = 0.0
    var cdeaths = 0.0
    var crecovered = 0.0
    var qtotal = 0.0
    var qdeaths = 0.0
    var qrecovered = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData(url)
        getData(urlM)
       //
    }

    func getData(_ url:String){
        let session = URLSession.shared
        let queryUrl = URL(string: url)!
        let task = session.dataTask(with: queryUrl){
            data, response, error in
            if error != nil || data == nil {
                print ("Client error!")
                return
            }
            let r = response as? HTTPURLResponse
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)else{
                print("Server error \(String(describing: r?.statusCode))")
                return
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Incorrect MIME type: \(String(describing: r?.mimeType))")
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                let summary = (json?["summary"] as? [Any])
                let total = (summary?[0] as? [String:Any])?["cumulative_cases"] as? Double
                let recovered = (summary?[0] as? [String:Any])?["cumulative_recovered"] as? Double
                let deaths = (summary?[0] as? [String:Any])?["cumulative_deaths"] as? Double
                let province = (summary?[0] as? [String:Any])?["province"] as? String
                DispatchQueue.main.async {
                    self.setCanada(total: total!, recovered: recovered!, deaths: deaths!, province: province!)
                }
                
                
            }catch{
                print("Error in JSON")
                return
            }
        }
        task.resume()
    }
    
    func setCanada(total:Double, recovered:Double, deaths:Double, province:String){
        if(province=="Canada"){
            lblTotal.text = String(format:"%.0f", total)
            lblRecovered.text = String(format:"%.0f", recovered)
            lblDeaths.text = String(format:"%.0f", deaths)
            ctotal = total
            crecovered = recovered
            cdeaths = deaths
        }else{
            lblQC.text = String(format:"%.0f", total)
            qtotal = total
            qrecovered = recovered
            qdeaths = deaths
            lblQCCA.text = String(format:"%.0f",qtotal*100/ctotal)
            updateGraph()
        }
    }
    
    func updateGraph(){
        var barChartEntry = [BarChartDataEntry]()
        var labels:[String] = ["CA Total","QC","CA Recover","QC","CA Death","QC"]
        var datta:[Double] = [ctotal,qtotal,crecovered,qrecovered,cdeaths,qdeaths]
        for i in 0..<labels.count{
            
            let val = BarChartDataEntry(x: Double(i), y: datta[i])
            barChartEntry.append(val)
        }
            
        let line1 = BarChartDataSet(entries: barChartEntry, label: "# People")
        
      //  line1.colors = [NSUIColor.orange]
        
        let data = BarChartData()
        
        data.addDataSet(line1)
        chart.data = data
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        chart.xAxis.granularity = 1
        chart.chartDescription?.text="Cummulative Covid Cases"
        chart.chartDescription?.textColor=NSUIColor.white
        chart.xAxis.labelTextColor = NSUIColor.white
        chart.barData?.setValueTextColor(NSUIColor.white)

        
        
    }

}
