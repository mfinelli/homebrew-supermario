class Recueil < Formula
  desc "Self-hosted webpage bookmarker and archiver"
  homepage "https://recueil.app"
  url "https://github.com/mfinelli/recueil.git",
    tag:      "v1.0.1",
    revision: "322dc0fc6765e5f891441726c1bf755da7653255"
  license "AGPL-3.0-or-later"
  head "https://github.com/mfinelli/recueil.git", branch: "master"

  depends_on "go" => :build
  depends_on "jq" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "sqlc" => :build

  deny_network_access!

  def fetch
    system "git", "submodule", "update", "--init"
    system "pnpm", "fetch"
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "pnpm", "install", "--offline", "--frozen-lockfile"

    readability= Utils.safe_popen_read("jq", "-r", ".version",
      "node_modules/@mozilla/readability/package.json").strip

    ldflags = %W[
      -X main.commit=#{Utils.git_short_head}
      -X main.date=#{time.iso8601}
      -X main.version=#{version}
      -X main.readabilityVersion=#{readability}
    ]

    system "pnpm", "run", "paraglide:compile"
    system "pnpm", "run", "build"
    system "sqlc", "generate"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"recueil", shell_parameter_format: :cobra)
    man1.install "recueil.1"
  end

  test do
    output = shell_output("#{bin}/recueil enqueue https://example.com 2>&1", 1)
    assert_match "Error: not paired with a Worker yet", output

    assert_match version.to_s, shell_output("#{bin}/recueil --version")
  end
end
