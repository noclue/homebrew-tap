class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.10/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "811742592e9b21c08348d6f5f4896a09a9d8f1408749690f1a75c4d596924a96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.10/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "c5d8ead51bb64998a1e8fb59b77eef8af4442c656c4e31d25e10af671c7593d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.10/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9912f6ac667d21ab24699e2533a0273af5243e21ea65a330b5825bd704a1708"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.10/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "111c0b77c6f80432ce5df89c09718935b1a2aff923cc18c7ad22479dfbea9fa5"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vtui"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vtui"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vtui"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vtui"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
