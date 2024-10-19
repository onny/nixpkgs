{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-cms";
  version = "4.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "django_cms";
    hash = "sha256-I62u9oxI45um93zYx3CnH78em8tXLqZt0ucb6O94vQ0=";
  };

  propagatedBuildInputs = [ django ];

  pythonImportCheck = [ "django-cms" ];

  meta = {
    description = "Django application to retrieve user's IP address";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/django-cms/blob/develop-4/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
