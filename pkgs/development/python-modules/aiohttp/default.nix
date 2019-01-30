{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, chardet
, multidict
, async-timeout
, yarl
, idna-ssl
, typing-extensions
, pytestrunner
, pytest
, gunicorn
, pytest-timeout
, async_generator
, pytest_xdist
, pytestcov
, pytest-mock
, trustme
, brotlipy
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wq7pzqdrpss7xs7k580hssgx7rix79sclnyikyndxhb595p85f1";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [
    pytestrunner pytest gunicorn pytest-timeout async_generator pytest_xdist
    pytest-mock pytestcov trustme brotlipy
  ];

  propagatedBuildInputs = [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optionals (pythonOlder "3.7") [ idna-ssl typing-extensions ];

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/aio-libs/aiohttp;
    maintainers = with maintainers; [ dotlambda ];
  };
}
