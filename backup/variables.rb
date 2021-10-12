class Variables < Formula
  desc "Python install opt"
  homepage "https://github.com/j5pux/optpy"
  url "https://github.com/j5pux/optpy/archive/refs/tags/0.0.1.tar.gz"
  sha256 "e30ea6e4d631ea35bffbd33458c043fc9964f3ee1184c432f0b8ebe14207d4fb"
  license "MIT"

  pour_bottle? only_if: :clt_installed

  opoo "============================================================================================================="
  opoo "Variables: during audit el pwd es donde ejecuto y no me sale el Tap."

  opoo "============================================================================================================="
  opoo "Variables: from livecheck"
  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end
  ohai "livecheck python latest 3.9 version: #{livecheck}"

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
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  _v = '3.9.7'
  _r = "Python-#{_v}"
  _url = "https://www.python.org/ftp/python/#{_v}/#{_r}.tar.xz"
  _sha = `/usr/local/bin/wget --quiet -O - "#{_url}" | /usr/local/bin/sha2 -q -256`.strip
  ohai "url: #{_url}, sha: #{_sha}"
  #   resource "Python-3.9.7" do
  #     url "#{_url}"
  #     sha256 "#{_sha}"
  #   end
  #   resource "Python-3.9.7" do
  #     url "https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tar.xz"
  #     sha256 "f8145616e68c00041d1a6399b76387390388f8359581abc24432bb969b5e3c57"
  #   end
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/db/e2/c0ced9ccffb61432305665c22842ea120c0f649eec47ecf2a45c596707c4/setuptools-57.4.0.tar.gz"
    sha256 "6bac238ffdf24e8806c61440e755192470352850f3419a52f26ffe0a1a64f465"
  end
  opoo "============================================================================================================="
  opoo "Variables: resource"
  ohai "url: #{_url}, sha: #{_sha}"

  opoo "============================================================================================================="
  opoo "Variables: open3 (it could also read files) and `"
  # https://www.honeybadger.io/blog/capturing-stdout-stderr-from-shell-commands-via-ruby/
  require "open3"
  stdout, = Open3.capture3("pwd")
  ohai "pwd (capture3) strip: '#{stdout.strip}'"
  ohai "pwd (capture3) gsub: #{stdout.delete('\n')}"
  ohai "pwd (`): '#{`pwd`}'"
  puts "ls /Users/Shared (`): '#{`ls /Users/Shared`}'"

  opoo "============================================================================================================="
  opoo "Variables: bump-formula-pr"
  #   ohai "system 'bump-formula-pr' ...: #{`/usr/local/bin/brew bump-formula-pr --debug --verbose --tag 0.0.2 --write
  #  --commit --strict --online --no-browse --no-fork --message 'Version bumped' optpy`}"

  opoo "============================================================================================================="
  opoo "Formula: Instance Attributes"
  ohai "build: '#{build}'"

  ohai "full_names: '#{full_names}'"
  ohai "name: '#{name}', name_split_arroba: '#{name.split(/@/)}'"
  #   ohai "path: '#{path}'"
  ohai "paths: '#{paths}'"
  ohai "revision: '#{revision}'"
  ohai "version_scheme: '#{version_scheme}'"

  opoo "============================================================================================================="
  opoo "Formula: Instance Method Details"
  ohai "aliases: '#{aliases}'"
  ohai "deprecated?: '#{deprecated?}'"
  ohai "deprecation_reason: '#{deprecation_reason}'"
  ohai "desc: '#{desc}'"
  ohai "disabled?: '#{disabled?}'"
  ohai "homepage: '#{homepage}'"
  ohai "license: #{license}"
  ohai "livecheckable?: #{livecheckable?}"
  ohai "paths: #{paths}"
  ohai "@paths: #{@paths}"
  ohai "service: #{service}"
  ohai "service?: #{service?}"
  ohai "to_s: #{self}"
  ohai "version: #{version}"
  ohai "version_major: '#{version.major}'"
  ohai "version_minor: '#{version.minor}'"
  ohai "version_major_minor: #{version.major_minor}"

  opoo "============================================================================================================="
  opoo "Python Formula: Instance Method Details"
  python_formula = Formula["python"]
  ohai "python_formula: #{python_formula}"
  ohai "python_formula_active_log_prefix: #{python_formula.active_log_prefix}"
  ohai "python_formula_alias_changed: '#{python_formula.alias_changed?}'"
  ohai "python_formula_alias_name: '#{python_formula.alias_name}'"
  ohai "python_formula_alias_path: '#{python_formula.alias_path}'"
  ohai "buildpath: '#{python_formula.buildpath}'"

  ohai "python_formula_any_installed_prefix: '#{python_formula.any_installed_prefix}'"
  ohai "python_formula_any_installed_version: '#{python_formula.any_installed_version}'"
  ohai "python_formula_bash_completion: '#{python_formula.bash_completion}'"
  ohai "python_formula_bin: #{python_formula.bin} == {python_formula.prefix}/bin: #{python_formula.prefix}/bin"
  ohai "python_formula_bottle: '#{python_formula.bottle}'"
  puts "python_formula_bottle_hash: '#{python_formula.bottle_hash}'"
  ohai "python_formula_bottle_tab_attributes: '#{python_formula.bottle_tab_attributes}'"
  ohai "python_formula_buildpath: '#{python_formula.buildpath}'"
  ohai "python_formula_caveats: '#{python_formula.caveats}'"
  ohai "python_formula_current_installed_alias_target: '#{python_formula.current_installed_alias_target}'"
  ohai "python_formula_deprecated?: '#{python_formula.deprecated?}'"
  ohai "python_formula_deprecation_reason: '#{python_formula.deprecation_reason}'"
  ohai "python_formula_desc: '#{python_formula.desc}'"
  ohai "python_formula_disabled?: '#{python_formula.disabled?}'"
  ohai "python_formula_doc: '#{python_formula.doc}'"
  ohai "python_formula_etc: '#{python_formula.etc}'"
  ohai "python_formula_follow_installed_alias: '#{python_formula.follow_installed_alias}'"
  ohai "python_formula_full_alias_name: '#{python_formula.full_alias_name}'"
  ohai "python_formula_full_installed_alias_name: '#{python_formula.full_installed_alias_name}'"
  ohai "python_formula_full_installed_specified_name: '#{python_formula.full_installed_specified_name}'"
  ohai "python_formula_full_name: '#{python_formula.full_name}'"
  ohai "python_formula_homepage: '#{python_formula.homepage}'"
  ohai "python_formula_include: #{python_formula.include}"
  ohai "python_formula_info: '#{python_formula.info}'"
  ohai "python_formula_installed_alias_name: '#{python_formula.installed_alias_name}'"
  ohai "python_formula_installed_alias_path: '#{python_formula.installed_alias_path}'"
  ohai "python_formula_installed_alias_target_changed?: '#{python_formula.installed_alias_target_changed?}'"
  ohai "python_formula_installed_specified_name: '#{python_formula.installed_specified_name}'"
  ohai "python_formula_kext_prefix: '#{python_formula.kext_prefix}'"
  ohai "python_formula_latest_formula: '#{python_formula.latest_formula}'"
  ohai "python_formula_latest_head_prefix: '#{python_formula.latest_head_prefix}'"
  ohai "python_formula_latest_head_version: '#{python_formula.latest_head_version}'"
  ohai "python_formula_lib: '#{python_formula.lib}'"
  ohai "python_formula_lib_cellar: #{python_formula.lib_cellar}"
  ohai "python_formula_libexec: #{python_formula.libexec}"
  ohai "python_formula_license: #{python_formula.license}"
  ohai "python_formula_linked_version: #{python_formula.linked_version}"
  ohai "python_formula_livecheckable?: #{python_formula.livecheckable?}"
  ohai "python_formula_livecheck: #{python_formula.livecheck}"
  ohai "python_formula_livecheck_url: #{python_formula.livecheck.url}"
  # brew livecheck python@3.9
  ohai "python_formula_livecheck_regex: #{python_formula.livecheck.regex}"
  ohai "python_formula_livecheck_to_hash: #{python_formula.livecheck.to_hash}"
  python_formula_livecheck = python_formula.livecheck
  python_formula_livecheck.formula("python3.9")
  puts "python_formula_livecheck_to_hash: #{python_formula_livecheck.to_hash}"
  ohai "python_formula_livecheck_strategy_block: #{python_formula_livecheck.strategy_block}"
  ohai "python_formula_man: #{python_formula.man}"
  ohai "python_formula_man1: #{python_formula.man1}"
  ohai "python_formula_migration_needed?: #{python_formula.migration_needed?}"
  ohai "python_formula_new_formula_available?: #{python_formula.new_formula_available?}"
  ohai "python_formula_old_installed_formulae: #{python_formula.old_installed_formulae}"
  ohai "python_formula_oldname: #{python_formula.oldname}"
  ohai "python_formula_opt_bin: #{python_formula.opt_bin}"
  ohai "python_formula_opt_elisp: #{python_formula.opt_elisp}"
  ohai "python_formula_opt_frameworks: #{python_formula.opt_frameworks}"
  ohai "python_formula_opt_include: #{python_formula.opt_include}"
  ohai "python_formula_opt_lib: #{python_formula.opt_lib}"
  ohai "python_formula_opt_libexec: #{python_formula.opt_libexec}"
  ohai "python_formula_opt_pkgshare: #{python_formula.opt_pkgshare}"
  ohai "python_formula_opt_prefix: #{python_formula.opt_prefix}"
  ohai "{HOMEBREW_PREFIX}/opt/{python_formula.name}: \
    #{HOMEBREW_PREFIX}/opt/#{python_formula.name}"
  ohai "python_formula_opt_sbin: #{python_formula.opt_sbin}"
  ohai "python_formula_opt_share: #{python_formula.opt_share}"
  ohai "python_formula_optlinked?: #{python_formula.optlinked?}"
  puts "python_formula_paths: #{python_formula.paths}"
  ohai "python_formula_pkg_version: #{python_formula.pkg_version}"
  ohai "python_formula_pkgetc: #{python_formula.pkgetc}"
  ohai "python_formula_pkgshare: #{python_formula.pkgshare}"
  ohai "python_formula_plist: #{python_formula.plist}"
  ohai "python_formula_plist_name: #{python_formula.plist_name}"
  ohai "python_formula_plist_path: #{python_formula.plist_path}"
  ohai "python_formula_post_install: Error during install."
  ohai "python_formula_prefix: #{python_formula.prefix}"
  ohai "{HOMEBREW_PREFIX}/Cellar/{python_formula.name}/{python_formula.version}: \
    #{HOMEBREW_PREFIX}/Cellar/#{python_formula.name}/#{python_formula.version}"
  ohai "python_formula_prefix_linked?: #{python_formula.prefix_linked?}"
  ohai "python_formula_rack: '#{python_formula.rack}'"
  ohai "python_formula_resources: #{python_formula.resources}"
  ohai "python_formula_rpath: #{python_formula.rpath}"
  ohai "python_formula_runtime_installed_formula_dependents: #{python_formula.runtime_installed_formula_dependents}"
  ohai "python_formula_sbin: #{python_formula.sbin}"
  ohai "python_formula_service: #{python_formula.service}"
  ohai "python_formula_service?: #{python_formula.service?}"
  ohai "python_formula_service_name: #{python_formula.service_name}"
  ohai "python_formula_share: #{python_formula.share}"
  ohai "python_formula_specified_name: #{python_formula.specified_name}"
  ohai "python_formula_std_configure_args: #{python_formula.std_configure_args}"
  ohai "python_formula_std_go_args: #{python_formula.std_go_args}"
  ohai "python_formula_supersedes_an_installed_formula?: #{python_formula.supersedes_an_installed_formula?}"
  ohai "python_formula_systemd_service_path: #{python_formula.systemd_service_path}"
  ohai "python_formula_testpath: '#{python_formula.testpath}'"
  ohai "python_formula_time: #{python_formula.time}"
  ohai "python_formula_update_head_version: #{python_formula.update_head_version}"
  ohai "python_formula_var: #{python_formula.var}"
  ohai "python_formula_version: #{python_formula.version}"
  ohai "python_formula_version_major: '#{python_formula.version.major}'"
  ohai "python_formula_version_minor: '#{python_formula.version.minor}'"
  ohai "python_formula_version_major_minor: #{python_formula.version.major_minor}"
  ohai "python_formula_versioned_formula?: #{python_formula.versioned_formula?}"
  ohai "python_formula_versioned_formulae: #{python_formula.versioned_formulae}"

  opoo "============================================================================================================="
  opoo "Variables: HOMEBREW"
  ohai "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}"
  ohai "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}"
  ohai "HOMEBREW_REPOSITORY: #{HOMEBREW_REPOSITORY}"
  ohai "HOMEBREW_PREFIX/bin: #{HOMEBREW_PREFIX}/bin"
  ohai "HOMEBREW_PREFIX/lib: #{HOMEBREW_PREFIX}/lib"
  ohai "HOMEBREW_PREFIX/include: #{HOMEBREW_PREFIX}/include"

  opoo "============================================================================================================="
  opoo "Variables: versions"
  def test_method(a1 = "Ruby", a2 = "Perl")
    puts "The programming language is #{a1}"
    puts "The programming language is #{a2}"
  end

  def resource_func(_version, _resource, _versions)
    url_name = "https://www.python.org/ftp/python/#{_version}/#{_resource}.tar.xz"
    sha_value = `/usr/local/bin/wget --quiet -O - "#{url_name}" | /usr/local/bin/sha2 -q -256`.strip
    _versions[_version]["url"] = url_name
    _versions[_version]["sha"] = sha_value
    puts _versions[_version]["url"]
    puts _versions[_version]["sha"]
    #     return resource _resource do
    #       url = url_name
    #       sha = sha_value
    #     end
    return 'a'
  end

   my_versions_a = {}
  ["3.9.7"].each do |v|
    my_versions_a[v] = {}
    my_versions_a[v]["split"] = v.split(".")
    my_versions_a[v]["major_minor"] = "#{my_versions_a[v]["split"][0]}.#{my_versions_a[v]["split"][1]}"
    my_versions_a[v]["executable"] = "python#{my_versions_a[v]["major_minor"]}"
    my_versions_a[v]["resource"] = "Python-#{v}"
    url_name = "https://www.python.org/ftp/python/#{v}/#{my_versions_a[v]["resource"]}.tar.xz"
    my_versions_a[v]["url"] = url_name
    my_versions_a[v]["sha"] = `/usr/local/bin/wget --quiet -O - "#{url_name}" | /usr/local/bin/sha2 -q -256`.strip
    resource "Python-3.9.7" do
      url = url_name
      sha = my_versions_a[v]["sha"]
    end
  end
  puts "my_versions_a: #{my_versions_a}"
  ohai "my_versions_a_keys: #{my_versions_a.keys}"

  resource "Python-3.9.7" do
    url = my_versions_a["3.9.7"]["url"]
    sha = my_versions_a["3.9.7"]["sha"]
  end

  def my_versions
    rv = {}
    ["3.9.7"].each do |v|
      rv[v] = {}
      rv[v]["split"] = v.split(".")
      rv[v]["major_minor"] = "#{rv[v]["split"][0]}.#{rv[v]["split"][1]}"
      rv[v]["executable"] = "python#{rv[v]["major_minor"]}"
      rv[v]["resource"] = "Python-#{v}"
    end
    return rv
  end

  opoo "============================================================================================================="
  opoo "Variables: `Dir` points to: `Tap` before: `bin.install`"
  Dir["*"].each do |file|
    ohai "Dir (Tap) file: '#{file}'"
  end
  Dir["Formula/*"].each do |file|
    src = File.basename(file)                 #=> "ruby.rb"
    dest = File.basename(file, ".*")          #=> "ruby"
    ohai "Dir (Tap) Dir/Formula file: '#{file}', Dir (Tap) Dir/Formula src: '#{src}'"
    ohai "Dir (Tap) Dir/Formula dest: '#{dest}'"
  end

  opoo "============================================================================================================="
  opoo "Variables: `prefix` directory is empty before: `bin.install`"
  ohai "Dir: '#{Dir}', Dir.children(prefix): 'Error: No such file or directory @ dir_initialize - prefix'"
  ohai "pwd (`): '#{`pwd`}'"

  def install
    opoo "==========================================================================================================="
    opoo "Variables: When your code in the `install` function is run, \
     the current working directory is set to the extracted tarball. During `install`, `bin.install`, `prefix.install`"
    ohai "pwd: #{pwd}"
    ohai "prefix: #{prefix}"
    ohai "ls prefix: '#{`ls "#{prefix}"`}'"
    ohai "Dir (install): '#{Dir}', Dir.children(prefix): #{Dir.children(prefix)}"
    def config
      prefix/"config"
    end
    ohai "config: #{config}"
    prefix_config = prefix/"config"
    prefix_config.mkpath
    ohai "prefix_config: #{prefix_config}"
    ohai "Dir (install): '#{Dir}', Dir.children(prefix) after prefix/config.mkpath: #{Dir.children(prefix)}"
    ohai "Dir (install): '#{Dir}', Dir.children(prefix): #{Dir.children("#{prefix}")}"
    ohai "Dir (install): '#{Dir}', Dir.glob(prefix/*): #{Dir.glob("#{prefix}/*")}"
    opoo "==========================================================================================================="
    opoo "Variables: `buildpath` to loop over repository, before the `install` function"
    ohai "Dir.children(buildpath): '#{Dir.children(buildpath)}'"
    Dir["#{buildpath}/bin/*"].each do |file|
      src = "bin/#{File.basename(file)}"      #=> "bin/ruby.sh"
      dest = File.basename(file, ".*")        #=> "ruby"
      ohai "Dir (before install) buildpath/bin file: '#{file}', Dir (before install) buildpath/bin src: '#{src}'"
      ohai "Dir (before install) buildpath/bin dest: '#{dest}'"
    end

    ohai "Dir (install): '#{Dir}', Dir.children(prefix): '#{Dir.children(prefix)}'"
    Dir["*"].each do |file|
      ohai "Dir (install) file: '#{file}'"
    end
    Dir["output/*"].each do |file|
      ohai "Dir (install) Dir/output file: '#{file}'"
    end

    opoo "==========================================================================================================="
    opoo "Formula: Instance Attributes"
    ohai "active_log_prefix: '#{active_log_prefix}'"
    ohai "alias_name: '#{alias_name}'"
    ohai "alias_changed: '#{alias_changed?}'"
    ohai "alias_path: '#{alias_path}'"
    ohai "any_installed_prefix: '#{any_installed_prefix}'"
    ohai "any_installed_version: '#{any_installed_version}'"
    ohai "bash_completion: '#{bash_completion}'"
    ohai "bin: #{bin} == {prefix}/bin: #{prefix}/bin"
    ohai "bottle_hash: '#{bottle_hash}'"
    ohai "bottle_tab_attributes: '#{bottle_tab_attributes}'"
    ohai "buildpath: '#{buildpath}'"
    ohai "caveats: '#{caveats}'"
    ohai "current_installed_alias_target: '#{current_installed_alias_target}'"
    ohai "deprecated?: '#{deprecated?}'"
    ohai "deprecation_reason: '#{deprecation_reason}'"
    ohai "desc: '#{desc}'"
    ohai "disabled?: '#{disabled?}'"
    ohai "doc: '#{doc}'"
    ohai "etc: '#{etc}'"
    ohai "follow_installed_alias: '#{follow_installed_alias}'"
    ohai "full_alias_name: '#{full_alias_name}'"
    ohai "full_installed_alias_name: '#{full_installed_alias_name}'"
    ohai "full_installed_specified_name: '#{full_installed_specified_name}'"
    ohai "full_name: '#{full_name}'"
    ohai "homepage: '#{homepage}'"
    ohai "include: #{include}"
    ohai "info: '#{info}'"
    ohai "installed_alias_name: '#{installed_alias_name}'"
    ohai "installed_alias_path: '#{installed_alias_path}'"
    ohai "installed_alias_target_changed?: '#{installed_alias_target_changed?}'"
    ohai "installed_specified_name: '#{installed_specified_name}'"
    ohai "kext_prefix: '#{kext_prefix}'"
    ohai "latest_formula: '#{latest_formula}'"
    ohai "latest_head_prefix: '#{latest_head_prefix}'"
    ohai "latest_head_version: '#{latest_head_version}'"
    ohai "lib: '#{lib}'"
    def lib_cellar
      prefix/"lib/python#{version.major_minor}"
    end
    ohai "lib_cellar: #{lib_cellar}"
    ohai "libexec: #{libexec}"
    ohai "license: #{license}"
    ohai "linked_version: #{linked_version}"
    ohai "livecheckable?: #{livecheckable?}"
    ohai "livecheck: #{livecheck}"
    ohai "man: #{man}"
    ohai "man1: #{man1}"
    ohai "migration_needed?: #{migration_needed?}"
    ohai "missing_dependencies: #{missing_dependencies}"
    ohai "new_formula_available?: #{new_formula_available?}"
    ohai "old_installed_formulae: #{old_installed_formulae}"
    ohai "oldname: #{oldname}"
    ohai "opt_bin: #{opt_bin}"
    ohai "opt_elisp: #{opt_elisp}"
    ohai "opt_frameworks: #{opt_frameworks}"
    ohai "opt_include: #{opt_include}"
    ohai "opt_lib: #{opt_lib}"
    ohai "opt_libexec: #{opt_libexec}"
    ohai "opt_pkgshare: #{opt_pkgshare}"
    ohai "opt_prefix: #{opt_prefix} == {HOMEBREW_PREFIX}/opt/{name}: #{HOMEBREW_PREFIX}/opt/#{name}"
    ohai "opt_sbin: #{opt_sbin}"
    ohai "opt_share: #{opt_share}"
    ohai "optlinked?: #{optlinked?}"
    puts "paths: #{paths}"
    ohai "pkg_version: #{pkg_version}"
    ohai "pkgetc: #{pkgetc}"
    ohai "pkgshare: #{pkgshare}"
    ohai "plist: #{plist}"
    ohai "plist_name: #{plist_name}"
    ohai "plist_path: #{plist_path}"
    ohai "post_install: #{post_install}"
    ohai "prefix: #{prefix} == {HOMEBREW_PREFIX}/Cellar/{name}/{version}: #{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}"
    ohai "prefix_linked?: #{prefix_linked?}"
    ohai "rack: '#{rack}'"
    puts "resources: #{resources}"
    ohai "rpath: #{rpath}"
    ohai "runtime_installed_formula_dependents: #{runtime_installed_formula_dependents}"
    ohai "sbin: #{sbin}"
    ohai "service: #{service}"
    ohai "service?: #{service?}"
    ohai "service_name: #{service_name}"
    ohai "share: #{share}"
    puts "Formula['readline'].opt_lib}/{shared_library('libhistory')}: \
      '#{Formula["readline"].opt_lib}/#{shared_library("libhistory")}'"
    ohai "specified_name: #{specified_name}"
    ohai "std_configure_args: #{std_configure_args}"
    ohai "std_go_args: #{std_go_args}"
    ohai "supersedes_an_installed_formula?: #{supersedes_an_installed_formula?}"
    ohai "systemd_service_path: #{systemd_service_path}"
    ohai "testpath: '#{testpath}'"
    ohai "time: #{time}"
    ohai "to_s: #{self}"
    ohai "to_recursive_bottle_hash: #{to_recursive_bottle_hash}"
    ohai "update_head_version: #{update_head_version}"
    ohai "var: #{var}"
    ohai "version: #{version}"
    ohai "version_major: '#{version.major}'"
    ohai "version_minor: '#{version.minor}'"
    ohai "version_major_minor: #{version.major_minor}"
    ohai "versioned_formula?: #{versioned_formula?}"
    ohai "versioned_formulae: #{versioned_formulae}"

    opoo "==========================================================================================================="
    opoo "test_method"
    test_method "C", "C++"
    test_method

    opoo "==========================================================================================================="
    opoo "Resources: stage (uncompress) - before install or test : cwd is the uncompress of the resource"
    ohai "my_versions: #{my_versions}"
    func = resource_func '3.9.7', 'Python-3.9.7', my_versions
    func_return =
    ohai "func: #{func}"
    my_versions.each do |key, value|
      ohai "resource_func: #{resource_func '3.9.7', 'Python-3.9.7', my_versions}"
      func_return = resource_func '3.9.7', 'Python-3.9.7', my_versions
      ohai "key: #{key}, func_return: #{func_return}"
      ohai "value: #{value}"
      func = resource_func key, value["resource"], my_versions
      ohai "key: #{key}, func: #{func}"
    end

    resource("Python-3.9.7").stage do
      opoo "Resources: stage (uncompress) - before install or test : cwd is the uncompress of the resource"
      ohai "Resource stage pwd: #{pwd}"

      Dir["*"].each do |file|
        ohai "Dir (resource stage) file: '#{file}'"
      end
    end

    opoo "==========================================================================================================="
    opoo "Formula: Instance Method Details"
    ohai "active_log_prefix: '#{active_log_prefix}'"

    opoo "==========================================================================================================="
    resource("Python-3.9.7").stage do
      opoo "Resources: stage (uncompress) - install : cwd is the uncompress of the resource"
      ohai "Install resource stage pwd: #{pwd}"
      Dir["*"].each do |file|
        ohai "Dir (install resource stage) file: '#{file}'"
      end
    end
  end

  opoo "============================================================================================================="
  test do
    resource("Python-3.9.7").stage do
      opoo "Resources: stage (uncompress) - test : cwd is the uncompress of the resource"
      ohai "Test resource stage pwd: #{pwd}"
      Dir["*"].each do |file|
        ohai "Dir (test resource stage) file: '#{file}'"
      end
    end
  end
end
