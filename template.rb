class Template < Formula
  # GitHub repository information
  GITHUB_USER = "griffin928"
  GITHUB_REPO = "homebrew-template"
  VERSION = "v1.0.53"

  desc "My personal CLI tool for daily automation"
  homepage "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}"
  url "#{homepage}/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "c0bf3b4746627bd6ec9ff30ad3f39ebb64cc7499d63dc2f6905da3c33b442162"
  license "MIT"

  def install
    bin.install "template"
  end

  test do
    system "#{bin}/template"
  end
end
