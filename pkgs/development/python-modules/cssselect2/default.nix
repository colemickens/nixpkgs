{ lib, buildPythonPackage, fetchFromGitHub, tinycss2, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "cssselect2";
    rev = "${version}";
    sha256 = "04hswa61h1dyaj0lsmvasj9h1zjsrmg6i7k4ki2ssh35lyf9m489";
  };

  # We're not interested in code quality tests
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-cov" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" ""
    substituteInPlace setup.cfg \
      --replace "--flake8" "" \
      --replace "--isort" ""
  '';

  propagatedBuildInputs = [ tinycss2 ];
  checkInputs = [ pytest pytestrunner ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    license = licenses.bsd3;
  };
}
