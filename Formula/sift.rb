class Sift < Formula
  desc "Fast photo/video triage for macOS"
  homepage "https://github.com/zodwick/sift"
  url "https://github.com/zodwick/sift/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "edf2fee6a23fdba6963d4f348cb04177add7122cb250833933afae8deca80985"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Create the app bundle
    app_dir = prefix/"Sift.app/Contents"
    (app_dir/"MacOS").mkpath

    cp ".build/release/Sift", app_dir/"MacOS/Sift"
    cp "Sources/Sift/Info.plist", app_dir/"Info.plist"

    # Also install the binary directly so `sift` works from CLI
    bin.install ".build/release/Sift" => "sift"
  end

  def caveats
    <<~EOS
      To use Sift, run:
        sift ~/Pictures/vacation

      Or open the app bundle:
        open #{prefix}/Sift.app --args ~/Pictures/vacation
    EOS
  end

  test do
    assert_predicate bin/"sift", :executable?
  end
end
