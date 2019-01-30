{ stdenv, buildPythonPackage, fetchFromGitHub, jsonschema, pyyaml, six, pytest }:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = version;
    sha256 = "1s5b09qy8ijafd4c0hkchkf7jr268gq1s0mal9g3vbfx0shqk5kf";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ jsonschema pyyaml six ];

  checkPhase = ''
    pytest
  '';

  # tests fail because of unresolvable network requests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "validates OpenAPI specs against the OpenAPI 2.0/3.0 specification";
    homepage = https://github.com/p1c2u/openapi-spec-validator/;
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
