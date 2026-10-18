nonisolated enum Secrets {
    static let sentryDSN: String? = "https://username@sentry.localhost/project_id"
    static let sentryRustDSN: String? = "https://username@sentry.localhost/project_id"
    static let postHogHost: String? = "https://posthog.localhost"
    static let postHogAPIKey: String? = "your_key"
    // decision 011 — rageshake / in-app log upload disabled
    static let rageshakeURL: String? = nil
    static let mapLibreAPIKey: String? = "your_key"
}
