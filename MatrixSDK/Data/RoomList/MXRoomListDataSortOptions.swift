// 
// Copyright 2021 The Matrix.org Foundation C.I.C
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

@objcMembers
/// Sort options to be used with fetch options. See `MXRoomListDataFetchOptions`.
public final class MXRoomListDataSortOptions: NSObject {
    /// Weak reference to the fetch options
    internal weak var fetchOptions: MXRoomListDataFetchOptions?
    
    /// Flag to sort by suggested room flag: suggested rooms will come later
    /// Related fetcher will be refreshed automatically when updated.
    public var suggested: Bool {
        didSet {
            if suggested != oldValue {
                refreshFetcher()
            }
        }
    }
    /// Flag to sort by invite status: invited rooms will come first
    /// Related fetcher will be refreshed automatically when updated.
    public var invitesFirst: Bool {
        didSet {
            if invitesFirst != oldValue {
                refreshFetcher()
            }
        }
    }
    /// Flag to sort by sent status: rooms having unsent messages will come first
    /// Related fetcher will be refreshed automatically when updated.
    public var sentStatus: Bool {
        didSet {
            if sentStatus != oldValue {
                refreshFetcher()
            }
        }
    }
    /// Flag to sort by last event date: most recent rooms will come first
    /// Related fetcher will be refreshed automatically when updated.
    public var lastEventDate: Bool {
        didSet {
            if lastEventDate != oldValue {
                refreshFetcher()
            }
        }
    }
    /// Flag to sort by favorite tag order: rooms having "bigger" tags will come first
    /// Related fetcher will be refreshed automatically when updated.
    public var favoriteTag: Bool {
        didSet {
            if favoriteTag != oldValue {
                refreshFetcher()
            }
        }
    }
    /// Flag to sort by missed notifications count: rooms having more missed notification count will come first
    /// Related fetcher will be refreshed automatically when updated.
    public var missedNotificationsFirst: Bool {
        didSet {
            if missedNotificationsFirst != oldValue {
                refreshFetcher()
            }
        }
    }
    /// Flag to sort by unread count: rooms having unread messages will come first
    /// Related fetcher will be refreshed automatically when updated.
    public var unreadMessagesFirst: Bool {
        didSet {
            if unreadMessagesFirst != oldValue {
                refreshFetcher()
            }
        }
    }
    
    /// Initializer
    /// - Parameters:
    ///   - sentStatus: flag to sort by sent status
    ///   - lastEventDate: flag to sort by last event date
    ///   - missedNotificationsFirst: flag to sort by missed notification count
    ///   - unreadMessagesFirst: flag to sort by unread count
    public init(invitesFirst: Bool = true,
                sentStatus: Bool = true,
                lastEventDate: Bool = true,
                favoriteTag: Bool = false,
                suggested: Bool = true,
                missedNotificationsFirst: Bool,
                unreadMessagesFirst: Bool) {
        self.invitesFirst = invitesFirst
        self.sentStatus = sentStatus
        self.lastEventDate = lastEventDate
        self.favoriteTag = favoriteTag
        self.suggested = suggested
        self.missedNotificationsFirst = missedNotificationsFirst
        self.unreadMessagesFirst = unreadMessagesFirst
        super.init()
    }
    
    /// Just to be used for in-memory data
    internal func sortRooms(_ rooms: [MXRoomSummaryProtocol]) -> [MXRoomSummaryProtocol] {
        return (rooms as NSArray).sortedArray(using: sortDescriptors) as! [MXRoomSummaryProtocol]
    }
    
    /// To be used for CoreData fetch request
    internal var sortDescriptors: [NSSortDescriptor] {
        var result: [NSSortDescriptor] = []
        
        if suggested {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.spaceChildInfo?.order, ascending: false))
        }
        
        if invitesFirst {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.membership, ascending: true))
        }
        
        if sentStatus {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.sentStatus, ascending: false))
        }
        
        if missedNotificationsFirst {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.highlightCount, ascending: false))
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.notificationCount, ascending: false))
        }
        
        if unreadMessagesFirst {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.localUnreadEventCount, ascending: false))
        }
        
        if lastEventDate {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.lastMessage?.originServerTs, ascending: false))
        }
        
        if favoriteTag {
            result.append(NSSortDescriptor(keyPath: \MXRoomSummaryProtocol.favoriteTagOrder, ascending: false))
        }
        
        return result
    }
    
    /// Refresh fetcher after updates
    private func refreshFetcher() {
        guard let fetcher = fetchOptions?.fetcher else {
            return
        }
        fetcher.refresh()
    }
}
