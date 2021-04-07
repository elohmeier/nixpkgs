{ buildPythonPackage
, fetchPypi
, cairosvg
, pyphen
, cffi
, cssselect
, lxml
, html5lib
, tinycss
, pygobject2
, glib
, pango
, fontconfig
, lib
, stdenv
, pytestCheckHook
, pytestrunner
, pytest-isort
, pytest-flake8
, pytestcov
, isPy3k
, substituteAll
}:

# TODO: add AHEM: https://github.com/Kozea/Ahem
# https://www.w3.org/Style/CSS/Test/Fonts/Ahem/

buildPythonPackage rec {
  pname = "weasyprint";
  version = "52.4";
  disabled = !isPy3k;

  disabledTests = [
    "test_font_stretch" # test needs the Ahem font
    "test_shrink_to_fit_floating_point_error_1"
    "test_shrink_to_fit_floating_point_error_2"
  ];

  # ignore failing flake8-test
  prePatch = ''
    substituteInPlace setup.cfg \
        --replace '[tool:pytest]' '[tool:pytest]\nflake8-ignore = E501'
  '';

  checkInputs = [ pytestCheckHook pytestrunner pytest-isort pytest-flake8 pytestcov ];

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ahem];
  };

  propagatedBuildInputs = [ cairosvg pyphen cffi cssselect lxml html5lib tinycss pygobject2 ];

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangoft2 = "${pango.out}/lib/libpangoft2-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      gobject = "${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pango = "${pango.out}/lib/libpango-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangocairo = "${pango.out}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  src = fetchPypi {
    inherit version;
    pname = "WeasyPrint";
    sha256 = "sha256-i2SNNbHoKM4yEHj+WT75Jnw1KAJC/Y9nPJH0jkF6Sl8=";
  };

  meta = with lib; {
    homepage = "https://weasyprint.org/";
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
