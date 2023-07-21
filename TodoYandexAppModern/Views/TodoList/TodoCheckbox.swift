//
//  TodoCheckbox.swift
//  TodoYandexAppModern
//
//  Created by Илья Колесников on 21.07.23.
//

import SwiftUI

struct TodoCheckbox: View {
    init(isChecked: Bool = false, isError: Bool = false) {
        _isChecked = State(initialValue: isChecked)
        _isError = State(initialValue:isError)
    }
    
    private var checkedImage: some View = Image(systemName: "checkmark.circle.fill")
        .symbolRenderingMode(.palette)
        .foregroundStyle(AssetsColors.colorWhite, AssetsColors.colorGreen)
    
    private var uncheckedImage: some View = Image(systemName: "circle")
        .symbolRenderingMode(.palette)
        .foregroundStyle(AssetsColors.supportSeparator)
    
    private var errorImage: some View = Image(systemName: "circle")
        .symbolRenderingMode(.palette)
        .foregroundStyle(AssetsColors.colorRed)
    
    @State
    var isChecked: Bool
    
    @State
    var isError: Bool
    
    var body: some View {
        ZStack {
            if isChecked {
                checkedImage.onTapGesture(perform: onClick)
            } else {
                if isError {
                    errorImage.onTapGesture(perform: onClick)
                } else {
                    uncheckedImage.onTapGesture(perform: onClick)
                }
            }
        }
    }
    
    private func onClick() {
        let val = isChecked
        isChecked = !val
    }
}

struct TodoCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        TodoCheckbox()
    }
}
