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
  isPy3k
}:

buildPythonPackage rec {
  pname = "WeasyPrint";
  version = "45";
  disabled = !isPy3k;

  doCheck = false;
  propagatedBuildInputs = [ cairosvg pyphen cffi cssselect lxml html5lib tinycss pygobject2 pytestrunner ];

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
    inherit pname version;
    sha256 = "04bf2p2x619g4q4scg8v6v57c24vwn7qckvz81rckj8clzifyr82";
  };

  meta = with stdenv.lib; {
    homepage = https://weasyprint.org/;
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
