class Fbarcalc < Formula
  desc "Calculate the maximum account value"
  homepage "https://github.com/mfinelli/fbarcalc"
  url "https://github.com/mfinelli/fbarcalc/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "19881491d5812da31e9a88733a384d1546bfda3aa61b6160d72a14dd22926bef"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/mfinelli/homebrew-supermario/releases/download/fbarcalc-1.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9366227dc579fc54f56ec449df0dce2012cbbda98e91adad5c8430bdb0f062d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "758b965c91fb892c354acf92f29824a2986fa3ece528987b7ce93658063606de"
    sha256 cellar: :any,                 x86_64_linux:  "35e66a1422c71220922d652d7961d5c610521d6bb4ab7b8bce6c3522a09eddc7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "fbarcalc.1"
  end

  test do
    output = shell_output("#{bin}/fbarcalc --config none.toml 2>&1", 1)
    assert_match "no such file, run `fbarcalc config` to create it", output

    assert_match version.to_s, shell_output("#{bin}/fbarcalc -V")
  end
end
