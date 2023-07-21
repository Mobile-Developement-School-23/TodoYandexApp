//
//  AssetsAcessor.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import SwiftUI

class AssetsColors {
    static let supportSeparator = Color("SupportSeparator")
    static let supportOverlay = Color("SupportOverlay")
    static let supportNavBarBlur = Color("SupportNavBarBlur")
    static let labelTertiary = Color("LabelTertiary")
    static let labelSecondary = Color("LabelSecondary")
    static let labelPrimary = Color("LabelPrimary")
    static let labelDisable = Color("LabelDisable")
    static let colorWhite = Color("ColorWhite")
    static let colorRed = Color("ColorRed")
    static let colorGreen = Color("ColorGreen")
    static let colorBlue = Color("ColorBlue")
    static let colorGrayLight = Color("ColorGrayLight")
    static let colorGray = Color("ColorGray")
    static let backSecondary = Color("BackSecondary")
    static let backPrimary = Color("BackPrimary")
    static let backIosPrimary = Color("BackIosPrimary")
    static let backElevated = Color("BackElevated")
}

class AssetsFonts {
    static let largeTitle = Font.system(size: 38, weight: .bold)
    static let title = Font.system(size: 20, weight: .semibold)
    static let headline = Font.system(size: 17, weight: .semibold)
    static let body = Font.system(size: 17, weight: .regular)
    static let subhead = Font.system(size: 15, weight: .regular)
    static let boldSubhead = Font.system(size: 15, weight: .semibold)
    static let footnote = Font.system(size: 13, weight: .semibold)
}

//@MainActor
//class AssetsImages {
//    static let gradientImage = UIImage(named: "Gradient")
//    static private(set) var checkedImage = {
//        var configuration = UIImage.SymbolConfiguration(
//            paletteColors: [AssetsColors.colorWhite, AssetsColors.colorGreen])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
//        return UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)!
//    }()
//    static private(set) var invertedCheckedImage = {
//        var configuration = UIImage.SymbolConfiguration(paletteColors:
//                                                            [AssetsColors.colorGreen, AssetsColors.colorWhite])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
//        return UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)!
//    }()
//    static private(set) var defaultCheckmarkImage = {
//        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.supportSeparator])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
//        return UIImage(systemName: "circle", withConfiguration: configuration)!
//    }()
//    static private(set) var errorCheckmarkImage = {
//        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorRed])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
//        return UIImage(systemName: "circle", withConfiguration: configuration)!
//    }()
//
//    static private(set) var exclamationImage = {
//        var config = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorRed])
//        config = config.applying(UIImage.SymbolConfiguration(weight: .bold))
//
//        return UIImage(systemName: "exclamationmark.2",
//                       withConfiguration: config)!.withTintColor(AssetsColors.colorRed, renderingMode: .alwaysOriginal)
//    }()
//
//    static private(set) var arrowDownImage = {
//        return UIImage(systemName: "arrow.down")!.withTintColor(AssetsColors.colorGray, renderingMode: .alwaysOriginal)
//    }()
//
//    static private(set) var infoImage = {
//        var configuration = UIImage.SymbolConfiguration(paletteColors:
//                                                            [AssetsColors.colorGrayLight, AssetsColors.colorWhite])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
//        return UIImage(systemName: "info.circle.fill", withConfiguration: configuration)!
//    }()
//
//    static private(set) var trashImage = {
//        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorWhite])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 24)))
//        return UIImage(systemName: "trash.fill", withConfiguration: configuration)!
//    }()
//
//    static private(set) var caldendarImage = {
//        var configuration = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.labelTertiary])
//            .applying(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15)))
//        return UIImage(systemName: "calendar", withConfiguration: configuration)!
//    }()
//}
