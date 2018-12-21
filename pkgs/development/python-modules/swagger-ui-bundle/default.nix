{ stdenv, buildPythonPackage, fetchPypi, jinja2, flake8 }:

buildPythonPackage rec {
  pname = "swagger-ui-bundle";
  version = "0.0.2";

  src = fetchPypi {
    pname = "swagger_ui_bundle";
    inherit version;
    sha256 = "0kk6y8p1fhmnjnxfafdw6dm1xc5wj8101y5h7hcy3rb2bxc1i94q";
  };

  nativeBuildInputs = [ flake8 ];
  propagatedBuildInputs = [ jinja2 ];

  # package contains no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "bundled swagger-ui pip package";
    homepage = https://github.com/dtkav/swagger_ui_bundle;
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
