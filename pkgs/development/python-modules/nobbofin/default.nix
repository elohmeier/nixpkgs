{ lib, buildPythonPackage, fetchPypi, fints, beancount }:

buildPythonPackage rec {
  pname = "nobbofin-tools";
  version = "0.1.5";

  src = fetchPypi {
    pname = pname;
    version = version;
    sha256 = "1wi44vmghwjzwc5c2xz3bgjyricxs7j1whyw6c8vvlhdz8b74fxw";
  };

  doCheck = false;
  propagatedBuildInputs = [ fints beancount ];
  checkPhase = "pytest";

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier ];
  };
}
