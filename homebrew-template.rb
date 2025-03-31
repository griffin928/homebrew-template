class HomebrewTemplate < Formula
  # GitHub repository information
  GITHUB_USER = "griffin928"
  GITHUB_REPO = "homebrew-template"
  VERSION = "v1.0.22"

  desc "My personal CLI tool for daily automation"
  homepage "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}"
  url "#{homepage}/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"

  def install
    bin.install "template"
  end

  test do
    system "#{bin}/template"
  end
end
