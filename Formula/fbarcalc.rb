class Fbarcalc < Formula
  desc "Calculate the maximum account value"
  homepage "https://github.com/mfinelli/fbarcalc"
  url "https://github.com/mfinelli/fbarcalc/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "19881491d5812da31e9a88733a384d1546bfda3aa61b6160d72a14dd22926bef"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/mfinelli/homebrew-supermario/releases/download/fbarcalc-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c3f28694e5fda59582fbeaa6514007c203c62bccd39ef9e41d145159444be44f"
    sha256 cellar: :any,                 x86_64_linux: "9a9cd06bfe363545d23f97f0ffba1772ec2a18b4b7b515e57a8a552e73724e7e"
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
