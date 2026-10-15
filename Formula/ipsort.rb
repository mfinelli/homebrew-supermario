class Ipsort < Formula
  desc "Versitile ip address sorting tool"
  homepage "https://ipsort.dev"
  url "https://github.com/mfinelli/ipsort/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8b1b702bbf0f26de2c9cc56d77f9ba9b3e9a59b01a19e4070e366da73e377464"
  license "GPL-3.0-or-later"

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
