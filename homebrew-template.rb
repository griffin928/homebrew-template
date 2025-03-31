class HomebrewTemplate < Formula
  # GitHub repository information
  GITHUB_USER = "griffin928"
  GITHUB_REPO = "homebrew-template"
  VERSION = "v1.0.31"

  desc "My personal CLI tool for daily automation"
  homepage "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}"
  url "#{homepage}/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "f01a995d62b9274b0ca14f5f7f949d95d7625566e8d1a9f0c231b69a4814ed64"
  license "MIT"

  def install
    bin.install "template"
  end

  test do
    system "#{bin}/template"
  end
end
