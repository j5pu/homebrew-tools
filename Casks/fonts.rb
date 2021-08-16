cask "fonts" do
  sha256 "c79b2b9ae8da431134b214f96c6a3b2c2598a3cc5a8db7764a3c789c683dc767"

  url "https://github.com/j5pu/fonts/archive/refs/tags/v0.1.0.tar.gz"
  name "Tools Fonts"
  homepage "https://github.com/j5pu/fonts"

  for f in Dir["Fonts/*"] do
    font f
  end

  test do
    for f in Dir["Fonts/*"] do
        system "test", "-f", "#{caskroom_path}/fonts/"f
    end
  end
end
