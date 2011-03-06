require 'formula'

class Cmigemo <Formula
  url 'http://www.kaoriya.net/dist/var/cmigemo-1.3c.tar.bz2'
  homepage 'http://www.kaoriya.net/#CMIGEMO'
  md5 '0b9d2feff4cfdc673cc1947fe54191ed'

  depends_on 'nkf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make osx"
    system "make osx-dict"
    Dir.chdir('dict') do
      system "make utf-8"
    end
    system "make osx-install"
  end
end

__END__

# vim: set nowrap tabstop=2 tw=0 sw=2 expandtab
