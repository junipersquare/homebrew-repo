class PreCommit < Formula
  include Language::Python::Virtualenv

  version "2.20.4"
  url "https://github.com/teeeg/pre-commit/archive/refs/tags/v2.20.4.tar.gz"
  sha256 "53a1298d8755d9aa98c63a8298f6ed260439e5bcca424394a8db810da8dac6d9"
  head "https://github.com/teeeg/pre-commit.git", branch: "main"
    
  bottle do
    root_url "https://github.com/junipersquare/homebrew-repo"
    rebuild 2
    sha256 cellar: :any, arm64_monterey: "2fee906cdaf6d5aef4294493e5a9c5429e5ad2fd0a285d0fbfa024815c67088d"
  end

  depends_on "libyaml"
  depends_on "python@3.10"
  depends_on "six"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f3/c7/5c1aef87f1197d2134a096c0264890969213c9cbfb8a4102087e8d758b5c/filelock-3.7.1.tar.gz"
    sha256 "3a0fd85166ad9dbab54c9aec96737b744106dc5f15c0b09a6744a445299fcf04"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e5/8e/408d590e26fbc75a2e974aa1103d95a3ffef014209967f66f491306c4824/identify-2.5.1.tar.gz"
    sha256 "3d11b16f3fe19f52039fb7e39c9c884b21cb1b586988114fbe42671f03de3e82"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/f3/9d/a28ecbd1721cd6c0ea65da6bfb2771d31c5d7e32d916a8f643b062530af3/nodeenv-1.7.0.tar.gz"
    sha256 "e0e7f7dfb85fc5394c6fe1e8fa98131a2473e04311a45afb6508f7cf1836fa2b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/2f/05b77cb73501c01963de2cef343839f0803b64aab4d5476771ae303b97a6/virtualenv-20.15.1.tar.gz"
    sha256 "288171134a2ff3bfb1a2f54f119e77cd1b81c29fc1265a2356f3e8d14c7d58c4"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/python3\")}\\n'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
