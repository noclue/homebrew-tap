class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.9/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "70115bab0510dc9f1a5cf478a70a072242e822a79143d571f2c0821f32d76ef0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.9/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "9740eb9a6b92d2d91b56057d50c6df5b9f172b24c36967edc89ed490fe538725"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.9/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "35ecdcd5edef722fdf587a50d085d39210a06ad4f6f980b725a30fbcb00b998e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.9/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9d7b482ac4e67d597754e8123904a184b9dccea0ab0f47bbb07156afc848284f"
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
