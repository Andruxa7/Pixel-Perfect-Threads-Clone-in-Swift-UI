//
//  SegmentedPickerView.swift
//  ThreadsChat
//
//  Created by Andrii Stetsenko on 04.10.2023.
//

import SwiftUI

struct SegmentedPickerView<Element, Content, Selection>: View
    where
    Content: View,
    Selection: View {
        
        public typealias Data = [Element]
        
        @State private var frames: [CGRect]
        @Binding private var selectedIndex: Data.Index?
        
        private let data: Data
        private let selection: () -> Selection
        private let content: (Data.Element, Bool) -> Content
        
        public init(_ data: Data,
                    selectedIndex: Binding<Data.Index?>,
                    @ViewBuilder content: @escaping (Data.Element, Bool) -> Content,
                    @ViewBuilder selection: @escaping () -> Selection) {
            
            self.data = data
            self.content = content
            self.selection = selection
            self._selectedIndex = selectedIndex
            self._frames = State(wrappedValue: Array(repeating: .zero,
                                                     count: data.count))
        }
        
        public var body: some View {
            ZStack(alignment: Alignment(horizontal: .horizontalCenterAlignment,
                                        vertical: .center)) {
                
                HStack(spacing: 0) {
                    ForEach(data.indices, id: \.self) { index in
                        Button(action: { selectedIndex = index },
                               label: { content(data[index], selectedIndex == index) }
                        )
                        .buttonStyle(PlainButtonStyle())
                        .background(GeometryReader { proxy in
                            Color.clear.onAppear { frames[index] = proxy.frame(in: .global) }
                        })
                        .alignmentGuide(.horizontalCenterAlignment,
                                        isActive: selectedIndex == index) { dimensions in
                            dimensions[HorizontalAlignment.center]
                        }
                    }
                }
                
                if let selectedIndex = selectedIndex {
                    selection()
                        .frame(width: frames[selectedIndex].width,
                               height: frames[selectedIndex].height)
                        .alignmentGuide(.horizontalCenterAlignment) { dimensions in
                            dimensions[HorizontalAlignment.center]
                        }
                }
            }
        }
}

extension HorizontalAlignment {
    private enum CenterAlignmentID: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            return dimension[HorizontalAlignment.center]
        }
    }
    
    static var horizontalCenterAlignment: HorizontalAlignment {
        HorizontalAlignment(CenterAlignmentID.self)
    }
}

extension View {
    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: HorizontalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }
    
    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: VerticalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }
}

struct SegmentedPickerViewPreviewHelperView: View {
    @State private var selectedColorIndex = 0
    
    let titles = ["Threads", "Replies", "Reposts"]
    @State var selectedIndex: Int?
    
    var body: some View {
        SegmentedPickerView(
            titles,
            selectedIndex: Binding(
                get: { selectedIndex },
                set: { selectedIndex = $0 }),
            content: { item, isSelected in
                VStack {
                    Text(item)
                        .foregroundColor(isSelected ? Color("primaryThreads") : Color.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                    Color.gray.frame(height: 1)
                }
            },
            selection: {
                VStack(spacing: 0) {
                    Spacer()
                    Color.primary.frame(height: 1)
                }
            })
        .onAppear {
            selectedIndex = 0
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
    }
}

struct SegmentedPickerView_Previews: PreviewProvider {
    @State var selectedIndex: Int = 0
    static var previews: some View {
        SegmentedPickerViewPreviewHelperView()
    }
}
