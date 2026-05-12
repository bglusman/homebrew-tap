class Calciforge < Formula
  desc "Agent and model gateway with routing, secrets, and security policy sidecars"
  homepage "https://github.com/bglusman/calciforge"
  license "MIT"

  depends_on "fnox"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bglusman/calciforge/releases/download/v0.1.0-rc.1/calciforge-0.1.0-rc.1-aarch64-apple-darwin.tar.gz"
      sha256 "0928be09ca5e04e0aab1b32e8fd07ec9064b579df7fb0f0bf2c38577bc19c78b"
    else
      url "https://github.com/bglusman/calciforge/releases/download/v0.1.0-rc.1/calciforge-0.1.0-rc.1-x86_64-apple-darwin.tar.gz"
      sha256 "8a39f382db5670d22eedd26f264e65971b40a0b1873ae69f6f1dd44f434a506b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/bglusman/calciforge/releases/download/v0.1.0-rc.1/calciforge-0.1.0-rc.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1c281705907c5b483f111fa524089fe3561d94e77d738ae0b37c6c01fa9b06f6"
    else
      odie "Calciforge does not publish a Linux ARM Homebrew binary yet"
    end
  end

  def install
    bin.install Dir["bin/*"].reject { |path| File.basename(path) == "fnox" }
    prefix.install "LICENSE"
    prefix.install "THIRD_PARTY_NOTICES.txt"
    prefix.install "README.txt"
  end

  def post_install
    (etc/"calciforge").mkpath
    (var/"lib/calciforge").mkpath
    (var/"log/calciforge").mkpath
  end

  service do
    run [opt_bin/"calciforge", "--config", etc/"calciforge/config.toml"]
    keep_alive true
    environment_variables PATH: "#{opt_bin}:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    working_dir var/"lib/calciforge"
    log_path var/"log/calciforge/calciforge.log"
    error_log_path var/"log/calciforge/calciforge.log"
  end

  def caveats
    <<~EOS
      Homebrew can supervise Calciforge after you provide a config at:
        #{etc}/calciforge/config.toml

      Start it with:
        brew services start calciforge

      This formula also depends on Homebrew's fnox package for Calciforge
      secret helpers.

      The managed config, certificate, and agent wiring flow still lives in
      the source-tree installer. For that path, clone the repository and run:
        git clone https://github.com/bglusman/calciforge
        cd calciforge
        bash scripts/install.sh

      Use the formula when you already have config or want a native supervisor
      for released binaries. Use the installer when Calciforge should discover
      and wire local or remote agents for you.
    EOS
  end

  test do
    system bin/"calciforge", "--version"
    system bin/"calciforge-secrets", "help"
    %w[security-proxy clashd mcp-server paste-server].each do |binary|
      assert_predicate bin/binary, :executable?
    end
  end
end
