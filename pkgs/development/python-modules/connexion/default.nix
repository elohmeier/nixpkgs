{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, glibcLocales
, lib
, pythonOlder

, aiohttp
, aiohttp-swagger
, aiohttp-jinja2
, clickclick
, decorator
, flake8
, flask
, gevent
, inflection
, jsonschema
, mock
, openapi-spec-validator
, pathlib
, pytest
, pytest-aiohttp
, pytestcov
, pyyaml
, requests
, six
, swagger-ui-bundle
, testfixtures
, typing
, ujson }:

buildPythonPackage rec {
  pname = "connexion";
  version = "2.2.0";

  # we're fetching from GitHub because tests weren't distributed on PyPi
  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = version;
    sha256 = "1psbql502xa7g8q4m7mpqpdicyb2kffgq9wvrq9jr7ld22k2m282";
  };

  buildInputs = lib.optional (pythonOlder "3.7") glibcLocales;
  checkInputs = [ 
    decorator
    mock
    pytest
    pytestcov
    testfixtures
    flask
    swagger-ui-bundle
  ] ++ lib.optionals isPy3k [ aiohttp aiohttp-jinja2 aiohttp-swagger ujson pytest-aiohttp ];
  propagatedBuildInputs = [
    clickclick
    jsonschema
    pyyaml
    requests
    six
    inflection
    openapi-spec-validator
    swagger-ui-bundle
    flask
  ]
  ++ lib.optional (pythonOlder "3.4") pathlib
  ++ lib.optional (pythonOlder "3.6") typing
  ++ lib.optionals isPy3k [ aiohttp aiohttp-jinja2 aiohttp-swagger ujson ];

  preConfigure = lib.optional (pythonOlder "3.7") ''
    export LANG=en_US.UTF-8
  '';

  checkPhase = if isPy3k then "pytest -k 'not test_app_get_root_path'"
                         else "pytest --ignore=tests/aiohttp";

  meta = with lib; {
    description = "Swagger/OpenAPI First framework on top of Flask";
    homepage = https://github.com/zalando/connexion/;
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
