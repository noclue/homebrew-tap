class Vtui < Formula
  desc "Terminal UI for browsing VMware vSphere inventory"
  homepage "https://github.com/noclue/vtui"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.8/vtui-aarch64-apple-darwin.tar.xz"
      sha256 "6fdd188ddb4300556018262868d392ac9737954b4eece7fd96cbd2c44edb840b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.8/vtui-x86_64-apple-darwin.tar.xz"
      sha256 "1da3bc85f398c48fc7011e5a53b589feac7c5fccceec561907318f9498617cb1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noclue/vtui/releases/download/v0.2.8/vtui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b45d0fe240a1fbb1c2c8cf66cc21ff80e72dffa71aafec01232203d298d68467"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noclue/vtui/releases/download/v0.2.8/vtui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d32b850b3fc7de666c328a9fdeb6a5d315c2f024bbe7c1219b58da50ec5db880"
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
