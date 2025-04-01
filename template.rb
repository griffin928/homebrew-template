class Template < Formula
  # GitHub repository information
  GITHUB_USER = "griffin928"
  GITHUB_REPO = "homebrew-template"
  VERSION = "v1.0.59"

  desc "My personal CLI tool for daily automation"
  homepage "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}"
  url "#{homepage}/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "3d8609125569bf23239d795631b3ec6ddc094a3ee698703dc6235696662aed38"
  license "MIT"

  def install
    bin.install "template"
  end

  test do
    system "#{bin}/template"
  end
end
