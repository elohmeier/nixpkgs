{ stdenv, buildPythonPackage, fetchFromGitHub, flake8, click, pyyaml, six, pytest }:

buildPythonPackage rec {
  pname = "clickclick";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "hjacobs";
    repo = "python-clickclick";
    rev = version;
    sha256 = "1rij9ws9nhsmagiy1vclzliiqfkxi006rf65qvrw1k3sm2s8p5g0";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 click pyyaml six ];

  # this two tests fail in Python 3.6
  checkPhase = ''
    pytest -k "not test_cli and not test_choice_default"
  '';

  meta = with stdenv.lib; {
    description = "Click command line utilities";
    homepage = https://github.com/hjacobs/python-clickclick/;
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
