class Dev < Formula
  desc "Stdlib module and development dependencies installed in python stdlib."
  homepage "https://www.python.org/"
  # Keep in sync with python-tk@3.9.
  url "https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tar.xz"
  sha256 "397920af33efc5b97f2e0b57e91923512ef89fc5b3c1d21dbfc8c4828ce0108a"
  license "MIT"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end

  depends_on "python@3.9"

end
