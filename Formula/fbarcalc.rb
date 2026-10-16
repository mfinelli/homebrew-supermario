class Fbarcalc < Formula
  desc "Calculate the maximum account value"
  homepage "https://github.com/mfinelli/fbarcalc"
  url "https://github.com/mfinelli/fbarcalc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "32ccebb11ac8ec1c00a6696831427ad9d040229c736b70c85461625e60d81530"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/mfinelli/homebrew-supermario/releases/download/fbarcalc-1.0.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74665fb492a6e13b267e3677f3eba275b089712a334d291439b742c71a461eea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b6489ed4d1cecc5e8c0dbbb202902320be7ebf915c99e1478be4f083445bd0"
    sha256 cellar: :any,                 x86_64_linux:  "2a4562b153ce78920150c9951fa78041ffa26ace938495a0af3b713157933bcf"
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
