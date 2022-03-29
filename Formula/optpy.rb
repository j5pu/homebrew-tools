class Optpy < Formula
  desc "Python install opt"
  homepage "https://github.com/j5pux/optpy"
  url "https://github.com/j5pux/optpy/archive/refs/tags/0.0.1.tar.gz"
  sha256 "e30ea6e4d631ea35bffbd33458c043fc9964f3ee1184c432f0b8ebe14207d4fb"
  license "MIT"

  pour_bottle? only_if: :clt_installed

  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "bash-completion@2"
  depends_on "bash-git-prompt"
  depends_on "enchant"
  depends_on "gdbm"
  depends_on "gh"
  depends_on "git"
  depends_on "mpdecimal"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "watchman"
  depends_on "xz"
  if OS.mac?
    depends_on "cmake"
  end

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  versions = ['3.9.7']

#   resource "wheel" do
#     url "https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tar.xz"
#   end

  def install
    # Override the auto-detection in setup.py, which assumes a universal build.
    if OS.mac?
      ENV["PYTHON_DECIMAL_WITH_MACHINE"] = Hardware::CPU.arm? ? "uint128" : "x64"
    end
  end

  test do
    system "true"
  end
end
