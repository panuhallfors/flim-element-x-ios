//
// Copyright 2026 Panu Hällfors
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
@testable import ElementX
import Foundation
import SwiftUI
import Testing

/// decision 011 — Element Call must not receive Element's PostHog/Sentry config.
@MainActor
struct FlimElementCallAnalyticsTests {
    @Test
    func elementCallStartsWithoutAnalyticsConfigurationEvenWhenOptedIn() async throws {
        let clientProxy = ClientProxyMock()
        clientProxy.deviceID = "call-device-id"
        
        let roomProxy = JoinedRoomProxyMock()
        let widgetDriver = ElementCallWidgetDriverMock()
        widgetDriver.messagePublisher = .init()
        widgetDriver.actions = PassthroughSubject<ElementCallWidgetDriverAction, Never>().eraseToAnyPublisher()
        widgetDriver.startBaseURLClientIDColorSchemeVoiceOnlyRageshakeURLAnalyticsConfigurationReturnValue = .success(.userDirectory)
        roomProxy.elementCallWidgetDriverDeviceIDReturnValue = widgetDriver
        
        let analyticsService = AnalyticsServiceMock(.init(isEnabled: true))
        
        _ = CallScreenViewModel(elementCallService: ElementCallServiceMock(.init()),
                                configuration: .init(roomProxy: roomProxy,
                                                     clientProxy: clientProxy,
                                                     clientID: "me.flim.dev",
                                                     elementCallBaseURL: "https://call.element.io",
                                                     elementCallBaseURLOverride: nil,
                                                     voiceOnly: false,
                                                     colorScheme: .light),
                                allowPictureInPicture: false,
                                userSettings: .mock(),
                                analyticsService: analyticsService)
        
        for _ in 0..<50 {
            if widgetDriver.startBaseURLClientIDColorSchemeVoiceOnlyRageshakeURLAnalyticsConfigurationCalled {
                break
            }
            try await Task.sleep(for: .milliseconds(20))
        }
        
        #expect(widgetDriver.startBaseURLClientIDColorSchemeVoiceOnlyRageshakeURLAnalyticsConfigurationCalled)
        let arguments = try #require(widgetDriver.startBaseURLClientIDColorSchemeVoiceOnlyRageshakeURLAnalyticsConfigurationReceivedArguments)
        #expect(arguments.analyticsConfiguration == nil)
    }
}
