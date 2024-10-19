{
  python3,
  fetchFromGitHub,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "froide-govplan";
  version = "1";

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide-govplan";
    rev = "eb0908dea9ecc64b23ca8a2bc550fcb1a400e3f1";
    hash = "sha256-4lBxIvNRr7/Jf2fV8Aaz9plOOK0tArIzyUfHDZTuE9c=";
  };

  pyproject = true;

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3.pkgs; [
    bleach
    django-admin-sortable2
    django-cms
    django-filer
    django-mfa3
    django-oauth-toolkit
    django-tinymce
    psycopg
    #froide
  ];

  postInstall = ''
    cp manage.py $out/${python3.sitePackages}/froide_govplan/
    cp -r project $out/${python3.sitePackages}/froide_govplan/
    makeWrapper $out/${python3.sitePackages}/froide_govplan/manage.py $out/bin/froide-govplan \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';
}
