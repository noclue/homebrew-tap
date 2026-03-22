class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.2/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "b515764524a99e753ed7522ce598e0b0e4de7327791d5efb0531d5a693d653cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.2/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "645c0491855a47abdc62ff7bf98af32ab44094f7d187dc919cb42fbd78c9dcb8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.2/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61c7182cee5ca96551055811a9f9bc94ccb9fc4c40a6b1e41fd48f8a7914e7b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.2/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef7098478672cfbcacddda086f410811b4ad2e8443b4470a8610885bd1c32a3f"
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
