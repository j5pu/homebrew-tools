class OptpyTest < Formula
  desc "Python install opt"
  homepage "https://github.com/j5pux/optpy"
  url "https://github.com/j5pux/optpy/archive/main.tar.gz"
  version `#{HOMEBREW_PREFIX}/bin/git ls-remote --refs --tags  --sort='version:refname' \
    https://github.com/python/cpython "v${1:-3.9}.*[!a-z]*" | sed "s|^.*/v||g" | tail -1`.strip
  sha256 `#{HOMEBREW_PREFIX}/bin/wget --quiet -O - "https://github.com/j5pux/optpy/archive/main.tar.gz" | \
    #{HOMEBREW_PREFIX}/bin/sha2 -q -256`.strip
  license "MIT"
  head "https://github.com/j5pux/optpy.git", { branch: "main" }
  # https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
  # https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tar.xz
  # https://www.python.org/ftp/python/3.9.7/python-3.9.7-macosx10.9.pkg
  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end

  pour_bottle? only_if: :clt_installed

  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "bash-completion@2"
  depends_on "bash-git-prompt"
  depends_on "cmake" if OS.mac?
  depends_on "enchant"
  depends_on "gdbm"
  depends_on "gh"
  depends_on "mpdecimal"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "readline"
  depends_on "sha2"
  depends_on "sqlite"
  depends_on "watchman"
  depends_on "wget"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  def install
    # Override the auto-detection in setup.py, which assumes a universal build.
    if OS.mac?
      ENV["PYTHON_DECIMAL_WITH_MACHINE"] = Hardware::CPU.arm? ? "uint128" : "x64"
    end
    ohai version
    bin.install "scripts/optpy" => "optpy"
  end

  test do
    system "test", "-x", "/usr/local/bin/optpy"
  end
end
