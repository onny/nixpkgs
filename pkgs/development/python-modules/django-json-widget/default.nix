{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-json-widget";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rbTKsX/loEE5A319hHJTaVMO81uRLDeQ06exP5k1E1g=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  checkInputs = [ pytestCheckHook ];

  pythonImportCheck = [ "django_json_widget" ];

  meta = {
    description = "Alternative widget that makes it easy to edit the jsonfield field of django";
    homepage = "https://github.com/jmrivas86/django-json-widget";
    changelog = "https://github.com/jmrivas86/django-json-widget/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
