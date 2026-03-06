class Vtui < Formula
  desc "Terminal UI for browsing VMware vCenter inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.0/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "988015c75ed158bdc5202f0d336e2544b63a643daa08a47065544561d7232322"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.0/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "dd3060793a58c0481e62c5164b01c13cb76dd50b148e483c6d571488a23ae199"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.0/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5a8bf40d6cd721fcfb15de8c0dcc8a260902848b0e62666740bef1412c43d13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.0/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bc10c8e687864b9795677564a25211df196ff4b56525f8090e0cfccbdcd4f0b"
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
