{ lib, buildPythonPackage, fetchFromGitHub, pytest, zeep, aiohttp }:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "hunterjm";
    repo = "python-onvif-zeep-async";
    rev = "v${version}";
    sha256 = "1r3j67sm0xj803sylrj9x80lfgnc23ipbdaz6dqg2c16aqzmaji8";
  };

  propagatedBuildInputs = [ zeep aiohttp ];
  pythonImportCheck = [ "onvif" ];

  meta = with lib; {
    homepage = "https://github.com/hunterjm/python-onvif-zeep-async";
    description =
      "ONVIF Client Implementation in Python 2+3 (using https://github.com/mvantellingen/python-zeep instead of suds as SOAP client)";
    license = licenses.mit;
  };
}
