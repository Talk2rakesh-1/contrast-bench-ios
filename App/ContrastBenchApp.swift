import SwiftUI

@main
struct ContrastBenchApp: App {
  var body: some Scene { WindowGroup { Workbench() } }
}

struct Workbench: View {
  @State private var foreground = "#1A365D"
  @State private var background = "#FFFFFF"
  @State private var sample = "Readable design starts here."

  private var result: ContrastResult? {
    guard let front = try? RGB(hex: foreground), let back = try? RGB(hex: background) else {
      return nil
    }
    return ContrastResult(foreground: front, background: back)
  }

  var body: some View {
    NavigationStack {
      Form {
        Section("Opaque sRGB colors") {
          colorField("Foreground", text: $foreground)
          colorField("Background", text: $background)
          Button("Swap colors", systemImage: "arrow.up.arrow.down") {
            let previous = foreground
            foreground = background
            background = previous
          }.accessibilityIdentifier("swap")
        }
        if let result {
          Section("Text preview") {
            TextField("Sample text", text: $sample)
              .onChange(of: sample) { _, value in sample = String(value.prefix(160)) }
            Text(sample.isEmpty ? "Sample text" : sample)
              .font(.title2).padding().frame(maxWidth: .infinity, minHeight: 100)
              .foregroundStyle(color(result.foreground))
              .background(color(result.background))
              .accessibilityLabel("Color preview: " + sample)
          }
          Section("Contrast results") {
            Text(String(format: "%.4f:1", result.ratio))
              .font(.largeTitle.monospacedDigit()).accessibilityIdentifier("ratio")
            status("AA normal text", passed: result.normalAA, threshold: "4.5:1")
            status("AA large text", passed: result.largeAA, threshold: "3:1")
            status("AAA normal text", passed: result.normalAAA, threshold: "7:1")
            status("AAA large text", passed: result.largeAAA, threshold: "4.5:1")
            ShareLink("Share report", item: result.report)
          }
        } else {
          Section {
            Label(
              "Enter six hexadecimal digits for each color, such as #123ABC.",
              systemImage: "exclamationmark.triangle"
            )
            .accessibilityIdentifier("invalidColor")
          }
        }
        Section("Scope") {
          Text(
            "Results use unrounded ratios. Preview appearance depends on your screen. This checks one opaque sRGB pair, not an entire interface."
          )
          Text(
            "WCAG large text means at least 18pt regular or 14pt bold in its web definition. The preview does not certify text-size eligibility."
          )
          Link(
            "Read the W3C contrast guidance",
            destination: URL(
              string: "https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html")!)
        }
      }.navigationTitle("ContrastBench")
    }
  }

  private func colorField(_ title: String, text: Binding<String>) -> some View {
    LabeledContent(title) {
      TextField(title, text: text).textInputAutocapitalization(.characters)
        .autocorrectionDisabled().keyboardType(.asciiCapable)
        .multilineTextAlignment(.trailing)
        .accessibilityLabel(title).accessibilityIdentifier(title.lowercased())
        .onChange(of: text.wrappedValue) { _, value in text.wrappedValue = String(value.prefix(16))
        }
    }
  }
  private func color(_ value: RGB) -> Color {
    Color(.sRGB, red: value.red, green: value.green, blue: value.blue, opacity: 1)
  }
  private func status(_ title: String, passed: Bool, threshold: String) -> some View {
    LabeledContent(title + " (" + threshold + ")") {
      Text(passed ? "Pass" : "Fail").foregroundStyle(.primary)
    }
  }
}
