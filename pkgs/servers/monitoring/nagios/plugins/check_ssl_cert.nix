{ lib
, stdenv
, bc
, bind # host and dig binary
, coreutils # date and timeout binary
, curl
, fetchFromGitHub
, file
, iproute2
, makeWrapper
, netcat-gnu
, nmap
, openssl
, python3
, which
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
  version = "2.77.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "refs/tags/v${version}";
    hash = "sha256-xU/1Bs3uIFomy6w2Vf50O3VbwoGfJMng88J1NXfg1pQ=";
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
      --prefix PATH : "${lib.makeBinPath ([ openssl file which curl bc coreutils bind nmap netcat-gnu python3 ] ++ lib.optional stdenv.isLinux iproute2) }"
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
