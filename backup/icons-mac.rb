# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class IconsMac < Formula
  desc "MacOS Icons"
  homepage "https://github.com/j5pu/icons-mac"
  url "https://github.com/j5pu/icons-mac/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3f6de953be6069855ba02fdfef5b2a19e01f116b5a5cca088f7545a4d6599889"
  license "MIT"

  def install
    etc.install "icons-mac"
  end

  test do
    system "test", "-d", etc/"icons-mac"
  end
end
