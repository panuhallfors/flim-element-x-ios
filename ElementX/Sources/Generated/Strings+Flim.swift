// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
// Flim catalog (decision 002). Regenerate via: swiftgen config run --config Tools/SwiftGen/swiftgen-config.yml

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal nonisolated enum FlimL10n {
  /// Flim Default
  internal static var screenNotificationSettingsSoundElementDefault: String { return FlimL10n.tr("Flim", "screen_notification_settings_sound_element_default") }
  /// Flim Fade
  internal static var screenNotificationSettingsSoundElementFade: String { return FlimL10n.tr("Flim", "screen_notification_settings_sound_element_fade") }
  /// Unsupported call. Ask if the caller can use the new Flim app.
  internal static var screenRoomTimelineLegacyCall: String { return FlimL10n.tr("Flim", "screen_room_timeline_legacy_call") }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

nonisolated extension FlimL10n {
  static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // Use preferredLocalizations to get a language that is in the bundle and the user's preferred list of languages.
    let languages = Bundle.overrideLocalizations ?? Bundle.app.preferredLocalizations

    for language in languages {
      if let translation = trIn(language, table, key, args) {
        return translation
      }
    }
    return Bundle.app.developmentLocalization.flatMap { trIn($0, table, key, args) } ?? key
  }

  private static func trIn(_ language: String, _ table: String, _ key: String, _ args: CVarArg...) -> String? {
    guard let bundle = Bundle.lprojBundle(for: language) else { return nil }
    let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    let translation = String(format: format, locale: Locale(identifier: language), arguments: args)
    guard translation != key,
          translation != "\(key) \(key)" // Handle double pseudo for tests
    else {
      return nil
    }
    return translation
  }
}

// swiftlint:enable all
