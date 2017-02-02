class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams."
  homepage "https://www.justwatch.com/gopass"
  url "https://www.justwatch.com/gopass/releases/1.0.0/gopass-1.0.0.tar.gz"
  sha256 "781a4cddec5503aa99c551e6751af9bb7b561a60503b04590b34ab944f9daaae"
  head "https://github.com/justwatchcom/gopass.git"

  depends_on "go" => :build
  depends_on "gnupg2" => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/justwatchcom/gopass").install buildpath.children

    cd "src/github.com/justwatchcom/gopass" do
      ENV["PREFIX"] = prefix
      system "make", "install"
    end

    # system bin/"gopass completion bash > bash_completion.bash"
    # system bin/"gopass completion zsh > zsh_completion.zsh"
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

    assert_match version.to_s, shell_output("#{bin}/gopass version")
  end
end
