class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.7/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "f12fdbf0309ac0b04105a9c36b9de99a430128f2bdf8f38be6d119aa408d6837"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.7/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "8d5d9e3585a95f35ec4252c2150e1d5ba67b52d7b54a333e9c04694ec9baea58"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.7/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d50c8e13bd0e8fd4d135b9cb0ced015e7c82d2f9427a4417c7b4c8d58842677c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.7/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32b9bdc8420c0cf17dfac4c16fbb17f5dcbd8e419fe255d74f5cbff8a30be1ae"
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
