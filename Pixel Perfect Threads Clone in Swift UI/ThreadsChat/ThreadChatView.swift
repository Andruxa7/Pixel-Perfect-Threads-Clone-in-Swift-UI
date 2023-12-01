//
//  ThreadChatView.swift
//  ThreadsChat
//
//  Created by Andrii Stetsenko on 02.11.2023.
//

import SwiftUI

import StreamChat
import StreamChatSwiftUI

struct ThreadChatView: View {
    @Injected(\.chatClient) var chatClient
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some View {
        ChatChannelView(
            viewFactory: DefaultViewFactory.shared,
            channelController: chatClient.channelController(
                            for: try! ChannelId(cid: "messaging:my-channel-id"),
                            messageOrdering: .topToBottom
                        )
                        )

    }
}

struct ThreadChatView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadChatView()
    }
}
