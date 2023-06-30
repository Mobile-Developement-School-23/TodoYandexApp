//
//  AssetsAcessor.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class AssetsColors {
    static let supportSeparator = UIColor(named: "SupportSeparator")!
    static let supportOverlay = UIColor(named: "SupportOverlay")!
    static let supportNavBarBlur = UIColor(named: "SupportNavBarBlur")!
    static let labelTertiary = UIColor(named: "LabelTertiary")!
    static let labelSecondary = UIColor(named: "LabelSecondary")!
    static let labelPrimary = UIColor(named: "LabelPrimary")!
    static let labelDisable = UIColor(named: "LabelDisable")!
    static let colorWhite = UIColor(named: "ColorWhite")!
    static let colorRed = UIColor(named: "ColorRed")!
    static let colorGreen = UIColor(named: "ColorGreen")!
    static let colorBlue = UIColor(named: "ColorBlue")!
    static let colorGrayLight = UIColor(named: "ColorGrayLight")!
    static let colorGray = UIColor(named: "ColorGray")!
    static let backSecondary = UIColor(named: "BackSecondary")!
    static let backPrimary = UIColor(named: "BackPrimary")!
    static let backIosPrimary = UIColor(named: "BackIosPrimary")!
    static let backElevated = UIColor(named: "BackElevated")!
}

class AssetsFonts {
    static let largeTitle = UIFont.systemFont(ofSize: 38, weight: .bold)
    static let title = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let subhead = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let boldSubhead = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let footnote = UIFont.systemFont(ofSize: 13, weight: .semibold)
}

class AssetsImages {
    static let gradientImage = UIImage(named: "Gradient")
    static var checkedImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorWhite, AssetsColors.colorGreen])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
        return UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)!
    }()
    static var invertedCheckedImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorGreen, AssetsColors.colorWhite])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
        return UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)!
    }()
    static var defaultCheckmarkImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.supportSeparator])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
        return UIImage(systemName: "circle", withConfiguration: configuration)!
    }()
    static var errorCheckmarkImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorRed])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
        return UIImage(systemName: "circle", withConfiguration: configuration)!
    }()
    
    static var exclamationImage = {
        var config = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorRed])
        config = config.applying(UIImage.SymbolConfiguration(weight: .bold))
        
        return UIImage(systemName: "exclamationmark.2", withConfiguration: config)!.withTintColor(AssetsColors.colorRed, renderingMode: .alwaysOriginal)
    }()
    
    static var arrowDownImage = {
        return UIImage(systemName: "arrow.down")!.withTintColor(AssetsColors.colorGray, renderingMode: .alwaysOriginal)
    }()
    
    static var infoImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorGrayLight, AssetsColors.colorWhite])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
        return UIImage(systemName: "info.circle.fill", withConfiguration: configuration)!
    }()
    
    static var trashImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorWhite])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
        return UIImage(systemName: "trash.fill", withConfiguration: configuration)!
    }()
    
    static var caldendarImage = {
        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.labelTertiary])
            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15)))
        return UIImage(systemName: "calendar", withConfiguration: configuration)!
    }()
}
