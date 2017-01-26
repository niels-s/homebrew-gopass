class Gopass < Formula
  desc "Password manager"
  homepage "https://www.justwatch.com/gopass"
  url "http://central.int.justwatch.com/tarballs/gopass-v1.0.0rc2-ae9a4505aff48ebf2caf70e82b7565e7bc1c4369.tar.gz"
  sha256 "ccd97976634c89c0478366848f7f49c7d9ff616298043fe216a077a4a42d728c"
  head "https://github.com/justwatchcom/gopass.git"

  depends_on "go" => :build
  depends_on "pwgen" => :run
  depends_on "gpg" => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/jus.tw.cx/gopass").install buildpath.children
    cd("src/jus.tw.cx/gopass") { system "go", "build", "-o", bin/"gopass" }

    # elisp.install "contrib/emacs/password-store.el"
    # pkgshare.install "contrib"
    # zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    # bash_completion.install "src/completion/pass.bash-completion" => "password-store"
    # fish_completion.install "src/completion/pass.fish-completion" => "pass.fish"
  end

  test do
    Gpg.create_test_key(testpath)
    system bin/"gopass", "init", "Testing"
    system bin/"gopass", "generate", "Email/testing@foo.bar", "15"
    assert File.exist?(".password-store/Email/testing@foo.bar.gpg")
  end
end
