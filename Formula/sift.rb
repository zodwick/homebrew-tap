class Sift < Formula
  desc "Fast photo/video triage for macOS"
  homepage "https://github.com/zodwick/sift"
  url "https://github.com/zodwick/sift/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "94b26eb4209a5a97dc6632d98e0582eb075acd9247500233672c3125d6986572"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Create the app bundle
    app_dir = prefix/"Sift.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath

    cp ".build/release/Sift", app_dir/"MacOS/Sift"
    cp "Sources/Sift/Info.plist", app_dir/"Info.plist"
    cp "Sources/Sift/AppIcon.icns", app_dir/"Resources/AppIcon.icns"

    # Also install the binary directly so `sift` works from CLI
    bin.install ".build/release/Sift" => "sift"
  end

  def post_install
    # Symlink to ~/Applications so Spotlight and Launchpad can find it
    user_apps = Pathname.new(Dir.home)/"Applications"
    user_apps.mkpath
    ln_sf prefix/"Sift.app", user_apps/"Sift.app"
  end

  def caveats
    <<~EOS
      Sift.app has been linked to ~/Applications for Spotlight and Launchpad.

      Usage:
        sift ~/Pictures/vacation

      Or open the app:
        open ~/Applications/Sift.app --args ~/Pictures/vacation
    EOS
  end

  test do
    assert_predicate bin/"sift", :executable?
  end
end
