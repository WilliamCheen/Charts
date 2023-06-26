//
//  XAxisRendererRadarChart.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

open class XAxisRendererRadarChart: XAxisRenderer
{
    @objc open weak var chart: RadarChartView?
    
    @objc public init(viewPortHandler: ViewPortHandler, axis: XAxis, chart: RadarChartView)
    {
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: nil)
        
        self.chart = chart
    }
    
    open override func renderAxisLabels(context: CGContext)
    {
        guard
            let chart = chart,
            axis.isEnabled,
            axis.isDrawLabelsEnabled
            else { return }

        let labelFont = axis.labelFont
        let labelTextColor = axis.labelTextColor
        let labelRotationAngleRadians = axis.labelRotationAngle.RAD2DEG
        let drawLabelAnchor = CGPoint(x: 0.5, y: 0.25)
        let labelBackgroundColor = axis.labelBackgroundColor
        let labelBackgroundInset = axis.labelBackgroundInset
        
        let sliceangle = chart.sliceAngle
        
        // calculate the factor that is needed for transforming the value to pixels
        let factor = chart.factor
        
        let center = chart.centerOffsets
        
        let bgHorizon = labelBackgroundInset.left + labelBackgroundInset.right
        let bgVertical = labelBackgroundInset.top + labelBackgroundInset.bottom
        
        for i in 0..<(chart.data?.maxEntryCountSet?.entryCount ?? 0)
        {
            let label = axis.valueFormatter?.stringForValue(Double(i), axis: axis) ?? ""
            let angle = (sliceangle * CGFloat(i) + chart.rotationAngle).truncatingRemainder(dividingBy: 360.0)
            let p = center.moving(distance: CGFloat(chart.yRange) * factor + axis.labelRotatedWidth / 2.0, atAngle: angle)
            
            let bgX = p.x - axis.labelRotatedWidth / 2.0 - labelBackgroundInset.left
            let bgY = p.y - axis.labelHeight * 0.65 - labelBackgroundInset.top
            let bgW = axis.labelWidth
            let bgFrame = CGRectMake(bgX, bgY, axis.labelRotatedWidth + bgHorizon, axis.labelRotatedHeight + bgVertical)
            let path = UIBezierPath(roundedRect: bgFrame, cornerRadius: 2).cgPath
            context.addPath(path)
            context.setFillColor(labelBackgroundColor.cgColor)
            context.fillPath()
            

            drawLabel(context: context,
                      formattedLabel: label,
                      x: p.x,
                      y: p.y - axis.labelRotatedHeight / 2.0,
                      attributes: [.font: labelFont, .foregroundColor: labelTextColor],
                      anchor: drawLabelAnchor,
                      angleRadians: labelRotationAngleRadians)
        }
    }
    
    @objc open func drawLabel(
        context: CGContext,
        formattedLabel: String,
        x: CGFloat,
        y: CGFloat,
        attributes: [NSAttributedString.Key : Any],
        anchor: CGPoint,
        angleRadians: CGFloat)
    {
        context.drawText(formattedLabel,
                         at: CGPoint(x: x, y: y),
                         anchor: anchor,
                         angleRadians: angleRadians,
                         attributes: attributes)
    }
    
    open override func renderLimitLines(context: CGContext)
    {
        /// XAxis LimitLines on RadarChart not yet supported.
    }
}
