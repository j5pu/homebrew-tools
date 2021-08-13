class Critic < Formula
  desc "Dead simple testing framework for Bash with coverage reporting"
  homepage "https://github.com/Checksum/critic.sh"
  url "https://github.com/Checksum/critic.sh/archive/995695f61f95a5f5cd08679ede984367841b8238.tar.gz"
  sha256 "4082f5d8ee52116678f637ef30fb069c77771621e067ae177d2358c923aca7a9"
  license "MIT"
  version_scheme 1

  depends_on "bash"

  def install
    bin.install "critic.sh" => "critic"
  end

  test do
    `#{bin}/critic`
  end
end
