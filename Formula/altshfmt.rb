class Altshfmt < Formula
  desc "AltSH (alternative sh script) formatter (support for ShellSpec and shpec syntax)"
  homepage "https://github.com/shellspec/altshfmt"
  url "https://github.com/shellspec/altshfmt/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "196a9ac14a2bc902bcd0569b2f6521a75d868aa589bf251a2aac6b3467454442"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "altshfmt"
  end

  test do
    `#{bin}/altshfmt --help`
  end
end
