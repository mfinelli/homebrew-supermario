class Ipsort < Formula
  desc "Versitile ip address sorting tool"
  homepage "https://ipsort.dev"
  url "https://github.com/mfinelli/ipsort/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8b1b702bbf0f26de2c9cc56d77f9ba9b3e9a59b01a19e4070e366da73e377464"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/mfinelli/homebrew-supermario/releases/download/ipsort-1.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e394449d14fe3c49020a67a8cbf4e9292bf2ab5370bd4d15436e1b47d9ad5838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822c9979d3b8f3e6902f371ebf4639ae220ae8655629bba1d7523994e44e3d4f"
    sha256 cellar: :any,                 x86_64_linux:  "bfc2b1764fcb4307f10e5b192afe8acc56e4c63b0cfb8bc7f6b17ea320ca2c45"
  end

  depends_on "rust" => :build
  depends_on "scdoc" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"ipsort", "--generate-completions")

    system "make", "target/release/ipsort.1"
    man1.install "target/release/ipsort.1"
  end

  test do
    output = shell_output("#{bin}/ipsort ipsort 10.30.0.0/16 10.4.0.0/16")
    assert_match "10.4.0.0/16\n10.30.0.0/16", output

    assert_match version.to_s, shell_output("#{bin}/ipsort -V")
  end
end
