//
// Copyright 2026 Panu Hällfors
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

@testable import ElementX
import Foundation
import Testing

/// decision 011 — Flim public site URLs, OAuth host, telemetry ids, rageshake off.
@MainActor
struct FlimPublicSiteAppSettingsTests {
    let appSettings = AppSettings.volatile()
    
    @Test
    func publicSiteURLsUseFlimMe() throws {
        let flimHost = "flim.me"
        #expect(appSettings.websiteURL.host() == flimHost)
        #expect(appSettings.logoURL.absoluteString == "https://flim.me/mobile-icon.png")
        #expect(appSettings.copyrightURL.host() == flimHost)
        #expect(appSettings.acceptableUseURL.host() == flimHost)
        #expect(appSettings.privacyURL.host() == flimHost)
        #expect(appSettings.encryptionURL.absoluteString == "https://flim.me/help#encryption")
        #expect(appSettings.deviceVerificationURL.absoluteString == "https://flim.me/help#encryption-device-verification")
        #expect(appSettings.chatBackupDetailsURL.absoluteString == "https://flim.me/help#encryption5")
        #expect(appSettings.identityPinningViolationDetailsURL.absoluteString == "https://flim.me/help#encryption18")
        #expect(appSettings.historySharingDetailsURL.absoluteString == "https://flim.me/help#e2ee-history-sharing")
        
        let analyticsTermsURL = try #require(appSettings.analyticsTermsURL)
        #expect(analyticsTermsURL.absoluteString == "https://flim.me/privacy#analytics")
        
        #expect(!appSettings.websiteURL.absoluteString.contains("element.io"))
        #expect(!appSettings.privacyURL.absoluteString.contains("element.io"))
    }
    
    @Test
    func oAuthRedirectUsesFlimMeAndBundleIdentifier() throws {
        let redirectURL = try #require(appSettings.oAuthRedirectURL)
        #expect(redirectURL.host() == "flim.me")
        #expect(redirectURL.path.hasPrefix("/oauth/ios/"))
        #expect(redirectURL.lastPathComponent == InfoPlistReader.main.bundleIdentifier)
        #expect(appSettings.oAuthClientURIPath == "apps/ios")
    }
    
    @Test
    func bugReportApplicationIDIsFlim() {
        #expect(appSettings.bugReportApplicationID == "flim-ios")
    }
    
    @Test
    func rageshakeIsDisabled() {
        #expect(Secrets.rageshakeURL == nil)
        #expect(appSettings.bugReportRageshakeURL.publisher.value == .disabled)
    }
    
    @Test
    func accountProvisioningHostEmptyUntilDecision012() {
        #expect(appSettings.accountProvisioningHost.isEmpty)
    }
    
    @Test
    func elementWebHostsUnchanged() {
        #expect(appSettings.elementWebHosts == ["app.element.io", "staging.element.io", "develop.element.io"])
    }
}
