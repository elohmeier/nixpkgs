{ lib, buildPythonPackage, fetchFromGitHub, 
  aiohttp, flake8, jinja2, pytest, pytest-aiohttp, pyyaml }:

buildPythonPackage rec {
  pname = "aiohttp-swagger";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "cr0hn";
    repo = pname;
    rev = "5a59e86"; # corresponds to 1.0.5 on PyPi, no tag on GitHub
    sha256 = "1vpfk5b3f7s9qzr2q48g776f39xzqppjwm57scfzqqmbldkk5nv7";
  };

  propagatedBuildInputs = [ aiohttp jinja2 pyyaml ];

  checkInputs = [ flake8 pytest pytest-aiohttp ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Swagger API Documentation builder for aiohttp";
    homepage = https://github.com/cr0hn/aiohttp-swagger;
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
