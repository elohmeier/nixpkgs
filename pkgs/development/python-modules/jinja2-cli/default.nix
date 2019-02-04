{ lib, buildPythonPackage, fetchFromGitHub, pyyaml, toml, xmltodict, jinja2, pytest, flake8 }:

buildPythonPackage rec {
  pname = "jinja2-cli";
  version = "0.7.0.dev0";

  src = fetchFromGitHub {
    owner = "mattrobenolt";
    repo = pname;
    rev = "a2d99e3";
    sha256 = "0qnv7j129001kay9phqa673flhv9k283zv4xk2yaa349fimkv4xa";
  };

  checkInputs = [ pytest flake8 ];
  propagatedBuildInputs = [ jinja2 pyyaml toml xmltodict ];
  checkPhase = "pytest";

  meta = with lib; {
    description = "A CLI interface to Jinja2";
    homepage = https://github.com/mattrobenolt/jinja2-cli;
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
