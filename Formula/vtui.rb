class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.1/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "bd358b907fb5ca8d6711abbbde76fc3a0ce4950b5516cfb0b393c6dafd05e2e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.1/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "d4ff22a555e94261f5e1edd06f86622d1a82385d76b555985b4763a572ce9a86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.1/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a024ad7710600f25ddd7ec45d73dbba71dad577dd0c904c7d446334cfdfc041b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.1/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7f76b68d4c7c9bf16572fae12751a273f7ff5b0d137191edff556284036bc9e"
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
    bin.install "vtui" if OS.mac? && Hardware::CPU.arm?
    bin.install "vtui" if OS.mac? && Hardware::CPU.intel?
    bin.install "vtui" if OS.linux? && Hardware::CPU.arm?
    bin.install "vtui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
