class Template < Formula
  # GitHub repository information
  GITHUB_USER = "griffin928"
  GITHUB_REPO = "homebrew-template"
  VERSION = "v1.0.58"

  desc "My personal CLI tool for daily automation"
  homepage "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}"
  url "#{homepage}/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "3607ae5c613e432522080340d5834f50eeccef69a9feaa0222592e9953ac6d84"
  license "MIT"

  def install
    bin.install "template"
  end

  test do
    system "#{bin}/template"
  end
end
