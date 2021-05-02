require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.55.1.tar.gz"
  sha256 "b8cbf769c8ed41c6e1dd74de78bf14ee7935ee436ee5ba018f742a48ee326f62"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.55.1"
    sha256 cellar: :any_skip_relocation, big_sur:  "e3995f20333c76153842de0538b9402670bfa4b1e2bfac2d30333340303fc184"
    sha256 cellar: :any_skip_relocation, catalina: "3723635e2a6232b41514848e5035d53ea9b3a2b99597676ae709e21ae8a0a5e0"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      "-tags", "cmount", *std_go_args
    man1.install "rclone.1" => "#{name}.1"
    system bin/name.to_s, "genautocomplete", "bash", "#{name}.bash"
    system bin/name.to_s, "genautocomplete", "zsh", "_#{name}"
    inreplace "#{name}.bash" do |s|
      s.gsub! "commands=(\"rclone\")", "commands=(\"#{name}\")"
      s.gsub! /(-F __start_rclone) rclone$/, "\\1 #{name}"
    end
    inreplace "_#{name}", /(#compdef _rclone) rclone$/, "\\1 #{name}"
    bash_completion.install "#{name}.bash" => name.to_s
    zsh_completion.install "_#{name}"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/name.to_s, "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
