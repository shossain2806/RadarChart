//Copyright (c) 2019 Saber Hossain
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit

public protocol RadarChartDataSource : class {
    func radarChartValue(chartNo: Int, variableNo: Int) -> Double
}


@IBDesignable public class RadarChartView: UIView {
    
    public weak var dataSource : RadarChartDataSource?
    
    private var maxValue : Double = 1.0
    private var radarCharts : [RadarChartAppearance]?
    
    @IBInspectable private var variables : Int = 5 {
        didSet{
            if variables < 3{
                variables = 3
            }
        }
       
    }
    
    @IBInspectable private var gridlines : Int = 4{
        didSet{
            if gridlines < 1{
                gridlines = 1
            }
        }
    }
    
    public func prepare(radarCharts : [RadarChartAppearance],
                 maxValue: Double,
                 variables : Int = 5,
                 gridlines : Int = 4){
        
        self.variables = variables
        self.gridlines = gridlines
        self.maxValue = maxValue
        self.radarCharts = radarCharts
        setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
       
        let paddedRect = rect.insetBy(dx: 2.0, dy: 2.0)
        drawAxes(paddedRect)
        drawCharts(paddedRect)
    }
  
    private func drawAxes(_ rect: CGRect){
    
        let center = rect.center
        
        for levels in 1...gridlines{
            let normalizedLength = CGFloat(levels) / CGFloat(gridlines)
            let axesPoints = self.getAxesPoints(for: normalizedLength,
                                                axesCount: variables,
                                                in: rect)
           
            let path = UIBezierPath()
            UIColor.lightGray.setStroke()
            axesPoints.forEach { (point) in
                path.move(to: center)
                path.addLine(to: point)
            }
            path.stroke()
            drawGrids(outerPoints: axesPoints)
        }
       
    }
    
    private func drawGrids(outerPoints: [CGPoint]){
        
        let path = UIBezierPath()
        UIColor.lightGray.setStroke()

        outerPoints.forEach { (point) in
            if point == outerPoints.first{
                path.move(to: point)
            }else{
                path.addLine(to: point)
            }
        }
        path.close()
        path.stroke()
    }
    
    private func drawCharts(_ rect: CGRect){
        
        guard let dataSource = self.dataSource,
            let charts = self.radarCharts else{
            return
        }
        
        for radarChartNo in 0..<charts.count{
            var points : [CGPoint] = []
            let chartAppearance = charts[radarChartNo]
            for variable in 0..<variables{
                let value = dataSource.radarChartValue(chartNo: radarChartNo, variableNo: variable)
                let normalizedValue = value / maxValue
                let axis = variable + 1
                let point = self.getAxisPoint(for: CGFloat(normalizedValue), axisNo: axis, axesCount: variables, in: rect)
                points.append(point)
            }
            let path = UIBezierPath()
            chartAppearance.strokeColor?.setStroke()
            chartAppearance.fillColor?.setFill()
            path.lineWidth = 1.0
            points.forEach({ (point) in
                if point == points.first{
                    path.move(to: point)
                }
                else{
                    path.addLine(to: point)
                }
                
            })
            path.close()
            path.fill()
            path.stroke()
            
            //draw point circles
            points.forEach({ (point) in
                let width : CGFloat = 3.0
                let border : CGFloat = 1.0
                let path = UIBezierPath(arcCenter: point, radius: width, startAngle: 0, endAngle: 360, clockwise: true)
                UIColor.white.setStroke()
                chartAppearance.strokeColor?.setFill()
                path.lineWidth = border
                path.fill()
                path.stroke()
                
            })
        }
        
        
    }
    
    private func getAxesPoints(for normalizedLength: CGFloat,
                               axesCount: Int,
                               in rect: CGRect) -> [CGPoint]{
        
        return (1...axesCount).compactMap { (axisNo) -> CGPoint in
            return self.getAxisPoint(for: normalizedLength,
                                     axisNo: axisNo,
                                     axesCount: axesCount,
                                     in: rect)
        }
    }
    
    private func getAxisPoint(for normalizedLength: CGFloat,
                              axisNo: Int,
                              axesCount: Int,
                              in rect: CGRect) -> CGPoint{
        
        let center = rect.center
        let radius : CGFloat = rect.width * CGFloat(normalizedLength) / 2.0
        
        let angle : CGFloat = (CGFloat(360) / CGFloat(axesCount))
        let currentAngle : CGFloat = CGFloat(270) + (angle * CGFloat(axisNo))
        let x = center.x + radius * cos(.pi *  currentAngle / CGFloat(180))
        let y = center.y + radius * sin(.pi * currentAngle / CGFloat(180))
        let point = CGPoint(x: x, y: y)
        return point
    }
}

