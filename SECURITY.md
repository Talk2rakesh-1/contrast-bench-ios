# Security and privacy

The app has no backend, account, telemetry, disk persistence, external packages, or automatic network requests. Only the explicit W3C link opens a browser. Share report sends content through the user-selected system share destination. Reports contain the selected colors, not the user's sample text. Color fields are bounded to 16 characters and sample text to 160; malformed values never reach the calculation.

Review performed: parser bounds, ASCII hex enforcement, finite calculations, no user code execution, no secret storage, and explicit share action. This review and automated scanning do not establish absence of all defects. Physical-device privacy and accessibility checks remain separate from code review.

Report non-sensitive reproducible bugs in Issues. Do not post credentials, personal data, or sensitive exploit details publicly; use GitHub private vulnerability reporting if enabled.
