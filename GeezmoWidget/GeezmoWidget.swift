//
//  GeezmoWidget.swift
//  GeezmoWidget
//
//  Created by Ярослав Седышев on 18.07.2024.
//


import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct GeezmoWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            Color(UIColor(named: "WidgetBackground")!)
            Image("moteWatchAppWidgetIcon")
                .resizable()
                .scaledToFill()
        }
    }
}

@main
struct MoteWidget: Widget {
    let kind: String = "MoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GeezmoWidgetEntryView(entry: entry)
                .containerBackground(.widgetBackground, for: .widget)
        }
        .configurationDisplayName("Geezmo Widget")
        .description("Geezmo Watch App Widget")
        .supportedFamilies([.accessoryCircular])
    }
}

#Preview(as: .accessoryCircular) {
    MoteWidget()
} timeline: {
    SimpleEntry(date: .now)
}
