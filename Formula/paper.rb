class Paper < Formula
  desc "Wall Paper changer and Wall Papers"
  homepage "https://github.com/j5pu/paper"
  url "https://github.com/j5pu/paper/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "26eb54ad771ab22d9a082ed0257c6663b653f8cb908289b33d202d919b6a5174"
  license "MIT"

  on_macos do
    depends_on "wallpaper"

    def install
      etc.install paper
      etc.install profile.d
    end

    test do
      `#{etc}/profile.d/paper.sh`
    end
  end
