class Gopass < Formula
  desc "Password manager"
  homepage "https://www.justwatch.com/gopass"
  url "http://central.int.justwatch.com/tarballs/gopass-v1.0.0rc2-ae9a4505aff48ebf2caf70e82b7565e7bc1c4369.tar.gz"
  sha256 "ccd97976634c89c0478366848f7f49c7d9ff616298043fe216a077a4a42d728c"
  head "https://github.com/justwatchcom/gopass.git"

  depends_on "go" => :build
  depends_on "gnupg2" => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/jus.tw.cx/gopass").install buildpath.children

    cd "src/jus.tw.cx/gopass" do
      # system "make", "install"
      system "go", "build", "-o", bin/"gopass"
    end

    system bin/"gopass completion bash > bash_completion.bash"
    system bin/"gopass completion zsh > zsh_completion.zsh"
    bash_completion.install "bash_completion.bash"
    zsh_completion.install "zsh_completion.zsh"

  end

  def caveats; <<-EOS.undent
    Gopass has been installed, have fun!

    If upgrading from `pass`, everything should work as expected.

    If installing from scratch, you need to either initialize a new repository now...
      gopass init

    ...or clone one from a source:
      gopass clone git@code.example.com:example/pass.git

    In order to use the great autocompletion features (they're helpful with gopass),
    please make sure you have autocompletion for homebrew enabled:
      https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion

    More information:
      https://www.justwatch.com/gopass
      https://github.com/justwatchcom/gopass/README.md
    EOS
  end

  test do
    # TODO: make this work, is currently stuck
    #
    # Gpg.create_test_key(testpath)
    # system bin/"gopass", "init", "Testing"
    # system bin/"gopass", "generate", "Email/testing@foo.bar", "15"
    # assert File.exist?(".password-store/Email/testing@foo.bar.gpg")

    assert_match version.to_s, shell_output("#{bin}/gopass --version")
  end
end
