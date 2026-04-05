class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.4/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "a93c2cc7149427f19210ac9a64c7f70266c16e3eb8cd3f6872e4be90d89e5c90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.4/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "c74939985889f3b26617dae36d86b80592f5003fecb497fd2a35dd614098d91d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.4/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f8239db02ecb3644a774e0720f7a975ad69c1dfb54b484d3ebbdfe32d6e3177"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.4/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2f3ded3f9620e761839631887acfc7736695fc842e1360b358d120d1891b005"
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
