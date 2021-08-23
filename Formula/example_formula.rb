class ExampleFormulaAt39 < Formula
  desc "Example Testing Formula."
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tar.xz"
  sha256 "397920af33efc5b97f2e0b57e91923512ef89fc5b3c1d21dbfc8c4828ce0108a"
  license "MIT"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end
  v = regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  formula_name_list = name.split(/@/)

  ohai "version: '#{v}'"
  ohai "formula_name_list: '#{formula_name_list}'"
  ohai "formula_name: '#{formula_name[0]}'"
  ohai "major_minor: #{version.major_minor}"
  ohai "Formula python: #{Formula['python'].opt_lib}"
  ohai "shared_library: #{shared_library}"
  ohai "lib_cellar: #{lib_cellar}"
  ohai "bin: #{bin}"
  {
    "unversioned" => "versioned3",
  }.each do |unversioned_name, versioned_name|
    ohai "unversioned_name: #{unversioned_name}, versioned_name: #{versioned_name}"
  ohai "#{version.major_minor}"

  script = "/tmp/example_formula_script"
    script.atomic_write <<~EOS
      [install]
      prefix=#{HOMEBREW_PREFIX}
      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOS
  script = bin/"distutils/distutils.cfg"

  def post_install
    inreplace script, /from stdlib import/, "from #{formula_name[0]} import *"
  end

  depends_on "python@3.9"
