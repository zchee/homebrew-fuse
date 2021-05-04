require_relative "../require/macfuse"

class IfuseMac < Formula
  desc "FUSE module for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.4.tar.gz"
  sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"
  license "LGPL-2.1-or-later"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/ifuse-mac-1.1.4"
    sha256 cellar: :any, big_sur:  "f6c2e432e98e35ea512c85e9eed06015e157477c58ccc3209fc915401a4a3bdc"
    sha256 cellar: :any, catalina: "bafcd207118ffb63fcb67ce909f52bde7dc2fa138a592be30e6d7cdb96580377"
    sha256 cellar: :any, mojave:   "5c2d874a7377fa5c91bad47e7ee82adb4d965e3019fbf4b5128c318549f66180"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end