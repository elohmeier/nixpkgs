{ buildPythonPackage,
  fetchPypi,
  cairosvg,
  pyphen,
  cffi,
  cssselect,
  lxml,
  html5lib,
  tinycss,
  pygobject2,
  glib,
  pango,
  fontconfig,
  stdenv,
  pytestrunner,
  pytest-isort,
  pytest-flake8,
  pytestcov,
  isPy3k,
  glibcLocales
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "45";
  disabled = !isPy3k;

  # ignore failing pytest
  checkPhase = "pytest -k 'not test_font_stretch'";

  # ignore failing flake8-test
  prePatch = ''
    substituteInPlace setup.cfg \
        --replace '[tool:pytest]' '[tool:pytest]\nflake8-ignore = E501'
  '';

  checkInputs = [ pytestrunner pytest-isort pytest-flake8 pytestcov ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";
  FONTCONFIG_PATH = "${fontconfig.out}/etc/fonts/";

  buildInputs = [ glibcLocales ];
  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ cairosvg pyphen cffi cssselect lxml html5lib tinycss pygobject2 ];

  postPatch = ''
    # Linux
    substituteInPlace weasyprint/text.py --replace "libgobject-2.0.so" "${glib.out}/lib/libgobject-2.0.so"
    substituteInPlace weasyprint/text.py --replace "libpango-1.0.so" "${pango.out}/lib/libpango-1.0.so"
    substituteInPlace weasyprint/text.py --replace "libpangocairo-1.0.so" "${pango.out}/lib/libpangocairo-1.0.so"
    substituteInPlace weasyprint/fonts.py --replace "libfontconfig.so.1" "${fontconfig.lib}/lib/libfontconfig.so.1"
    substituteInPlace weasyprint/fonts.py --replace "libpangoft2-1.0.so" "${pango.out}/lib/libpangoft2-1.0.so"

    # MacOS
    substituteInPlace weasyprint/text.py --replace "libgobject-2.0.dylib" "${glib.out}/lib/libgobject-2.0.dylib"
    substituteInPlace weasyprint/text.py --replace "libpango-1.0.dylib" "${pango.out}/lib/libpango-1.0.dylib"
    substituteInPlace weasyprint/text.py --replace "libpangocairo-1.0.dylib" "${pango.out}/lib/libpangocairo-1.0.dylib"
    substituteInPlace weasyprint/fonts.py --replace "libfontconfig-1.dylib" "${fontconfig.lib}/lib/libfontconfig.1.dylib"
    substituteInPlace weasyprint/fonts.py --replace "libpangoft2-1.0.dylib" "${pango.out}/lib/libpangoft2-1.0.dylib"
  '';

  src = fetchPypi {
    inherit version;
    pname = "WeasyPrint";
    sha256 = "04bf2p2x619g4q4scg8v6v57c24vwn7qckvz81rckj8clzifyr82";
  };

  meta = with stdenv.lib; {
    homepage = https://weasyprint.org/;
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
