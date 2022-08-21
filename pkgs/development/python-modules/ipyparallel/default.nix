{ lib
, buildPythonPackage
, fetchPypi
, nose
, python-dateutil
, ipython_genutils
, decorator
, pyzmq
, ipython
, jupyter-client
, ipykernel
, packaging
, psutil
, tornado
, tqdm
, hatchling
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "8.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Zwu+BXVTgXQuHqARd9xCj/jz6Urx8NVkLJ0Z83yoKJs=";
  };

  buildInputs = [ nose ];

  propagatedBuildInputs = [
    decorator
    hatchling
    ipykernel
    ipython
    ipython_genutils
    jupyter-client
    packaging
    psutil
    python-dateutil
    pyzmq
    tornado
    tqdm
  ];

  # Requires access to cluster
  doCheck = false;

  meta = {
    description = "Interactive Parallel Computing with IPython";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
