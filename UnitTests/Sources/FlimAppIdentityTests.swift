//
// Copyright 2026 Panu Hällfors
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

@testable import ElementX
import Foundation
import Testing

/// decision 000a — interim Flim identity knobs and derived background task ids.
final class FlimAppIdentityTests {
    @Test
    func displayAndProductionNamesAreFlim() {
        #expect(InfoPlistReader.main.bundleDisplayName == "Flim")
        #expect(InfoPlistReader.main.productionAppName == "Flim")
    }
    
    @Test
    func interimBaseBundleIdentifier() {
        #expect(InfoPlistReader.main.baseBundleIdentifier == "me.flim.dev")
        #expect(InfoPlistReader.main.appGroupIdentifier == "group.me.flim.dev")
    }
    
    @Test
    func backgroundTaskIdentifiersDeriveFromBaseBundleIdentifier() {
        let settings = AppSettings(store: VolatileUserDefaults())
        let base = InfoPlistReader.main.baseBundleIdentifier
        #expect(settings.backgroundAppRefreshTaskIdentifier == "\(base).background.refresh")
        #expect(settings.searchBackfillTaskIdentifier == "\(base).background.search-backfill")
    }
}
