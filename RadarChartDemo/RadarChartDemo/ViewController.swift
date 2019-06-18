//
//  ViewController.swift
//  RadarChartDemo
//
//  Created by Saber Hossain on 4/2/20.
//  Copyright © 2020 Saber Hossain. All rights reserved.
//

import UIKit
import RadarChart

class ViewController: UIViewController {

    @IBOutlet weak var radarChart: RadarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        
        radarChart.dataSource = self
       
        let charApperance1 = RadarChartAppearance(fillColor: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5), strokeColor: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        let chartAppearnce2 = RadarChartAppearance(fillColor: UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5), strokeColor: UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0))
        
        radarChart.prepare(radarCharts: [charApperance1, chartAppearnce2], maxValue: 5.0, variables: 5, gridlines: 4)
    }


}

extension ViewController : RadarChartDataSource{
   
    func radarChartValue(chartNo: Int, variableNo: Int) -> Double {
        return Double.random(in: 2...5)
    }
    
    
}
