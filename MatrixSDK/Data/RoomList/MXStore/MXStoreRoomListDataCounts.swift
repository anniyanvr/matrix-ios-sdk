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
internal class MXStoreRoomListDataCounts: NSObject, MXRoomListDataCounts {
    
    let numberOfRooms: Int
    let numberOfUnsentRooms: Int
    let numberOfNotifiedRooms: Int
    let numberOfHighlightedRooms: Int
    let numberOfNotifications: UInt
    let numberOfHighlights: UInt
    let numberOfInvitedRooms: Int
    let totalRoomsCount: Int
    
    init(withRooms rooms: [MXRoomSummaryProtocol],
         totalRoomsCount: Int) {
        var numberOfInvitedRooms: Int = 0
        var numberOfUnsentRooms: Int = 0
        var numberOfNotifiedRooms: Int = 0
        var numberOfHighlightedRooms: Int = 0
        var numberOfNotifications: UInt = 0
        var numberOfHighlights: UInt = 0
        
        rooms.forEach { summary in
            if summary.isTyped(.invited) {
                numberOfInvitedRooms += 1
            }
            if summary.sentStatus != .ok {
                numberOfUnsentRooms += 1
            }
            if summary.notificationCount > 0 {
                numberOfNotifiedRooms += 1
                numberOfNotifications += summary.notificationCount
            }
            if summary.highlightCount > 0 {
                numberOfHighlightedRooms += 1
                numberOfHighlights += summary.highlightCount
            }
        }
        
        self.numberOfRooms = rooms.count
        self.numberOfInvitedRooms = numberOfInvitedRooms
        self.numberOfUnsentRooms = numberOfUnsentRooms
        self.numberOfNotifiedRooms = numberOfNotifiedRooms + numberOfInvitedRooms
        self.numberOfHighlightedRooms = numberOfHighlightedRooms
        self.numberOfNotifications = numberOfNotifications
        self.numberOfHighlights = numberOfHighlights
        self.totalRoomsCount = totalRoomsCount
        super.init()
    }

}
