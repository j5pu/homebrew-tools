cask "fonts" do
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"

  url "https://github.com/j5pu/fonts/archive/refs/tags/v0.1.0.tar.gz"
  name "Tools Fonts"
  homepage "https://github.com/j5pu/fonts"

  for f in Dir["Fonts/*"] do
    font f
  end
end
