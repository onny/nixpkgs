{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  django-classy-tags,
  django-formtools,
  django-treebeard,
  django-sekizai,
}:

buildPythonPackage rec {
  pname = "djangocms-admin-style";
  version = "3.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2iDeODHxoadN4z/hK704ZaACepgoeMAqodECsceZ12c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-classy-tags
    django-formtools
    django-treebeard
    django-sekizai
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  checkInputs = [ pytestCheckHook ];

  pythonImportCheck = [ "django-cms" ];

  meta = {
    description = "Lean enterprise content management powered by Django";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/django-cms/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
