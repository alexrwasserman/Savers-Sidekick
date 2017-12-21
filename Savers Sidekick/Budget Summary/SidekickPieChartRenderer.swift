//
//  SidekickPieChartRenderer.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/21/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import Charts

// A class to add special behavior to the pie chart. Specifically, to not display the label/value of small slices.
class SidekickPieChartRenderer: PieChartRenderer {
    
    struct Math {
        internal static let FDEG2RAD = CGFloat(Double.pi / 180.0)
        internal static let FRAD2DEG = CGFloat(180.0 / Double.pi)
        internal static let DEG2RAD = Double.pi / 180.0
        internal static let RAD2DEG = 180.0 / Double.pi
    }
    
    open override func drawValues(context: CGContext)
    {
        guard
            let chart = chart,
            let data = chart.data,
            let animator = animator
            else { return }
        
        let center = chart.centerCircleBox
        
        // get whole the radius
        let radius = chart.radius
        let rotationAngle = chart.rotationAngle
        var drawAngles = chart.drawAngles
        var absoluteAngles = chart.absoluteAngles
        
        let phaseX = animator.phaseX
        let phaseY = animator.phaseY
        
        var labelRadiusOffset = radius / 10.0 * 3.0
        
        if chart.drawHoleEnabled
        {
            labelRadiusOffset = (radius - (radius * chart.holeRadiusPercent)) / 2.0
        }
        
        let labelRadius = radius - labelRadiusOffset
        
        var dataSets = data.dataSets
        
        let yValueSum = (data as! PieChartData).yValueSum
        
        let drawEntryLabels = chart.isDrawEntryLabelsEnabled
        let usePercentValuesEnabled = chart.usePercentValuesEnabled
        let entryLabelColor = chart.entryLabelColor
        let entryLabelFont = chart.entryLabelFont
        
        var angle: CGFloat = 0.0
        var xIndex = 0
        
        context.saveGState()
        defer { context.restoreGState() }
        
        for i in 0 ..< dataSets.count
        {
            guard let dataSet = dataSets[i] as? IPieChartDataSet else { continue }
            
            let drawValues = dataSet.isDrawValuesEnabled
            
            if !drawValues && !drawEntryLabels && !dataSet.isDrawIconsEnabled
            {
                continue
            }
            
            let iconsOffset = dataSet.iconsOffset
            
            let xValuePosition = dataSet.xValuePosition
            let yValuePosition = dataSet.yValuePosition
            
            let valueFont = dataSet.valueFont
            let entryLabelFont = dataSet.entryLabelFont
            let lineHeight = valueFont.lineHeight
            
            guard let formatter = dataSet.valueFormatter else { continue }
            
            for j in 0 ..< dataSet.entryCount
            {
                guard let e = dataSet.entryForIndex(j) else { continue }
                let pe = e as? PieChartDataEntry
                
                if xIndex == 0
                {
                    angle = 0.0
                }
                else
                {
                    angle = absoluteAngles[xIndex - 1] * CGFloat(phaseX)
                }
                
                let sliceAngle = drawAngles[xIndex]
                let sliceSpace = getSliceSpace(dataSet: dataSet)
                let sliceSpaceMiddleAngle = sliceSpace / (Math.FDEG2RAD * labelRadius)
                
                // offset needed to center the drawn text in the slice
                let angleOffset = (sliceAngle - sliceSpaceMiddleAngle / 2.0) / 2.0
                
                angle = angle + angleOffset
                
                let transformedAngle = rotationAngle + angle * CGFloat(phaseY)
                
                let value = usePercentValuesEnabled ? e.y / yValueSum * 100.0 : e.y
                
                let valueText: String
                
                let percentOfYValueSum = (e.y / yValueSum * 100.0).roundToTwoDecimalPlaces()
                if percentOfYValueSum < 10.0 {
                    valueText = ""
                }
                else {
                    valueText = formatter.stringForValue(
                        value,
                        entry: e,
                        dataSetIndex: i,
                        viewPortHandler: viewPortHandler
                    )
                }
                
                let labelText = valueText == "" ? "" : pe!.label!
                
                let sliceXBase = cos(transformedAngle * Math.FDEG2RAD)
                let sliceYBase = sin(transformedAngle * Math.FDEG2RAD)
                
                let drawXOutside = drawEntryLabels && xValuePosition == .outsideSlice
                let drawYOutside = drawValues && yValuePosition == .outsideSlice
                let drawXInside = drawEntryLabels && xValuePosition == .insideSlice
                let drawYInside = drawValues && yValuePosition == .insideSlice
                
                let valueTextColor = dataSet.valueTextColorAt(j)
                let entryLabelColor = dataSet.entryLabelColor
                
                if drawXOutside || drawYOutside
                {
                    let valueLineLength1 = dataSet.valueLinePart1Length
                    let valueLineLength2 = dataSet.valueLinePart2Length
                    let valueLinePart1OffsetPercentage = dataSet.valueLinePart1OffsetPercentage
                    
                    var pt2: CGPoint
                    var labelPoint: CGPoint
                    var align: NSTextAlignment
                    
                    var line1Radius: CGFloat
                    
                    if chart.drawHoleEnabled
                    {
                        line1Radius = (radius - (radius * chart.holeRadiusPercent)) * valueLinePart1OffsetPercentage + (radius * chart.holeRadiusPercent)
                    }
                    else
                    {
                        line1Radius = radius * valueLinePart1OffsetPercentage
                    }
                    
                    let polyline2Length = dataSet.valueLineVariableLength
                        ? labelRadius * valueLineLength2 * abs(sin(transformedAngle * Math.FDEG2RAD))
                        : labelRadius * valueLineLength2
                    
                    let pt0 = CGPoint(
                        x: line1Radius * sliceXBase + center.x,
                        y: line1Radius * sliceYBase + center.y)
                    
                    let pt1 = CGPoint(
                        x: labelRadius * (1 + valueLineLength1) * sliceXBase + center.x,
                        y: labelRadius * (1 + valueLineLength1) * sliceYBase + center.y)
                    
                    if transformedAngle.truncatingRemainder(dividingBy: 360.0) >= 90.0 && transformedAngle.truncatingRemainder(dividingBy: 360.0) <= 270.0
                    {
                        pt2 = CGPoint(x: pt1.x - polyline2Length, y: pt1.y)
                        align = .right
                        labelPoint = CGPoint(x: pt2.x - 5, y: pt2.y - lineHeight)
                    }
                    else
                    {
                        pt2 = CGPoint(x: pt1.x + polyline2Length, y: pt1.y)
                        align = .left
                        labelPoint = CGPoint(x: pt2.x + 5, y: pt2.y - lineHeight)
                    }
                    
                    if dataSet.valueLineColor != nil
                    {
                        context.setStrokeColor(dataSet.valueLineColor!.cgColor)
                        context.setLineWidth(dataSet.valueLineWidth)
                        
                        context.move(to: CGPoint(x: pt0.x, y: pt0.y))
                        context.addLine(to: CGPoint(x: pt1.x, y: pt1.y))
                        context.addLine(to: CGPoint(x: pt2.x, y: pt2.y))
                        
                        context.drawPath(using: CGPathDrawingMode.stroke)
                    }
                    
                    if drawXOutside && drawYOutside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: labelPoint,
                            align: align,
                            attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): valueFont, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): valueTextColor]
                        )
                        
                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: labelText,
                                point: CGPoint(x: labelPoint.x, y: labelPoint.y + lineHeight),
                                align: align,
                                attributes: [
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): entryLabelFont ?? valueFont,
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawXOutside
                    {
                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: labelText,
                                point: CGPoint(x: labelPoint.x, y: labelPoint.y + lineHeight / 2.0),
                                align: align,
                                attributes: [
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): entryLabelFont ?? valueFont,
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawYOutside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: CGPoint(x: labelPoint.x, y: labelPoint.y + lineHeight / 2.0),
                            align: align,
                            attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): valueFont, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): valueTextColor]
                        )
                    }
                }
                
                if drawXInside || drawYInside
                {
                    // calculate the text position
                    let x = labelRadius * sliceXBase + center.x
                    let y = labelRadius * sliceYBase + center.y - lineHeight
                    
                    if drawXInside && drawYInside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: CGPoint(x: x, y: y),
                            align: .center,
                            attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): valueFont, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): valueTextColor]
                        )
                        
                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: labelText,
                                point: CGPoint(x: x, y: y + lineHeight),
                                align: .center,
                                attributes: [
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): entryLabelFont ?? valueFont,
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawXInside
                    {
                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: labelText,
                                point: CGPoint(x: x, y: y + lineHeight / 2.0),
                                align: .center,
                                attributes: [
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): entryLabelFont ?? valueFont,
                                    NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawYInside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: CGPoint(x: x, y: y + lineHeight / 2.0),
                            align: .center,
                            attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): valueFont, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): valueTextColor]
                        )
                    }
                }
                
                if let icon = e.icon, dataSet.isDrawIconsEnabled
                {
                    // calculate the icon's position
                    
                    let x = (labelRadius + iconsOffset.y) * sliceXBase + center.x
                    var y = (labelRadius + iconsOffset.y) * sliceYBase + center.y
                    y += iconsOffset.x
                    
                    ChartUtils.drawImage(context: context,
                                         image: icon,
                                         x: x,
                                         y: y,
                                         size: icon.size)
                }
                
                xIndex += 1
            }
        }
    }
    
}
