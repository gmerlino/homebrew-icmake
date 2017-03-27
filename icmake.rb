class Icmake < Formula
  desc "Make utility using a C-line grammar"
  homepage "https://fbb-git.github.io/icmake/"
  url "https://github.com/fbb-git/icmake/archive/8.01.00.tar.gz"
  head 'git://github.com/fbb-git/icmake.git'
  sha256 "d77304994fb07cf437f7fbe6ff5a0fd72b42a2bccab81f398f056245cea48dcc"
  revision 1

  depends_on "gnu-sed"

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["findutils"].libexec/"gnubin"

    # override the existing file
    (buildpath/"icmake/INSTALL.im").open("w") do |f|
      f.write <<-EOS.undent
        #define BINDIR      "#{bin}"
        #define SKELDIR     "#{pkgshare}"
        #define MANDIR      "#{man}"
        // not a typo; the install script puts binaries under LIBDIR/
        #define LIBDIR      "#{bin}"
        #define CONFDIR     "#{etc}"
        #define DOCDIR      "#{doc}"
        #define DOCDOCDIR   "#{doc}"
      EOS
    end

    cd "icmake" do
      system "./icm_prepare", "/"
      system "./icm_bootstrap", "/"
      system "./icm_install", "all", "/"
    end
  end

  test do
    (testpath/"script.im").write <<-EOS.undent
      string TEST;

      void main() {
        TEST = "foobar";
      }
    EOS
    system "#{bin}/icmake", "script.im", (testpath/"test")
  end
end
