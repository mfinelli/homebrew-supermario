class Fbarcalc < Formula
  desc "Calculate the maximum account value"
  homepage "https://github.com/mfinelli/fbarcalc"
  url "https://github.com/mfinelli/fbarcalc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "32ccebb11ac8ec1c00a6696831427ad9d040229c736b70c85461625e60d81530"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/mfinelli/homebrew-supermario/releases/download/fbarcalc-1.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7043cee31639b3894ea69392486d147939139508b576ec9ca5d752d8b5b391d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5e5b9f4f910e67aa63df02d903919b4f48659351ac4d436f6e33735ce59faf"
    sha256 cellar: :any,                 x86_64_linux:  "0e81d4e9f23eb3d59cd3163bdd9220599d6a38b7393ec244f38a2b25df38b29b"
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
