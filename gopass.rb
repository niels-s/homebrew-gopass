class Gopass < Formula
  desc "Password manager"
  # homepage "https://gopass.justwatch.com/"
  url "http://central.int.justwatch.com/tarballs/gopass-develop-93ceffed0d11896161835130e8ec9c272abe7350.tar.gz"
  sha256 "f1f3b25918dff876986f93313b569132ac004fde445e3438d1b560c8004da018"
  # head "https://github.com/justwatchcom/gopass"

  depends_on "pwgen"
  depends_on "tree"
  depends_on "go"
  depends_on :gpg => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd("src/github.com/tools/godep") { system "go", "build", "-o", bin/"godep" }

    # elisp.install "contrib/emacs/password-store.el"
    # pkgshare.install "contrib"
    # zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    # bash_completion.install "src/completion/pass.bash-completion" => "password-store"
    # fish_completion.install "src/completion/pass.fish-completion" => "pass.fish"
  end

  test do
    Gpg.create_test_key(testpath)
    system bin/"pass", "init", "Testing"
    system bin/"pass", "generate", "Email/testing@foo.bar", "15"
    assert File.exist?(".password-store/Email/testing@foo.bar.gpg")
  end
end
