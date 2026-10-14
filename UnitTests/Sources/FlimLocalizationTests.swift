//
// Copyright 2026 Panu Hällfors
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

@testable import ElementX
import Foundation
import Testing

/// decision 002 — Flim catalog locale resolution + English fallback.
final class FlimLocalizationTests {
    deinit {
        Bundle.overrideLocalizations = nil
    }
    
    @Test
    func englishLookup() {
        Bundle.overrideLocalizations = ["en"]
        
        #expect(FlimL10n.screenNotificationSettingsSoundElementDefault == "Flim Default")
        #expect(FlimL10n.screenNotificationSettingsSoundElementFade == "Flim Fade")
        #expect(FlimL10n.screenRoomTimelineLegacyCall == "Unsupported call. Ask if the caller can use the new Flim app.")
    }
    
    @Test
    func finnishLookup() {
        Bundle.overrideLocalizations = ["fi"]
        
        #expect(FlimL10n.screenNotificationSettingsSoundElementDefault == "Flimin oletus")
        #expect(FlimL10n.screenNotificationSettingsSoundElementFade == "Flim Fade")
        #expect(FlimL10n.screenRoomTimelineLegacyCall == "Puhelua ei tueta. Pyydä soittajaa käyttämään uutta Flim-sovellusta.")
    }
    
    @Test
    func englishFallbackWhenLocaleUnsupported() {
        Bundle.overrideLocalizations = ["xx"]
        
        #expect(FlimL10n.screenNotificationSettingsSoundElementDefault == "Flim Default")
        #expect(FlimL10n.screenNotificationSettingsSoundElementDefault != "screen_notification_settings_sound_element_default")
    }
}
