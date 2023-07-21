//
//  TodoListItem.swift
//  TodoYandexAppModern
//
//  Created by Илья Колесников on 19.07.23.
//

import SwiftUI

struct TodoListItem: View {
    private let calendarImage: some View = Text(
        Image(systemName: "calendar"))
        .foregroundColor(AssetsColors.labelTertiary)
        .baselineOffset(1)
        .font(.system(size: 13))
    
    private let importanceImage: some View = Text(
        Image(systemName: "exclamationmark.2"))
        .foregroundColor(AssetsColors.colorRed)
        .baselineOffset(1)
        .fontWeight(.bold)
        .font(.system(size: 15))
    
    private let lowImportanceImage: some View = Text(
        Image(systemName: "arrow.down"))
        .foregroundColor(AssetsColors.colorGray)
        .baselineOffset(1)
        .font(.system(size: 15))
    
    @State
    var data: TodoListItemData
    
    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(data: TodoListItemData) {
        _data = State(initialValue: data)
    }
    
    var body: some View {
        HStack {
            TodoCheckbox(
                isChecked: data.done, isError: data.importance == .important
            )
            .font(.system(size: 24))
            VStack(alignment: .leading) {
                ((getImportanceText()) + Text(data.text))
                    .foregroundColor(getTextColor())
                    .font(AssetsFonts.body)
                    .lineLimit(3)
                
                if let date = data.deadline {
                    (calendarImage as! Text + Text(" ") + Text(dateFormatter.string(from: date)))
                        .font(AssetsFonts.subhead)
                        .foregroundColor(AssetsColors.labelTertiary)
                }
            }
        }
    }
    
    private func getTextColor() -> Color {
        if let color = data.color, let uiColor = UIColor(hexString: color) {
            return Color(uiColor)
        }
        
        return AssetsColors.labelPrimary
    }
    
    private func getImportanceText() -> Text {
        if data.importance == .important {
            return (importanceImage as! Text + Text(" "))
        } else if data.importance == .low {
            return (lowImportanceImage as! Text + Text(" "))
        }
        
        return Text("")
    }
}

struct TodoListItem_Previews: PreviewProvider {
    static let previewData = TodoListItemData(id: "123", text: "Some text",
                                              importance: .important, done: true,
                                              color: "#1f65fe",
                                              deadline: Date.now.addingTimeInterval(700000))
    static var previews: some View {
        TodoListItem(data: previewData)
    }
}
