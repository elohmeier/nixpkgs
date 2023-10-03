{ lib
, stdenv
, bc
, bind # host binary
, coreutils # date and timeout binary
, curl
, dig
, fetchFromGitHub
, file
, gawk
, glibc # getconf binary
, iproute2
, makeWrapper
, netcat-gnu
, nettools # hostname binary
, nmap
, openssl
, python3
, which
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
  version = "2.69.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "refs/tags/v${version}";
    hash = "sha256-85bm/CvD5Kp9HKpf9czkqSEDYwmm8W+zd/uc88fWzPQ=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  makeFlags = [
    "DESTDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
  ];

  postInstall = ''
    wrapProgram $out/bin/check_ssl_cert \
      --prefix PATH : "${lib.makeBinPath ([ gawk dig openssl file which curl bc coreutils bind.host nettools nmap netcat-gnu python3 ] ++ lib.optionals stdenv.isLinux [ glibc iproute2 ]) }"
  '';

  meta = with lib; {
    description = "Nagios plugin to check the CA and validity of an X.509 certificate";
    homepage = "https://github.com/matteocorti/check_ssl_cert";
    changelog = "https://github.com/matteocorti/check_ssl_cert/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
