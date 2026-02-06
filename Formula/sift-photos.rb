class SiftPhotos < Formula
  desc "Fast photo/video triage for macOS"
  homepage "https://github.com/zodwick/sift"
  url "https://github.com/zodwick/sift/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "97342894baff8ac718bad9ae865cbe14b98018638baccfeeb0f591cc1c554587"
  license "MIT"

  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Create the app bundle
    app_dir = prefix/"Sift.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath

    cp ".build/release/Sift", app_dir/"MacOS/Sift"
    cp "Sources/Sift/Info.plist", app_dir/"Info.plist"
    cp "Sources/Sift/AppIcon.icns", app_dir/"Resources/AppIcon.icns"

    # CLI binary
    bin.install ".build/release/Sift" => "sift-photos"
  end

  def caveats
    <<~EOS
      To add Sift to Spotlight and Launchpad, run:
        cp -R #{prefix}/Sift.app ~/Applications/
        open ~/Applications/Sift.app

      Usage:
        sift-photos ~/Pictures/vacation
        open ~/Applications/Sift.app --args ~/Pictures/vacation
    EOS
  end

  test do
    assert_predicate bin/"sift-photos", :executable?
  end
end
