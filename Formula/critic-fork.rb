class Critic < Formula
  desc "Dead simple testing framework for Bash with coverage reporting"
  homepage "https://github.com/j5pu/critic"
  url "https://github.com/j5pu/critic/archive/v0.1.0.tar.gz"
  sha256 "40f71c586c94d408c7a145b94b7a10ba503d04b38c0e906a79c22314007dd86a"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "critic.sh" => "critic"
  end

  test do
    system "true"
  end
end
