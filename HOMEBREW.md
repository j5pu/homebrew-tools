# HomeBrew

## [Tap/Bottles to GitHub releases](https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/)

### Create a GitHub repository, i.e., `critic` `hombrew-critic`

```bash
brew tap-new j5pu/tools
cd $(brew --repository j5pu/tools)
git remote add origin https://github.com/j5pu/homebrew-tools
git push --set-upstream origin main
```

Two workflow files created by default, see also 
[yandex-go](https://github.com/msoap/yandex-weather-cli/blob/master/.github/workflows/go.yml), 
[yandex-rebase](https://github.com/msoap/yandex-weather-cli/tree/master/.github/workflows),
[tap-release](https://github.com/apps/tap-release) and [GitVersion](https://gitversion.net/docs/usage/) 
for automatic version:
1.  `tests.yml`: run on each pull_request event, so every push to a PR’s branch triggers the workflow,
which tests changes made to formulae, 
builds bottles for those formulae and uploads them to GitHub Actions as artifacts.
2. `publish.yml`: run when a pull request is labelled, 
is responsible for bottle uploading and publishing.

### Creating formula, edit, audit and test.
All formulae should go in the `Formula` directory.

#### URL with tags
````bash
url="https://github.com/j5pu/critic/archive/refs/tags/v0.1.0.tar.gz"
brew create --tap=j5pu/tools "${url/ref\/tags\//}"  # creates a Formula/critic.rb
````

#### URL with No tags
Creates a Formula/critic.rb.
````bash
repo="https://github.com/Checksum/critic.sh"
commit="$( git ls-remote "${repo}" HEAD | awk '{print $1}' )" # get revision
url="${repo}/archive/${commit}.tar.gz"
sha256="$( wget --quiet -O - "${tar}" | sha256sum  | awk '{print $1}' )"
brew create --tap=j5pu/tools --set-name critic "${url}"
````

or

```ruby
class Critic < Formula
  desc "Dead simple testing framework for Bash with coverage reporting"
  homepage "https://github.com/Checksum/critic.sh"
  url <== "${url}"
  sha256 <== "${sha256}"
  version_scheme 1
  license "MIT"

  depends_on "bash"

  def install
    bin.install "critic.sh" => "critic"
  end

  test do
    system "true"
  end
end

```

* Edit: `brew edit j5pu/critic/critic`
* Audit: `brew audit --quiet --new critic`
* Test: `/usr/local/bin/brew install --quiet j5pu/tools/critic; brew test --quiet critic`

### Branch, add formula, commit and push.
````bash
git checkout -b fork
git add Formula/critic.rb
git commit --message "critic 0.1.0 (new formula)"
git push --set-upstream origin fork
````

### Trigger workflows.
To trigger the workflows, created a pull request.

```bash
export GH_CONFIG_DIR=$HOME/data/config/git
source $HOME/data/config/.gitattributes
gh loguser  # gh auth login --with-token <<< $GITHUB_USER_TOKEN
gh prfill  # gh pr create --fill --label pr_pull
open https://github.com/j5pu/homebrew-critic/pull/2  # check status
# Fix error
gh pr close 2

git add --all
git commit --message "fix quotes true"
git push --set-upstream origin fork
open https://github.com/j5pu/homebrew-critic/pull/3  # check status
# First run tests.yml
# Second run publish.yml (did not do the merge probably because was a formula !!)
```

### Install.

```bash
brew tap j5pu/critic
brew install critic
```

### Test new Tap Release
[j5pu/critic/.github/workflows/tap-release.yml](https://github.com/j5pu/critic/tree/main/.github/workflows/tap-release.yml)
```yaml
asset: critic.zip
tap: j5pu/homebrew-critic/critic.rb
template: |
  class App < Formula
    desc     "$REPO_DESCRIPTION"
    homepage "$REPO_WEBSITE"
    version  "$STABLE_VERSION"
    url      "$STABLE_ASSET_URL"
    sha256   "$STABLE_ASSET_SHA256"

      depends_on "bash"

      def install
        bin.install "critic.sh" => "critic"
      end

      test do
        `#{bin}/critic`
      end
    end
```

Make a new release and push, check that tap is updated.


## Tips

### Depends
```ruby
depends_on "bash"
depends_on "go" => :build
depends_on "cmake" => :build
```
### Install with different name

````ruby
def install
  bin.install "critic.sh" => "critic"
end
````

### System Command with args

````ruby
def install 
  # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
  system "./configure", *std_configure_args, "--disable-silent-rules"
end
````

### Test

```ruby
test do 
    # `test do` will create, run in and delete a temporary directory. 
    # 
    # This test will fail and we won't accept that! For Homebrew/homebrew-core 
    # this will need to be a test that verifies the functionality of the 
    # software. Run the test with `brew test critic`. Options passed 
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`. 
    # 
  system "true"
end
```

```ruby
test do
    ENV.delete "GITHUB_TOKEN"
    assert_match "no Github token found", shell_output(bin/"gothanks", 255)
end
```

## [Doppler](https://dashboard.doppler.com/workplace/c1b6617234eb28e014bd/projects/default/configs/default)

```bash
doppler --silent --configuration $(brew prefix)/etc/doppler.yml login
doppler --silent --configuration $(brew prefix)/etc/doppler.yml setup
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets --json
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets --only-names --json
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets --raw --json
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets --raw --no-read-env --json
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets get GITHUB_WORK_TOKEN --json
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets upload secrets.sh
```
A secret `D="${C}"` cannot reference another secret `C="${A}_${B}"` which references other secrets `A="hola";B="adios"`.


### [jq]
```bash
doppler --configuration /config/doppler/doppler.yml --silent secrets --json | \
  jq -r '. | to_entries[]  | "export \(.key)='\''\(.value.computed)'\''"'
```

### [Templating](https://pkg.go.dev/text/template)
```yaml
{{/* Comments won't be shown in the output. */}}
bind: {{.DOPPLER_CONFIG}}
port: {{.DOPPLER_ENVIRONMENT}}
{{/* The `logfile` field will only be shown if the GITHUB_ORG_TOKEN secret is defined */}}
{{with .GITHUB_ORG_TOKEN}}
logfile: {{.}}
{{end}}
access:
  user: {{.GITHUB_USER_TOKEN}}
  password: {{.GITHUB_WORK_TOKEN}}
```

```bash
doppler --silent --configuration $(brew prefix)/etc/doppler.yml secrets substitute template.yml --output out.yml
```

```yaml

bind: default
port: default


logfile: ...

access:
  user: ...
  password: ...
```

### [Parsing with json and from json multiline or add dicts to yaml](https://docs.doppler.com/docs/secret-injection-with-templates)
```text
┌─────────────────────┬──────────────────────────────────────────────────────────────────┐
│ NAME                │ VALUE                                                            │
├─────────────────────┼──────────────────────────────────────────────────────────────────┤
│ ACCESS              │ {"user": "admin", "password": "uRJ5WhRmSZF4dgkk82Kp"}            │
│ PRIVATE_KEY         │ -----BEGIN RSA PRIVATE KEY-----                                  │
│                     │ MIIJJwIBAAKCAgEAww6PISGwwCRj125/5CNQ5kntc/NdjA7EKmNPY1wol/8ZSgrl │
│                     │ H2Egpj7GghDCsJfoJ7gQu3OtYQJ2j1/txGP44tzZh/lraMQblFqc9r9N8xXU3Y6z │
│                     │ ...                                                              │
│                     │ -----END RSA PRIVATE KEY-----                                    │
│                     │                                                                  │
└─────────────────────┴──────────────────────────────────────────────────────────────────┘
```

```yaml
private_key: {{tojson .PRIVATE_KEY}}
{{with fromjson .ACCESS}}
access:
  user: {{.user}}
  password: {{.password}}
{{end}}
```

```bash
$ dopler secrets substitute example.txt
private_key: "-----BEGIN RSA PRIVATE KEY-----\r\nMIIJJwIBAAKCAgEAww6PISGwwCRj125/5CNQ5knt..."
access:
  user: admin
  password: uRJ5WhRmSZF4dgkk82Kp
````

## Ruby 

### Path & Install

* `Dir` points to: `Tap` before: `bin.install`.
````ruby
Dir["Formula/*"].each do |file|
  src = File.basename(file)                 #=> "ruby.rb"
  dest = File.basename(file, ".*")          #=> "ruby"
  ohai "file: '#{file}', src: '#{src}', dest: '#{dest}'"
end
````

* `prefix` directory is empty before: `bin.install`.
````ruby
opoo Dir.children(prefix)  # prefix = /usr/local/Cellar/critic/8238
````

* When your code in the `install` function is run, the current working directory is set to the extracted tarball.
During `bin.install`, `prefix.install` or
[variables-for-directory-locations](https://docs.brew.sh/Formula-Cookbook#variables-for-directory-locations.

````ruby
prefix.install Dir["output/*"]
prefix.install "file1", "file2"
bin.install "foo.py" => "foo"
````

* `buildpath` to loop over repository, before the `install` function.
````ruby
opoo Dir.children(buildpath)
Dir["#{buildpath}/bin/*"].each do |file|
  src = "bin/#{File.basename(file)}"      #=> "bin/ruby.sh"
  dest = File.basename(file, ".*")        #=> "ruby"
  ohai "file: '#{file}', src: '#{src}', dest: '#{dest}'"
  bin.install src => dest
end
````

## See also

### GitHub Actions and Apps
  * [Tap Release](https://github.com/toolmantim/tap-release) - Automatically update Homebrew taps when you publish 
  new releases to GitHub. Built with Probot.
  * [GitHub MarketPlace Homebrew Actions](https://github.com/marketplace?type=actions&query=Homebrew+)
  * [Doppler](https://github.com/marketplace/doppler-secrets-manager) - Doppler is the single source of truth 
  for your secrets. 
  * [Homebrew Releaser](https://github.com/marketplace/actions/homebrew-releaser) - Release scripts, binaries, and 
  executables directly to Homebrew via GitHub Actions (creates the formula).
  * [Homebrew bump formula](https://github.com/marketplace/actions/homebrew-bump-formula) - Homebrew bump formula 
  GitHub Action (updates the formula).

### Taps
  * [github.com/egilsster/git-releaser tap](https://github.com/egilsster/homebrew-git-releaser) 
  * [yandex-weather-cli Makefile](https://github.com/msoap/yandex-weather-cli/blob/master/README.md) - Man page 
  from README.
  * [msoap tools](https://github.com/msoap/homebrew-tools)
  * [mongodb](https://github.com/mongodb/homebrew-brew)
  * [getoptions](https://github.com/ko1nksm/homebrew-getoptions)
  * [pet](https://github.com/knqyf263/homebrew-pet)
  * [ssh-askpass](https://github.com/theseal/homebrew-ssh-askpass)
  * [hostctl](https://github.com/guumaster/homebrew-tap)
  * [ghorg](https://github.com/gabrie30/homebrew-utils)
  * [homebrew-bundle](https://github.com/Homebrew/homebrew-bundle)
  * [homebrew-cask](https://github.com/Homebrew/homebrew-cask)
  * [homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts)
  * [homebrew-cask-versions](https://github.com/Homebrew/homebrew-cask-versions)
  * [homebrew-core](https://github.com/Homebrew/homebrew-core)
  * [linuxbrew-core](https://github.com/Homebrew/linuxbrew-core)
  * [mas tap](https://github.com/mas-cli/mas)
  * [homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts)

### [Formulas](https://github.com/Homebrew/homebrew-core/tree/master/Formula)
  * [Large Example Formula](https://github.com/syhw/homebrew/blob/master/Library/Contributions/example-formula.rb)
  * [fzf](https://github.com/Homebrew/homebrew-core/blob/master/Formula/fzf.rb)
  * [bash](https://github.com/Homebrew/homebrew-core/blob/master/Formula/bash.rb)
  * [bash-completion@2](https://github.com/Homebrew/homebrew-core/blob/master/Formula/bash-completion%402.rb)
  
### [Brew Docs](https://docs.brew.sh/)
  * [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
  * [Ruby Brew Formula](https://rubydoc.brew.sh/Formula)
  * [Taps](https://docs.brew.sh/Taps)
  * [Brew FAQ](https://docs.brew.sh/FAQ)
  * [External Commands](https://docs.brew.sh/External-Commands)
  * [tap-uploaded-to-github-releases](https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/)
  * [Homebrew/actions](https://github.com/Homebrew/actions) - Homebrew's GitHub Actions.
