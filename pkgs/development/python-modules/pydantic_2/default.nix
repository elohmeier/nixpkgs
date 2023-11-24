{ lib
, buildPythonPackage
, fetchFromGitHub
, callPackage
, hatch-fancy-pypi-readme
, hatchling
, annotated-types
, pydantic-core
, typing-extensions
, email-validator
, pythonOlder
, pytestCheckHook
, cloudpickle
, dirty-equals
, pytest-examples
, pytest-mock
, faker
,
}:
buildPythonPackage rec {
  pname = "pydantic";
  version = "2.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "v${version}";
    hash = "sha256-D0gYcyrKVVDhBgV9sCVTkGq/kFmIoT9l0i5bRM1qxzM=";
  };

  patches = [
    ./01-remove-benchmark-flags.patch
  ];

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    annotated-types
    pydantic-core
    typing-extensions
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  pythonImportsCheck = [ "pydantic" ];

  nativeCheckInputs = [
    cloudpickle
    dirty-equals
    faker
    pytest-examples
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  meta = with lib; {
    description = "Data validation using Python type hints";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
