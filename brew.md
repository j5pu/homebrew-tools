# brew

## [Tap/Bottles to GitHub releases](https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/)

### Create a GitHub repository, i.e., `critic` `hombrew-critic`

```bash
brew tap-new j5pu/critic
cd $(brew --repository j5pu/critic)
git remote add origin https://github.com/j5pu/homebrew-critic
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

````bash
https://github.com/psampaz/gothanks/archive/v0.3.0.tar.gz
url="https://github.com/j5pu/critic/archive/refs/tags/v0.1.0.tar.gz"
brew create --tap=j5pu/critic "${url/ref\/tags\//}"  # creates a Formula/critic.rb
````

* Edit: `brew edit j5pu/critic/critic`
* Audit: `brew audit --quiet --new critic`
* Test: `/usr/local/bin/brew install --quiet j5pu/critic/critic; brew test --quiet critic`

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
        system "true"
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


## See also

### Releaser
  * [github.com/egilsster/git-releaser](https://github.com/egilsster/git-releaser) - A CLI tool to that creates 
  a git tag, a changelog and a git release, all in one command.
  * [GitVersion](https://gitversion.net/docs/usage/) - From git log to SemVer in no time.

### Brew Releaser
  * [Tap Release](https://github.com/toolmantim/tap-release) - Automatically update Homebrew taps when you publish 
  new releases to GitHub. Built with Probot.

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
````bash
git clone https://github.com/Homebrew/homebrew-core.git; cd homebrew-core/Formula
git clone https://github.com/Homebrew/linuxbrew-core.git; cd linuxbrew-core/Formula
````
  `git clone https://github.com/Homebrew/homebrew-core.git; cd homebrew-core/Formula`
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

### How-To
  * [create-custom-github-action](https://www.philschmid.de/create-custom-github-action-in-4-steps)
  * [Automate your build & release](https://faun.pub/automate-your-build-release-with-github-actions-367c0febf5fd)
  * [Automating PyPI releases](https://www.caktusgroup.com/blog/2021/02/11/automating-pypi-releases/)
  * [Publishing PyPI package distribution](https://packaging.python.org/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/)
  * [Setting up python-semantic-release](https://python-semantic-release.readthedocs.io/en/latest/automatic-releases/github-actions.html)
  * [PyPI publish GitHub Action](https://github.com/pypa/gh-action-pypi-publish)
  * [Automate your build & release](https://faun.pub/automate-your-build-release-with-github-actions-367c0febf5fd)

### Actions
  * [critic.sh - Bash Test](https://github.com/Checksum/critic.sh/blob/master/.github/workflows/main.yml)

### GitHub
  * [gh pr](https://cli.github.com/manual/gh_pr_create) - gh pr create.
  * [Authentication in a workflow](https://docs.github.com/en/actions/reference/authentication-in-a-workflow)
  * [Encrypted secrets](https://docs.github.com/en/actions/reference/encrypted-secrets)
  * [Introduction to GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions)
